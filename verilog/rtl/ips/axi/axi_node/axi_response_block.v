module axi_response_block 
#(
   parameter           AXI_ADDRESS_W  = 32,
   parameter           AXI_DATA_W     = 64,
   parameter           AXI_USER_W     = 6,

   parameter           N_INIT_PORT    = 4,
   parameter           N_TARG_PORT    = 8,
   parameter           FIFO_DEPTH_DW  = 8,

   parameter           AXI_ID_IN      = 16,
   parameter           AXI_ID_OUT     = AXI_ID_IN + $clog2(N_TARG_PORT),
   parameter           N_REGION       = 2
)
(
	clk,
	rst_n,
	test_en_i,
	rid_i,
	rdata_i,
	rresp_i,
	rlast_i,
	ruser_i,
	rvalid_i,
	rready_o,
	bid_i,
	bresp_i,
	buser_i,
	bvalid_i,
	bready_o,
	rid_o,
	rdata_o,
	rresp_o,
	rlast_o,
	ruser_o,
	rvalid_o,
	rready_i,
	bid_o,
	bresp_o,
	buser_o,
	bvalid_o,
	bready_i,
	arvalid_i,
	araddr_i,
	arready_o,
	arid_i,
	arlen_i,
	aruser_i,
	arvalid_o,
	arready_i,
	awvalid_i,
	awaddr_i,
	awready_o,
	awid_i,
	awuser_i,
	awvalid_o,
	awready_i,
	wvalid_i,
	wlast_i,
	wready_o,
	wvalid_o,
	wready_i,
	START_ADDR_i,
	END_ADDR_i,
	enable_region_i,
	connectivity_map_i
);
	//parameter AXI_ADDRESS_W = 32;
	//parameter AXI_DATA_W = 64;
	//parameter AXI_USER_W = 6;
	//parameter N_INIT_PORT = 4;
	//parameter N_TARG_PORT = 8;
	//parameter FIFO_DEPTH_DW = 8;
	//parameter AXI_ID_IN = 16;
	//parameter AXI_ID_OUT = AXI_ID_IN + $clog2(N_TARG_PORT);
	//parameter N_REGION = 2;
	input wire clk;
	input wire rst_n;
	input wire test_en_i;
	input wire [(N_INIT_PORT * AXI_ID_OUT) - 1:0] rid_i;
	input wire [(N_INIT_PORT * AXI_DATA_W) - 1:0] rdata_i;
	input wire [(N_INIT_PORT * 2) - 1:0] rresp_i;
	input wire [N_INIT_PORT - 1:0] rlast_i;
	input wire [(N_INIT_PORT * AXI_USER_W) - 1:0] ruser_i;
	input wire [N_INIT_PORT - 1:0] rvalid_i;
	output wire [N_INIT_PORT - 1:0] rready_o;
	input wire [(N_INIT_PORT * AXI_ID_OUT) - 1:0] bid_i;
	input wire [(N_INIT_PORT * 2) - 1:0] bresp_i;
	input wire [(N_INIT_PORT * AXI_USER_W) - 1:0] buser_i;
	input wire [N_INIT_PORT - 1:0] bvalid_i;
	output wire [N_INIT_PORT - 1:0] bready_o;
	output wire [AXI_ID_IN - 1:0] rid_o;
	output wire [AXI_DATA_W - 1:0] rdata_o;
	output wire [1:0] rresp_o;
	output wire rlast_o;
	output wire [AXI_USER_W - 1:0] ruser_o;
	output wire rvalid_o;
	input wire rready_i;
	output wire [AXI_ID_IN - 1:0] bid_o;
	output wire [1:0] bresp_o;
	output wire [AXI_USER_W - 1:0] buser_o;
	output wire bvalid_o;
	input wire bready_i;
	input wire arvalid_i;
	input wire [AXI_ADDRESS_W - 1:0] araddr_i;
	output wire arready_o;
	input wire [AXI_ID_IN - 1:0] arid_i;
	input wire [7:0] arlen_i;
	input wire [AXI_USER_W - 1:0] aruser_i;
	output wire [N_INIT_PORT - 1:0] arvalid_o;
	input wire [N_INIT_PORT - 1:0] arready_i;
	input wire awvalid_i;
	input wire [AXI_ADDRESS_W - 1:0] awaddr_i;
	output wire awready_o;
	input wire [AXI_ID_IN - 1:0] awid_i;
	input wire [AXI_USER_W - 1:0] awuser_i;
	output wire [N_INIT_PORT - 1:0] awvalid_o;
	input wire [N_INIT_PORT - 1:0] awready_i;
	input wire wvalid_i;
	input wire wlast_i;
	output wire wready_o;
	output wire [N_INIT_PORT - 1:0] wvalid_o;
	input wire [N_INIT_PORT - 1:0] wready_i;
	input wire [((N_REGION * N_INIT_PORT) * AXI_ADDRESS_W) - 1:0] START_ADDR_i;
	input wire [((N_REGION * N_INIT_PORT) * AXI_ADDRESS_W) - 1:0] END_ADDR_i;
	input wire [(N_REGION * N_INIT_PORT) - 1:0] enable_region_i;
	input wire [N_INIT_PORT - 1:0] connectivity_map_i;
	wire push_DEST_DW;
	wire grant_FIFO_DEST_DW;
	wire [N_INIT_PORT - 1:0] DEST_DW;
	wire incr_ar_req;
	wire full_counter_ar;
	wire outstanding_trans_ar;
	wire error_ar_req;
	wire error_ar_gnt;
	wire incr_aw_req;
	wire full_counter_aw;
	wire outstanding_trans_aw;
	wire handle_error_aw;
	wire wdata_error_completed;
	wire sample_awdata_info;
	wire sample_ardata_info;
	wire error_aw_req;
	wire error_aw_gnt;
	axi_BW_allocator #(
		.AXI_USER_W(AXI_USER_W),
		.N_INIT_PORT(N_INIT_PORT),
		.N_TARG_PORT(N_TARG_PORT),
		.AXI_DATA_W(AXI_DATA_W),
		.AXI_ID_IN(AXI_ID_IN)
	) BW_ALLOC(
		.clk(clk),
		.rst_n(rst_n),
		.bid_i(bid_i),
		.bresp_i(bresp_i),
		.buser_i(buser_i),
		.bvalid_i(bvalid_i),
		.bready_o(bready_o),
		.bid_o(bid_o),
		.bresp_o(bresp_o),
		.buser_o(buser_o),
		.bvalid_o(bvalid_o),
		.bready_i(bready_i),
		.incr_req_i(incr_aw_req),
		.full_counter_o(full_counter_aw),
		.outstanding_trans_o(outstanding_trans_aw),
		.sample_awdata_info_i(sample_awdata_info),
		.error_req_i(error_aw_req),
		.error_gnt_o(error_aw_gnt),
		.error_user_i(awuser_i),
		.error_id_i(awid_i)
	);
	axi_BR_allocator #(
		.AXI_USER_W(AXI_USER_W),
		.N_INIT_PORT(N_INIT_PORT),
		.N_TARG_PORT(N_TARG_PORT),
		.AXI_DATA_W(AXI_DATA_W),
		.AXI_ID_IN(AXI_ID_IN)
	) BR_ALLOC(
		.clk(clk),
		.rst_n(rst_n),
		.rid_i(rid_i),
		.rdata_i(rdata_i),
		.rresp_i(rresp_i),
		.rlast_i(rlast_i),
		.ruser_i(ruser_i),
		.rvalid_i(rvalid_i),
		.rready_o(rready_o),
		.rid_o(rid_o),
		.rdata_o(rdata_o),
		.rresp_o(rresp_o),
		.rlast_o(rlast_o),
		.ruser_o(ruser_o),
		.rvalid_o(rvalid_o),
		.rready_i(rready_i),
		.incr_req_i(incr_ar_req),
		.full_counter_o(full_counter_ar),
		.outstanding_trans_o(outstanding_trans_ar),
		.error_req_i(error_ar_req),
		.error_gnt_o(error_ar_gnt),
		.error_len_i(arlen_i),
		.error_user_i(aruser_i),
		.error_id_i(arid_i),
		.sample_ardata_info_i(sample_ardata_info)
	);
	axi_address_decoder_AR #(
		.ADDR_WIDTH(AXI_ADDRESS_W),
		.N_INIT_PORT(N_INIT_PORT),
		.N_REGION(N_REGION)
	) AR_ADDR_DEC(
		.clk(clk),
		.rst_n(rst_n),
		.arvalid_i(arvalid_i),
		.araddr_i(araddr_i),
		.arready_o(arready_o),
		.arvalid_o(arvalid_o),
		.arready_i(arready_i),
		.START_ADDR_i(START_ADDR_i),
		.END_ADDR_i(END_ADDR_i),
		.enable_region_i(enable_region_i),
		.connectivity_map_i(connectivity_map_i),
		.incr_req_o(incr_ar_req),
		.full_counter_i(full_counter_ar),
		.outstanding_trans_i(outstanding_trans_ar),
		.error_req_o(error_ar_req),
		.error_gnt_i(error_ar_gnt),
		.sample_ardata_info_o(sample_ardata_info)
	);
	axi_address_decoder_AW #(
		.ADDR_WIDTH(AXI_ADDRESS_W),
		.N_INIT_PORT(N_INIT_PORT),
		.N_REGION(N_REGION)
	) AW_ADDR_DEC(
		.clk(clk),
		.rst_n(rst_n),
		.awvalid_i(awvalid_i),
		.awaddr_i(awaddr_i),
		.awready_o(awready_o),
		.awvalid_o(awvalid_o),
		.awready_i(awready_i),
		.grant_FIFO_DEST_i(grant_FIFO_DEST_DW),
		.DEST_o(DEST_DW),
		.push_DEST_o(push_DEST_DW),
		.START_ADDR_i(START_ADDR_i),
		.END_ADDR_i(END_ADDR_i),
		.enable_region_i(enable_region_i),
		.connectivity_map_i(connectivity_map_i),
		.incr_req_o(incr_aw_req),
		.full_counter_i(full_counter_aw),
		.outstanding_trans_i(outstanding_trans_aw),
		.error_req_o(error_aw_req),
		.error_gnt_i(error_aw_gnt),
		.handle_error_o(handle_error_aw),
		.wdata_error_completed_i(wdata_error_completed),
		.sample_awdata_info_o(sample_awdata_info)
	);
	axi_address_decoder_DW #(
		.N_INIT_PORT(N_INIT_PORT),
		.FIFO_DEPTH(FIFO_DEPTH_DW)
	) DW_ADDR_DEC(
		.clk(clk),
		.rst_n(rst_n),
		.test_en_i(test_en_i),
		.wvalid_i(wvalid_i),
		.wlast_i(wlast_i),
		.wready_o(wready_o),
		.wvalid_o(wvalid_o),
		.wready_i(wready_i),
		.grant_FIFO_DEST_o(grant_FIFO_DEST_DW),
		.DEST_i(DEST_DW),
		.push_DEST_i(push_DEST_DW),
		.handle_error_i(handle_error_aw),
		.wdata_error_completed_o(wdata_error_completed)
	);
endmodule
