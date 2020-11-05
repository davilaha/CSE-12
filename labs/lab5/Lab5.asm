####################################################################################
# Created by:  Davila, Alex
#              1465932
#              13 March 2020
#	     Winter20 Lab5
#
# Assignment:  Lab 5: Functions and Graphics
#              CMPE 012, Computer Systems and Assembly Language
#              UC Santa Cruz, Winter 2020
# 
# Description:  I implementented functions that perform some primitive 
#	      graphics operations on a small simulated display. These functions will 
#	      clear the entire display to a color, display a colored line, display 
#	      an unfilled colored triangle and display a filled colored rectangle 
#	      using a memory-mapped bitmap graphics display in MARS. To do this you 
#	      I utilized:
#			• Arrays
#			• Memory-mapped Input/Output (IO)
#			• Subroutines (a.k.a. Functions or Procedures)
#			• Macros
#			• The MIPS Stack (for arguments and subroutine call state)
#
#
# Notes: This program is intended to be run from the MARS IDE.
###################################################################################



# Macro that stores the value in %reg on the stack 
#  and moves the stack pointer.
.macro push(%reg)
	subi $sp, $sp, 4
	sw %reg, 0($sp)
.end_macro 

# Macro takes the value on the top of the stack and 
#  loads it into %reg then moves the stack pointer.
.macro pop(%reg)
	lw %reg, 0($sp)
	addi $sp, $sp, 4
.end_macro

# Macro that takes as input coordinates in the format
# (0x00XX00YY) and returns 0x000000XX in %x and 
# returns 0x000000YY in %y
.macro getCoordinates(%input %x %y)
         	#easier way
         	srl %x, %input, 16		#0x00000xx
	and %y, %input, 0x000000FF	#0x00000yy
.end_macro

# Macro that takes Coordinates in (%x,%y) where
# %x = 0x000000XX and %y= 0x000000YY and
# returns %output = (0x00XX00YY)
.macro formatCoordinates(%output %x %y)
	sll %output, %x, 16
	or %output, %output, %y
.end_macro 


.data
originAddress: .word 0xFFFF0000

.text

#---TEST---------#
#li $a0 0x00000000
#li $a1 0x00000080
#li $a2 0x00FF0000
#jal draw_line
#---TEST---------#

j done
    
    done: nop
    li $v0 10 
    syscall

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  Subroutines defined below
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#*****************************************************
# clear_bitmap:
#  Given a clor in $a0, sets all pixels in the display to
#  that color.	
#-----------------------------------------------------
# $a0 =  color of pixel
#*****************************************************
clear_bitmap: nop
	lw $t0, originAddress		#load adress into a $t#
	startClear:			#startLoop:
		beq $t0, 0xFFFFFFFC, endClear		#end_loop if $t# reaches 0xFFFFFFFC
		sw $a0, 0($t0)			#   stores $a0 into memory ($t#)
		addi $t0, $t0, 4			#   increment ($t#)
		b startClear			#   j startLoop
	endClear:				#end_loop
					#jr $ra
	jr $ra
	
#*****************************************************
# draw_pixel:
#  Given a coordinate in $a0, sets corresponding value
#  in memory to the color given by $a1
#  [(row * row_size) + column] to locate the correct pixel to color
#-----------------------------------------------------
# $a0 = coordinates of pixel in format (0x00XX00YY)
# $a1 = color of pixel
#*****************************************************
draw_pixel: nop			##draw_pixel##
	lw $t0, originAddress	#load adress into $t0 
	getCoordinates($a0, $t1, $t2)	#detCoordinates($a0, $tx, $ty)
	mul $t3, $t2, 128		#[(row * row_size) + column] ----> store value in a $t register
	add $t4, $t3, $t1	
	mul $t5, $t4, 4		#word alig coordinate ---> use the same $t value and multiply by 4
          #-----------------------------#
	add $t6, $t5, $t0		#$t value holds OA+Walign coord from above
	sw $a1, 0($t6)		#load the color of pixel into that $t value ex: sw $a1, ($t)
	jr $ra			#jr $ra
#*****************************************************
# get_pixel:
#  Given a coordinate, returns the color of that pixel	
#-----------------------------------------------------
# $a0 = coordinates of pixel in format (0x00XX00YY)
# returns pixel color in $v0	
#*****************************************************
get_pixel: nop
	lw $t0, originAddress	#load adress into $t0
	getCoordinates($a0, $t1, $t2)	#getCoordinates($a0, $t(x), $t(y))
	mul $t3, $t2, 128		#[(row * row_size) + column]
	add $t4, $t3, $t1	
	mul $t5, $t4, 4		#word aligned coordinate
          #-----------------------------#	
	add $t6, $t5, $t0		#$t6 holds OA+Walign coord
	lw $v0, 0($t6)		#load the color of pixel into $t6
	jr $ra			#jr $ra

#***********************************************
# draw_line:
#  Given two coordinates, draws a line between them 
#  using Bresenham's incremental error line algorithm	
#-----------------------------------------------------
# 	Bresenham's line algorithm (incremental error)
# plotLine(int x0, int y0, int x1, int y1)
#    dx =  abs(x1-x0);
#    sx = x0<x1 ? 1 : -1;
#    dy = -abs(y1-y0);
#    sy = y0<y1 ? 1 : -1;
#    err = dx+dy;  /* error value e_xy */
#    while (true)   /* loop */
#        plot(x0, y0);
#        if (x0==x1 && y0==y1) break;
#        e2 = 2*err;
#        if (e2 >= dy) 
#           err += dy; /* e_xy+e_x > 0 */
#           x0 += sx;
#        end if
#        if (e2 <= dx) /* e_xy+e_y < 0 */
#           err += dx;
#           y0 += sy;
#        end if
#   end while
#-----------------------------------------------------
# $a0 = first coordinate (x0,y0) format: (0x00XX00YY)
# $a1 = second coordinate (x1,y1) format: (0x00XX00YY)
# $a2 = color of line format: (0x00RRGGBB)
#***************************************************
draw_line: nop
	#---PUSH REGISTERS------------------------#
	push($s0)
	push($s1)
	push($s2)
	push($s3)
	push($s4)
	push($s5)
	push($s6)
	push($s7)
	push($ra)
	#plotLine(int x0, int y0, int x1, int y1)
	getCoordinates($a0, $t0, $t1)	#(x0,y0)	
	getCoordinates($a1, $t2, $t3) #(x1,y1)
	#dx =  abs(x1-x0); $t1 = x1-x0; $t4 = dx
	sub $s6, $t2, $t0			
	abs $t4, $s6
	#sx = x0<x1 ? 1 : -1;			
	bge $t0, $t2 set_sx_Negative
	li $t5, 1						
	j continue1
	set_sx_Negative:
	li $t5, -1
	continue1:
	#dy = -abs(y1-y0); $t8 = dy
	sub $t6, $t3, $t1
	abs $t7, $t6
	mul $t8, $t7, -1
	#sy = y0<y1 ? 1 : -1;
	bge $t1, $t3, set_sy_Negative
	li $t9, 1
	j continue2
	set_sy_Negative:
	li $t9, -1
	continue2:
	#err = dx+dy;  /* error value e_xy */ #$s0 = err
	add $s0, $t4, $t8		
	#while (true)   /* loop */
	infinitLoop:
		#plot(x0, y0);
		move $a1, $a2
		formatCoordinates($a0, $t0, $t1)
		push($t0)
		push($t1)
		push($t2)
		push($t3)
		push($t4)
		push($t5)
		push($t6)
		push($t7)
		push($t8)
		push($t9)
		push($ra)
		jal draw_pixel
		pop($ra)
		pop($t9)
		pop($t8)
		pop($t7)
		pop($t6)
		pop($t5)
		pop($t4)
		pop($t3)
		pop($t2)
		pop($t1)
		pop($t0)
		
		#if (x0==x1 && y0==y1) break;
		beq $t0, $t2, break0
		j continue3
		break0: 
		beq $t1, $t3, endAll
		
		continue3:
		#e2 = 2*err; $s1 ---> e2
		mul $s1, $s0, 2 
		
		break1:
		#if (e2 >= dy)
		blt $s1, $t8,  endCase1 
			#err += dy; /* e_xy+e_x > 0 */
			add $s0, $s0, $t8 
			#x0 += sx;
			add $t0, $t0, $t5
			j continue4
		#end if
		endCase1:
		
		continue4:
		#if (e2 <= dx) /* e_xy+e_y < 0 */
		bgt $s1, $t4, endCase2
			#err += dx;
			add $s0, $s0, $t4
			#y0 += sy;
			add $t1 $t1, $t9
		#end if
		endCase2:
	j infinitLoop
	endAll:
	#---POP REGISTERS-----C-------------------#
	pop($ra)
	pop($s7)
	pop($s6)
	pop($s5)
	pop($s4)
	pop($s3)
	pop($s2)
	pop($s1)
	pop($s0)
	
	jr $ra
	
#*****************************************************
# draw_rectangle:
#  Given two coordinates for the upper left and lower 
#  right coordinate, draws a solid rectangle	
#-----------------------------------------------------
# $a0 = first coordinate (x0,y0) format: (0x00XX00YY)
# $a1 = second coordinate (x1,y1) format: (0x00XX00YY)
# $a2 = color of line format: (0x00RRGGBB)
#***************************************************
draw_rectangle: nop
	push($ra)
	#plotLine(int x0, int y0, int x1, int y1)
	getCoordinates($a0, $t0, $t1)	#(x0,y0)	
	getCoordinates($a1, $t2, $t3) #(x1,y1)
		while:
		formatCoordinates($a0, $t0, $t1)
		formatCoordinates($a1, $t2, $t1)
		
		#push and pop to allocate
		push($t0)
		push($t1)
		push($t2)
		push($t3)
		jal draw_line
		pop($t3)
		pop($t2)
		pop($t1)
		pop($t0)
		
		#increment they y0 until y0 = y1
		addi $t1, $t1, 1
		bgt $t1, $t3, exit
		j while
	
	exit:
	pop($ra)
	jr $ra
	
#*****************************************************
#Given three coordinates, draws a triangle
#-----------------------------------------------------
# $a0 = coordinate of point A (x0,y0) format: (0x00XX00YY)
# $a1 = coordinate of point B (x1,y1) format: (0x00XX00YY)
# $a2 = coordinate of traingle point C (x2, y2) format: (0x00XX00YY)
# $a3 = color of line format: (0x00RRGGBB)
#-----------------------------------------------------
# Traingle should look like:
#               B
#             /   \
#            A ––  C
#***************************************************	
draw_triangle: nop
	push($ra)
	
	#move the parameters in a temp register
	move $t1, $a0
	move $t2, $a1
	move $t3, $a2
	
	#set up to draw aline from A=>B
	move $a0, $t2
	move $a1, $t3
	move $a2, $a3
	
	#you must push and pop the registers before calling draw_line
	push($t3)
	push($t1)
	push($t2)
	jal draw_line
	pop($t2)
	pop($t1)
	pop($t3)
	
	#set up for the draw_line from B=>C
	move $a0, $t1
	move $a1, $t3
	move $a2, $a3
	
	#you must push and pop the registers before calling draw_line
	push($t3)
	push($t1)
	push($t2)
	jal draw_line
	pop($t2)
	pop($t1)
	pop($t3)
	
	#set up for the draw_line from C=>A
	move $a0, $t1
	move $a1, $t2
	move $a2, $a3
	
	#you must push and pop the registers before calling draw_line
	push($t3)
	push($t1)
	push($t2)
	jal draw_line
	pop($t2)
	pop($t1)
	pop($t3)
	
	pop($ra)
	jr $ra	
	
	
	
