/* Program that counts consecutive 1's */

          .text                   // executable code follows
          .global _start                  
_start:                             
          MOV     R4, #TEST_NUM   // load the data word address into R4
		  MOV	R5, #0	// initialze R5 to 0, which will store largest number of 1 count
		  
WORD_LOOP:	LDR	R1, [R4], #4 // get the next word
			CMP	R1, #0	// check if R1 (current word) is 0
		  	BEQ		END		// if R1 is 0, then branch to end
		  		  
		  BL	ONES
		  CMP 	R5, R0	// check if current word has more zeroes than what current max 
		  MOVLT	R5, R0 // if it has more zeroes then replace count
		  B		WORD_LOOP

ONES:	MOV     R0, #0          // R0 will hold the result
LOOP:	CMP     R1, #0          // loop until the data contains no more 1's
		BEQ		END_ONES             
		LSR     R2, R1, #1      // perform SHIFT, followed by AND
		AND     R1, R1, R2      
		ADD     R0, #1          // count the string length so far
		B       LOOP            

END_ONES:	BX	LR

END:      B       END             

TEST_NUM: .word   0x103fe00f
			.word	0x1022fb03
			.word	0x7048453e
			.word	0xed315d13
			.word	0x5e17aa47
			.word 	0x186b4aa8
			.word	0xc3c859a4
			.word	0x2ce8aa3c
			.word	0xe0f63f64
			.word	0x1feb739d
			.word	0x75e8a6ab
			.word	0


          .end                            
