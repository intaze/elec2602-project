# ELEC2602 Final Project: Processor Extension Roadmap

This document outlines the step-by-step plan to upgrade the essential processor to a fully self-contained architecture, implementing conditional branches, jumps, memory operations, and additional arithmetic instructions.

## Phase 1: The Architectural Overhaul (Fetch Cycle)
Currently, the testbench forces instructions directly into the processor. To match the hardware diagram and deploy to an FPGA, the processor must fetch its own instructions.

1. **Add a Program Counter (PC):** Create a new register (`my_pc.v`) to hold the current instruction address. It must increment by 1 each cycle, but also accept a new value from the bus during a Jump or Branch.
2. **Implement Instruction Memory (ROM):** Create a module that takes the PC as an address and outputs the 16-bit instruction data. In simulation/synthesis, initialize this memory using `$readmemb` or `$readmemh` to load your assembled machine code.
3. **Instruction Registers (IR):** Add the IR blocks to hold the fetched instruction so the FSM can decode it over multiple clock cycles.
4. **Update `top.v`:** Remove `instruction` and `data_in` from the module inputs. Your processor should now be self-contained, taking only `clk` and `rst` as external inputs.

## Phase 2: Expanding the ALU
The current ALU uses a 1-bit `addsub` control signal. To support 5 arithmetic instructions, this control signal needs to be expanded into a 3-bit `alu_op`.

* **`000`:** ADD (`a_in + bus`)
* **`001`:** SUB (`a_in - bus`)
* **`010`:** 2s Complement (`~bus + 1` or `-bus`)
* **`011`:** MUL (`a_in * bus`)
* **`100`:** DIV (`a_in / bus`)

*Note for FPGA Synthesis:* Synthesis tools map `*` to built-in DSP multipliers easily. However, division (`/`) can be highly resource-intensive or may require a custom shift-add divider IP depending on your toolchain constraints.

## Phase 3: Status Register & Branching
To implement conditional branches, the FSM needs to evaluate the result of the last ALU operation.

1. **Add a Status Register:** Connect a 2-bit register to evaluate the ALU output.
   * **Zero Flag (Z):** Set if `alu_result == 0`.
   * **Negative Flag (N):** Set if `alu_result[15] == 1` (MSB is 1).
2. **Jump/Branch Logic in FSM:** * **Unconditional Jump:** The FSM ignores the status register, takes the target address from the instruction payload, and overwrites the PC.
   * **Conditional Branch:** The FSM checks the target flag (Z or N) in the Status Register. If true, overwrite the PC. If false, increment the PC normally.

## Phase 4: Data Memory (RAM) for Load/Store
To implement `LD` (Load) and `ST` (Store), the Data Memory block must be added.

1. **Create a RAM Module:** Similar to the Instruction Memory, but writable. It requires an `Address` input, a `Data In` input, a `Data Out` output, and a `Write Enable` signal controlled by the FSM.
2. **Connecting to the Bus:** * **Load (`LD`):** Address comes from a register via the bus. RAM `Data Out` is driven onto the bus (via a tri-state buffer) and latched into a destination register.
   * **Store (`ST`):** Address comes from a register, and the data to be stored is routed from another register.

## Phase 5: FSM Overhaul
The current FSM is a 3-phase sequencer hardcoded for the ADD/SUB flow. It must be rewritten as a classic multi-cycle CPU state machine:

* **State 0 (Fetch):** `PC` -> Instruction Memory -> `IR`. Increment `PC`.
* **State 1 (Decode):** Decode the opcode and source/destination registers from the `IR`.
* **State 2+ (Execute):** Perform the specific instruction behavior (ALU operation, Memory access, or Branching) over 1 or more cycles depending on bus availability.# ELEC2602 Final Project: Processor Extension Roadmap

This document outlines the step-by-step plan to upgrade the essential processor to a fully self-contained architecture, implementing conditional branches, jumps, memory operations, and additional arithmetic instructions.

## Phase 1: The Architectural Overhaul (Fetch Cycle)
Currently, the testbench forces instructions directly into the processor. To match the hardware diagram and deploy to an FPGA, the processor must fetch its own instructions.

1. **Add a Program Counter (PC):** Create a new register (`my_pc.v`) to hold the current instruction address. It must increment by 1 each cycle, but also accept a new value from the bus during a Jump or Branch.
2. **Implement Instruction Memory (ROM):** Create a module that takes the PC as an address and outputs the 16-bit instruction data. In simulation/synthesis, initialize this memory using `$readmemb` or `$readmemh` to load your assembled machine code.
3. **Instruction Registers (IR):** Add the IR blocks to hold the fetched instruction so the FSM can decode it over multiple clock cycles.
4. **Update `top.v`:** Remove `instruction` and `data_in` from the module inputs. Your processor should now be self-contained, taking only `clk` and `rst` as external inputs.

## Phase 2: Expanding the ALU
The current ALU uses a 1-bit `addsub` control signal. To support 5 arithmetic instructions, this control signal needs to be expanded into a 3-bit `alu_op`.

* **`000`:** ADD (`a_in + bus`)
* **`001`:** SUB (`a_in - bus`)
* **`010`:** 2s Complement (`~bus + 1` or `-bus`)
* **`011`:** MUL (`a_in * bus`)
* **`100`:** DIV (`a_in / bus`)

*Note for FPGA Synthesis:* Synthesis tools map `*` to built-in DSP multipliers easily. However, division (`/`) can be highly resource-intensive or may require a custom shift-add divider IP depending on your toolchain constraints.

## Phase 3: Status Register & Branching
To implement conditional branches, the FSM needs to evaluate the result of the last ALU operation.

1. **Add a Status Register:** Connect a 2-bit register to evaluate the ALU output.
   * **Zero Flag (Z):** Set if `alu_result == 0`.
   * **Negative Flag (N):** Set if `alu_result[15] == 1` (MSB is 1).
2. **Jump/Branch Logic in FSM:** * **Unconditional Jump:** The FSM ignores the status register, takes the target address from the instruction payload, and overwrites the PC.
   * **Conditional Branch:** The FSM checks the target flag (Z or N) in the Status Register. If true, overwrite the PC. If false, increment the PC normally.

## Phase 4: Data Memory (RAM) for Load/Store
To implement `LD` (Load) and `ST` (Store), the Data Memory block must be added.

1. **Create a RAM Module:** Similar to the Instruction Memory, but writable. It requires an `Address` input, a `Data In` input, a `Data Out` output, and a `Write Enable` signal controlled by the FSM.
2. **Connecting to the Bus:** * **Load (`LD`):** Address comes from a register via the bus. RAM `Data Out` is driven onto the bus (via a tri-state buffer) and latched into a destination register.
   * **Store (`ST`):** Address comes from a register, and the data to be stored is routed from another register.

## Phase 5: FSM Overhaul
The current FSM is a 3-phase sequencer hardcoded for the ADD/SUB flow. It must be rewritten as a classic multi-cycle CPU state machine:

* **State 0 (Fetch):** `PC` -> Instruction Memory -> `IR`. Increment `PC`.
* **State 1 (Decode):** Decode the opcode and source/destination registers from the `IR`.
* **State 2+ (Execute):** Perform the specific instruction behavior (ALU operation, Memory access, or Branching) over 1 or more cycles depending on bus availability.