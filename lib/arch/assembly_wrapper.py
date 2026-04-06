
class instruction(object):
    def __init__(self, text, mc):
        self.text = text 
        self.mc = mc
    def get_assembly(self):
        return self.text
    def get_mc(self):
        return self.mc

class mul_store_addr(instruction):
    def __init__(self, sys_info):
        if sys_info["sys_isa"] == "x86_64":
            super().__init__(["imul $1, %rdi"], [[72, 107, 255, 1]])
        elif sys_info["sys_isa"] == "arm64":
            super().__init__(["imul x0, x0, x2"], [[0, 124, 2, 155]])
        else:
            super().__init__([], [])

class mul_load_des(instruction):
    def __init__(self, sys_info):
        if sys_info["sys_isa"] == "x86_64":
            super().__init__(["imul $1, %rax"], [[72, 107, 192, 1]])
        elif sys_info["sys_isa"] == "arm64":
            super().__init__(["mul x3, x3, x2"], [[99, 124, 2, 155]])
        else:
            super().__init__([], [])

class store_load_pair(instruction):
    def __init__(self, sys_info):
        if sys_info["sys_isa"] == "x86_64":
            super().__init__(["movq $0, 0(%rdi)", "movq 0(%rsi), %rax"], [[72, 199, 7, 0, 0, 0, 0], [72, 139, 6]])
        elif sys_info["sys_isa"] == "arm64":
            super().__init__(["str x2, [x0]", "ldr x3, [x1]"], [[2, 0, 0, 249], [35, 0, 64, 249]])
        else:
            super().__init__([], [])

class ret(instruction):
    def __init__(self, sys_info):
        if sys_info["sys_isa"] == "x86_64":
            super().__init__(["ret"], [[195]])
        elif sys_info["sys_isa"] == "arm64":
            super().__init__(["ret"], [[192, 3, 95, 214]])
        else:
            super().__init__([], [])

class timing_start(instruction):
     def __init__(self, sys_info):
        '''
        rdtscp
        shl $32, %rdx
        or %rax, %rdx
        mov %rdx, %r8
        '''
        if sys_info["sys_isa"] == "x86_64":
            if sys_info["sys_cpu"] == "AMD":
                super().__init__([], [])
            else: # Intel
                super().__init__(["rdtscp", "shl $32, %rdx", "or %rax, %rdx", "mov %rdx, %r8"], [[15, 1, 249], [72, 193, 226, 50], [72, 9, 194], [73, 137, 208]])
        elif sys_info["sys_isa"] == "arm64":
            if sys_info["sys_cpu"] == "Apple":
                super().__init__([], [])
            else:
                super().__init__([], [])
        else:
            super().__init__([], [])

class timing_end(instruction):
     def __init__(self, sys_info):
        if sys_info["sys_isa"] == "x86_64":
            if sys_info["sys_cpu"] == "AMD":
                super().__init__([], [])
            else:
                super().__init__([], [])
        elif sys_info["sys_isa"] == "arm64":
            if sys_info["sys_cpu"] == "Apple":
                super().__init__([], [])
            else:
                super().__init__([], [])
        else:
            super().__init__([], [])

class barrier(instruction):
     def __init__(self, sys_info):
        if sys_info["sys_isa"] == "x86_64":
            super().__init__(["mfence", "lfence"], [[15, 174, 240], [15, 174, 232]])
        elif sys_info["sys_isa"] == "arm64":
            super().__init__(["dsb ish", "isb"], [[159, 59, 3, 213], [223, 63, 3, 213]])
        else:
            super().__init__([], [])