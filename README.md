# Reconfigurable Computing: VHDL Digital Systems on FPGA

Three assignments from Reconfigurable Computing (ELEC8600-1-R-2026W), University of Windsor, Winter 2026, covering VHDL design, simulation, and synthesis, progressing from basic combinational and sequential building blocks through a full RTL-to-synthesis-to-timing-closure flow on a real Intel FPGA.

Team project: co-authored with **Kamran Shahid** across all three assignments. All designs, simulation, and synthesis work were done jointly.

## Assignment 1: Combinational and Sequential Building Blocks

Four parts, each targeting a specific digital design pattern:

- **Part I**, `magnitude_comparator_12bit.vhd`: a 12-bit combinational magnitude comparator (greater-than, equal-to, less-than outputs).
- **Part II**, `counter_4bit.vhd`: a 4-bit synchronous up-counter with asynchronous clear, synchronous load, and count-enable, plus a carry-out flag.
- **Part III**, `counter_12bit_structural.vhd`: a 12-bit counter built **structurally** by cascading three of the 4-bit counters above with ripple-style enable chaining (`EN_1 = E and CO_0`, `EN_2 = E and CO_0 and CO_1`), combined with the magnitude comparator to detect a specific terminal count (3541) and trigger a synchronous reload.
- **Part IV**, `counter_12bit_behavioral.vhd`: the same 12-bit counter and terminal-count behavior, implemented **behaviorally** as a single direct 12-bit process, for direct comparison against the structural version.

## Assignment 2: Shift Register, Sequential Divider, and Synthesis Scaling

- **Part I**, `shift_register_8bit.vhd`: an 8-bit universal (bidirectional) shift register with parallel load, count-enable, direction control, and serial-in/serial-out on both ends.
- **Part II**, `divider.vhd`: a generic n-bit sequential restoring binary divider, implemented as a 4-state FSM (S1-S4) following a shift-subtract algorithm, matching the report's own ASM chart. Synthesized and timed at four bit-widths (8/16/24/32) to study area and frequency scaling; the report notes a real anomaly, 32-bit synthesis showed a *higher* Fmax than 24-bit in the tool's report despite 32-bit being expected to run slower in practice, an honest observation rather than a smoothed-over result.

## Assignment 3: Byte Processor (Full RTL-to-Synthesis Flow)

`byte_processor.vhd`: a 4-state FSM (S1-S4) that reads 8 bytes into an internal memory, computes all 7 consecutive byte differences, streams them to an output port, and pulses `done` for exactly one clock cycle. Modeled from an ASM chart, implemented in VHDL, simulated in Questa, and synthesized in Intel Quartus Prime to a real target device.

**Synthesis results** (Intel Max 10 FPGA): 192 estimated logic elements, 83 registers, 20 I/O pins, and a maximum operating frequency of 189.83 MHz (Slow 1200mV 85C model), well above the 50 MHz testbench clock.

## Independent Verification

ModelSim/Questa and Intel Quartus Prime are proprietary tools not available in the environment used to prepare this repository. Every design was instead independently compiled and simulated using **GHDL**, an open-source VHDL compiler and simulator, to confirm correctness directly rather than relying on the original screenshots alone.

| Design | Verification | Result |
|---|---|---|
| byte_processor | Compiled and ran the original testbench | Bit-exact match: dataout sequence 0x15, 0x49, 0x0E, 0x14, 0x01, 0x0D, 0x4E; done pulses for exactly 1 cycle, as reported |
| divider | Compiled and ran 6 independent test vectors (not from the original testbench), including A=0, A=B, A<B, and A at max value | All 6 exact matches against Python-computed expected quotient/remainder |
| shift_register_8bit | Compiled and tested load, left-shift-with-fill, right-shift-with-fill | Bit-exact match against hand-calculated expected patterns in both directions |
| counter_12bit (structural, Part III) | Compiled and ran to the rollover point | Counts cleanly to the terminal count (3541), rolls over to 0 exactly on schedule |
| counter_12bit (behavioral, Part IV) | Same test against the alternate architecture | Identical rollover behavior, confirming the structural and behavioral designs are functionally equivalent |
| magnitude_comparator_12bit, counter_4bit | Compiled cleanly; exercised as components inside the counter_12bit tests above | Correct |

See `verification/README.md` for details on which testbenches are original coursework submissions versus independently authored for this verification pass.

## Files

- `assignment1-combinational-sequential/`: the four Assignment 1 modules
- `assignment2-shift-register-divider/`: the shift register and divider
- `assignment3-byte-processor-fsm/`: the byte processor and its original testbench
- `verification/`: independently authored testbenches used to verify this repository's designs with GHDL (not part of the original coursework)
- Original submitted PDF reports for all three assignments, including ASM charts, ModelSim/Questa waveforms, and Quartus Prime synthesis screenshots. Hosted on my site rather than in this repo, GitHub's file upload doesn't handle PDFs reliably: [Assignment 1](https://lawazislam.com/assets/downloads/reconfigurable-computing-vhdl-fpga/assignment1-report.pdf), [Assignment 2](https://lawazislam.com/assets/downloads/reconfigurable-computing-vhdl-fpga/assignment2-report.pdf), [Assignment 3](https://lawazislam.com/assets/downloads/reconfigurable-computing-vhdl-fpga/assignment3-report.pdf)

## Skills demonstrated

VHDL RTL design, finite state machines, structural and behavioral design methodologies, sequential arithmetic algorithms (restoring division), FPGA synthesis and timing closure, Intel Quartus Prime, ModelSim/Questa simulation, parameterized (generic) hardware design.
