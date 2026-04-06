#ifndef CONFIG_H
#define CONFIG_H

/* Platform Configuration */
#ifndef ARCH                    // 0: AMD, 1: Intel, 2: Arm, 3: Apple, 4: neoverse
#define ARCH -1
#endif

/* Runtime Configuration */

#define LOOP_HOT_EX 1000000     // Making CPU frequence stable in existence test
#define LOOP_HOT_SM 1000000     // Making CPU frequence stable in state machine test
#define LOOP_HOT_HASH 1000000   // Making CPU frequence stable in hash test
#define LOOP_TRY_HASH 30        // Number of try times in hash test

#define SIZE_SAMPLE_HSAH 100    // Number of timing samples in hash testing
#define SIZE_SAMPLE_ORG 100     // Number of timing samples in hash testing
#define PAGE_SIZE 4096          // Size of a page, 4 KiB by default

#endif