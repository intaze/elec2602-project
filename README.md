# ELEC2602 - Digital Logic Design - Final Project

## Project Description

### Essential

The task is to implement a processor that can execute the following instructions:

LDI Rx D; (Rx = D)
MOV Rx Ry; (Rx = Ry)
ADD Rx Ry; (Rx = Rx + Ry)
SUB Rx Ry; (Rx = Rx - Ry)

Other details:

- The processor inlcudes 3 16-bit registers
- All the instructions can be passed to the processor using a testbench
- Currently works in simulation
- The number of bits used to encode the instructions\n
00 -> Load (LDI)\n
01 -> Move\n
10 -> Add\n
11 -> Sub\n



