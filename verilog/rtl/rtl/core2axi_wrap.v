module core2axi_wrap 
#(
    parameter AXI_ADDR_WIDTH   = 32,
    parameter AXI_DATA_WIDTH   = 32,
    parameter AXI_USER_WIDTH   = 6,
    parameter AXI_ID_WIDTH     = 6,
    parameter REGISTERED_GRANT = "FALSE"
)
(
	clk_i,
	rst_ni,
	data_req_i,
	data_gnt_o,
	data_rvalid_o,
	data_addr_i,
	data_we_i,
	data_be_i,
	data_rdata_o,
	data_wdata_i,
	m00_aw_addr,
	m00_aw_prot,
	m00_aw_region,
	m00_aw_len,
	m00_aw_size,
	m00_aw_burst,
	m00_aw_lock,
	m00_aw_cache,
	m00_aw_qos,
	m00_aw_id,
	m00_aw_user,
	m00_aw_ready,
	m00_aw_valid,
	m00_ar_addr,
	m00_ar_prot,
	m00_ar_region,
	m00_ar_len,
	m00_ar_size,
	m00_ar_burst,
	m00_ar_lock,
	m00_ar_cache,
	m00_ar_qos,
	m00_ar_id,
	m00_ar_user,
	m00_ar_ready,
	m00_ar_valid,
	m00_w_valid,
	m00_w_data,
	m00_w_strb,
	m00_w_user,
	m00_w_last,
	m00_w_ready,
	m00_r_data,
	m00_r_resp,
	m00_r_last,
	m00_r_id,
	m00_r_user,
	m00_r_ready,
	m00_r_valid,
	m00_b_resp,
	m00_b_id,
	m00_b_user,
	m00_b_ready,
	m00_b_valid
);
	//parameter AXI_ADDR_WIDTH = 32;
	//parameter AXI_DATA_WIDTH = 32;
	//parameter AXI_USER_WIDTH = 6;
	//parameter AXI_ID_WIDTH = 6;
	parameter AXI_STRB_WIDTH = AXI_DATA_WIDTH / 8;
	//parameter REGISTERED_GRANT = "FALSE";
	input wire clk_i;
	input wire rst_ni;
	input wire data_req_i;
	output wire data_gnt_o;
	output wire data_rvalid_o;
	input wire [AXI_ADDR_WIDTH - 1:0] data_addr_i;
	input wire data_we_i;
	input wire [3:0] data_be_i;
	output wire [31:0] data_rdata_o;
	input wire [31:0] data_wdata_i;
	output wire [AXI_ADDR_WIDTH - 1:0] m00_aw_addr;
	output wire [2:0] m00_aw_prot;
	output wire [3:0] m00_aw_region;
	output wire [7:0] m00_aw_len;
	output wire [2:0] m00_aw_size;
	output wire [1:0] m00_aw_burst;
	output wire m00_aw_lock;
	output wire [3:0] m00_aw_cache;
	output wire [3:0] m00_aw_qos;
	output wire [AXI_ID_WIDTH - 1:0] m00_aw_id;
	output wire [AXI_USER_WIDTH - 1:0] m00_aw_user;
	input wire m00_aw_ready;
	output wire m00_aw_valid;
	output wire [AXI_ADDR_WIDTH - 1:0] m00_ar_addr;
	output wire [2:0] m00_ar_prot;
	output wire [3:0] m00_ar_region;
	output wire [7:0] m00_ar_len;
	output wire [2:0] m00_ar_size;
	output wire [1:0] m00_ar_burst;
	output wire m00_ar_lock;
	output wire [3:0] m00_ar_cache;
	output wire [3:0] m00_ar_qos;
	output wire [AXI_ID_WIDTH - 1:0] m00_ar_id;
	output wire [AXI_USER_WIDTH - 1:0] m00_ar_user;
	input wire m00_ar_ready;
	output wire m00_ar_valid;
	output wire m00_w_valid;
	output wire [AXI_DATA_WIDTH - 1:0] m00_w_data;
	output wire [AXI_STRB_WIDTH - 1:0] m00_w_strb;
	output wire [AXI_USER_WIDTH - 1:0] m00_w_user;
	output wire m00_w_last;
	input wire m00_w_ready;
	input wire [AXI_DATA_WIDTH - 1:0] m00_r_data;
	input wire [1:0] m00_r_resp;
	input wire m00_r_last;
	input wire [AXI_ID_WIDTH - 1:0] m00_r_id;
	input wire [AXI_USER_WIDTH - 1:0] m00_r_user;
	output wire m00_r_ready;
	input wire m00_r_valid;
	input wire [1:0] m00_b_resp;
	input wire [AXI_ID_WIDTH - 1:0] m00_b_id;
	input wire [AXI_USER_WIDTH - 1:0] m00_b_user;
	output wire m00_b_ready;
	input wire m00_b_valid;
	core2axi #(
		.AXI4_ADDRESS_WIDTH(AXI_ADDR_WIDTH),
		.AXI4_RDATA_WIDTH(AXI_DATA_WIDTH),
		.AXI4_WDATA_WIDTH(AXI_DATA_WIDTH),
		.AXI4_ID_WIDTH(AXI_ID_WIDTH),
		.AXI4_USER_WIDTH(AXI_USER_WIDTH),
		.REGISTERED_GRANT(REGISTERED_GRANT)
	) core2axi_i(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.data_req_i(data_req_i),
		.data_gnt_o(data_gnt_o),
		.data_rvalid_o(data_rvalid_o),
		.data_addr_i(data_addr_i),
		.data_we_i(data_we_i),
		.data_be_i(data_be_i),
		.data_rdata_o(data_rdata_o),
		.data_wdata_i(data_wdata_i),
		.aw_id_o(m00_aw_id),
		.aw_addr_o(m00_aw_addr),
		.aw_len_o(m00_aw_len),
		.aw_size_o(m00_aw_size),
		.aw_burst_o(m00_aw_burst),
		.aw_lock_o(m00_aw_lock),
		.aw_cache_o(m00_aw_cache),
		.aw_prot_o(m00_aw_prot),
		.aw_region_o(m00_aw_region),
		.aw_user_o(m00_aw_user),
		.aw_qos_o(m00_aw_qos),
		.aw_valid_o(m00_aw_valid),
		.aw_ready_i(m00_aw_ready),
		.w_data_o(m00_w_data),
		.w_strb_o(m00_w_strb),
		.w_last_o(m00_w_last),
		.w_user_o(m00_w_user),
		.w_valid_o(m00_w_valid),
		.w_ready_i(m00_w_ready),
		.b_id_i(m00_b_id),
		.b_resp_i(m00_b_resp),
		.b_valid_i(m00_b_valid),
		.b_user_i(m00_b_user),
		.b_ready_o(m00_b_ready),
		.ar_id_o(m00_ar_id),
		.ar_addr_o(m00_ar_addr),
		.ar_len_o(m00_ar_len),
		.ar_size_o(m00_ar_size),
		.ar_burst_o(m00_ar_burst),
		.ar_lock_o(m00_ar_lock),
		.ar_cache_o(m00_ar_cache),
		.ar_prot_o(m00_ar_prot),
		.ar_region_o(m00_ar_region),
		.ar_user_o(m00_ar_user),
		.ar_qos_o(m00_ar_qos),
		.ar_valid_o(m00_ar_valid),
		.ar_ready_i(m00_ar_ready),
		.r_id_i(m00_r_id),
		.r_data_i(m00_r_data),
		.r_resp_i(m00_r_resp),
		.r_last_i(m00_r_last),
		.r_user_i(m00_r_user),
		.r_valid_i(m00_r_valid),
		.r_ready_o(m00_r_ready)
	);
endmodule
