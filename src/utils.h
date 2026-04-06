#include <stdint.h>

/**
 * @brief 1D DBSCAN clustering algorithm
 *
 * Performs DBSCAN clustering on a 1D array of uint64_t values.
 * The algorithm sorts the input while preserving original indices,
 * computes neighborhood ranges using a two-pointer technique,
 * and expands clusters using a queue-based BFS approach.
 *
 * @param x        Input array of values (size n)
 * @param n        Number of elements in the input array
 * @param eps      Neighborhood radius (maximum distance)
 * @param minPts   Minimum number of points required to form a core point
 * @param labels   Output array of cluster labels (size n)
 *                 - Each element will be assigned a cluster ID
 *                 - NOISE(-1) indicates noise points
 *
 * @return int     Number of clusters
 */
int dbscan_1d(uint64_t *x, int n, uint64_t eps, int minPts, int *labels);

/**
 * @brief Convert a virtual address to its physical address
 * 
 * Get physical address. Not support for non-Linux kernel.
 * 
 * @param path_buf  A string that holds the PID of current process
 * @param virt_addr Virtual address
 * 
 * @return          Physical address of virt_addr
 */
uint64_t virt_to_phys(char* path_buf, unsigned long virt_addr);