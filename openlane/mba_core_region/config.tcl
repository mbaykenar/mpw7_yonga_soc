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

set ::env(DESIGN_NAME) {mba_core_region}

# easier method for VERILOG_FILES
#set ::env(VERILOG_FILES) [glob $::env(DESIGN_DIR)/src/*.v  $::env(DESIGN_DIR)/src/*.sv]

#         \core_region
#             \zeroriscy_core
#                 \zeroriscy_debug_unit
#                 \zeroriscy_cs_registers
#                 \zeroriscy_load_store_unit
#                 \zeroriscy_ex_block
#                     \zeroriscy_multdiv_fast
#                     \zeroriscy_alu
#                 \zeroriscy_id_stage
#                     \zeroriscy_int_controller
#                     \zeroriscy_controller
#                     \zeroriscy_decoder
#                     \zeroriscy_register_file
#                 \zeroriscy_if_stage
#                     \zeroriscy_compressed_decoder
#                     \zeroriscy_prefetch_buffer
#                         \zeroriscy_fetch_fifo
#             \adv_dbg_if
#                 \adbg_top
#                     \adbg_or1k_module
#                         \adbg_crc32
#                         \adbg_or1k_biu
#                         \adbg_or1k_status_reg
#                     \adbg_axi_module
#                         \adbg_axi_biu
#                 \adbg_tap_top
#                     \cluster_clock_mux2
#                     \cluster_clock_inverter
#             \ram_mux
#             \axi_mem_if_SP_wrap
#                 \axi_mem_if_SP
#                     \axi_read_only_ctrl
#                     \axi_write_only_ctrl
#             \sp_ram_wrap
#             \instr_ram_wrap
#                 \boot_rom_wrap
#                     \boot_code
#             \axi_slice_wrap
#                 \axi_slice
#             \core2axi_wrap
#                 \core2axi

#set ::env(VERILOG_FILES) "\
#	$::env(CARAVEL_ROOT)/verilog/rtl/defines.v \
#	$script_dir/../../verilog/rtl/rtl/core_region.v \
#    $script_dir/../../verilog/rtl/ips/zero-riscy/zeroriscy_core.v \
#    $script_dir/../../verilog/rtl/ips/zero-riscy/zeroriscy_debug_unit.v \
#    $script_dir/../../verilog/rtl/ips/zero-riscy/zeroriscy_cs_registers.v \
#    $script_dir/../../verilog/rtl/ips/zero-riscy/zeroriscy_load_store_unit.v \
#    $script_dir/../../verilog/rtl/ips/zero-riscy/zeroriscy_ex_block.v \
#    $script_dir/../../verilog/rtl/ips/zero-riscy/zeroriscy_multdiv_fast.v \
#    $script_dir/../../verilog/rtl/ips/zero-riscy/zeroriscy_alu.v \
#    $script_dir/../../verilog/rtl/ips/zero-riscy/zeroriscy_id_stage.v \
#    $script_dir/../../verilog/rtl/ips/zero-riscy/zeroriscy_int_controller.v \
#    $script_dir/../../verilog/rtl/ips/zero-riscy/zeroriscy_controller.v \
#    $script_dir/../../verilog/rtl/ips/zero-riscy/zeroriscy_decoder.v \
#    $script_dir/../../verilog/rtl/ips/zero-riscy/zeroriscy_register_file_ff.v \
#    $script_dir/../../verilog/rtl/ips/zero-riscy/zeroriscy_if_stage.v \
#    $script_dir/../../verilog/rtl/ips/zero-riscy/zeroriscy_compressed_decoder.v \
#    $script_dir/../../verilog/rtl/ips/zero-riscy/zeroriscy_prefetch_buffer.v \
#    $script_dir/../../verilog/rtl/ips/zero-riscy/zeroriscy_fetch_fifo.v \
#    $script_dir/../../verilog/rtl/ips/adv_dbg_if/rtl/adv_dbg_if.v \
#    $script_dir/../../verilog/rtl/ips/adv_dbg_if/rtl/adbg_top.v \
#    $script_dir/../../verilog/rtl/ips/adv_dbg_if/rtl/adbg_or1k_module.v \
#    $script_dir/../../verilog/rtl/ips/adv_dbg_if/rtl/adbg_crc32.v \
#    $script_dir/../../verilog/rtl/ips/adv_dbg_if/rtl/adbg_or1k_biu.v \
#    $script_dir/../../verilog/rtl/ips/adv_dbg_if/rtl/adbg_or1k_status_reg.v \
#    $script_dir/../../verilog/rtl/ips/adv_dbg_if/rtl/adbg_axi_module.v \
#	$script_dir/../../verilog/rtl/ips/adv_dbg_if/rtl/adbg_axi_biu.v \
#    $script_dir/../../verilog/rtl/ips/adv_dbg_if/rtl/adbg_tap_top.v \
#    $script_dir/../../verilog/rtl/rtl/components/cluster_clock_mux2.v \
#	$script_dir/../../verilog/rtl/rtl/components/cluster_clock_inverter.v \
#	$script_dir/../../verilog/rtl/rtl/ram_mux.v \
#    $script_dir/../../verilog/rtl/rtl/axi_mem_if_SP_wrap.v \
#    $script_dir/../../verilog/rtl/ips/axi/axi_mem_if_DP/axi_mem_if_SP.v \
#    $script_dir/../../verilog/rtl/ips/axi/axi_mem_if_DP/axi_read_only_ctrl.v \
#    $script_dir/../../verilog/rtl/ips/axi/axi_mem_if_DP/axi_write_only_ctrl.v \    
#    $script_dir/../../verilog/rtl/rtl/sp_ram_wrap.v \
#    $script_dir/../../verilog/rtl/rtl/instr_ram_wrap.v \
#    $script_dir/../../verilog/rtl/rtl/boot_rom_wrap.v \
#    $script_dir/../../verilog/rtl/rtl/boot_code.v \
#	$script_dir/../../verilog/rtl/rtl/axi_slice_wrap.v \
#    $script_dir/../../verilog/rtl/ips/axi/axi_slice/axi_slice.v \
#    $script_dir/../../verilog/rtl/rtl/core2axi_wrap.v \
#    $script_dir/../../verilog/rtl/ips/axi/core2axi/core2axi.v \
#	$script_dir/../../verilog/rtl/ips/adv_dbg_if/rtl/adbg_axi_defines.v \
#    $script_dir/../../verilog/rtl/ips/adv_dbg_if/rtl/adbg_defines.v \
#    $script_dir/../../verilog/rtl/ips/adv_dbg_if/rtl/adbg_lint_defines.v \
#    $script_dir/../../verilog/rtl/ips/adv_dbg_if/rtl/adbg_or1k_defines.v \
#    $script_dir/../../verilog/rtl/ips/adv_dbg_if/rtl/adbg_tap_defines.v \
#    $script_dir/../../verilog/rtl/rtl/includes/apu_defines.sv \
#    $script_dir/../../verilog/rtl/ips/adv_dbg_if/rtl/adbg_axi_defines.v \
#    $script_dir/../../verilog/rtl/ips/adv_dbg_if/rtl/adbg_defines.v \
#    $script_dir/../../verilog/rtl/ips/adv_dbg_if/rtl/adbg_lint_defines.v \
#    $script_dir/../../verilog/rtl/ips/adv_dbg_if/rtl/adbg_or1k_defines.v \
#    $script_dir/../../verilog/rtl/ips/adv_dbg_if/rtl/adbg_tap_defines.v \
#    $script_dir/../../verilog/rtl/ips/axi/axi_node/defines.v \
#    $script_dir/../../verilog/rtl/ips/apb/apb_event_unit/include/defines_event_unit.sv \
#    $script_dir/../../verilog/rtl/ips/zero-riscy/include/zeroriscy_config.sv \
#    $script_dir/../../verilog/rtl/ips/zero-riscy/include/zeroriscy_defines.sv"

set ::env(VERILOG_FILES) "\
	$::env(CARAVEL_ROOT)/verilog/rtl/defines.v \
	$script_dir/../../verilog/rtl/rtl/apb_mock_uart.v \
	$script_dir/../../verilog/rtl/rtl/axi_mem_if_SP_wrap.v \
	$script_dir/../../verilog/rtl/rtl/axi_node_intf_wrap.v \
	$script_dir/../../verilog/rtl/rtl/axi_slice_wrap.v \
	$script_dir/../../verilog/rtl/rtl/axi_spi_slave_wrap.v \
	$script_dir/../../verilog/rtl/rtl/axi2apb_wrap.v \
	$script_dir/../../verilog/rtl/rtl/boot_code.v \
	$script_dir/../../verilog/rtl/rtl/boot_rom_wrap.v \
	$script_dir/../../verilog/rtl/rtl/clk_rst_gen.v \
	$script_dir/../../verilog/rtl/rtl/mba_core_region.v \
	$script_dir/../../verilog/rtl/rtl/core2axi_wrap.v \
	$script_dir/../../verilog/rtl/rtl/dp_ram_wrap.v \
	$script_dir/../../verilog/rtl/rtl/mba_instr_ram_wrap.v \
	$script_dir/../../verilog/rtl/rtl/periph_bus_wrap.v \
	$script_dir/../../verilog/rtl/rtl/peripherals.v \
	$script_dir/../../verilog/rtl/rtl/pulpino_top_wrapper.v \
	$script_dir/../../verilog/rtl/rtl/pulpino_top.v \
	$script_dir/../../verilog/rtl/rtl/ram_mux.v \
	$script_dir/../../verilog/rtl/rtl/mba_sp_ram_wrap.v \
	$script_dir/../../verilog/rtl/rtl/components/cluster_clock_gating.v \
	$script_dir/../../verilog/rtl/rtl/components/cluster_clock_inverter.v \
	$script_dir/../../verilog/rtl/rtl/components/cluster_clock_mux2.v \
	$script_dir/../../verilog/rtl/rtl/components/dp_ram.v \
	$script_dir/../../verilog/rtl/rtl/components/generic_fifo.v \
	$script_dir/../../verilog/rtl/rtl/components/pulp_clock_gating.v \
	$script_dir/../../verilog/rtl/rtl/components/pulp_clock_inverter.v \
	$script_dir/../../verilog/rtl/rtl/components/pulp_clock_mux2.v \
	$script_dir/../../verilog/rtl/rtl/components/rstgen.v \
	$script_dir/../../verilog/rtl/rtl/components/sp_ram.v \
	$script_dir/../../verilog/rtl/rtl/includes/apb_bus.sv \
	$script_dir/../../verilog/rtl/rtl/includes/apu_defines.sv \
	$script_dir/../../verilog/rtl/rtl/includes/axi_bus.sv \
	$script_dir/../../verilog/rtl/rtl/includes/config.sv \
	$script_dir/../../verilog/rtl/rtl/includes/debug_bus.sv \
	$script_dir/../../verilog/rtl/ips/adv_dbg_if/rtl/adbg_axi_biu.v \
	$script_dir/../../verilog/rtl/ips/adv_dbg_if/rtl/adbg_axi_defines.v \
	$script_dir/../../verilog/rtl/ips/adv_dbg_if/rtl/adbg_axi_module.v \
    $script_dir/../../verilog/rtl/ips/adv_dbg_if/rtl/adbg_axionly_top.v \
    $script_dir/../../verilog/rtl/ips/adv_dbg_if/rtl/adbg_crc32.v \
    $script_dir/../../verilog/rtl/ips/adv_dbg_if/rtl/adbg_defines.v \
    $script_dir/../../verilog/rtl/ips/adv_dbg_if/rtl/adbg_lint_biu.v \
    $script_dir/../../verilog/rtl/ips/adv_dbg_if/rtl/adbg_lint_defines.v \
    $script_dir/../../verilog/rtl/ips/adv_dbg_if/rtl/adbg_lint_module.v \
    $script_dir/../../verilog/rtl/ips/adv_dbg_if/rtl/adbg_lintonly_top.v \
    $script_dir/../../verilog/rtl/ips/adv_dbg_if/rtl/adbg_or1k_biu.v \
    $script_dir/../../verilog/rtl/ips/adv_dbg_if/rtl/adbg_or1k_defines.v \
    $script_dir/../../verilog/rtl/ips/adv_dbg_if/rtl/adbg_or1k_module.v \
    $script_dir/../../verilog/rtl/ips/adv_dbg_if/rtl/adbg_or1k_status_reg.v \
    $script_dir/../../verilog/rtl/ips/adv_dbg_if/rtl/adbg_tap_defines.v \
    $script_dir/../../verilog/rtl/ips/adv_dbg_if/rtl/adbg_tap_top.v \
    $script_dir/../../verilog/rtl/ips/adv_dbg_if/rtl/adbg_top.v \
    $script_dir/../../verilog/rtl/ips/adv_dbg_if/rtl/adv_dbg_if.v \
    $script_dir/../../verilog/rtl/ips/adv_dbg_if/rtl/bytefifo.v \
    $script_dir/../../verilog/rtl/ips/adv_dbg_if/rtl/syncflop.v \
    $script_dir/../../verilog/rtl/ips/adv_dbg_if/rtl/syncreg.v \
    $script_dir/../../verilog/rtl/ips/apb/apb_event_unit/apb_event_unit.v \
    $script_dir/../../verilog/rtl/ips/apb/apb_event_unit/generic_service_unit.v \
    $script_dir/../../verilog/rtl/ips/apb/apb_event_unit/sleep_unit.v \
    $script_dir/../../verilog/rtl/ips/apb/apb_event_unit/include/defines_event_unit.sv \
    $script_dir/../../verilog/rtl/ips/apb/apb_fll_if/apb_fll_if.v \
	$script_dir/../../verilog/rtl/ips/apb/apb_gpio/apb_gpio.v \
    $script_dir/../../verilog/rtl/ips/apb/apb_i2c/apb_i2c.v \
    $script_dir/../../verilog/rtl/ips/apb/apb_i2c/i2c_master_bit_ctrl.v \
    $script_dir/../../verilog/rtl/ips/apb/apb_i2c/i2c_master_byte_ctrl.v \
    $script_dir/../../verilog/rtl/ips/apb/apb_i2c/i2c_master_defines.sv	\
    $script_dir/../../verilog/rtl/ips/apb/apb_node/apb_node_wrap.v \
    $script_dir/../../verilog/rtl/ips/apb/apb_node/apb_node.v \
    $script_dir/../../verilog/rtl/ips/apb/apb_pulpino/apb_pulpino.v \
    $script_dir/../../verilog/rtl/ips/apb/apb_spi_master/apb_spi_master.v \
    $script_dir/../../verilog/rtl/ips/apb/apb_spi_master/spi_master_apb_if.v \
    $script_dir/../../verilog/rtl/ips/apb/apb_spi_master/spi_master_clkgen.v \
    $script_dir/../../verilog/rtl/ips/apb/apb_spi_master/spi_master_controller.v \
    $script_dir/../../verilog/rtl/ips/apb/apb_spi_master/spi_master_fifo.v \
    $script_dir/../../verilog/rtl/ips/apb/apb_spi_master/spi_master_rx.v \
    $script_dir/../../verilog/rtl/ips/apb/apb_spi_master/spi_master_tx.v \
    $script_dir/../../verilog/rtl/ips/apb/apb_timer/apb_timer.v \
    $script_dir/../../verilog/rtl/ips/apb/apb_timer/timer.v \
    $script_dir/../../verilog/rtl/ips/apb/apb_uart_sv/apb_uart_sv.v \
    $script_dir/../../verilog/rtl/ips/apb/apb_uart_sv/io_generic_fifo.v \
    $script_dir/../../verilog/rtl/ips/apb/apb_uart_sv/uart_interrupt.v \
    $script_dir/../../verilog/rtl/ips/apb/apb_uart_sv/uart_rx.v \
    $script_dir/../../verilog/rtl/ips/apb/apb_uart_sv/uart_tx.v \
    $script_dir/../../verilog/rtl/ips/apb/apb2per/apb2per.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_mem_if_DP/axi_mem_if_DP_hybr.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_mem_if_DP/axi_mem_if_DP.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_mem_if_DP/axi_mem_if_MP_Hybrid_multi_bank.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_mem_if_DP/axi_mem_if_multi_bank.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_mem_if_DP/axi_mem_if_SP.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_mem_if_DP/axi_read_only_ctrl.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_mem_if_DP/axi_write_only_ctrl.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_node/apb_regs_top.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_node/axi_address_decoder_AR.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_node/axi_address_decoder_AW.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_node/axi_address_decoder_BR.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_node/axi_address_decoder_BW.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_node/axi_address_decoder_DW.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_node/axi_AR_allocator.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_node/axi_ArbitrationTree.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_node/axi_AW_allocator.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_node/axi_BR_allocator.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_node/axi_BW_allocator.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_node/axi_DW_allocator.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_node/axi_FanInPrimitive_Req.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_node/axi_multiplexer.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_node/axi_node_wrap_with_slices.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_node/axi_node_wrap.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_node/axi_node.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_node/axi_regs_top.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_node/axi_request_block.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_node/axi_response_block.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_node/axi_RR_Flag_Req.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_node/defines.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_slice/axi_ar_buffer.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_slice/axi_aw_buffer.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_slice/axi_b_buffer.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_slice/axi_buffer.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_slice/axi_r_buffer.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_slice/axi_slice.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_slice/axi_w_buffer.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_slice_dc/axi_slice_dc_master.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_slice_dc/axi_slice_dc_slave.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_slice_dc/dc_data_buffer.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_slice_dc/dc_full_detector.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_slice_dc/dc_synchronizer.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_slice_dc/dc_token_ring_fifo_din.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_slice_dc/dc_token_ring_fifo_dout.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_slice_dc/dc_token_ring.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_spi_master/axi_spi_master.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_spi_master/spi_master_axi_if.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_spi_slave/axi_spi_slave.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_spi_slave/spi_slave_axi_plug.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_spi_slave/spi_slave_cmd_parser.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_spi_slave/spi_slave_controller.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_spi_slave/spi_slave_dc_fifo.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_spi_slave/spi_slave_regs.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_spi_slave/spi_slave_rx.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_spi_slave/spi_slave_syncro.v \
    $script_dir/../../verilog/rtl/ips/axi/axi_spi_slave/spi_slave_tx.v \
    $script_dir/../../verilog/rtl/ips/axi/axi2apb/AXI_2_APB_32.v \
    $script_dir/../../verilog/rtl/ips/axi/axi2apb/AXI_2_APB.v \
    $script_dir/../../verilog/rtl/ips/axi/axi2apb/axi2apb.v \
    $script_dir/../../verilog/rtl/ips/axi/axi2apb/axi2apb32.v \
    $script_dir/../../verilog/rtl/ips/axi/core2axi/core2axi.v \
    $script_dir/../../verilog/rtl/ips/fpu/hdl/fpu_div_sqrt_tp_nlp/control_tp.v \
    $script_dir/../../verilog/rtl/ips/fpu/hdl/fpu_div_sqrt_tp_nlp/div_sqrt_top_tp.v \
    $script_dir/../../verilog/rtl/ips/fpu/hdl/fpu_div_sqrt_tp_nlp/fpu_defs_div_sqrt_tp.sv \
    $script_dir/../../verilog/rtl/ips/fpu/hdl/fpu_div_sqrt_tp_nlp/fpu_norm_div_sqrt.v \
    $script_dir/../../verilog/rtl/ips/fpu/hdl/fpu_div_sqrt_tp_nlp/iteration_div_sqrt_first.v \
    $script_dir/../../verilog/rtl/ips/fpu/hdl/fpu_div_sqrt_tp_nlp/iteration_div_sqrt.v \
    $script_dir/../../verilog/rtl/ips/fpu/hdl/fpu_div_sqrt_tp_nlp/nrbd_nrsc_tp.v \
    $script_dir/../../verilog/rtl/ips/fpu/hdl/fpu_div_sqrt_tp_nlp/preprocess.v \
    $script_dir/../../verilog/rtl/ips/fpu/hdl/fpu_fmac/adders.v \
    $script_dir/../../verilog/rtl/ips/fpu/hdl/fpu_fmac/aligner.v \
    $script_dir/../../verilog/rtl/ips/fpu/hdl/fpu_fmac/booth_encoder.v \
    $script_dir/../../verilog/rtl/ips/fpu/hdl/fpu_fmac/booth_selector.v \
    $script_dir/../../verilog/rtl/ips/fpu/hdl/fpu_fmac/CSA.v \
    $script_dir/../../verilog/rtl/ips/fpu/hdl/fpu_fmac/fpu_defs_fmac.sv \
    $script_dir/../../verilog/rtl/ips/fpu/hdl/fpu_fmac/fpu_norm_fmac.v \
    $script_dir/../../verilog/rtl/ips/fpu/hdl/fpu_fmac/LZA.v \
    $script_dir/../../verilog/rtl/ips/fpu/hdl/fpu_fmac/pp_generation.v \
    $script_dir/../../verilog/rtl/ips/fpu/hdl/fpu_fmac/preprocess_fmac.v \
    $script_dir/../../verilog/rtl/ips/fpu/hdl/fpu_fmac/wallace.v \
    $script_dir/../../verilog/rtl/ips/fpu/hdl/fpu_utils/fpu_ff.v \
    $script_dir/../../verilog/rtl/ips/fpu/hdl/fpu_v0.1/defines_fpu.sv \
    $script_dir/../../verilog/rtl/ips/fpu/hdl/fpu_v0.1/fp_fma_wrapper.v \
    $script_dir/../../verilog/rtl/ips/fpu/hdl/fpu_v0.1/fpexc.v \
    $script_dir/../../verilog/rtl/ips/fpu/hdl/fpu_v0.1/fpu_add.v \
    $script_dir/../../verilog/rtl/ips/fpu/hdl/fpu_v0.1/fpu_core.v \
    $script_dir/../../verilog/rtl/ips/fpu/hdl/fpu_v0.1/fpu_defs.sv \
    $script_dir/../../verilog/rtl/ips/fpu/hdl/fpu_v0.1/fpu_ftoi.v \
    $script_dir/../../verilog/rtl/ips/fpu/hdl/fpu_v0.1/fpu_itof.v \
    $script_dir/../../verilog/rtl/ips/fpu/hdl/fpu_v0.1/fpu_mult.v \
    $script_dir/../../verilog/rtl/ips/fpu/hdl/fpu_v0.1/fpu_norm.v \
    $script_dir/../../verilog/rtl/ips/fpu/hdl/fpu_v0.1/fpu_private.v \
    $script_dir/../../verilog/rtl/ips/fpu/hdl/fpu_v0.1/fpu.v \
    $script_dir/../../verilog/rtl/ips/fpu/hdl/fpu_v0.1/riscv_fpu.v \
    $script_dir/../../verilog/rtl/ips/zero-riscy/zeroriscy_alu.v \
    $script_dir/../../verilog/rtl/ips/zero-riscy/zeroriscy_compressed_decoder.v \
    $script_dir/../../verilog/rtl/ips/zero-riscy/zeroriscy_controller.v \
    $script_dir/../../verilog/rtl/ips/zero-riscy/zeroriscy_core.v \
    $script_dir/../../verilog/rtl/ips/zero-riscy/zeroriscy_cs_registers.v \
    $script_dir/../../verilog/rtl/ips/zero-riscy/zeroriscy_debug_unit.v \
    $script_dir/../../verilog/rtl/ips/zero-riscy/zeroriscy_decoder.v \
    $script_dir/../../verilog/rtl/ips/zero-riscy/zeroriscy_ex_block.v \
    $script_dir/../../verilog/rtl/ips/zero-riscy/zeroriscy_fetch_fifo.v \
    $script_dir/../../verilog/rtl/ips/zero-riscy/zeroriscy_id_stage.v \
    $script_dir/../../verilog/rtl/ips/zero-riscy/zeroriscy_if_stage.v \
    $script_dir/../../verilog/rtl/ips/zero-riscy/zeroriscy_int_controller.v \
    $script_dir/../../verilog/rtl/ips/zero-riscy/zeroriscy_load_store_unit.v \
    $script_dir/../../verilog/rtl/ips/zero-riscy/zeroriscy_multdiv_fast.v \
    $script_dir/../../verilog/rtl/ips/zero-riscy/zeroriscy_multdiv_slow.v \
    $script_dir/../../verilog/rtl/ips/zero-riscy/zeroriscy_prefetch_buffer.v \
    $script_dir/../../verilog/rtl/ips/zero-riscy/zeroriscy_register_file_ff.v \
    $script_dir/../../verilog/rtl/ips/zero-riscy/include/zeroriscy_config.sv \
    $script_dir/../../verilog/rtl/ips/zero-riscy/include/zeroriscy_defines.sv"

set ::env(DESIGN_IS_CORE) {0}

set ::env(CLOCK_PORT) {clk}
set ::env(CLOCK_NET) {clk}
set ::env(CLOCK_PERIOD) {200}

set ::env(PL_RESIZER_MAX_SLEW_MARGIN) 40
set ::env(PL_RESIZER_MAX_CAP_MARGIN) 40
set ::env(GLB_RESIZER_MAX_SLEW_MARGIN) 40

set ::env(FP_SIZING) absolute
set ::env(DIE_AREA) "0 0 1400 1800"
#set ::env(FP_SIZING) relative

#set ::env(FP_PIN_ORDER_CFG) $script_dir/pin_order.cfg
set ::env(SYNTH_STRATEGY) "AREA 0"
set ::env(PL_BASIC_PLACEMENT) 0
set ::env(PL_TARGET_DENSITY) {0.30}
set ::env(FP_CORE_UTIL) {30}
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
#   data_mem.open_ram_2k vccd1 vssd1 vccd1 vssd1, \
#   instr_mem.sp_ram_wrap_i.open_ram_2k vccd1 vssd1 vccd1 vssd1"

set ::env(DIODE_INSERTION_STRATEGY) 3 
# If you're going to use multiple power domains, then disable cvc run.
set ::env(RUN_CVC) 1

####################################################################################################
## Internal Macro

# $script_dir/../../verilog/rtl/rtl/components/sky130_sram_2kbyte_1rw1r_32x512_8.v \
 
#set ::env(VERILOG_FILES_BLACKBOX) "\
#	$::env(PDK_ROOT)/$::env(PDK)/libs.ref/sky130_sram_macros/verilog/sky130_sram_2kbyte_1rw1r_32x512_8.v"
#
#set ::env(EXTRA_LEFS) "\
#	$::env(PDK_ROOT)/$::env(PDK)/libs.ref/sky130_sram_macros/lef/sky130_sram_2kbyte_1rw1r_32x512_8.lef"
#
#set ::env(EXTRA_GDS_FILES) "\
#	$::env(PDK_ROOT)/$::env(PDK)/libs.ref/sky130_sram_macros/gds/sky130_sram_2kbyte_1rw1r_32x512_8.gds"
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
