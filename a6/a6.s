!Name: Shah Farzan Al-Hafiz
!ID: 10162590
!CPSC 355-T06


 													!importing macro defs


															!defining hte constants
															










!local variables 
 buf = -8
 ans = -16

.section ".data" 														!accessing data section
	.align 8 															!alignment

																		!double values
zero_m: .double 0r0.0 													
one_m: 	.double 0r1.0 
x_m: 	.double 0r0.0 													
e_m: 	.double 0r1.0e-10																								
ans_m: 	.double 0r0.0 													
	
	
	
	.align 4
fmt1:
	.asciz "x: %.10f 	  |e^x: %.10f 	  |e^-x: %.10f\n"	 				!String with placeholder for printing


fmtError1:
	.asciz "PYou must specify atleast one valid filename" 				!Error messge
	.align 4

	.global main									!global access
main:
	save %sp, (-92 + -16) & -8, %sp 			
	
	cmp 	%i0, 2 									!checking for file
	be 		valid 									!If yes then branch to valid
	nop
	set 	fmtError1, %o0 							!set format string
	call 	printf 									!Calling printf
	nop
	mov 	1, %g1 									!Trap dispatch
	ta 		0 										!Trap to system

valid:
	ld 		[%i1 + 4], %l0 							!filename to l0
	mov 	%l0, %o0 								!1st arg
	clr 	%o1 									!2nd arg 
	clr 	%o2 									!3rd arg 
	mov 	5, %g1 								!Open service request
	ta 		0 										!system trap
	bcc 	open_ok									
	nop
	set 	fmtError1, %o0 							!Set format string
	call 	printf 									!Calling printf
	nop

	mov 	1, %g1
	ta 		0										!system trap

open_ok:
	mov 	%o0, %l1 								!file descriptor to l1


top:
	mov 	%l1, %o0 								!ast arg 
	add 	%fp, buf, %o1 							!2nd arg 
	mov 	8, %o2 									!3rd arg 
	mov 	3, %g1 								!Read service request
	ta 		0 										!system trap

	cmp 	%o0, 8 									!was 8 bytes read?
	bne 	exit 									!If not, exit the program
	nop 
	ldd 	[%fp + buf], %o0 						
	call 	calculate 								!call calculate function
	nop
	
	std 	%f0, [%fp + ans] 						
	ldd 	[%fp + buf], %o0 						
	sethi 	%hi(1<<31), %o2 						!setting MSB to 1
	btog 	%o2, %o0 								!negating
	call 	calculate 								!call calculate function
	nop
	ld 		[%fp + buf], %o1 						!X as 2nd arg high part
	ld 		[%fp + buf + 4], %o2 					!X as 2nd arg low part
	ld 		[%fp + ans], %o3 						!3rd
	ld 		[%fp + ans + 4], %o4 					!4th
	st 		%f0, [%fp + ans] 						
	ld 		[%fp + ans], %o5 						
	
	st 		%f1, [%sp + 92] 						
	
	set 	fmt1, %o0 								!Set format string
	call 	printf 									!call printf
	nop

	ba 		top 									
	nop
exit:
	mov 	1, %g1									
	ta 		0 										!system trap


calculate:
	save    %sp, (-92 + -8) & -8, %sp 				! register window
	std 	%i0, [%fp -8] 							!put X on stack
	ldd 	[%fp -8], %f0 							!Load X in %f0
	set 	e_m, %o0 								!pointer
	ldd 	[%o0], %f2							
	
	set 	one_m, %o0 								
	ldd 	[%o0], %f6 							
	faddd 	%f6, %f0, %f6 					
	mov 	2, %o0 									

top_calculate:									
	call 	exponentiate 								
	nop

	call 	factorial 													!branch to factorial
	nop
	fdivd 	%f8, %f10, %f12 				
	faddd 	%f6, %f12, %f6 				
	inc 	%o0 								
	
	fabss 	%f12, %f12
	fcmpd 	%f12, %f2 						
	nop
	fbg 	top_calculate 								
	nop

end_calculate:
	fmovs 	%f6, %f0								
	fmovs 	%f7, %f1 								 
	ret 											!Return
	restore 										!Restore
	


	.global exponentiate
exponentiate:
	save 	%sp, -96, %sp 							
	mov 	%i0, %l0 								
	fmovs 	%f0, %f8 							
	fmovs 	%f1, %f9 								

top_exp:
	fmuld 	%f0, %f8, %f8 					!num = x*x

	dec 	%l0 									!decrement
	cmp 	%l0, 1 									!compare with 1
	bg		top_exp 								!loop if yes
	nop
	
end_exp:
	ret 											!Return
	restore 										!Restore
	

	.global factorial
factorial:
	save    %sp, (-92 + -4) & -8, %sp 				!Slide register window
	st      %i0, [%fp - 4] 							!Store arg n on the stack
	ld      [%fp - 4], %f10 						
	fitod   %f10, %f10  						!Convert int to double

	fmovs   %f10, %f12  							
	fmovs   %f11, %f13  							
	set     one_m, %o0  							
	ldd     [%o0], %f14  							
	ba      loop_check 								!calculating factorial values in loop
	nop

factloop:
	fsubd   %f12, %f14, %f12  						
	fmuld   %f10, %f12, %f10 					

loop_check:
	fcmpd   %f12, %f14 								!Compare with 1.0
	nop
	fbg     factloop 								
	nop
	ret 											!Return 
	restore 										!Restore 
