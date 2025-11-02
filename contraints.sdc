
# --------------------------------------------------------------
# 1. Create main clock (100 MHz => 10 ns period)
# --------------------------------------------------------------
create_clock -name clk -period 10 [get_ports clk]

# --------------------------------------------------------------
# 2. Set input and output delays relative to clock
# --------------------------------------------------------------
# Input delay of 1 ns from clock edge
set_input_delay 1 -clock [get_clocks clk] [get_ports {rst_n wr_en wr_data[*] rd_en}]

# Output delay of 2 ns from clock edge
set_output_delay 2 -clock [get_clocks clk] [get_ports {rd_data[*] full empty overflow underflow parity_error}]

# --------------------------------------------------------------
# 3. Exclude asynchronous reset from timing paths
# --------------------------------------------------------------
set_false_path -from [get_ports rst_n]

# --------------------------------------------------------------
# 4. Prevent optimization of FIFO memory cells (optional)
# --------------------------------------------------------------
# This ensures internal memory array isn't flattened during synthesis.
if {[llength [get_cells fifo_mem* -quiet]] > 0} {
    set_dont_touch [get_cells fifo_mem*]
}

# --------------------------------------------------------------
# 5. Set operating conditions for analysis
# --------------------------------------------------------------
# Enable on-chip variation for accurate timing
if {[llength [get_operating_conditions -quiet]] > 0} {
    set_operating_conditions -analysis_type on_chip_variation
}

# --------------------------------------------------------------
# 6. Design rule assumptions (optional safety margins)
# --------------------------------------------------------------
# These are typical IO transition & load values for 90 nm designs.
set_input_transition 0.2 [all_inputs]
set_load 0.05 [all_outputs]

# --------------------------------------------------------------
# 7. Reporting checks (optional)
# --------------------------------------------------------------
report_clocks
report_ports
report_timing -max_paths 10

# ==============================================================
# END OF FILE
# ==============================================================
