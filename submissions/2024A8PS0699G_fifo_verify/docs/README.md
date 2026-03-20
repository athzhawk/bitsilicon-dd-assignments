# Synchronous FIFO Verification Environment

## Overview
This project implements a parameterized Synchronous First-In-First-Out (FIFO) memory module in Verilog, along with a fully automated, self-checking testbench. The testbench is designed to verify the functional correctness of the hardware using a Golden Reference Model and an automated Scoreboard, eliminating the need for manual waveform inspection.

## Project Structure
* `sync_fifo.v` - The core Synchronous FIFO hardware logic (pointers, memory array, and flag generation).
* `sync_fifo_top.v` - The top-level wrapper for the DUT (Design Under Test).
* `tb_sync_fifo.v` - The self-checking testbench environment.

## Testbench Architecture
The testbench is built using standard Verilog and consists of four main components:
1.  **Stimulus Generator:** Applies specific, deterministic inputs on the negative edge of the clock to prevent race conditions.
2.  **Golden Reference Model:** A cycle-accurate behavioral model of the FIFO that runs in parallel with the DUT. It maintains its own independent memory, pointers, and state.
3.  **Automated Scoreboard:** Evaluates the DUT against the Golden Model on every clock cycle. It checks the occupancy count, empty/full flags, and read data. If a mismatch occurs, it halts the simulation and prints a detailed debug report.
4.  **Coverage Counters:** Tracks the occurrence of specific edge cases (e.g., wrap-around, simultaneous read/write, overflow attempts) to ensure 100% test coverage.

## Verification Plan (Directed Tests)
The testbench automatically executes the following test sequence:
1.  **Reset Test:** Verifies that pointers and count initialize to `0`, `rd_empty` is `1`, and `wr_full` is `0`.
2.  **Single Write / Read Test:** Verifies basic functionality and count increments/decrements.
3.  **Fill Test:** Writes continuously until the FIFO is full (`count == DEPTH`) and checks the `wr_full` flag.
4.  **Overflow Attempt Test:** Attempts to write to a full FIFO and verifies that the state does not corrupt.
5.  **Drain Test:** Reads continuously from a full FIFO until it is empty and checks the `rd_empty` flag.
6.  **Underflow Attempt Test:** Attempts to read from an empty FIFO and verifies that the state does not change.
7.  **Simultaneous Read/Write Test:** Asserts `wr_en` and `rd_en` on the same cycle to verify that pointers increment while the occupancy count remains unchanged.
8.  **Pointer Wrap-Around Test:** Performs continuous read/writes to force the internal pointers to roll over `DEPTH-1` back to `0`.

## How to Run the Simulation
This testbench is designed to be run in standard HDL simulators like ModelSim or QuestaSim.

1. Compile the Verilog files:
2. Type the following in the Transcript:
vsim tb_sync_fifo
run -all
   ```bash
   vlog sync_fifo.v sync_fifo_top.v tb_sync_fifo.v
