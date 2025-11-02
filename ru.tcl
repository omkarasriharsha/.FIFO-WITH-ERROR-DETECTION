
# --------------------------------------------------------------
# 1. Setup: Define library and working directories
# --------------------------------------------------------------
# Standard cell library search paths
set_db init_lib_search_path {/home/iiitdmk/Gaya/ /home/install/FOUNDRY/digital/90nm/dig/lib/}

# Specify your standard cell library
set_db library slow.lib

# --------------------------------------------------------------
# 2. Read and elaborate the RTL design
# --------------------------------------------------------------
# Read the Verilog HDL file
read_hdl {/home/iiitdmk/Gaya/fifo_with_error_detection.v}

# Elaborate the top-level design
elaborate fifo_with_error_detection

# --------------------------------------------------------------
# 3. Apply design constraints
# --------------------------------------------------------------
# Read the constraints file (SDC)
read_sdc /home/iiitdmk/Gaya/constraints_input.sdc

# --------------------------------------------------------------
# 4. Set synthesis effort and options
# --------------------------------------------------------------
set_db syn_generic_effort medium
set_db syn_map_effort     medium
set_db syn_opt_effort     medium

# Enable power optimization
set_db opt_power_effort medium

# --------------------------------------------------------------
# 5. Run synthesis steps
# --------------------------------------------------------------
syn_generic      ;# Convert RTL to generic gates
syn_map          ;# Map to standard cell library
syn_opt          ;# Perform final optimization (timing/area/power)

# --------------------------------------------------------------
# 6. Generate reports
# --------------------------------------------------------------
report timing  > /home/iiitdmk/Gaya/fifo_timing.rpt
report area    > /home/iiitdmk/Gaya/fifo_area.rpt
report power   > /home/iiitdmk/Gaya/fifo_power.rpt
report gates   > /home/iiitdmk/Gaya/fifo_gates.rpt
report clock   > /home/iiitdmk/Gaya/fifo_clock.rpt

# --------------------------------------------------------------
# 7. Write synthesized outputs
# --------------------------------------------------------------
write_hdl > /home/iiitdmk/Gaya/fifo_netlist.v
write_sdc > /home/iiitdmk/Gaya/fifo_output_constraints.sdc

# --------------------------------------------------------------
# 8. Optional: Open GUI for schematic and reports visualization
# --------------------------------------------------------------
gui_show

# ==============================================================
# End of File
# ==============================================================
