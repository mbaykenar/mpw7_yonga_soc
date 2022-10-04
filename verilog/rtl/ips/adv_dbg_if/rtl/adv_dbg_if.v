module adv_dbg_if 
#(
	parameter NB_CORES       = 4,
	parameter AXI_ADDR_WIDTH = 32,
	parameter AXI_DATA_WIDTH = 64,
	parameter AXI_USER_WIDTH = 6,
	parameter AXI_ID_WIDTH   = 3
)
(
	tms_pad_i,
	tck_pad_i,
	trstn_pad_i,
	tdi_pad_i,
	tdo_pad_o,
	tdo_padoe_o,
	test_mode_i,
	cpu_clk_i,
	cpu_addr_o,
	cpu_data_i,
	cpu_data_o,
	cpu_bp_i,
	cpu_stall_o,
	cpu_stb_o,
	cpu_we_o,
	cpu_ack_i,
	cpu_rst_o,
	axi_aclk,
	axi_aresetn,
	axi_master_aw_valid,
	axi_master_aw_addr,
	axi_master_aw_prot,
	axi_master_aw_region,
	axi_master_aw_len,
	axi_master_aw_size,
	axi_master_aw_burst,
	axi_master_aw_lock,
	axi_master_aw_cache,
	axi_master_aw_qos,
	axi_master_aw_id,
	axi_master_aw_user,
	axi_master_aw_ready,
	axi_master_ar_valid,
	axi_master_ar_addr,
	axi_master_ar_prot,
	axi_master_ar_region,
	axi_master_ar_len,
	axi_master_ar_size,
	axi_master_ar_burst,
	axi_master_ar_lock,
	axi_master_ar_cache,
	axi_master_ar_qos,
	axi_master_ar_id,
	axi_master_ar_user,
	axi_master_ar_ready,
	axi_master_w_valid,
	axi_master_w_data,
	axi_master_w_strb,
	axi_master_w_user,
	axi_master_w_last,
	axi_master_w_ready,
	axi_master_r_valid,
	axi_master_r_data,
	axi_master_r_resp,
	axi_master_r_last,
	axi_master_r_id,
	axi_master_r_user,
	axi_master_r_ready,
	axi_master_b_valid,
	axi_master_b_resp,
	axi_master_b_id,
	axi_master_b_user,
	axi_master_b_ready
);
	//parameter NB_CORES = 4;
	//parameter AXI_ADDR_WIDTH = 32;
	//parameter AXI_DATA_WIDTH = 64;
	//parameter AXI_USER_WIDTH = 6;
	//parameter AXI_ID_WIDTH = 3;
	input wire tms_pad_i;
	input wire tck_pad_i;
	input wire trstn_pad_i;
	input wire tdi_pad_i;
	output wire tdo_pad_o;
	output wire tdo_padoe_o;
	input wire test_mode_i;
	input wire [NB_CORES - 1:0] cpu_clk_i;
	output wire [(NB_CORES * 16) - 1:0] cpu_addr_o;
	input wire [(NB_CORES * 32) - 1:0] cpu_data_i;
	output wire [(NB_CORES * 32) - 1:0] cpu_data_o;
	input wire [NB_CORES - 1:0] cpu_bp_i;
	output wire [NB_CORES - 1:0] cpu_stall_o;
	output wire [NB_CORES - 1:0] cpu_stb_o;
	output wire [NB_CORES - 1:0] cpu_we_o;
	input wire [NB_CORES - 1:0] cpu_ack_i;
	output wire [NB_CORES - 1:0] cpu_rst_o;
	input wire axi_aclk;
	input wire axi_aresetn;
	output wire axi_master_aw_valid;
	output wire [AXI_ADDR_WIDTH - 1:0] axi_master_aw_addr;
	output wire [2:0] axi_master_aw_prot;
	output wire [3:0] axi_master_aw_region;
	output wire [7:0] axi_master_aw_len;
	output wire [2:0] axi_master_aw_size;
	output wire [1:0] axi_master_aw_burst;
	output wire axi_master_aw_lock;
	output wire [3:0] axi_master_aw_cache;
	output wire [3:0] axi_master_aw_qos;
	output wire [AXI_ID_WIDTH - 1:0] axi_master_aw_id;
	output wire [AXI_USER_WIDTH - 1:0] axi_master_aw_user;
	input wire axi_master_aw_ready;
	output wire axi_master_ar_valid;
	output wire [AXI_ADDR_WIDTH - 1:0] axi_master_ar_addr;
	output wire [2:0] axi_master_ar_prot;
	output wire [3:0] axi_master_ar_region;
	output wire [7:0] axi_master_ar_len;
	output wire [2:0] axi_master_ar_size;
	output wire [1:0] axi_master_ar_burst;
	output wire axi_master_ar_lock;
	output wire [3:0] axi_master_ar_cache;
	output wire [3:0] axi_master_ar_qos;
	output wire [AXI_ID_WIDTH - 1:0] axi_master_ar_id;
	output wire [AXI_USER_WIDTH - 1:0] axi_master_ar_user;
	input wire axi_master_ar_ready;
	output wire axi_master_w_valid;
	output wire [AXI_DATA_WIDTH - 1:0] axi_master_w_data;
	output wire [(AXI_DATA_WIDTH / 8) - 1:0] axi_master_w_strb;
	output wire [AXI_USER_WIDTH - 1:0] axi_master_w_user;
	output wire axi_master_w_last;
	input wire axi_master_w_ready;
	input wire axi_master_r_valid;
	input wire [AXI_DATA_WIDTH - 1:0] axi_master_r_data;
	input wire [1:0] axi_master_r_resp;
	input wire axi_master_r_last;
	input wire [AXI_ID_WIDTH - 1:0] axi_master_r_id;
	input wire [AXI_USER_WIDTH - 1:0] axi_master_r_user;
	output wire axi_master_r_ready;
	input wire axi_master_b_valid;
	input wire [1:0] axi_master_b_resp;
	input wire [AXI_ID_WIDTH - 1:0] axi_master_b_id;
	input wire [AXI_USER_WIDTH - 1:0] axi_master_b_user;
	output wire axi_master_b_ready;
	wire s_test_logic_reset;
	wire s_run_test_idle;
	wire s_shift_dr;
	wire s_pause_dr;
	wire s_update_dr;
	wire s_capture_dr;
	wire s_extest_select;
	wire s_sample_preload_select;
	wire s_mbist_select;
	wire s_debug_select;
	wire s_tdi;
	wire s_debug_tdo;
	adbg_tap_top cluster_tap_i(
		.tms_pad_i(tms_pad_i),
		.tck_pad_i(tck_pad_i),
		.trstn_pad_i(trstn_pad_i),
		.tdi_pad_i(tdi_pad_i),
		.tdo_pad_o(tdo_pad_o),
		.tdo_padoe_o(tdo_padoe_o),
		.test_mode_i(test_mode_i),
		.test_logic_reset_o(s_test_logic_reset),
		.run_test_idle_o(s_run_test_idle),
		.shift_dr_o(s_shift_dr),
		.pause_dr_o(s_pause_dr),
		.update_dr_o(s_update_dr),
		.capture_dr_o(s_capture_dr),
		.extest_select_o(s_extest_select),
		.sample_preload_select_o(s_sample_preload_select),
		.mbist_select_o(s_mbist_select),
		.debug_select_o(s_debug_select),
		.tdi_o(s_tdi),
		.debug_tdo_i(s_debug_tdo),
		.bs_chain_tdo_i(1'b0),
		.mbist_tdo_i(1'b0)
	);
	adbg_top #(
		.NB_CORES(NB_CORES),
		.AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
		.AXI_DATA_WIDTH(AXI_DATA_WIDTH),
		.AXI_USER_WIDTH(AXI_USER_WIDTH),
		.AXI_ID_WIDTH(AXI_ID_WIDTH)
	) dbg_module_i(
		.tck_i(tck_pad_i),
		.tdi_i(s_tdi),
		.tdo_o(s_debug_tdo),
		.trstn_i(trstn_pad_i),
		.shift_dr_i(s_shift_dr),
		.pause_dr_i(s_pause_dr),
		.update_dr_i(s_update_dr),
		.capture_dr_i(s_capture_dr),
		.debug_select_i(s_debug_select),
		.cpu_addr_o(cpu_addr_o),
		.cpu_data_i(cpu_data_i),
		.cpu_data_o(cpu_data_o),
		.cpu_bp_i(cpu_bp_i),
		.cpu_stall_o(cpu_stall_o),
		.cpu_stb_o(cpu_stb_o),
		.cpu_we_o(cpu_we_o),
		.cpu_ack_i(cpu_ack_i),
		.cpu_rst_o(cpu_rst_o),
		.axi_aclk(axi_aclk),
		.axi_aresetn(axi_aresetn),
		.axi_master_aw_valid(axi_master_aw_valid),
		.axi_master_aw_addr(axi_master_aw_addr),
		.axi_master_aw_prot(axi_master_aw_prot),
		.axi_master_aw_region(axi_master_aw_region),
		.axi_master_aw_len(axi_master_aw_len),
		.axi_master_aw_size(axi_master_aw_size),
		.axi_master_aw_burst(axi_master_aw_burst),
		.axi_master_aw_lock(axi_master_aw_lock),
		.axi_master_aw_cache(axi_master_aw_cache),
		.axi_master_aw_qos(axi_master_aw_qos),
		.axi_master_aw_id(axi_master_aw_id),
		.axi_master_aw_user(axi_master_aw_user),
		.axi_master_aw_ready(axi_master_aw_ready),
		.axi_master_ar_valid(axi_master_ar_valid),
		.axi_master_ar_addr(axi_master_ar_addr),
		.axi_master_ar_prot(axi_master_ar_prot),
		.axi_master_ar_region(axi_master_ar_region),
		.axi_master_ar_len(axi_master_ar_len),
		.axi_master_ar_size(axi_master_ar_size),
		.axi_master_ar_burst(axi_master_ar_burst),
		.axi_master_ar_lock(axi_master_ar_lock),
		.axi_master_ar_cache(axi_master_ar_cache),
		.axi_master_ar_qos(axi_master_ar_qos),
		.axi_master_ar_id(axi_master_ar_id),
		.axi_master_ar_user(axi_master_ar_user),
		.axi_master_ar_ready(axi_master_ar_ready),
		.axi_master_w_valid(axi_master_w_valid),
		.axi_master_w_data(axi_master_w_data),
		.axi_master_w_strb(axi_master_w_strb),
		.axi_master_w_user(axi_master_w_user),
		.axi_master_w_last(axi_master_w_last),
		.axi_master_w_ready(axi_master_w_ready),
		.axi_master_r_valid(axi_master_r_valid),
		.axi_master_r_data(axi_master_r_data),
		.axi_master_r_resp(axi_master_r_resp),
		.axi_master_r_last(axi_master_r_last),
		.axi_master_r_id(axi_master_r_id),
		.axi_master_r_user(axi_master_r_user),
		.axi_master_r_ready(axi_master_r_ready),
		.axi_master_b_valid(axi_master_b_valid),
		.axi_master_b_resp(axi_master_b_resp),
		.axi_master_b_id(axi_master_b_id),
		.axi_master_b_user(axi_master_b_user),
		.axi_master_b_ready(axi_master_b_ready)
	);
endmodule
