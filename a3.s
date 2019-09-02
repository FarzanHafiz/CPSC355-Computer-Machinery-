!Name: Shah Farzan Al-Hafiz
!ID: 10162590
!CPSC 355-T06





							!taken from d2l
v_s = -160						!macro for array
i_s = -164							!macro for i
j_s = -168							!macro for j
temp_s = -172						!macro for temp size


fmt1:	
	.asciz	"v[%d]:%d\n"			!printing initial array
	.align	4

fmt2:	
	.asciz"\nArray after sorting:\n"	!printing literal text 	
	.align	4

fmt3:
	.asciz"v[%d]:%d\n"				!printing sorted array
	.align	4
	
	
	
	.global main
main:	
	save	%sp, (-92 + -172) & -8, %sp									
	clr		%l2					 		!store zero in %l2
			
test:	
	cmp		%l2,		40				!implementing i<40
	bge,a	postloop					!branch on greater than or equal to postloop
	mov		39,		%l2					!store 39 in %l2
	
loop:
	call	rand						!generate a random number
	nop
	and		%o0, 0xff, %o2				!logical & between random number and oxff
	mov		%l2, %l3					!move i to %l3
	sll		%l3, 2, %o1	!o1=i*4
	add		%fp, %o1, %o1				!%o1 = %fp + i*4
	st		%o2, [%o1+v_s]	 			!store into stack
	set		fmt1, %o0					!set format string to %o0
	call	printf						!call print function
	mov		%l3, %o1					!move i to %o1 for printing
										!the value of randoms are saved in %o2 ready to print
	ld		[%o1+v_s], %o1				!o1 = [%fp +v_s + i*4]

	ba		test						!branch always to test
	inc		%l2							!incrementing i, i++


postloop:  
	clr		%l2							!clear l2 for reuse
	mov		1, %l2						!store 1 into %l2 which is i


testOuterFor:
	sll		%l2, 2,	%o2					! left twice to get i*4
	add		%fp, %o2, %o2				!%o2 = %fp + i*4
	ld		[%o2+v_s], %l5				!load the values and store into %l5
	cmp		%l2, 40						!checking i<40
	bge		postOuterFor				!branch on greater or equal
	mov		%l2, %l4					!implementing j=i	


testInnerFor:		
	cmp		%l4,	0					!checking if j>0	
	ble		postInnerFor				!branch on less or equal
	nop
	sub		%l4, 1, %l6					!subtract to get j-1 and store into %l6
	sll		%l6, 2, %o3					!o3 = (j-1) * 4
	add		%fp, %o3, %o3				!o3= fp + (j-1) * 4 
	ld		[v_s+%o3], %l6				!store v[j-1] into %l6

	cmp		%l5, %l6					!compare %l5 and %l6
	bge		postInnerFor 				!branch on greater or equal
		
	sll		%l4, 2, %o4					!o4 = (j-1) * 4
	add		%fp, %o4, %o4				!o4 = fp + (j-1) * 4
	st		%l6, [v_s+%o4]				!load the value of v[j-1] to v[j], 

	ba		testInnerFor				!branch always to testInnerFor
	sub		%l4,	1,	%l4				!decrementing j


postInnerFor:
	sll		%l4, 2,	%o5					!o5 = j * 4
	add		%fp, %o5, %o5				!o5 = fp + j*4
	st		%l5, [v_s+%o5]				!store temp in v[j]

	ba		testOuterFor				!branch always to testOuterFor
	inc		%l2							!incrementing i


postOuterFor:
	set		fmt2, %o0					!set format string to %o0
	call	printf			 			!call print function
	clr		%l2							!clear %l2 for reuse
	mov		0, %l2						!store zero into %l2(i=0)


for1:									
	cmp		%l2, 40						!check if i<40
	bge		postFor1					!branch on greater or equal
	nop				
	sll		%l2, 2,	%o5					!o5 = i * 4
	add		%fp, %o5, %o5				!o5 = fp +v i * 4
	ld		[v_s+%o5], %o5				!load the valuse from stack for printing
	set		fmt3, %o0					!set format string to %o0
	mov		%l2, %o1					!store %l2(i) in %o1
	call	printf						!call print function
	mov		%o5, %o2					!store %o5(v[i]) into %o2

	ba		for1						!branch always to for1
	inc		%l2							!incrementing i

postFor1:
	mov		1, %g1
	ta		0
		
