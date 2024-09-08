# CPU and Hardware Accelerators 

This repository contains CPU and HW accelerators modules synthesized in VHDL + stimuli
as part of a Course Lab performed on an Intel's FPGA chip (Cyclone V).

## Labs

### Lab 1: VHDL Concurrent Code - ALU

**Lab aims:**
- Develop skills in VHDL, focusing on code structure, data types, operators and attributes, concurrent code, design hierarchy, packages, and components.
- Gain basic skills in ModelSim, a multi-language HDL simulation environment.
- Refresh general knowledge in digital systems and architecture design.

**Tasks:**
1. **System Design ISA**: Implement various arithmetic, shift, and boolean operations based on a predefined instruction set.
2. **Status Bits**: Implement status bits for overflow, zero, carry, and negative conditions.
3. **System Design Micro-Architecture**: Design a module containing an adder/subtractor, shifter, and boolean logic, ensuring it is tested for different `n` values (4, 8, 16, 32).
4. **Generic Adder/Subtractor Module**: Create a generic adder/subtractor using a ripple carry adder.
5. **Shifter Module**: Design a shifter module based on a barrel-shifter without using forbidden operators.
6. **Test and Timing**: Develop a test bench for the system and analyze timing and outputs.

### Lab 2: VHDL Sequential Code - Behavioral Modeling

**Lab aims**
- Develop skills in VHDL part 2, focusing on sequential code and behavioral modeling.
- Enhance knowledge in digital systems design.
- Properly analyze and understand architecture design.

**Tasks**

1. **Design the System**:
    Implement a synchronous digital system to detect valid sub-series.
    Ensure the system uses the given VHDL files and adheres to the structural constraints.
2. **Test and Timing**:
        Develop a test bench to validate the system.
        Analyze timing and outputs using the provided timing diagrams.
        
### Lab 3: Digital System Design - Multi-Cycle CPU

**Lab aims:**
- Design and implement a multi-cycle CPU using VHDL.
- Apply principles of concurrent and sequential logic in system design.
- Understand and implement controller-based design and functional validation.
- Prepare for FPGA-based synthesis and analysis.

**Tasks**

1. **Design the CPU**:
    Create a multi-cycle CPU architecture that includes a controller and datapath components.
    Utilize the given VHDL files and follow the provided ISA and design specifications.
    Ensure the CPU is capable of executing a provided program code and adheres to the multi-cycle design principles.
2. **Test and Timing**:
        Develop a test bench to validate the system.
        Analyze timing and outputs using the provided timing diagrams.

### Lab 4: FPGA, Quartus & Memory - FPGA

**Lab Aims:**
- Understand and implement digital system synthesis on FPGA.
- Analyze performance, area, and functionality of FPGA designs.
- Use Quartus II for synthesis and timing analysis.
- Validate the design on a physical FPGA board.

**Tasks**

### 1. Design and Synthesize the System
- Synthesize a synchronous digital system based on Lab 1's ALU design for the Cyclone V FPGA.
- Ensure your design includes registers to confine logic paths for performance analysis.

### 2. Performance Test Case
- **ModelSim Simulation**: Perform thorough simulation with maximal coverage to validate the design.
- **Quartus Compilation**: Compile the design without pin assignments, then load the design to check synthesis performance.
- **Timing Analysis**:
  - Determine the maximum operating clock frequency (`f_max`).
  - Set the clock constraint to the maximum value and analyze logic usage based on the compilation report.
  - Identify and analyze the critical path, showing the longest and shortest paths and explaining the frequency-limiting operations.
- **Report**: Include RTL Viewer results, logic usage reports, critical path analysis, and optimizations done for FPGA.

### 3. Hardware Test Case
- Test the ALU digital system on the DE10-Standard FPGA board.
- Use the board’s switches, pushbuttons, LEDs, and 7-segment displays for input and output interfaces.
- Connect the system to the FPGA board as per the provided diagram, ensuring proper I/O interface integration.

### Lab 5: Pipelined MIPS Architecture - TBA

## Final Project - Single-Cycle Mips CPU

**Aim of the Project:**
- Design, synthesis, and analysis of a single-cycle MIPS CPU core with memory-mapped I/O, interrupt capability, and (optionally) a serial communication peripheral.
- Understand CPU vs. MCU concepts and FPGA memory structure.

**Assignment Definition:**
- The architecture must include a MIPS ISA-compatible CPU with data memory (DTCM) and program memory (ITCM).
- The top-level design and MIPS core must be structural. The design should be compiled and tested on the Altera board using a single clock (CLK).
- Use push-button KEY0 as a system reset.

**I/O Devices Connected:**
- **Input Interface**: Board ten switches (SW9-SW0) and four pushbuttons (KEY3-KEY0).
- **Output Interface**: Board 10 red LEDs (LEDR9-LEDR0) and six 7-segment displays (HEX5-HEX0).

**Required Support of CPU Peripherals:**
1. Seven GPIO ports (six Output and one Input).
2. Three pushbuttons (KEY [3-1]) as input devices.
3. Basic Timer with output compare capability.
4. Unsigned Binary Division Multicycle Accelerator.
5. **Bonus**: USART Peripheral Interface in UART Mode.
6. Interrupt controller for handling various interrupts.

**Pin Planner:**
- Connect MCU I/O devices to FPGA location legs via the pin planner.

**Host Interface (to ITCM and DTCM):**
- Use a JTAG-based code wrapper for communication to memory caches.

**Compiler, Simulator, and Memory:**
- Use MARS or another compiler to compile and simulate assembly code. MARS can also export memory contents in a format readable by VHDL.

**CPU and MCU Test:**
- Support all given test assembly source files.
- Optionally, use serial communication support and write code for a menu transmitted from MCU to PC.

