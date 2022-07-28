module axi_slice_wrap 
#(
    parameter AXI_ADDR_WIDTH = 32,
    parameter AXI_DATA_WIDTH = 64,
    parameter AXI_USER_WIDTH = 6,
    parameter AXI_ID_WIDTH   = 6,
    parameter SLICE_DEPTH    = 2
)
(
	clk_i,
	rst_ni,
	test_en_i,
	s00_aw_addr,
	s00_aw_prot,
	s00_aw_region,
	s00_aw_len,
	s00_aw_size,
	s00_aw_burst,
	s00_aw_lock,
	s00_aw_cache,
	s00_aw_qos,
	s00_aw_id,
	s00_aw_user,
	s00_aw_ready,
	s00_aw_valid,
	s00_ar_addr,
	s00_ar_prot,
	s00_ar_region,
	s00_ar_len,
	s00_ar_size,
	s00_ar_burst,
	s00_ar_lock,
	s00_ar_cache,
	s00_ar_qos,
	s00_ar_id,
	s00_ar_user,
	s00_ar_ready,
	s00_ar_valid,
	s00_w_valid,
	s00_w_data,
	s00_w_strb,
	s00_w_user,
	s00_w_last,
	s00_w_ready,
	s00_r_data,
	s00_r_resp,
	s00_r_last,
	s00_r_id,
	s00_r_user,
	s00_r_ready,
	s00_r_valid,
	s00_b_resp,
	s00_b_id,
	s00_b_user,
	s00_b_ready,
	s00_b_valid,
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
	//parameter AXI_DATA_WIDTH = 64;
	//parameter AXI_USER_WIDTH = 6;
	//parameter AXI_ID_WIDTH = 6;
	//parameter SLICE_DEPTH = 2;
	parameter AXI_STRB_WIDTH = AXI_DATA_WIDTH / 8;
	input wire clk_i;
	input wire rst_ni;
	input wire test_en_i;
	input wire [AXI_ADDR_WIDTH - 1:0] s00_aw_addr;
	input wire [2:0] s00_aw_prot;
	input wire [3:0] s00_aw_region;
	input wire [7:0] s00_aw_len;
	input wire [2:0] s00_aw_size;
	input wire [1:0] s00_aw_burst;
	input wire s00_aw_lock;
	input wire [3:0] s00_aw_cache;
	input wire [3:0] s00_aw_qos;
	input wire [AXI_ID_WIDTH - 1:0] s00_aw_id;
	input wire [AXI_USER_WIDTH - 1:0] s00_aw_user;
	output wire s00_aw_ready;
	input wire s00_aw_valid;
	input wire [AXI_ADDR_WIDTH - 1:0] s00_ar_addr;
	input wire [2:0] s00_ar_prot;
	input wire [3:0] s00_ar_region;
	input wire [7:0] s00_ar_len;
	input wire [2:0] s00_ar_size;
	input wire [1:0] s00_ar_burst;
	input wire s00_ar_lock;
	input wire [3:0] s00_ar_cache;
	input wire [3:0] s00_ar_qos;
	input wire [AXI_ID_WIDTH - 1:0] s00_ar_id;
	input wire [AXI_USER_WIDTH - 1:0] s00_ar_user;
	output wire s00_ar_ready;
	input wire s00_ar_valid;
	input wire s00_w_valid;
	input wire [AXI_DATA_WIDTH - 1:0] s00_w_data;
	input wire [AXI_STRB_WIDTH - 1:0] s00_w_strb;
	input wire [AXI_USER_WIDTH - 1:0] s00_w_user;
	input wire s00_w_last;
	output wire s00_w_ready;
	output wire [AXI_DATA_WIDTH - 1:0] s00_r_data;
	output wire [1:0] s00_r_resp;
	output wire s00_r_last;
	output wire [AXI_ID_WIDTH - 1:0] s00_r_id;
	output wire [AXI_USER_WIDTH - 1:0] s00_r_user;
	input wire s00_r_ready;
	output wire s00_r_valid;
	output wire [1:0] s00_b_resp;
	output wire [AXI_ID_WIDTH - 1:0] s00_b_id;
	output wire [AXI_USER_WIDTH - 1:0] s00_b_user;
	input wire s00_b_ready;
	output wire s00_b_valid;
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
	generate
		if (SLICE_DEPTH > 1) begin : WITH_SLICE
			axi_slice #(
				.AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
				.AXI_DATA_WIDTH(AXI_DATA_WIDTH),
				.AXI_USER_WIDTH(AXI_USER_WIDTH),
				.AXI_ID_WIDTH(AXI_ID_WIDTH),
				.SLICE_DEPTH(SLICE_DEPTH)
			) axi_slice_i(
				.clk_i(clk_i),
				.rst_ni(rst_ni),
				.test_en_i(test_en_i),
				.axi_slave_aw_valid_i(s00_aw_valid),
				.axi_slave_aw_addr_i(s00_aw_addr),
				.axi_slave_aw_prot_i(s00_aw_prot),
				.axi_slave_aw_region_i(s00_aw_region),
				.axi_slave_aw_len_i(s00_aw_len),
				.axi_slave_aw_size_i(s00_aw_size),
				.axi_slave_aw_burst_i(s00_aw_burst),
				.axi_slave_aw_lock_i(s00_aw_lock),
				.axi_slave_aw_cache_i(s00_aw_cache),
				.axi_slave_aw_qos_i(s00_aw_qos),
				.axi_slave_aw_id_i(s00_aw_id[AXI_ID_WIDTH - 1:0]),
				.axi_slave_aw_user_i(s00_aw_user),
				.axi_slave_aw_ready_o(s00_aw_ready),
				.axi_slave_ar_valid_i(s00_ar_valid),
				.axi_slave_ar_addr_i(s00_ar_addr),
				.axi_slave_ar_prot_i(s00_ar_prot),
				.axi_slave_ar_region_i(s00_ar_region),
				.axi_slave_ar_len_i(s00_ar_len),
				.axi_slave_ar_size_i(s00_ar_size),
				.axi_slave_ar_burst_i(s00_ar_burst),
				.axi_slave_ar_lock_i(s00_ar_lock),
				.axi_slave_ar_cache_i(s00_ar_cache),
				.axi_slave_ar_qos_i(s00_ar_qos),
				.axi_slave_ar_id_i(s00_ar_id[AXI_ID_WIDTH - 1:0]),
				.axi_slave_ar_user_i(s00_ar_user),
				.axi_slave_ar_ready_o(s00_ar_ready),
				.axi_slave_w_valid_i(s00_w_valid),
				.axi_slave_w_data_i(s00_w_data),
				.axi_slave_w_strb_i(s00_w_strb),
				.axi_slave_w_user_i(s00_w_user),
				.axi_slave_w_last_i(s00_w_last),
				.axi_slave_w_ready_o(s00_w_ready),
				.axi_slave_r_valid_o(s00_r_valid),
				.axi_slave_r_data_o(s00_r_data),
				.axi_slave_r_resp_o(s00_r_resp),
				.axi_slave_r_last_o(s00_r_last),
				.axi_slave_r_id_o(s00_r_id[AXI_ID_WIDTH - 1:0]),
				.axi_slave_r_user_o(s00_r_user),
				.axi_slave_r_ready_i(s00_r_ready),
				.axi_slave_b_valid_o(s00_b_valid),
				.axi_slave_b_resp_o(s00_b_resp),
				.axi_slave_b_id_o(s00_b_id[AXI_ID_WIDTH - 1:0]),
				.axi_slave_b_user_o(s00_b_user),
				.axi_slave_b_ready_i(s00_b_ready),
				.axi_master_aw_valid_o(m00_aw_valid),
				.axi_master_aw_addr_o(m00_aw_addr),
				.axi_master_aw_prot_o(m00_aw_prot),
				.axi_master_aw_region_o(m00_aw_region),
				.axi_master_aw_len_o(m00_aw_len),
				.axi_master_aw_size_o(m00_aw_size),
				.axi_master_aw_burst_o(m00_aw_burst),
				.axi_master_aw_lock_o(m00_aw_lock),
				.axi_master_aw_cache_o(m00_aw_cache),
				.axi_master_aw_qos_o(m00_aw_qos),
				.axi_master_aw_id_o(m00_aw_id[AXI_ID_WIDTH - 1:0]),
				.axi_master_aw_user_o(m00_aw_user),
				.axi_master_aw_ready_i(m00_aw_ready),
				.axi_master_ar_valid_o(m00_ar_valid),
				.axi_master_ar_addr_o(m00_ar_addr),
				.axi_master_ar_prot_o(m00_ar_prot),
				.axi_master_ar_region_o(m00_ar_region),
				.axi_master_ar_len_o(m00_ar_len),
				.axi_master_ar_size_o(m00_ar_size),
				.axi_master_ar_burst_o(m00_ar_burst),
				.axi_master_ar_lock_o(m00_ar_lock),
				.axi_master_ar_cache_o(m00_ar_cache),
				.axi_master_ar_qos_o(m00_ar_qos),
				.axi_master_ar_id_o(m00_ar_id[AXI_ID_WIDTH - 1:0]),
				.axi_master_ar_user_o(m00_ar_user),
				.axi_master_ar_ready_i(m00_ar_ready),
				.axi_master_w_valid_o(m00_w_valid),
				.axi_master_w_data_o(m00_w_data),
				.axi_master_w_strb_o(m00_w_strb),
				.axi_master_w_user_o(m00_w_user),
				.axi_master_w_last_o(m00_w_last),
				.axi_master_w_ready_i(m00_w_ready),
				.axi_master_r_valid_i(m00_r_valid),
				.axi_master_r_data_i(m00_r_data),
				.axi_master_r_resp_i(m00_r_resp),
				.axi_master_r_last_i(m00_r_last),
				.axi_master_r_id_i(m00_r_id[AXI_ID_WIDTH - 1:0]),
				.axi_master_r_user_i(m00_r_user),
				.axi_master_r_ready_o(m00_r_ready),
				.axi_master_b_valid_i(m00_b_valid),
				.axi_master_b_resp_i(m00_b_resp),
				.axi_master_b_id_i(m00_b_id[AXI_ID_WIDTH - 1:0]),
				.axi_master_b_user_i(m00_b_user),
				.axi_master_b_ready_o(m00_b_ready)
			);
		end
		else begin : NO_SLICE
			assign m00_aw_valid = s00_aw_valid;
			assign m00_aw_addr = s00_aw_addr;
			assign m00_aw_prot = s00_aw_prot;
			assign m00_aw_region = s00_aw_region;
			assign m00_aw_len = s00_aw_len;
			assign m00_aw_size = s00_aw_size;
			assign m00_aw_burst = s00_aw_burst;
			assign m00_aw_lock = s00_aw_lock;
			assign m00_aw_cache = s00_aw_cache;
			assign m00_aw_qos = s00_aw_qos;
			assign m00_aw_id = s00_aw_id;
			assign m00_aw_user = s00_aw_user;
			assign s00_aw_ready = m00_aw_ready;
			assign m00_ar_valid = s00_ar_valid;
			assign m00_ar_addr = s00_ar_addr;
			assign m00_ar_prot = s00_ar_prot;
			assign m00_ar_region = s00_ar_region;
			assign m00_ar_len = s00_ar_len;
			assign m00_ar_size = s00_ar_size;
			assign m00_ar_burst = s00_ar_burst;
			assign m00_ar_lock = s00_ar_lock;
			assign m00_ar_cache = s00_ar_cache;
			assign m00_ar_qos = s00_ar_qos;
			assign m00_ar_id = s00_ar_id;
			assign m00_ar_user = s00_ar_user;
			assign s00_ar_ready = m00_ar_ready;
			assign m00_w_valid = s00_w_valid;
			assign m00_w_data = s00_w_data;
			assign m00_w_strb = s00_w_strb;
			assign m00_w_user = s00_w_user;
			assign m00_w_last = s00_w_last;
			assign s00_w_ready = m00_w_ready;
			assign s00_r_valid = m00_r_valid;
			assign s00_r_data = m00_r_data;
			assign s00_r_resp = m00_r_resp;
			assign s00_r_last = m00_r_last;
			assign s00_r_id = m00_r_id;
			assign s00_r_user = m00_r_user;
			assign m00_r_ready = s00_r_ready;
			assign s00_b_valid = m00_b_valid;
			assign s00_b_resp = m00_b_resp;
			assign s00_b_id = m00_b_id;
			assign s00_b_user = m00_b_user;
			assign m00_b_ready = s00_b_ready;
		end
	endgenerate
endmodule
