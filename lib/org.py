import subprocess
import re
import os
import json
import random
from tqdm import tqdm
from .utils.hash_linear_solver import infer_linear_xor_hash

proj_root = ".."
bin_file = os.path.join(proj_root, "bin", "org")  # bin/org
elf_org = "microbenchmark"
elf_mem = "mem"
make_file = os.path.join(proj_root, "src", "org") # src/org/Makefile
bin_data_flie = os.path.join(proj_root, "bin", "org") # bin/org
lib_data_file = os.path.join(proj_root, "data") # data
input_file = os.path.join(bin_data_flie, "in.txt") # bin/org/in.txt
output_file = os.path.join(bin_data_flie, "out.txt") # bin/org/out.txt
characterization_file = os.path.join(lib_data_file, "characterization.json") # data/*.json
collide_addr_file = os.path.join(lib_data_file, "eviction.json") # data/*.json


def build(arch):
    '''
    Build testcase.

    Args:
        arch (str): Architecture information from [intel, amd, arm, apple, neoverse]

    Returns:
        None
    '''
    if arch == "apple":
        cmd = f"make -C {make_file} -f make.apple arch={arch} clean && make -C {make_file} -f make.apple arch={arch}"
    else:
        cmd = f"make -C {make_file} arch={arch} clean && make -C {make_file} arch={arch}"
    # print(cmd)
    # os.system(cmd)
    subprocess.run(cmd, shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    return

def run(bin, sudo = True):
    '''
    Run the testcase.

    Args:
        bin (str):   ELF to be executed
        sudo (bool): If sudo is enabled, the physical addresses can be accessed

    Returns:
        None
    '''
    original_dir = os.getcwd()
    d = bin_file
    if os.path.isdir(bin_file):
        os.chdir(d)
        cmd = f"{'sudo' if sudo else ''} ./{bin}"
        try:
            e = subprocess.Popen(
                cmd,
                shell=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                text=True
            )
            e.communicate(timeout=3600)[0]
        except subprocess.TimeoutExpired:
            print("\033[93m\033[1m[Warning]\033[0m Testcase timeout, killed.")
            e.kill()
    os.chdir(original_dir)
    return

def set_input_mem(op, fixed_va):
    '''
    Build input file for mem.
    '''
    with open(input_file, 'w') as f:
        f.write("{0} {1}\n".format(op, fixed_va))

def set_input_org(operation_list, cpu, expected_sm_val, is_store_mdp, fixed_va, num_hash, ld_insert_position, ld_hash, cmd1, cmd2):
    '''
    Build input file for microbenchmark.
    '''
    with open(input_file, 'w') as f:
        f.write("{0} {1}\n".format(cmd1, cmd2))
        f.write("{0} {1} {2} {3} {4}\n".format(cpu, len(operation_list), expected_sm_val, is_store_mdp, fixed_va))
        for i in range(len(operation_list)):
            f.write("{0} ".format(operation_list[i]))
        assert(len(ld_insert_position) == len(ld_hash))
        f.write(f"\n{1 << num_hash} {len(ld_hash)}\n")
        for i in range(len(ld_insert_position)):
            f.write("{0} ".format(ld_insert_position[i]))
        f.write("\n")
        for i in range(len(ld_hash)):
            f.write("{0} ".format(ld_hash[i]))
        f.write("\n")

def parse_output_mem(arch, character, hash_id):
    '''
    Read the output file and parse the output from mem.
    '''
    data = []
    if arch == "intel" or arch == "amd":
        '''
        movq 0(%rsi), %rax
        jmp *%rbx
        '''
        ins_seg_size = 6 
        nop_size = 1
    elif arch == "arm" or arch == "apple":
        '''
        ldr x7, [x7]
        br x11
        '''
        ins_seg_size = 8 
        nop_size = 4
    else:
        ins_seg_size = 0 
        nop_size = 0           
    
    # Load output file
    with open(output_file, 'r') as f:
        lines = f.read().strip().split("\n")
        if (len(lines) == 1):
            return int(lines[0], 16), [], []
        else:
            data = [int(i, 16) for i in lines[1].strip().split(" ")]
    va = [data[i] for i in range(0, len(data), 2)]
    pa = [data[i] for i in range(1, len(data), 2)]

    # Load Hash Function
    hash_func_orig = character["hash"]["hash_func"]
    for i in range(len(hash_func_orig)):
        hash_func_orig[i] = sorted(hash_func_orig[i])
    hash_func = sorted(hash_func_orig, key=lambda x: x[0])
    is_va = character["hash"]["hash_va"]
    print(hash_func)

    def h(val):
        # Compute integer from outputs specified by XOR combinations
        y = 0
        for j, idxs in enumerate(hash_func):
            s = 0
            for i in idxs:
                s ^= (val >> i) & 1
            y |= (s << j)
        return y
    hash_output_size = (1 << len(hash_func))
    # if hash_output_size > 4096: # Enumerate 4096 hash values only
    #     hash_output_size = 4096

    # Compute load PC
    covered_hash = set()
    pg_info = va if is_va else pa
    i = va[0]
    add_point = []
    while i < va[-1] + 0xfff:
        pg_id = (i - va[0]) >> 12
        h_i = h(pg_info[pg_id] | (i & 0xfff))
        if h_i not in covered_hash:
            covered_hash.add(h_i)
            add_point.append(i - va[0])
            if (hash_output_size == len(covered_hash)):
                break
            i += ins_seg_size
            if arch == "arm":
                i += 256 - ins_seg_size
        else:
            i += nop_size 
    ld_hash = []
    for i in range(len(add_point)):
        addr = va[0] + add_point[i]
        pg_id = add_point[i] >> 12
        ld_hash.append(h(pg_info[pg_id] | (addr & 0xfff)))
    pairs = list(zip(add_point, ld_hash))
    random.shuffle(pairs)
    add_point, ld_hash = zip(*pairs)
    # print(len(add_point), arch)
    if 'intel' in arch or 'amd' in arch:
        if len(add_point) > 4096:
            add_point = add_point[:4096]
            ld_hash = ld_hash[:4096]
    if 'arm' in arch or 'apple' in arch or 'neoverse' in arch:
        if len(add_point) > 1024:
            add_point = add_point[:1024]
            ld_hash = ld_hash[:1024]
    return int(lines[0], 16), add_point, ld_hash
        
def parse_output_org():
    '''
    Read the output file and parse the output from microbenchmark.
    '''
    with open(output_file, 'r') as f:
        o = f.read()
        # tqdm.write(o)
        return o

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

def get_rep_pol(pi_input):
    """
    Solve the replacement policy of an MDP from the original output.
    """
    def gen_pi(k):
        if k == 4:
            lru = [[0,1,2,3],[1,0,2,3],[2,0,1,3],[3,0,1,2],[0,1,2,3]]
            plru = [[0,1,2,3],[1,0,3,2],[2,1,0,3],[3,0,1,2],[0,1,2,3]]
            fifo = [[0,1,2,3],[0,1,2,3],[0,1,2,3],[0,1,2,3],[0,1,2,3]]
            nlru = [[0,1,2,3],[1,2,3,0],[2,0,3,1],[3,0,1,2],[0,1,2,3]]
            return {"lru": lru, "plru": plru, "fifo": fifo, "nlru": nlru}
        elif k == 3:
            lru = [[0,1,2],[1,0,2],[2,0,1],[0,1,2]]
            fifo = [[0,1,2],[0,1,2],[0,1,2],[0,1,2]]
            return {"lru": lru, "fifo": fifo}
        elif k == 2:
            lru = [[0,1],[1,0],[0,1]]
            fifo = [[0,1],[0,1],[0,1]]
            return {"lru": lru, "fifo": fifo}
        else:
            return {}
    def normalize_pi(pi):
        # In org.c, the original order is 0,1,2,3 where 3 is the most recent element,
        # and the output is a permutation of 0,1,2,3, 
        # where x0,x1,x2,x3 means the eviction priority of 0,1,2,3.
        # We need to normalize it to the definition of pi.
        real_pi = []
        for p in pi:
            real_p = [0 for i in range(len(p))]
            # fix -1 elements
            for i in range(len(p)):
                if p[i] == -1:
                    for j in range(len(p)):
                        if j not in p:
                            p[i] = j
            # get pi from original output
            for i in range(len(p)):
                real_p[len(p) - 1 - p[i]] = i
            for i in range(len(p)):
                real_p[i] = len(p) - 1 - real_p[i]
            real_pi.append(real_p)
        real_pi = real_pi[:-1][::-1] + [real_pi[-1]]
        return real_pi

    pi_hash = lambda pi: ''.join([''.join([str(i) for i in p]) for p in pi])
    # Find the most frequent pi
    pi_cnt = {}
    pi_most_freq = []
    max_pi_cnt = 0
    for pi in pi_input:
        pi_hashed = pi_hash(pi)
        if pi_hashed not in pi_cnt.keys():
            pi_cnt[pi_hashed] = 1
        else:
            pi_cnt[pi_hashed] += 1
        if pi_cnt[pi_hashed] > max_pi_cnt:
            max_pi_cnt = pi_cnt[pi_hashed]
            pi_most_freq = pi
    pi = normalize_pi(pi_most_freq)
    rep_dict = gen_pi(len(pi) - 1)
    pi_hash = lambda pi: ''.join([str(i) for i in pi])
    rep_cnt_dict = {}
    for p in rep_dict.keys():
        rep_cnt_dict[p] = 0
        for i in range(len(pi)):
            if pi_hash(pi[i]) == pi_hash(rep_dict[p][i]):
                rep_cnt_dict[p] += 1
    rep_cnt_max = 0
    all_freq = 0
    rep = "random"
    for p in rep_cnt_dict.keys():
        all_freq += rep_cnt_dict[p]
        if (rep_cnt_dict[p] > rep_cnt_max):
            rep_cnt_max = rep_cnt_dict[p]
            rep = p
    print(rep_cnt_dict)
    return rep, rep_cnt_max / len(pi)

def test_org_eviction_set_size(num_try = 10):
    """
    Test the minimal eviction set size of an MDP.
    """
    cnt = {}
    res = -1
    print("Testing eviction size:")
    for i in tqdm(range(num_try), ncols=80, dynamic_ncols=True, leave=False):
        run(elf_org, sudo=False)
        e = parse_output_org().strip()
        if len(e) > 0 and len(e.split("\n")) == 1:
            v = int(e)
            if (v not in cnt.keys()):
                cnt[v] = 1
            else:
                cnt[v] += 1
            # early stop
            early_stop = False
            if i >= 3:
                for v in cnt.keys():
                    if cnt[v] >= (i + 1) // 2 + 1:
                        early_stop = True
            if early_stop:
                break
    print(cnt)
    max_cnt = 0
    all_freq = 0
    for v in cnt.keys():
        all_freq += cnt[v]
        if cnt[v] > max_cnt:
            max_cnt = cnt[v]
            res = v
    return res, all_freq / all_freq

def test_org_replacement_policy(num_try = 10):
    """
    Test the replacement policy of an MDP.
    """
    cnt = {}
    res = -1
    print("Testing replacement policy:")
    tested_org = {}
    for i in tqdm(range(num_try), ncols=80, dynamic_ncols=True, leave=False):
        run(elf_org, sudo=False)
        e = parse_output_org().strip()
        pi_size = -2
        pi_raw_all = []
        if len(e) > 0 and len(e.split("\n")) >= 6:
            e = e.strip().split("\n")
            pi_size = int(e[0].strip())
            if (len(e) % (pi_size + 2) != 0):
                continue
            for j in range(0, len(e), pi_size + 2):
                pi_raw = []
                for k in range(1, pi_size + 2):
                    pi_raw.append([int(d) for d in e[j + k].strip().split(" ")])
                pi_raw_all.append(pi_raw)
            rep, conf = get_rep_pol(pi_raw_all)
            print(rep, conf)
            if rep not in tested_org.keys():
                tested_org[rep] = [1, conf]
            else:
                v1 = tested_org[rep][0]
                v2 = tested_org[rep][1]
                tested_org[rep] = [v1 + 1, v2 + conf]
                # early stop
                early_stop = False
                if i >= 3:
                    for p in tested_org.keys():
                        if tested_org[p][0] >= (i + 1) // 2 + 1:
                            early_stop = True
                if early_stop:
                    break
    res = ''
    max_cnt = 0
    conf = 0
    print(tested_org)
    if len(tested_org.keys()) > 0:
        for p in tested_org.keys():
            if tested_org[p][0] > max_cnt:
                max_cnt = tested_org[p][0]
                res = p
        conf = tested_org[res][1] // tested_org[res][0]
    else:
        res = 'none'
    return res, conf
    

def test_org_parameters(num_try = 5):
    """
    Test the table size, associativity and index bits of an MDP.
    """
    print("Testing other structure parameters:")
    max_cnt = 0
    all_freq = 0
    best_d = [0, 0, 0]

    while(max_cnt == 0): # loop until we have at least one positive result
        tested_org = {}
        for i in tqdm(range(num_try), ncols=80, dynamic_ncols=True, leave=False):
            run(elf_org, sudo=False)
            e = parse_output_org().strip()
            if len(e) > 0 and len(e.split("\n")) == 1:
                d = [int(i) for i in e.strip().split(" ")]
                if (d.count(0) == 3):
                    continue
                if str(d) not in tested_org.keys():
                    tested_org[str(d)] = [d, 1]
                else:
                    tested_org[str(d)][1] += 1
        print(tested_org)
        for d in tested_org.keys():
            all_freq += tested_org[d][1]
            if tested_org[d][1] > max_cnt:
                max_cnt = tested_org[d][1]
                best_d = tested_org[d][0]
    return best_d, max_cnt / all_freq

def test_org(arch, cpu):
    """
    Test the organization parameters of an MDP.

    Args:
        arch (str): Architecture information from [intel, amd, arm, apple, neoverse]
        cpu (str): Target core ID

    Returns:
        None
    """
    print("Step 4: Test the organization parameters of MDP ...")
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
    if not character["hash"]:
        return

    if arch == "apple":
        print("\033[93m\033[1m[Warning]\033[0m Physical address is not accessible on macOS.")

    build(arch)
    # 1. Create a file map with the same virtual and physical addresses
    set_input_mem(0, 0)
    run(elf_mem, sudo=False)
    fixed_addr, _, _ = parse_output_mem(arch, character, 0)
    set_input_mem(1, fixed_addr)
    if arch == "apple" or character["hash"]["hash_va"]: 
        run(elf_mem, sudo=False)
    else:
        run(elf_mem, sudo=True)
    fixed_addr, ld_offset_table, ld_hash_table = parse_output_mem(arch, character, 0)

    # 2. Organization test
    seq = character["hash"]["hash_seq"]
    expected_sm_val = character["hash"]["expected_sm_val"]
    hash_len = len(character["hash"]["hash_func"])
    character["org"] = {}
    # 2.1 Get the eviction size
    set_input_org(gen_seq_in_text_list(seq), cpu, expected_sm_val, 0, fixed_addr, 
                    hash_len, ld_offset_table, ld_hash_table, 0, 5)
    eviction_set_size, conf = test_org_eviction_set_size()
    print(f"eviction_set_size = {eviction_set_size}")
    character["org"]["eviction_set_size"] = eviction_set_size
    character["org"]["confidence_eviction_set_size"] = conf
    if (eviction_set_size + 1 == len(ld_hash_table)):
        # Direct mapping, no replacement policy
        print(f"Direct mapping tested.")
        character["org"]["size"] = (1 << hash_len) - 1
        character["org"]["set"] = (1 << hash_len) - 1
        character["org"]["set_index"] = (1 << hash_len) - 1
        character["org"]["replacement_policy"] = "none"
        character["org"]["confidence_replacement_policy"] = 1
        character["org"]["confidence_parameters"] = 1
    else:
        # 2.2 Test replacement policy
        set_input_org(gen_seq_in_text_list(seq), cpu, expected_sm_val, 0, fixed_addr, 
                        hash_len, ld_offset_table, ld_hash_table, 1, eviction_set_size)
        rep, conf = test_org_replacement_policy(10)
        print(f"replacement_policy = {rep}")
        character["org"]["replacement_policy"] = rep
        character["org"]["confidence_replacement_policy"] = conf
        # 2.3 Test other parameters
        set_input_org(gen_seq_in_text_list(seq), cpu, expected_sm_val, 0, fixed_addr, 
                        hash_len, ld_offset_table, ld_hash_table, 2, eviction_set_size)
        par, conf = test_org_parameters()
        print(f"parameters: size = {par[0]}, set = {par[1]}, set index = {par[2]}")
        character["org"]["size"] = par[0]
        character["org"]["set"] = par[1]
        character["org"]["set_index"] = par[2]
        character["org"]["confidence_parameters"] = conf

    with open(characterization_file, 'w') as f:
        json.dump(character, f)    
    # 3. Release the space
    set_input_mem(2, 0)
    run(elf_mem, sudo=False)
    print("\033[92m\033[1m[OK]\033[0m Org test completes.")
