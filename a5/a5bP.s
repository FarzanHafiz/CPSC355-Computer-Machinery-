! Define local variables
	
	
	
! String formatters
monthErrorFmt:
	.asciz 		"The month has to be between 1-12 \n"
	.align 		4
dayErrorFmt:
	.asciz 		"The day has to be between 1-31 \n"
	.align 		4
yearErrorFmt:
	.asciz 		"Year should be 4 digits \n"
	.align 		4
	
	.align 		4
	.global		month
! Array for month
month:	.word	jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec

! Month formatters
jan:	
	.asciz		"January"
	.align 		4
feb:
	.asciz		"February"
	.align 		4	
mar:
	.asciz		"March"
	.align		4
apr:
	.asciz		"April"
	.align 		4
may:
	.asciz		"May"
	.align 		4
jun:
	.asciz		"June"
	.align 		4
jul:
	.asciz		"July"
	.align		4
aug:
	.asciz		"August"
	.align 		4
sep:
	.asciz		"September"
	.align		4
oct:
	.asciz		"October"
	.align 		4
nov:
	.asciz		"November"
	.align 		4
dec:
	.asciz		"December"
	.align 		4

	
! Define output labels
date:
	.asciz		"%s %sth, %s\n"
	.align		 4
error:
	.asciz		"usage mm dd yyyy\n"
	.align		 4
.global main
main:
	! Allocate memory for window
	save	%sp, -96, %sp
	! Test that there are three arguments
	cmp	%i0, 4					! Ensure that there are 4 arguments
	bne	printerror				! Error Message if it does have 4 
	nop
	ld	[%i1+4], %o0 			! Load month into %o0
	call	atoi				! Convert month to integer
	nop
	mov	%o0, %l0
	cmp 	%l0, 12				! if month is greater than 12 then show error message
	bg		monthError
	nop
	cmp 	%l0, 1				! if month is less than 1 then show error message
	bl		monthError
	nop

	dec		%l0					! Convert month to -1 of string array
	sll		%l0, 2, %l0				! Shift month -1 by 2
	
	ld		[%i1+8], %l1			! Get day
	mov		%l1, %o0				! mov %l1 into o0
	call	atoi				! Convert day to integer
	nop
	cmp		%o0, 1				! Compare %o0 to 1
	bl		dayError			! if day is less than 1 then show error message
	nop
	cmp		%o0, 31				! if day is greater than 31 then show error message
	bg		dayError
	nop
	ld		[%i1+12], %l2			! Get year
	mov		%l2, %o0				! move %l2 into o0
	call	atoi				! Convert year to integer	
	nop
	cmp		%o0, 1000			! if year is not 4 digits then show error message
	bl		yearError
	nop

	! Printing Statements
	set		month, %o1
	add		%o1, %l0, %o1			! Calculate -1 of proper month
	set		date, %o0
	ld		[%o1], %o1		! Load pointer to month string
	mov		%l1, %o2
	mov		%l2, %o3
	call	printf
	nop

	!Exits program
	ba 		exit
	nop

	
! handles Error
monthError:
	set 	monthErrorFmt, %o0
	call	printf
	nop
	ba 		exit
	nop
dayError:
	set 	dayErrorFmt, %o0
	call	printf
	nop
	ba 		exit
	nop
yearError:
	set 	yearErrorFmt, %o0
	call	printf
	nop
	ba 		exit
	nop
printerror:

	! Prints usage error
	set	error, %o0
	call	printf
	nop

exit:
	mov		1, %g1
	ta		0
	
