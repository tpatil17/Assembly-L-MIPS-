I, Tanishq Patil, have read and understood the Spring CSE12 syllabus and Personal Responsibility Document. tpatil 3 April 2020
Name: Tanishq Patil
Cruz ID: Tmpatil
Lab3:A program to print out a pattern with numbers and stars(astrisk)


 DESCRIPTION
 
In this lab the user enters a number as an input, which is the hegiht of the pattern. The input should be greater than zero, if the input is invalid an error message is
printed and the user is asked again for the correct input until a valid input is received. if the input is valid a pattern of numers and stars is printed, where each 
number and star is seperated by a tab and the height of the pattern is equal to the number given as input.

FILES

Lab3.asm 
This file includes the code for the assignment.

INSTRUCTIONS

This program is intended to be run using the MIPS Assembler and Runtime Simulator
(MARS). Enter the test case as a program argument and run using MARS.

This program asks for a input, which is height of the pattern. The input value 
should be an integer greater than 0.If input is valid the program proceeds to 
print the pattern or an error message is printed and input is asked again until 
a valid input is received .

print " Enter the height of the pattern(must be grater than 0):\t" (input)

while input <=0:
    print " Invalid Entry!"
    print" Enter the height of the pattern(must be greater than 0):\t"(input)

CtrRow = 0
CtrNum = 0
Ctrstar = 0
revnum = 0
while input > 0:
    while CtrRow != input:
        while CtrNum != CtrRow:
            num += 1
            print(num)
            print("\t")
            CtrNum +=1
        while Ctrstar != (input -1)*2:
            print("*")
            print("\t")
            Ctrstar +=1
        while revnum != input:
            rnum = num
            if revnum != input-1
                print(rnum)
                rnum-=1
                revnum +=1
            else:
                print(rnum)
                print("\t")
                rnum-=1
                revnum +=1
        CtrRow +=1
    end()
        