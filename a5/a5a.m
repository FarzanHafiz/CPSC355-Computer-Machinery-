!Name: Shah Farzan Al-Hafiz
!ID: 10162590
!CPSC 355-T06 


include(macro_defs.m)							!include macro definition from given file

.global stack									!declare global variable stack
.global top										!declare global variable top
.section	".text"								!access text section



define(STACKSIZE, 5)							!define the constants
define(TRUE, 1)
define(FALSE, 0)


stkOverflow:	.asciz	"\nStack Overflow: Cannot add any more values to Stack.\n"		!error message
				.align	4
stkUnderflow:	.asciz	"\nStack Underflow: Stack is empty, cannot pop.\n"				!error message	
				.align	4
stkEmpty:		.asciz	"\nStack is empty.\n"											!error message
				.align	4
stkElements:	.asciz	"\nElements in Stack:\n"										!literal print of the line
				.align	4
printElements:	.asciz	" %d"															!print Stack elements				
				.align	4
breakLine:		.asciz	"\n"															!print in a new line
				.align	4
stkTop:			.asciz	"<---- Top of Stack"											!Visually indicating top of stack





begin_fn(push)															!begin push function
	call	stackFull													!test if stack is full
	nop
	
	cmp		%o0, TRUE													!is stkFull true?
	be		errorFull													!branch on equal to errorFull
	nop
	
	sethi	%hi(top), %o0												!store the top address in %o0
	or		%o0, %lo(top), %o0											!add the lower bits
	ld		[%o0], %l0													!store top into %l0
	
	inc		%l0															!increment
	st		%l0, [%o0]													!update top value
	sll		%l0, 2, %l0													!mltiply by 4 to offset
	
	sethi	%hi(stack), %o1												!get stack memory
	or		%o1, %lo(stack), %o1										!add the lower bits
	st		%i0, [%o1 + %l0]											!store in stack
	
	ba		endPush														!branch always to endPush
	nop
	
errorFull:
	set		stkOverflow, %o0											!set print statement
	call	printf														!call print function
	nop
	
endPush:
	clr		%o0															!clear the used registers
	clr		%o1
	clr		%l0
end_fn(push)	
	
begin_fn(pop)															!begin pop function
	call	stackEmpty                                         	        !test if stack is empty
    nop

    cmp     %o0, TRUE 			                                       	!is stkEmpty true?
    be      errorEmpty                                             		!branch on equal to errorEmpty
    nop                                                             

    sethi   %hi(top), %o0 	            	                            !store top address into %o0
    or      %o0, %lo(top), %o0											!add the lower bits
    ld      [%o0], %l0		             	                            !load top into %l0
    sll     %l0, 2, %l1					      	                        !multiply by 4 to offset

    sethi   %hi(stack), %o1                       	                    !load top of stack
    or      %o1, %lo(stack), %o1										!add the lower bits
    ld      [%o1 + %l1], %i0                                            !load into return register

    dec     %l0                                           	            !decrement
    st      %l0, [%o0]                                 	        		!store top

    ba      endPop                                                	    !branch always to endPop
    nop

errorEmpty: 
	set     stkUnderflow, %o0                                     		!set print statement
    call    printf                                              		!call print function
    nop
    
endPop:
	clr		%o0															!clear the used registers
	clr		%o1
	clr		%l0
	clr		%o1
end_fn(pop)	
	
begin_fn(stackFull)														!begin stackFull function
	sethi   %hi(top), %o0                                         		!store top into %o0
    or      %o0, %lo(top), %o0											!add the lower bits

    ld      [%o0], %l0        		                                    !load top into %l0
    mov     STACKSIZE, %l6             		                            !move constant STACKSIZE into %l5
    sub     %l6, 1, %l1                     					        !decrease STACKSIZE by 1

    cmp     %l0, %l1                                         			!compare top with STACKSIZE
    be      ifFull                                                  	!branch on equal to isFull
    nop                                                             	

    mov     FALSE, %i0                                         			!return the value

    ba      endStackFull                                                 !branch always to endStacKFull
            nop

ifFull:     
	mov     TRUE, %i0                                        			!return the value
	
endStackFull:															
	clr		%o0															!clear the used registers
	clr		%l0
	clr		%l1
	clr		%l6
end_fn(stackFull)	

begin_fn(stackEmpty)													!begin stackEmpty function
	sethi   %hi(top), %o0                                        	    !store top into %o0
    or      %o0, %lo(top), %o0											!add the lower bits

    ld      [%o0], %l0                                                  !load top into %l0
    mov     -1, %l1                                        			    !store -1 into %l1

    cmp     %l0, %l1                                         			!compare top with -1
    be      ifEmpty                                             	    !branch equal to isEmpty
    nop

    mov     FALSE, %i0                                       		    !return the value

    ba      endStackEmpty                                             	!branch always to endStackEmpty
	nop

ifEmpty:
    mov     TRUE, %i0                                        		    !return the value
    
endStackEmpty:
	clr		%o0															!clear the used registers
	clr		%l0
	clr		%l1
end_fn(stackEmpty)	
	
begin_fn(display)														!begin display function
	 call    stackEmpty													!call stackEmpty function
     nop

     cmp     %o0, TRUE                                          	    !test whether stack is empty
     be      isEmpty													!branch on equal to isEmpty
     nop

     set     stkElements, %o0                                           !set print statement
     call    printf														!call print function
     nop

     sethi   %hi(top), %l0                                              !load top into %l0
     or      %l0, %lo(top), %l0											!add the lower bits
	 ld      [%l0], %l0                                                 !load top into %l0

     sethi   %hi(stack), %l1          	                                !store address into %l1
     or      %l1, %lo(stack), %l1										!add the lower bits

     mov     %l0, %l3                                                   !save top into %l3
     
loop:
	cmp     %l0, 0                                    			        !compare %l0 with 0
    bl      endDisplay                                             	    !branch on lower than to endDisplay
    nop

    sll     %l0, 2, %l2                           					    !multiply by 4 to offset
    ld      [%l1 + %l2], %o1                                            !load the current element for printing

    set     printElements, %o0                                      	!set print statement
    call    printf                                             	        !call print function
    nop

    cmp     %l0, %l3                                     			    !test if we are at the top
    be      printTop                                                 	!branch on equal to printTop
    nop

    dec     %l0                                                    	    !decrement by 1
    set     breakLine, %o0                                              !set print statement for new line
    call    printf														!call print function
    nop

    ba      loop                                                        !branch always to loop
    nop
    
printTop:   
	set     stkTop, %o0                                        	   	    !set print statement
    call    printf                                                      !call print function and print " <-- top of stack"
    nop

    dec     %l0                                                         !decrement by 1.
    set     breakLine, %o0                                              !set print statement
    call    printf														!call print function
    nop

    ba      loop                                                        !branch always to loop
    nop

isEmpty:   
	set     stkEmpty, %o0                                       	    !set print statement
    call    printf                                                      !call print function and display message
    nop    

endDisplay:   
	clr     %o0                                                         !clear the used registers
    clr     %o1
    clr     %l0
    clr     %l1
    clr     %l2
    clr     %l3
end_fn(display)  
