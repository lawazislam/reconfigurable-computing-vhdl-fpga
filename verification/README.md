# Independent Verification Testbenches

The files in this folder were **not part of the original coursework submission**. They were written independently to verify the designs in this repository using GHDL (an open-source VHDL compiler and simulator), since ModelSim/Questa and Intel Quartus Prime (used for the original coursework) are proprietary tools not available in this verification environment.

- `tb_divider_verification.vhd`: 6 independent test vectors for the Assignment 2 divider, including edge cases (A=0, A=B, A<B, A at max value). All 6 matched Python-computed expected quotient/remainder pairs exactly.
- `tb_shift_register_verification.vhd`: tests load, left-shift-with-fill, and right-shift-with-fill on the Assignment 2 shift register. Output matched hand-calculated expected bit patterns exactly.
- `tb_counter_12bit_verification.vhd`: run against both the structural (Assignment 1, Part III) and behavioral (Part IV) counter_12bit implementations. Both roll over at exactly the specified terminal count (3541), confirming the two design methodologies are functionally equivalent.
- `tb_byte_processor_instrumented.vhd`: the original Assignment 3 testbench (see `../assignment3-byte-processor-fsm/tb_byte_processor.vhd`) with an added monitor process that prints `dataout` and `done` every clock cycle, used to confirm the exact reported output sequence.

See the main README's Verification section for full results.
