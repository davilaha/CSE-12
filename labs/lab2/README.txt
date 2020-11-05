Alex Davila
hdavilac

Lab 2: Simple Data Path

------------------------
FILES 
 - Lab2.lgi
 - README.dm

-----------------------
DESCRIPTION

- In this lab I created a sequential logic circuit and introduced data paths.
- A data path is a path by which data flows in a system. 
- I implemented a simple data path with a register file, ALU, and user inputs.

- Each processor contains a register file that holds the registers used in program
  execution. Registers are fast access local variale that can change after every
  instruction.

- I built a register file that contains four, 4-bit registers. Each od the four
  registers has an address (0b00 -> 0b11) and stores a 4-bit value.
- The value saved to a destination register (write register) will come from 
  one of two sources, the keypad user input, or the output of the ALU.
- The ALU in this system is a 4-bit bitwise left rotation (left circular shift)
  circuit that takes two of the register values as inputs (read registers).
- The ALU was built out of MUXES and/or Logic Gates.

- From the user interface, the user will select the data source (source select)
  and the address of the read and write registers.  



---------------------- 
INSTRUCTIONS
