
Alex Davila
hdavilac
Winter 2020
Lab 5: Functions and Graphics

----------------------------------------------------------------------------------
FILES:
	- Lab5.asm
	- README.txt
----------------------------------------------------------------------------------
Description: 

- In this lab, I implemented functions that perform some primitive graphics
  operations on a small simulated display. These functions clear the entire
  display to a color, display a colored line, display an unfilled colored triangle
  and display a filled colored rectangle using a memory-mapped bitmap graphics
  display in MARS. To do this I utilized:
 	
	• Arrays
	• Memory-mapped Input/Output (IO)
	• Subroutines (a.k.a. Functions or Procedures)
	• Macros
	• The MIPS Stack (for arguments and subroutine call state)

----------------------------------------------------------------------------------
Functionality:

 1. All pixels should be in the range x in [0,128) and y in [0,128)
    (the parenthesis means not including 128). 
 2. Pixels start from (0,0) in the upper left to (127,127) in the lower right.
 3. Pixel values are referenced in a single word using the upper and lower half of
    the word. So, for example, 0x00XX00YY) where XX and YY can be 0x00 to 0x7F. 
 4. All colors should be RGB using a single 32-bit word where the top byte is zero.
    So, for example, 0x00RRGGBB where RR, GG, and BB can be 0x00 to 0xFF.
 5. Clear the entire bitmap display to a color c.
 6. Draw a line from x1,y1 to x2,y2 of a given color c.
 7. Draw a triangle among x1,y1, x2,y2 and x3,y3 of a given color c.
 8. Draw a rectangle filled with color c from ulx,uly to lrx,lry where ul is the
    “upper left” corner and lr is the “lower right” corner.



----------------------------------------------------------------------------------- 
-----------------------------------------------------------------------------------

