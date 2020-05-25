.data
      Tab:.asciiz "\t"
      program1: .asciiz "Integer values:"
      newline: .asciiz " \n"
      myarray: .space 32
      sortedV: .asciiz "Sorted values:\n"
      program: .asciiz "Program arguments:"
.text
 move $s5, $a1       # copy the address
 add $s0, $s0, $a0   # copy the number of elements
 add $t0, $t0, $zero # set a counter
 li $v0, 4
 la $a0, program
    syscall
 li $v0, 4
 la $a0, newline
    syscall


 mainP:nop  
    blt $t0, $s0, printP
    nop
    j hexTd
    printP:nop
    	lw $a0, ($a1)
    	li $v0, 4
    	syscall
    	addi $a1, $a1, 4 #next element
    	addi $t0, $t0, 1
    	li $v0, 4
    	la $a0, Tab
    	syscall
    	j mainP
    
 hexTd:
 move $a1, $s5
 li $t0, 0
 li $k0, 0 # claculator/adder
 li $t4, 0
 li $t2, 0 # power reference/byte count
 li $s7, 0  # array
 li $v0, 4
 la $a0, newline
 syscall 
 li $v0, 4
 la $a0, program1
 syscall 
 li $v0, 4
 la $a0, newline
 syscall 
 big:nop
  beq $t4, $s0, sort # terminate after last argument is read/ move on to sorting 
  lw $t0, ($a1)
  li $t2, 0 # Reset counter
  li $t3, 4 # power
  li $k0, 0 # Reset calculator
  nop
  loop:nop
   li $t5, 1
   lb $t1, ($t0)
   beq $t2, 4, new
   nop
   blt $t1,48, null
   nop
   bgt $t1, 57,capital # checks if the number is hex alphabet
   subu $t1, $t1, 48
   multiple:nop
           beq  $t5, $t3, out
           nop
           mul $t1, $t1, 16
           addi $t5, $t5, 1
           j multiple
   out:nop
   add $k0, $k0, $t1
   addi $t2, $t2, 1
   subu $t3, $t3, 1
   addi $t0, $t0, 1
   j loop
 capital:nop
         beq $t2, 4, new
         nop 
	 blt $t1, 65, null
	 bgt $t1, 70, small
	 subu $t1, $t1, 55
     multiple1:nop
           beq $t5, $t3, out1
           nop
           mul $t1, $t1, 16
           addi $t5, $t5, 1
           j multiple1
     out1:nop
 	add $k0, $k0, $t1 
	addi $t2, $t2,1
	addi $t0, $t0,1
	subu $t3, $t3,1
	j loop
	small:nop
	     beq $t2, 4,new
	     nop
	     blt $t1, 97, null
	     bgt $t1, 102, null
	     subu $t1, $t1, 87
	  multiple2:nop
                beq $t5, $t3, out2
                nop
                mul $t1, $t1, 16
                addi $t5, $t5, 1
                j multiple2
        out2:nop
	     add $k0, $k0,$t1
	     addi $t2, $t2, 1
	     addi $t0, $t0, 1
	     subu $t3, $t3, 1     
	     j loop
 null:
     addi $k0, $k0, 0# null terminate or display error
     addi $t2, $t2, 1
     addi $t0, $t0, 1 #next byte
     subu $t3, $t3, 1
     j loop
 new:nop
 li $v0, 1     #print the conveted decimal number
 move $a0, $k0
 syscall 
 li $v0, 4
 la $a0,Tab
      syscall 
 sb $k0, myarray($s7) # store it into myarray
 addi $t4, $t4, 1
 addi $a1, $a1, 4 #new element
 addi $s7, $s7, 4 # next address for next number
 j big 

 sort:nop
    # We wil use bubble sort to sort the decimal values
     li $s7, 0
     move $s1, $s7
     li $k1, 1 # counter
     li $k0, 1 # log /register of no swaps
     main:nop
     beq $k1, $s0, pass   # after a round of n-1 operations, pass to another round
     beq $k0, $s0, end    # end program if no swap is made in the pass
     lbu $t0, myarray($s7) #load the inetger from array/ pointer is set
     lbu $t1, myarray+4($s7)
     bgt $t0, $t1, swap   #if the number is greater than other, swap positions
     nop
     addi $k1, $k1, 1
     addi $k0, $k0, 1    # log 1 no swap, if no swaps are made throughout 
     beq  $k0, $s0, end
     addi $s7, $s7, 4     # set pointer on next number
     j main
     swap:nop
     sb $t0, myarray+4($s7)
     sb $t1, myarray($s7)
     addi $k1, $k1, 1
     beq  $k1, $s0, pass
     addi $s7, $s7, 4
     j main
     pass:nop
     move $s7, $s1       # Reset $s7
     li $k1, 1           # Reset op count
     li $k0, 1           # Reset swap log
     j main
 
 end:nop
 li $s7, 0    # address of first element
 li $t3, 0    # counter
 li $v0, 4
 la $a0, newline
 syscall 
 li $v0, 4
 la $a0, sortedV
 syscall 
 while:nop
 beq $t3, $s0, term # terminate after all values are printed
 li $v0, 1
 lbu  $a0, myarray($s7)
 syscall
 addi $s7, $s7, 4
 addi $t3, $t3, 1
 li $v0, 4
 la $a0, Tab
 syscall 
 j while
 term:nop
 li $v0, 10
 syscall 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
