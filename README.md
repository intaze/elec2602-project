# ELEC2602 - Digital Logic Design - Final Project

## Project Description

### Essential

Your task is to implement a processor that can execute the following instructions:

- LDI Rx D; (Rx = D, D is a constant)
- MOV Rx Ry; (Rx = Ry)
- ADD Rx Ry; (Rx = Rx + Ry)
- SUB Rx Ry; (Rx = Rx - Ry)

Other details:
- The initial processor must use at least 3 16-bit registers
- All the instructions can be passed to the processor using a testbench
- You only need to show  this working in simulation
- The number of bits used to encode the instructions:
    - 00000 -> Load (LDI)
    - 00001 -> Move
    - 00010 -> Add
    - 00011 -> Sub
    - 00100 -> 2s complement
    - 00101 -> Multiplication
    - 00110 -> Division 



