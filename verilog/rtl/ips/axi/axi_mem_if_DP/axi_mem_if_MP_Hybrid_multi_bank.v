module axi_mem_if_MP_Hybrid_multi_bank 
#(
    parameter AXI4_ADDRESS_WIDTH = 32,
    parameter AXI4_RDATA_WIDTH   = 64,
    parameter AXI4_WDATA_WIDTH   = 64,
    parameter AXI4_ID_WIDTH      = 16,
    parameter AXI4_USER_WIDTH    = 10,
    parameter AXI_NUMBYTES       = AXI4_WDATA_WIDTH/8,

    parameter MEM_ADDR_WIDTH     = 13,
    parameter BUFF_DEPTH_SLAVE   = 4,
    parameter NB_L2_BANKS        = 4,

    parameter N_CH0              = 1,
    parameter N_CH1              = 3
)
(
	ACLK,
	ARESETn,
	test_en_i,
	CH0_AWID_i,
	CH0_AWADDR_i,
	CH0_AWLEN_i,
	CH0_AWSIZE_i,
	CH0_AWBURST_i,
	CH0_AWLOCK_i,
	CH0_AWCACHE_i,
	CH0_AWPROT_i,
	CH0_AWREGION_i,
	CH0_AWUSER_i,
	CH0_AWQOS_i,
	CH0_AWVALID_i,
	CH0_AWREADY_o,
	CH0_WDATA_i,
	CH0_WSTRB_i,
	CH0_WLAST_i,
	CH0_WUSER_i,
	CH0_WVALID_i,
	CH0_WREADY_o,
	CH0_BID_o,
	CH0_BRESP_o,
	CH0_BVALID_o,
	CH0_BUSER_o,
	CH0_BREADY_i,
	CH0_ARID_i,
	CH0_ARADDR_i,
	CH0_ARLEN_i,
	CH0_ARSIZE_i,
	CH0_ARBURST_i,
	CH0_ARLOCK_i,
	CH0_ARCACHE_i,
	CH0_ARPROT_i,
	CH0_ARREGION_i,
	CH0_ARUSER_i,
	CH0_ARQOS_i,
	CH0_ARVALID_i,
	CH0_ARREADY_o,
	CH0_RID_o,
	CH0_RDATA_o,
	CH0_RRESP_o,
	CH0_RLAST_o,
	CH0_RUSER_o,
	CH0_RVALID_o,
	CH0_RREADY_i,
	CH1_req_i,
	CH1_gnt_o,
	CH1_wen_i,
	CH1_addr_i,
	CH1_wdata_i,
	CH1_be_i,
	CH1_rdata_o,
	CH1_rvalid_o,
	CEN,
	WEN,
	A,
	D,
	BE,
	Q
);
	//parameter AXI4_ADDRESS_WIDTH = 32;
	//parameter AXI4_RDATA_WIDTH = 64;
	//parameter AXI4_WDATA_WIDTH = 64;
	//parameter AXI4_ID_WIDTH = 16;
	//parameter AXI4_USER_WIDTH = 10;
	//parameter AXI_NUMBYTES = AXI4_WDATA_WIDTH / 8;
	//parameter MEM_ADDR_WIDTH = 13;
	//parameter BUFF_DEPTH_SLAVE = 4;
	//parameter NB_L2_BANKS = 4;
	//parameter N_CH0 = 1;
	//parameter N_CH1 = 3;
	input wire ACLK;
	input wire ARESETn;
	input wire test_en_i;
	input wire [(N_CH0 * AXI4_ID_WIDTH) - 1:0] CH0_AWID_i;
	input wire [(N_CH0 * AXI4_ADDRESS_WIDTH) - 1:0] CH0_AWADDR_i;
	input wire [(N_CH0 * 8) - 1:0] CH0_AWLEN_i;
	input wire [(N_CH0 * 3) - 1:0] CH0_AWSIZE_i;
	input wire [(N_CH0 * 2) - 1:0] CH0_AWBURST_i;
	input wire [N_CH0 - 1:0] CH0_AWLOCK_i;
	input wire [(N_CH0 * 4) - 1:0] CH0_AWCACHE_i;
	input wire [(N_CH0 * 3) - 1:0] CH0_AWPROT_i;
	input wire [(N_CH0 * 4) - 1:0] CH0_AWREGION_i;
	input wire [(N_CH0 * AXI4_USER_WIDTH) - 1:0] CH0_AWUSER_i;
	input wire [(N_CH0 * 4) - 1:0] CH0_AWQOS_i;
	input wire [N_CH0 - 1:0] CH0_AWVALID_i;
	output wire [N_CH0 - 1:0] CH0_AWREADY_o;
	input wire [((N_CH0 * AXI_NUMBYTES) * 8) - 1:0] CH0_WDATA_i;
	input wire [(N_CH0 * AXI_NUMBYTES) - 1:0] CH0_WSTRB_i;
	input wire [N_CH0 - 1:0] CH0_WLAST_i;
	input wire [(N_CH0 * AXI4_USER_WIDTH) - 1:0] CH0_WUSER_i;
	input wire [N_CH0 - 1:0] CH0_WVALID_i;
	output wire [N_CH0 - 1:0] CH0_WREADY_o;
	output wire [(N_CH0 * AXI4_ID_WIDTH) - 1:0] CH0_BID_o;
	output wire [(N_CH0 * 2) - 1:0] CH0_BRESP_o;
	output wire [N_CH0 - 1:0] CH0_BVALID_o;
	output wire [(N_CH0 * AXI4_USER_WIDTH) - 1:0] CH0_BUSER_o;
	input wire [N_CH0 - 1:0] CH0_BREADY_i;
	input wire [(N_CH0 * AXI4_ID_WIDTH) - 1:0] CH0_ARID_i;
	input wire [(N_CH0 * AXI4_ADDRESS_WIDTH) - 1:0] CH0_ARADDR_i;
	input wire [(N_CH0 * 8) - 1:0] CH0_ARLEN_i;
	input wire [(N_CH0 * 3) - 1:0] CH0_ARSIZE_i;
	input wire [(N_CH0 * 2) - 1:0] CH0_ARBURST_i;
	input wire [N_CH0 - 1:0] CH0_ARLOCK_i;
	input wire [(N_CH0 * 4) - 1:0] CH0_ARCACHE_i;
	input wire [(N_CH0 * 3) - 1:0] CH0_ARPROT_i;
	input wire [(N_CH0 * 4) - 1:0] CH0_ARREGION_i;
	input wire [(N_CH0 * AXI4_USER_WIDTH) - 1:0] CH0_ARUSER_i;
	input wire [(N_CH0 * 4) - 1:0] CH0_ARQOS_i;
	input wire [N_CH0 - 1:0] CH0_ARVALID_i;
	output wire [N_CH0 - 1:0] CH0_ARREADY_o;
	output wire [(N_CH0 * AXI4_ID_WIDTH) - 1:0] CH0_RID_o;
	output wire [(N_CH0 * AXI4_RDATA_WIDTH) - 1:0] CH0_RDATA_o;
	output wire [(N_CH0 * 2) - 1:0] CH0_RRESP_o;
	output wire [N_CH0 - 1:0] CH0_RLAST_o;
	output wire [(N_CH0 * AXI4_USER_WIDTH) - 1:0] CH0_RUSER_o;
	output wire [N_CH0 - 1:0] CH0_RVALID_o;
	input wire [N_CH0 - 1:0] CH0_RREADY_i;
	input wire [N_CH1 - 1:0] CH1_req_i;
	output wire [N_CH1 - 1:0] CH1_gnt_o;
	input wire [N_CH1 - 1:0] CH1_wen_i;
	input wire [(N_CH1 * (MEM_ADDR_WIDTH + $clog2(NB_L2_BANKS))) - 1:0] CH1_addr_i;
	input wire [(N_CH1 * AXI4_WDATA_WIDTH) - 1:0] CH1_wdata_i;
	input wire [(N_CH1 * AXI_NUMBYTES) - 1:0] CH1_be_i;
	output wire [(N_CH1 * AXI4_RDATA_WIDTH) - 1:0] CH1_rdata_o;
	output wire [N_CH1 - 1:0] CH1_rvalid_o;
	output wire [NB_L2_BANKS - 1:0] CEN;
	output wire [NB_L2_BANKS - 1:0] WEN;
	output wire [(NB_L2_BANKS * MEM_ADDR_WIDTH) - 1:0] A;
	output wire [(NB_L2_BANKS * AXI4_WDATA_WIDTH) - 1:0] D;
	output wire [(NB_L2_BANKS * AXI_NUMBYTES) - 1:0] BE;
	input wire [(NB_L2_BANKS * AXI4_RDATA_WIDTH) - 1:0] Q;
	localparam OFFSET_BIT = $clog2(AXI4_WDATA_WIDTH) - 3;
	wire [(N_CH0 * AXI4_ID_WIDTH) - 1:0] CH0_AWID;
	wire [(N_CH0 * AXI4_ADDRESS_WIDTH) - 1:0] CH0_AWADDR;
	wire [(N_CH0 * 8) - 1:0] CH0_AWLEN;
	wire [(N_CH0 * 3) - 1:0] CH0_AWSIZE;
	wire [(N_CH0 * 2) - 1:0] CH0_AWBURST;
	wire [N_CH0 - 1:0] CH0_AWLOCK;
	wire [(N_CH0 * 4) - 1:0] CH0_AWCACHE;
	wire [(N_CH0 * 3) - 1:0] CH0_AWPROT;
	wire [(N_CH0 * 4) - 1:0] CH0_AWREGION;
	wire [(N_CH0 * AXI4_USER_WIDTH) - 1:0] CH0_AWUSER;
	wire [(N_CH0 * 4) - 1:0] CH0_AWQOS;
	wire [N_CH0 - 1:0] CH0_AWVALID;
	wire [N_CH0 - 1:0] CH0_AWREADY;
	wire [((N_CH0 * AXI_NUMBYTES) * 8) - 1:0] CH0_WDATA;
	wire [(N_CH0 * AXI_NUMBYTES) - 1:0] CH0_WSTRB;
	wire [N_CH0 - 1:0] CH0_WLAST;
	wire [(N_CH0 * AXI4_USER_WIDTH) - 1:0] CH0_WUSER;
	wire [N_CH0 - 1:0] CH0_WVALID;
	wire [N_CH0 - 1:0] CH0_WREADY;
	wire [(N_CH0 * AXI4_ID_WIDTH) - 1:0] CH0_BID;
	wire [(N_CH0 * 2) - 1:0] CH0_BRESP;
	wire [N_CH0 - 1:0] CH0_BVALID;
	wire [(N_CH0 * AXI4_USER_WIDTH) - 1:0] CH0_BUSER;
	wire [N_CH0 - 1:0] CH0_BREADY;
	wire [(N_CH0 * AXI4_ID_WIDTH) - 1:0] CH0_ARID;
	wire [(N_CH0 * AXI4_ADDRESS_WIDTH) - 1:0] CH0_ARADDR;
	wire [(N_CH0 * 8) - 1:0] CH0_ARLEN;
	wire [(N_CH0 * 3) - 1:0] CH0_ARSIZE;
	wire [(N_CH0 * 2) - 1:0] CH0_ARBURST;
	wire [N_CH0 - 1:0] CH0_ARLOCK;
	wire [(N_CH0 * 4) - 1:0] CH0_ARCACHE;
	wire [(N_CH0 * 3) - 1:0] CH0_ARPROT;
	wire [(N_CH0 * 4) - 1:0] CH0_ARREGION;
	wire [(N_CH0 * AXI4_USER_WIDTH) - 1:0] CH0_ARUSER;
	wire [(N_CH0 * 4) - 1:0] CH0_ARQOS;
	wire [N_CH0 - 1:0] CH0_ARVALID;
	wire [N_CH0 - 1:0] CH0_ARREADY;
	wire [(N_CH0 * AXI4_ID_WIDTH) - 1:0] CH0_RID;
	wire [(N_CH0 * AXI4_RDATA_WIDTH) - 1:0] CH0_RDATA;
	wire [(N_CH0 * 2) - 1:0] CH0_RRESP;
	wire [N_CH0 - 1:0] CH0_RLAST;
	wire [(N_CH0 * AXI4_USER_WIDTH) - 1:0] CH0_RUSER;
	wire [N_CH0 - 1:0] CH0_RVALID;
	wire [N_CH0 - 1:0] CH0_RREADY;
	wire [N_CH0 - 1:0] valid_R_CH0;
	wire [N_CH0 - 1:0] valid_W_CH0;
	wire [N_CH0 - 1:0] grant_R_CH0;
	wire [N_CH0 - 1:0] grant_W_CH0;
	wire [N_CH1 - 1:0] valid_CH1;
	wire [N_CH0 - 1:0] CH0_W_cen;
	wire [N_CH0 - 1:0] CH0_R_cen;
	wire [N_CH0 - 1:0] CH0_W_wen;
	wire [N_CH0 - 1:0] CH0_R_wen;
	wire [(N_CH0 * (MEM_ADDR_WIDTH + $clog2(NB_L2_BANKS))) - 1:0] CH0_W_addr;
	wire [(N_CH0 * (MEM_ADDR_WIDTH + $clog2(NB_L2_BANKS))) - 1:0] CH0_R_addr;
	wire [(N_CH0 * AXI4_WDATA_WIDTH) - 1:0] CH0_W_wdata;
	wire [(N_CH0 * AXI4_WDATA_WIDTH) - 1:0] CH0_R_wdata;
	wire [(N_CH0 * AXI_NUMBYTES) - 1:0] CH0_W_be;
	wire [(N_CH0 * AXI_NUMBYTES) - 1:0] CH0_R_be;
	wire [(N_CH0 * AXI4_WDATA_WIDTH) - 1:0] CH0_W_rdata;
	wire [(N_CH0 * AXI4_WDATA_WIDTH) - 1:0] CH0_R_rdata;
	wire [((2 * N_CH0) + N_CH1) - 1:0] req_int;
	wire [(((2 * N_CH0) + N_CH1) * ((MEM_ADDR_WIDTH + 3) + $clog2(NB_L2_BANKS))) - 1:0] add_int;
	wire [((2 * N_CH0) + N_CH1) - 1:0] wen_int;
	wire [(((2 * N_CH0) + N_CH1) * AXI4_WDATA_WIDTH) - 1:0] wdata_int;
	wire [(((2 * N_CH0) + N_CH1) * (AXI4_WDATA_WIDTH / 8)) - 1:0] be_int;
	wire [((2 * N_CH0) + N_CH1) - 1:0] gnt_int;
	wire [(((2 * N_CH0) + N_CH1) * AXI4_WDATA_WIDTH) - 1:0] r_rdata_int;
	wire [((2 * N_CH0) + N_CH1) - 1:0] r_valid_int;
	wire [(NB_L2_BANKS * AXI4_WDATA_WIDTH) - 1:0] mem_wdata;
	wire [(NB_L2_BANKS * MEM_ADDR_WIDTH) - 1:0] mem_add;
	wire [NB_L2_BANKS - 1:0] mem_req;
	wire [NB_L2_BANKS - 1:0] mem_wen;
	wire [(NB_L2_BANKS * (AXI4_WDATA_WIDTH / 8)) - 1:0] mem_be;
	wire [(NB_L2_BANKS * AXI4_WDATA_WIDTH) - 1:0] mem_rdata;
	genvar i;
	generate
		for (i = 0; i < N_CH0; i = i + 1) begin : AW_BUF
			axi_aw_buffer #(
				.ID_WIDTH(AXI4_ID_WIDTH),
				.ADDR_WIDTH(AXI4_ADDRESS_WIDTH),
				.USER_WIDTH(AXI4_USER_WIDTH),
				.BUFFER_DEPTH(BUFF_DEPTH_SLAVE)
			) Slave_aw_buffer_LP(
				.clk_i(ACLK),
				.rst_ni(ARESETn),
				.test_en_i(test_en_i),
				.slave_valid_i(CH0_AWVALID_i[i]),
				.slave_addr_i(CH0_AWADDR_i[i * AXI4_ADDRESS_WIDTH+:AXI4_ADDRESS_WIDTH]),
				.slave_prot_i(CH0_AWPROT_i[i * 3+:3]),
				.slave_region_i(CH0_AWREGION_i[i * 4+:4]),
				.slave_len_i(CH0_AWLEN_i[i * 8+:8]),
				.slave_size_i(CH0_AWSIZE_i[i * 3+:3]),
				.slave_burst_i(CH0_AWBURST_i[i * 2+:2]),
				.slave_lock_i(CH0_AWLOCK_i[i]),
				.slave_cache_i(CH0_AWCACHE_i[i * 4+:4]),
				.slave_qos_i(CH0_AWQOS_i[i * 4+:4]),
				.slave_id_i(CH0_AWID_i[i * AXI4_ID_WIDTH+:AXI4_ID_WIDTH]),
				.slave_user_i(CH0_AWUSER_i[i * AXI4_USER_WIDTH+:AXI4_USER_WIDTH]),
				.slave_ready_o(CH0_AWREADY_o[i]),
				.master_valid_o(CH0_AWVALID[i]),
				.master_addr_o(CH0_AWADDR[i * AXI4_ADDRESS_WIDTH+:AXI4_ADDRESS_WIDTH]),
				.master_prot_o(CH0_AWPROT[i * 3+:3]),
				.master_region_o(CH0_AWREGION[i * 4+:4]),
				.master_len_o(CH0_AWLEN[i * 8+:8]),
				.master_size_o(CH0_AWSIZE[i * 3+:3]),
				.master_burst_o(CH0_AWBURST[i * 2+:2]),
				.master_lock_o(CH0_AWLOCK[i]),
				.master_cache_o(CH0_AWCACHE[i * 4+:4]),
				.master_qos_o(CH0_AWQOS[i * 4+:4]),
				.master_id_o(CH0_AWID[i * AXI4_ID_WIDTH+:AXI4_ID_WIDTH]),
				.master_user_o(CH0_AWUSER[i * AXI4_USER_WIDTH+:AXI4_USER_WIDTH]),
				.master_ready_i(CH0_AWREADY[i])
			);
		end
		for (i = 0; i < N_CH0; i = i + 1) begin : AR_BUF
			axi_ar_buffer #(
				.ID_WIDTH(AXI4_ID_WIDTH),
				.ADDR_WIDTH(AXI4_ADDRESS_WIDTH),
				.USER_WIDTH(AXI4_USER_WIDTH),
				.BUFFER_DEPTH(BUFF_DEPTH_SLAVE)
			) Slave_ar_buffer_LP(
				.clk_i(ACLK),
				.rst_ni(ARESETn),
				.test_en_i(test_en_i),
				.slave_valid_i(CH0_ARVALID_i[i]),
				.slave_addr_i(CH0_ARADDR_i[i * AXI4_ADDRESS_WIDTH+:AXI4_ADDRESS_WIDTH]),
				.slave_prot_i(CH0_ARPROT_i[i * 3+:3]),
				.slave_region_i(CH0_ARREGION_i[i * 4+:4]),
				.slave_len_i(CH0_ARLEN_i[i * 8+:8]),
				.slave_size_i(CH0_ARSIZE_i[i * 3+:3]),
				.slave_burst_i(CH0_ARBURST_i[i * 2+:2]),
				.slave_lock_i(CH0_ARLOCK_i[i]),
				.slave_cache_i(CH0_ARCACHE_i[i * 4+:4]),
				.slave_qos_i(CH0_ARQOS_i[i * 4+:4]),
				.slave_id_i(CH0_ARID_i[i * AXI4_ID_WIDTH+:AXI4_ID_WIDTH]),
				.slave_user_i(CH0_ARUSER_i[i * AXI4_USER_WIDTH+:AXI4_USER_WIDTH]),
				.slave_ready_o(CH0_ARREADY_o[i]),
				.master_valid_o(CH0_ARVALID[i]),
				.master_addr_o(CH0_ARADDR[i * AXI4_ADDRESS_WIDTH+:AXI4_ADDRESS_WIDTH]),
				.master_prot_o(CH0_ARPROT[i * 3+:3]),
				.master_region_o(CH0_ARREGION[i * 4+:4]),
				.master_len_o(CH0_ARLEN[i * 8+:8]),
				.master_size_o(CH0_ARSIZE[i * 3+:3]),
				.master_burst_o(CH0_ARBURST[i * 2+:2]),
				.master_lock_o(CH0_ARLOCK[i]),
				.master_cache_o(CH0_ARCACHE[i * 4+:4]),
				.master_qos_o(CH0_ARQOS[i * 4+:4]),
				.master_id_o(CH0_ARID[i * AXI4_ID_WIDTH+:AXI4_ID_WIDTH]),
				.master_user_o(CH0_ARUSER[i * AXI4_USER_WIDTH+:AXI4_USER_WIDTH]),
				.master_ready_i(CH0_ARREADY[i])
			);
		end
		for (i = 0; i < N_CH0; i = i + 1) begin : W_BUF
			axi_w_buffer #(
				.DATA_WIDTH(AXI4_WDATA_WIDTH),
				.USER_WIDTH(AXI4_USER_WIDTH),
				.BUFFER_DEPTH(BUFF_DEPTH_SLAVE)
			) Slave_w_buffer_LP(
				.clk_i(ACLK),
				.rst_ni(ARESETn),
				.test_en_i(test_en_i),
				.slave_valid_i(CH0_WVALID_i[i]),
				.slave_data_i(CH0_WDATA_i[8 * (i * AXI_NUMBYTES)+:8 * AXI_NUMBYTES]),
				.slave_strb_i(CH0_WSTRB_i[i * AXI_NUMBYTES+:AXI_NUMBYTES]),
				.slave_user_i(CH0_WUSER_i[i * AXI4_USER_WIDTH+:AXI4_USER_WIDTH]),
				.slave_last_i(CH0_WLAST_i[i]),
				.slave_ready_o(CH0_WREADY_o[i]),
				.master_valid_o(CH0_WVALID[i]),
				.master_data_o(CH0_WDATA[8 * (i * AXI_NUMBYTES)+:8 * AXI_NUMBYTES]),
				.master_strb_o(CH0_WSTRB[i * AXI_NUMBYTES+:AXI_NUMBYTES]),
				.master_user_o(CH0_WUSER[i * AXI4_USER_WIDTH+:AXI4_USER_WIDTH]),
				.master_last_o(CH0_WLAST[i]),
				.master_ready_i(CH0_WREADY[i])
			);
		end
		for (i = 0; i < N_CH0; i = i + 1) begin : R_BUF
			axi_r_buffer #(
				.ID_WIDTH(AXI4_ID_WIDTH),
				.DATA_WIDTH(AXI4_RDATA_WIDTH),
				.USER_WIDTH(AXI4_USER_WIDTH),
				.BUFFER_DEPTH(BUFF_DEPTH_SLAVE)
			) Slave_r_buffer_LP(
				.clk_i(ACLK),
				.rst_ni(ARESETn),
				.test_en_i(test_en_i),
				.slave_valid_i(CH0_RVALID[i]),
				.slave_data_i(CH0_RDATA[i * AXI4_RDATA_WIDTH+:AXI4_RDATA_WIDTH]),
				.slave_resp_i(CH0_RRESP[i * 2+:2]),
				.slave_user_i(CH0_RUSER[i * AXI4_USER_WIDTH+:AXI4_USER_WIDTH]),
				.slave_id_i(CH0_RID[i * AXI4_ID_WIDTH+:AXI4_ID_WIDTH]),
				.slave_last_i(CH0_RLAST[i]),
				.slave_ready_o(CH0_RREADY[i]),
				.master_valid_o(CH0_RVALID_o[i]),
				.master_data_o(CH0_RDATA_o[i * AXI4_RDATA_WIDTH+:AXI4_RDATA_WIDTH]),
				.master_resp_o(CH0_RRESP_o[i * 2+:2]),
				.master_user_o(CH0_RUSER_o[i * AXI4_USER_WIDTH+:AXI4_USER_WIDTH]),
				.master_id_o(CH0_RID_o[i * AXI4_ID_WIDTH+:AXI4_ID_WIDTH]),
				.master_last_o(CH0_RLAST_o[i]),
				.master_ready_i(CH0_RREADY_i[i])
			);
		end
		for (i = 0; i < N_CH0; i = i + 1) begin : B_BUF
			axi_b_buffer #(
				.ID_WIDTH(AXI4_ID_WIDTH),
				.USER_WIDTH(AXI4_USER_WIDTH),
				.BUFFER_DEPTH(BUFF_DEPTH_SLAVE)
			) Slave_b_buffer_LP(
				.clk_i(ACLK),
				.rst_ni(ARESETn),
				.test_en_i(test_en_i),
				.slave_valid_i(CH0_BVALID[i]),
				.slave_resp_i(CH0_BRESP[i * 2+:2]),
				.slave_id_i(CH0_BID[i * AXI4_ID_WIDTH+:AXI4_ID_WIDTH]),
				.slave_user_i(CH0_BUSER[i * AXI4_USER_WIDTH+:AXI4_USER_WIDTH]),
				.slave_ready_o(CH0_BREADY[i]),
				.master_valid_o(CH0_BVALID_o[i]),
				.master_resp_o(CH0_BRESP_o[i * 2+:2]),
				.master_id_o(CH0_BID_o[i * AXI4_ID_WIDTH+:AXI4_ID_WIDTH]),
				.master_user_o(CH0_BUSER_o[i * AXI4_USER_WIDTH+:AXI4_USER_WIDTH]),
				.master_ready_i(CH0_BREADY_i[i])
			);
		end
		for (i = 0; i < N_CH0; i = i + 1) begin : WO_CTRL
			axi_write_only_ctrl #(
				.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),
				.AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH),
				.AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH),
				.AXI4_ID_WIDTH(AXI4_ID_WIDTH),
				.AXI4_USER_WIDTH(AXI4_USER_WIDTH),
				.AXI_NUMBYTES(AXI_NUMBYTES),
				.MEM_ADDR_WIDTH(MEM_ADDR_WIDTH + $clog2(NB_L2_BANKS))
			) W_CTRL(
				.clk(ACLK),
				.rst_n(ARESETn),
				.AWID_i(CH0_AWID[i * AXI4_ID_WIDTH+:AXI4_ID_WIDTH]),
				.AWADDR_i(CH0_AWADDR[i * AXI4_ADDRESS_WIDTH+:AXI4_ADDRESS_WIDTH]),
				.AWLEN_i(CH0_AWLEN[i * 8+:8]),
				.AWSIZE_i(CH0_AWSIZE[i * 3+:3]),
				.AWBURST_i(CH0_AWBURST[i * 2+:2]),
				.AWLOCK_i(CH0_AWLOCK[i]),
				.AWCACHE_i(CH0_AWCACHE[i * 4+:4]),
				.AWPROT_i(CH0_AWPROT[i * 3+:3]),
				.AWREGION_i(CH0_AWREGION[i * 4+:4]),
				.AWUSER_i(CH0_AWUSER[i * AXI4_USER_WIDTH+:AXI4_USER_WIDTH]),
				.AWQOS_i(CH0_AWQOS[i * 4+:4]),
				.AWVALID_i(CH0_AWVALID[i]),
				.AWREADY_o(CH0_AWREADY[i]),
				.WDATA_i(CH0_WDATA[8 * (i * AXI_NUMBYTES)+:8 * AXI_NUMBYTES]),
				.WSTRB_i(CH0_WSTRB[i * AXI_NUMBYTES+:AXI_NUMBYTES]),
				.WLAST_i(CH0_WLAST[i]),
				.WUSER_i(CH0_WUSER[i * AXI4_USER_WIDTH+:AXI4_USER_WIDTH]),
				.WVALID_i(CH0_WVALID[i]),
				.WREADY_o(CH0_WREADY[i]),
				.BID_o(CH0_BID[i * AXI4_ID_WIDTH+:AXI4_ID_WIDTH]),
				.BRESP_o(CH0_BRESP[i * 2+:2]),
				.BVALID_o(CH0_BVALID[i]),
				.BUSER_o(CH0_BUSER[i * AXI4_USER_WIDTH+:AXI4_USER_WIDTH]),
				.BREADY_i(CH0_BREADY[i]),
				.MEM_CEN_o(CH0_W_cen[i]),
				.MEM_WEN_o(CH0_W_wen[i]),
				.MEM_A_o(CH0_W_addr[i * (MEM_ADDR_WIDTH + $clog2(NB_L2_BANKS))+:MEM_ADDR_WIDTH + $clog2(NB_L2_BANKS)]),
				.MEM_D_o(CH0_W_wdata[i * AXI4_WDATA_WIDTH+:AXI4_WDATA_WIDTH]),
				.MEM_BE_o(CH0_W_be[i * AXI_NUMBYTES+:AXI_NUMBYTES]),
				.MEM_Q_i(1'sb0),
				.grant_i(grant_W_CH0[i]),
				.valid_o(valid_W_CH0[i])
			);
		end
		for (i = 0; i < N_CH0; i = i + 1) begin : RO_CTRL
			axi_read_only_ctrl #(
				.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),
				.AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH),
				.AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH),
				.AXI4_ID_WIDTH(AXI4_ID_WIDTH),
				.AXI4_USER_WIDTH(AXI4_USER_WIDTH),
				.AXI_NUMBYTES(AXI_NUMBYTES),
				.MEM_ADDR_WIDTH(MEM_ADDR_WIDTH + $clog2(NB_L2_BANKS))
			) R_CTRL_LP(
				.clk(ACLK),
				.rst_n(ARESETn),
				.ARID_i(CH0_ARID[i * AXI4_ID_WIDTH+:AXI4_ID_WIDTH]),
				.ARADDR_i(CH0_ARADDR[i * AXI4_ADDRESS_WIDTH+:AXI4_ADDRESS_WIDTH]),
				.ARLEN_i(CH0_ARLEN[i * 8+:8]),
				.ARSIZE_i(CH0_ARSIZE[i * 3+:3]),
				.ARBURST_i(CH0_ARBURST[i * 2+:2]),
				.ARLOCK_i(CH0_ARLOCK[i]),
				.ARCACHE_i(CH0_ARCACHE[i * 4+:4]),
				.ARPROT_i(CH0_ARPROT[i * 3+:3]),
				.ARREGION_i(CH0_ARREGION[i * 4+:4]),
				.ARUSER_i(CH0_ARUSER[i * AXI4_USER_WIDTH+:AXI4_USER_WIDTH]),
				.ARQOS_i(CH0_ARQOS[i * 4+:4]),
				.ARVALID_i(CH0_ARVALID[i]),
				.ARREADY_o(CH0_ARREADY[i]),
				.RID_o(CH0_RID[i * AXI4_ID_WIDTH+:AXI4_ID_WIDTH]),
				.RDATA_o(CH0_RDATA[i * AXI4_RDATA_WIDTH+:AXI4_RDATA_WIDTH]),
				.RRESP_o(CH0_RRESP[i * 2+:2]),
				.RLAST_o(CH0_RLAST[i]),
				.RUSER_o(CH0_RUSER[i * AXI4_USER_WIDTH+:AXI4_USER_WIDTH]),
				.RVALID_o(CH0_RVALID[i]),
				.RREADY_i(CH0_RREADY[i]),
				.MEM_CEN_o(CH0_R_cen[i]),
				.MEM_WEN_o(CH0_R_wen[i]),
				.MEM_A_o(CH0_R_addr[i * (MEM_ADDR_WIDTH + $clog2(NB_L2_BANKS))+:MEM_ADDR_WIDTH + $clog2(NB_L2_BANKS)]),
				.MEM_D_o(),
				.MEM_BE_o(),
				.MEM_Q_i(CH0_R_rdata[i * AXI4_WDATA_WIDTH+:AXI4_WDATA_WIDTH]),
				.grant_i(grant_R_CH0[i]),
				.valid_o(valid_R_CH0[i])
			);
		end
		for (i = 0; i < N_CH0; i = i + 1) begin : BINDING_AXI_IF
			assign req_int[2 * i] = valid_W_CH0[i];
			assign req_int[(2 * i) + 1] = valid_R_CH0[i];
			assign grant_W_CH0[i] = gnt_int[2 * i];
			assign grant_R_CH0[i] = gnt_int[(2 * i) + 1];
			assign add_int[(2 * i) * ((MEM_ADDR_WIDTH + 3) + $clog2(NB_L2_BANKS))+:(MEM_ADDR_WIDTH + 3) + $clog2(NB_L2_BANKS)] = {CH0_W_addr[i * (MEM_ADDR_WIDTH + $clog2(NB_L2_BANKS))+:MEM_ADDR_WIDTH + $clog2(NB_L2_BANKS)], 3'b000};
			assign add_int[((2 * i) + 1) * ((MEM_ADDR_WIDTH + 3) + $clog2(NB_L2_BANKS))+:(MEM_ADDR_WIDTH + 3) + $clog2(NB_L2_BANKS)] = {CH0_R_addr[i * (MEM_ADDR_WIDTH + $clog2(NB_L2_BANKS))+:MEM_ADDR_WIDTH + $clog2(NB_L2_BANKS)], 3'b000};
			assign wen_int[2 * i] = 1'b0;
			assign wen_int[(2 * i) + 1] = 1'b1;
			assign wdata_int[(2 * i) * AXI4_WDATA_WIDTH+:AXI4_WDATA_WIDTH] = CH0_W_wdata[i * AXI4_WDATA_WIDTH+:AXI4_WDATA_WIDTH];
			assign wdata_int[((2 * i) + 1) * AXI4_WDATA_WIDTH+:AXI4_WDATA_WIDTH] = 1'sb0;
			assign be_int[(2 * i) * (AXI4_WDATA_WIDTH / 8)+:AXI4_WDATA_WIDTH / 8] = CH0_W_be[i * AXI_NUMBYTES+:AXI_NUMBYTES];
			assign be_int[((2 * i) + 1) * (AXI4_WDATA_WIDTH / 8)+:AXI4_WDATA_WIDTH / 8] = 1'sb0;
			assign CH0_W_rdata[i * AXI4_WDATA_WIDTH+:AXI4_WDATA_WIDTH] = r_rdata_int[(2 * i) * AXI4_WDATA_WIDTH+:AXI4_WDATA_WIDTH];
			assign CH0_R_rdata[i * AXI4_WDATA_WIDTH+:AXI4_WDATA_WIDTH] = r_rdata_int[((2 * i) + 1) * AXI4_WDATA_WIDTH+:AXI4_WDATA_WIDTH];
		end
		for (i = 0; i < N_CH1; i = i + 1) begin : BINDING_TCDM_IF
			assign req_int[(2 * N_CH0) + i] = CH1_req_i[i];
			assign CH1_gnt_o[i] = gnt_int[(2 * N_CH0) + i];
			assign add_int[((2 * N_CH0) + i) * ((MEM_ADDR_WIDTH + 3) + $clog2(NB_L2_BANKS))+:(MEM_ADDR_WIDTH + 3) + $clog2(NB_L2_BANKS)] = {CH1_addr_i[i * (MEM_ADDR_WIDTH + $clog2(NB_L2_BANKS))+:MEM_ADDR_WIDTH + $clog2(NB_L2_BANKS)], 3'b000};
			assign wen_int[(2 * N_CH0) + i] = CH1_wen_i[i];
			assign wdata_int[((2 * N_CH0) + i) * AXI4_WDATA_WIDTH+:AXI4_WDATA_WIDTH] = CH1_wdata_i[i * AXI4_WDATA_WIDTH+:AXI4_WDATA_WIDTH];
			assign be_int[((2 * N_CH0) + i) * (AXI4_WDATA_WIDTH / 8)+:AXI4_WDATA_WIDTH / 8] = CH1_be_i[i * AXI_NUMBYTES+:AXI_NUMBYTES];
			assign CH1_rdata_o[i * AXI4_RDATA_WIDTH+:AXI4_RDATA_WIDTH] = r_rdata_int[((2 * N_CH0) + i) * AXI4_WDATA_WIDTH+:AXI4_WDATA_WIDTH];
			assign CH1_rvalid_o[i] = r_valid_int[(2 * N_CH0) + i];
		end
	endgenerate
	XBAR_TCDM_FC #(
		.N_CH0(2 * N_CH0),
		.N_CH1(N_CH1),
		.N_SLAVE(NB_L2_BANKS),
		.ADDR_WIDTH((MEM_ADDR_WIDTH + 3) + $clog2(NB_L2_BANKS)),
		.DATA_WIDTH(AXI4_WDATA_WIDTH),
		.ADDR_MEM_WIDTH(MEM_ADDR_WIDTH),
		.CH0_CH1_POLICY("RR")
	) L2_MB_INTERCO(
		.data_req_i(req_int),
		.data_add_i(add_int),
		.data_wen_i(wen_int),
		.data_wdata_i(wdata_int),
		.data_be_i(be_int),
		.data_gnt_o(gnt_int),
		.data_r_valid_o(r_valid_int),
		.data_r_rdata_o(r_rdata_int),
		.data_req_o(mem_req),
		.data_add_o(mem_add),
		.data_wen_o(mem_wen),
		.data_wdata_o(mem_wdata),
		.data_be_o(mem_be),
		.data_r_rdata_i(mem_rdata),
		.clk(ACLK),
		.rst_n(ARESETn)
	);
	assign CEN = ~mem_req;
	assign WEN = mem_wen;
	assign A = mem_add;
	assign D = mem_wdata;
	assign BE = mem_be;
	assign mem_rdata = Q;
endmodule
