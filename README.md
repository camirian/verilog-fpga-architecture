# Verilog FPGA Architecture

**Digital Logic & ASIC Hardware Design**

> A project demonstrating proficiency in Register-Transfer Level (RTL) hardware design using Verilog, specifically focusing on low-level Cyber-Physical interfaces like Serial Peripheral Interface (SPI) protocols for ASIC integration.

---

## 🎯 Core Technical Competencies

| Claim ID   | Capability                           | Deliverable                                                                   |
| :--------- | :----------------------------------- | :---------------------------------------------------------------------------- |
| **EDU_CSULA_04** | Digital Logic & FPGA Architecture | A Verilog/VHDL architecture linking to the ASIC hardware spec capability. |

---

## 🏗️ Technical Architecture

This codebase contains the RTL design and testbenches for a standard SPI Master module, commonly used to interface embedded Jetson/ARM environments with discrete ASIC sensors (like the IMUs modeled in `gyroscope-firmware-mock`).

### Directory Structure

*   **/src/spi_master.v**: The core Verilog RTL implementing the SPI Master state machine (Mode 0: CPOL=0, CPHA=0).
*   **/tb/spi_master_tb.v**: A Verilog testbench validating the shifting logic, clock generation (SCLK), and Chip Select (CS) behavior.

## 🚀 Simulation

These modules can be simulated using standard open-source EDA tools like Icarus Verilog (`iverilog`) and visualized using GTKWave.

```bash
# Compile the design and testbench
iverilog -o spi_sim src/spi_master.v tb/spi_master_tb.v

# Run the simulation -> output.vcd
vvp spi_sim
```
