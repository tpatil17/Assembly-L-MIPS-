#Spring20 Lab5 Template File

# Macro that stores the value in %reg on the stack 
#  and moves the stack pointer.
.macro push(%reg)
 	subi  $sp $sp 4
 	sw %reg 0($sp)
.end_macro 

# Macro takes the value on the top of the stack and 
#  loads it into %reg then moves the stack pointer.
.macro pop(%reg)
 	lw %reg 0($sp)
	addi  $sp $sp 4	
.end_macro

# Macro that takes as input coordinates in the format
# (0x00XX00YY) and returns 0x000000XX in %x and 
# returns 0x000000YY in %y
.macro getCoordinates(%input %x %y)
	push($s0)						# store register value to stack
	push($s1)						# store register value to stack
	move $s0, %input					# store input vlue to $s0
	srl $s1, $s0, 16					# shift value to right by 16 to get "xx"
	move %x $s1						# store the "XX" value to %x
	sll $s1, $s1, 16					# shift the register value to left by 16 to get subtractor
	subu $s0, $s0, $s1					# subtract original value by subtractor to get "YY"
	move %y $s0						# store the "YY" value to %y
	pop($s1)						# restre calle save registers
	pop($s0)						# restore callle save register
	
.end_macro

# Macro that takes Coordinates in (%x,%y) where
# %x = 0x000000XX and %y= 0x000000YY and
# returns %output = (0x00XX00YY)
.macro formatCoordinates(%output %x %y)
	push($s0)						# save calle save reg
	push($s1)						# save calle save register
	move $s0 %x						# load register with x coordinate
	move $s1 %y						# load reg with Y coordinate
	sll $s0, $s0, 16					# shift xx by 16 to creat an add value
	addu $s0, $s1, $s0					# add the XX and YY in desired format
	move %output $s0					# output the result
	pop($s1)						# restore 
	pop($s0) 						# restore
.end_macro 


.data
originAddress: .word 0xFFFF0000

.text

j done
    
    done: nop
    li $v0 10 
    syscall

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  Subroutines defined below
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#*****************************************************
#Clear_bitmap: Given a color, will fill the bitmap display with that color.
#   Inputs:
#    $a0 = Color in format (0x00RRGGBB) 
#   Outputs:
#    No register outputs
#    Side-Effects: 
#    Colors the Bitmap display all the same color
#*****************************************************
clear_bitmap: nop
	push($s0)						# save calle save reg to stack
 	lw $s0, originAddress					# load the top left pixel address ( the base)
 	loop1:nop						# loop 
 		bgt $s0, 0xfffffffc, ex				# stop when last pixel is colored
 		sw $a0 ($s0)					# fill the color at pixel address
 		addi $s0, $s0, 4				# next pixel address
 		j loop1						
 		
 	ex: nop							# when last pixel is colored
 	pop($s0)						# restore the calle save reg
	jr $ra							# jump reg
	
#*****************************************************
# draw_pixel:
#  Given a coordinate in $a0, sets corresponding value
#  in memory to the color given by $a1	
#-----------------------------------------------------
#   Inputs:
#    $a0 = coordinates of pixel in format (0x00XX00YY)
#    $a1 = color of pixel in format (0x00RRGGBB)
#   Outputs:
#    No register outputs
#*****************************************************
draw_pixel: nop
	getCoordinates($a0 $v0 $v1)
	push($s0)						# save calle save reg to stack
	push($s1)						# save calle save reg to stack
	push($s2)						# save calle save reg to stack
	push($s3)						# save calle save reg to stack
	move $s0, $v0						# load $s0 with x-coordinate
	mulu  $s0, $s0, 4					# word align
	move $s1, $v1						# load $s1 with y-coordinate
	mulu  $s1, $s1, 4					# word align
	li $s2, 128						# load row size to $s2 for further use
	mulu  $s2 $s2 $s0					# $s2 = row_size * x-coordinte
	addu $s2 $s2 $s1					# $s2 = (row_size * x-coordinate)+ y-coordinate / desired pixel
	lw $s3 originAddress					# load the reg with base address
	addu $s2 $s2 $s3					# $s2 has the address of desired pixel
	sw $a1 ($s2)						# color the pixel by color in $a1
	pop($s3)						# restore reg
	pop($s2)						# restore reg
	pop($s1)						# restore reg
	pop($s0)						# restore reg
	jr $ra							# jump reg
	
#*****************************************************
# get_pixel:
#  Given a coordinate, returns the color of that pixel	
#-----------------------------------------------------
#   Inputs:
#    $a0 = coordinates of pixel in format (0x00XX00YY)
#   Outputs:
#    Returns pixel color in $v0 in format (0x00RRGGBB)
#*****************************************************
get_pixel: nop
	getCoordinates($a0 $v0 $v1)
	push($s0)						# save calle save reg to stack
	push($s1)						# save calle save reg to stack
	push($s2)						# save calle save reg to stack
	push($s3)						# save calle save reg to stack
	move $s0, $v0						# load $s0 with x-coordinate
	mulu $s0, $s0, 4					 	# word align
	move $s1, $v1						# load $s1 with y-coordinate
	mulu $s1, $s1, 4						# word align
	li $s2, 128						# load row size to $s2 for further use
	mulu $s2 $s2 $s0					# $s2 = row_size * x-coordinte
	addu $s2 $s2 $s1					# $s2 = (row_size * x-coordinate)+ y-coordinate / desired pixel
	lw $s3 originAddress					# load the reg with base address
	addu $s2 $s2 $s3					# $s2 has the address of desired pixel
	lw $v0 ($s2)						# the color at that address to be stored in $v0
	pop($s3)						# restore reg
	pop($s2)						# restore reg
	pop($s1)						# restore reg
	pop($s0)						# restore reg
	jr $ra

#***********************************************
# draw_solid_circle:
#  Considering a square arround the circle to be drawn  
#  iterate through the square points and if the point 
#  lies inside the circle (x - xc)^2 + (y - yc)^2 = r^2
#  then plot it.
#-----------------------------------------------------
# draw_solid_circle(int xc, int yc, int r) 
#    xmin = xc-r
#    xmax = xc+r
#    ymin = yc-r
#    ymax = yc+r
#    for (i = xmin; i <= xmax; i++) 
#        for (j = ymin; j <= ymax; j++) 
#            a = (i - xc)*(i - xc) + (j - yc)*(j - yc)	 
#            if (a < r*r ) 
#                draw_pixel(x,y) 	
#-----------------------------------------------------
#   Inputs:
#    $a0 = coordinates of circle center in format (0x00XX00YY)
#    $a1 = radius of the circle
#    $a2 = color in format (0x00RRGGBB)
#   Outputs:
#    No register outputs
#***************************************************

draw_solid_circle: nop
	push($s0)							# save calle save reg to stack
	push($s1)							# save calle save reg to stack
	push($s2)	 						# save calle save reg to stack
	push($s3)							# save calle save reg to stack
	push($s4)							# save calle save reg to stack
	push($s5)							# save calle save reg to stack
	push($s6)							# save calle save reg to stack
	push($s7)							# save calle save reg to stack
	push($k0)							# save calle save reg to stack
	push($k1)							# save calle save reg to stack
	push($ra)							# save return reg
	move $k1 $a1						        # store the radius value
	getCoordinates($a0 $v0 $v1)					# get the coordinates 
	move $s0 $v0							# $s0 contains x-coordinate of center
	move $s1 $v1							# $s1 contains y-coordinate of center
	subu $s2 $s0 $k1						# $s2 is xmin
	addu $s3 $s0 $k1						# $s3 is xmax
	subu $s4 $s1 $k1						# $s4 is ymin
	addu $s5 $s1 $k1						# $s5 is ymax
	pix_loop:nop
		move $s6 $s2						# set reg to xmin
		forX:nop						# for loop for x=xmin; x<=xmax
		bgt $s6 $s3 brake					# break from loop if x > xmax
		nop
		move $s7 $s4						# current y = ymin ; y<= ymax
		nop
		forY:nop						# for current x all values of y are tried
		bgt $s7 $s5 next					# after all y exhausted move on to next x
		subu $t0, $s6, $s0					# (i-xc)
		mulu $t0, $t0, $t0					# (i-xc)^2
		subu $t1, $s7, $s1					# (j-yc)
		mulu $t1, $t1, $t1					# (j-yc)^2
		addu $t2, $t0, $t1					# (i-xc)^2 + (j-yc)^2
		mulu $t3, $k1, $k1					# radius ^2
		blt $t2, $t3, draw					# draw pixel if in range
		nop
		addi $s7 $s7 1						# next y coordinate
		j forY
		draw:nop
		formatCoordinates($v0 $s6 $s7)				# get the cordinate input compatible
		move $a0 $v0						# input for draw_pixel
		move $a1 $a2						# color for draw pixal
		jal draw_pixel						# draw the pixel at current locus
		addi $s7 $s7 1						# increase in y-coordinate
		j forY
			
		next:nop						# repeat same for next x
		addi $s6 $s6 1						# next x-coordinate
		j forX
		
		
	brake:nop							# drills for all possible x exhausted then end
	pop($ra)
	pop($k1)
	pop($k0)
	pop($s7)							# restore
	pop($s6)
	pop($s5)
	pop($s4)
	pop($s3)
	pop($s2)
	pop($s1)
	pop($s0)
	jr $ra
	

#***********************************************
# draw_circle:
#  Given the coordinates of the center of the circle
#  plot the circle using the Bresenham's circle 
#  drawing algorithm 	
#-----------------------------------------------------
# draw_circle(xc, yc, r) 
#    x = 0 
#    y = r 
#    d = 3 - 2 * r 
#    draw_circle_pixels(xc, yc, x, y) 
#    while (y >= x) 
#        x=x+1 
#        if (d > 0) 
#            y=y-1  
#            d = d + 4 * (x - y) + 10 
#        else
#            d = d + 4 * x + 6 
#        draw_circle_pixels(xc, yc, x, y) 	
#-----------------------------------------------------
#   Inputs:
#    $a0 = coordinates of the circle center in format (0x00XX00YY)
#    $a1 = radius of the circle
#    $a2 = color of line in format (0x00RRGGBB)
#   Outputs:
#    No register outputs
#***************************************************
draw_circle: nop
	push($ra)								# save return reg to stack
	push($s0)								# save calle save reg to stack
	push($s1)								# save calle save reg to stack
	push($s2)								# save calle save reg to stack
	push($s3)								# save calle save reg to stack
	push($s4)
	#push($k0)								# save reg to stack
	#push($k1)								# save reg to stack
	li $s0 0								# set x with 0
	move $s1 $a1								# set y = radius
	li $s3  3								# further use for d
	mulu $s2 $s1 2							        # 2*radius
	sub $s3, $s3, $s2 							# d=$s3= 3-2R
	move $s4 $a0								# copy center
	move $a0 $s4								# $a0 is coordinates of center
	move $k1 $a2								# save the color
	move $a1 $k1								# color for draw circle pixel
	move $a2 $s0								# current x for draw circle pixel
	move $a3 $s1								# current y for draw circle pixel
	jal draw_circle_pixels							# subroutine 
	while:nop								# while loop
		blt $s1 $s0 out							# dont enter loop if y < x/ while y>=x
		addiu $s0 $s0 1							# x=x+1
		ble $s3 0 else							# if d > 0 proceed , else go to "else"
		subiu $s1 $s1 1							# y= y-1
		subu $k0 $s0 $s1						# store x-y
		mulu $k0 $k0 4							# store (x-y)*4
		addiu $k0 $k0 10							# store (x-y)*4 +10
		addu $s3 $s3 $k0						# d = d + (x-y)*4 + 10
		j dcp							
		nop
		else:nop							# else
		mulu $k0 $s0 4							# store x*4
		addu $s3 $s3 $k0						# d= d+ x*4
		addiu $s3 $s3 6							# d = d + x*4 + 6
		j dcp								
		
		dcp:nop								# draw_circle_pixel
		move $a0 $s4							# center coordinate
		move $a1 $k1							# input color
		move $a2 $s0							# current x for draw circle pixel
		move $a3 $s1							# current y for draw circle pixel
		jal draw_circle_pixels
		nop
		j while								# loop to while
		
	out: nop								# when while loop ends
	#pop($k1)								# restore register
	#pop($k0)								# restore regieter
	pop($s4)
	pop($s3)								# restore register
	pop($s2)								# restore register
	pop($s1)								# restore register
	pop($s0)								# restore register
	pop($ra)								# restore register
	jr $ra
	
#*****************************************************
# draw_circle_pixels:
#  Function to draw the circle pixels 
#  using the octans' symmetry
#-----------------------------------------------------
# draw_circle_pixels(xc, yc, x, y)  
#    draw_pixel(xc+x, yc+y) 
#    draw_pixel(xc-x, yc+y)
#    draw_pixel(xc+x, yc-y)
#    draw_pixel(xc-x, yc-y)
#    draw_pixel(xc+y, yc+x)
#    draw_pixel(xc-y, yc+x)
#    draw_pixel(xc+y, yc-x)
#    draw_pixel(xc-y, yc-x)
#-----------------------------------------------------
#   Inputs:
#    $a0 = coordinates of circle center in format (0x00XX00YY)
#    $a1 = color of pixel in format (0x00RRGGBB)
#    $a2 = current x value from the Bresenham's circle algorithm
#    $a3 = current y value from the Bresenham's circle algorithm
#   Outputs:
#    No register outputs	
#*****************************************************
draw_circle_pixels: nop
	
	push($s0)								# save reg
	push($s1)								# save reg
	push($s2)								# save reg
	push($s3)								# save reg
	push($s4)								# save reg
	push($ra)
	
	getCoordinates($a0 $v0 $v1)						# get the coordinates of center
	move $s0 $v0								# $s0 is xc
	move $s3 $s0								# copy xc
	move $s1 $v1								# $s1 is yc
	move $s4 $s1								# copy yc
	addu $s0 $s0 $a2							# xc + x
	addu $s1 $s1 $a3							# yc + y
	formatCoordinates($v0 $s0 $s1)						# format for draw_pixel
	move $a0 $v0								# input coordinat to draw pixel
	jal draw_pixel								# draw_pixel(xc+x, yc+y)
	 
	move $s0 $s3								# restore xc to $s0
	subu $s0 $s0 $a2							# xc - x
	formatCoordinates($v0 $s0 $s1)						# xc-x, yc+y
	move $a0 $v0								# input coordinate for draw pixel
	jal draw_pixel								# draw_pixel(xc-x, yc + y)
	
	move $s0 $s3								# restore xc
	move $s1 $s4								# restore yc
	addu $s0 $s0 $a2							# xc + x
	subu $s1 $s1 $a3							# yc - y
	formatCoordinates($v0 $s0 $s1)						# xc+x, yc-y
	move $a0 $v0								# input coordinat to draw pixel
	jal draw_pixel								# draw_pixel(xc+x, yc-y)
	 
	move $s0 $s3								# restore xc
	move $s1 $s4								# restore yc
	subu $s0 $s0 $a2							# xc - x
	subu $s1 $s1 $a3							# yc - y
	formatCoordinates($v0 $s0 $s1)						# xc-x, yc-y
	move $a0 $v0								# input coordinat to draw pixel
	jal draw_pixel								# draw_pixel(xc-x, yc-y)
	 
	move $s0 $s3								# restore xc
	move $s1 $s4								# restore yc
	addu $s0 $s0 $a3							# xc + y
	addu $s1 $s1 $a2							# yc + x
	formatCoordinates($v0 $s0 $s1)						# xc+y, yc + x
	move $a0 $v0								# input coordinat to draw pixel
	jal draw_pixel								# draw_pixel(xc+y, yc+x)
	 
	move $s0 $s3								# restore xc
	move $s1 $s4								# restore yc
	subu $s0 $s0 $a3							# xc - y
	addu $s1 $s1 $a2							# yc + x
	formatCoordinates($v0 $s0 $s1)						# xc-y , yc + x
	move $a0 $v0								# input coordinat to draw pixel
	jal draw_pixel								# draw_pixel(xc-y, yc+x)
	 
	move $s0 $s3								# restore xc
	move $s1 $s4								# restore yc
	addu $s0 $s0 $a3							# xc + y
	subu $s1 $s1 $a2							# yc - x
	formatCoordinates($v0 $s0 $s1)						# xc+y , yc - x
	move $a0 $v0								# input coordinat to draw pixel
	jal draw_pixel								# draw_pixel(xc+y, yc-x)
	 
	move $s0 $s3								# restore xc
	move $s1 $s4								# restore yc
	subu $s0 $s0 $a3							# xc - y
	subu $s1 $s1 $a2							# yc - x
	formatCoordinates($v0 $s0 $s1)						# xc-y , yc - x
	move $a0 $v0								# input coordinat to draw pixel
	jal draw_pixel								# draw_pixel(xc-y, yc-x) 
	
	pop($ra)
	pop($s4)								# restore
	pop($s3)								
	pop($s2)
	pop($s1)
	pop($s0)
	
	
	jr $ra
