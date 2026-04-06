import subprocess
import re
import os
import json
from .utils.hash_linear_solver import infer_linear_xor_hash

proj_root = ".."
bin_file = os.path.join(proj_root, "bin", "hash")  # bin/hash
elf = "microbenchmark"
make_file = os.path.join(proj_root, "src", "hash") # src/hash/Makefile
bin_data_flie = os.path.join(proj_root, "bin", "hash") # bin/hash
lib_data_file = os.path.join(proj_root, "data") # data
input_file = os.path.join(bin_data_flie, "in.txt") # bin/hash/in.txt
output_file = os.path.join(bin_data_flie, "out.txt") # bin/hash/out.txt
characterization_file = os.path.join(lib_data_file, "characterization.json") # data/*.json
collide_addr_file = os.path.join(lib_data_file, "collide_addr.json") # data/*.json

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
    # os.system(cmd)
    subprocess.run(cmd, shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    return

def run(sudo = True):
    '''
    Run the testcase.

    Args:
        sudo (bool): If sudo is enabled, the physical addresses can be collected

    Returns:
        None
    '''
    original_dir = os.getcwd()
    d = bin_file
    if os.path.isdir(bin_file):
        os.chdir(d)
        cmd = f"{'sudo' if sudo else ''} ./{elf}"
        e = subprocess.Popen(
            cmd,
            shell=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True
        ).communicate()[0]
    os.chdir(original_dir)
    return

def set_input(operation_list, cpu, expected_sm_val):
    '''
    Build input file of a testcase.

    Args:
        operation_list (list): A list that defines the dependence of a store-load sequence. 
                               For each element, 1 means a dependent store-load pair, while
                               0 means an independent store-load pair
        cpu (int):             Core ID
        expected_sm_val (int): Expected MDP counter value after executing the operations in the operation_list

    Returns:
        None
    '''
    with open(input_file, 'w') as f:
        f.write("{0} {1} {2}\n".format(cpu, len(operation_list), expected_sm_val))
        for i in range(len(operation_list)):
            f.write("{0} ".format(operation_list[i]))
        f.write("\n")
    return

def parse_output():
    '''
    Read the output file and parse the output from the microbenchmark.

    Args:
        None

    Returns:
        (list, list):
            - data_virt: Collided addresses in the virtual address format
            - data_phys: Collided addresses in the physical address format
    '''
    with open(output_file, 'r') as f:
        line = f.read()
        if (len(line) <= 1):
            return [], []
        data = line.strip().split(" ")
        data_virt = [int(data[i], 16) for i in range(0, len(data), 2)]
        data_phys = [int(data[i], 16) for i in range(1, len(data), 2)]
    return data_virt, data_phys

def gen_seq_in_text_list(raw_sequence):
    """
    Generate operation sequences from a compressed sequence string.

    Args:
        raw_sequence (str): Encoded sequence string describing store-load dependence

    Returns:
        list: Corresponding numeric operations (1 = 'a', 0 = 'n')
    """
    raw_sequence_combine = ''.join(i.strip() for i in raw_sequence)
    raw_sequence_combine_list = re.split(r"(\d+)", raw_sequence_combine)
    sequences_in_text = str()
    repeat_n = 1
    for s in raw_sequence_combine_list:
        if (len(s) == 0):
            continue
        elif (len(s) > 0 and s.isdigit()):
            repeat_n = int(s)
            assert(repeat_n > 0)
        else:
            sequences_in_text += repeat_n * s[0]
            sequences_in_text += s[1:]
            repeat_n = 1
    ops = []
    for c in sequences_in_text:
        assert(c == 'n' or c == 'a')
        if (c == 'n'):
            ops.append(0)
        else:
            ops.append(1)
    return ops

def hash_solver_wrapper(character, filter=False):
    """
    Call the hash function solver after collided address collection.

    Args:
        character (map): The map that contains the MDP characters
        filter (bool): Whether filter the noise addresses. False by default

    Returns:
        (list, bool):
            - hash_mdp (list): The hash function matrix
            - is_va (bool): Whether the virtual address is used as the input
                            If not, the physical address is then used
    """
    assert(character["state machine"]["store_exist"] or character["state machine"]["load_exist"])
    with open(collide_addr_file, 'r') as f:
        data = json.load(f)
    data_va = []
    data_pa = []
    if filter:
        # Remove adjacent addresses
        for i in range(len(data[0][0]) - 1):
            if data[0][0][i + 1] - data[0][0][i] > 0x10:
                data_va.append(data[0][0][i])
                data_pa.append(data[0][1][i])
        # Find Common Suffix for virtual addresses
        max_comman_suffix = 0
        max_comman_suffix_bitlen = 0
        for l in range(16, 3, -1):
            common_suffix_cnt = {}
            for i in range(len(data_va)):
                suffix = data_va[i] & ((1 << l) - 1)
                if suffix not in common_suffix_cnt.keys():
                    common_suffix_cnt[suffix] = 1
                else:
                    common_suffix_cnt[suffix] += 1
            for suffix in common_suffix_cnt.keys():
                if common_suffix_cnt[suffix] > len(data_va) * 0.9:
                    max_comman_suffix = suffix
                    max_comman_suffix_bitlen = l
                    break
            if (max_comman_suffix > 0):
                break
        if max_comman_suffix > 0:
            data_va_cpy = data_va[:]
            for a in data_va_cpy:
                if a & ((1 << max_comman_suffix_bitlen) - 1) != max_comman_suffix:
                    if a in data_va:
                        data_va.remove(a)
    else:
        data_va = data[0][0]
        data_pa = data[0][1]
    # print(data_va, data_pa)

    if (len(data_va) <= 1 and len(data_pa) <= 1):
        print("\033[91m\033[1m[Error]\033[0m Cannot solve hash function.")
        exit()

    if character["state machine"]["store_exist"] or character["state machine"]["load_exist"]:
        h1 = infer_linear_xor_hash(data_va, 64, auto_calibration=True)
        h2 = infer_linear_xor_hash(data_pa, 48, auto_calibration=True)
        hash_mdp = []
        is_va = True
        if (len(h1) > 0):
            hash_mdp = h1
        elif (len(h2) > 0):
            hash_mdp = h2
            is_va = False
        return hash_mdp, is_va

def test_hash(arch, cpu, user_mode = False, collect_addr = False):
    """
    Test the hash function of an MDP.

    Args:
        arch (str): Architecture information from [intel, amd, arm, apple, neoverse]
        cpu (str): Target core ID
        collect_addr: If the collided addresses have been collected,
                      providing its path can skip the address collection process.
                      False by default.

    Returns:
        None
    """
    print("Step 3: Test the hash function of MDP ...")
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
    collide_addr_find = False
    if os.path.isfile(collide_addr_file):
        with open(collide_addr_file, 'r') as f:
            collide_addrs = json.load(f)
            if len(collide_addrs) > 0:
                collide_addr_find = True
    if character["state machine"]["store_exist"] or character["state machine"]["load_exist"]:
        if character["state machine"]["store_exist"] and character["state machine"]["load_exist"]:
            sm = character["state machine"]["load_sm"]
            seq_for_re = character["state machine"]["load_seq"]
        elif character["state machine"]["store_exist"]:
            sm = character["state machine"]["store_sm"]
            seq_for_re = character["state machine"]["store_seq"]
        elif character["state machine"]["load_exist"]:
            sm = character["state machine"]["load_sm"]
            seq_for_re = character["state machine"]["load_seq"]
        if len(sm) == 0:
            expected_sm_val = 0
        else:
            parameter_sm = sm
            expected_sm_val = parameter_sm[4] - parameter_sm[7]
    if not collide_addr_find or collect_addr: # Collect collided addresses, which is time consuming
        print("Collecting collided addresses, which takes a few minutes or hours.")
        print("To get physical address, privilege is required here.")
        if arch == "apple":
            print("\033[93m\033[1m[Warning]\033[0m Physical address is not accessible on macOS.")
        collide_addr = []
        build(arch)
        set_input(gen_seq_in_text_list(seq_for_re), cpu, expected_sm_val)
        if arch == "apple" or user_mode: 
            run(False)
        else:
            run()
        data_virt, data_phys = parse_output()
        collide_addr.append([data_virt, data_phys])
        print("Collided addresses collected successfully.")
        with open(collide_addr_file, 'w') as f:
            json.dump(collide_addr, f)
    hash_functions, addr_feature = hash_solver_wrapper(character, filter=True)
    # print(hash_functions)
    if arch != "intel" and arch != "amd":  # PCs are 4-byte aligned, so the 2 LSBs are always 0
        hf_ = hash_functions[:]
        for h in hf_:
            h_ = h[:]
            for b in h_:
                if b in [0, 1]:
                    h.remove(b)
            if len(h) == 0:
                hash_functions.remove(h)
    character["hash"] = {}
    character["hash"]["hash_func"] = hash_functions
    character["hash"]["hash_va"] = addr_feature
    character["hash"]["hash_seq"] = seq_for_re
    character["hash"]["expected_sm_val"] = expected_sm_val
    with open(characterization_file, 'w') as f:
        json.dump(character, f)    
    print("\033[92m\033[1m[OK]\033[0m Hash test completes.")
    return