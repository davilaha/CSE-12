Alex Davila
hdavilac

Lab 3: ASCII-risks (Asteriks)

------------------------------------------------------------------------
FILES:
	- Lab3.asm
	- README.txt

------------------------------------------------------------------------
Description: 

 • I utilized MIPS ISA using MARS.
 • I wrote a program with several nested loops to print variable
   sized ASCII diamond and a sequence of embedded numbers.
 • In addition, I implemented several different syscalls 
   to incorporate I/O into my program.
------------------------------------------------------------------------
Functionality:

 • This program will print out a triangle with numbers and asteriks.
	
	1. It will prompt the user for the height of the triangle.
	    • It will use the height h to print h rows
	    • If the user enters an invalid input such as a negative 
	      number or 0 (zero), an error message is printed and the
	      user will be prompted again for a valid input.

	2.  When the height of the triangle is determined, at the start
	    of each row, except the last row, I used a number of tabs 
	    as the indent to center the row. I programmed this so that
	    the number of tabs would appropriately align the columns
	    exactly as shown in the sample output.

	3. The program then prints numbers and stars (asterisks) 
	   alternatively with a tab between each number and star.
------------------------------------------------------------------------
Sample Output:

 • User input 0, -1, and then 5

Enter the height of the triangle (must be greater than 0): 0
Invalid entry!
Enter the height of the triangle (must be greater than 0):-1
Invalid entry!
Enter the height of the triangle (must be greater than 0): 5 

				1
			2	*	3
		4	*	5	*	6
	7	*	8	*	9	*	10
11	*	12	*	13	*	14	*	15

–– program is finished running ––
------------------------------------------------------------------------
________________________________________________________________________
|Table: Implemented  Syscalls						|
|_______________________________________________________________________|
| SYSCALL #|	FUNCTION	|	PURPOSE				|
| 1	   |	Print integer	|	Prints an integer in ASCII	|
| 4	   |	Print string	|	Print prompt			|
| 5	   |	Read integer	|	Read user input			|
| 10	   | 	Exit		|	Successfully end the program	|
| 11	   |	Print character	|	Prints an ASCII character	|
|_______________________________________________________________________|


