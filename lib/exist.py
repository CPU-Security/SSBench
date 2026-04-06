import subprocess
import re
import os
import json

from .utils.cluster import cluster_timing_data

proj_root = ".."
bin_file = os.path.join(proj_root, "bin", "exist")  # bin/exist
elf = "microbenchmark"
make_file = os.path.join(proj_root, "src", "exist") # src/exist/Makefile
bin_data_flie = os.path.join(proj_root, "bin", "exist") # bin/exist
lib_data_file = os.path.join(proj_root, "data") # data
input_file = os.path.join(bin_data_flie, "in.txt") # bin/exist/in.txt
output_file = os.path.join(bin_data_flie, "out.txt") # bin/exist/out.txt
characterization_file = os.path.join(lib_data_file, "characterization.json") # data/*.json
collided_addr_file = os.path.join(lib_data_file, "collide_addr.json") # data/*.json


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

def set_input(operation_list, cpu):
    '''
    Build input file of a testcase.

    Args:
        operation_list (list): A list that defines the dependence of a store-load sequence. 
                               For each element, 1 means a dependent store-load pair, while
                               0 means an independent store-load pair
        cpu (int):             Core ID

    Returns:
        None
    '''
    with open(input_file, 'w') as f:
        f.write("{0} {1}\n".format(cpu, len(operation_list)))
        for i in range(len(operation_list)):
            f.write("{0} ".format(operation_list[i]))
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
        assert(len(data) == 2 * len(op_list))
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
            print("({2:<2})[{0}]{1}".format("a" if flag_list[j + k] == 1 else "n", time_list[j + k], j + k), end = " ")
        print()
    return

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
    # Parse numeric repetition
    raw_sequence_combine = ''.join(i.strip() for i in raw_sequence)
    raw_sequence_combine_list = re.split(r"(\d+)", raw_sequence_combine)

    sequence_in_text_with_x = str()
    repeat_n = 1

    for s in raw_sequence_combine_list:
        if len(s) == 0:
            continue
        elif s.isdigit():
            repeat_n = int(s)
            assert repeat_n > 0
        else:
            sequence_in_text_with_x += repeat_n * s[0]
            sequence_in_text_with_x += s[1:]
            repeat_n = 1

    # Handle 'x' (generate all combinations)
    sequences_in_text = []
    idx_list = []

    for i in range(len(sequence_in_text_with_x)):
        if sequence_in_text_with_x[i] == 'x':
            idx_list.append(i)

    for i in range(2 ** len(idx_list)):
        sequence_in_text_without_x = sequence_in_text_with_x
        for j in range(len(idx_list)):
            sequence_in_text_without_x = (
                sequence_in_text_without_x[0:idx_list[j]] +
                ('n' if (i >> j) & 1 == 0 else 'a') +
                sequence_in_text_without_x[idx_list[j] + 1:]
            )
        sequences_in_text.append(sequence_in_text_without_x)

    # Convert to numeric ops
    ops_list = []
    for sequence in sequences_in_text:
        ops = []
        for c in sequence:
            assert c in ('n', 'a')
            ops.append(0 if c == 'n' else 1)
        ops_list.append(ops)

    return sequences_in_text, ops_list

def exp_timing_type(cpu):
    """
    Detect different timing categories (SSB, BLK, ROL) using clustering.

    Args:
        cpu (str): Target core ID

    Returns:
        dict:
            {
                'S': ssb_cluster,
                'B': blk_cluster,
                'R': rol_cluster,
                'b1': threshold between SSB and BLK,
                'b2': threshold between BLK and ROL,
                'b3': threshold between ROL and noise
            }
        Returns empty dict if classification fails
    """

    def range_cover(range_1, range_2):
        """Check if all ranges in range_1 are fully covered by range_2."""
        for r1 in range_1:
            covered = False
            for r2 in range_2:
                if r1[0] >= r2[0] and r1[1] <= r2[1]:
                    covered = True
                    break
            if not covered:
                return False
        return True

    def range_overlap(range_1, range_2):
        """Check if any range in range_1 overlaps with range_2."""
        for r1 in range_1:
            for r2 in range_2:
                if not (r1[1] < r2[0] or r2[1] < r1[0]):
                    return True
        return False

    def range_bnd(range_1):
        """Get global lower and upper bounds of a range set."""
        l = 1e7
        u = -1
        for r in range_1:
            if r[0] < l:
                l = r[0]
            if r[1] > u:
                u = r[1]
        return l, u

    # SSB
    seq_in_text = "100n 100n"
    seq_list, ops_list = gen_seq_in_text_list(seq_in_text)
    times, flags = experiment(cpu, ops_list[0], repeat_times=100)

    timing = []
    for i in range(len(times)):
        timing.extend(times[i][100:])

    ssb_cluster = cluster_timing_data(timing, 2.0, 50, True)

    # BLK and ROL
    seq_in_text = "100n 100a"
    seq_list, ops_list = gen_seq_in_text_list(seq_in_text)
    times, flags = experiment(cpu, ops_list[0], repeat_times=100)

    timing = []
    for i in range(len(times)):
        timing.extend(times[i][100:])

    blk_cluster = cluster_timing_data(timing, 2.0, 1000, True)

    timing = []
    for i in range(len(times)):
        timing.append(times[i][100])

    rol_cluster = cluster_timing_data(timing, 2.0, 50, True)

    # Validate cluster relationships
    if range_overlap(ssb_cluster, blk_cluster):
        return {}

    for r in rol_cluster:
        for b in blk_cluster:
            if range_cover([r], [b]):
                blk_cluster.remove(b)

    if len(blk_cluster) == 0:
        return {}

    _, ssb_upper_bnd = range_bnd(ssb_cluster)
    blk_lower_bnd, blk_upper_bnd = range_bnd(blk_cluster)
    rol_lower_bnd, rol_upper_bnd = range_bnd(rol_cluster)

    # Different timing categories
    type_time_dict = {
        'S': ssb_cluster,
        'B': blk_cluster,
        'R': rol_cluster,
        'b1': (blk_lower_bnd + ssb_upper_bnd) // 2,
        'b2': (blk_upper_bnd + rol_lower_bnd) // 2,
        'b3': rol_upper_bnd + rol_upper_bnd // 2
    }

    if type_time_dict['b2'] > rol_lower_bnd:
        return {}

    print(type_time_dict)
    return type_time_dict

def experiment(cpu, sequence=[], repeat_times=1, formatted_print=False):
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
        set_input(operation_list=sequence, cpu=cpu)
        run()
        f, t = parse_output(formatted_print)
        times.append(t)
        flags.append(f)
    return times, flags

def test_existence(arch, cpu):
    """
    Test whether timing differences of store-load pairs can be observed.

    Args:
        arch (str): Architecture information from [intel, amd, arm, apple, neoverse]
        cpu (str): Target core ID

    Returns:
        None
    """
    print("Step 1: Test the existence of MDP ...")
    build(arch)

    if os.path.isfile(characterization_file):
        os.remove(characterization_file)
    if os.path.isfile(collided_addr_file):
        os.remove(collided_addr_file)

    # Run experiment and detect timing types
    type_seq = exp_timing_type(cpu)

    if len(type_seq.keys()) == 6:
        character = {'type_time_dict': type_seq}
        print("\033[92m\033[1m[OK]\033[0m Observe the timing difference of store-load pairs.")
    else:
        print("\033[92m\033[1m[OK]\033[0m Cannot observe the timing difference of store-load pairs!")
        character = {'exist': False}

    # Save analysis result
    with open(characterization_file, 'w') as f:
        json.dump(character, f)