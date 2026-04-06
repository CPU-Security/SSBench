import platform
import argparse
import os
import time
import json
import cpuinfo
from lib import exist,sm,hash,org

def get_sysinfo():
    """
    Detect the current system information, including OS, ISA, and CPU vendor/type.

    The function identifies the platform using `platform.system()` and
    `platform.machine()`, then applies platform-specific logic to infer
    a normalized CPU category.

    Returns:
        dict: A dictionary containing:
            - sys_os (str): Operating system name in lowercase
            - sys_cpu (str): Normalized CPU type
              (e.g. "intel", "amd", "apple", "arm", "neoverse", "Unknown")
            - sys_isa (str): Instruction set architecture name in lowercase
    """
    sys_os = platform.system().lower()
    sys_isa =platform.machine().lower()
    sys_cpu = ''
    sys_vendor = ''
    if sys_isa == "x86_64" and sys_os == "linux":
        with open("/proc/cpuinfo") as f:
            for line in f:
                if line.startswith("vendor_id"):
                    sys_vendor = line.strip().split(":")[1].strip()
                    break
        if "Intel" in sys_vendor:
            sys_cpu = "intel"
        elif "AMD" in sys_vendor:
            sys_cpu = "amd"
    elif sys_isa == "arm64" and sys_os == "darwin":
        sys_cpu = "apple"
    elif sys_isa == "aarch64" and sys_os == "linux":
        info = cpuinfo.get_cpu_info()
        if "Neoverse" in info['brand_raw']:
            sys_cpu = "neoverse"
        else:
            sys_cpu = "arm"
    else:
        sys_cpu = "Unknown"
    return {"sys_os": sys_os, "sys_cpu": sys_cpu, "sys_isa": sys_isa}

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='SSBench: characterize MDP automatically across various CPUs.')

    parser.add_argument("-a", "--arch", type=str, default='',
                        help="Specify architecture from [intel, amd, arm, apple, riscv]")
    parser.add_argument("-c", "--cpu", type=int, default=0,
                        help="Specify the tested CPU ID")
    args = parser.parse_args()

    # If no architecture is provided, detect it from the current system
    if args.arch == '':
        sys_info = get_sysinfo()
        original_dir = os.getcwd()
        arch = sys_info["sys_cpu"]
    else:
        arch = args.arch
        original_dir = os.getcwd()

    # Enter the library directory and run all characterization stages
    os.chdir("lib")
    t1 = time.time()
    exist.test_existence(arch, args.cpu)
    t2 = time.time()
    sm.test_sm(arch, args.cpu)
    sm.sm_gen_prime_seq(arch, args.cpu)
    t3 = time.time()
    hash.test_hash(arch, args.cpu)
    t4 = time.time()
    org.test_org(arch, args.cpu)
    t5 = time.time()
    os.chdir(original_dir)
    characterization_file = os.path.join("data", "characterization.json")
    if os.path.isfile(characterization_file):
        character = {}
        with open(characterization_file, 'r') as f:
            character = json.load(f)
        character["time"] = {"exist": t2 - t1, "sm": t3 - t2, "hash": t4 - t3, "org": t5 - t4}
        with open(characterization_file, 'w') as f:
            json.dump(character, f)