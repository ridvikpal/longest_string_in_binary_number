/* Program that counts consecutive 1's */

				.text                   // executable code follows
				.global _start                  
_start:                             
				MOV		R4, #TEST_NUM // load the data word address into R4
				MOV		R5, #0 // initialze R5 to 0, which will store largest number of 1 count
				MOV		R6, #0 // initialize R6 to 0, which will store largest number of 0 count
				MOV		R7, #0 // initialize R7 to 0, which will store largest number of alternating count
		  
WORD_LOOP:		LDR		R1, [R4] // get the next word
				CMP		R1, #0	// check if R1 (current word) is 0
		  		BEQ		END		// if R1 is 0, then branch to end
		  		  
				// get the largest consecutive string of ones in the 32 bit number
				// algorithm:
				// 1. shift number to the left.
				// 2. and original number with the shifted one, and replace original number with result.
				// 3. increment counter and repeat loop until number is equal to 0.
				BL		ONES
				CMP		R5, R0	// check if current word has more zeroes than what current max 
				MOVLT	R5, R0 // if it has more zeroes then replace count
			
				// get the largest consecutive string of zeroes in the 32 bit number
				// algorithm:
				// 1. rotate shift number to the left.
				// 2. or original number with the shifted one, and replace original number with result.
				// 3. increment counter and repeat loop until number is equal to 0xffffffff
				// 4. make sure to check for corner case as well
				LDR		R1, [R4]
				BL		ZEROES
				CMP		R6, R0
				MOVLT	R6, R0
			
				// get the largest consecutive alternating string of ones and zeroes in the 32 bit number
				// algorithm:
				// 1. XOR number with alternating string of 0 and 1 (0xaaaaaaaa)
				// 2. find largest number of consecutive ones (using previous algorithm).
				// 3. find largest number of consecutive zeroes (using previous algorithm), checking for corner case as well
				// compare the two results are store the largest one
			
				LDR		R1, [R4]
				MOV		R3, #EOR_CONSTANT
				LDR		R3, [R3]
				EOR		R1, R1, R3 // instead of finding alternating string, find the largest number of zeroes by doing XOR with alternating string first
				BL		ONES
				CMP		R7, R0
				MOVLT	R7, R0
			
				LDR		R1, [R4]
				MOV		R3, #EOR_CONSTANT
				LDR		R3, [R3]
				EOR		R1, R1, R3 // instead of finding alternating string, find the largest number of zeroes by doing XOR with alternating string first
				BL		ZEROES
				CMP		R7, R0 // if result is greater when checking ones, then replace r7 with that result
				MOVLT	R7, R0
			
				// increment to the next word
				ADD		R4, #4
				B		WORD_LOOP

ONES:			MOV     R0, #0 // R0 will hold the result
LOOP_ONES:		CMP     R1, #0 // loop until the data contains no more 1's
				BEQ		END_SUB             
				LSR     R2, R1, #1 // perform SHIFT, followed by AND
				AND     R1, R1, R2     
				ADD     R0, #1 // count the string length so far
				B       LOOP_ONES            

ZEROES:			CMP		R1, #0 // corner case for checking if R1 is passed with all 0
				BEQ		CC_ZEROES
				MOV		R3, #OR_CONSTANT
				LDR		R3, [R3] // load the OR_CONSTANT into R3
				MOV     R0, #0 // R0 will hold the result
LOOP_ZEROES:	CMP     R1, R3 // loop until the data contains no more 0's
				BEQ		END_SUB
				ROR     R2, R1, #1 // perform SHIFT LEFT, followed by OR
				ORR		R1, R1, R2      
				ADD     R0, #1 // count the string length so far
				B       LOOP_ZEROES
CC_ZEROES:		MOV		R0, #32	// if the number was passed as 0, then that means all 32 bits are 0
				B		END_SUB

END_SUB:		BX	LR

END:			B	END             

OR_CONSTANT:	.word	0xffffffff
EOR_CONSTANT:	.word	0xaaaaaaaa

TEST_NUM:		.word	0xaaaaaaaa
				.word   0x103fe00f
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