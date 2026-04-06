#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/mman.h>

#include "config.h"
#include "utils.h"
#include "org_config.h"

#if defined(__APPLE__) && ARCH==3
#include <pthread.h>
    void bindcore(int core) {
        if (core >= 4) {
            fprintf(stderr, "Bind to P core on macOS\n");
            pthread_set_qos_class_self_np(QOS_CLASS_USER_INTERACTIVE, 0);
        } else {
            fprintf(stderr, "Bind to E core on macOS\n");
            pthread_set_qos_class_self_np(QOS_CLASS_BACKGROUND, 0);
        }
    }
#elif defined(__linux__)
#include <sched.h>
    void bindcore(int core) {
        cpu_set_t mask;
        CPU_ZERO(&mask);
        CPU_SET(core, &mask);
        sched_setaffinity(0, sizeof(mask), &mask);
    }
#else

#endif

extern uint64_t stld(uint64_t* store_addrs, uint64_t* load_addrs, 
    uint64_t* func_addrs, uint64_t func_len, 
    uint64_t* timing, uint64_t* store_selector);

/**
 * @brief Analyze timing data and count BLK cases.
 *
 * @param time   Pointer to the timing array (uint64_t values)
 * @param len    Total length of the timing array
 *
 * @return       Number of values in the second half of the array that exceed
 *               the maximum value of the non-noisy cluster in the first half
 */
int state_analysie(uint64_t* time, int len) {
    int label[len];
    int num_of_cluster = dbscan_1d(time, len / 2, cluster_range, len / 4, label);
    // Get maxinum value from non-noisy samples
    int ssb_max = 0;
    for(int i = 1; i < len / 2; ++ i) {
        if (label[i] != -1 && time[i] > ssb_max) {
            ssb_max = time[i];
        }
    }

    int blk_cnt = 0;
    for(int i = len / 2; i < len; ++ i) {
        if (time[i] > ssb_max + 5) {
            blk_cnt += 1;
        }
    }
    // for(int i = 0; i < len; ++ i) {
    //     printf("%ld ", time[i]);
    // }
    // printf("%d ", ssb_max);
    // printf("%d\n", blk_cnt);
    return blk_cnt;
}

int prime_operation[100];
uint64_t st[409600], ld[409600];
uint64_t time_samples[409600];
int prime_operation_num, cpu, base = ALIAS_OFFSET;  // Experiment config
int expected_mdp_val = 0, is_store_mdp = 0; // Learn from state machine analysis
int ld_size, hash_size;
uint64_t ld_jmp_offset[ld_jmp_offset_num];
uint64_t ld_hash[ld_jmp_offset_num];
char* ptr;

#define INDEX_BIT_RATE  0.2

/**
 * @brief Test whether the store-load pair with ID ld_prob_id is evicted by elements in exp_seq.
 *
 * @param exp_seq        Store-load pairs with different PCs
 * @param exp_seq_len    Number of elements in exp_seq
 * @param flush_seq      Store-load pairs used for initializing the MDP state
 * @param flush_seq_len  Number of elements in flush_seq
 * @param ld_prob_id     The store-load pair to be tested
 * 
 * @return               Whether the store-load pair with ID ld_prob_id is evicted
 */
int stld_experiment(int* exp_seq, int exp_seq_len, int* flush_seq, int flush_seq_len, int ld_prob_id) {
    // Prepare offsets for indirect jump to target load
    uint64_t ld_jmp_exp[409600];
    uint64_t st_jmp_exp[409600];
    int cnt = 0;
    for(int i = cnt; i < cnt + SIZE_SAMPLE_ORG / 2; i ++) {
        ld[i] = (uint64_t)ptr + base;
        ld_jmp_exp[i] = ld_jmp_offset[ld_prob_id];       
        st_jmp_exp[i] = st_jmp_offset[0];
    }
    cnt += SIZE_SAMPLE_ORG / 2;

    for(int i = 0; i < flush_seq_len; i ++) {
        for(int j = 0; j < prime_operation_num; ++ j) {
            ld_jmp_exp[cnt + i * prime_operation_num + j] = ld_jmp_offset[flush_seq[i]];
            ld[cnt + i * prime_operation_num + j] = (uint64_t)ptr + base * (1 - prime_operation[j]);
            st_jmp_exp[cnt + i * prime_operation_num + j] = st_jmp_offset[0];
        }
    }
    cnt += flush_seq_len * prime_operation_num;

    for(int i = 0; i < exp_seq_len; i ++) {
        for(int j = 0; j < prime_operation_num; ++ j) {
            ld_jmp_exp[cnt + i * prime_operation_num + j] = ld_jmp_offset[exp_seq[i]];
            ld[cnt + i * prime_operation_num + j] = (uint64_t)ptr + base * (1 - prime_operation[j]);
            st_jmp_exp[cnt + i * prime_operation_num + j] = st_jmp_offset[0];
        }
    }
    cnt += exp_seq_len * prime_operation_num;

    for(int i = cnt; i < cnt + SIZE_SAMPLE_ORG / 2; i ++) {
        ld[i] = (uint64_t)ptr + base;
        ld_jmp_exp[i] = ld_jmp_offset[ld_prob_id];       
        st_jmp_exp[i] = st_jmp_offset[0]; 
    }
    cnt += SIZE_SAMPLE_ORG / 2;

    // printf("%d\n", cnt);
    // for(int i = 0; i < cnt; ++ i) {
    //     printf("%lx ", ld_jmp_exp[i]);
    // }
    // printf("\n");

    #if ARCH == 0 
        ld[0] = (uint64_t) ptr + base;
        for(int i = 0; i < 100; ++ i) {
            stld(&st[0], &ld[0], &ld_jmp_exp[1], 1, 
            &time_samples[0], &st_jmp_exp[0]);
        }
        stld(&st[0], &ld[0], &ld_jmp_exp[0], cnt, &time_samples[0], &st_jmp_exp[0]);
    #elif ARCH == 2 || ARCH == 4
        stld(&st[0], &ld[0], &ld_jmp_exp[0], cnt, &time_samples[0], &st_jmp_exp[0]);
    #elif ARCH == 1
        stld(&st[0], &ld[0], &ld_jmp_exp[0], cnt - SIZE_SAMPLE_ORG / 2, 
            &time_samples[0], &st_jmp_exp[0]);
        ld[0] = (uint64_t) ptr + base;
        for (int i = 0; i < 100; ++ i) {
            stld(&st[0], &ld[0], &ld_jmp_offset[(ld_prob_id + 1) % ld_size], 1, 
            &time_samples[0], &st_jmp_exp[0]);
        }
        stld(&st[cnt - SIZE_SAMPLE_ORG / 2], &ld[cnt - SIZE_SAMPLE_ORG / 2], 
            &ld_jmp_exp[cnt - SIZE_SAMPLE_ORG / 2], SIZE_SAMPLE_ORG / 2, 
            &time_samples[cnt - SIZE_SAMPLE_ORG / 2], &st_jmp_exp[0]);
    #elif ARCH == 3
        stld(&st[0], &ld[0], &ld_jmp_exp[0], cnt - SIZE_SAMPLE_ORG / 2, 
            &time_samples[0], &st_jmp_exp[0]);
        for (volatile int z = 0; z < 999; ++ z) {}
        stld(&st[cnt - SIZE_SAMPLE_ORG / 2], &ld[cnt - SIZE_SAMPLE_ORG / 2], 
            &ld_jmp_exp[cnt - SIZE_SAMPLE_ORG / 2], SIZE_SAMPLE_ORG / 2, 
            &time_samples[cnt - SIZE_SAMPLE_ORG / 2], &st_jmp_exp[0]);
        for (volatile int z = 0; z < 999; ++ z) {}
    #else
    #endif
    // for(int i = 0; i < cnt; ++ i) {
    //     printf("%d ", time_samples[i]);
    // }
    // printf("\n");

    for(int i = 0; i < SIZE_SAMPLE_HSAH / 2; ++ i) {
        time_samples[i + SIZE_SAMPLE_HSAH / 2] = time_samples[cnt - 1 - SIZE_SAMPLE_ORG / 2 + i];
    }
    // check the first store-load entry
    if (state_analysie(time_samples, SIZE_SAMPLE_HSAH) >= expected_mdp_val / 2)
        return 1;
    else
        return 0;
}

int upd_evicted_threshold;
int timing_outstanding_threshold;

/**
 * @brief The wrapper of stld_experiment. Run stld_experiment for multiple times to reduce noise.
 *
 * @param exp_seq        Store-load pairs with different PCs
 * @param exp_seq_len    Number of elements in exp_seq
 * @param flush_seq      Store-load pairs used for initializing the MDP state
 * @param flush_seq_len  Number of elements in flush_seq
 * @param ld_prob_id     The store-load pair to be tested
 * 
 * @return               Whether the store-load pair with ID ld_prob_id is evicted
 */
int evict_experiment(int* exp_seq, int exp_seq_len, int* flush_seq, int flush_seq_len, int ld_prob_id) {
    int evicted = 0;
    for(int t = 0; t < 5; ++ t) {
        int tmp_upd = 0;
        for(int i = 0; i < 100; ++ i)
            tmp_upd += stld_experiment(exp_seq, exp_seq_len,
                flush_seq, flush_seq_len, ld_prob_id);
        if (tmp_upd <= upd_evicted_threshold)
            evicted += 1;
    }
    return evicted >= 4;
}


int random_seq(int *test_seq, int length, int first) {
    // random test_seq;
    for (int i = first; i < length - 1; ++i) {
        int num = (rand() % (length - i)) + i;
        int temp = test_seq[i];
        test_seq[i] = test_seq[num];
        test_seq[num] = temp;
    }
}

/**
 * @brief Solve the design parameters, including associativity, index bits and MDP table size.
 */
void org_test(int *evict_set_in, int evict_ways, int *set_out, int *size_out, uint64_t *index_bit_out) {
    printf("hash size : %d\n", hash_size);
    printf("ld size : %d\n", ld_size);
    printf("evict ways : %d\n", evict_ways);
    int evict_set[ld_size];
    for (int i = 0; i < evict_ways; ++i) {
        evict_set[i] = evict_set_in[i];
    }
    for (int i = 0; i < evict_ways; ++i) {
        printf("  %d(%lx)", evict_set[i], ld_hash[evict_set[i]]);
    }
    printf("\n");

    int upd = evict_experiment(evict_set, evict_ways, NULL, 0, evict_set[0]);
    printf("Test evict_set : %d\n", upd);
    upd = evict_experiment(evict_set, evict_ways - 1, NULL, 0, evict_set[0]);
    printf("Test evict_set - 1 : %d\n", upd);

    // test SSBP sets and Index
    int has_Insert[hash_size];
    int flush_seq[ld_size];
    int flush_seq_len = 0;
    int flush_seq2[ld_size];
    int flush_seq2_len = 0;
    for (int i = 0; i < hash_size; ++i) {
        has_Insert[i] = 0;
    }
    for (int i = 0; i < evict_ways; ++i) {
        has_Insert[ld_hash[evict_set[i]]] = 1;
    }
    for (int i = 0; i < ld_size; ++i)
        if (has_Insert[ld_hash[i]] == 0) {
            has_Insert[ld_hash[i]] = 1;
            flush_seq[flush_seq_len] = i;
            flush_seq_len++;
        }
        
    int bit_sum = 1;
    while ((1 << bit_sum) < hash_size) {
        bit_sum++;
    }
    int bit_count[100][2];
    int fix_bit[100];
    for (int i = 0; i < bit_sum; ++i) {
        bit_count[i][0] = 0;
        bit_count[i][1] = 0;
    }
    for (int i = 0; i < hash_size; ++i)
        if (has_Insert[i]) {
            for (int j = 0; j < bit_sum; ++j)
                if (((i >> j) & 0x01) > 0) {
                    bit_count[j][1]++;
                } else {
                    bit_count[j][0]++;
                }
        }
    for (int i = 0; i < bit_sum; ++i) {
        if ((bit_count[i][0] == 0) || (bit_count[i][1] == 0)) {
            fix_bit[i] = 1;
        } else {
            fix_bit[i] = 0;
        }
    }

    for (int i = 0; i < hash_size; ++i) {
        has_Insert[i] = 0;
    }
    for (int i = 0; i < evict_ways; ++i) {
        has_Insert[ld_hash[evict_set[i]]] = 1;
    }

    upd = evict_experiment(evict_set, evict_ways, flush_seq, flush_seq_len, evict_set[0]);
    printf("Test evict_set : %d\n", upd);
    upd = evict_experiment(evict_set, evict_ways - 1, flush_seq, flush_seq_len, evict_set[0]);
    printf("Test evict_set - 1 : %d\n", upd);

    for (int bit_cycles = 0; bit_cycles < 1; ++bit_cycles) {
        for (int i = 0; i < flush_seq_len; ++i) {
            if (has_Insert[ld_hash[flush_seq[i]]] == 0) {
                int temp = evict_set[evict_ways - 1];
                evict_set[evict_ways - 1] = flush_seq[i];
                //flush_seq[i] = flush_seq[flush_seq_len - 1];
                if (flush_seq_len < 2 * evict_ways) upd = evict_experiment(evict_set, evict_ways, flush_seq, flush_seq_len, evict_set[0]);
                else upd = evict_experiment(evict_set, evict_ways, flush_seq, 2 * evict_ways, evict_set[0]);
                //flush_seq[i] = evict_set[evict_ways - 1];
                evict_set[evict_ways - 1] = temp;
                if (upd) {
                    has_Insert[ld_hash[flush_seq[i]]] = 1;
                    flush_seq2[flush_seq2_len] = flush_seq[i];
                    flush_seq2_len++;
                }
            }
        }
    }

    for (int i = 0; i < bit_sum; ++i) {
        bit_count[i][0] = 0;
        bit_count[i][1] = 0;
    }
    for (int i = 0; i < hash_size; ++i)
        if (has_Insert[i]) {
            for (int j = 0; j < bit_sum; ++j)
                if (((i >> j) & 0x01) > 0) {
                    bit_count[j][1]++;
                } else {
                    bit_count[j][0]++;
                }
        }

    int index_bits = 0;
    uint64_t index_bit_set = 0;
    for (int i = 0; i < bit_sum; ++i) {
        double rate;
        if (bit_count[i][0] <= bit_count[i][1]) {
            rate = bit_count[i][0];
            rate = rate / (double)bit_count[i][1];
        } else {
            rate = bit_count[i][1];
            rate = rate / (double)bit_count[i][0];
        }
        printf("bit %d  :  %ld(0) vs %ld(1) ", i, bit_count[i][0], bit_count[i][1]);
        printf("bit %d  :  %ld(0) vs %ld(1) ", i, bit_count[i][0], bit_count[i][1]);
        if ((rate - INDEX_BIT_RATE < 1e-9) && (fix_bit[i] == 0)) {
            printf("  Index\n");
            index_bits++;
            index_bit_set = index_bit_set | (1 << i);
        } else {
            printf("  Tag\n");
        }
    }
    printf("SSBP sets: %d\n", 1 << index_bits);
    printf("SSBP size: %d\n", (1 << index_bits) * (evict_ways - 1));


    *set_out = 1 << index_bits;
    *size_out = (1 << index_bits) * (evict_ways - 1);
    *index_bit_out = index_bit_set;

#if ARCH==0
    int set_sum = bit_count[0][0] + bit_count[0][1];
    double rate = set_sum * (1 << index_bits);
    rate = rate / hash_size;
    if ((rate < 0.7) || (rate > 1.5)) {
        *set_out = 0;
        *size_out = 0;
        *index_bit_out = 0;
    }
#endif
    // set_size = bit_count[0][0] + bit_count[0][1];
    // check : set_size * (1 << index_bits) = ld_size
}

/**
 * @brief Generate the threshold that determines whether an eviction happens.
 */
int get_evict_threshold() {
    // randomly pick one initial node, find negative and positive timing
    int nodes[ld_size];
    int exp_1[ld_size], exp_2[1];    
    int node_used[ld_size];
    for(int i = 0; i < ld_size; ++ i)  // init nodes
        nodes[i] = i;
    random_seq(nodes, ld_size, 1);      // shuffle nodes
    for(int i = 0; i < ld_size; ++ i)   // shuffle node_used
        node_used[i] = 0;
    node_used[0] = 1;
    int size_exp_1_0 = 0;
    for(int i = 0; i < ld_size >> 3; ++ i) {
        if (node_used[nodes[i]] == 0) {
            node_used[nodes[i]] = 1;
            exp_1[size_exp_1_0++] = nodes[i];
        }
    }

    exp_2[0] = 0;
    int size_exp_1_1 = 1;
    int upd_exp_1_0 = 0, upd_exp_1_1 = 100;
    for(int t = 0; t < 100; ++ t) {
        int tmp_upd = 0;
        for(int i = 0; i < 100; ++ i)
            tmp_upd += stld_experiment(exp_1, size_exp_1_0, NULL, 0, 0);
        if (tmp_upd > upd_exp_1_0) 
            upd_exp_1_0 = tmp_upd;
    }
    for(int t = 0; t < 100; ++ t) {
        int tmp_upd = 0;
        for(int i = 0; i < 100; ++ i)
            tmp_upd += stld_experiment(exp_2, size_exp_1_1,
                        NULL, 0, 0);
        if (tmp_upd < upd_exp_1_1) 
            upd_exp_1_1 = tmp_upd;
    }   

    upd_evicted_threshold = (upd_exp_1_1 - upd_exp_1_0) / 10 + upd_exp_1_0;
    if (upd_evicted_threshold >= upd_exp_1_1)
        upd_evicted_threshold = 0;
}

/**
 * @brief Generate the initial eviction set using the reverse binary research.
 */
int gen_eviction_set(int init_node, FILE* fout, int* evict_set) {
    // Get minimum size of the eviction set
    int nodes[ld_size];
    int exp_1[ld_size], flush[ld_size];    
    int node_used[ld_size];
    for(int i = 0; i < ld_size;  ++ i)  // init nodes
        nodes[i] = i;
    nodes[0] = init_node;               // swap init_node to the first node
    nodes[init_node] = 0;
    random_seq(nodes, ld_size, 1);      // shuffle nodes
    for(int i = 0; i < ld_size; ++ i)   // shuffle node_used
        node_used[i] = 0;
    node_used[0] = 1;
    int size_flush = 0;
    for(int i = 0; i < ld_size; ++ i) {
        if (node_used[nodes[i]] == 0) {
            node_used[nodes[i]] = 1;
            flush[size_flush++] = nodes[i];
        }
    }
    for(int i = 0; i < ld_size; ++ i)
        exp_1[i] = nodes[i];
    // Find 2^x eviction size through reverse binary research
    int evict_size_pow2 = 1;
    int has_evicted_pow2 = 0;
    while(evict_size_pow2 < ld_size) {
        int evicted = evict_experiment(exp_1, evict_size_pow2,
                    &exp_1[evict_size_pow2], evict_size_pow2, init_node);
        if (evicted) {
            has_evicted_pow2 = 1;
            break;
        }
        evict_size_pow2 *= 2;
    }
    // From 2^(x-1) to 2^x, find the target eviction size by linear research
    if (!has_evicted_pow2) {
        for(int i = 0; i < ld_size; ++ i)
            evict_set[i] = exp_1[i];
        return ld_size;
    }
    int evict_size_linear = -1;
    for(int e = evict_size_pow2 >> 1; e < evict_size_pow2; e++) {
        int evicted = evict_experiment(exp_1, e,
                    &exp_1[e], e * 3 < ld_size ? e * 2 : ld_size - e, init_node);
        evict_size_linear = e;
        if (evicted)
            break;
    }
    // printf("evict_size_linear = %d\n", evict_size_linear - 1);
    // fprintf(fout, "evict_size_linear = %d\n", evict_size_linear - 1);
    for(int i = 0; i < evict_size_linear; ++ i)
        evict_set[i] = exp_1[i];
    return evict_size_linear;
}

/**
 * @brief Generate the minimal eviction set
 */
int reduce_eviction_set(int* eviction_set, int init_set_size) {
    // Try to minimize the eviction set
    int real_size = init_set_size, flush_size = 0;
    int real_size_reduced = 1;
    int real_eviction_set[init_set_size], flush[ld_size], node_used[ld_size]; 
    for(int i = 0; i < ld_size; ++ i)
        node_used[i] = 0;
    for(int i = 0; i < init_set_size; ++ i)
        node_used[eviction_set[i]] = 1;
    for(int i = 0; i < ld_size; ++ i)
        if (!node_used[i]) {
            node_used[i] = 1;
            flush[flush_size++] = i;
        }
    for(int i = 0; i < init_set_size; ++ i)
        real_eviction_set[i] = eviction_set[i];
    while(real_size_reduced && real_size >= 2) {
        real_size_reduced = 0;
        for(int i = 1; i < real_size; ++ i) {
            // try to remove i
            int tmp = real_eviction_set[i];
            real_eviction_set[i] = real_eviction_set[real_size - 1];
            real_eviction_set[real_size - 1] = tmp;
            int evicted = 0;
            for(int try = 0; try < 5; ++ try) {
                evicted += evict_experiment(real_eviction_set, real_size - 1, 
                                flush, init_set_size + 1, eviction_set[0]);
                if (evicted) break;
            }
            if (evicted) {
                real_size_reduced += 1;
                real_size --;
                break;
            }
        }
    }
    // printf("init_set_size = %d, real_size = %d\n", init_set_size, real_size);
    // if (init_set_size < 64 && real_size < init_set_size)
        for(int i = 0; i < real_size; ++ i)
            eviction_set[i] = real_eviction_set[i];
    // else 
        // real_size = init_set_size;
    return real_size;
    
}

/**
 * @brief Generate the PI permutation to solve the replacement policy.
 */
int gen_replacement_pi(int* eviction_set, int set_size, int** Pi) {
    int node_used[ld_size]; 
    int pi_size = set_size - 1 >= 4 ? 4 : set_size - 1;
    int exp_size = 0;
    int exp_3[ld_size + pi_size];
    
    for(int i = 0; i < ld_size; ++ i)
        node_used[i] = 0;

    for(int i = 0; i < pi_size; ++ i)
        Pi[pi_size][i] = i;

    for(int i = 0; i < set_size; ++ i)
        exp_3[exp_size++] = eviction_set[i];
    for(int i = 0; i < set_size; ++ i)
        node_used[eviction_set[i]] = 1;
    for(int i = 0; i < ld_size; ++ i)
        if (!node_used[i]) {
            node_used[i] = 1;
            exp_3[exp_size++] = i;
        }

    // pi_3_0: 0 1 2 3 ... n-2 0 n-1 e1 e2 e3
    // pi_3_1: 0 1 2 3 ... n-2 1 n-1 e1 e2 e3 
    // pi_3_2: 0 1 2 3 ... n-2 2 n-1 e1 e2 e3 
    // pi_3_3: 0 1 2 3 ... n-2 3 n-1 e1 e2 e3 
    int exp_len_glb = set_size + 1;
    for(int p = 0; p < pi_size; ++ p) {
        exp_3[set_size - 1] = eviction_set[p];
        exp_3[set_size] = eviction_set[set_size - 1];
        int victim[set_size + pi_size], victim_first4_label[4] = {-1, -1, -1, -1}, evict_first4 = 0;
        for(int i = 0; i < set_size + pi_size; ++ i)
            victim[i] = -1;
        for(int v = 0; v < set_size; ++ v) {
            int exp_len = exp_len_glb;
            if (v >= 1)
                exp_3[exp_len + v] = eviction_set[victim[v - 1]];
            while(victim[v] == -1) {
                for(int i = 0; i < set_size - 1; ++ i) {   // find the first victim
                    int evicted = evict_experiment(exp_3, exp_len + v,
                                    &exp_3[exp_size - set_size - 4],
                                    set_size + 4,
                                    eviction_set[i]);
                    if (evicted) {
                        if (p == 0 && v == 0 && exp_len_glb != exp_len)
                            exp_len_glb = exp_len;
                        victim[v] = i;
                        if (i < pi_size && victim_first4_label[i] == -1) {
                            victim_first4_label[i] = evict_first4++;
                            break;
                        }
                    }
                }
                exp_len ++;
            }
            // for(int i = 0; i < exp_len + v; ++ i) {
            //     printf("[%d] %d ", i, exp_3[i]);
            // }
            // printf(" -> %d\n", victim[v]);
            // fprintf(fout, " -> %d\n", victim[v]);
            // printf("%d\n", exp_len_glb);
            if (evict_first4 >= pi_size - 1) {
                for(int i = 0; i < pi_size; ++ i)
                    if (victim_first4_label[i] == -1)
                        victim_first4_label[i] = pi_size - 1;
                break;
            }
        }
        for(int i = 0; i < pi_size; ++ i) 
            Pi[p][i] = victim_first4_label[i];
    }
    for(int i = 0; i < pi_size + 1; ++ i) {
        for(int j = 0; j < pi_size; ++ j) {
            printf("%d ", Pi[i][j]);
        }
        printf("\n");
    }   
}

/**
 * @brief A demo showing how to use funtion stld_experiment.
 */
void experiment_demo() {
    // Experiment Demo    
    int exp[10][100] = {{1,2,3,4}, {0}, {0}, {0}, {0}};
    int flush[100];
    for(int i = 0; i < 100; ++ i) {
        for(int j = 1; j < 10; ++ j)
            exp[j][i] = i;
        flush[i] = 100 + i;
    }
    int exp_len[6] = {4, 4, 8, 16, 32, 64};
    for(int i = 0; i < 1; i += 1) {
        int upd = 0;
        for(int j = 0; j < 1000; ++ j)    // Reduce noise
            upd += stld_experiment(exp[i], exp_len[i], flush, 72, 0);
        printf("%d\n", upd);
    }
}

int main(int argc, char* argv[]) {
    // Input
    FILE* fin = fopen("in.txt", "r");
    FILE* fout = fopen("out.txt", "w");
    uint64_t fixed_map_addr;
    int cmd, cmd2;
    fscanf(fin, "%d %d", &cmd, &cmd2);
    fscanf(fin, "%d %d %d %d %ld", &cpu, &prime_operation_num, 
        &expected_mdp_val, &is_store_mdp, &fixed_map_addr);
    if (expected_mdp_val == 0) // state machine is not used
        expected_mdp_val = SIZE_SAMPLE_ORG > 16 ? 16 : SIZE_SAMPLE_ORG >> 1;
    for(int i = 0; i < prime_operation_num; ++ i) 
        fscanf(fin, "%d", &prime_operation[i]);
    fscanf(fin, "%d %d", &hash_size, &ld_size);
    
    for(int i = 0; i < ld_size; ++ i) {
        fscanf(fin, "%ld", &ld_jmp_offset[i]);
    }
    for(int i = 0; i < ld_size; ++ i) {
        fscanf(fin, "%ld", &ld_hash[i]);
    }
    fclose(fin);

    // Prepare
    srand(time(NULL));
    ptr = (char*) malloc(500);
    int fd = open(ORG_SHARED_FILE_NAME, O_RDWR);
    if (fd < 0) {
        printf("Cannot open file, exit\n");
        return 0;
    }
    void *p = mmap((void*)fixed_map_addr, ORG_MAP_SIZE * PAGE_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_FIXED, fd, 0);
    for(int i = 0; i < ld_size; ++ i) {  // prepare load instructions
        uint64_t pos = ld_jmp_offset[i];
        for(int j = 0; j < ld_seg_len; ++ j)
            *((char*)p + pos + j) = ld_set_ins[j]; 
        ld_jmp_offset[i] = (uint64_t) p + pos;
    }
    if (mprotect(p, ORG_MAP_SIZE * PAGE_SIZE, PROT_READ | PROT_EXEC) < 0) {
        printf("mprotect");
        return 0;
    }

    for (int i = 0; i < 409600; i ++) {  // prepare data addresses
        st[i] = (uint64_t)ptr;
        ld[i] = (uint64_t)(ptr + base);
    }

    bindcore(cpu); // bind core

    for (int i = 0; i < LOOP_HOT_HASH; i ++) { // hot core
        stld(&st[i % 409600], &ld[i % 409600], 
            &ld_jmp_offset[i % ld_size],
            1, &time_samples[0], &st_jmp_offset[0]);
    }

    int repeat_num_eviction_set = 10, expected_eviction_set_size = -1;
    if (cmd == 0) repeat_num_eviction_set = cmd2;
    if (cmd != 0) expected_eviction_set_size = cmd2;

    int best_eviction_set_size = 0;
    int best_eviction_set[ld_size];
    int eviction_set_gen[ld_size];
    int eviction_set_size_freq[ld_size + 1];

    // experiment_demo();
    // Generate eviction set
    int threshold_try = 0;
    get_evict_threshold();
    while ((upd_evicted_threshold == 0 || upd_evicted_threshold > 50) && threshold_try++ < 6) {
        if (threshold_try <= 3)
            expected_mdp_val += 2;
        else
            expected_mdp_val -= 2;
        get_evict_threshold();
    }
    printf("upd_evicted_threshold = %d\n", upd_evicted_threshold);
    if (threshold_try == 3)
        goto org_exit;

    for(int i = 0; i <= ld_size; ++ i) 
        eviction_set_size_freq[i] = 0;
    int evict_max_freq = 0;
    int evict_max_freq_idx = -1;
    for(int i = 0; i < repeat_num_eviction_set; ++ i) {
        int eviction_size_init = gen_eviction_set(rand() % ld_size, fout, eviction_set_gen);
        int eviction_size_reduced = eviction_size_init;
        if (eviction_size_init < ld_size || eviction_size_init < eviction_size_max)
            eviction_size_reduced = reduce_eviction_set(eviction_set_gen, eviction_size_init);
        if (eviction_size_reduced == 0) continue;
        printf("Eviction set update: eviction_size_init = %d, eviction_size_reduced = %d\n", 
            eviction_size_init - 1, eviction_size_reduced - 1);
        eviction_set_size_freq[eviction_size_reduced] ++;
        if (eviction_set_size_freq[eviction_size_reduced] > evict_max_freq || 
            (cmd > 0 && eviction_size_reduced == expected_eviction_set_size + 1)) {
            evict_max_freq = eviction_set_size_freq[eviction_size_reduced];
            best_eviction_set_size = eviction_size_reduced;
            for(int j = 0; j < best_eviction_set_size; ++ j)
                best_eviction_set[j] = eviction_set_gen[j];
            if (cmd > 0 && eviction_size_reduced == expected_eviction_set_size + 1) break;
        }
    }
    printf("After reduction, evict_size = %d\n", best_eviction_set_size - 1);
    if (cmd == 0) fprintf(fout, "%d\n", best_eviction_set_size - 1);
    else if (cmd == 1) {
        if (best_eviction_set_size != expected_eviction_set_size + 1) goto org_exit;
        int pi_size = best_eviction_set_size - 1 >= 4 ? 4 : best_eviction_set_size - 1;
        int **Pi = malloc((pi_size + 1) * sizeof(int*));
        for(int i = 0; i < pi_size + 1; ++ i) Pi[i] = malloc((pi_size) * sizeof(int));
        for(int try = 0; try < 5; ++ try) {
            gen_replacement_pi(best_eviction_set, best_eviction_set_size, Pi);
            fprintf(fout, "%d\n", pi_size);
            for(int i = 0; i < pi_size + 1; ++ i) {
                for(int j = 0; j < pi_size; ++ j) {
                    fprintf(fout, "%d ", Pi[i][j]);
                }
                fprintf(fout, "\n");
            }   
        }
    }
    else if (cmd == 2) {
        if (best_eviction_set_size != expected_eviction_set_size + 1) goto org_exit;
        int *ssbp_size = (int*)malloc(sizeof(int));
        int *ssbp_sets = (int*)malloc(sizeof(int));;
        uint64_t *ssbp_index_bits = (int*)malloc(sizeof(uint64_t));
        org_test(best_eviction_set, best_eviction_set_size, ssbp_sets, ssbp_size, ssbp_index_bits);
        fprintf(fout, "%d %d %d\n", *ssbp_size, *ssbp_sets, *ssbp_index_bits);
        free(ssbp_size);
        free(ssbp_sets);
        free(ssbp_index_bits);
    }
    else {}

    // exit
org_exit:
    fclose(fout);
    munmap(p, ORG_MAP_SIZE * PAGE_SIZE);
    close(fd);

    return 0;
}