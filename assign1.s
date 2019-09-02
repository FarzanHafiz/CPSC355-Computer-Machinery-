!Shah Farzan Al-Hafiz
!ID: 10162590
!CPSC 355-T06

	
fmt:	.asciz "X-value: %d\nY-value: %d\nMinimum: %d\n\n"
		.align 4
	
	.global main
main:	save	%sp, -96, %sp
		mov		-2, %l0		!initialize %lo to -2(initial value of x)
		clr		%l7			!clearing %l3 to zero

start:
		mov		%l0, %o0		!Copying the initial value of x into register %o0
		mov		%l0, %o1		!Copying the initial value of x into register %o1
		call	.mul			!Making x^2 by multiplying %o0 and %o1
		nop						!Delay slot
		
		mov		%o0, %l1		!Storing x^2 into %l1
		mov		%l0, %o1		!Copying the value of x in %o1
		call	.mul			!Multiplying x and x^2 to get x^3
		nop						!Delay slot
		
		mov		%o0, %l2		!Copying x^3 into %l2
		
		mov		2, %o1			!Assign 2 to %o1
		call	.mul			!Multiplying 2 and X^3 to get 2x^3
		nop						!Delay slot
		
		mov		%o0, %l3		!Storing 2x^3 into %l3
		
		mov		%l1, %o0		!Copying x^2 into %o0
		mov		-18, %o1		!Assign -18 to %o1
		call	.mul			!Multiplying -18 and x^2 to get -18x^2
		nop						!Delay slot
		
		mov		%o0, %l4		!Storing -18x^2 into %l4
		
		add		%l3, %l4, %l5	!Adding and storing 2x^3-18x^2 into %l5
		
		mov		%l0, %o0		!Copying x value into %o0
		mov		10, %o1			!Assign 10 to %o1
		call	.mul			!Multiplying 10 and x to get 10x
		nop						!Delay slot
		
		add		%o0, 39, %l6	!Adding and storing 10x+39 into %l6
		add		%l5, %l6, %l1	!Adding 2x^3-18x^2 and 10x+39 to make the whole expression

		
		cmp		%l1, %l7		!Comparing the two values
		bg		loop			!Branch if %l3 > %l1
		nop						!Delay slot
		mov		%l1, %l7		!Store the minimum into %l3
		
loop:
		set 	fmt, %o0
		mov		%l0, %o1		!Storing x into %o1
		mov		%l1, %o2		!Storing y into %o2
		mov		%l7, %o3		!Storing the minimum into %o3
		call	printf			!Prints content stored in %o1, %o2, %o3
		nop						!Delay slots
		
		inc		%l0				!Incrementing x
		cmp		%l0, 11			!Comparing x to 11
		ble		start			!Branch if x <= 11
		nop						!Delay slot
		
		mov		%l3, %l0

end:
		mov		1, %g1
		ta 0
