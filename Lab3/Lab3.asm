.data 
   prompt1: .asciiz " Enter the height of the pattern(must be greater than 0):"
   prompt2: .asciiz "Invalid Entry!\n"

   star: .asciiz "*"
   tab: .asciiz"\t"
   newline: .asciiz "\n"
.text
 
 req:                # This label checks for input validity and prints the error message and asks for the input
                     # until the valid input is received
  li $v0,4
  la $a0, prompt1    
  syscall            # prints the ask input statment in prompt1
  
  
  li $v0,4
  la $a0,tab
  syscall            # Prints a tab
  
  li $v0,5
  syscall            # Gets input
  move $t0, $v0
  
  blez $t0, label1  # conditional statement determinig whter input is valid or invalid
     nop 
     j after
  label1: nop
     li $v0, 4
     la $a0, prompt2
     syscall       # prints the error message
     j req         # jumpts to the start label to rpeat the process
  after:           # upon entering valid input, counters for height, numbers, and starts are set
    nop
    addi $t1,$t1,1# counter for height
    li $v0,4
    la $a0, newline
    syscall
    
    li $t6,0     # astrisk counter
    li $t2,0     #counter for number
    li $t9,0     # reverse num count
    li  $k0,0    # Tab on end count
    sub $k1, $t1,1
    sub $t7,$t0,$t1
    mul $t8, $t7,2  # counter check for astrisk
    ble $t1,$t0,number #compares height and current height(Row)
        nop
        j terminate # jumps to conclude the program after reaching given height
    number: nop
        beq $t2,$t1, astrisk # compares current and required stars in the pattern in that row
        nop
        j num
        astrisk: nop       # prints stars
          bne $t6,$t8,stars
          nop
          j revnum
          stars:nop
            li $v0,4
            la $a0, star
            syscall
            addi $t6,$t6,1
            li $v0,4
            la $a0,tab
            syscall 
            j astrisk
          revnum:nop # prints the numbers in reflection after stars
            bne $t9, $t1,reflect
            nop
            j after
            reflect:nop # special loop for end line element, without tab
              beq $k0 ,$k1,notab
              nop
              j down
              notab:nop
                move $a0,$t5
              li $v0,1
              syscall
              addi $t9,$t9,1
              sub $t5,$t5,1
              addi $k0,$k0,1
              j after
             down: nop         
              move $a0,$t5
              li $v0,1
              syscall
              addi $t9,$t9,1
              sub $t5,$t5,1
              li $v0,4
              la $a0,tab
              syscall
              addi $k0, $k0,1
              j revnum
        num: nop
        addi $t4, $t4,1#number supply
        move $a0, $t4
        li $v0, 1
        syscall 
        addi $t2,$t2,1
        addi $t5,$t4,0 # to print numbers in reverse order 
        li $v0,4
        la $a0,tab
        syscall
        j number
     terminate:nop
        li $v0, 10
        syscall 
         
        
     
     
 
 
 
   
   
