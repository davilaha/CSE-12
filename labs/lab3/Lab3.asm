##########################################################################
# Created by:  Davila, Alex
#              1465932
#              20 February 2020
#
# Assignment:  Lab 3: ASCII-risks (Asterisks)
#              CMPE 012, Computer Systems and Assembly Language
#              UC Santa Cruz, Winter 2020
# 
# Description:  • This lab introduced me to the MIPS ISA using MARS.
# 		• I wrote a program with several nested loops to print variable
#  		  sized ASCII diamond and a sequence of embedded numbers.
# 		• In addition, I implemented several different syscalls 
#   		  to incorporate I/O into my program.
#
# 
# Notes:       This program is intended to be run from the MARS IDE.
##########################################################################

.text	#for all my structions
	main:
	li $t4 1
	la $a0, prompt		#prompt the user to enter input
	li $v0, 4			#prints string
	syscall			#implemented syscall
	li $v0, 5			#to read user input
	syscall 
	move $s0, $v0		#store the result 'userInput' in $t0 temporarily
				#this is because I will be modifying $v0 later
	bge $s0, 1, Outer		#this is outer loop, if true it will go to Outer:
	li $v0, 4			#prints a string the error messege
	la $a0, message	
	syscall
	j main				#jumps to main until the 'userInput' is positive
	
		Outer:	
		addi $t0, $t0, 1		# currentRow++ or currentRow = currentRow + 1;		
 		bgt  $t0, $s0, OuterExit	# currentRow <= userInput, jump TabLoop to print something	
		sub $t9, $s0, $t0		# t9 = userInput - currentRow ($t9 = $s0 - $t0)
		li $t1, 0			# numChars = 0;  number of characters per line

		TabLoop:
 		bge $t1, $t9, tabExit	# while number of tabs < userInput - currentRow/line
 		li $v0, 11		# prints character
 		li $a0, '\t'		# the character is TAB or code 9 
 		syscall			# calling syscall
 		addi $t1, $t1, 1		#increments #oftabs
 		j TabLoop
 		tabExit:
 		
 			
 			li $t2, 1			#newChar = 1
 			li $t3, 0			#numChars = 0 keeps track of the characters in each row
 			mul $t5, $t0, 2
 			subi $t6, $t5, 1
 			number:	
 			bge  $t3, $t6, numExit	#for(numChars=0; numChars<(currentRow*2)-1)
 			bne $t2, 1, printTabs	#check if the character is new to the line;
 			li $v0, 1
 			move $a0, $t4		#print currentNumber stored in $t4
 			syscall
 			li $t2, 0
 			addi $t4, $t4, 1		#increment currentNumber $t4
 			j exitloop
 				
 				printTabs: 	
 				bnez $t2, exitloop	#if isnewChars?? is 0; then print 'tab' + '*' + 'tab'
 				li $v0, 4
 				la $a0, txt		
 				syscall
 				li $t2, 1
 				exitloop:
 			
 			addi $t3, $t3, 1		#increment number of characters per line
 				
 			j number
 			numExit:
 		li $v0, 4
 		la $a0, newline			
 		syscall
 		j Outer				#loops again
		OuterExit:

	li $v0, 10		#exit: 
	syscall 			#-- program is finished running --

.data	#for all my data
prompt: .asciiz "Enter the height of the triangle (must be greater than 0):"
message: .asciiz "Invalid Entry!\n"
newline: .asciiz "\n" 
txt: .asciiz "\t*\t"

#pseudo code
# handwritten pseudo code
#  int userIn = syscall 5 stored in $s0;
#  int currentRow = 1; //currentRow
#//outed loop
#  for(int currentRow = 1; currentRow<=userIn; currentRow++) {
# 
#        //inner loop
#        for(int # of tabs = 0; # of tabs < (userIn-currentRow); # of tabs ++){
#          print(tab);
#        }

#        //print stars & #'s
        
#     	int isnewChar = 1;
#        int numChars = 0;
#        while(numChars<(currentRow*2-1)){
#            
#		if(isnewChar==1) {
#                print(currentNumber);
#                isnewChar=0; //set back to 0 
#                currentNumber++;
#            else 
#		if(isnewChar==0){ //check
#                print(T*T);
#                //printf("%s","\t")
#                //printf("%s","*","\t")
#                //prinrf("%s","\t")]
#                isnewChar=1;
#            }
#          increment numChars;
#        }
#
#      
#      //newline here
#	li $v0, 4
#	la $a0, newline			
#	syscall
#    }
# My Output:
#Enter the height of the triangle (must be greater than 0):0
#Invalid Entry!
#Enter the height of the triangle (must be greater than 0):-1
#Invalid Entry!
#Enter the height of the triangle (must be greater than 0):5
#				1
#			2	*	3
#		4	*	5	*	6
#	7	*	8	*	9	*	10
#11	*	12	*	13	*	14	*	15
#
#-- program is finished running --
#####################################################################
