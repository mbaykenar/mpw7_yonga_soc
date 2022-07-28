module axi_mem_if_SP_wrap 
#(
    parameter AXI_ADDR_WIDTH = 32,
    parameter AXI_DATA_WIDTH = 64,
    parameter AXI_ID_WIDTH   = 10,
    parameter AXI_USER_WIDTH = 10,
    parameter MEM_ADDR_WIDTH = 10
  )
(
	clk,
	rst_n,
	test_en_i,
	mem_req_o,
	mem_addr_o,
	mem_we_o,
	mem_be_o,
	mem_rdata_i,
	mem_wdata_o,
	aw_addr,
	aw_prot,
	aw_region,
	aw_len,
	aw_size,
	aw_burst,
	aw_lock,
	aw_cache,
	aw_qos,
	aw_id,
	aw_user,
	aw_ready,
	aw_valid,
	ar_addr,
	ar_prot,
	ar_region,
	ar_len,
	ar_size,
	ar_burst,
	ar_lock,
	ar_cache,
	ar_qos,
	ar_id,
	ar_user,
	ar_ready,
	ar_valid,
	w_valid,
	w_data,
	w_strb,
	w_user,
	w_last,
	w_ready,
	r_data,
	r_resp,
	r_last,
	r_id,
	r_user,
	r_ready,
	r_valid,
	b_resp,
	b_id,
	b_user,
	b_ready,
	b_valid
);
	//parameter AXI_ADDR_WIDTH = 32;
	//parameter AXI_DATA_WIDTH = 64;
	//parameter AXI_ID_WIDTH = 10;
	//parameter AXI_USER_WIDTH = 10;
	//parameter MEM_ADDR_WIDTH = 10;
	parameter AXI_STRB_WIDTH = AXI_DATA_WIDTH / 8;
	input wire clk;
	input wire rst_n;
	input wire test_en_i;
	output wire mem_req_o;
	output wire [MEM_ADDR_WIDTH - 1:0] mem_addr_o;
	output wire mem_we_o;
	output wire [(AXI_DATA_WIDTH / 8) - 1:0] mem_be_o;
	input wire [AXI_DATA_WIDTH - 1:0] mem_rdata_i;
	output wire [AXI_DATA_WIDTH - 1:0] mem_wdata_o;
	input wire [AXI_ADDR_WIDTH - 1:0] aw_addr;
	input wire [2:0] aw_prot;
	input wire [3:0] aw_region;
	input wire [7:0] aw_len;
	input wire [2:0] aw_size;
	input wire [1:0] aw_burst;
	input wire aw_lock;
	input wire [3:0] aw_cache;
	input wire [3:0] aw_qos;
	input wire [AXI_ID_WIDTH - 1:0] aw_id;
	input wire [AXI_USER_WIDTH - 1:0] aw_user;
	output wire aw_ready;
	input wire aw_valid;
	input wire [AXI_ADDR_WIDTH - 1:0] ar_addr;
	input wire [2:0] ar_prot;
	input wire [3:0] ar_region;
	input wire [7:0] ar_len;
	input wire [2:0] ar_size;
	input wire [1:0] ar_burst;
	input wire ar_lock;
	input wire [3:0] ar_cache;
	input wire [3:0] ar_qos;
	input wire [AXI_ID_WIDTH - 1:0] ar_id;
	input wire [AXI_USER_WIDTH - 1:0] ar_user;
	output wire ar_ready;
	input wire ar_valid;
	input wire w_valid;
	input wire [AXI_DATA_WIDTH - 1:0] w_data;
	input wire [AXI_STRB_WIDTH - 1:0] w_strb;
	input wire [AXI_USER_WIDTH - 1:0] w_user;
	input wire w_last;
	output wire w_ready;
	output wire [AXI_DATA_WIDTH - 1:0] r_data;
	output wire [1:0] r_resp;
	output wire r_last;
	output wire [AXI_ID_WIDTH - 1:0] r_id;
	output wire [AXI_USER_WIDTH - 1:0] r_user;
	input wire r_ready;
	output wire r_valid;
	output wire [1:0] b_resp;
	output wire [AXI_ID_WIDTH - 1:0] b_id;
	output wire [AXI_USER_WIDTH - 1:0] b_user;
	input wire b_ready;
	output wire b_valid;
	wire cen;
	wire wen;
	axi_mem_if_SP #(
		.AXI4_ADDRESS_WIDTH(AXI_ADDR_WIDTH),
		.AXI4_RDATA_WIDTH(AXI_DATA_WIDTH),
		.AXI4_WDATA_WIDTH(AXI_DATA_WIDTH),
		.AXI4_ID_WIDTH(AXI_ID_WIDTH),
		.AXI4_USER_WIDTH(AXI_USER_WIDTH),
		.MEM_ADDR_WIDTH(MEM_ADDR_WIDTH)
	) axi_mem_if_SP_i(
		.ACLK(clk),
		.ARESETn(rst_n),
		.test_en_i(test_en_i),
		.AWID_i(aw_id),
		.AWADDR_i(aw_addr),
		.AWLEN_i(aw_len),
		.AWSIZE_i(aw_size),
		.AWBURST_i(aw_burst),
		.AWLOCK_i(aw_lock),
		.AWCACHE_i(aw_cache),
		.AWPROT_i(aw_prot),
		.AWREGION_i(aw_region),
		.AWUSER_i(aw_user),
		.AWQOS_i(aw_qos),
		.AWVALID_i(aw_valid),
		.AWREADY_o(aw_ready),
		.WDATA_i(w_data),
		.WSTRB_i(w_strb),
		.WLAST_i(w_last),
		.WUSER_i(w_user),
		.WVALID_i(w_valid),
		.WREADY_o(w_ready),
		.BID_o(b_id),
		.BRESP_o(b_resp),
		.BVALID_o(b_valid),
		.BUSER_o(b_user),
		.BREADY_i(b_ready),
		.ARID_i(ar_id),
		.ARADDR_i(ar_addr),
		.ARLEN_i(ar_len),
		.ARSIZE_i(ar_size),
		.ARBURST_i(ar_burst),
		.ARLOCK_i(ar_lock),
		.ARCACHE_i(ar_cache),
		.ARPROT_i(ar_prot),
		.ARREGION_i(ar_region),
		.ARUSER_i(ar_user),
		.ARQOS_i(ar_qos),
		.ARVALID_i(ar_valid),
		.ARREADY_o(ar_ready),
		.RID_o(r_id),
		.RDATA_o(r_data),
		.RRESP_o(r_resp),
		.RLAST_o(r_last),
		.RUSER_o(r_user),
		.RVALID_o(r_valid),
		.RREADY_i(r_ready),
		.CEN_o(cen),
		.WEN_o(wen),
		.A_o(mem_addr_o),
		.D_o(mem_wdata_o),
		.BE_o(mem_be_o),
		.Q_i(mem_rdata_i)
	);
	assign mem_req_o = ~cen;
	assign mem_we_o = ~wen;
endmodule
