	.file	"test_type.c"
	.text
	.globl	luy_thua
	.type	luy_thua, @function
luy_thua:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movw	%di, -18(%rbp)
	movw	%si, -20(%rbp)
	movw	$1, -6(%rbp)
	movl	$1, -4(%rbp)
	jmp	.L2
.L3:
	movzwl	-6(%rbp), %edx
	movzwl	-18(%rbp), %eax
	imull	%edx, %eax
	movw	%ax, -6(%rbp)
	addl	$1, -4(%rbp)
.L2:
	movswl	-20(%rbp), %eax
	cmpl	%eax, -4(%rbp)
	jle	.L3
	movzwl	-6(%rbp), %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	luy_thua, .-luy_thua
	.section	.rodata
.LC0:
	.string	"%d\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB1:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movw	$1, -2(%rbp)
	movw	$0, -2(%rbp)
	movl	$16, %esi
	movl	$2, %edi
	call	luy_thua
	movw	%ax, -2(%rbp)
	movswl	-2(%rbp), %eax
	leaq	.LC0(%rip), %rdx
	movl	%eax, %esi
	movq	%rdx, %rdi
	movl	$0, %eax
	call	printf@PLT
	movw	$0, -2(%rbp)
	movl	$32, %esi
	movl	$2, %edi
	call	luy_thua
	movw	%ax, -2(%rbp)
	movswl	-2(%rbp), %eax
	leaq	.LC0(%rip), %rdx
	movl	%eax, %esi
	movq	%rdx, %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	main, .-main
	.ident	"GCC: (GNU) 16.1.1 20260430"
	.section	.note.GNU-stack,"",@progbits
