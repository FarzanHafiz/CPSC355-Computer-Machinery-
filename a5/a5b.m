!Name: Shah Farzan Al-Hafiz
!ID: 10162590
!CPSC 355-T06 

include(macro_defs.m)                                           !include marco definitions from d2l file

date:			.asciz  "%s %s%s, %s\n"                         !print output
                .align  4                                       
invalidArg:     .asciz  "Usage: mm dd yyyy\n"                   !print message for date format
                .align  4                                       
invalidM:       .asciz  "Invalid Month.\n"   				    !error message
                .align  4                                       
invalidD:       .asciz  "Invalid Day.\n"      					!error message
                .align  4                                       
invalidY:       .asciz  "Invalid Year.\n"      					!error message.
                .align  4                                       


.align      4                                                   
.section    ".data"                                             !access data section
            
	month:  .word   JAN_m, FEB_m, MAR_m, APR_m, MAY_m, JUN_m, JUL_m, AUG_m, SEP_m, OCT_m, NOV_m, DEC_m
	!name of months for output
	JAN_m:   .asciz  "January"                          		
    FEB_m:   .asciz  "February"
    MAR_m:   .asciz  "March"
    APR_m:   .asciz  "April"
    MAY_m:   .asciz  "May"
    JUN_m:   .asciz  "June"
    JUL_m:   .asciz  "July"
    AUG_m:   .asciz  "August"
    SEP_m:   .asciz  "September"
    OCT_m:   .asciz  "October"
    NOV_m:   .asciz  "November"
    DEC_m:   .asciz  "December"

.align      4                                                   
.section    ".data"                                             !access data section
    daySuffix:   .word   st_m, nd_m, rd_m, th_m
	!day suffixes
    st_m:   .asciz  "st"                                
    nd_m:   .asciz  "nd"
    rd_m:   .asciz  "rd"
    th_m:   .asciz  "th"

.align      4                                                  
.section    ".data"                                             !access data section
    dayBounds:   .word   JANd_m, FEBd_m, MARd_m, APRd_m, MAYd_m, JUNd_m, JULd_m, AUGd_m, SEPd_m, OCTd_m, NOVd_m, DECd_m
	!max day number for months
    JANd_m:  .asciz  "31"                                
    FEBd_m:  .asciz  "28"
    MARd_m:  .asciz  "31"
    APRd_m:  .asciz  "30"
    MAYd_m:  .asciz  "31"
    JUNd_m:  .asciz  "30"
    JULd_m:  .asciz  "31"
    AUGd_m:  .asciz  "31"
    SEPd_m:  .asciz  "30"
    OCTd_m:  .asciz  "31"
    NOVd_m:  .asciz  "30"
    DECd_m:  .asciz  "31"

.section    ".text"                                             !access text section
begin_fn(main)                                                  !begin main function

test:           
	cmp		%i0, 4                      			   		    !no. of elements == 4?
    be      validArgs                            			    !branch on equal to validArgs
    nop
    set     invalidArg, %o0                    			        !set print statement
    call    printf                                  			!print error message
    nop
    call    exit                                  			    !exit
    nop

validArgs: 
	set     month, %l0                    	  				    !month array in %l0
    set     daySuffix, %l1                    				    !suffix array inn %l1
    set     dayBounds, %l2                      			    !max days array in !l2

monthCheck:   
	ld      [%i1 + 4], %o0                     					!1st arg
    call    atoi                                  			    !atoi function
    nop
    mov     %o0, %l3                			      	        !copy %o0 to %l3
    sub     %l3, 1, %l3            			   				    !decrement by 1
    smul    %l3, 4, %l3           			   				    !multiply by 4
    cmp     %o0, 0                      			 		    !check whether lower bound is zero
    ble     invalidArgsM                               		    !branch on lower or equal to invalidArgsM
    nop
   
    cmp     %o0, 12                      		  			    !check if month is more than 12
    bg      invalidArgsM                                		!branch on greater than to invalidArgM
    nop

dayCheck:    
	ld      [%i1 + 8], %o0                     					!2nd arg
    call    atoi                                   			    !change to integer by calling atoi function
    nop
    mov     %o0, %l4                    				        !move the integer to %l4
    cmp     %l4, 0                    					        !check if its in range
    ble     invalidArgsD                               		    !branch on lower or equal to invalidArgsD
    nop

    ld      [%l2 + %l3], %o0                     				!load max into %o0
    call    atoi                                   			    !change to integer
    nop
    cmp     %l4, %o0                     						!check if day is in range
                                                                
    bg      invalidArgsD                                		!branch on greater to invalidArgsD
    nop
                
yearCheck: 
    ld      [%i1 + 12], %o0                     				!3rd args
    call    atoi                                   			    !change to integer
	nop
                
    cmp     %o0, 0 						                        !check lower bound
    bl      invalidArgsY                                        !branch on lower
    nop         
    set     9999, %l5                    				        !set 9999 to %l5
                
    cmp     %o0, %l5         						            !check range
    bg      invalidArgsY                            		    !branch on greater
    nop
                
    ba      testSuff                              				!branch always to testSuff
    nop
                
invalidArgsM: 
    set     invalidM, %o0                    			    	!set print statement
    call    printf                                		        !print error message
    nop
                
    call    exit                                  			    !exit
    nop

invalidArgsD:
    set     invalidD, %o0                     					!set print statement
    call    printf                               			    !print error message
    nop
    call    exit                                   				!exit
    nop

invalidArgsY: 
    set     invalidY, %o0               			      	    !set print statement
    call    printf                                   		    !print error message
    nop
    call    exit                                    		    !exit
    nop 

testSuff:   
    cmp     %l4, 3                     			   			    !check day range
    ble     setSuffA                             			    !branch on lwer than or equal
    nop
    cmp     %l4, 31                      					    !check range
    be      setSuffST                            			    !branch on equal
    nop
                
    cmp     %l4, 21                     			   		    !check range
    bge     setSuffB                             			    !branch on greater or equal
    nop
    ld      [%l1 + 12], %o3                     				!load "th"
    ba      printArgs                              			    !branch always
    nop

setSuffA:    
	cmp     %l4, 3                       						!check range
    be      setSuffRD                             				!branch on equal
    nop
                
    cmp     %l4, 2                      					    !check range
    be      setSuffND                           			    !branch on equal
    nop
               
    ld      [%l1 + 0], %o3                   			        !load "st"
    ba      printArgs                              			    !branch always
    nop
                
setSuffB:   
    cmp     %l4, 21                      						!check day numbers and set apprpriate suffixes
    be      setSuffST                           
    nop             
    cmp     %l4, 22                      
    be      setSuffND                            
    nop
               
    cmp     %l4, 23                      
    be      setSuffRD                             
    nop              
    ld      [%l1 + 12], %o3                                
    ba      printArgs                               
    nop
                
setSuffST:   
	ld      [%l1 + 0], %o3                     					!load "st" suffix 
    ba      printArgs                               			!branch always
    nop

setSuffND: 
   ld      [%l1 + 4], %o3                     					!load "nd" suffix               
   ba      printArgs                              				!branch always
   nop
                
setSuffRD:  
  ld      [%l1 + 8], %o3             		          			!load "rd" suffix
                
printArgs:   
   ld      [%l0 + %l3], %o1               		                
   ld      [%i1 + 8], %o2                                      
   ld      [%i1 + 12], %o4                   				    
                                                                
                
   set     date, %o0                     						
   call    printf                                			    
   nop
end_fn(main)
