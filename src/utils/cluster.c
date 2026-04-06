#include <stdio.h>
#include <stdlib.h>
#include "utils.h"

#define NOISE (-1)

typedef struct {
    uint64_t val;
    int idx;
} Pair;

static int cmp_pair(const void *a, const void *b) {
    const Pair *pa = (const Pair*)a;
    const Pair *pb = (const Pair*)b;
    if (pa->val < pb->val) return -1;
    if (pa->val > pb->val) return 1;
    return 0;
}

static void set_all_int(int *arr, int n, int v) {
    for (int i = 0; i < n; ++i) arr[i] = v;
}


int dbscan_1d(uint64_t *x, int n, uint64_t eps, int minPts, int *labels) {
    if (!x || !labels || n <= 0 || eps < 0.0 || minPts <= 1) {
        if (labels && n > 0) set_all_int(labels, n, NOISE);
        return 0;
    }

    // 1) Sort while preserving original indices
    Pair *arr = (Pair*)malloc(sizeof(Pair) * n);
    if (!arr) { set_all_int(labels, n, NOISE); return 0; }
    for (int i = 0; i < n; ++i) { arr[i].val = x[i]; arr[i].idx = i; }
    qsort(arr, n, sizeof(Pair), cmp_pair);

    // 2) Precompute neighborhood boundaries for each point
    //    Using two pointers to find [L[i], R[i]] such that:
    //    arr[L..R] satisfies |arr[k].val - arr[i].val| <= eps
    int *L = (int*)malloc(sizeof(int) * n);
    int *R = (int*)malloc(sizeof(int) * n);
    if (!L || !R) {
        free(arr);
        if (L) free(L);
        if (R) free(R);
        set_all_int(labels, n, NOISE);
        return 0;
    }

    int left = 0, right = 0;
    for (int i = 0; i < n; ++i) {
        uint64_t v = arr[i].val;
        while (left < n && v - arr[left].val > eps) left++;          // arr[left] >= v - eps
        if (right < i) right = i;
        while (right < n && arr[right].val - v <= eps) right++;      // arr[right-1] <= v + eps
        L[i] = left;
        R[i] = right - 1;   // inclusive right boundary
    }

    // 3) DBSCAN main process (performed in sorted index space)
    // labels_s corresponds to arr[i]; later mapped back to original indices
    int *labels_s = (int*)malloc(sizeof(int) * n);
    int *visited   = (int*)malloc(sizeof(int) * n);
    if (!labels_s || !visited) {
        free(arr); free(L); free(R);
        if (labels_s) free(labels_s);
        if (visited) free(visited);
        set_all_int(labels, n, NOISE);
        return 0;
    }
    for (int i = 0; i < n; ++i) { labels_s[i] = NOISE; visited[i] = 0; }

    // Simple queue for cluster expansion (max size n)
    int *queue = (int*)malloc(sizeof(int) * n);
    if (!queue) {
        free(arr); free(L); free(R); free(labels_s); free(visited);
        set_all_int(labels, n, NOISE);
        return 0;
    }

    int cluster_id = 0;

    for (int i = 0; i < n; ++i) {
        if (visited[i]) continue;
        visited[i] = 1;

        int left_i = L[i], right_i = R[i];
        int neighbor_count = right_i - left_i + 1;

        if (neighbor_count < minPts) {
            // Mark as noise (may later become a border point)
            labels_s[i] = NOISE;
            continue;
        }

        // Create a new cluster
        int front = 0, back = 0;
        labels_s[i] = cluster_id;

        // Push all neighbors of i into the queue
        for (int k = left_i; k <= right_i; ++k) {
            if (labels_s[k] == NOISE) labels_s[k] = cluster_id; // noise becomes border point
            if (!visited[k]) {
                queue[back++] = k;
                visited[k] = 1;  // avoid duplicate enqueue
            }
        }

        // Cluster expansion (BFS)
        while (front < back) {
            int j = queue[front++];
            int left_j = L[j], right_j = R[j];
            int count_j = right_j - left_j + 1;

            // If j is a core point, expand its neighbors
            if (count_j >= minPts) {
                for (int k = left_j; k <= right_j; ++k) {
                    if (labels_s[k] == NOISE) labels_s[k] = cluster_id;
                    if (!visited[k]) {
                        queue[back++] = k;
                        visited[k] = 1;
                    }
                }
            }

            // Ensure j is assigned to current cluster
            if (labels_s[j] == NOISE) labels_s[j] = cluster_id;
            if (labels_s[j] < 0)      labels_s[j] = cluster_id;
        }

        cluster_id++;
    }

    // 4) Map labels back to original order
    for (int i = 0; i < n; ++i) labels[i] = NOISE;
    for (int i = 0; i < n; ++i) {
        int orig = arr[i].idx;
        labels[orig] = labels_s[i];
    }

    free(arr); free(L); free(R); free(labels_s); free(visited); free(queue);
    return cluster_id;
}