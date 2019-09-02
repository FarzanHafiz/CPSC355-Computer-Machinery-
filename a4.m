!NameL Shah Farzan Al-Hafiz
!ID: 10162590
!CPSC 355-T06


include(macro_defs.m)					
define(FALSE,0)						
define(TRUE,1)						

begin_struct(point)			
field(x,4)				
field(y,4)				
end_struct(point)			 

begin_struct(dimension)			
field(width,4)				
field(height,4)				
end_struct(dimension)			

begin_struct(box)					
field(origin,align_of_point,size_of_point)		 
field(size,align_of_dimension,size_of_dimension)	
field(area,4)						
end_struct(box)						


fmt1:	.asciz "Initial box values:\n"													!print statement
		.align 4

fmt2:	.asciz "Box first origin = (%d, %d)  width = %d  height = %d  area = %d\n"		!print statement
		.align 4

fmt3:	.asciz "Box second origin = (%d, %d)  width = %d  height = %d  area = %d\n\n"		!print statement
		.align 4

fmt4:	.asciz "\nChanged box values:\n"												!print statement
		.align 4


local_var				
var(first,align_of_box,size_of_box)						
var(second,align_of_box,size_of_box)					
                                                                	
		.global main
main:	save	%sp, (-92 + last_sym) & -8, %sp										
		add		%fp, first, %o0							!get first address
		st		%o0, [%sp + 64]							!store in %o0
		call	newBox									!call newBox function
		nop												!delay slot
		.word	size_of_box								!embeded word
		
		clr		%o0										!clearing %o0 
		add		%fp, second, %o0						!get second address
		st		%o0, [%sp+64]							!store in %o0
		call	newBox									!pass it to newBox and invoke it
		nop												!delay slot
		.word	size_of_box								!embeded word
		
b1:		set		fmt1, %o0								!set print statement into %o0
		call	printf									!call printf
		nop												!delay slot

		add		%fp, first, %o1							!get the first address
		set		fmt2, %o0								!set print statement into %o0
		call	printBox								!pass it to printBox and invoke it
		nop												!delay slot


		add		%fp, second, %o0						!get seconf address
		set		fmt3,	%o0								!set print statement into %o0
		call	printBox								!call printBox
		nop												!delay slot
		
		clr		%o0										!clear %o0
		add		%fp, first,	 %o0						!get first address
		add		%fp, second, %o1						!get second address
		call	equal									!call equal
		nop												!delay slot
		
		cmp		%o0, 1									!compare with 1
		bne		endIt									!branch on not equals
		nop

		add		%fp, first, %o0							!get first address
		mov		-5, %o1									!move -5 into %o1
		mov		7,	%o2									!move 7 into %o2
		call	move									!call move
		nop												!delay slot

		add		%fp, second, %o0						!get second address
		mov		3, %o1									!move 3 into %o1
		call	expand									!call expand
		nop												!delay slot

endIt:
		set		fmt4, %o0								!set print statement to %o0
		call	printf									!call printf
		nop												!delay slot

		add		%fp, first, %o1							!get first address
		set		fmt2, %o0								!set print statement to %o0
		call	printBox								!call printf
		nop												!delay slot

		add		%fp, second, %o1						!get second address
		set		fmt3, %o0								!set print statement to %o0
		call	printBox								!call printf
		nop												!delay slot


exit:	mov		1, %g1						
		ta		0					
		
		

newBox:	
		local_var
		var(b, align_of_box,size_of_box)	
		save	%sp, (-92 + last_sym) & -8,	%sp	
		ld		[%i7+8], %l1	
		cmp		%l1, size_of_box									!when equal keep
		bne		return												!branch on not equals
		nop															!delay slot
		
		ld		[%fp+64], %o0										!get address of first
		st		%g0, [%fp + b + box_origin + point_x]				!set feild x in b
		ld		[%fp + b + box_origin + point_x],	%o1	
		st		%o1, [%o0 + box_origin + point_x]					!set in main
	
		st		%g0, [%fp + b + box_origin + point_y]				!set feild y in b
		ld		[%fp + b + box_origin + point_y],	%o1	
		st		%o1, [%o0 + box_origin + point_y]					!set in main

		mov		1, %l0
		st		%l0, [%fp + b + box_size + dimension_width]			!set feild width in b
		ld		[%fp + b + box_size + dimension_width],	%o1	
		st		%o1, [%o0 + box_size + dimension_width]				!set in main
	
		mov		1, %l1
		st		%l1, [%fp + b + box_size + dimension_height]		!set feild height in b
		ld		[%fp + b + box_size + dimension_height], %o2
		st		%o2, [%o0 + box_size + dimension_height]			!set in main
	
		smul 	%o1, %o2, %o3
		st		%o3, [%fp + b + box_area]							!store value in stack
		ld		[%fp + b + box_area], %o1							!load in %o1
		st		%o1, [%o0 + box_area]								!set in main


return:
		jmpl	%i7 + 12, %g0										!branch here when condition isn't met
		restore
		
move:	save	%sp, (-92+last_sym)&-8,	%sp							!function move
		ld		[%i0+box_origin+point_x],	%o0						!get the address of x
		add		%i1, %o0, %o0										!add it to the passed value deltaX
		st		%o0, [%i0+box_origin+point_x]						!store the sum in stack
		ld		[%i0+box_origin+point_y], %o0						!get the address of y
		add		%i2, %o0, %o0										!add it to the passed value deltaY
		st		%o0, [%i0+box_origin+point_y]						!store it in the stack
		ret															!return to main
		restore

expand:	save	%sp, (-92 )&-8,	%sp							!function expand
		ld		[%i0 + box_size + dimension_width],	%o0					!get the address of width
		smul	%i1, %o0, %o1											!multiply it with the passed value
		st		%o1, [%i0 + box_size + dimension_width]					!store the value in the stack

		ld		[%i0 + box_size + dimension_height], %o0				!get the address of height
		smul	%i1, %o0, %o2											!multiply it with the passed value
		st		%o2, [%i0 + box_size + dimension_height]				!store it to the stack	
	
		ld		[%i0 + box_area], %o0								!get the address of area
		smul	%o1, %o2, %o3										!area = width*height
		st		%o3, [%i0 + box_area]								!set area in main
		
		ret															!returnning to main
		restore
		
printBox:	
		save	%sp, (-92 + last_sym) & -8, %sp					!printBox function
		mov		%i0, %o0										!put passed value in o0
		ld		[%i1 + box_origin + point_x], %o1				!get the address of x
		ld		[%i1 + box_origin + point_y], %o2				!get the address of y
		ld		[%i1 + box_size + dimension_width], %o3			!get the address of x
		ld		[%i1 + box_size + dimension_height], %o4		!get the address of y
		ld		[%i1 + box_area], %o5							!get the address of x
		call	printf											!pass them to printf and invoke it
		nop														!delay slot
		ret														!returnning to main
		restore
		
equal:	local_var
		save	%sp, (-92+last_sym)&-8, %sp						!function equal
		
		clr %l3
		ld		[%i0 + box_origin + point_x], %l0				!get the address of x of b1
		ld		[%i1 + box_origin + point_x], %l1				!get the address of x of b2
		cmp		%l0, %l1										!when they are equal continuing
		bne 	skip											!branch on not equals
		nop
						
		ld		[%i0 + box_origin + point_y], %l0				!get the address of y of b1
		ld		[%i1 + box_origin + point_y], %l1				!get the address of y of b2
		clr		%13
		cmp		%l0, %l1										!when they are equal continuing
		bne 	skip											!branch on not equals
		nop
				
		ld		[%i0 + box_size + dimension_width], %l0			!get the address of width of b1
		ld		[%i1 + box_size + dimension_width], %l1			!get the address of width of b2
		cmp		%l0, %l1										!when equal keep
		bne 	skip											!branch on not equals
		nop
								
		ld		[%i0 + box_size + dimension_height], %l0  		!get address of height of b1
		ld		[%i1 + box_size + dimension_height], %l1		!get address of height of b2
		cmp		%l0, %l1										!branch on not equals
		bne 	skip
		nop
		mov		TRUE,	%l3										!when all conditions true
		
skip:	mov		%l3, %i0										!branch here if one of the the condtions are wrong
		ret
		restore
		
