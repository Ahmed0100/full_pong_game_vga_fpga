## Generated SDC file "dot_trace.out.sdc"

## Copyright (C) 2022  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and any partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details, at
## https://fpgasoftware.intel.com/eula.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 21.1.1 Build 850 06/23/2022 SJ Lite Edition"

## DATE    "Sat Dec 10 11:12:03 2022"

##
## DEVICE  "EP4CE10E22C8"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {clk} -period 20.000 -waveform { 0.000 10.000 } [get_ports {clk}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {pcount} -source [get_ports {clk}] -divide_by 2 -master_clock {clk} [get_registers {*pcount}] 


#**************************************************************
# Set Clock Latency
#**************************************************************

#**************************************************************
# Set Clock Uncertainty
#**************************************************************


#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay  -clock [get_clocks {clk}]  4.000 [get_ports {btn[0]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  4.000 [get_ports {btn[1]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  4.000 [get_ports {reset_n}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay  -clock [get_clocks {pcount}]  0.0000 [get_ports {vga_hsync}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.0000 [get_ports {vga_rgb[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.00000 [get_ports {vga_rgb[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  0.001000 [get_ports {vga_rgb[2]}]
set_output_delay -add_delay  -clock [get_clocks {pcount}]  0.00000 [get_ports {vga_vsync}]


#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************


#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

