	.file	"main.c"
	.text
	.globl	s_grid
	.bss
	.align 32
	.type	s_grid, @object
	.size	s_grid, 40
s_grid:
	.zero	40
	.globl	p_grid
	.align 32
	.type	p_grid, @object
	.size	p_grid, 160
p_grid:
	.zero	160
	.globl	mtx
	.align 32
	.type	mtx, @object
	.size	mtx, 40
mtx:
	.zero	40
	.globl	screenBuf
	.align 32
	.type	screenBuf, @object
	.size	screenBuf, 80
screenBuf:
	.zero	80
	.globl	BLOCK
	.data
	.type	BLOCK, @object
	.size	BLOCK, 1
BLOCK:
	.byte	35
	.globl	EMPTY
	.type	EMPTY, @object
	.size	EMPTY, 1
EMPTY:
	.byte	46
	.globl	NEW_BLOCK
	.section	.rodata
	.type	NEW_BLOCK, @object
	.size	NEW_BLOCK, 1
NEW_BLOCK:
	.byte	1
	.globl	coords
	.bss
	.align 8
	.type	coords, @object
	.size	coords, 8
coords:
	.zero	8
	.globl	flag
	.data
	.type	flag, @object
	.size	flag, 1
flag:
	.byte	32
	.globl	COLISION_MASK
	.section	.rodata
	.type	COLISION_MASK, @object
	.size	COLISION_MASK, 1
COLISION_MASK:
	.byte	16
	.globl	GAME_LOOP_MASK
	.type	GAME_LOOP_MASK, @object
	.size	GAME_LOOP_MASK, 1
GAME_LOOP_MASK:
	.byte	32
	.globl	figures
	.align 32
	.type	figures, @object
	.size	figures, 56
figures:
	.base64	"BAEEAAMBBQE="
	.base64	"BAAFAAMABgA="
	.base64	"BAAEAQUABQE="
	.base64	"BAEEAAMBBQA="
	.base64	"BAEEAAMABQE="
	.base64	"BAEEAAQCBQA="
	.base64	"BAEEAAQCAwI="
.LC0:
	.string	"\033[H"
.LC1:
	.string	"\t\t\t%c%c%c%c%c%c%c%c%c%c\n"
	.text
	.globl	show
	.type	show, @function
show:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r12
	pushq	%rbx
	subq	$16, %rsp
	.cfi_offset 12, -24
	.cfi_offset 3, -32
	movw	$1, -18(%rbp)
	leaq	.LC0(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	movb	$0, -20(%rbp)
	movb	$0, -19(%rbp)
	jmp	.L2
.L7:
	movb	$0, -19(%rbp)
	jmp	.L3
.L6:
	movzbl	-20(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	p_grid(%rip), %rax
	movq	(%rdx,%rax), %rax
	movzwl	(%rax), %eax
	andw	-18(%rbp), %ax
	cmpw	%ax, -18(%rbp)
	jne	.L4
	movzbl	-19(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	screenBuf(%rip), %rax
	leaq	BLOCK(%rip), %rcx
	movq	%rcx, (%rdx,%rax)
	jmp	.L5
.L4:
	movzbl	-19(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	screenBuf(%rip), %rax
	leaq	EMPTY(%rip), %rcx
	movq	%rcx, (%rdx,%rax)
.L5:
	salw	-18(%rbp)
	movzbl	-19(%rbp), %eax
	addl	$1, %eax
	movb	%al, -19(%rbp)
.L3:
	cmpb	$9, -19(%rbp)
	jbe	.L6
	movw	$1, -18(%rbp)
	movq	72+screenBuf(%rip), %rax
	movzbl	(%rax), %eax
	movsbl	%al, %r11d
	movq	64+screenBuf(%rip), %rax
	movzbl	(%rax), %eax
	movsbl	%al, %r10d
	movq	56+screenBuf(%rip), %rax
	movzbl	(%rax), %eax
	movsbl	%al, %r9d
	movq	48+screenBuf(%rip), %rax
	movzbl	(%rax), %eax
	movsbl	%al, %r8d
	movq	40+screenBuf(%rip), %rax
	movzbl	(%rax), %eax
	movsbl	%al, %esi
	movq	32+screenBuf(%rip), %rax
	movzbl	(%rax), %eax
	movsbl	%al, %r12d
	movq	24+screenBuf(%rip), %rax
	movzbl	(%rax), %eax
	movsbl	%al, %ebx
	movq	16+screenBuf(%rip), %rax
	movzbl	(%rax), %eax
	movsbl	%al, %ecx
	movq	8+screenBuf(%rip), %rax
	movzbl	(%rax), %eax
	movsbl	%al, %edx
	movq	screenBuf(%rip), %rax
	movzbl	(%rax), %eax
	movsbl	%al, %eax
	leaq	.LC1(%rip), %rdi
	subq	$8, %rsp
	pushq	%r11
	pushq	%r10
	pushq	%r9
	pushq	%r8
	pushq	%rsi
	movl	%r12d, %r9d
	movl	%ebx, %r8d
	movl	%eax, %esi
	movl	$0, %eax
	call	printf@PLT
	addq	$48, %rsp
	movzbl	-20(%rbp), %eax
	addl	$1, %eax
	movb	%al, -20(%rbp)
.L2:
	cmpb	$19, -20(%rbp)
	jbe	.L7
	nop
	nop
	leaq	-16(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	show, .-show
	.globl	printBlock
	.type	printBlock, @function
printBlock:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-16(%rbp), %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	p_grid(%rip), %rax
	movq	(%rdx,%rax), %rax
	movzwl	(%rax), %eax
	movl	%eax, %esi
	movq	-8(%rbp), %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	movl	$1, %edx
	movl	%eax, %ecx
	sall	%cl, %edx
	movl	%edx, %eax
	orl	%eax, %esi
	movl	%esi, %ecx
	movq	-16(%rbp), %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	p_grid(%rip), %rax
	movq	(%rdx,%rax), %rax
	movl	%ecx, %edx
	movw	%dx, (%rax)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	printBlock, .-printBlock
	.globl	printTetris
	.type	printTetris, @function
printTetris:
.LFB8:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$8, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	-8(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	printBlock
	movq	-8(%rbp), %rax
	leaq	3(%rax), %rdx
	movq	-8(%rbp), %rax
	addq	$2, %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	printBlock
	movq	-8(%rbp), %rax
	leaq	5(%rax), %rdx
	movq	-8(%rbp), %rax
	addq	$4, %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	printBlock
	movq	-8(%rbp), %rax
	leaq	7(%rax), %rdx
	movq	-8(%rbp), %rax
	addq	$6, %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	printBlock
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	printTetris, .-printTetris
	.globl	clearBlock
	.type	clearBlock, @function
clearBlock:
.LFB9:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-16(%rbp), %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	p_grid(%rip), %rax
	movq	(%rdx,%rax), %rax
	movzwl	(%rax), %eax
	movl	%eax, %esi
	movq	-8(%rbp), %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	movl	$1, %edx
	movl	%eax, %ecx
	sall	%cl, %edx
	movl	%edx, %eax
	xorl	%eax, %esi
	movl	%esi, %ecx
	movq	-16(%rbp), %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	p_grid(%rip), %rax
	movq	(%rdx,%rax), %rax
	movl	%ecx, %edx
	movw	%dx, (%rax)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	clearBlock, .-clearBlock
	.globl	clearTetris
	.type	clearTetris, @function
clearTetris:
.LFB10:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$8, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	-8(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	clearBlock
	movq	-8(%rbp), %rax
	leaq	3(%rax), %rdx
	movq	-8(%rbp), %rax
	addq	$2, %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	clearBlock
	movq	-8(%rbp), %rax
	leaq	5(%rax), %rdx
	movq	-8(%rbp), %rax
	addq	$4, %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	clearBlock
	movq	-8(%rbp), %rax
	leaq	7(%rax), %rdx
	movq	-8(%rbp), %rax
	addq	$6, %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	clearBlock
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	clearTetris, .-clearTetris
	.globl	tetrisDown
	.type	tetrisDown, @function
tetrisDown:
.LFB11:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-8(%rbp), %rax
	addq	$1, %rax
	movzbl	(%rax), %eax
	cmpb	$18, %al
	ja	.L13
	movq	-8(%rbp), %rax
	addq	$1, %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	addl	$1, %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	p_grid(%rip), %rax
	movq	(%rdx,%rax), %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %edx
	movq	-8(%rbp), %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	movl	%eax, %ecx
	sarl	%cl, %edx
	movl	%edx, %eax
	andl	$1, %eax
	testl	%eax, %eax
	je	.L14
.L13:
	movq	-16(%rbp), %rax
	movzbl	(%rax), %eax
	movl	$16, %edx
	orl	%eax, %edx
	movq	-16(%rbp), %rax
	movb	%dl, (%rax)
	jmp	.L12
.L14:
	movq	-8(%rbp), %rax
	addq	$3, %rax
	movzbl	(%rax), %eax
	cmpb	$18, %al
	ja	.L16
	movq	-8(%rbp), %rax
	addq	$3, %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	addl	$1, %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	p_grid(%rip), %rax
	movq	(%rdx,%rax), %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %edx
	movq	-8(%rbp), %rax
	addq	$2, %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	movl	%eax, %ecx
	sarl	%cl, %edx
	movl	%edx, %eax
	andl	$1, %eax
	testl	%eax, %eax
	je	.L17
.L16:
	movq	-16(%rbp), %rax
	movzbl	(%rax), %eax
	movl	$16, %edx
	orl	%eax, %edx
	movq	-16(%rbp), %rax
	movb	%dl, (%rax)
	jmp	.L12
.L17:
	movq	-8(%rbp), %rax
	addq	$5, %rax
	movzbl	(%rax), %eax
	cmpb	$18, %al
	ja	.L18
	movq	-8(%rbp), %rax
	addq	$5, %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	addl	$1, %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	p_grid(%rip), %rax
	movq	(%rdx,%rax), %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %edx
	movq	-8(%rbp), %rax
	addq	$4, %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	movl	%eax, %ecx
	sarl	%cl, %edx
	movl	%edx, %eax
	andl	$1, %eax
	testl	%eax, %eax
	je	.L19
.L18:
	movq	-16(%rbp), %rax
	movzbl	(%rax), %eax
	movl	$16, %edx
	orl	%eax, %edx
	movq	-16(%rbp), %rax
	movb	%dl, (%rax)
	jmp	.L12
.L19:
	movq	-8(%rbp), %rax
	addq	$7, %rax
	movzbl	(%rax), %eax
	cmpb	$18, %al
	ja	.L20
	movq	-8(%rbp), %rax
	addq	$7, %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	addl	$1, %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	p_grid(%rip), %rax
	movq	(%rdx,%rax), %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %edx
	movq	-8(%rbp), %rax
	addq	$6, %rax
	movzbl	(%rax), %eax
	movzbl	%al, %eax
	movl	%eax, %ecx
	sarl	%cl, %edx
	movl	%edx, %eax
	andl	$1, %eax
	testl	%eax, %eax
	je	.L21
.L20:
	movq	-16(%rbp), %rax
	movzbl	(%rax), %eax
	movl	$16, %edx
	orl	%eax, %edx
	movq	-16(%rbp), %rax
	movb	%dl, (%rax)
	jmp	.L12
.L21:
	movq	-8(%rbp), %rax
	addq	$1, %rax
	movzbl	(%rax), %edx
	addl	$1, %edx
	movb	%dl, (%rax)
	movq	-8(%rbp), %rax
	addq	$3, %rax
	movzbl	(%rax), %edx
	addl	$1, %edx
	movb	%dl, (%rax)
	movq	-8(%rbp), %rax
	addq	$5, %rax
	movzbl	(%rax), %edx
	addl	$1, %edx
	movb	%dl, (%rax)
	movq	-8(%rbp), %rax
	addq	$7, %rax
	movzbl	(%rax), %edx
	addl	$1, %edx
	movb	%dl, (%rax)
.L12:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	tetrisDown, .-tetrisDown
	.globl	setCoords
	.type	setCoords, @function
setCoords:
.LFB12:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	p_grid(%rip), %rax
	movzwl	(%rax), %eax
	testw	%ax, %ax
	je	.L23
	movl	$32, %eax
	notl	%eax
	movl	%eax, %edx
	movzbl	flag(%rip), %eax
	andl	%edx, %eax
	movb	%al, flag(%rip)
	jmp	.L22
.L23:
	call	rand@PLT
	movslq	%eax, %rdx
	imulq	$-1840700269, %rdx, %rdx
	shrq	$32, %rdx
	addl	%eax, %edx
	sarl	$2, %edx
	movl	%eax, %ecx
	sarl	$31, %ecx
	subl	%ecx, %edx
	movl	%edx, -4(%rbp)
	movl	-4(%rbp), %ecx
	movl	%ecx, %edx
	sall	$3, %edx
	subl	%ecx, %edx
	subl	%edx, %eax
	movl	%eax, -4(%rbp)
	movl	$0, -8(%rbp)
	jmp	.L25
.L26:
	movl	-8(%rbp), %eax
	cltq
	movl	-4(%rbp), %edx
	movslq	%edx, %rdx
	salq	$3, %rdx
	addq	%rax, %rdx
	leaq	figures(%rip), %rax
	addq	%rdx, %rax
	movzbl	(%rax), %edx
	movl	-8(%rbp), %eax
	cltq
	leaq	coords(%rip), %rcx
	movb	%dl, (%rax,%rcx)
	addl	$1, -8(%rbp)
.L25:
	cmpl	$7, -8(%rbp)
	jle	.L26
.L22:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	setCoords, .-setCoords
	.globl	checkColision
	.type	checkColision, @function
checkColision:
.LFB13:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movzbl	flag(%rip), %eax
	movl	$16, %edx
	andl	%edx, %eax
	movl	$16, %edx
	cmpb	%dl, %al
	jne	.L29
	leaq	coords(%rip), %rax
	movq	%rax, %rdi
	call	printTetris
	call	setCoords
	movzbl	flag(%rip), %eax
	movl	$16, %edx
	xorl	%edx, %eax
	movb	%al, flag(%rip)
.L29:
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	checkColision, .-checkColision
	.globl	rotateTetris
	.type	rotateTetris, @function
rotateTetris:
.LFB14:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movb	$0, -18(%rbp)
	jmp	.L31
.L36:
	movzbl	1+coords(%rip), %edx
	movzbl	coords(%rip), %eax
	leal	(%rdx,%rax), %ecx
	movzbl	-18(%rbp), %eax
	addl	$1, %eax
	cltq
	leaq	coords(%rip), %rdx
	movzbl	(%rax,%rdx), %eax
	subl	%eax, %ecx
	movl	%ecx, %edx
	movzbl	-18(%rbp), %eax
	cltq
	movb	%dl, -16(%rbp,%rax)
	movzbl	-18(%rbp), %eax
	cltq
	leaq	coords(%rip), %rdx
	movzbl	(%rax,%rdx), %eax
	movzbl	coords(%rip), %edx
	subl	%edx, %eax
	movl	%eax, %ecx
	movzbl	1+coords(%rip), %eax
	leal	(%rcx,%rax), %edx
	movzbl	-18(%rbp), %eax
	addl	$1, %eax
	cltq
	movb	%dl, -16(%rbp,%rax)
	movzbl	-18(%rbp), %eax
	addl	$1, %eax
	cltq
	movzbl	-16(%rbp,%rax), %eax
	testb	%al, %al
	js	.L41
	movzbl	-18(%rbp), %eax
	cltq
	movzbl	-16(%rbp,%rax), %eax
	testb	%al, %al
	js	.L42
	movzbl	-18(%rbp), %eax
	cltq
	movzbl	-16(%rbp,%rax), %eax
	cmpb	$9, %al
	jg	.L42
	movzbl	-18(%rbp), %eax
	addl	$1, %eax
	cltq
	movzbl	-16(%rbp,%rax), %eax
	movsbl	%al, %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	p_grid(%rip), %rax
	movq	(%rdx,%rax), %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %edx
	movzbl	-18(%rbp), %eax
	cltq
	movzbl	-16(%rbp,%rax), %eax
	movsbl	%al, %eax
	subl	$1, %eax
	movl	%eax, %ecx
	sarl	%cl, %edx
	movl	%edx, %eax
	andl	$1, %eax
	testl	%eax, %eax
	jne	.L42
	addb	$2, -18(%rbp)
.L31:
	cmpb	$7, -18(%rbp)
	jbe	.L36
	movb	$0, -17(%rbp)
	jmp	.L37
.L38:
	movzbl	-17(%rbp), %eax
	cltq
	movzbl	-16(%rbp,%rax), %edx
	movzbl	-17(%rbp), %eax
	movl	%edx, %ecx
	cltq
	leaq	coords(%rip), %rdx
	movb	%cl, (%rax,%rdx)
	movzbl	-17(%rbp), %eax
	addl	$1, %eax
	cltq
	movzbl	-16(%rbp,%rax), %edx
	movzbl	-17(%rbp), %eax
	addl	$1, %eax
	movl	%edx, %ecx
	cltq
	leaq	coords(%rip), %rdx
	movb	%cl, (%rax,%rdx)
	addb	$2, -17(%rbp)
.L37:
	cmpb	$7, -17(%rbp)
	jbe	.L38
	jmp	.L30
.L41:
	nop
	jmp	.L30
.L42:
	nop
.L30:
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L40
	call	__stack_chk_fail@PLT
.L40:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE14:
	.size	rotateTetris, .-rotateTetris
	.globl	horMoveLeft
	.type	horMoveLeft, @function
horMoveLeft:
.LFB15:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movzbl	coords(%rip), %eax
	testb	%al, %al
	je	.L53
	movzbl	1+coords(%rip), %eax
	movzbl	%al, %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	p_grid(%rip), %rax
	movq	(%rdx,%rax), %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %edx
	movzbl	coords(%rip), %eax
	movzbl	%al, %eax
	subl	$1, %eax
	movl	%eax, %ecx
	sarl	%cl, %edx
	movl	%edx, %eax
	andl	$1, %eax
	testl	%eax, %eax
	jne	.L53
	movzbl	2+coords(%rip), %eax
	testb	%al, %al
	je	.L54
	movzbl	3+coords(%rip), %eax
	movzbl	%al, %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	p_grid(%rip), %rax
	movq	(%rdx,%rax), %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %edx
	movzbl	2+coords(%rip), %eax
	movzbl	%al, %eax
	subl	$1, %eax
	movl	%eax, %ecx
	sarl	%cl, %edx
	movl	%edx, %eax
	andl	$1, %eax
	testl	%eax, %eax
	jne	.L54
	movzbl	4+coords(%rip), %eax
	testb	%al, %al
	je	.L55
	movzbl	5+coords(%rip), %eax
	movzbl	%al, %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	p_grid(%rip), %rax
	movq	(%rdx,%rax), %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %edx
	movzbl	4+coords(%rip), %eax
	movzbl	%al, %eax
	subl	$1, %eax
	movl	%eax, %ecx
	sarl	%cl, %edx
	movl	%edx, %eax
	andl	$1, %eax
	testl	%eax, %eax
	jne	.L55
	movzbl	6+coords(%rip), %eax
	testb	%al, %al
	je	.L56
	movzbl	7+coords(%rip), %eax
	movzbl	%al, %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	p_grid(%rip), %rax
	movq	(%rdx,%rax), %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %edx
	movzbl	6+coords(%rip), %eax
	movzbl	%al, %eax
	subl	$1, %eax
	movl	%eax, %ecx
	sarl	%cl, %edx
	movl	%edx, %eax
	andl	$1, %eax
	testl	%eax, %eax
	jne	.L56
	movzbl	coords(%rip), %eax
	subl	$1, %eax
	movb	%al, coords(%rip)
	movzbl	2+coords(%rip), %eax
	subl	$1, %eax
	movb	%al, 2+coords(%rip)
	movzbl	4+coords(%rip), %eax
	subl	$1, %eax
	movb	%al, 4+coords(%rip)
	movzbl	6+coords(%rip), %eax
	subl	$1, %eax
	movb	%al, 6+coords(%rip)
	jmp	.L43
.L53:
	nop
	jmp	.L43
.L54:
	nop
	jmp	.L43
.L55:
	nop
	jmp	.L43
.L56:
	nop
.L43:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE15:
	.size	horMoveLeft, .-horMoveLeft
	.globl	horMoveRight
	.type	horMoveRight, @function
horMoveRight:
.LFB16:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movzbl	coords(%rip), %eax
	cmpb	$8, %al
	ja	.L67
	movzbl	1+coords(%rip), %eax
	movzbl	%al, %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	p_grid(%rip), %rax
	movq	(%rdx,%rax), %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %edx
	movzbl	coords(%rip), %eax
	movzbl	%al, %eax
	addl	$1, %eax
	movl	%eax, %ecx
	sarl	%cl, %edx
	movl	%edx, %eax
	andl	$1, %eax
	testl	%eax, %eax
	jne	.L67
	movzbl	2+coords(%rip), %eax
	cmpb	$8, %al
	ja	.L68
	movzbl	3+coords(%rip), %eax
	movzbl	%al, %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	p_grid(%rip), %rax
	movq	(%rdx,%rax), %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %edx
	movzbl	2+coords(%rip), %eax
	movzbl	%al, %eax
	addl	$1, %eax
	movl	%eax, %ecx
	sarl	%cl, %edx
	movl	%edx, %eax
	andl	$1, %eax
	testl	%eax, %eax
	jne	.L68
	movzbl	4+coords(%rip), %eax
	cmpb	$8, %al
	ja	.L69
	movzbl	5+coords(%rip), %eax
	movzbl	%al, %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	p_grid(%rip), %rax
	movq	(%rdx,%rax), %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %edx
	movzbl	4+coords(%rip), %eax
	movzbl	%al, %eax
	addl	$1, %eax
	movl	%eax, %ecx
	sarl	%cl, %edx
	movl	%edx, %eax
	andl	$1, %eax
	testl	%eax, %eax
	jne	.L69
	movzbl	6+coords(%rip), %eax
	cmpb	$8, %al
	ja	.L70
	movzbl	7+coords(%rip), %eax
	movzbl	%al, %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	p_grid(%rip), %rax
	movq	(%rdx,%rax), %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %edx
	movzbl	6+coords(%rip), %eax
	movzbl	%al, %eax
	addl	$1, %eax
	movl	%eax, %ecx
	sarl	%cl, %edx
	movl	%edx, %eax
	andl	$1, %eax
	testl	%eax, %eax
	jne	.L70
	movzbl	coords(%rip), %eax
	addl	$1, %eax
	movb	%al, coords(%rip)
	movzbl	2+coords(%rip), %eax
	addl	$1, %eax
	movb	%al, 2+coords(%rip)
	movzbl	4+coords(%rip), %eax
	addl	$1, %eax
	movb	%al, 4+coords(%rip)
	movzbl	6+coords(%rip), %eax
	addl	$1, %eax
	movb	%al, 6+coords(%rip)
	jmp	.L57
.L67:
	nop
	jmp	.L57
.L68:
	nop
	jmp	.L57
.L69:
	nop
	jmp	.L57
.L70:
	nop
.L57:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE16:
	.size	horMoveRight, .-horMoveRight
	.globl	checkISR
	.type	checkISR, @function
checkISR:
.LFB17:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, %eax
	movb	%al, -4(%rbp)
	cmpb	$112, -4(%rbp)
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE17:
	.size	checkISR, .-checkISR
	.globl	checkTetris
	.type	checkTetris, @function
checkTetris:
.LFB18:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movw	$1023, -18(%rbp)
	movl	$19, -16(%rbp)
	jmp	.L74
.L78:
	movl	-16(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	p_grid(%rip), %rax
	movq	(%rdx,%rax), %rax
	movzwl	(%rax), %eax
	andw	-18(%rbp), %ax
	cmpw	%ax, -18(%rbp)
	jne	.L75
	movl	-16(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	p_grid(%rip), %rax
	movq	(%rdx,%rax), %rax
	movq	%rax, -8(%rbp)
	movl	-16(%rbp), %eax
	movl	%eax, -12(%rbp)
	jmp	.L76
.L77:
	movl	-12(%rbp), %eax
	subl	$1, %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	p_grid(%rip), %rax
	movq	(%rdx,%rax), %rax
	movl	-12(%rbp), %edx
	movslq	%edx, %rdx
	leaq	0(,%rdx,8), %rcx
	leaq	p_grid(%rip), %rdx
	movq	%rax, (%rcx,%rdx)
	subl	$1, -12(%rbp)
.L76:
	cmpl	$0, -12(%rbp)
	jg	.L77
	movq	-8(%rbp), %rax
	movq	%rax, p_grid(%rip)
	movq	p_grid(%rip), %rax
	movw	$0, (%rax)
.L75:
	subl	$1, -16(%rbp)
.L74:
	cmpl	$0, -16(%rbp)
	jns	.L78
	nop
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE18:
	.size	checkTetris, .-checkTetris
	.globl	gameLoop
	.type	gameLoop, @function
gameLoop:
.LFB19:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	call	setCoords
	leaq	mtx(%rip), %rax
	movq	%rax, %rdi
	call	pthread_mutex_lock@PLT
.L80:
	leaq	coords(%rip), %rax
	movq	%rax, %rdi
	call	printTetris
	call	show
	leaq	mtx(%rip), %rax
	movq	%rax, %rdi
	call	pthread_mutex_unlock@PLT
	movl	$500000, %edi
	call	usleep@PLT
	leaq	mtx(%rip), %rax
	movq	%rax, %rdi
	call	pthread_mutex_lock@PLT
	leaq	coords(%rip), %rax
	movq	%rax, %rdi
	call	printTetris
	leaq	coords(%rip), %rax
	movq	%rax, %rdi
	call	clearTetris
	leaq	flag(%rip), %rdx
	leaq	coords(%rip), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	tetrisDown
	call	checkColision
	call	checkTetris
	movzbl	flag(%rip), %eax
	movl	$32, %edx
	andl	%edx, %eax
	testb	%al, %al
	jne	.L80
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE19:
	.size	gameLoop, .-gameLoop
	.globl	userInput
	.type	userInput, @function
userInput:
.LFB20:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$176, %rsp
	movq	%rdi, -168(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-144(%rbp), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	tcgetattr@PLT
	movq	-144(%rbp), %rax
	movq	-136(%rbp), %rdx
	movq	%rax, -80(%rbp)
	movq	%rdx, -72(%rbp)
	movq	-128(%rbp), %rax
	movq	-120(%rbp), %rdx
	movq	%rax, -64(%rbp)
	movq	%rdx, -56(%rbp)
	movq	-112(%rbp), %rax
	movq	-104(%rbp), %rdx
	movq	%rax, -48(%rbp)
	movq	%rdx, -40(%rbp)
	movq	-100(%rbp), %rax
	movq	-92(%rbp), %rdx
	movq	%rax, -36(%rbp)
	movq	%rdx, -28(%rbp)
	movl	-132(%rbp), %eax
	andl	$-11, %eax
	movl	%eax, -132(%rbp)
	leaq	-144(%rbp), %rax
	movq	%rax, %rdx
	movl	$0, %esi
	movl	$0, %edi
	call	tcsetattr@PLT
	movl	$2048, %edx
	movl	$4, %esi
	movl	$0, %edi
	movl	$0, %eax
	call	fcntl@PLT
	jmp	.L83
.L88:
	call	getchar@PLT
	movb	%al, -145(%rbp)
	cmpb	$-1, -145(%rbp)
	je	.L84
	leaq	mtx(%rip), %rax
	movq	%rax, %rdi
	call	pthread_mutex_lock@PLT
	leaq	coords(%rip), %rax
	movq	%rax, %rdi
	call	clearTetris
	cmpb	$97, -145(%rbp)
	jne	.L85
	call	horMoveLeft
.L85:
	cmpb	$100, -145(%rbp)
	jne	.L86
	call	horMoveRight
.L86:
	cmpb	$119, -145(%rbp)
	jne	.L87
	call	rotateTetris
.L87:
	leaq	coords(%rip), %rax
	movq	%rax, %rdi
	call	printTetris
	call	show
	leaq	mtx(%rip), %rax
	movq	%rax, %rdi
	call	pthread_mutex_unlock@PLT
.L84:
	movl	$20000, %edi
	call	usleep@PLT
.L83:
	movzbl	flag(%rip), %eax
	movl	$32, %edx
	andl	%edx, %eax
	testb	%al, %al
	jne	.L88
	leaq	-80(%rbp), %rax
	movq	%rax, %rdx
	movl	$0, %esi
	movl	$0, %edi
	call	tcsetattr@PLT
	movl	$0, %eax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L90
	call	__stack_chk_fail@PLT
.L90:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE20:
	.size	userInput, .-userInput
	.globl	main
	.type	main, @function
main:
.LFB21:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$0, -28(%rbp)
	jmp	.L92
.L93:
	movl	-28(%rbp), %eax
	cltq
	leaq	(%rax,%rax), %rdx
	leaq	s_grid(%rip), %rax
	movw	$0, (%rdx,%rax)
	movl	-28(%rbp), %eax
	cltq
	leaq	(%rax,%rax), %rdx
	leaq	s_grid(%rip), %rax
	leaq	(%rdx,%rax), %rcx
	movl	-28(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	p_grid(%rip), %rax
	movq	%rcx, (%rdx,%rax)
	addl	$1, -28(%rbp)
.L92:
	cmpl	$19, -28(%rbp)
	jle	.L93
	leaq	mtx(%rip), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	pthread_mutex_init@PLT
	leaq	gameLoop(%rip), %rdx
	leaq	-24(%rbp), %rax
	movl	$0, %ecx
	movl	$0, %esi
	movq	%rax, %rdi
	call	pthread_create@PLT
	leaq	userInput(%rip), %rdx
	leaq	-16(%rbp), %rax
	movl	$0, %ecx
	movl	$0, %esi
	movq	%rax, %rdi
	call	pthread_create@PLT
	movq	-16(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	pthread_join@PLT
	movq	-24(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	pthread_join@PLT
	movl	$0, %eax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L95
	call	__stack_chk_fail@PLT
.L95:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE21:
	.size	main, .-main
	.ident	"GCC: (GNU) 15.2.1 20251112"
	.section	.note.GNU-stack,"",@progbits
