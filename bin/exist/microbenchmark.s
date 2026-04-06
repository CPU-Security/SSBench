
../../bin/exist/microbenchmark:     file format elf64-x86-64


Disassembly of section .init:

0000000000001000 <_init>:
    1000:	f3 0f 1e fa          	endbr64 
    1004:	48 83 ec 08          	sub    $0x8,%rsp
    1008:	48 8b 05 d9 4f 00 00 	mov    0x4fd9(%rip),%rax        # 5fe8 <__gmon_start__>
    100f:	48 85 c0             	test   %rax,%rax
    1012:	74 02                	je     1016 <_init+0x16>
    1014:	ff d0                	callq  *%rax
    1016:	48 83 c4 08          	add    $0x8,%rsp
    101a:	c3                   	retq   

Disassembly of section .plt:

0000000000001020 <.plt>:
    1020:	ff 35 62 4f 00 00    	pushq  0x4f62(%rip)        # 5f88 <_GLOBAL_OFFSET_TABLE_+0x8>
    1026:	ff 25 64 4f 00 00    	jmpq   *0x4f64(%rip)        # 5f90 <_GLOBAL_OFFSET_TABLE_+0x10>
    102c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000001030 <__isoc99_fscanf@plt>:
    1030:	ff 25 62 4f 00 00    	jmpq   *0x4f62(%rip)        # 5f98 <__isoc99_fscanf@GLIBC_2.7>
    1036:	68 00 00 00 00       	pushq  $0x0
    103b:	e9 e0 ff ff ff       	jmpq   1020 <.plt>

0000000000001040 <fclose@plt>:
    1040:	ff 25 5a 4f 00 00    	jmpq   *0x4f5a(%rip)        # 5fa0 <fclose@GLIBC_2.2.5>
    1046:	68 01 00 00 00       	pushq  $0x1
    104b:	e9 d0 ff ff ff       	jmpq   1020 <.plt>

0000000000001050 <__stack_chk_fail@plt>:
    1050:	ff 25 52 4f 00 00    	jmpq   *0x4f52(%rip)        # 5fa8 <__stack_chk_fail@GLIBC_2.4>
    1056:	68 02 00 00 00       	pushq  $0x2
    105b:	e9 c0 ff ff ff       	jmpq   1020 <.plt>

0000000000001060 <sched_setaffinity@plt>:
    1060:	ff 25 4a 4f 00 00    	jmpq   *0x4f4a(%rip)        # 5fb0 <sched_setaffinity@GLIBC_2.3.4>
    1066:	68 03 00 00 00       	pushq  $0x3
    106b:	e9 b0 ff ff ff       	jmpq   1020 <.plt>

0000000000001070 <fputc@plt>:
    1070:	ff 25 42 4f 00 00    	jmpq   *0x4f42(%rip)        # 5fb8 <fputc@GLIBC_2.2.5>
    1076:	68 04 00 00 00       	pushq  $0x4
    107b:	e9 a0 ff ff ff       	jmpq   1020 <.plt>

0000000000001080 <fprintf@plt>:
    1080:	ff 25 3a 4f 00 00    	jmpq   *0x4f3a(%rip)        # 5fc0 <fprintf@GLIBC_2.2.5>
    1086:	68 05 00 00 00       	pushq  $0x5
    108b:	e9 90 ff ff ff       	jmpq   1020 <.plt>

0000000000001090 <malloc@plt>:
    1090:	ff 25 32 4f 00 00    	jmpq   *0x4f32(%rip)        # 5fc8 <malloc@GLIBC_2.2.5>
    1096:	68 06 00 00 00       	pushq  $0x6
    109b:	e9 80 ff ff ff       	jmpq   1020 <.plt>

00000000000010a0 <fopen@plt>:
    10a0:	ff 25 2a 4f 00 00    	jmpq   *0x4f2a(%rip)        # 5fd0 <fopen@GLIBC_2.2.5>
    10a6:	68 07 00 00 00       	pushq  $0x7
    10ab:	e9 70 ff ff ff       	jmpq   1020 <.plt>

Disassembly of section .plt.got:

00000000000010b0 <__cxa_finalize@plt>:
    10b0:	ff 25 42 4f 00 00    	jmpq   *0x4f42(%rip)        # 5ff8 <__cxa_finalize@GLIBC_2.2.5>
    10b6:	66 90                	xchg   %ax,%ax

Disassembly of section .text:

0000000000002000 <_start>:
    2000:	f3 0f 1e fa          	endbr64 
    2004:	31 ed                	xor    %ebp,%ebp
    2006:	49 89 d1             	mov    %rdx,%r9
    2009:	5e                   	pop    %rsi
    200a:	48 89 e2             	mov    %rsp,%rdx
    200d:	48 83 e4 f0          	and    $0xfffffffffffffff0,%rsp
    2011:	50                   	push   %rax
    2012:	54                   	push   %rsp
    2013:	4c 8d 05 a6 11 00 00 	lea    0x11a6(%rip),%r8        # 31c0 <__libc_csu_fini>
    201a:	48 8d 0d 2f 11 00 00 	lea    0x112f(%rip),%rcx        # 3150 <__libc_csu_init>
    2021:	48 8d 3d 9d 01 00 00 	lea    0x19d(%rip),%rdi        # 21c5 <main>
    2028:	ff 15 b2 3f 00 00    	callq  *0x3fb2(%rip)        # 5fe0 <__libc_start_main@GLIBC_2.2.5>
    202e:	f4                   	hlt    
    202f:	90                   	nop

0000000000002030 <deregister_tm_clones>:
    2030:	48 8d 3d d9 3f 00 00 	lea    0x3fd9(%rip),%rdi        # 6010 <__TMC_END__>
    2037:	48 8d 05 d2 3f 00 00 	lea    0x3fd2(%rip),%rax        # 6010 <__TMC_END__>
    203e:	48 39 f8             	cmp    %rdi,%rax
    2041:	74 15                	je     2058 <deregister_tm_clones+0x28>
    2043:	48 8b 05 8e 3f 00 00 	mov    0x3f8e(%rip),%rax        # 5fd8 <_ITM_deregisterTMCloneTable>
    204a:	48 85 c0             	test   %rax,%rax
    204d:	74 09                	je     2058 <deregister_tm_clones+0x28>
    204f:	ff e0                	jmpq   *%rax
    2051:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    2058:	c3                   	retq   
    2059:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

0000000000002060 <register_tm_clones>:
    2060:	48 8d 3d a9 3f 00 00 	lea    0x3fa9(%rip),%rdi        # 6010 <__TMC_END__>
    2067:	48 8d 35 a2 3f 00 00 	lea    0x3fa2(%rip),%rsi        # 6010 <__TMC_END__>
    206e:	48 29 fe             	sub    %rdi,%rsi
    2071:	48 89 f0             	mov    %rsi,%rax
    2074:	48 c1 ee 3f          	shr    $0x3f,%rsi
    2078:	48 c1 f8 03          	sar    $0x3,%rax
    207c:	48 01 c6             	add    %rax,%rsi
    207f:	48 d1 fe             	sar    %rsi
    2082:	74 14                	je     2098 <register_tm_clones+0x38>
    2084:	48 8b 05 65 3f 00 00 	mov    0x3f65(%rip),%rax        # 5ff0 <_ITM_registerTMCloneTable>
    208b:	48 85 c0             	test   %rax,%rax
    208e:	74 08                	je     2098 <register_tm_clones+0x38>
    2090:	ff e0                	jmpq   *%rax
    2092:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
    2098:	c3                   	retq   
    2099:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

00000000000020a0 <__do_global_dtors_aux>:
    20a0:	f3 0f 1e fa          	endbr64 
    20a4:	80 3d 65 3f 00 00 00 	cmpb   $0x0,0x3f65(%rip)        # 6010 <__TMC_END__>
    20ab:	75 2b                	jne    20d8 <__do_global_dtors_aux+0x38>
    20ad:	55                   	push   %rbp
    20ae:	48 83 3d 42 3f 00 00 	cmpq   $0x0,0x3f42(%rip)        # 5ff8 <__cxa_finalize@GLIBC_2.2.5>
    20b5:	00 
    20b6:	48 89 e5             	mov    %rsp,%rbp
    20b9:	74 0c                	je     20c7 <__do_global_dtors_aux+0x27>
    20bb:	48 8b 3d 46 3f 00 00 	mov    0x3f46(%rip),%rdi        # 6008 <__dso_handle>
    20c2:	e8 e9 ef ff ff       	callq  10b0 <__cxa_finalize@plt>
    20c7:	e8 64 ff ff ff       	callq  2030 <deregister_tm_clones>
    20cc:	c6 05 3d 3f 00 00 01 	movb   $0x1,0x3f3d(%rip)        # 6010 <__TMC_END__>
    20d3:	5d                   	pop    %rbp
    20d4:	c3                   	retq   
    20d5:	0f 1f 00             	nopl   (%rax)
    20d8:	c3                   	retq   
    20d9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

00000000000020e0 <frame_dummy>:
    20e0:	f3 0f 1e fa          	endbr64 
    20e4:	e9 77 ff ff ff       	jmpq   2060 <register_tm_clones>

00000000000020e9 <bindcore>:
    20e9:	f3 0f 1e fa          	endbr64 
    20ed:	55                   	push   %rbp
    20ee:	48 89 e5             	mov    %rsp,%rbp
    20f1:	48 81 ec b0 00 00 00 	sub    $0xb0,%rsp
    20f8:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%rbp)
    20fe:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
    2105:	00 00 
    2107:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    210b:	31 c0                	xor    %eax,%eax
    210d:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
    2114:	48 89 c6             	mov    %rax,%rsi
    2117:	b8 00 00 00 00       	mov    $0x0,%eax
    211c:	ba 10 00 00 00       	mov    $0x10,%edx
    2121:	48 89 f7             	mov    %rsi,%rdi
    2124:	48 89 d1             	mov    %rdx,%rcx
    2127:	f3 48 ab             	rep stos %rax,%es:(%rdi)
    212a:	8b 85 5c ff ff ff    	mov    -0xa4(%rbp),%eax
    2130:	48 98                	cltq   
    2132:	48 89 85 68 ff ff ff 	mov    %rax,-0x98(%rbp)
    2139:	48 81 bd 68 ff ff ff 	cmpq   $0x3ff,-0x98(%rbp)
    2140:	ff 03 00 00 
    2144:	77 4f                	ja     2195 <bindcore+0xac>
    2146:	48 8b 85 68 ff ff ff 	mov    -0x98(%rbp),%rax
    214d:	48 c1 e8 06          	shr    $0x6,%rax
    2151:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    2158:	00 
    2159:	48 8d 8d 70 ff ff ff 	lea    -0x90(%rbp),%rcx
    2160:	48 01 ca             	add    %rcx,%rdx
    2163:	48 8b 32             	mov    (%rdx),%rsi
    2166:	48 8b 95 68 ff ff ff 	mov    -0x98(%rbp),%rdx
    216d:	83 e2 3f             	and    $0x3f,%edx
    2170:	bf 01 00 00 00       	mov    $0x1,%edi
    2175:	89 d1                	mov    %edx,%ecx
    2177:	48 d3 e7             	shl    %cl,%rdi
    217a:	48 89 fa             	mov    %rdi,%rdx
    217d:	48 8d 0c c5 00 00 00 	lea    0x0(,%rax,8),%rcx
    2184:	00 
    2185:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
    218c:	48 01 c8             	add    %rcx,%rax
    218f:	48 09 f2             	or     %rsi,%rdx
    2192:	48 89 10             	mov    %rdx,(%rax)
    2195:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
    219c:	48 89 c2             	mov    %rax,%rdx
    219f:	be 80 00 00 00       	mov    $0x80,%esi
    21a4:	bf 00 00 00 00       	mov    $0x0,%edi
    21a9:	e8 b2 ee ff ff       	callq  1060 <sched_setaffinity@plt>
    21ae:	90                   	nop
    21af:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
    21b3:	64 48 2b 04 25 28 00 	sub    %fs:0x28,%rax
    21ba:	00 00 
    21bc:	74 05                	je     21c3 <bindcore+0xda>
    21be:	e8 8d ee ff ff       	callq  1050 <__stack_chk_fail@plt>
    21c3:	c9                   	leaveq 
    21c4:	c3                   	retq   

00000000000021c5 <main>:
    21c5:	f3 0f 1e fa          	endbr64 
    21c9:	55                   	push   %rbp
    21ca:	48 89 e5             	mov    %rsp,%rbp
    21cd:	41 57                	push   %r15
    21cf:	41 56                	push   %r14
    21d1:	41 55                	push   %r13
    21d3:	41 54                	push   %r12
    21d5:	53                   	push   %rbx
    21d6:	48 81 ec d8 00 00 00 	sub    $0xd8,%rsp
    21dd:	89 bd 4c ff ff ff    	mov    %edi,-0xb4(%rbp)
    21e3:	48 89 b5 40 ff ff ff 	mov    %rsi,-0xc0(%rbp)
    21ea:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
    21f1:	00 00 
    21f3:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    21f7:	31 c0                	xor    %eax,%eax
    21f9:	48 89 e0             	mov    %rsp,%rax
    21fc:	48 89 c3             	mov    %rax,%rbx
    21ff:	bf f4 01 00 00       	mov    $0x1f4,%edi
    2204:	e8 87 ee ff ff       	callq  1090 <malloc@plt>
    2209:	48 89 85 70 ff ff ff 	mov    %rax,-0x90(%rbp)
    2210:	48 8d 05 ed 1d 00 00 	lea    0x1ded(%rip),%rax        # 4004 <_IO_stdin_used+0x4>
    2217:	48 89 c6             	mov    %rax,%rsi
    221a:	48 8d 05 e5 1d 00 00 	lea    0x1de5(%rip),%rax        # 4006 <_IO_stdin_used+0x6>
    2221:	48 89 c7             	mov    %rax,%rdi
    2224:	e8 77 ee ff ff       	callq  10a0 <fopen@plt>
    2229:	48 89 85 78 ff ff ff 	mov    %rax,-0x88(%rbp)
    2230:	48 8d 05 d6 1d 00 00 	lea    0x1dd6(%rip),%rax        # 400d <_IO_stdin_used+0xd>
    2237:	48 89 c6             	mov    %rax,%rsi
    223a:	48 8d 05 ce 1d 00 00 	lea    0x1dce(%rip),%rax        # 400f <_IO_stdin_used+0xf>
    2241:	48 89 c7             	mov    %rax,%rdi
    2244:	e8 57 ee ff ff       	callq  10a0 <fopen@plt>
    2249:	48 89 45 80          	mov    %rax,-0x80(%rbp)
    224d:	c7 85 6c ff ff ff 10 	movl   $0x10,-0x94(%rbp)
    2254:	00 00 00 
    2257:	48 8d 85 54 ff ff ff 	lea    -0xac(%rbp),%rax
    225e:	48 8d 95 58 ff ff ff 	lea    -0xa8(%rbp),%rdx
    2265:	48 8b bd 78 ff ff ff 	mov    -0x88(%rbp),%rdi
    226c:	48 89 c1             	mov    %rax,%rcx
    226f:	48 8d 05 a1 1d 00 00 	lea    0x1da1(%rip),%rax        # 4017 <_IO_stdin_used+0x17>
    2276:	48 89 c6             	mov    %rax,%rsi
    2279:	b8 00 00 00 00       	mov    $0x0,%eax
    227e:	e8 ad ed ff ff       	callq  1030 <__isoc99_fscanf@plt>
    2283:	8b 95 54 ff ff ff    	mov    -0xac(%rbp),%edx
    2289:	48 63 c2             	movslq %edx,%rax
    228c:	48 83 e8 01          	sub    $0x1,%rax
    2290:	48 89 45 88          	mov    %rax,-0x78(%rbp)
    2294:	48 63 c2             	movslq %edx,%rax
    2297:	48 89 85 30 ff ff ff 	mov    %rax,-0xd0(%rbp)
    229e:	48 c7 85 38 ff ff ff 	movq   $0x0,-0xc8(%rbp)
    22a5:	00 00 00 00 
    22a9:	48 63 c2             	movslq %edx,%rax
    22ac:	48 89 85 20 ff ff ff 	mov    %rax,-0xe0(%rbp)
    22b3:	48 c7 85 28 ff ff ff 	movq   $0x0,-0xd8(%rbp)
    22ba:	00 00 00 00 
    22be:	48 63 c2             	movslq %edx,%rax
    22c1:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
    22c8:	00 
    22c9:	b8 10 00 00 00       	mov    $0x10,%eax
    22ce:	48 83 e8 01          	sub    $0x1,%rax
    22d2:	48 01 d0             	add    %rdx,%rax
    22d5:	be 10 00 00 00       	mov    $0x10,%esi
    22da:	ba 00 00 00 00       	mov    $0x0,%edx
    22df:	48 f7 f6             	div    %rsi
    22e2:	48 6b c0 10          	imul   $0x10,%rax,%rax
    22e6:	48 89 c1             	mov    %rax,%rcx
    22e9:	48 81 e1 00 f0 ff ff 	and    $0xfffffffffffff000,%rcx
    22f0:	48 89 e2             	mov    %rsp,%rdx
    22f3:	48 29 ca             	sub    %rcx,%rdx
    22f6:	48 39 d4             	cmp    %rdx,%rsp
    22f9:	74 12                	je     230d <main+0x148>
    22fb:	48 81 ec 00 10 00 00 	sub    $0x1000,%rsp
    2302:	48 83 8c 24 f8 0f 00 	orq    $0x0,0xff8(%rsp)
    2309:	00 00 
    230b:	eb e9                	jmp    22f6 <main+0x131>
    230d:	48 89 c2             	mov    %rax,%rdx
    2310:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
    2316:	48 29 d4             	sub    %rdx,%rsp
    2319:	48 89 c2             	mov    %rax,%rdx
    231c:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
    2322:	48 85 d2             	test   %rdx,%rdx
    2325:	74 10                	je     2337 <main+0x172>
    2327:	25 ff 0f 00 00       	and    $0xfff,%eax
    232c:	48 83 e8 08          	sub    $0x8,%rax
    2330:	48 01 e0             	add    %rsp,%rax
    2333:	48 83 08 00          	orq    $0x0,(%rax)
    2337:	48 89 e0             	mov    %rsp,%rax
    233a:	48 83 c0 03          	add    $0x3,%rax
    233e:	48 c1 e8 02          	shr    $0x2,%rax
    2342:	48 c1 e0 02          	shl    $0x2,%rax
    2346:	48 89 45 90          	mov    %rax,-0x70(%rbp)
    234a:	8b 85 54 ff ff ff    	mov    -0xac(%rbp),%eax
    2350:	48 63 d0             	movslq %eax,%rdx
    2353:	48 83 ea 01          	sub    $0x1,%rdx
    2357:	48 89 55 98          	mov    %rdx,-0x68(%rbp)
    235b:	48 63 d0             	movslq %eax,%rdx
    235e:	48 89 95 10 ff ff ff 	mov    %rdx,-0xf0(%rbp)
    2365:	48 c7 85 18 ff ff ff 	movq   $0x0,-0xe8(%rbp)
    236c:	00 00 00 00 
    2370:	48 63 d0             	movslq %eax,%rdx
    2373:	48 89 95 00 ff ff ff 	mov    %rdx,-0x100(%rbp)
    237a:	48 c7 85 08 ff ff ff 	movq   $0x0,-0xf8(%rbp)
    2381:	00 00 00 00 
    2385:	48 98                	cltq   
    2387:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
    238e:	00 
    238f:	b8 10 00 00 00       	mov    $0x10,%eax
    2394:	48 83 e8 01          	sub    $0x1,%rax
    2398:	48 01 d0             	add    %rdx,%rax
    239b:	be 10 00 00 00       	mov    $0x10,%esi
    23a0:	ba 00 00 00 00       	mov    $0x0,%edx
    23a5:	48 f7 f6             	div    %rsi
    23a8:	48 6b c0 10          	imul   $0x10,%rax,%rax
    23ac:	48 89 c1             	mov    %rax,%rcx
    23af:	48 81 e1 00 f0 ff ff 	and    $0xfffffffffffff000,%rcx
    23b6:	48 89 e2             	mov    %rsp,%rdx
    23b9:	48 29 ca             	sub    %rcx,%rdx
    23bc:	48 39 d4             	cmp    %rdx,%rsp
    23bf:	74 12                	je     23d3 <main+0x20e>
    23c1:	48 81 ec 00 10 00 00 	sub    $0x1000,%rsp
    23c8:	48 83 8c 24 f8 0f 00 	orq    $0x0,0xff8(%rsp)
    23cf:	00 00 
    23d1:	eb e9                	jmp    23bc <main+0x1f7>
    23d3:	48 89 c2             	mov    %rax,%rdx
    23d6:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
    23dc:	48 29 d4             	sub    %rdx,%rsp
    23df:	48 89 c2             	mov    %rax,%rdx
    23e2:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
    23e8:	48 85 d2             	test   %rdx,%rdx
    23eb:	74 10                	je     23fd <main+0x238>
    23ed:	25 ff 0f 00 00       	and    $0xfff,%eax
    23f2:	48 83 e8 08          	sub    $0x8,%rax
    23f6:	48 01 e0             	add    %rsp,%rax
    23f9:	48 83 08 00          	orq    $0x0,(%rax)
    23fd:	48 89 e0             	mov    %rsp,%rax
    2400:	48 83 c0 07          	add    $0x7,%rax
    2404:	48 c1 e8 03          	shr    $0x3,%rax
    2408:	48 c1 e0 03          	shl    $0x3,%rax
    240c:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
    2410:	8b 85 54 ff ff ff    	mov    -0xac(%rbp),%eax
    2416:	48 63 d0             	movslq %eax,%rdx
    2419:	48 83 ea 01          	sub    $0x1,%rdx
    241d:	48 89 55 a8          	mov    %rdx,-0x58(%rbp)
    2421:	48 63 d0             	movslq %eax,%rdx
    2424:	49 89 d6             	mov    %rdx,%r14
    2427:	41 bf 00 00 00 00    	mov    $0x0,%r15d
    242d:	48 63 d0             	movslq %eax,%rdx
    2430:	49 89 d4             	mov    %rdx,%r12
    2433:	41 bd 00 00 00 00    	mov    $0x0,%r13d
    2439:	48 98                	cltq   
    243b:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
    2442:	00 
    2443:	b8 10 00 00 00       	mov    $0x10,%eax
    2448:	48 83 e8 01          	sub    $0x1,%rax
    244c:	48 01 d0             	add    %rdx,%rax
    244f:	be 10 00 00 00       	mov    $0x10,%esi
    2454:	ba 00 00 00 00       	mov    $0x0,%edx
    2459:	48 f7 f6             	div    %rsi
    245c:	48 6b c0 10          	imul   $0x10,%rax,%rax
    2460:	48 89 c1             	mov    %rax,%rcx
    2463:	48 81 e1 00 f0 ff ff 	and    $0xfffffffffffff000,%rcx
    246a:	48 89 e2             	mov    %rsp,%rdx
    246d:	48 29 ca             	sub    %rcx,%rdx
    2470:	48 39 d4             	cmp    %rdx,%rsp
    2473:	74 12                	je     2487 <main+0x2c2>
    2475:	48 81 ec 00 10 00 00 	sub    $0x1000,%rsp
    247c:	48 83 8c 24 f8 0f 00 	orq    $0x0,0xff8(%rsp)
    2483:	00 00 
    2485:	eb e9                	jmp    2470 <main+0x2ab>
    2487:	48 89 c2             	mov    %rax,%rdx
    248a:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
    2490:	48 29 d4             	sub    %rdx,%rsp
    2493:	48 89 c2             	mov    %rax,%rdx
    2496:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
    249c:	48 85 d2             	test   %rdx,%rdx
    249f:	74 10                	je     24b1 <main+0x2ec>
    24a1:	25 ff 0f 00 00       	and    $0xfff,%eax
    24a6:	48 83 e8 08          	sub    $0x8,%rax
    24aa:	48 01 e0             	add    %rsp,%rax
    24ad:	48 83 08 00          	orq    $0x0,(%rax)
    24b1:	48 89 e0             	mov    %rsp,%rax
    24b4:	48 83 c0 03          	add    $0x3,%rax
    24b8:	48 c1 e8 02          	shr    $0x2,%rax
    24bc:	48 c1 e0 02          	shl    $0x2,%rax
    24c0:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
    24c4:	c7 85 5c ff ff ff 00 	movl   $0x0,-0xa4(%rbp)
    24cb:	00 00 00 
    24ce:	eb 3c                	jmp    250c <main+0x347>
    24d0:	8b 85 5c ff ff ff    	mov    -0xa4(%rbp),%eax
    24d6:	48 98                	cltq   
    24d8:	48 8d 14 85 00 00 00 	lea    0x0(,%rax,4),%rdx
    24df:	00 
    24e0:	48 8b 45 90          	mov    -0x70(%rbp),%rax
    24e4:	48 01 c2             	add    %rax,%rdx
    24e7:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
    24ee:	48 8d 0d 28 1b 00 00 	lea    0x1b28(%rip),%rcx        # 401d <_IO_stdin_used+0x1d>
    24f5:	48 89 ce             	mov    %rcx,%rsi
    24f8:	48 89 c7             	mov    %rax,%rdi
    24fb:	b8 00 00 00 00       	mov    $0x0,%eax
    2500:	e8 2b eb ff ff       	callq  1030 <__isoc99_fscanf@plt>
    2505:	83 85 5c ff ff ff 01 	addl   $0x1,-0xa4(%rbp)
    250c:	8b 85 54 ff ff ff    	mov    -0xac(%rbp),%eax
    2512:	39 85 5c ff ff ff    	cmp    %eax,-0xa4(%rbp)
    2518:	7c b6                	jl     24d0 <main+0x30b>
    251a:	48 8b 85 78 ff ff ff 	mov    -0x88(%rbp),%rax
    2521:	48 89 c7             	mov    %rax,%rdi
    2524:	e8 17 eb ff ff       	callq  1040 <fclose@plt>
    2529:	8b 85 58 ff ff ff    	mov    -0xa8(%rbp),%eax
    252f:	89 c7                	mov    %eax,%edi
    2531:	e8 b3 fb ff ff       	callq  20e9 <bindcore>
    2536:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%rbp)
    253d:	00 00 00 
    2540:	eb 4d                	jmp    258f <main+0x3ca>
    2542:	48 8b 85 70 ff ff ff 	mov    -0x90(%rbp),%rax
    2549:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    254d:	8b 85 6c ff ff ff    	mov    -0x94(%rbp),%eax
    2553:	48 63 d0             	movslq %eax,%rdx
    2556:	48 8b 85 70 ff ff ff 	mov    -0x90(%rbp),%rax
    255d:	48 01 d0             	add    %rdx,%rax
    2560:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
    2564:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
    2568:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
    256c:	48 89 d6             	mov    %rdx,%rsi
    256f:	48 89 c7             	mov    %rax,%rdi
    2572:	e8 89 0a 00 00       	callq  3000 <stld>
    2577:	89 c2                	mov    %eax,%edx
    2579:	0f b6 85 53 ff ff ff 	movzbl -0xad(%rbp),%eax
    2580:	21 d0                	and    %edx,%eax
    2582:	88 85 53 ff ff ff    	mov    %al,-0xad(%rbp)
    2588:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%rbp)
    258f:	81 bd 60 ff ff ff 3f 	cmpl   $0xf423f,-0xa0(%rbp)
    2596:	42 0f 00 
    2599:	7e a7                	jle    2542 <main+0x37d>
    259b:	c7 85 64 ff ff ff 00 	movl   $0x0,-0x9c(%rbp)
    25a2:	00 00 00 
    25a5:	e9 83 00 00 00       	jmpq   262d <main+0x468>
    25aa:	48 8b 85 70 ff ff ff 	mov    -0x90(%rbp),%rax
    25b1:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    25b5:	48 8b 45 90          	mov    -0x70(%rbp),%rax
    25b9:	8b 95 64 ff ff ff    	mov    -0x9c(%rbp),%edx
    25bf:	48 63 d2             	movslq %edx,%rdx
    25c2:	8b 14 90             	mov    (%rax,%rdx,4),%edx
    25c5:	b8 01 00 00 00       	mov    $0x1,%eax
    25ca:	29 d0                	sub    %edx,%eax
    25cc:	0f af 85 6c ff ff ff 	imul   -0x94(%rbp),%eax
    25d3:	48 63 d0             	movslq %eax,%rdx
    25d6:	48 8b 85 70 ff ff ff 	mov    -0x90(%rbp),%rax
    25dd:	48 01 d0             	add    %rdx,%rax
    25e0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
    25e4:	48 8b 55 c0          	mov    -0x40(%rbp),%rdx
    25e8:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
    25ec:	48 89 d6             	mov    %rdx,%rsi
    25ef:	48 89 c7             	mov    %rax,%rdi
    25f2:	e8 09 0a 00 00       	callq  3000 <stld>
    25f7:	48 8b 55 a0          	mov    -0x60(%rbp),%rdx
    25fb:	8b 8d 64 ff ff ff    	mov    -0x9c(%rbp),%ecx
    2601:	48 63 c9             	movslq %ecx,%rcx
    2604:	48 89 04 ca          	mov    %rax,(%rdx,%rcx,8)
    2608:	48 8b 45 b8          	mov    -0x48(%rbp),%rax
    260c:	48 3b 45 c0          	cmp    -0x40(%rbp),%rax
    2610:	0f 94 c0             	sete   %al
    2613:	0f b6 c8             	movzbl %al,%ecx
    2616:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
    261a:	8b 95 64 ff ff ff    	mov    -0x9c(%rbp),%edx
    2620:	48 63 d2             	movslq %edx,%rdx
    2623:	89 0c 90             	mov    %ecx,(%rax,%rdx,4)
    2626:	83 85 64 ff ff ff 01 	addl   $0x1,-0x9c(%rbp)
    262d:	8b 85 54 ff ff ff    	mov    -0xac(%rbp),%eax
    2633:	39 85 64 ff ff ff    	cmp    %eax,-0x9c(%rbp)
    2639:	0f 8c 6b ff ff ff    	jl     25aa <main+0x3e5>
    263f:	c7 85 68 ff ff ff 00 	movl   $0x0,-0x98(%rbp)
    2646:	00 00 00 
    2649:	eb 40                	jmp    268b <main+0x4c6>
    264b:	48 8b 45 a0          	mov    -0x60(%rbp),%rax
    264f:	8b 95 68 ff ff ff    	mov    -0x98(%rbp),%edx
    2655:	48 63 d2             	movslq %edx,%rdx
    2658:	48 8b 0c d0          	mov    (%rax,%rdx,8),%rcx
    265c:	48 8b 45 b0          	mov    -0x50(%rbp),%rax
    2660:	8b 95 68 ff ff ff    	mov    -0x98(%rbp),%edx
    2666:	48 63 d2             	movslq %edx,%rdx
    2669:	8b 14 90             	mov    (%rax,%rdx,4),%edx
    266c:	48 8b 45 80          	mov    -0x80(%rbp),%rax
    2670:	48 8d 35 a9 19 00 00 	lea    0x19a9(%rip),%rsi        # 4020 <_IO_stdin_used+0x20>
    2677:	48 89 c7             	mov    %rax,%rdi
    267a:	b8 00 00 00 00       	mov    $0x0,%eax
    267f:	e8 fc e9 ff ff       	callq  1080 <fprintf@plt>
    2684:	83 85 68 ff ff ff 01 	addl   $0x1,-0x98(%rbp)
    268b:	8b 85 54 ff ff ff    	mov    -0xac(%rbp),%eax
    2691:	39 85 68 ff ff ff    	cmp    %eax,-0x98(%rbp)
    2697:	7c b2                	jl     264b <main+0x486>
    2699:	48 8b 45 80          	mov    -0x80(%rbp),%rax
    269d:	48 89 c6             	mov    %rax,%rsi
    26a0:	bf 0a 00 00 00       	mov    $0xa,%edi
    26a5:	e8 c6 e9 ff ff       	callq  1070 <fputc@plt>
    26aa:	48 8b 45 80          	mov    -0x80(%rbp),%rax
    26ae:	48 89 c7             	mov    %rax,%rdi
    26b1:	e8 8a e9 ff ff       	callq  1040 <fclose@plt>
    26b6:	b8 00 00 00 00       	mov    $0x0,%eax
    26bb:	48 89 dc             	mov    %rbx,%rsp
    26be:	48 8b 55 c8          	mov    -0x38(%rbp),%rdx
    26c2:	64 48 2b 14 25 28 00 	sub    %fs:0x28,%rdx
    26c9:	00 00 
    26cb:	74 05                	je     26d2 <main+0x50d>
    26cd:	e8 7e e9 ff ff       	callq  1050 <__stack_chk_fail@plt>
    26d2:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
    26d6:	5b                   	pop    %rbx
    26d7:	41 5c                	pop    %r12
    26d9:	41 5d                	pop    %r13
    26db:	41 5e                	pop    %r14
    26dd:	41 5f                	pop    %r15
    26df:	5d                   	pop    %rbp
    26e0:	c3                   	retq   
    26e1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    26e8:	00 00 00 
    26eb:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    26f2:	00 00 00 
    26f5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    26fc:	00 00 00 
    26ff:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2706:	00 00 00 
    2709:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2710:	00 00 00 
    2713:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    271a:	00 00 00 
    271d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2724:	00 00 00 
    2727:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    272e:	00 00 00 
    2731:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2738:	00 00 00 
    273b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2742:	00 00 00 
    2745:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    274c:	00 00 00 
    274f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2756:	00 00 00 
    2759:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2760:	00 00 00 
    2763:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    276a:	00 00 00 
    276d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2774:	00 00 00 
    2777:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    277e:	00 00 00 
    2781:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2788:	00 00 00 
    278b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2792:	00 00 00 
    2795:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    279c:	00 00 00 
    279f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    27a6:	00 00 00 
    27a9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    27b0:	00 00 00 
    27b3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    27ba:	00 00 00 
    27bd:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    27c4:	00 00 00 
    27c7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    27ce:	00 00 00 
    27d1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    27d8:	00 00 00 
    27db:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    27e2:	00 00 00 
    27e5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    27ec:	00 00 00 
    27ef:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    27f6:	00 00 00 
    27f9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2800:	00 00 00 
    2803:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    280a:	00 00 00 
    280d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2814:	00 00 00 
    2817:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    281e:	00 00 00 
    2821:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2828:	00 00 00 
    282b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2832:	00 00 00 
    2835:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    283c:	00 00 00 
    283f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2846:	00 00 00 
    2849:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2850:	00 00 00 
    2853:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    285a:	00 00 00 
    285d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2864:	00 00 00 
    2867:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    286e:	00 00 00 
    2871:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2878:	00 00 00 
    287b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2882:	00 00 00 
    2885:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    288c:	00 00 00 
    288f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2896:	00 00 00 
    2899:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    28a0:	00 00 00 
    28a3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    28aa:	00 00 00 
    28ad:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    28b4:	00 00 00 
    28b7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    28be:	00 00 00 
    28c1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    28c8:	00 00 00 
    28cb:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    28d2:	00 00 00 
    28d5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    28dc:	00 00 00 
    28df:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    28e6:	00 00 00 
    28e9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    28f0:	00 00 00 
    28f3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    28fa:	00 00 00 
    28fd:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2904:	00 00 00 
    2907:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    290e:	00 00 00 
    2911:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2918:	00 00 00 
    291b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2922:	00 00 00 
    2925:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    292c:	00 00 00 
    292f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2936:	00 00 00 
    2939:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2940:	00 00 00 
    2943:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    294a:	00 00 00 
    294d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2954:	00 00 00 
    2957:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    295e:	00 00 00 
    2961:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2968:	00 00 00 
    296b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2972:	00 00 00 
    2975:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    297c:	00 00 00 
    297f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2986:	00 00 00 
    2989:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2990:	00 00 00 
    2993:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    299a:	00 00 00 
    299d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    29a4:	00 00 00 
    29a7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    29ae:	00 00 00 
    29b1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    29b8:	00 00 00 
    29bb:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    29c2:	00 00 00 
    29c5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    29cc:	00 00 00 
    29cf:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    29d6:	00 00 00 
    29d9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    29e0:	00 00 00 
    29e3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    29ea:	00 00 00 
    29ed:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    29f4:	00 00 00 
    29f7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    29fe:	00 00 00 
    2a01:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2a08:	00 00 00 
    2a0b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2a12:	00 00 00 
    2a15:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2a1c:	00 00 00 
    2a1f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2a26:	00 00 00 
    2a29:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2a30:	00 00 00 
    2a33:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2a3a:	00 00 00 
    2a3d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2a44:	00 00 00 
    2a47:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2a4e:	00 00 00 
    2a51:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2a58:	00 00 00 
    2a5b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2a62:	00 00 00 
    2a65:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2a6c:	00 00 00 
    2a6f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2a76:	00 00 00 
    2a79:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2a80:	00 00 00 
    2a83:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2a8a:	00 00 00 
    2a8d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2a94:	00 00 00 
    2a97:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2a9e:	00 00 00 
    2aa1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2aa8:	00 00 00 
    2aab:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2ab2:	00 00 00 
    2ab5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2abc:	00 00 00 
    2abf:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2ac6:	00 00 00 
    2ac9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2ad0:	00 00 00 
    2ad3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2ada:	00 00 00 
    2add:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2ae4:	00 00 00 
    2ae7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2aee:	00 00 00 
    2af1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2af8:	00 00 00 
    2afb:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2b02:	00 00 00 
    2b05:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2b0c:	00 00 00 
    2b0f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2b16:	00 00 00 
    2b19:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2b20:	00 00 00 
    2b23:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2b2a:	00 00 00 
    2b2d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2b34:	00 00 00 
    2b37:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2b3e:	00 00 00 
    2b41:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2b48:	00 00 00 
    2b4b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2b52:	00 00 00 
    2b55:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2b5c:	00 00 00 
    2b5f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2b66:	00 00 00 
    2b69:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2b70:	00 00 00 
    2b73:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2b7a:	00 00 00 
    2b7d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2b84:	00 00 00 
    2b87:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2b8e:	00 00 00 
    2b91:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2b98:	00 00 00 
    2b9b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2ba2:	00 00 00 
    2ba5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2bac:	00 00 00 
    2baf:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2bb6:	00 00 00 
    2bb9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2bc0:	00 00 00 
    2bc3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2bca:	00 00 00 
    2bcd:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2bd4:	00 00 00 
    2bd7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2bde:	00 00 00 
    2be1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2be8:	00 00 00 
    2beb:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2bf2:	00 00 00 
    2bf5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2bfc:	00 00 00 
    2bff:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2c06:	00 00 00 
    2c09:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2c10:	00 00 00 
    2c13:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2c1a:	00 00 00 
    2c1d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2c24:	00 00 00 
    2c27:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2c2e:	00 00 00 
    2c31:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2c38:	00 00 00 
    2c3b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2c42:	00 00 00 
    2c45:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2c4c:	00 00 00 
    2c4f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2c56:	00 00 00 
    2c59:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2c60:	00 00 00 
    2c63:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2c6a:	00 00 00 
    2c6d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2c74:	00 00 00 
    2c77:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2c7e:	00 00 00 
    2c81:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2c88:	00 00 00 
    2c8b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2c92:	00 00 00 
    2c95:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2c9c:	00 00 00 
    2c9f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2ca6:	00 00 00 
    2ca9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2cb0:	00 00 00 
    2cb3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2cba:	00 00 00 
    2cbd:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2cc4:	00 00 00 
    2cc7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2cce:	00 00 00 
    2cd1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2cd8:	00 00 00 
    2cdb:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2ce2:	00 00 00 
    2ce5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2cec:	00 00 00 
    2cef:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2cf6:	00 00 00 
    2cf9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2d00:	00 00 00 
    2d03:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2d0a:	00 00 00 
    2d0d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2d14:	00 00 00 
    2d17:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2d1e:	00 00 00 
    2d21:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2d28:	00 00 00 
    2d2b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2d32:	00 00 00 
    2d35:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2d3c:	00 00 00 
    2d3f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2d46:	00 00 00 
    2d49:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2d50:	00 00 00 
    2d53:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2d5a:	00 00 00 
    2d5d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2d64:	00 00 00 
    2d67:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2d6e:	00 00 00 
    2d71:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2d78:	00 00 00 
    2d7b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2d82:	00 00 00 
    2d85:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2d8c:	00 00 00 
    2d8f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2d96:	00 00 00 
    2d99:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2da0:	00 00 00 
    2da3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2daa:	00 00 00 
    2dad:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2db4:	00 00 00 
    2db7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2dbe:	00 00 00 
    2dc1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2dc8:	00 00 00 
    2dcb:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2dd2:	00 00 00 
    2dd5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2ddc:	00 00 00 
    2ddf:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2de6:	00 00 00 
    2de9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2df0:	00 00 00 
    2df3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2dfa:	00 00 00 
    2dfd:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2e04:	00 00 00 
    2e07:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2e0e:	00 00 00 
    2e11:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2e18:	00 00 00 
    2e1b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2e22:	00 00 00 
    2e25:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2e2c:	00 00 00 
    2e2f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2e36:	00 00 00 
    2e39:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2e40:	00 00 00 
    2e43:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2e4a:	00 00 00 
    2e4d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2e54:	00 00 00 
    2e57:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2e5e:	00 00 00 
    2e61:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2e68:	00 00 00 
    2e6b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2e72:	00 00 00 
    2e75:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2e7c:	00 00 00 
    2e7f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2e86:	00 00 00 
    2e89:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2e90:	00 00 00 
    2e93:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2e9a:	00 00 00 
    2e9d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2ea4:	00 00 00 
    2ea7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2eae:	00 00 00 
    2eb1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2eb8:	00 00 00 
    2ebb:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2ec2:	00 00 00 
    2ec5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2ecc:	00 00 00 
    2ecf:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2ed6:	00 00 00 
    2ed9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2ee0:	00 00 00 
    2ee3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2eea:	00 00 00 
    2eed:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2ef4:	00 00 00 
    2ef7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2efe:	00 00 00 
    2f01:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2f08:	00 00 00 
    2f0b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2f12:	00 00 00 
    2f15:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2f1c:	00 00 00 
    2f1f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2f26:	00 00 00 
    2f29:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2f30:	00 00 00 
    2f33:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2f3a:	00 00 00 
    2f3d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2f44:	00 00 00 
    2f47:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2f4e:	00 00 00 
    2f51:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2f58:	00 00 00 
    2f5b:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2f62:	00 00 00 
    2f65:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2f6c:	00 00 00 
    2f6f:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2f76:	00 00 00 
    2f79:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2f80:	00 00 00 
    2f83:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2f8a:	00 00 00 
    2f8d:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2f94:	00 00 00 
    2f97:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2f9e:	00 00 00 
    2fa1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2fa8:	00 00 00 
    2fab:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2fb2:	00 00 00 
    2fb5:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2fbc:	00 00 00 
    2fbf:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2fc6:	00 00 00 
    2fc9:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2fd0:	00 00 00 
    2fd3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2fda:	00 00 00 
    2fdd:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2fe4:	00 00 00 
    2fe7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2fee:	00 00 00 
    2ff1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
    2ff8:	00 00 00 
    2ffb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

0000000000003000 <stld>:
    3000:	4c 8d 05 00 00 00 00 	lea    0x0(%rip),%r8        # 3007 <stld+0x7>
    3007:	49 c7 c1 a2 00 00 00 	mov    $0xa2,%r9
    300e:	49 c7 c2 ac 00 00 00 	mov    $0xac,%r10
    3015:	4d 01 c1             	add    %r8,%r9
    3018:	4d 01 c2             	add    %r8,%r10
    301b:	0f ae f0             	mfence 
    301e:	0f ae e8             	lfence 
    3021:	0f 01 f9             	rdtscp 
    3024:	48 c1 e2 20          	shl    $0x20,%rdx
    3028:	48 09 c2             	or     %rax,%rdx
    302b:	49 89 d0             	mov    %rdx,%r8
    302e:	48 6b ff 01          	imul   $0x1,%rdi,%rdi
    3032:	48 6b ff 01          	imul   $0x1,%rdi,%rdi
    3036:	48 6b ff 01          	imul   $0x1,%rdi,%rdi
    303a:	48 6b ff 01          	imul   $0x1,%rdi,%rdi
    303e:	48 6b ff 01          	imul   $0x1,%rdi,%rdi
    3042:	48 6b ff 01          	imul   $0x1,%rdi,%rdi
    3046:	48 6b ff 01          	imul   $0x1,%rdi,%rdi
    304a:	48 6b ff 01          	imul   $0x1,%rdi,%rdi
    304e:	48 6b ff 01          	imul   $0x1,%rdi,%rdi
    3052:	48 6b ff 01          	imul   $0x1,%rdi,%rdi
    3056:	48 6b ff 01          	imul   $0x1,%rdi,%rdi
    305a:	48 6b ff 01          	imul   $0x1,%rdi,%rdi
    305e:	48 6b ff 01          	imul   $0x1,%rdi,%rdi
    3062:	48 6b ff 01          	imul   $0x1,%rdi,%rdi
    3066:	48 6b ff 01          	imul   $0x1,%rdi,%rdi
    306a:	48 6b ff 01          	imul   $0x1,%rdi,%rdi
    306e:	48 6b ff 01          	imul   $0x1,%rdi,%rdi
    3072:	48 6b ff 01          	imul   $0x1,%rdi,%rdi
    3076:	48 6b ff 01          	imul   $0x1,%rdi,%rdi
    307a:	48 6b ff 01          	imul   $0x1,%rdi,%rdi
    307e:	48 6b ff 01          	imul   $0x1,%rdi,%rdi
    3082:	48 6b ff 01          	imul   $0x1,%rdi,%rdi
    3086:	48 6b ff 01          	imul   $0x1,%rdi,%rdi
    308a:	48 6b ff 01          	imul   $0x1,%rdi,%rdi
    308e:	48 6b ff 01          	imul   $0x1,%rdi,%rdi
    3092:	48 6b ff 01          	imul   $0x1,%rdi,%rdi
    3096:	48 6b ff 01          	imul   $0x1,%rdi,%rdi
    309a:	48 6b ff 01          	imul   $0x1,%rdi,%rdi
    309e:	48 6b ff 01          	imul   $0x1,%rdi,%rdi
    30a2:	48 6b ff 01          	imul   $0x1,%rdi,%rdi
    30a6:	41 ff e1             	jmpq   *%r9

00000000000030a9 <stend>:
    30a9:	48 c7 07 00 00 00 00 	movq   $0x0,(%rdi)
    30b0:	41 ff e2             	jmpq   *%r10

00000000000030b3 <ldend>:
    30b3:	48 8b 06             	mov    (%rsi),%rax
    30b6:	48 6b c0 01          	imul   $0x1,%rax,%rax
    30ba:	48 6b c0 01          	imul   $0x1,%rax,%rax
    30be:	48 6b c0 01          	imul   $0x1,%rax,%rax
    30c2:	48 6b c0 01          	imul   $0x1,%rax,%rax
    30c6:	48 6b c0 01          	imul   $0x1,%rax,%rax
    30ca:	48 6b c0 01          	imul   $0x1,%rax,%rax
    30ce:	48 6b c0 01          	imul   $0x1,%rax,%rax
    30d2:	48 6b c0 01          	imul   $0x1,%rax,%rax
    30d6:	48 6b c0 01          	imul   $0x1,%rax,%rax
    30da:	48 6b c0 01          	imul   $0x1,%rax,%rax
    30de:	48 6b c0 01          	imul   $0x1,%rax,%rax
    30e2:	48 6b c0 01          	imul   $0x1,%rax,%rax
    30e6:	48 6b c0 01          	imul   $0x1,%rax,%rax
    30ea:	48 6b c0 01          	imul   $0x1,%rax,%rax
    30ee:	48 6b c0 01          	imul   $0x1,%rax,%rax
    30f2:	48 6b c0 01          	imul   $0x1,%rax,%rax
    30f6:	48 6b c0 01          	imul   $0x1,%rax,%rax
    30fa:	48 6b c0 01          	imul   $0x1,%rax,%rax
    30fe:	48 6b c0 01          	imul   $0x1,%rax,%rax
    3102:	48 6b c0 01          	imul   $0x1,%rax,%rax
    3106:	48 6b c0 01          	imul   $0x1,%rax,%rax
    310a:	48 6b c0 01          	imul   $0x1,%rax,%rax
    310e:	48 6b c0 01          	imul   $0x1,%rax,%rax
    3112:	48 6b c0 01          	imul   $0x1,%rax,%rax
    3116:	48 6b c0 01          	imul   $0x1,%rax,%rax
    311a:	48 6b c0 01          	imul   $0x1,%rax,%rax
    311e:	48 6b c0 01          	imul   $0x1,%rax,%rax
    3122:	48 6b c0 01          	imul   $0x1,%rax,%rax
    3126:	48 6b c0 01          	imul   $0x1,%rax,%rax
    312a:	48 6b c0 01          	imul   $0x1,%rax,%rax
    312e:	0f ae f0             	mfence 
    3131:	0f 01 f9             	rdtscp 
    3134:	48 c1 e2 20          	shl    $0x20,%rdx
    3138:	48 09 c2             	or     %rax,%rdx
    313b:	4c 29 c2             	sub    %r8,%rdx
    313e:	48 89 d0             	mov    %rdx,%rax
    3141:	0f ae f0             	mfence 
    3144:	0f ae e8             	lfence 
    3147:	c3                   	retq   
    3148:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
    314f:	00 

0000000000003150 <__libc_csu_init>:
    3150:	f3 0f 1e fa          	endbr64 
    3154:	41 57                	push   %r15
    3156:	4c 8d 3d 23 2c 00 00 	lea    0x2c23(%rip),%r15        # 5d80 <__frame_dummy_init_array_entry>
    315d:	41 56                	push   %r14
    315f:	49 89 d6             	mov    %rdx,%r14
    3162:	41 55                	push   %r13
    3164:	49 89 f5             	mov    %rsi,%r13
    3167:	41 54                	push   %r12
    3169:	41 89 fc             	mov    %edi,%r12d
    316c:	55                   	push   %rbp
    316d:	48 8d 2d 14 2c 00 00 	lea    0x2c14(%rip),%rbp        # 5d88 <__do_global_dtors_aux_fini_array_entry>
    3174:	53                   	push   %rbx
    3175:	4c 29 fd             	sub    %r15,%rbp
    3178:	48 83 ec 08          	sub    $0x8,%rsp
    317c:	e8 7f de ff ff       	callq  1000 <_init>
    3181:	48 c1 fd 03          	sar    $0x3,%rbp
    3185:	74 1f                	je     31a6 <__libc_csu_init+0x56>
    3187:	31 db                	xor    %ebx,%ebx
    3189:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
    3190:	4c 89 f2             	mov    %r14,%rdx
    3193:	4c 89 ee             	mov    %r13,%rsi
    3196:	44 89 e7             	mov    %r12d,%edi
    3199:	41 ff 14 df          	callq  *(%r15,%rbx,8)
    319d:	48 83 c3 01          	add    $0x1,%rbx
    31a1:	48 39 dd             	cmp    %rbx,%rbp
    31a4:	75 ea                	jne    3190 <__libc_csu_init+0x40>
    31a6:	48 83 c4 08          	add    $0x8,%rsp
    31aa:	5b                   	pop    %rbx
    31ab:	5d                   	pop    %rbp
    31ac:	41 5c                	pop    %r12
    31ae:	41 5d                	pop    %r13
    31b0:	41 5e                	pop    %r14
    31b2:	41 5f                	pop    %r15
    31b4:	c3                   	retq   
    31b5:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
    31bc:	00 00 00 00 

00000000000031c0 <__libc_csu_fini>:
    31c0:	f3 0f 1e fa          	endbr64 
    31c4:	c3                   	retq   

Disassembly of section .fini:

00000000000031c8 <_fini>:
    31c8:	f3 0f 1e fa          	endbr64 
    31cc:	48 83 ec 08          	sub    $0x8,%rsp
    31d0:	48 83 c4 08          	add    $0x8,%rsp
    31d4:	c3                   	retq   
