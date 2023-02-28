				.text
				.global _start        
				
				// code from Part III
_start:			MOV		R10, #TEST_NUM // load the data word address into R10
				MOV		R5, #0 // initialze R5 to 0, which will store largest number of 1 count
				MOV		R6, #0 // initialize R6 to 0, which will store largest number of 0 count
				MOV		R7, #0 // initialize R7 to 0, which will store largest number of alternating count
		  
WORD_LOOP:		LDR		R1, [R10] // get the next word
				CMP		R1, #0 // check if R1 (current word) is 0
		  		BEQ		END // if R1 is 0, then branch to end
		  		  
				// get the largest consecutive string of ones in the 32 bit number
				// algorithm:
				// 1. shift number to the left.
				// 2. and original number with the shifted one, and replace original number with result.
				// 3. increment counter and repeat loop until number is equal to 0.
				BL		ONES
				CMP		R5, R0 // check if current word has more zeroes than what current max 
				MOVLT	R5, R0 // if it has more zeroes then replace count
			
				// get the largest consecutive string of zeroes in the 32 bit number
				// algorithm:
				// 1. rotate shift number to the left.
				// 2. or original number with the shifted one, and replace original number with result.
				// 3. increment counter and repeat loop until number is equal to 0xffffffff
				// 4. make sure to check for corner case as well
				LDR		R1, [R10]
				BL		ZEROES
				CMP		R6, R0
				MOVLT	R6, R0
			
				// get the largest consecutive alternating string of ones and zeroes in the 32 bit number
				// algorithm:
				// 1. XOR number with alternating string of 0 and 1 (0xaaaaaaaa)
				// 2. find largest number of consecutive ones (using previous algorithm).
				// 3. find largest number of consecutive zeroes (using previous algorithm), checking for corner case as well
				// compare the two results are store the largest one
			
				LDR		R1, [R10]
				MOV		R3, #EOR_CONSTANT
				LDR		R3, [R3]
				EOR		R1, R1, R3 // instead of finding alternating string, find the largest number of zeroes by doing XOR with alternating string first
				BL		ONES
				CMP		R7, R0
				MOVLT	R7, R0
			
				LDR		R1, [R10]
				MOV		R3, #EOR_CONSTANT
				LDR		R3, [R3]
				EOR		R1, R1, R3 // instead of finding alternating string, find the largest number of zeroes by doing XOR with alternating string first
				BL		ZEROES
				CMP		R7, R0 // if result is greater when checking ones, then replace r7 with that result
				MOVLT	R7, R0
			
				//Display R5 on HEX1-0, R6 on HEX3-2 and R7 on HEX5-4
DISPLAY:		LDR     R8, =0xFF200020 // base address of HEX3-HEX0
				
				// convert R5 into a bit code for the hex display
				MOV     R0, R5 // display R5 on HEX1-0
				BL      DIVIDE // ones digit will be in R0; tens digit in R1
				MOV     R9, R1 // save the tens digit
				
				BL      SEG7_CODE // convert the ones digit into a bit code
				MOV     R4, R0 // save bit code
				MOV     R0, R9 // retrieve the tens digit, get bit code
				BL      SEG7_CODE // convert the tens digit into a bit code
				LSL     R0, #8
				ORR     R4, R0 // merge the tens digit and one digit and store in R4.
				
				// convert R6 into a bit code for the hex display
				MOV		R0, R6 // display R6 on HEX3-2
				BL		DIVIDE // ones digit will be in R0; tens digit in R1
				MOV		R9, R1 // save the tens digit
				
				BL		SEG7_CODE // convert the ones digit into a bit code
				LSL		R0, #16
				ORR		R4, R0 // save ones bit code by merging with R5 bit codes
				MOV		R0, R9 // retrieve the tens digit, get bit code
				BL		SEG7_CODE // convert the tens digit into a bit code
				LSL		R0, #24
				ORR		R4, R0 // save tens bit code by merging with R5 bit codes

				// display numbers from R6 and R5 on hex display
				STR     R4, [R8]
				
				LDR     R8, =0xFF200030 // base address of HEX5-HEX4
				
				// convert R7 into a bit code for the hex display
				MOV		R0, R7 // display R6 on HEX3-2
				BL		DIVIDE // ones digit will be in R0; tens digit in R1
				MOV		R9, R1 // save the tens digit
				
				BL		SEG7_CODE // convert the ones digit into a bit code
				MOV		R4, R0 // save bit code
				MOV		R0, R9 // retrieve the tens digit, get bit code
				BL		SEG7_CODE // convert the tens digit into a bit code
				LSL		R0, #8
				ORR		R4, R0 // merge the tens digit and one digit and store it in R4
				
				// display the number from R7 on the hex display
				STR     R4, [R8]
			
				// increment to the next word
				ADD		R10, #4
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

				/* Subroutine to perform the integer division R0 / 10.
				 * Returns: quotient in R1, and remainder in R0 */
DIVIDE:			MOV		R2, #0
CONT:       	CMP		R0, #10
				BLT		DIV_END
				SUB		R0, #10
				ADD		R2, #1
				B		CONT
DIV_END:    	MOV		R1, R2     // quotient in R1 (remainder in R0)
				B		END_SUB

				/* Subroutine to convert the digits from 0 to 9 to be shown on a HEX display.
				 *    Parameters: R0 = the decimal value of the digit to be displayed
				 *    Returns: R0 = bit patterm to be written to the HEX display
				 */
SEG7_CODE:		MOV		R1, #BIT_CODES  
				ADD		R1, R0         // index into the BIT_CODES "array"
				LDRB	R0, [R1]       // load the bit pattern (to be returned)
				B		END_SUB

				// branch to end subroutine
END_SUB:		BX		LR

				// end the program
END:			B		END

				// data used for our program
BIT_CODES:		.byte	0b00111111, 0b00000110, 0b01011011, 0b01001111, 0b01100110
				.byte	0b01101101, 0b01111101, 0b00000111, 0b01111111, 0b01100111
				.skip	2 // pad with 2 bytes to maintain word alignment

OR_CONSTANT:	.word	0xffffffff
EOR_CONSTANT:	.word	0xaaaaaaaa

TEST_NUM:		//.word	0xaaaaaaaa // corner case testing
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