####################################################################################
# Created by:  Davila, Alex
#              1465932
#              02 March 2020
#
# Assignment:  Lab 4: Syntax Checker
#              CMPE 012, Computer Systems and Assembly Language
#              UC Santa Cruz, Winter 2020
# 
# Description:  • You will write a program in the MIPS32 language 
#	        using the MARS integrated development environment 
#	        to check the balance of braces {}, brackets [], 
# 	        parentheses (). On an error, you will report a 
#	        32-bit integer byte offset (starting from 0) and 
#	        which brace, bracket or parenthesis is unmatched. 
#	        On success, you will print the number of matched braces,
#	        brackets and parentheses (collectively referred to as “braces”).
#
# Notes:          This program is intended to be run from the MARS IDE.
###################################################################################

.data
BufferSpace: .space 128 	#space to store strings to be read
fileEnteredMessage: .asciiz "You entered the file: \n"
SUCCESS_A: .asciiz "SUCCESS: There are "
SUCCESS_B: .asciiz " pairs of braces."
Err_A: .asciiz "Error - There is a brace mismatch: "
Err_B: .asciiz " at index "
Err_C: .asciiz "ERROR - Brace(s) still on stack:"
ERROR: .asciiz "\nERROR: Invalid program argument. "
space: .asciiz " "
extraspace: .asciiz " \n "


Message: "Success: There are # pairs of braces."

.text
	main: nop
	lw $t0, 0($a1) 		#$t0 has address of the filename
	lb $t1, 0($t0)		#loads first byte of the address name
	li $t2, 0			#count initialized to 0
	move $s3, $sp		#save #sp int a register
	
	FileCheck: nop
	blt $t1, 65, ErrorMessage 	#since I changed 4($t0) to 0($t0) this might be affected
	ble $t1, 90, CheckLength	#FileEntered  --> CheckLength
	blt $t1, 97, ErrorMessage
	ble $t1, 122, CheckLength		
	bgt $t1, 122, ErrorMessage
	
 
	
	CheckLength: nop
	lb $t1, 0($t0)
	beqz $t1, ExitCount		#should this be $t1??
	addi $t2, $t2, 1		#increment count
	addi $t0, $t0, 1		#increment t0 to get the next character
	bge $t2, 20, ErrorMessage
	j CheckLength
	ExitCount:

	FileEntered: nop
	li $v0, 4
 	la $a0, fileEnteredMessage		
 	syscall
 	li $v0, 4
 	lw $t0, 0($a1) 		#$t0 has address of the filename	
 	la $a0, ($t0)
 	syscall
 	li $v0, 11
 	la $a0, ' '
 	syscall
 	li $v0, 11
 	la $a0, '\n'
 	syscall
 	li $v0, 11
	la $a0, ' '		# ' ' = space
	syscall
	li $v0, 11
 	la $a0, '\n'
 	syscall
 	j OpenFile
 
	#---------------------------------------
	OpenFile: nop
	li $v0, 13          	#open a file
	la $a0, ($t0) 		# load address of the file name --> is in $t0 
	li $a1, 0           	# file flag (read)
	li $a2, 0   		# file mode (unused)
	syscall

	#--------------------------------------
	la $t3, BufferSpace 		#$t3 has buffer elements
	lb $t4, 0($t3)			#loads first byte of the buffer 
	li $t5, -1			#counter (index for buffer)
	li $t6, 0 			#counter for pop
	move $a0, $v0       	 	# load file descriptor
	#--------------------------------------
	#li $s1, 0
	#la $s2, BufferSpace
	#	ClearBuffer:
	#	beq $s1, 128 ReadFile
	#	sb $zero, 0($s2)
	#	addi $s1, $s1, 1
	#	addi $s2, $s2, 1
	#	j ClearBuffer
	
		ReadFile:
		li $v0, 14          	 	#read from file
		la $a1, BufferSpace        		# allocate space for the bytes loaded
		li $a2, 128        	 		# number of bytes to be read #16
		syscall
		blez $v0, done_ReadFile   		#$v0 contains number of characters read (0 if end-of-file, negative if error)
		#TRY------------------------------------
		READNEXT: nop
			lb $t4, 0($t3)		#load the first byte of the array/ can be bufferSpace
			addi $t5, $t5, 1		#increment counter on buffer for braces
			addi $t3, $t3, 1		#increment the index???
			beqz $t4, ExitArray 
			#-------------------
			beq $t4, 40, PUSH
			beq $t4, 91, PUSH
			beq $t4, 123, PUSH
			beq $t4, 41, POP
			beq $t4, 93, POP
			beq $t4, 125, POP
			j READNEXT 
			#--------------------
			PUSH: nop
			subi $sp, $sp, 4
			sw $t4, ($sp)		#store the brace which is in $t4 in memory
			subi $sp, $sp, 4
			sw $t5, ($sp)		#store the index of that brace in the array
			j READNEXT
			#---------------------
			POP:  nop			#$t8 has the closing brace I am trying to compare
			lw $t7, 0($sp)
			#addi $sp, $sp, 4
			lw $t8, 4($sp)
			#addi $sp, $sp, 4
			
			beq $s3, $sp, SpecialError
			
			beq $t4, 41, check1		# if $t4 = )
			beq $t4, 93, check2		# if $t4  = ]
			beq $t4, 125, check3	# if $t4 = }
		
		
			check1: nop
			beq $t8, 40, pop
			#j Mismatch
		
			check2: nop
			beq $t8, 91, pop
			#j Mismatch
		
			check3: nop
			beq $t8, 123, pop
			j Mismatch 		#mismatch
		
			pop: nop			#what is this pop1 supposed to do?
			addi $sp, $sp 4
			addi $sp, $sp 4
			addi $t6, $t6, 1 		#number of pairs
			j READNEXT
			ExitArray:	
	j ReadFile
	done_ReadFile:
	
	
	beq $s3, $sp, SuccessMessage
	li $v0, 4
	la $a0, Err_C
	syscall
	#extraspace
	li $v0, 11
	la $a0, ' '		# ' ' = space
	syscall
	Loop:
	beq $s3, $sp, exit
	lw $t5, ($sp)
	addi $sp, $sp, 4
	lw $t8, ($sp)
	addi $sp, $sp, 4
	li $v0, 11
	la $a0, ($t8)
	syscall
	j Loop
	
	j spc
	spc:
	li $v0, 11
	la $a0, ' '		# ' ' = space
	syscall
	j exit
	

	#do space after loop 
	
	#----------------------------
	SuccessMessage: nop
	li $v0, 4			#prints a string the SUCCESS messege
	la $a0, SUCCESS_A	
	syscall
	li $v0, 1
	la $a0, 0($t6)		#$t6 = counter of matched braces
	syscall
	li $v0, 4
	la $a0, SUCCESS_B  
	syscall
	li $v0, 11
	la $a0, ' '		# ' ' = space
	syscall
	j exit
	#-----------------------------
	SpecialError:
	li $v0, 4
	la $a0, Err_A		# "\nError - There is a brace mismatch: "
	syscall
	li $v0, 11
	la $a0, 0($t4)		#$t6 = counter of matched braces
	syscall
	li $v0, 4
	la $a0, Err_B		#"at index "
	syscall
	li $v0, 1
	la $a0, ($t5)		# $t5 = index
	syscall
	li $v0, 11
	la $a0, ' '		# ' ' = space
	syscall
	j exit
	#-----------------------------
	Mismatch: nop
	li $v0, 4
	la $a0, Err_A		# "\nError - There is a brace mismatch: "
	syscall
	li $v0, 11		
	la $a0, 0($t8)
	syscall
	li $v0, 4
	la $a0, Err_B		#"at index "
	syscall
	li $v0, 1
	la $a0, ($t7)		# $t5 = index
	syscall
	li $v0, 11
	la $a0, ' '		# ' ' = space
	syscall
	li $v0, 11		
	la $a0, 0($t4)
	syscall
	li $v0, 4
	la $a0, Err_B		#"at index "
	syscall
	li $v0, 1
	la $a0, ($t5)		# $t5 = index
	syscall
	li $v0, 11
	la $a0, ' '		# ' ' = space
	syscall
	j exit
	#-----------------------------
	ErrorMessage: nop
	li $v0, 4
 	la $a0, fileEnteredMessage		
 	syscall
 	li $v0, 4
 	lw $t0, 0($a1) 		#$t0 has address of the filename
 	la $a0, ($t0)
 	syscall
 	li $v0, 11
	la $a0, ' '		# ' ' = space
	syscall
 	li $v0, 11
 	la $a0, '\n'
 	syscall
 	li $v0, 11
	la $a0, ' '		# ' ' = space
	syscall
	li $v0, 4			#prints a string the error messege
	la $a0, ERROR	
	syscall
	j exit
	#-----------------------------------------
	#-- program is finished running --
	exit:
	li $v0, 11
	la $a0, '\n'		# ' ' = space
	syscall 
	li $v0, 16
	syscall
	li $v0, 10	
	syscall 
	
