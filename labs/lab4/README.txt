Alex Davila
hdavilac

Lab 4 Syntax Checker

----------------------------------------------------------------------------------
FILES:
	- Lab4.asm
	- README.txt
	- test1.txt
	- test2.txt
	- test3.txt

----------------------------------------------------------------------------------
Description: 

- I developed a simple syntax checker that opens a file and
  determines whether it has balanced braces, brackets, and parentheses.
  
  This type of syntax checking is often used in programs to determine the
  point of a “syntax error” that the programmer needs to fix. I used MIPS
  and the stack to check the balance and report either the location of a 
  mismatch or the number of matched items on success.
 
 I utilized MIPS ISA using MARS.
----------------------------------------------------------------------------------
Functionality:

 	This program uses the MIPS32 language using the MARS integrated 
	development environment to check the balance of braces {}, brackets
	[], parentheses (). 

        On an error, I report a 32-bit integer byte offset (starting 
        from 0) and which brace, bracket or parenthesis is unmatched. 

	On success, I print the number of matched braces, brackets and parentheses. 

	I use program arguments instead of a syscall to take user inputs. 
	The program argument specifies a file that is to be read through and checked 
	for syntax errors. The file contains printable ASCII characters only. 

	
High-Level:

	In this lab I open a file, read, and perform a parens matching operations 
	for a simple syntax program. When printing the integer values, I use syscall 1 	
	(print integer). When opening and reading a file, I used syscall 13 (open file), 
	14 (read file) and 16 (close file). For syscall 13 I set the mode register 
	to a value of 0 ($a2=0, the mode register is ignored in MIPS).  For the flag 
	register ($a1), I used 0 for reading only. I closed the file when I was done using
	syscall 16. I made sure to exit the program cleanly using syscall 10.

-----------------------------------------------------------------------------------
File Content:

test1.txt	[a[b[c[d]c]b}a]

test2.txt	[a[a]a]a]

test3.txt	((({{[(here)
-----------------------------------------------------------------------------------
