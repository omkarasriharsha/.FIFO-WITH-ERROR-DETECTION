# .FIFO-WITH-ERROR-DETECTION
Design and Verification of FIFO Buffer with Error Detection using Verilog HDL. In this project, a FIFO is designed with built-in error detection logic. The design demonstrates a full RTL-to-GDSII implementation using the Cadence tool suite.
# FIFO with Error Detection — RTL to GDSII VLSI Design

##  Project Overview
This project implements a **FIFO (First-In-First-Out)** memory with built-in **parity error detection** using **Verilog HDL**.  
The design detects single-bit errors during data transmission or storage and follows a complete **VLSI design flow** —  
from **RTL design and simulation** to **logic synthesis, physical design, and GDSII generation** using **Cadence Genus** and **Cadence Innovus** (90 nm library).

---

## Features
 Parameterized **data width** and **depth**  
**Parity-based error detection**  
 Handles **overflow** and **underflow** conditions  
Synthesizable and technology-mapped (90 nm library)  
 **Complete RTL → GDSII** industrial-grade flow  

##  RTL Design Summary
The FIFO module stores and retrieves data sequentially while maintaining data integrity through parity checking.  
Parity is computed on each write and verified upon readback. A mismatch triggers the **parity_error** signal.

| Signal | Direction | Description |
|--------|------------|--------------|
| `clk` | Input | System clock (100 MHz) |
| `rst_n` | Input | Active-low synchronous reset |
| `wr_en` | Input | Write enable |
| `wr_data` | Input | Input data bus |
| `rd_en` | Input | Read enable |
| `rd_data` | Output | Output data bus |
| `full` / `empty` | Output | FIFO status indicators |
| `overflow` / `underflow` | Output | Access violation indicators |
| `parity_error` | Output | Error detection flag |

Physical Design — Cadence Innovus

Steps Performed:
Import synthesized netlist and constraints (.sdc)
Perform floorplanning and IO placement
Generate power rails (VDD/VSS)
Placement, Clock Tree Synthesis (CTS), and Routing
DRC/LVS verification
Export GDSII for fabrication

Post-layout results:
Layout: 3D Metal View:

| Tool                    | Purpose                 |
| ----------------------- | ----------------------- |
| **Cadence Genus**       | Logic Synthesis         |
| **Cadence Innovus**     | Physical Design & GDSII |
| **GTKWave**             | Waveform Analysis       |
| **Vivado (Optional)**   | Functional Verification |
[fifo-design-doc.pdf](https://github.com/user-attachments/files/23305795/fifo-design-doc.pdf)





