!Shah Farzan Al-Hafiz
!ID: 10162590
!CPSC 355-T06

	
		define(x_r, l0)			!x register
		define(y_r, l1)			!y register
		define(c1, 2)
		define(c2, -18)
		define(c3, 10)
		define(c4, 39)
		

	
fmt:	.asciz "X-value: %d\nY-value: %d\nMinimum: %d\n\n"
		.align 4
	
	.global main
main:	save	%sp, -96, %sp
		mov		-2, %x_r		!initialize %x_r to -2(initial value of x)
		clr		%l7				!clearing %l7 to zero
		mov		%x_r, %o0		!Copying the initial value of x into register %o0

start:
		
		
		call	.mul			!Making x^2 by multiplying %o0 and %o1
		mov		%x_r, %o1		!Copying the initial value of x into register %o1
		
		mov		%o0, %y_r		!Storing x^2 into %y_r
		
		call	.mul			!Multiplying x and x^2 to get x^3
		mov		%x_r, %o1		!Copying the value of x in %o1	
		
		mov		%o0, %l2		!Copying x^3 into %l2
		
		
		call	.mul			!Multiplying 2 and X^3 to get 2x^3
		mov		c1, %o1			!Assign 2 to %o1
		
		mov		%o0, %l3		!Storing 2x^3 into %l3
		
		mov		%y_r, %o0		!Copying x^2 into %o0
		
		call	.mul			!Multiplying -18 and x^2 to get -18x^2
		mov		c2, %o1			!Assign -18 to %o1
		
		mov		%o0, %l4		!Storing -18x^2 into %l4
		
		add		%l3, %l4, %l5	!Adding and storing 2x^3-18x^2 into %l5
		
		mov		%x_r, %o0		!Copying x value into %o0
		
		call	.mul			!Multiplying 10 and x to get 10x
		mov		c3, %o1			!Assign 10 to %o1
		
		add		%o0, c4, %l6	!Adding and storing 10x+39 into %l6
		add		%l5, %l6, %y_r	!Adding 2x^3-18x^2 and 10x+39 to make the whole expression

		
		cmp		%y_r, %l7		!Comparing the two values
		bg,a	loop			!Branch if %l3 > %y_r
		mov		%x_r, %o1		!Storing x into %o1
		mov		%y_r, %l7		!Store the minimum into %l3
		
loop:
		set 	fmt, %o0
		mov		%x_r, %o1		!Storing x into %o1
		mov		%x_r, %o1		!Storing x into %o1
		mov		%y_r, %o2		!Storing y into %o2
		
		call	printf			!Prints content stored in %o1, %o2, %o3
		mov		%l7, %o3		!Storing the minimum into %o3
		
		inc		%x_r			!Incrementing x
		cmp		%x_r, 11		!Comparing x to 11
		ble,a	start 			!Branch if x <= 11
		mov		%x_r, %o0		!Copying the initial value of x into register %o0
		
		mov		%l3, %l0		!Copying the minimum into %l0

end:
		mov		1, %g1
		ta 0
