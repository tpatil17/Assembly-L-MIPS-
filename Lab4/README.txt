Tanishq Patil
Tmpatil
Spring 2020
Lab 4: 

DESCRIPTION

In this Lab the input will be accepted via program arguments. These program 
arguments will be in hexa-decimal format and will be printed in the order they 
were given. They will then be converted to decimal values(integers) and wil
be printed on screen. These numbers will then be sorted in ascending order and 
will be printed on the screen.

FILES

Diagram.pdf

This file includes a block diagram of the program design.The application draw.io
was used to draft the diagram and generate the pdf.

Lab4.asm

This file includes the assembly code of the lab.

Instructions

This program is intended to be run using the MIPS Assembler and Runtime Simulator
(MARS). Enter the test case as a program argument and run using MARS.

The program arguments will be accessed via the adress at $a1 register. The 
arguments will be printed as the are accessed. They will then be converted to 
decimal form, printed and stored ina an array simultaneously. the array will 
then be sorted and printed.

base = address of the program argument    # access the arguments by loading the address
ele = numebr of arguments
for i in range(ele):
   print(content at base)
   base+=4                                # increase 4 bytes to get the address of next argument
list= []
for i in range(ele):
   convert_hex_to_dec(content_at_base)
   list.append(converted value)
   print(converted value)
   base+=4
 ascending = sorted(list)
 print(list)