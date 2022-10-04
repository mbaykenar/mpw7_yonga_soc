module adbg_top 
#(
	parameter NB_CORES       = 4,
	parameter AXI_ADDR_WIDTH = 32,
	parameter AXI_DATA_WIDTH = 64,
	parameter AXI_USER_WIDTH = 6,
	parameter AXI_ID_WIDTH   = 3
)
(
	tck_i,
	tdi_i,
	tdo_o,
	trstn_i,
	shift_dr_i,
	pause_dr_i,
	update_dr_i,
	capture_dr_i,
	debug_select_i,
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
	input wire tck_i;
	input wire tdi_i;
	output reg tdo_o;
	input wire trstn_i;
	input wire shift_dr_i;
	input wire pause_dr_i;
	input wire update_dr_i;
	input wire capture_dr_i;
	input wire debug_select_i;
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
	wire tdo_axi;
	wire tdo_cpu;
	reg [63:0] input_shift_reg;
	reg [4:0] module_id_reg;
	wire select_cmd;
	wire [4:0] module_id_in;
	reg [1:0] module_selects;
	wire select_inhibit;
	wire [1:0] module_inhibit;
	integer j;
	assign select_cmd = input_shift_reg[63];
	assign module_id_in = input_shift_reg[62:58];
	always @(posedge tck_i or negedge trstn_i)
		if (~trstn_i)
			module_id_reg <= 5'h00;
		else if (((debug_select_i && select_cmd) && update_dr_i) && !select_inhibit)
			module_id_reg <= module_id_in;
	always @(*)
		if (module_id_reg == 0)
			module_selects = 2'b01;
		else
			module_selects = 2'b10;
	always @(posedge tck_i or negedge trstn_i)
		if (~trstn_i)
			input_shift_reg <= 'h0;
		else if (debug_select_i && shift_dr_i)
			input_shift_reg <= {tdi_i, input_shift_reg[63:1]};
	adbg_axi_module #(
		.AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
		.AXI_DATA_WIDTH(AXI_DATA_WIDTH),
		.AXI_USER_WIDTH(AXI_USER_WIDTH),
		.AXI_ID_WIDTH(AXI_ID_WIDTH)
	) i_dbg_axi(
		.tck_i(tck_i),
		.module_tdo_o(tdo_axi),
		.tdi_i(tdi_i),
		.capture_dr_i(capture_dr_i),
		.shift_dr_i(shift_dr_i),
		.update_dr_i(update_dr_i),
		.data_register_i(input_shift_reg),
		.module_select_i(module_selects[0]),
		.top_inhibit_o(module_inhibit[0]),
		.trstn_i(trstn_i),
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
	adbg_or1k_module #(.NB_CORES(NB_CORES)) i_dbg_cpu_or1k(
		.tck_i(tck_i),
		.module_tdo_o(tdo_cpu),
		.tdi_i(tdi_i),
		.capture_dr_i(capture_dr_i),
		.shift_dr_i(shift_dr_i),
		.update_dr_i(update_dr_i),
		.data_register_i(input_shift_reg[63:7]),
		.module_select_i(module_selects[1]),
		.top_inhibit_o(module_inhibit[1]),
		.trstn_i(trstn_i),
		.cpu_clk_i(axi_aclk),
		.cpu_rstn_i(axi_aresetn),
		.cpu_addr_o(cpu_addr_o),
		.cpu_data_i(cpu_data_i),
		.cpu_data_o(cpu_data_o),
		.cpu_bp_i(cpu_bp_i),
		.cpu_stall_o(cpu_stall_o),
		.cpu_stb_o(cpu_stb_o),
		.cpu_we_o(cpu_we_o),
		.cpu_ack_i(cpu_ack_i)
	);
	assign select_inhibit = |module_inhibit;
	always @(module_id_reg or tdo_axi or tdo_cpu)
		if (module_id_reg == 0)
			tdo_o <= tdo_axi;
		else if (module_id_reg == 1)
			tdo_o <= tdo_cpu;
		else
			tdo_o <= 1'b0;
endmodule
