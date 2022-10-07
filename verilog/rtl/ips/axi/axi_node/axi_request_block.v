module axi_request_block 
#(
    parameter                   AXI_ADDRESS_W  = 32,
    parameter                   AXI_DATA_W     = 64,
    parameter                   AXI_NUMBYTES   = AXI_DATA_W/8,
    parameter                   AXI_USER_W     = 6,

    parameter                   N_INIT_PORT    = 5,
    parameter                   N_TARG_PORT    = 8,
    parameter                   FIFO_DW_DEPTH  = 8,

    parameter                   AXI_ID_IN      = 16,

    parameter                   LOG_N_TARG     = $clog2(N_TARG_PORT),
    parameter                   AXI_ID_OUT     = AXI_ID_IN + LOG_N_TARG
)
(
	clk,
	rst_n,
	test_en_i,
	awid_i,
	awaddr_i,
	awlen_i,
	awsize_i,
	awburst_i,
	awlock_i,
	awcache_i,
	awprot_i,
	awregion_i,
	awuser_i,
	awqos_i,
	awvalid_i,
	awready_o,
	wdata_i,
	wstrb_i,
	wlast_i,
	wuser_i,
	wvalid_i,
	wready_o,
	arid_i,
	araddr_i,
	arlen_i,
	arsize_i,
	arburst_i,
	arlock_i,
	arcache_i,
	arprot_i,
	arregion_i,
	aruser_i,
	arqos_i,
	arvalid_i,
	arready_o,
	bid_i,
	bvalid_i,
	bready_o,
	bvalid_o,
	bready_i,
	rid_i,
	rvalid_i,
	rready_o,
	rvalid_o,
	rready_i,
	awid_o,
	awaddr_o,
	awlen_o,
	awsize_o,
	awburst_o,
	awlock_o,
	awcache_o,
	awprot_o,
	awregion_o,
	awuser_o,
	awqos_o,
	awvalid_o,
	awready_i,
	wdata_o,
	wstrb_o,
	wlast_o,
	wuser_o,
	wvalid_o,
	wready_i,
	arid_o,
	araddr_o,
	arlen_o,
	arsize_o,
	arburst_o,
	arlock_o,
	arcache_o,
	arprot_o,
	arregion_o,
	aruser_o,
	arqos_o,
	arvalid_o,
	arready_i
);
	//parameter AXI_ADDRESS_W = 32;
	//parameter AXI_DATA_W = 64;
	//parameter AXI_NUMBYTES = AXI_DATA_W / 8;
	//parameter AXI_USER_W = 6;
	//parameter N_INIT_PORT = 5;
	//parameter N_TARG_PORT = 8;
	//parameter FIFO_DW_DEPTH = 8;
	//parameter AXI_ID_IN = 16;
	//parameter LOG_N_TARG = $clog2(N_TARG_PORT);
	//parameter AXI_ID_OUT = AXI_ID_IN + LOG_N_TARG;
	input wire clk;
	input wire rst_n;
	input wire test_en_i;
	input wire [(N_TARG_PORT * AXI_ID_IN) - 1:0] awid_i;
	input wire [(N_TARG_PORT * AXI_ADDRESS_W) - 1:0] awaddr_i;
	input wire [(N_TARG_PORT * 8) - 1:0] awlen_i;
	input wire [(N_TARG_PORT * 3) - 1:0] awsize_i;
	input wire [(N_TARG_PORT * 2) - 1:0] awburst_i;
	input wire [N_TARG_PORT - 1:0] awlock_i;
	input wire [(N_TARG_PORT * 4) - 1:0] awcache_i;
	input wire [(N_TARG_PORT * 3) - 1:0] awprot_i;
	input wire [(N_TARG_PORT * 4) - 1:0] awregion_i;
	input wire [(N_TARG_PORT * AXI_USER_W) - 1:0] awuser_i;
	input wire [(N_TARG_PORT * 4) - 1:0] awqos_i;
	input wire [N_TARG_PORT - 1:0] awvalid_i;
	output wire [N_TARG_PORT - 1:0] awready_o;
	input wire [(N_TARG_PORT * AXI_DATA_W) - 1:0] wdata_i;
	input wire [(N_TARG_PORT * AXI_NUMBYTES) - 1:0] wstrb_i;
	input wire [N_TARG_PORT - 1:0] wlast_i;
	input wire [(N_TARG_PORT * AXI_USER_W) - 1:0] wuser_i;
	input wire [N_TARG_PORT - 1:0] wvalid_i;
	output wire [N_TARG_PORT - 1:0] wready_o;
	input wire [(N_TARG_PORT * AXI_ID_IN) - 1:0] arid_i;
	input wire [(N_TARG_PORT * AXI_ADDRESS_W) - 1:0] araddr_i;
	input wire [(N_TARG_PORT * 8) - 1:0] arlen_i;
	input wire [(N_TARG_PORT * 3) - 1:0] arsize_i;
	input wire [(N_TARG_PORT * 2) - 1:0] arburst_i;
	input wire [N_TARG_PORT - 1:0] arlock_i;
	input wire [(N_TARG_PORT * 4) - 1:0] arcache_i;
	input wire [(N_TARG_PORT * 3) - 1:0] arprot_i;
	input wire [(N_TARG_PORT * 4) - 1:0] arregion_i;
	input wire [(N_TARG_PORT * AXI_USER_W) - 1:0] aruser_i;
	input wire [(N_TARG_PORT * 4) - 1:0] arqos_i;
	input wire [N_TARG_PORT - 1:0] arvalid_i;
	output wire [N_TARG_PORT - 1:0] arready_o;
	input wire [AXI_ID_OUT - 1:0] bid_i;
	input wire bvalid_i;
	output wire bready_o;
	output wire [N_TARG_PORT - 1:0] bvalid_o;
	input wire [N_TARG_PORT - 1:0] bready_i;
	input wire [AXI_ID_OUT - 1:0] rid_i;
	input wire rvalid_i;
	output wire rready_o;
	output wire [N_TARG_PORT - 1:0] rvalid_o;
	input wire [N_TARG_PORT - 1:0] rready_i;
	output wire [AXI_ID_OUT - 1:0] awid_o;
	output wire [AXI_ADDRESS_W - 1:0] awaddr_o;
	output wire [7:0] awlen_o;
	output wire [2:0] awsize_o;
	output wire [1:0] awburst_o;
	output wire awlock_o;
	output wire [3:0] awcache_o;
	output wire [2:0] awprot_o;
	output wire [3:0] awregion_o;
	output wire [AXI_USER_W - 1:0] awuser_o;
	output wire [3:0] awqos_o;
	output wire awvalid_o;
	input wire awready_i;
	output wire [AXI_DATA_W - 1:0] wdata_o;
	output wire [AXI_NUMBYTES - 1:0] wstrb_o;
	output wire wlast_o;
	output wire [AXI_USER_W - 1:0] wuser_o;
	output wire wvalid_o;
	input wire wready_i;
	output wire [AXI_ID_OUT - 1:0] arid_o;
	output wire [AXI_ADDRESS_W - 1:0] araddr_o;
	output wire [7:0] arlen_o;
	output wire [2:0] arsize_o;
	output wire [1:0] arburst_o;
	output wire arlock_o;
	output wire [3:0] arcache_o;
	output wire [2:0] arprot_o;
	output wire [3:0] arregion_o;
	output wire [AXI_USER_W - 1:0] aruser_o;
	output wire [3:0] arqos_o;
	output wire arvalid_o;
	input wire arready_i;
	wire push_ID;
	wire [(LOG_N_TARG + N_TARG_PORT) - 1:0] ID;
	wire grant_FIFO_ID;
	axi_AR_allocator #(
		.AXI_ADDRESS_W(AXI_ADDRESS_W),
		.AXI_USER_W(AXI_USER_W),
		.N_TARG_PORT(N_TARG_PORT),
		.AXI_ID_IN(AXI_ID_IN)
	) AR_ALLOCATOR(
		.clk(clk),
		.rst_n(rst_n),
		.arid_i(arid_i),
		.araddr_i(araddr_i),
		.arlen_i(arlen_i),
		.arsize_i(arsize_i),
		.arburst_i(arburst_i),
		.arlock_i(arlock_i),
		.arcache_i(arcache_i),
		.arprot_i(arprot_i),
		.arregion_i(arregion_i),
		.aruser_i(aruser_i),
		.arqos_i(arqos_i),
		.arvalid_i(arvalid_i),
		.arready_o(arready_o),
		.arid_o(arid_o),
		.araddr_o(araddr_o),
		.arlen_o(arlen_o),
		.arsize_o(arsize_o),
		.arburst_o(arburst_o),
		.arlock_o(arlock_o),
		.arcache_o(arcache_o),
		.arprot_o(arprot_o),
		.arregion_o(arregion_o),
		.aruser_o(aruser_o),
		.arqos_o(arqos_o),
		.arvalid_o(arvalid_o),
		.arready_i(arready_i)
	);
	axi_AW_allocator #(
		.AXI_ADDRESS_W(AXI_ADDRESS_W),
		.AXI_USER_W(AXI_USER_W),
		.N_TARG_PORT(N_TARG_PORT),
		.AXI_ID_IN(AXI_ID_IN)
	) AW_ALLOCATOR(
		.clk(clk),
		.rst_n(rst_n),
		.awid_i(awid_i),
		.awaddr_i(awaddr_i),
		.awlen_i(awlen_i),
		.awsize_i(awsize_i),
		.awburst_i(awburst_i),
		.awlock_i(awlock_i),
		.awcache_i(awcache_i),
		.awprot_i(awprot_i),
		.awregion_i(awregion_i),
		.awuser_i(awuser_i),
		.awqos_i(awqos_i),
		.awvalid_i(awvalid_i),
		.awready_o(awready_o),
		.awid_o(awid_o),
		.awaddr_o(awaddr_o),
		.awlen_o(awlen_o),
		.awsize_o(awsize_o),
		.awburst_o(awburst_o),
		.awlock_o(awlock_o),
		.awcache_o(awcache_o),
		.awprot_o(awprot_o),
		.awregion_o(awregion_o),
		.awuser_o(awuser_o),
		.awqos_o(awqos_o),
		.awvalid_o(awvalid_o),
		.awready_i(awready_i),
		.push_ID_o(push_ID),
		.ID_o(ID),
		.grant_FIFO_ID_i(grant_FIFO_ID)
	);
	axi_DW_allocator #(
		.AXI_USER_W(AXI_USER_W),
		.N_TARG_PORT(N_TARG_PORT),
		.FIFO_DEPTH(FIFO_DW_DEPTH),
		.AXI_DATA_W(AXI_DATA_W)
	) DW_ALLOC(
		.clk(clk),
		.rst_n(rst_n),
		.test_en_i(test_en_i),
		.wdata_i(wdata_i),
		.wstrb_i(wstrb_i),
		.wlast_i(wlast_i),
		.wuser_i(wuser_i),
		.wvalid_i(wvalid_i),
		.wready_o(wready_o),
		.wdata_o(wdata_o),
		.wstrb_o(wstrb_o),
		.wlast_o(wlast_o),
		.wuser_o(wuser_o),
		.wvalid_o(wvalid_o),
		.wready_i(wready_i),
		.push_ID_i(push_ID),
		.ID_i(ID),
		.grant_FIFO_ID_o(grant_FIFO_ID)
	);
	axi_address_decoder_BW #(
		.N_TARG_PORT(N_TARG_PORT),
		.AXI_ID_IN(AXI_ID_IN)
	) BW_DECODER(
		.bid_i(bid_i),
		.bvalid_i(bvalid_i),
		.bready_o(bready_o),
		.bvalid_o(bvalid_o),
		.bready_i(bready_i)
	);
	axi_address_decoder_BR #(
		.N_TARG_PORT(N_TARG_PORT),
		.AXI_ID_IN(AXI_ID_IN)
	) BR_DECODER(
		.rid_i(rid_i),
		.rvalid_i(rvalid_i),
		.rready_o(rready_o),
		.rvalid_o(rvalid_o),
		.rready_i(rready_i)
	);
endmodule
