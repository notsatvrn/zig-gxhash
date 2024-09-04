	.text
	.intel_syntax noprefix
	.file	"core"
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0
.LCPI0_0:
	.byte	0
	.byte	1
	.byte	2
	.byte	3
	.byte	4
	.byte	5
	.byte	6
	.byte	7
	.byte	8
	.byte	9
	.byte	10
	.byte	11
	.byte	12
	.byte	13
	.byte	14
	.byte	15
.LCPI0_1:
	.byte	66
	.byte	69
	.byte	120
	.byte	242
	.byte	33
	.byte	62
	.byte	157
	.byte	176
	.byte	229
	.byte	34
	.byte	194
	.byte	137
	.byte	142
	.byte	194
	.byte	59
	.byte	252
.LCPI0_2:
	.byte	121
	.byte	226
	.byte	252
	.byte	3
	.byte	155
	.byte	46
	.byte	107
	.byte	203
	.byte	88
	.byte	220
	.byte	97
	.byte	179
	.byte	217
	.byte	43
	.byte	19
	.byte	57
.LCPI0_3:
	.zero	16
	.text
	.globl	compressAllExtern
	.p2align	4, 0x90
	.type	compressAllExtern,@function
compressAllExtern:
	.cfi_startproc
	push	rbx
	.cfi_def_cfa_offset 16
	sub	rsp, 16
	.cfi_def_cfa_offset 32
	.cfi_offset rbx, -16
	test	rsi, rsi
	je	.LBB0_1
	cmp	rsi, 16
	ja	.LBB0_14
	mov	eax, edi
	not	eax
	test	eax, 4080
	jne	.LBB0_5
	vxorps	xmm0, xmm0, xmm0
	vmovaps	xmmword ptr [rsp], xmm0
	mov	rax, rsp
	mov	rcx, rdi
	mov	rdi, rax
	mov	rbx, rsi
	mov	rsi, rcx
	mov	rdx, rbx
	call	memcpy@PLT
	vmovd	xmm0, ebx
	vpshufb	xmm0, xmm0, xmmword ptr [rip + .LCPI0_3]
	vpaddb	xmm0, xmm0, xmmword ptr [rsp]
	jmp	.LBB0_6
.LBB0_1:
	xor	eax, eax
	xor	edx, edx
	add	rsp, 16
	.cfi_def_cfa_offset 16
	pop	rbx
	.cfi_def_cfa_offset 8
	ret
.LBB0_14:
	.cfi_def_cfa_offset 32
	mov	r10, rsi
	and	r10, 15
	je	.LBB0_8
	vmovd	xmm0, r10d
	vpxor	xmm1, xmm1, xmm1
	vpshufb	xmm0, xmm0, xmm1
	vpcmpgtb	xmm1, xmm0, xmmword ptr [rip + .LCPI0_0]
	vpand	xmm1, xmm1, xmmword ptr [rdi]
	vpaddb	xmm0, xmm1, xmm0
	jmp	.LBB0_9
.LBB0_5:
	vmovd	xmm0, esi
	vpxor	xmm1, xmm1, xmm1
	vpshufb	xmm0, xmm0, xmm1
	vpcmpgtb	xmm1, xmm0, xmmword ptr [rip + .LCPI0_0]
	vpand	xmm1, xmm1, xmmword ptr [rdi]
	vpaddb	xmm0, xmm1, xmm0
.LBB0_6:
	vpextrq	rdx, xmm0, 1
	vmovq	rax, xmm0
	add	rsp, 16
	.cfi_def_cfa_offset 16
	pop	rbx
	.cfi_def_cfa_offset 8
	ret
.LBB0_8:
	.cfi_def_cfa_offset 32
	vmovdqu	xmm0, xmmword ptr [rdi]
	mov	r10d, 16
.LBB0_9:
	prefetcht0	byte ptr [rip + core.keys]
	mov	rcx, qword ptr [rdi + r10]
	mov	rax, qword ptr [rdi + r10 + 8]
	cmp	rsi, 32
	jbe	.LBB0_24
	add	r10, rdi
	vmovq	xmm1, rcx
	vmovq	xmm2, rax
	vpunpcklqdq	xmm1, xmm1, xmm2
	vmovdqu	xmm2, xmmword ptr [r10 + 16]
	#APP
	aesenc	xmm1, xmm2
	#NO_APP
	vpextrq	rax, xmm1, 1
	vmovq	rcx, xmm1
	cmp	rsi, 49
	jb	.LBB0_24
	vmovq	xmm1, rcx
	vmovq	xmm2, rax
	vpunpcklqdq	xmm1, xmm1, xmm2
	vmovdqu	xmm2, xmmword ptr [r10 + 32]
	#APP
	aesenc	xmm1, xmm2
	#NO_APP
	vpextrq	rax, xmm1, 1
	vmovq	rcx, xmm1
	cmp	rsi, 65
	jb	.LBB0_24
	add	rdi, rsi
	lea	rdx, [r10 + 48]
	vpextrq	r8, xmm0, 1
	vmovq	r9, xmm0
	mov	r11d, edi
	sub	r11d, edx
	and	r11d, 127
	je	.LBB0_13
	add	r11, r10
	add	r11, 48
	mov	r10, rdx
	.p2align	4, 0x90
.LBB0_17:
	vmovq	xmm0, r9
	vmovq	xmm1, r8
	vpunpcklqdq	xmm0, xmm0, xmm1
	vmovdqu	xmm1, xmmword ptr [rdx]
	#APP
	aesenc	xmm0, xmm1
	#NO_APP
	vpextrq	r8, xmm0, 1
	vmovq	r9, xmm0
	add	rdx, 16
	add	r10, 16
	cmp	r11, r10
	ja	.LBB0_17
	cmp	rdi, r10
	jbe	.LBB0_19
.LBB0_20:
	vpxor	xmm0, xmm0, xmm0
	vmovdqa	xmm1, xmmword ptr [rip + .LCPI0_1]
	vmovdqa	xmm2, xmmword ptr [rip + .LCPI0_2]
	mov	r10, rdx
	mov	rbx, r9
	mov	r11, r8
	vpxor	xmm3, xmm3, xmm3
	.p2align	4, 0x90
.LBB0_21:
	vpaddb	xmm0, xmm0, xmm2
	vpaddb	xmm3, xmm3, xmm1
	vmovups	xmm5, xmmword ptr [rdx]
	vmovups	xmm4, xmmword ptr [rdx + 16]
	vmovups	xmm6, xmmword ptr [rdx + 32]
	vmovups	xmm7, xmmword ptr [rdx + 48]
	#APP
	aesenc	xmm5, xmm6
	#NO_APP
	#APP
	aesenc	xmm4, xmm7
	#NO_APP
	vmovups	xmm6, xmmword ptr [rdx + 64]
	#APP
	aesenc	xmm5, xmm6
	#NO_APP
	vmovups	xmm6, xmmword ptr [rdx + 80]
	#APP
	aesenc	xmm4, xmm6
	#NO_APP
	vmovups	xmm6, xmmword ptr [rdx + 96]
	#APP
	aesenc	xmm5, xmm6
	#NO_APP
	vmovups	xmm6, xmmword ptr [rdx + 112]
	#APP
	aesenc	xmm4, xmm6
	#NO_APP
	#APP
	aesenc	xmm5, xmm3
	#NO_APP
	vmovq	xmm6, rbx
	vmovq	xmm7, r11
	vpunpcklqdq	xmm6, xmm6, xmm7
	#APP
	aesenclast	xmm5, xmm6
	#NO_APP
	vpextrq	r11, xmm5, 1
	vmovq	rbx, xmm5
	#APP
	aesenc	xmm4, xmm0
	#NO_APP
	vmovq	xmm5, r9
	vmovq	xmm6, r8
	vpunpcklqdq	xmm5, xmm5, xmm6
	#APP
	aesenclast	xmm4, xmm5
	#NO_APP
	vpextrq	r8, xmm4, 1
	vmovq	r9, xmm4
	sub	rdx, -128
	sub	r10, -128
	cmp	rdi, r10
	ja	.LBB0_21
	vmovq	xmm0, r9
	vmovq	xmm1, r8
	vpunpcklqdq	xmm1, xmm0, xmm1
	vmovq	xmm0, rbx
	vmovq	xmm2, r11
	vpunpcklqdq	xmm0, xmm0, xmm2
	jmp	.LBB0_23
.LBB0_13:
	mov	r10, rdx
	cmp	rdi, r10
	ja	.LBB0_20
.LBB0_19:
	vmovq	xmm0, r9
	vmovq	xmm1, r8
	vpunpcklqdq	xmm0, xmm0, xmm1
	vmovdqa	xmm1, xmm0
.LBB0_23:
	vmovd	xmm2, esi
	vpshufd	xmm2, xmm2, 0
	vpaddb	xmm0, xmm0, xmm2
	vpaddb	xmm1, xmm1, xmm2
	#APP
	aesenc	xmm0, xmm1
	#NO_APP
.LBB0_24:
	vmovq	xmm1, rcx
	vmovq	xmm2, rax
	vpunpcklqdq	xmm1, xmm1, xmm2
	vmovaps	xmm2, xmmword ptr [rip + .LCPI0_1]
	#APP
	aesenc	xmm1, xmm2
	#NO_APP
	vmovaps	xmm2, xmmword ptr [rip + .LCPI0_2]
	#APP
	aesenc	xmm1, xmm2
	#NO_APP
	#APP
	aesenclast	xmm0, xmm1
	#NO_APP
	vmovq	rax, xmm0
	vpextrq	rdx, xmm0, 1
	add	rsp, 16
	.cfi_def_cfa_offset 16
	pop	rbx
	.cfi_def_cfa_offset 8
	ret
.Lfunc_end0:
	.size	compressAllExtern, .Lfunc_end0-compressAllExtern
	.cfi_endproc

	.type	core.keys,@object
	.section	.rodata,"a",@progbits
	.p2align	4, 0x0
core.keys:
	.quad	-5720347636167850686
	.quad	-271409435073436955
	.quad	-3788883418180427143
	.quad	4112679098736827480
	.quad	7538229170648722994
	.quad	-4068137861075652169
	.size	core.keys, 48

	.section	".note.GNU-stack","",@progbits
