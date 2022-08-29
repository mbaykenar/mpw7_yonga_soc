# SPDX-FileCopyrightText: 2020 Efabless Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# SPDX-License-Identifier: Apache-2.0

# Base Configurations. Don't Touch
# section begin

set ::env(PDK) $::env(PDK)
set ::env(STD_CELL_LIBRARY) "sky130_fd_sc_hd"

# YOU ARE NOT ALLOWED TO CHANGE ANY VARIABLES DEFINED IN THE FIXED WRAPPER CFGS 
source $::env(DESIGN_DIR)/fixed_dont_change/fixed_wrapper_cfgs.tcl

# YOU CAN CHANGE ANY VARIABLES DEFINED IN THE DEFAULT WRAPPER CFGS BY OVERRIDING THEM IN THIS CONFIG.TCL
source $::env(DESIGN_DIR)/fixed_dont_change/default_wrapper_cfgs.tcl

set script_dir [file dirname [file normalize [info script]]]

set ::env(DESIGN_NAME) user_project_wrapper
#section end

# User Configurations

## Source Verilog Files
set ::env(VERILOG_FILES) "\
	$::env(CARAVEL_ROOT)/verilog/rtl/defines.v \
	$script_dir/../../verilog/rtl/user_project_wrapper.v"

## Clock configurations
set ::env(CLOCK_PORT) "user_clock2"
set ::env(CLOCK_NET) "mprj.clk"

set ::env(CLOCK_PERIOD) "200"

set ::env(DESIGN_IS_CORE) 1
set ::env(FP_PDN_CORE_RING) 1

## Internal Macros

#set ::env(VDD_NETS) [list {vccd1}]
#set ::env(GND_NETS) [list {vssd1}]
#set ::env(VDD_NET) {vccd1}
#set ::env(VDD_PIN) {vccd1}
#set ::env(GND_NET) {vssd1}
#set ::env(GND_PIN) {vssd1}
#set ::env(FP_PDN_ENABLE_MACROS_GRID) "1"
#set ::env(FP_PDN_ENABLE_GLOBAL_CONNECTIONS) "1"
### Macro Placement
set ::env(MACRO_PLACEMENT_CFG) $script_dir/macro.cfg
#set ::env(SYNTH_USE_PG_PINS_DEFINES) "USE_POWER_PINS"
#set ::env(SYNTH_DEFINES) "USE_POWER_PINS"

# other configurations
set ::env(PL_RESIZER_MAX_SLEW_MARGIN) 40
set ::env(PL_RESIZER_MAX_CAP_MARGIN) 40
set ::env(GLB_RESIZER_MAX_SLEW_MARGIN) 40
set ::env(SYNTH_STRATEGY) "AREA 0"
#set ::env(PL_BASIC_PLACEMENT) 0
#set ::env(PL_TARGET_DENSITY) {0.01}
#set ::env(FP_CORE_UTIL) {1}
set ::env(CELL_PAD) {4}
#set ::env(GLB_RESIZER_HOLD_MAX_BUFFER_PERCENT) {60}
set ::env(ROUTING_CORES) {8}
set ::env(GLB_RT_OVERFLOW_ITERS) {50}
set ::env(GLB_RT_ALLOW_CONGESTION) 1 

### Macro PDN Connections
set ::env(FP_PDN_MACRO_HOOKS) "\
   core_region_i vccd1 vssd1 vccd1 vssd1, \
   axi_interconnect_i vccd1 vssd1 vccd1 vssd1, \
   peripherals_i vccd1 vssd1 vccd1 vssd1, \
   clk_rst_gen_i vccd1 vssd1 vccd1 vssd1, \
   instr_ram vccd1 vssd1 vccd1 vssd1, \
   data_ram vccd1 vssd1 vccd1 vssd1"

#instr_ram 170 2960 N
#data_ram 1030 2960 N
#openram 683.1 416.54

set ::env(GRT_OBS) "\
	li1   170 2960  853.1  3376.54,\
	met1  170 2960  853.1  3376.54,\
	met2  170 2960  853.1  3376.54,\
	met3  170 2960  853.1  3376.54,\
	li1   1030 2960  1713.1 3376.54,\
	met1  1030 2960  1713.1 3376.54,\
	met2  1030 2960  1713.1 3376.54,\
	met3  1030 2960  1713.1 3376.54,\
	met5  0 0 2920 3520"

### Black-box verilog and views
set ::env(VERILOG_FILES_BLACKBOX) "\
	$::env(PDK_ROOT)/$::env(PDK)/libs.ref/sky130_sram_macros/verilog/sky130_sram_2kbyte_1rw1r_32x512_8.v \
	$script_dir/../../verilog/rtl/rtl/mba_core_region.v \
	$script_dir/../../verilog/rtl/rtl/clk_rst_gen.v \
	$script_dir/../../verilog/rtl/rtl/peripherals.v \
	$script_dir/../../verilog/rtl/rtl/axi_node_intf_wrap.v"

set ::env(EXTRA_LEFS) "\
	$::env(PDK_ROOT)/$::env(PDK)/libs.ref/sky130_sram_macros/lef/sky130_sram_2kbyte_1rw1r_32x512_8.lef \
	$script_dir/../../lef/mba_core_region.lef \
	$script_dir/../../lef/clk_rst_gen.lef \
	$script_dir/../../lef/peripherals.lef \
	$script_dir/../../lef/axi_node_intf_wrap.lef"

set ::env(EXTRA_GDS_FILES) "\
	$::env(PDK_ROOT)/$::env(PDK)/libs.ref/sky130_sram_macros/gds/sky130_sram_2kbyte_1rw1r_32x512_8.gds \
	$script_dir/../../gds/mba_core_region.gds \
	$script_dir/../../gds/clk_rst_gen.gds \
	$script_dir/../../gds/peripherals.gds \
	$script_dir/../../gds/axi_node_intf_wrap.gds"


# set ::env(GLB_RT_MAXLAYER) 5
set ::env(RT_MAX_LAYER) {met5}

# disable pdn check nodes becuase it hangs with multiple power domains.
# any issue with pdn connections will be flagged with LVS so it is not a critical check.
set ::env(FP_PDN_CHECK_NODES) 0

# The following is because there are no std cells in the example wrapper project.
set ::env(SYNTH_TOP_LEVEL) 1
#set ::env(PL_RANDOM_GLB_PLACEMENT) 1
#set ::env(PL_RESIZER_DESIGN_OPTIMIZATIONS) 0
#set ::env(PL_RESIZER_TIMING_OPTIMIZATIONS) 0
#set ::env(PL_RESIZER_BUFFER_INPUT_PORTS) 0
#set ::env(PL_RESIZER_BUFFER_OUTPUT_PORTS) 0
#set ::env(FP_PDN_ENABLE_RAILS) 0
#set ::env(DIODE_INSERTION_STRATEGY) 0
#set ::env(FILL_INSERTION) 0
#set ::env(TAP_DECAP_INSERTION) 0
#set ::env(CLOCK_TREE_SYNTH) 0




set ::env(PL_RANDOM_GLB_PLACEMENT) 1
set ::env(PL_RESIZER_DESIGN_OPTIMIZATIONS) 0
set ::env(PL_RESIZER_TIMING_OPTIMIZATIONS) 0
set ::env(PL_RESIZER_BUFFER_INPUT_PORTS) 0
set ::env(PL_RESIZER_BUFFER_OUTPUT_PORTS) 0
set ::env(FP_PDN_ENABLE_RAILS) 0
set ::env(DIODE_INSERTION_STRATEGY) 0
set ::env(FILL_INSERTION) 0
set ::env(TAP_DECAP_INSERTION) 0
set ::env(CLOCK_TREE_SYNTH) 0
set ::env(QUIT_ON_LVS_ERROR) "1"
set ::env(QUIT_ON_MAGIC_DRC) "0"
set ::env(QUIT_ON_NEGATIVE_WNS) "0"
set ::env(QUIT_ON_SLEW_VIOLATIONS) "0"
set ::env(QUIT_ON_TIMING_VIOLATIONS) "0"
set ::env(FP_PDN_IRDROP) "1"
set ::env(FP_PDN_HORIZONTAL_HALO) "10"
set ::env(FP_PDN_VERTICAL_HALO) "10"


