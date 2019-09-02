!Name: Shah Farzan Al-Hafiz
!ID: 10162590
!CPSC 355-T06


fmt:	
	.asciz "Checksum before feeding: 0x%x\n"		
	.align 4

fmt1:	
	.asciz "Values of Input registers: 0x%x\n"			
	.align 4

fmt2:	
	.asciz "Checksum after feeding: 0x%x\n"
	.align 4

	.global main
main:
	save	 %sp, -96, %sp
	set		0xaaaa8c01, %l4		!stores input for %l4.
	set		0xff001234, %l5		!stores input for %l5.
	set		0x13579bdf,	%l6		!stores input for %l6.
	set		0xc8b4ae32, %l7		!stores input for %l7.
	set		0xffffffff, %l0		!make all bits of %l0 = 1.
	set		0x0000ffff, %o0		!store bitmask into %o0.
	and		%l0, %o0, %l0		!convert left half of %l0 to 0.
	set		fmt, %o0			!move fmt formatter into %o0.
	call	printf				!call print instruction.
	mov		%l0, %o1			!copy %l0 into %o1.
	set		fmt1, %o0			!move fmt1 formatter into %o0.
	call	printf				!call print instruction.
	mov		%l4, %o1			!copy input into %o1
	set		fmt1, %o0			!move fmt1 formatter into %o0.
	call	printf				!call print instruction.
	mov		%l5, %o1			!copy input into %o1.
	set		fmt1, %o0			!move fmt1 formatter into %o0.
	call	printf				!call print instruction.
	mov		%l6, %o1			!copy input into %o1.
	set		fmt1, %o0			!move fmt1 formatter into %o0
	call	printf				!call print instruction.
	mov		%l7, %o1			!move input into %o1.
	mov		32, %l1				!stores hardcoded 32 to %l1.
	mov		%l4, %l3			!copy %l4 into %l3.
	ba		looptest			!branch always to looptest.
	mov		4, %l2				!copies 4 to %l2.
	
	
	
	
start:
	sll		%l0, 1, %l0			!Moves %l0 to left by one bit
	srl		%l3, 31, %o0		!Moves current bit into %o0
	or		%l0, %o0, %l0		!Moves current bit into 0th spot in %l0
	set		0x00010000, %o0		!Moves bitmask into %o0
	and		%l0, %o0, %o1		!Isolates bit of index 16 in %l0
	cmp		%o0, %o1			!Checks if bit is 1 or not
	bne		dec				!Branches if no xor is necesssary (bit = 0)
	sll		%l3, 1, %l3			!Shift hashing register to left by 1 bit
	set		0x00001021, %o0		!Moves xor bitmask into %o0
	xor		%l0, %o0, %l0		!xors bitmask with %l0
		


dec:		
	sub		%l1, 1, %l1			!subtract 1 from index.
		


looptest:
	cmp 	%l1, 0				!compare %l1 with 0.
	bg		start				!branch on greater than to start.
	nop							!delay slot.
	mov		32, %l1				!copies 32 to %l1.
	add		%l2, 1, %l2			!increments register by 1
	cmp		%l2, 5				!compare %l5 with 5.
	be		looptest			!branch on equal to looptest.
	mov		%l5, %l3			!copy %l5 to %l3.		
	cmp		%l2, 6				!compare %l2 with 6.
	be		looptest			!branch on equal to looptest.
	mov		%l6, %l3			!copies %l6 into %l3.
	cmp		%l2, 7				!compare %l2 with 7.
	be		looptest			!branch on equal to looptest.
	mov		%l7, %l3			!copies %l7 into %l3.
	ba		finish				!branch always to finish.
	nop 						!delay slot.
		
	
	
finish:
	set		0x0000ffff, %o0		!puts 0xFFFF into %o0
	and		%l0, %o0, %l0		!make the left half bits 0.
	set		fmt2, %o0			!move fmt2 formatter into %o0
	call	printf				!call print instruction.
	mov		%l0, %o1			!copy %l0 into %o1.
		
	mov		1, %g1				!trap dispatch.
	ta		0					!trap to system, exit.
