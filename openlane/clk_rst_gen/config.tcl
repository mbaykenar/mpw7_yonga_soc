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

set ::env(PDK) "sky130B"
set ::env(STD_CELL_LIBRARY) "sky130_fd_sc_hd"

set script_dir [file dirname [file normalize [info script]]]

set ::env(DESIGN_NAME) {clk_rst_gen}

set ::env(VERILOG_FILES) "\
	$::env(CARAVEL_ROOT)/verilog/rtl/defines.v \
	$script_dir/../../verilog/rtl/rtl/clk_rst_gen.v \
	$script_dir/../../verilog/rtl/rtl/components/rstgen.v"

set ::env(DESIGN_IS_CORE) {0}

set ::env(CLOCK_PORT) {clk_i}
set ::env(CLOCK_NET) {clk_i}
set ::env(CLOCK_PERIOD) {200}

set ::env(PL_RESIZER_MAX_SLEW_MARGIN) 40
set ::env(PL_RESIZER_MAX_CAP_MARGIN) 40
set ::env(GLB_RESIZER_MAX_SLEW_MARGIN) 40

set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0 0 250 150"
#set ::env(FP_SIZING) relative

#set ::env(FP_PIN_ORDER_CFG) $script_dir/pin_order.cfg
set ::env(SYNTH_STRATEGY) "DELAY 0"
set ::env(PL_BASIC_PLACEMENT) 0
set ::env(PL_TARGET_DENSITY) {0.20}
set ::env(FP_CORE_UTIL) {20}
#set ::env(PL_MACRO_CHANNEL) {30 30}
#set ::env(PL_MACRO_HALO) {10 10}
set ::env(CELL_PAD) {4}
set ::env(GLB_RESIZER_HOLD_MAX_BUFFER_PERCENT) {60}
set ::env(ROUTING_CORES) {8}
set ::env(GLB_RT_OVERFLOW_ITERS) {50}
set ::env(GLB_RT_ALLOW_CONGESTION) 1 



# Maximum layer used for routing is metal 4.
# This is because this macro will be inserted in a top level (user_project_wrapper) 
# where the PDN is planned on metal 5. So, to avoid having shorts between routes
# in this macro and the top level metal 5 stripes, we have to restrict routes to metal4.  
# 
# set ::env(GLB_RT_MAXLAYER) 5

set ::env(RT_MAX_LAYER) {met4}

# You can draw more power domains if you need to 
set ::env(VDD_NETS) [list {vccd1}]
set ::env(GND_NETS) [list {vssd1}]
#set ::env(FP_PDN_ENABLE_MACROS_GRID) "1"
#set ::env(FP_PDN_ENABLE_GLOBAL_CONNECTIONS) "1"
### Macro Placement
#set ::env(MACRO_PLACEMENT_CFG) $script_dir/macro.cfg
set ::env(SYNTH_USE_PG_PINS_DEFINES) "USE_POWER_PINS"
#set ::env(SYNTH_DEFINES) "USE_POWER_PINS"
## Macro PDN Connections
#set ::env(FP_PDN_MACRO_HOOKS) "\
#   core_region_i vccd1 vssd1 vccd1 vssd1, \
#   instr_ram vccd1 vssd1 vccd1 vssd1, \
#   data_ram vccd1 vssd1 vccd1 vssd1"

set ::env(DIODE_INSERTION_STRATEGY) 3 
# If you're going to use multiple power domains, then disable cvc run.
set ::env(RUN_CVC) 1

####################################################################################################
## Internal Macro

# $script_dir/../../verilog/rtl/rtl/components/sky130_sram_2kbyte_1rw1r_32x512_8.v \

##########################
# sky130_sram_2kbyte_1rw1r_32x512_8 


##########################
# axi_node_intf_wrap
#set ::env(VERILOG_FILES_BLACKBOX) "\
#	$script_dir/../../verilog/rtl/rtl/axi_node_intf_wrap.v"

#set ::env(EXTRA_LEFS) "\
#	$script_dir/../../lef/axi_node_intf_wrap.lef"

#set ::env(EXTRA_GDS_FILES) "\
#	$script_dir/../../gds/axi_node_intf_wrap.gds"

##########################
# peripherals
#set ::env(VERILOG_FILES_BLACKBOX) "\
#	$script_dir/../../verilog/rtl/rtl/peripherals.v"

#set ::env(EXTRA_LEFS) "\
#	$script_dir/../../lef/peripherals.lef"

#set ::env(EXTRA_GDS_FILES) "\
#	$script_dir/../../gds/peripherals.gds"

##########################
# mba_core_region
#set ::env(VERILOG_FILES_BLACKBOX) "\
#	$script_dir/../../verilog/rtl/rtl/mba_core_region.v"

#set ::env(EXTRA_LEFS) "\
#	$script_dir/../../lef/mba_core_region.lef"

#set ::env(EXTRA_GDS_FILES) "\
#	$script_dir/../../gds/mba_core_region.gds"


#
#set ::env(EXTRA_LIBS) "\
#	$::env(PDK_ROOT)/$::env(PDK)/libs.ref/sky130_sram_macros/lib/sky130_sram_2kbyte_1rw1r_32x512_8_TT_1p8V_25C.lib"

### Black-box verilog and views
#set ::env(VERILOG_FILES_BLACKBOX) "\
#    $script_dir/../../verilog/rtl/rtl/components/sky130_sram_2kbyte_1rw1r_32x512_8.v"

#set ::env(EXTRA_LEFS) "\
#	$script_dir/../../dependencies/pdks/sky130B/libs.ref/sky130_sram_macros/lef/sky130_sram_2kbyte_1rw1r_32x512_8.lef"

#set ::env(EXTRA_GDS_FILES) "\
#	$script_dir/../../dependencies/pdks/sky130B/libs.ref/sky130_sram_macros/gds/sky130_sram_2kbyte_1rw1r_32x512_8.gds"

# disable pdn check nodes becuase it hangs with multiple power domains.
# any issue with pdn connections will be flagged with LVS so it is not a critical check.
set ::env(FP_PDN_CHECK_NODES) 0

# The following is because there are no std cells in the example wrapper project.
#set ::env(SYNTH_TOP_LEVEL) 1
#set ::env(PL_RANDOM_GLB_PLACEMENT) 1
