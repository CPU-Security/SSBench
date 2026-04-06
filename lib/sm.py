import subprocess
import re
import os
import json
from .utils.sm_solver import integer_solve

proj_root = ".."
bin_file = os.path.join(proj_root, "bin", "sm")  # bin/sm
elf = "microbenchmark"
make_file = os.path.join(proj_root, "src", "sm") # src/sm/Makefile
bin_data_flie = os.path.join(proj_root, "bin", "sm") # bin/sm
lib_data_file = os.path.join(proj_root, "data") # data
input_file = os.path.join(bin_data_flie, "in.txt") # bin/sm/in.txt
output_file = os.path.join(bin_data_flie, "out.txt") # bin/sm/out.txt
characterization_file = os.path.join(lib_data_file, "characterization.json") # data/*.json
seq_file = os.path.join(lib_data_file, "seq.json") # data/seq.json

def build(arch):
    '''
    Build testcase.

    Args:
        arch (str): Architecture information from [intel, amd, arm, apple, neoverse]

    Returns:
        None
    '''
    cmd = f"make -C {make_file} arch={arch} clean && make -C {make_file} arch={arch}"
    # print(cmd)
    subprocess.run(cmd, shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    return

def run():
    '''
    Run the testcase.

    Args:
        None

    Returns:
        None
    '''
    original_dir = os.getcwd()
    d = bin_file
    if os.path.isdir(bin_file):
        os.chdir(d)
        cmd = f"./{elf}"
        e = subprocess.Popen(
            cmd,
            shell=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True
        ).communicate()[0]
    os.chdir(original_dir)
    return

def set_input(operation_list, operator_list, record_list, cpu):
    '''
    Build input file of a testcase.

    Args:
        operation_list (list): A list that defines the dependence of a store-load sequence. 
                               For each element, 1 means a dependent store-load pair, while
                               0 means an independent store-load pair
        operator_list (list):  A list that defines the instruction PC of a store-load sequence. 
        record_list (list):    A list that defines store-load pairs to be timed. 
        cpu (int):             Core ID

    Returns:
        None
    '''
    with open(input_file, 'w') as f:
        f.write("{0} {1} {2}\n".format(cpu, len(operation_list), len(record_list)))
        for i in range(len(operation_list)):
            f.write("{0} ".format(operation_list[i]))
        f.write("\n")
        for i in range(len(operator_list)):
            f.write("{0} ".format(operator_list[i]))
        f.write("\n")
        for i in range(len(record_list)):
            f.write("{0} ".format(record_list[i]))
        f.write("\n")
    return

def parse_input():
    '''
    Read the input file and parse the operation list.

    Args:
        None

    Returns:
        operation_list (list): A list that defines the dependence of a store-load sequence. 
                               For each element, 1 means a dependent store-load pair, while
                               0 means an independent store-load pair
    '''
    with open(input_file, 'r') as f:
        lines = f.readlines()
        meta_data = lines[0].strip().split(" ")
        op_data = lines[1].strip().split(" ")
        operation_num = int(meta_data[1])
        operation_list = [int(i) for i in op_data]
        assert(operation_num == len(operation_list))
    return operation_list

def parse_output(print_cmd):
    '''
    Read the output file and parse the output from the microbenchmark.

    Args:
        print_cmd (bool): Whether the output should be printed in the terminal

    Returns:
        (list, list):
            - flag: A list that contains the true dependence of a store-load sequence.
                    1: dependent, 0: independent
            - time: A list that contains the executen time of each store-load pair in
                    a store-load sequence
    '''
    op_list = parse_input()
    with open(output_file, 'r') as f:
        lines = f.readlines()
        assert(len(lines) == 1)
        flag = []
        time = []
        data = [int(d) for d in lines[0].strip().split(" ")]
        # assert(len(data) == 2 * len(op_list))
        for j in range(0, len(data), 2):
            flag.append(data[j])
            time.append(data[j + 1])
    if (print_cmd):
        format_output(flag, time, 8)
    return (flag, time)

def format_output(flag_list, time_list, num_each_line):
    '''
    Print the output of microbenchmark in a human-readable format.

    Args:
        flag_list (list): A list that contains the true dependence of a store-load sequence:
                          1: dependent, 0: independent
        time_list (list): A list that contains the executen time of each store-load pair in
                          a store-load sequence
        num_each_line (int): Number of timing samples that appear in a line

    Returns:
        None
    '''
    assert(len(flag_list) == len(time_list))
    for j in range(0, num_each_line):
        print("{0:^11}".format(j), end = "")
    print()
    assert(len(flag_list) == len(time_list))
    for j in range(0, len(flag_list), num_each_line):
        print("{0:<3}".format(j // num_each_line), end = " ")
        for k in range(0, min(num_each_line, len(flag_list) - j)):
            print("({2:<2})[{0}]{1}".format("a" if flag_list[j + k] == 1 else "n", 
                                            time_list[j + k], j + k), end = " ")
        print()

def gen_seq_in_text_list(raw_sequence):
    """
    Generate operation sequences from a compressed sequence string.

    Example:
        gen_seq_in_text_list("3a") -> ["aaa"], [[1, 1, 1]]

    Args:
        raw_sequence (str): Encoded sequence string describing store-load dependence

    Returns:
        tuple:
            - sequences_in_text (list[str]): Expanded sequences with 'a'/'n'
            - ops_list (list[list[int]]): Corresponding numeric operations (1='a', 0='n')
    """
    raw_sequence_combine = ''.join(i.strip() for i in raw_sequence)
    raw_sequence_combine_list = re.split(r"(\d+)", raw_sequence_combine)
    sequence_in_text_with_x = str()
    repeat_n = 1
    for s in raw_sequence_combine_list:
        if (len(s) == 0):
            continue
        elif (len(s) > 0 and s.isdigit()):
            repeat_n = int(s)
            assert(repeat_n >= 0)
        else:
            sequence_in_text_with_x += repeat_n * s[0]
            sequence_in_text_with_x += s[1:]
            repeat_n = 1
    # parse x
    sequences_in_text = []
    idx_list = []
    for i in range(len(sequence_in_text_with_x)):
        if sequence_in_text_with_x[i] == 'x':
            idx_list.append(i)
    # print(idx_list)
    for i in range(2 ** len(idx_list)):
        sequence_in_text_without_x = sequence_in_text_with_x
        for j in range(len(idx_list)):
            sequence_in_text_without_x =  sequence_in_text_without_x[0:idx_list[j]] + (
                'n' if (i >> j) & 1 == 0 else 'a') + sequence_in_text_without_x[idx_list[j] + 1:]
        sequences_in_text.append(sequence_in_text_without_x)
    ops_list = []
    for sequence in sequences_in_text:
        ops = []
        for c in sequence:
            assert(c == 'n' or c == 'a')
            if (c == 'n'):
                ops.append(0)
            else:
                ops.append(1)
        ops_list.append(ops)
    return sequences_in_text, ops_list

def experiment(cpu, sequence = [], operators = [], records = [],
               repeat_times = 1, formatted_print = False):
    """
    Execute experiment with a given operation sequence.

    Args:
        cpu (str): Target core ID
        sequence (list[int]): Operation sequence (0/1)
        repeat_times (int): Number of repetitions
        formatted_print (bool): Whether to format output

    Returns:
        tuple:
            - times (list): Timing results
            - flags (list): Execution flags
    """
    times = []
    flags = []
    for i in range(repeat_times):
        set_input(operation_list = sequence, 
                  operator_list=operators, record_list=records ,cpu=cpu)
        run()
        f, t = parse_output(formatted_print)
        times.append(t)
        flags.append(f)
    return times, flags

def analyze(times, flags, type_time_dict):
    """
    Infer timing-type sequences from repeated experiment results and filter noise.

    Args:
        times (list[list[int]]): Timing samples from repeated experiments.
            Each inner list represents one execution sequence
        flags (list[list[int]]): Flag results corresponding to `times`.
            Currently read per sample but not used in classification logic
        type_time_dict (dict): Timing classification dictionary, typically
            containing:
                - 'S': timing ranges for S-type
                - 'B': timing ranges for B-type
                - 'R': timing ranges for R-type
                - 'b1': threshold between S and B
                - 'b2': threshold between B and R
                - 'b3': threshold between R and noise

    Returns:
        list[str]: A list containing the most frequent and second most frequent
        timing-type sequences. Returns an empty list if the result is too noisy
        or unstable
    """
    type_seqs = list()

    for i in range(len(times)):
        type_seq = list()
        t_types = ['S', 'R', 'B']
        t_in_seq = times[i]
        f_in_seq = flags[i]

        for k in range(len(t_in_seq)):
            t = t_in_seq[k]
            f = f_in_seq[k]
            tp_t = 'N'

            for tp in t_types:
                for timing_range in type_time_dict[tp]:
                    if timing_range[0] <= t and t <= timing_range[1]:
                        tp_t = tp
                        break
                if tp_t != 'N':
                    break

            if tp_t == 'N':
                if t <= type_time_dict["b1"]:
                    tp_t = 'S'
                elif t > type_time_dict["b1"] and t <= type_time_dict["b2"]:
                    tp_t = 'B'
                elif t > type_time_dict["b2"] and t < type_time_dict["b3"]:
                    tp_t = 'R'
                else:
                    pass

            type_seq.append(tp_t)

        type_seqs.append(''.join([c for c in type_seq]))

    # Count the frequency of each observed execution sequence
    freq_seq = dict()
    for i in range(len(type_seqs)):
        if type_seqs[i] in freq_seq.keys():
            freq_seq[type_seqs[i]] += 1
        else:
            freq_seq[type_seqs[i]] = 1

    # Get the top two most frequent sequences
    a, b = 0, 0
    id_1, id_2 = -1, -1
    for i in range(len(type_seqs)):
        fq = freq_seq[type_seqs[i]]
        if fq > a:
            a = fq
            id_1 = i
        elif fq > b and fq < a:
            b = fq
            id_2 = i

    # If the most frequent sequence appears in less than 3/4 of the runs,
    # or the second most frequent one is too close to it,
    # or the best sequence still contains unknown type 'N',
    # the experiment should be repeated
    if (a < len(times) * 3 // 4 and a // 2 < b) or 'N' in type_seqs[id_1]:
        return []

    return [type_seqs[id_1], type_seqs[id_2]]


def gen_seq(raw_seq_with_anx, arch, cpu, consider_store=False,
            test_mdp_ld_when_consider_store=False,
            clear_original_file=False):
    """
    Generate and evaluate timing-type sequences for all expanded input sequences.

    Args:
        raw_seq_with_anx (str): Input sequence string to expand and test
        arch (str): Target architecture name
        cpu (int): Target core ID
        consider_store (bool, optional): Whether store PC should be
            considered when generating operators. Defaults to False
        test_mdp_ld_when_consider_store (bool, optional): Controls how store-load pairs
            are generated when `consider_store` is enabled. Defaults to False
        clear_original_file (bool, optional): Whether to clear previous
            experiment results before appending new ones. Defaults to False

    Returns:
        list[list[str]]: A list of experiment results
    """
    def gen_operator(sequences_op):
        """
        Generate operator indices and record positions for a sequence.

        Args:
            sequences_op (list[int]): Operation sequence where each element
                typically represents one load/store dependency type.

        Returns:
            tuple:
                - operators (list[int]): Generated operator indices
                - records (list[int]): Recorded original positions
        """
        operators = []
        records = []

        if consider_store and test_mdp_ld_when_consider_store:
            oper = 0
            # After executing each 'a', switch to the next store
            for i in range(len(sequences_op)):
                records.append(i)
                if sequences_op[i] == 0:
                    operators.append(oper)
                else:
                    operators.append(oper)
                    oper += 1

        elif consider_store and not test_mdp_ld_when_consider_store:
            # After executing each 'a', switch to the other store
            # and insert 64 'n' operations
            i = 0
            while i < len(sequences_op):
                operators.append(0)
                records.append(i)
                if sequences_op[i] == 1:
                    for j in range(64):
                        sequences_op.insert(i + 1, 0)
                        i += 1
                    operators.extend([1 for j in range(64)])
                i += 1

        else:
            for i in range(len(sequences_op)):
                operators.append(0)
                records.append(i)

        assert len(operators) == len(sequences_op)
        return operators, records

    time_tp_find = False
    if os.path.isfile(characterization_file):
        with open(characterization_file, 'r') as f:
            character = json.load(f)
            if "type_time_dict" in character.keys():
                time_tp_find = True

    if not time_tp_find:
        print("\033[91m\033[1m[Error]\033[0m Cannot find timing type. Run existence test first.")
        exit()

    sequences_in_text, sequences_op = gen_seq_in_text_list(raw_seq_with_anx)
    seq_results = []

    for i in range(len(sequences_op)):
        operators, records = gen_operator(sequences_op[i])
        times, flags = experiment(
            cpu,
            sequences_op[i],
            operators,
            records,
            formatted_print=False,
            repeat_times=20
        )

        # Output sequences with the top two highest frequencies
        type_seqs = analyze(times, flags, character["type_time_dict"])

        while len(type_seqs) == 0:
            times, flags = experiment(
                cpu,
                sequences_op[i],
                operators,
                records,
                formatted_print=False,
                repeat_times=20
            )
            type_seqs = analyze(times, flags, character["type_time_dict"])

        type_seqs.insert(0, sequences_in_text[i])
        seq_results.append(type_seqs)

    exp_results = []
    if clear_original_file:
        exp_results = []

    exp_results.extend(seq_results)
    return seq_results

def analyse_sm(arch, cpu, consider_store = False, 
            test_mdp_ld_when_consider_store = False):
    """
    Generate the state machine under the 1-counter model.

    Args:
        arch (str): Target architecture name
        cpu (int): Target core ID
        consider_store (bool, optional): Whether store PC should be
            considered when generating operators. Defaults to False
        test_mdp_ld_when_consider_store (bool, optional): Controls how store-load pairs
            are generated when `consider_store` is enabled. Defaults to False

    Returns:
        list: The seven parameters of the state machine
    """
    # Step 1. Find min x1, s.t. x1a a = x1R B
    # Step 2. Find min x3, s.t. x1a x3a a = x1R x3B R
    seq_results = gen_seq(f"100n 100a", arch, cpu, consider_store, 
            test_mdp_ld_when_consider_store)
    x1 = 0
    x3 = -1
    meet_r = False
    for i in range(0, 100):
        if (not meet_r and seq_results[0][1][100 + i] == 'R'):
            x1 += 1
        elif (not meet_r and seq_results[0][1][100 + i] == 'B'):
            meet_r = True
        elif (meet_r and seq_results[0][1][100 + i] == 'R'):
            x3 = i - x1
            break
        else:
            continue
    # print(x1, x3)

    # Step 3. Find min x2, s.t. x1a x2n n = x1R x2B S
    seq_results = gen_seq(f"100n {x1}a 100n", arch, cpu, consider_store, 
            test_mdp_ld_when_consider_store)
    x2 = 0
    for i in range(0, 100):
        if (seq_results[0][1][100 + x1 + i] == 'B'):
            x2 += 1
        else:
            pass # break
    if (x2 == 0):
        print("\033[91m\033[1m[Error]\033[0m Cannot solve the state machine.")
        exit()
    # print(x2)

    # Step 4. Determine x4, x4' and x4''
    # Step 4.1. If x3 == -1, then k6 = 1 and k4 >= 0, Else k4 < 0 OR k6 = 0. 
    #           Then find max x4, s.t. x1A yA x4N N = x1R yB x4B S for any y.
    #           Now we have k5 = x4. Then, find min x4', s.t. x1A (x2-1)N A x4'N N
    #           = x1R x2B x4'B S. Now we have k4 = x4' - x2.
    # Step 4.2. If x3 != -1, we have k4 < 0 or k6 = 0. We find min x4, s.t.
    #           x1A A x4N N = x1R B x4B S. If x4 <= x2, we have k4 < 0 and
    #           k5 = x1 * k3 and k6 = -1. Otherwise, we have k4 > 0 and k6 = 0.
    # Step 4.3. If k6 = 0 and k4 > 0, we find min x4', s.t. x1A (x2 - 1)N x4'A A
    #           = x1R (x2 - 1)B x4'B R. Then we find min x4'', s.t. x1A (x2 - 1)N
    #           (x4' - 1)A x4''N 2A = x1R (x2 – 1)B (x4’ – 1)B x4’’B 2B. Then we
    #           have k5 - kp = x4' * k4 - x4''.
    # Step 4.4. If k4 < 0, we find min x4'. s.t. x1A (x2 – 1)N A x4'A A = 
    #           x1R (x2 – 1)B S x'4R B. Then we find min x4'', s.t. 
    #           x1A (x2 – 1)N A x4'A x4''N N = x1R (x2 – 1)B S x4'R x4''B S.
    #           Then we have k4 = x4'' – 1 – x4' * k3. 
    x4 = x4_ = x4__ = 0
    if x3 == -1:
        seq_results = gen_seq(f"100n 100a 100n", arch, cpu, consider_store, 
            test_mdp_ld_when_consider_store)
        for i in range(0, 100):
            if (seq_results[0][1][200 + i] == 'B'):
                x4 += 1
            else:
                break    
        seq_results = gen_seq(f"100n {x1}a {x2-1}n a 100n", arch, cpu,
                        consider_store, test_mdp_ld_when_consider_store)
        for i in range(0, 100):
            if (seq_results[0][1][100 + x1 + x2 + i] == 'B'):
                x4_ += 1
            else:
                break
    else:
        seq_results = gen_seq(f"100n {x1}a a 100n", arch, cpu, consider_store, 
                        test_mdp_ld_when_consider_store)
        for i in range(0, 100):
            if (seq_results[0][1][100 + x1 + x2 + i] == 'B'):
                x4 += 1
            else:
                break
        if x4 > x2: # k4 > 0 and k6 = 0.
            seq_results = gen_seq(f"100n {x1}a {x2-1}n 100a", arch, cpu,
                            consider_store, test_mdp_ld_when_consider_store)
            for i in range(0, 100):
                if (seq_results[0][1][100 + x1 + x2 - 1 + i] == 'B'):
                    x4_ += 1
                else:
                    break
            for i in range(0, 100):
                seq_results = gen_seq(f"100n {x1}a {x2-1}n {x4_-1}a {i}n 2a",
                                arch, cpu, consider_store, 
                                test_mdp_ld_when_consider_store)
                if (seq_results[0][1][-1] == 'B'):
                    x4__ = i
                    break
        else: # k4 < 0
            seq_results = gen_seq(f"100n {x1}a {x2-1}n a 100a",
                                arch, cpu, consider_store, 
                                test_mdp_ld_when_consider_store)
            for i in range(0, 100):
                if (seq_results[0][1][100 + x1 + x2 + i] == 'R'):
                    x4_ += 1
                else:
                    break
            seq_results = gen_seq(f"100n {x1}a {x2-1}n a {x4_}a 100n",
                                arch, cpu, consider_store, 
                                test_mdp_ld_when_consider_store)
            for i in range(0, 100):
                if (seq_results[0][1][100 + x1 + x2 + x4_ + i] == 'B'):
                    x4__ += 1
                else:
                    break        
    # print(x4, x4_, x4__)

    # Step 5. Find min x5, s.t. x1a x2n n x5a a = x1R x2B S x5R B
    seq_results = gen_seq(f"{x1-1}a n 100a",
                                arch, cpu, consider_store, 
                                test_mdp_ld_when_consider_store)
    x5 = 0
    for i in range(0, 100):
        if (seq_results[0][1][x1 + i] == 'R'):
            x5 += 1
        else:
            break
    # print(x5)

    # Step 6. Find min x6, s.t. x1a x2n n x5a x6n n = x1R x2B S x5R x6B S
    seq_results = gen_seq(f"{x1-1}a n {x5}a 100n",
                                arch, cpu, consider_store, 
                                test_mdp_ld_when_consider_store)
    x6 = 0
    for i in range(0, 100):
        if (seq_results[0][1][x1 + x5 + i] == 'B'):
            x6 += 1
        else:
            break
    # print(x6)

    # Step 3. Solve parameters.
    res = integer_solve(x1, x2, x3, x4, x4_, x4__, x5, x6)
    if (len(res) == 0):
        print("\033[91m\033[1m[Error]\033[0m Cannot solve the state machine.")
        exit()
    print(res)
    return res

def analyse_info(arch, cpu):
    """
    Test the existence of SL/L type MDP.

    HSL/O type test is not included in this version.

    Args:
        arch (str): Target architecture name
        cpu (int): Target core ID

    Returns:
        (bool, bool): 
            - store_MDP_exist: whether the SL type MDP exists
            - load_MDP_exist: whether the L type MDP exists
    """
    store_MDP_exist = True
    load_MDP_exist = False
    seq_results = gen_seq(f"100n 10a 100n", arch, cpu, consider_store=True)
    state_R = 0
    state_B = 0
    for i in range(0, 10):
        if (seq_results[0][1][100 + i] == 'R'):
            state_R += 1
        else:
            continue
    for i in range(0, 100):
        if (seq_results[0][1][110 + i] == 'B'):
            state_B += 1
        else:
            continue        
    if (state_R == 10 or state_B == 100):
        # Both store and load info are used.
        # Particularly, if n cannot update MDP state,
        # We cannot tell whether store MDP exists in this way.
        # TODO: find a better way to avoid this case,
        # maybe multiple loads should be used.
        store_MDP_exist = False
    if not store_MDP_exist:
        seq_results = gen_seq(f"100n 10a 100n", arch, cpu,
                        consider_store=False, test_mdp_ld_when_consider_store=False)
    else:
        seq_results = gen_seq(f"100n 10a 100n", arch, cpu,
                        consider_store=True, test_mdp_ld_when_consider_store=True)        
    state_R = 0
    state_B = 0
    for i in range(0, 10):
        if (seq_results[0][1][100 + i] == 'R'):
            state_R += 1
        else:
            continue
    for i in range(0, 100):
        if (seq_results[0][1][110 + i] == 'B'):
            state_B += 1
        else:
            continue  
    if (state_B > 0 and state_R < 10):
        # Both store and load info are used
        load_MDP_exist = True
    print("store-load MDP exist:", store_MDP_exist, ", load MDP exist:", load_MDP_exist)
    return store_MDP_exist, load_MDP_exist

def analyse_sm_existence(arch, cpu, consider_store, 
            test_mdp_ld_when_consider_store):
    """
    Test whether the state machine exists.

    Args:
        arch (str): Target architecture name
        cpu (int): Target core ID
        consider_store (bool, optional): Whether store PC should be
            considered when generating operators. Defaults to False
        test_mdp_ld_when_consider_store (bool, optional): Controls how store-load pairs
            are generated when `consider_store` is enabled. Defaults to False

    Returns:
        bool: Whether the state machine is used. If the state machien is not used, 
              the independent store-load pairs do not update the prediction
    """
    seq_results = gen_seq(f"100n 10a 100n", arch, cpu, consider_store,
                          test_mdp_ld_when_consider_store)
    state_B = 0
    for i in range(0, 100):
        if (seq_results[0][1][110 + i] == 'B'):
            state_B += 1
        else:
            continue
    return state_B < 100

def test_sm(arch, cpu):
    """
    Test the design type and the state machine of an MDP.

    Args:
        arch (str): Architecture information from [intel, amd, arm, apple, neoverse]
        cpu (str): Target core ID

    Returns:
        None
    """

    print("Step 2: Test the state machine of MDP ...")
    # Collect traces
    # gen_seq("100n10x40n", arch, clear_original_file=True)
    # gen_seq("100n10a10x40n", arch)
    # gen_seq("40na40na40na10x40n", arch)
    # gen_seq("100n1a100n", arch, consider_store=True, 
    #         test_mdp_ld_when_consider_store=False)
    # parse_output(True)
    # 
    build(arch)
    store_MDP_exist, load_MDP_exist = analyse_info(arch, cpu)
    store_sm = []
    load_sm = []
    if (store_MDP_exist):
        sm_store_exist = analyse_sm_existence(arch, cpu, True, False)
        if (sm_store_exist and load_MDP_exist):
            store_sm = analyse_sm(arch, cpu, True, False)
        elif (sm_store_exist and not load_MDP_exist):
            store_sm = analyse_sm(arch, cpu, False, False)
    if (load_MDP_exist):
        sm_load_exist = analyse_sm_existence(arch, cpu, True, True)
        if (not store_MDP_exist and sm_load_exist):
            load_sm = analyse_sm(arch, cpu, False, False)
        elif (store_MDP_exist and sm_load_exist):
            load_sm = analyse_sm(arch, cpu, True, True)
    # Update the characterization file
    with open(characterization_file, 'r') as f:
        character = json.load(f)
        character["exist"] = load_MDP_exist or store_MDP_exist
        character["state machine"] = {
            "store_exist": store_MDP_exist, 
            "store_sm": store_sm,
            "load_exist": load_MDP_exist,
            "load_sm": load_sm}
    with open(characterization_file, 'w') as f:
        json.dump(character, f)
    print("\033[92m\033[1m[OK]\033[0m State Machine testing runs successfully.")
    return

def sm_gen_prime_seq(arch, cpu):
    """
    Generate store-load sequence to manipulate the MDP state in the rest of tests.

    Args:
        arch (str): Architecture information from [intel, amd, arm, apple, neoverse]
        cpu (str): Target core ID

    Returns:
        None
    """
    character_find = False
    if os.path.isfile(characterization_file):
        with open(characterization_file, 'r') as f:
            character = json.load(f)
            if ("state machine" in character.keys()):
                character_find = True
    if not character_find:
        print("\033[91m\033[1m[Error]\033[0m Cannot find state machine info. Run sm test first.")
        exit()
    if not character["exist"]:
        return
    store_sm = character["state machine"]["store_sm"]
    load_sm = character["state machine"]["load_sm"]
    no_sm = (len(store_sm) == 0) and (len(load_sm) == 0)
    only_single_mdp = (len(store_sm) == 0) ^ (len(load_sm) == 0)
    if no_sm:
        target_seq = '3a'
        character["state machine"]["load_seq"] = target_seq
    elif only_single_mdp:
        best_seq = ""
        parameters = load_sm if len(load_sm) > 0 else store_sm
        k3 = parameters[2]
        k4 = parameters[3]
        k5 = parameters[4]
        kp = parameters[7]
        if k4 <= 0:
            best_seq = f'{kp // k3 + 3}a'
        else:
            max_sim_cnt = 0
            for i in range(kp // k3 + 1, max(parameters)):
                test_seq = f"{i+3}a"
                sim = sm_simulate(parameters, test_seq) 
                sim_cnt = sim[1][0]
                if (sim_cnt > max_sim_cnt):
                    max_sim_cnt = sim_cnt
                    best_seq = test_seq
                    if(sim_cnt == parameters[5]):
                        break
        if len(load_sm) > 0:
            character["state machine"]["load_seq"] = best_seq
        else:
            character["state machine"]["store_seq"] = best_seq
    else: # both store-load mdp and load mdp are implemented
        # Greedy Algorithm
        parameters_store = store_sm
        parameters_load = load_sm
        # Calculate the minimal number of n to clear a counter
        store_clear = (parameters_store[7] // parameters_store[2] +
                        1) * parameters_store[2] - parameters_store[7]
        load_clear = (parameters_load[7] // parameters_load[2] + 
                      1) * parameters_load[2] - parameters_load[7]
        if store_clear < load_clear:
            max_cnt_store = 0
            best_seq_store = ""
            for i in range(0, store_clear):
                test_seq = f"a" if i == 0 else f"a{i}n"
                sim_cnt_store = sm_simulate(parameters_store, test_seq)
                sim_cnt_load = sm_simulate(parameters_load, test_seq)    
                sim_cnt_store_cnt = sim_cnt_store[1][0]
                sim_cnt_load_cnt = sim_cnt_load[1][0]
                if (sim_cnt_load_cnt <= parameters_load[7] and 
                    sim_cnt_store_cnt > parameters_store[7] and
                    sim_cnt_store_cnt > max_cnt_store):
                    max_cnt_store = sim_cnt_store_cnt
                    best_seq_store = test_seq
                    if sim_cnt_store == parameters_store[5]:
                        break
            target_seq_1 = best_seq_store
            max_cnt_load = 0
            best_seq_load = ""
            for i in range(1, max(parameters_load)):
                test_seq = f"a{store_clear}n" * i
                sim_cnt_store = sm_simulate(parameters_store, test_seq)
                sim_cnt_load = sm_simulate(parameters_load, test_seq)    
                sim_cnt_store_cnt = sim_cnt_store[1][0]
                sim_cnt_load_cnt = sim_cnt_load[1][0]
                if (sim_cnt_load_cnt > parameters_load[7] and 
                    sim_cnt_store_cnt <= parameters_store[7]):
                    if(sim_cnt_load_cnt > max_cnt_load):
                        max_cnt_load = sim_cnt_load_cnt
                        best_seq_load = test_seq
                    else:
                        break
            target_seq_2 = best_seq_load
            character["state machine"]["store_seq"] = target_seq_1
            character["state machine"]["load_seq"] = target_seq_2
        else:
            print("\033[91m\033[1m[Warning]\033[0m Unknown case. Simply generate naive sequences")
            target_seq_1 = "3a"
            target_seq_2 = "3a"
    # Update the characterization file
    with open(characterization_file, 'w') as f:
        json.dump(character, f)
    # print("\033[92m\033[1m[OK]\033[0m Sequence for following testing generated successfully.")
    return

def sm_simulate(parameters, seq):
    """
    Simulate a state machine, providing the timing type of a store-load sequence.

    The sequence with character `x` will be expanded.

    Args:
        parameters (list): A 1-counter state machine model with seven parameters
        seq (str): Encoded sequence string describing store-load dependence 

    Returns:
        (list, list):
            - outputs: Output for each input given each input sequence
            - counts: Counter value after each input sequence
    """
    k1 = parameters[0]
    k2 = parameters[1]
    k3 = parameters[2]
    k4 = parameters[3]
    k5 = parameters[4]
    k6 = parameters[5]
    k7 = parameters[6]
    kp = parameters[7]
    input_ = gen_seq_in_text_list(seq)
    inputs = input_[0]
    outputs = [] # Output for each input given each input sequence
    counts = []  # Counter value after each input sequence
    for input in inputs:
        cm_count = 0
        output = []
        for i in input:
            if i == 'n':
                if (cm_count > kp):
                    output.append('B')
                    cm_count += k2
                else:
                    output.append('S')
                    cm_count += k1
            elif i == 'a':
                if (cm_count > kp):
                    output.append('B')
                    cm_count += k4
                else:
                    output.append('R')
                    cm_count += k3
            else:
                print("Bad input format, exit")
            if cm_count > k5:
                if k6 == 0:
                    cm_count = cm_count % k5
                else:
                    cm_count = k5
            if cm_count < 0:
                if k7 == 1:
                    while cm_count < 0:
                        cm_count = cm_count + k5
                else:
                    cm_count = 0
        outputs.append(''.join(output))
        counts.append(cm_count)
    return outputs, counts

            