# longest_string_in_binary_number
Working code for ECE243 Lab 2 (Winter 2023) at the University of Toronto. The goal is to count the longest consecutive string of 1s, 0s, and alternating 1s and 0s in a word (32 bits) of data. All code is written and debugged in ARM Assembly. To simulate the code, upload the code and compile using the ARMv7 [CPUlator online tool](https://cpulator.01xz.net/?sys=arm-de1soc "CPUlator"). See the included lab handout for more information.

## Part 2
Part 2 counts the longest consecutive 1s in a word for an array of data. For example, for the following array:
```assembly
TEST_NUM: .word 0x103fe00f
          .word	0x1022fb03
          .word	0x7048453e
          .word	0xed315d13
          .word	0x5e17aa47
          .word 0x186b4aa8
          .word	0xc3c859a4
          .word	0x2ce8aa3c
          .word	0xe0f63f64
          .word	0x1feb739d
          .word	0x75e8a6ab
          .word	0
```
The output in Register R5 is:
![image](https://user-images.githubusercontent.com/105998663/221735043-9a1c3b2e-fecb-4e36-98fa-760f95a02a9a.png)

This corresponds to the first word: ```0x103fe00f```

## Part 3
Part 3 counts the longest consecutive 1s, 0s, and alternating 1s and 0s in a word for an array of data. For the following array:
```assembly
TEST_NUM:		.word	0xaaaaaaaa
            .word 0x103fe00f
            .word	0x1022fb03
            .word	0x7048453e
            .word	0xed315d13
            .word	0x5e17aa47
            .word 0x186b4aa8
            .word	0xc3c859a4
            .word	0x2ce8aa3c
            .word	0xe0f63f64
            .word	0x1feb739d
            .word	0x75e8a6ab
            .word	0
```

The output in registers R5, R6 and R7 is:
![image](https://user-images.githubusercontent.com/105998663/221735833-eabf2816-d9fb-4706-9ed7-e0eeac66dab2.png)

## Part 4
Part 4 does the same as Part 3 but displays the results on the hex displays from HEX0-HEX5. For the same array as in Part 3, the hex displays now show the contents of registers R5-R7: 
![image](https://user-images.githubusercontent.com/105998663/221736199-a1325465-510f-4d0a-a932-14048d686a18.png)

