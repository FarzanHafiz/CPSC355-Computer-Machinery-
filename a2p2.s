!Shah Farzan Al-Hafiz
!ID: 10162590
!CPSC 355-T06



fmt:
	.asciz	"Multiplicand: 0x%x\nMultiplier: 0x%x\nFinal Product Value: 0x%x\nFinal Multiplier Value: 0x%x \n\n"
	.align 4


	
	.global main
main:
	save	%sp,-96, %sp
	set		82732983, %l0		!store multiplicand value in %l0.
	set		0x0, %l1			!put 0 as the initial product value.
	set		120490892, %l2		!store multiplier value1 in %l2.
	mov		%l2, %l7			!copy multiplier value to %l7.
	set		0x80000000,	%l3		!Use %l3 to check the multiplier sign.
	andcc	%l2, %l3, %g0		!comparing %l2 & %l3.
	bneg,a	negated				!branch on negative.
	set		1, %l4				!using %l4 as it's negative.
	ba		start				!branch always to start.
	set		0, %l4				!using %l4 because of positve.


negated:
start:
	set		0, %l5				


loop:
	cmp		%l5, 32				!compare with 32.
	bge,a	endloop				!branch on greater or equal.
	andcc	%l4, 0x1, %g0		!andcc %l4 with 0x1 and store in %g0.
	andcc	%l2, 0x1, %g0		!check lsb of multiplier 0 if it's zero 1 if it's one
	be		lsbzero				!branch to lsbzero when lsb of multiplier =0
	nop							!delay slot.
	add		%l0, %l1, %l1		!add contents of %l0 and %l1 and store in %l1.
	
	
lsbzero:
	srl		%l2, 1,	%l2			!shift right logical of %l2.
	mov		%l1, %l6			!copying %l1 to %l6.
	sra		%l1, 1,	%l1			!shift right arithmetic of %l1(product).
	sll		%l6, 31, %l6		!shift all bits by 31 in %l6.
	xor		%l6, %l2, %l2		!xor %l6 with %l2.
	ba		loop				!branch always to the loop.
	inc		%l5					!increment counter.


endloop:
	be		finish				!branch on equal to finish.
	nop							!delay slot.
	mov		%l0, %l6			!copy %l0 to %l6 if negative.
	xor		%l6, 0xffffffff, %l6	!toggle l6.
	add		%l6, 1,	%l6			!add 1 to get the two's compliment.
	add		%l1, %l6, %l1		!adding contents of %l1 and %l6.


finish:
	set		fmt, %o0			!move fmt formatter into %0o.
	mov		%l0, %o1			!initial multiplicand into %o1.
	mov		%l7, %o2			!initial multiplier into %o2.
	mov		%l1, %o3			!product in %o3.
	call	printf				!calling print instruction.
	mov		%l2, %o4			!multiplier into %o4.


	set		82732983, %l0		!store multiplicand in %l0.
	set		0x0, %l1			!put 0 as initial product value.
	set		-120490892,	%l2		!store multiplier in %l2.
	mov		%l2, %l7			!copy multiplier value to %l7.
	set		0x80000000,	%l3		!use %l3 to check multiplier sign.
	andcc	%l2, %l3, %g0		!compare %l2 & %l3.
	bneg,a	negated1			!branch on negative.
	set		1, %l4				!using %l4 as its negative.
	ba		start1				!branch always to start1.
	set		0, %l4				!use %l4 if positive.


negated1:	
start1:
	set	0,		%l5				!put 0 into %l5.


loop1:
	cmp		%l5, 32				!compare with 32.
	bge,a	endloop1			!branch on greater or equal.
	andcc	%l4, 0x1, %g0		!andcc %l4 and hexadecimal 0x1.
	andcc	%l2, 0x1, %g0		!andcc %l2 and hexadecimal 0x1.
	be		lsbzero1			!branch on equal.
	nop							!delay slot.
	add		%l0, %l1, %l1		!add %l0 and %l1.

	
lsbzero1:
	srl		%l2, 1,	%l2			!shift right by 1.
	mov		%l1, %l6			!copying %l1 to %l6.
	sra		%l1, 1,	%l1			!shift the product right by one.
	sll		%l6, 31, %l6		!shift the copy of product by 31.  
	xor		%l6, %l2, %l2		!xor %l6 with l2.
	ba		loop1				!branch always to loop1.
	inc		%l5					!increment %l5.


endloop1:
	be		finish1				!branch on equal to finish1.
	nop							!delay slot.
	mov		%l0, %l6			!copying %l0 to %l6.
	xor		%l6, 0xffffffff, %l6	!toggle %l6.
	add		%l6, 1,	%l6			!add 1 to get the two's compliment
	add		%l1, %l6,%l1		!adding contents of %l1 and %l6.


finish1:
	set		fmt, %o0			!move fmt formatter into %o0.
	mov		%l0, %o1			!initial multiplicand into %o1.
	mov		%l7, %o2			!initial multiplier into %o2.
	mov		%l1, %o3			!product in %o3. 
	call	printf				!calling print instruction.
	mov		%l2, %o4			!multiplier into %o4.
	

	set		-82732983, %l0		!store multiplicand in %l0.
	set		0x0, %l1			!put 0 as the initial product.
	set		-120490892,	%l2		!store multiplier in %l2.
	mov		%l2, %l7			!copy multiplier value to %l7.
	set		0x80000000,	%l3		!use %l3 to check the sign of the multiplier.
	andcc	%l2, %l3, %g0		!compare %l2 & %l3.
	bneg,a	negated2			!branch on negative.
	set		1, %l4				!use %l4 if negative.
	ba		start2				!branch always to start2.
	set		0, %l4				!put 0 into %l4.


negated2:	
start2:
	set	0,		%l5		!initialize i =0


loop2:
	cmp		%l5, 32				!compare with 32.
	bge,a	endloop2			!branch on greater than or equal.
	andcc	%l4, 0x1, %g0		!andcc %l4 with 0x1.
	andcc	%l2, 0x1, %g0		!andcc %l2 with 0x1.
	be		lsbzero2			!branch on equal.
	nop							!delay slot.
	add		%l0, %l1, %l1		!add contents of %l0 and %l1.


	
lsbzero2:
	srl		%l2, 1,	%l2			!shift right logical by 1.
	mov		%l1, %l6			!copy %l1 to %l6.
	sra		%l1, 1,	%l1			!shift right arithmetic by 1.
	sll		%l6, 31, %l6		!shift left by 31.
	xor		%l6, %l2, %l2		!xor %l6 with %l2.
	ba		loop2				!branch always to loop2
	inc		%l5					!increments %l5.


endloop2:
	be		end2				!branch on equal.
	nop							!delay slot.
	mov		%l0, %l6			!copy %l0 to %l6.
	xor		%l6, 0xffffffff, %l6	!toggle %l6.
	add		%l6, 1,	%l6			!add 1 to get the two's compliment.
	add		%l1, %l6, %l1		!add %l1 and %l6.


end2:
	set		fmt, %o0			!move fmt formatter into %o0.
	mov		%l0, %o1			!initial multiplicand into %o1.
	mov		%l7, %o2			!initial multiplier into %o2.
	mov		%l1, %o3			!product in %o3. 
	call	printf				!delay slot.
	mov		%l2, %o4			!multiplier into %o4.

	mov		1, %g1				!trap dispatch
	ta		0					!trap to system, exit
