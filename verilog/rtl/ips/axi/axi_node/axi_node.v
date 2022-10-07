module axi_node 
#(
   parameter                   AXI_ADDRESS_W      = 32,
   parameter                   AXI_DATA_W         = 64,
   parameter                   AXI_NUMBYTES       = AXI_DATA_W/8,
   parameter                   AXI_USER_W         = 6,
`ifdef USE_CFG_BLOCK
   `ifdef  USE_AXI_LITE
      parameter                AXI_LITE_ADDRESS_W = 32,
      parameter                AXI_LITE_DATA_W    = 32,
      parameter                AXI_LITE_BE_W      = AXI_LITE_DATA_W/8,
   `else
      parameter                APB_ADDR_WIDTH     = 32,
      parameter                APB_DATA_WIDTH     = 32,
   `endif
`endif
   parameter                   N_MASTER_PORT      = 8,
   parameter                   N_SLAVE_PORT       = 4,
   parameter                   AXI_ID_IN          = 16,
   parameter                   AXI_ID_OUT         = AXI_ID_IN + $clog2(N_SLAVE_PORT),
   parameter                   FIFO_DEPTH_DW      = 8,
   parameter                   N_REGION           = 2
)
(
	clk,
	rst_n,
	test_en_i,
	slave_awid_i,
	slave_awaddr_i,
	slave_awlen_i,
	slave_awsize_i,
	slave_awburst_i,
	slave_awlock_i,
	slave_awcache_i,
	slave_awprot_i,
	slave_awregion_i,
	slave_awuser_i,
	slave_awqos_i,
	slave_awvalid_i,
	slave_awready_o,
	slave_wdata_i,
	slave_wstrb_i,
	slave_wlast_i,
	slave_wuser_i,
	slave_wvalid_i,
	slave_wready_o,
	slave_bid_o,
	slave_bresp_o,
	slave_bvalid_o,
	slave_buser_o,
	slave_bready_i,
	slave_arid_i,
	slave_araddr_i,
	slave_arlen_i,
	slave_arsize_i,
	slave_arburst_i,
	slave_arlock_i,
	slave_arcache_i,
	slave_arprot_i,
	slave_arregion_i,
	slave_aruser_i,
	slave_arqos_i,
	slave_arvalid_i,
	slave_arready_o,
	slave_rid_o,
	slave_rdata_o,
	slave_rresp_o,
	slave_rlast_o,
	slave_ruser_o,
	slave_rvalid_o,
	slave_rready_i,
	master_awid_o,
	master_awaddr_o,
	master_awlen_o,
	master_awsize_o,
	master_awburst_o,
	master_awlock_o,
	master_awcache_o,
	master_awprot_o,
	master_awregion_o,
	master_awuser_o,
	master_awqos_o,
	master_awvalid_o,
	master_awready_i,
	master_wdata_o,
	master_wstrb_o,
	master_wlast_o,
	master_wuser_o,
	master_wvalid_o,
	master_wready_i,
	master_bid_i,
	master_bresp_i,
	master_buser_i,
	master_bvalid_i,
	master_bready_o,
	master_arid_o,
	master_araddr_o,
	master_arlen_o,
	master_arsize_o,
	master_arburst_o,
	master_arlock_o,
	master_arcache_o,
	master_arprot_o,
	master_arregion_o,
	master_aruser_o,
	master_arqos_o,
	master_arvalid_o,
	master_arready_i,
	master_rid_i,
	master_rdata_i,
	master_rresp_i,
	master_rlast_i,
	master_ruser_i,
	master_rvalid_i,
	master_rready_o,
	cfg_START_ADDR_i,
	cfg_END_ADDR_i,
	cfg_valid_rule_i,
	cfg_connectivity_map_i
);
	//parameter AXI_ADDRESS_W = 32;
	//parameter AXI_DATA_W = 64;
	//parameter AXI_NUMBYTES = AXI_DATA_W / 8;
	//parameter AXI_USER_W = 6;
	//parameter N_MASTER_PORT = 8;
	//parameter N_SLAVE_PORT = 4;
	//parameter AXI_ID_IN = 16;
	//parameter AXI_ID_OUT = AXI_ID_IN + $clog2(N_SLAVE_PORT);
	//parameter FIFO_DEPTH_DW = 8;
	//parameter N_REGION = 2;
	input wire clk;
	input wire rst_n;
	input wire test_en_i;
	input wire [(N_SLAVE_PORT * AXI_ID_IN) - 1:0] slave_awid_i;
	input wire [(N_SLAVE_PORT * AXI_ADDRESS_W) - 1:0] slave_awaddr_i;
	input wire [(N_SLAVE_PORT * 8) - 1:0] slave_awlen_i;
	input wire [(N_SLAVE_PORT * 3) - 1:0] slave_awsize_i;
	input wire [(N_SLAVE_PORT * 2) - 1:0] slave_awburst_i;
	input wire [N_SLAVE_PORT - 1:0] slave_awlock_i;
	input wire [(N_SLAVE_PORT * 4) - 1:0] slave_awcache_i;
	input wire [(N_SLAVE_PORT * 3) - 1:0] slave_awprot_i;
	input wire [(N_SLAVE_PORT * 4) - 1:0] slave_awregion_i;
	input wire [(N_SLAVE_PORT * AXI_USER_W) - 1:0] slave_awuser_i;
	input wire [(N_SLAVE_PORT * 4) - 1:0] slave_awqos_i;
	input wire [N_SLAVE_PORT - 1:0] slave_awvalid_i;
	output wire [N_SLAVE_PORT - 1:0] slave_awready_o;
	input wire [(N_SLAVE_PORT * AXI_DATA_W) - 1:0] slave_wdata_i;
	input wire [(N_SLAVE_PORT * AXI_NUMBYTES) - 1:0] slave_wstrb_i;
	input wire [N_SLAVE_PORT - 1:0] slave_wlast_i;
	input wire [(N_SLAVE_PORT * AXI_USER_W) - 1:0] slave_wuser_i;
	input wire [N_SLAVE_PORT - 1:0] slave_wvalid_i;
	output wire [N_SLAVE_PORT - 1:0] slave_wready_o;
	output wire [(N_SLAVE_PORT * AXI_ID_IN) - 1:0] slave_bid_o;
	output wire [(N_SLAVE_PORT * 2) - 1:0] slave_bresp_o;
	output wire [N_SLAVE_PORT - 1:0] slave_bvalid_o;
	output wire [(N_SLAVE_PORT * AXI_USER_W) - 1:0] slave_buser_o;
	input wire [N_SLAVE_PORT - 1:0] slave_bready_i;
	input wire [(N_SLAVE_PORT * AXI_ID_IN) - 1:0] slave_arid_i;
	input wire [(N_SLAVE_PORT * AXI_ADDRESS_W) - 1:0] slave_araddr_i;
	input wire [(N_SLAVE_PORT * 8) - 1:0] slave_arlen_i;
	input wire [(N_SLAVE_PORT * 3) - 1:0] slave_arsize_i;
	input wire [(N_SLAVE_PORT * 2) - 1:0] slave_arburst_i;
	input wire [N_SLAVE_PORT - 1:0] slave_arlock_i;
	input wire [(N_SLAVE_PORT * 4) - 1:0] slave_arcache_i;
	input wire [(N_SLAVE_PORT * 3) - 1:0] slave_arprot_i;
	input wire [(N_SLAVE_PORT * 4) - 1:0] slave_arregion_i;
	input wire [(N_SLAVE_PORT * AXI_USER_W) - 1:0] slave_aruser_i;
	input wire [(N_SLAVE_PORT * 4) - 1:0] slave_arqos_i;
	input wire [N_SLAVE_PORT - 1:0] slave_arvalid_i;
	output wire [N_SLAVE_PORT - 1:0] slave_arready_o;
	output wire [(N_SLAVE_PORT * AXI_ID_IN) - 1:0] slave_rid_o;
	output wire [(N_SLAVE_PORT * AXI_DATA_W) - 1:0] slave_rdata_o;
	output wire [(N_SLAVE_PORT * 2) - 1:0] slave_rresp_o;
	output wire [N_SLAVE_PORT - 1:0] slave_rlast_o;
	output wire [(N_SLAVE_PORT * AXI_USER_W) - 1:0] slave_ruser_o;
	output wire [N_SLAVE_PORT - 1:0] slave_rvalid_o;
	input wire [N_SLAVE_PORT - 1:0] slave_rready_i;
	output wire [(N_MASTER_PORT * AXI_ID_OUT) - 1:0] master_awid_o;
	output wire [(N_MASTER_PORT * AXI_ADDRESS_W) - 1:0] master_awaddr_o;
	output wire [(N_MASTER_PORT * 8) - 1:0] master_awlen_o;
	output wire [(N_MASTER_PORT * 3) - 1:0] master_awsize_o;
	output wire [(N_MASTER_PORT * 2) - 1:0] master_awburst_o;
	output wire [N_MASTER_PORT - 1:0] master_awlock_o;
	output wire [(N_MASTER_PORT * 4) - 1:0] master_awcache_o;
	output wire [(N_MASTER_PORT * 3) - 1:0] master_awprot_o;
	output wire [(N_MASTER_PORT * 4) - 1:0] master_awregion_o;
	output wire [(N_MASTER_PORT * AXI_USER_W) - 1:0] master_awuser_o;
	output wire [(N_MASTER_PORT * 4) - 1:0] master_awqos_o;
	output wire [N_MASTER_PORT - 1:0] master_awvalid_o;
	input wire [N_MASTER_PORT - 1:0] master_awready_i;
	output wire [(N_MASTER_PORT * AXI_DATA_W) - 1:0] master_wdata_o;
	output wire [(N_MASTER_PORT * AXI_NUMBYTES) - 1:0] master_wstrb_o;
	output wire [N_MASTER_PORT - 1:0] master_wlast_o;
	output wire [(N_MASTER_PORT * AXI_USER_W) - 1:0] master_wuser_o;
	output wire [N_MASTER_PORT - 1:0] master_wvalid_o;
	input wire [N_MASTER_PORT - 1:0] master_wready_i;
	input wire [(N_MASTER_PORT * AXI_ID_OUT) - 1:0] master_bid_i;
	input wire [(N_MASTER_PORT * 2) - 1:0] master_bresp_i;
	input wire [(N_MASTER_PORT * AXI_USER_W) - 1:0] master_buser_i;
	input wire [N_MASTER_PORT - 1:0] master_bvalid_i;
	output wire [N_MASTER_PORT - 1:0] master_bready_o;
	output wire [(N_MASTER_PORT * AXI_ID_OUT) - 1:0] master_arid_o;
	output wire [(N_MASTER_PORT * AXI_ADDRESS_W) - 1:0] master_araddr_o;
	output wire [(N_MASTER_PORT * 8) - 1:0] master_arlen_o;
	output wire [(N_MASTER_PORT * 3) - 1:0] master_arsize_o;
	output wire [(N_MASTER_PORT * 2) - 1:0] master_arburst_o;
	output wire [N_MASTER_PORT - 1:0] master_arlock_o;
	output wire [(N_MASTER_PORT * 4) - 1:0] master_arcache_o;
	output wire [(N_MASTER_PORT * 3) - 1:0] master_arprot_o;
	output wire [(N_MASTER_PORT * 4) - 1:0] master_arregion_o;
	output wire [(N_MASTER_PORT * AXI_USER_W) - 1:0] master_aruser_o;
	output wire [(N_MASTER_PORT * 4) - 1:0] master_arqos_o;
	output wire [N_MASTER_PORT - 1:0] master_arvalid_o;
	input wire [N_MASTER_PORT - 1:0] master_arready_i;
	input wire [(N_MASTER_PORT * AXI_ID_OUT) - 1:0] master_rid_i;
	input wire [(N_MASTER_PORT * AXI_DATA_W) - 1:0] master_rdata_i;
	input wire [(N_MASTER_PORT * 2) - 1:0] master_rresp_i;
	input wire [N_MASTER_PORT - 1:0] master_rlast_i;
	input wire [(N_MASTER_PORT * AXI_USER_W) - 1:0] master_ruser_i;
	input wire [N_MASTER_PORT - 1:0] master_rvalid_i;
	output wire [N_MASTER_PORT - 1:0] master_rready_o;
	input wire [((N_REGION * N_MASTER_PORT) * 32) - 1:0] cfg_START_ADDR_i;
	input wire [((N_REGION * N_MASTER_PORT) * 32) - 1:0] cfg_END_ADDR_i;
	input wire [(N_REGION * N_MASTER_PORT) - 1:0] cfg_valid_rule_i;
	input wire [(N_SLAVE_PORT * N_MASTER_PORT) - 1:0] cfg_connectivity_map_i;
	genvar i;
	genvar j;
	genvar k;
	wire [(N_SLAVE_PORT * N_MASTER_PORT) - 1:0] arvalid_int;
	wire [(N_MASTER_PORT * N_SLAVE_PORT) - 1:0] arready_int;
	wire [(N_MASTER_PORT * N_SLAVE_PORT) - 1:0] arvalid_int_reverse;
	wire [(N_SLAVE_PORT * N_MASTER_PORT) - 1:0] arready_int_reverse;
	wire [(N_SLAVE_PORT * N_MASTER_PORT) - 1:0] awvalid_int;
	wire [(N_MASTER_PORT * N_SLAVE_PORT) - 1:0] awready_int;
	wire [(N_MASTER_PORT * N_SLAVE_PORT) - 1:0] awvalid_int_reverse;
	wire [(N_SLAVE_PORT * N_MASTER_PORT) - 1:0] awready_int_reverse;
	wire [(N_SLAVE_PORT * N_MASTER_PORT) - 1:0] wvalid_int;
	wire [(N_MASTER_PORT * N_SLAVE_PORT) - 1:0] wready_int;
	wire [(N_MASTER_PORT * N_SLAVE_PORT) - 1:0] wvalid_int_reverse;
	wire [(N_SLAVE_PORT * N_MASTER_PORT) - 1:0] wready_int_reverse;
	wire [(N_MASTER_PORT * N_SLAVE_PORT) - 1:0] bvalid_int;
	wire [(N_SLAVE_PORT * N_MASTER_PORT) - 1:0] bready_int;
	wire [(N_SLAVE_PORT * N_MASTER_PORT) - 1:0] bvalid_int_reverse;
	wire [(N_MASTER_PORT * N_SLAVE_PORT) - 1:0] bready_int_reverse;
	wire [(N_MASTER_PORT * N_SLAVE_PORT) - 1:0] rvalid_int;
	wire [(N_SLAVE_PORT * N_MASTER_PORT) - 1:0] rready_int;
	wire [(N_SLAVE_PORT * N_MASTER_PORT) - 1:0] rvalid_int_reverse;
	wire [(N_MASTER_PORT * N_SLAVE_PORT) - 1:0] rready_int_reverse;
	wire [((N_REGION * N_MASTER_PORT) * 32) - 1:0] START_ADDR;
	wire [((N_REGION * N_MASTER_PORT) * 32) - 1:0] END_ADDR;
	wire [(N_REGION * N_MASTER_PORT) - 1:0] valid_rule;
	wire [(N_SLAVE_PORT * N_MASTER_PORT) - 1:0] connectivity_map;
	generate
		for (i = 0; i < N_MASTER_PORT; i = i + 1) begin : _REVERSING_VALID_READY_MASTER
			for (j = 0; j < N_SLAVE_PORT; j = j + 1) begin : _REVERSING_VALID_READY_SLAVE
				assign arvalid_int_reverse[(i * N_SLAVE_PORT) + j] = arvalid_int[(j * N_MASTER_PORT) + i];
				assign awvalid_int_reverse[(i * N_SLAVE_PORT) + j] = awvalid_int[(j * N_MASTER_PORT) + i];
				assign wvalid_int_reverse[(i * N_SLAVE_PORT) + j] = wvalid_int[(j * N_MASTER_PORT) + i];
				assign bvalid_int_reverse[(j * N_MASTER_PORT) + i] = bvalid_int[(i * N_SLAVE_PORT) + j];
				assign rvalid_int_reverse[(j * N_MASTER_PORT) + i] = rvalid_int[(i * N_SLAVE_PORT) + j];
				assign arready_int_reverse[(j * N_MASTER_PORT) + i] = arready_int[(i * N_SLAVE_PORT) + j];
				assign awready_int_reverse[(j * N_MASTER_PORT) + i] = awready_int[(i * N_SLAVE_PORT) + j];
				assign wready_int_reverse[(j * N_MASTER_PORT) + i] = wready_int[(i * N_SLAVE_PORT) + j];
				assign bready_int_reverse[(i * N_SLAVE_PORT) + j] = bready_int[(j * N_MASTER_PORT) + i];
				assign rready_int_reverse[(i * N_SLAVE_PORT) + j] = rready_int[(j * N_MASTER_PORT) + i];
			end
		end
		for (i = 0; i < N_MASTER_PORT; i = i + 1) begin : _REQ_BLOCK_GEN
			axi_request_block #(
				.AXI_ADDRESS_W(AXI_ADDRESS_W),
				.AXI_DATA_W(AXI_DATA_W),
				.AXI_USER_W(AXI_USER_W),
				.N_INIT_PORT(N_MASTER_PORT),
				.N_TARG_PORT(N_SLAVE_PORT),
				.FIFO_DW_DEPTH(FIFO_DEPTH_DW),
				.AXI_ID_IN(AXI_ID_IN)
			) REQ_BLOCK(
				.clk(clk),
				.rst_n(rst_n),
				.test_en_i(test_en_i),
				.awid_i(slave_awid_i),
				.awaddr_i(slave_awaddr_i),
				.awlen_i(slave_awlen_i),
				.awsize_i(slave_awsize_i),
				.awburst_i(slave_awburst_i),
				.awlock_i(slave_awlock_i),
				.awcache_i(slave_awcache_i),
				.awprot_i(slave_awprot_i),
				.awregion_i(slave_awregion_i),
				.awuser_i(slave_awuser_i),
				.awqos_i(slave_awqos_i),
				.awvalid_i(awvalid_int_reverse[i * N_SLAVE_PORT+:N_SLAVE_PORT]),
				.awready_o(awready_int[i * N_SLAVE_PORT+:N_SLAVE_PORT]),
				.wdata_i(slave_wdata_i),
				.wstrb_i(slave_wstrb_i),
				.wlast_i(slave_wlast_i),
				.wuser_i(slave_wuser_i),
				.wvalid_i(wvalid_int_reverse[i * N_SLAVE_PORT+:N_SLAVE_PORT]),
				.wready_o(wready_int[i * N_SLAVE_PORT+:N_SLAVE_PORT]),
				.arid_i(slave_arid_i),
				.araddr_i(slave_araddr_i),
				.arlen_i(slave_arlen_i),
				.arsize_i(slave_arsize_i),
				.arburst_i(slave_arburst_i),
				.arlock_i(slave_arlock_i),
				.arcache_i(slave_arcache_i),
				.arprot_i(slave_arprot_i),
				.arregion_i(slave_arregion_i),
				.aruser_i(slave_aruser_i),
				.arqos_i(slave_arqos_i),
				.arvalid_i(arvalid_int_reverse[i * N_SLAVE_PORT+:N_SLAVE_PORT]),
				.arready_o(arready_int[i * N_SLAVE_PORT+:N_SLAVE_PORT]),
				.bid_i(master_bid_i[i * AXI_ID_OUT+:AXI_ID_OUT]),
				.bvalid_i(master_bvalid_i[i]),
				.bready_o(master_bready_o[i]),
				.bvalid_o(bvalid_int[i * N_SLAVE_PORT+:N_SLAVE_PORT]),
				.bready_i(bready_int_reverse[i * N_SLAVE_PORT+:N_SLAVE_PORT]),
				.rid_i(master_rid_i[i * AXI_ID_OUT+:AXI_ID_OUT]),
				.rvalid_i(master_rvalid_i[i]),
				.rready_o(master_rready_o[i]),
				.rvalid_o(rvalid_int[i * N_SLAVE_PORT+:N_SLAVE_PORT]),
				.rready_i(rready_int_reverse[i * N_SLAVE_PORT+:N_SLAVE_PORT]),
				.awid_o(master_awid_o[i * AXI_ID_OUT+:AXI_ID_OUT]),
				.awaddr_o(master_awaddr_o[i * AXI_ADDRESS_W+:AXI_ADDRESS_W]),
				.awlen_o(master_awlen_o[i * 8+:8]),
				.awsize_o(master_awsize_o[i * 3+:3]),
				.awburst_o(master_awburst_o[i * 2+:2]),
				.awlock_o(master_awlock_o[i]),
				.awcache_o(master_awcache_o[i * 4+:4]),
				.awprot_o(master_awprot_o[i * 3+:3]),
				.awregion_o(master_awregion_o[i * 4+:4]),
				.awuser_o(master_awuser_o[i * AXI_USER_W+:AXI_USER_W]),
				.awqos_o(master_awqos_o[i * 4+:4]),
				.awvalid_o(master_awvalid_o[i]),
				.awready_i(master_awready_i[i]),
				.wdata_o(master_wdata_o[i * AXI_DATA_W+:AXI_DATA_W]),
				.wstrb_o(master_wstrb_o[i * AXI_NUMBYTES+:AXI_NUMBYTES]),
				.wlast_o(master_wlast_o[i]),
				.wuser_o(master_wuser_o[i * AXI_USER_W+:AXI_USER_W]),
				.wvalid_o(master_wvalid_o[i]),
				.wready_i(master_wready_i[i]),
				.arid_o(master_arid_o[i * AXI_ID_OUT+:AXI_ID_OUT]),
				.araddr_o(master_araddr_o[i * AXI_ADDRESS_W+:AXI_ADDRESS_W]),
				.arlen_o(master_arlen_o[i * 8+:8]),
				.arsize_o(master_arsize_o[i * 3+:3]),
				.arburst_o(master_arburst_o[i * 2+:2]),
				.arlock_o(master_arlock_o[i]),
				.arcache_o(master_arcache_o[i * 4+:4]),
				.arprot_o(master_arprot_o[i * 3+:3]),
				.arregion_o(master_arregion_o[i * 4+:4]),
				.aruser_o(master_aruser_o[i * AXI_USER_W+:AXI_USER_W]),
				.arqos_o(master_arqos_o[i * 4+:4]),
				.arvalid_o(master_arvalid_o[i]),
				.arready_i(master_arready_i[i])
			);
		end
		for (i = 0; i < N_SLAVE_PORT; i = i + 1) begin : _RESP_BLOCK_GEN
			axi_response_block #(
				.AXI_ADDRESS_W(AXI_ADDRESS_W),
				.AXI_DATA_W(AXI_DATA_W),
				.AXI_USER_W(AXI_USER_W),
				.N_INIT_PORT(N_MASTER_PORT),
				.N_TARG_PORT(N_SLAVE_PORT),
				.FIFO_DEPTH_DW(FIFO_DEPTH_DW),
				.AXI_ID_IN(AXI_ID_IN),
				.N_REGION(N_REGION)
			) RESP_BLOCK(
				.clk(clk),
				.rst_n(rst_n),
				.test_en_i(test_en_i),
				.rid_i(master_rid_i),
				.rdata_i(master_rdata_i),
				.rresp_i(master_rresp_i),
				.rlast_i(master_rlast_i),
				.ruser_i(master_ruser_i),
				.rvalid_i(rvalid_int_reverse[i * N_MASTER_PORT+:N_MASTER_PORT]),
				.rready_o(rready_int[i * N_MASTER_PORT+:N_MASTER_PORT]),
				.bid_i(master_bid_i),
				.bresp_i(master_bresp_i),
				.buser_i(master_buser_i),
				.bvalid_i(bvalid_int_reverse[i * N_MASTER_PORT+:N_MASTER_PORT]),
				.bready_o(bready_int[i * N_MASTER_PORT+:N_MASTER_PORT]),
				.rid_o(slave_rid_o[i * AXI_ID_IN+:AXI_ID_IN]),
				.rdata_o(slave_rdata_o[i * AXI_DATA_W+:AXI_DATA_W]),
				.rresp_o(slave_rresp_o[i * 2+:2]),
				.rlast_o(slave_rlast_o[i]),
				.ruser_o(slave_ruser_o[i * AXI_USER_W+:AXI_USER_W]),
				.rvalid_o(slave_rvalid_o[i]),
				.rready_i(slave_rready_i[i]),
				.bid_o(slave_bid_o[i * AXI_ID_IN+:AXI_ID_IN]),
				.bresp_o(slave_bresp_o[i * 2+:2]),
				.buser_o(slave_buser_o[i * AXI_USER_W+:AXI_USER_W]),
				.bvalid_o(slave_bvalid_o[i]),
				.bready_i(slave_bready_i[i]),
				.arvalid_i(slave_arvalid_i[i]),
				.araddr_i(slave_araddr_i[i * AXI_ADDRESS_W+:AXI_ADDRESS_W]),
				.arready_o(slave_arready_o[i]),
				.arlen_i(slave_arlen_i[i * 8+:8]),
				.aruser_i(slave_aruser_i[i * AXI_USER_W+:AXI_USER_W]),
				.arid_i(slave_arid_i[i * AXI_ID_IN+:AXI_ID_IN]),
				.arvalid_o(arvalid_int[i * N_MASTER_PORT+:N_MASTER_PORT]),
				.arready_i(arready_int_reverse[i * N_MASTER_PORT+:N_MASTER_PORT]),
				.awvalid_i(slave_awvalid_i[i]),
				.awaddr_i(slave_awaddr_i[i * AXI_ADDRESS_W+:AXI_ADDRESS_W]),
				.awready_o(slave_awready_o[i]),
				.awuser_i(slave_awuser_i[i * AXI_USER_W+:AXI_USER_W]),
				.awid_i(slave_awid_i[i * AXI_ID_IN+:AXI_ID_IN]),
				.awvalid_o(awvalid_int[i * N_MASTER_PORT+:N_MASTER_PORT]),
				.awready_i(awready_int_reverse[i * N_MASTER_PORT+:N_MASTER_PORT]),
				.wvalid_i(slave_wvalid_i[i]),
				.wlast_i(slave_wlast_i[i]),
				.wready_o(slave_wready_o[i]),
				.wvalid_o(wvalid_int[i * N_MASTER_PORT+:N_MASTER_PORT]),
				.wready_i(wready_int_reverse[i * N_MASTER_PORT+:N_MASTER_PORT]),
				.START_ADDR_i(START_ADDR),
				.END_ADDR_i(END_ADDR),
				.enable_region_i(valid_rule),
				.connectivity_map_i(connectivity_map[i * N_MASTER_PORT+:N_MASTER_PORT])
			);
		end
	endgenerate
	assign START_ADDR = cfg_START_ADDR_i;
	assign END_ADDR = cfg_END_ADDR_i;
	assign connectivity_map = cfg_connectivity_map_i;
	generate
		for (i = 0; i < N_REGION; i = i + 1) begin : _VALID_RULE_REGION
			for (j = 0; j < N_MASTER_PORT; j = j + 1) begin : _VALID_RULE_MASTER
				assign valid_rule[(i * N_MASTER_PORT) + j] = cfg_valid_rule_i[(i * N_MASTER_PORT) + j];
			end
		end
	endgenerate
endmodule
