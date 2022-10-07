module axi_AW_allocator 
#(
      parameter  AXI_ADDRESS_W  = 32,
      parameter  AXI_USER_W     = 6,
      parameter  N_TARG_PORT    = 7,
      parameter  LOG_N_TARG     = $clog2(N_TARG_PORT),
      parameter  AXI_ID_IN      = 16,
      parameter  AXI_ID_OUT     = AXI_ID_IN + $clog2(N_TARG_PORT)
)
(
	clk,
	rst_n,
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
	push_ID_o,
	ID_o,
	grant_FIFO_ID_i
);
	//parameter AXI_ADDRESS_W = 32;
	//parameter AXI_USER_W = 6;
	//parameter N_TARG_PORT = 7;
	//parameter LOG_N_TARG = $clog2(N_TARG_PORT);
	//parameter AXI_ID_IN = 16;
	//parameter AXI_ID_OUT = AXI_ID_IN + $clog2(N_TARG_PORT);
	input wire clk;
	input wire rst_n;
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
	output wire push_ID_o;
	output wire [(LOG_N_TARG + N_TARG_PORT) - 1:0] ID_o;
	input wire grant_FIFO_ID_i;
	localparam AUX_WIDTH = (((AXI_ID_IN + AXI_ADDRESS_W) + 25) + AXI_USER_W) + 4;
	wire [(N_TARG_PORT * AUX_WIDTH) - 1:0] AUX_VECTOR_IN;
	wire [AUX_WIDTH - 1:0] AUX_VECTOR_OUT;
	wire [(N_TARG_PORT * (LOG_N_TARG + N_TARG_PORT)) - 1:0] ID_in;
	wire [N_TARG_PORT - 1:0] awready_int;
	wire awvalid_int;
	genvar i;
	assign {awqos_o, awuser_o, awregion_o, awprot_o, awcache_o, awlock_o, awburst_o, awsize_o, awlen_o, awaddr_o, awid_o[AXI_ID_IN - 1:0]} = AUX_VECTOR_OUT;
	assign awid_o[AXI_ID_OUT - 1:AXI_ID_IN] = ID_o[(LOG_N_TARG + N_TARG_PORT) - 1:N_TARG_PORT];
	assign awready_o = {N_TARG_PORT {grant_FIFO_ID_i}} & awready_int;
	assign awvalid_o = awvalid_int & grant_FIFO_ID_i;
	assign push_ID_o = (awvalid_o & awready_i) & grant_FIFO_ID_i;
	generate
		for (i = 0; i < N_TARG_PORT; i = i + 1) begin : AUX_VECTOR_BINDING
			assign AUX_VECTOR_IN[i * AUX_WIDTH+:AUX_WIDTH] = {awqos_i[i * 4+:4], awuser_i[i * AXI_USER_W+:AXI_USER_W], awregion_i[i * 4+:4], awprot_i[i * 3+:3], awcache_i[i * 4+:4], awlock_i[i], awburst_i[i * 2+:2], awsize_i[i * 3+:3], awlen_i[i * 8+:8], awaddr_i[i * AXI_ADDRESS_W+:AXI_ADDRESS_W], awid_i[i * AXI_ID_IN+:AXI_ID_IN]};
		end
		for (i = 0; i < N_TARG_PORT; i = i + 1) begin : ID_VECTOR_BINDING
			assign ID_in[(i * (LOG_N_TARG + N_TARG_PORT)) + (N_TARG_PORT - 1)-:N_TARG_PORT] = 2 ** i;
			assign ID_in[(i * (LOG_N_TARG + N_TARG_PORT)) + (((LOG_N_TARG + N_TARG_PORT) - 1) >= N_TARG_PORT ? (LOG_N_TARG + N_TARG_PORT) - 1 : (((LOG_N_TARG + N_TARG_PORT) - 1) + (((LOG_N_TARG + N_TARG_PORT) - 1) >= N_TARG_PORT ? (((LOG_N_TARG + N_TARG_PORT) - 1) - N_TARG_PORT) + 1 : (N_TARG_PORT - ((LOG_N_TARG + N_TARG_PORT) - 1)) + 1)) - 1)-:(((LOG_N_TARG + N_TARG_PORT) - 1) >= N_TARG_PORT ? (((LOG_N_TARG + N_TARG_PORT) - 1) - N_TARG_PORT) + 1 : (N_TARG_PORT - ((LOG_N_TARG + N_TARG_PORT) - 1)) + 1)] = i;
		end
	endgenerate
	axi_ArbitrationTree #(
		.AUX_WIDTH(AUX_WIDTH),
		.ID_WIDTH(LOG_N_TARG + N_TARG_PORT),
		.N_MASTER(N_TARG_PORT)
	) AW_ARB_TREE(
		.clk(clk),
		.rst_n(rst_n),
		.data_req_i(awvalid_i),
		.data_AUX_i(AUX_VECTOR_IN),
		.data_ID_i(ID_in),
		.data_gnt_o(awready_int),
		.data_req_o(awvalid_int),
		.data_AUX_o(AUX_VECTOR_OUT),
		.data_ID_o(ID_o),
		.data_gnt_i(awready_i),
		.lock(1'b0),
		.SEL_EXCLUSIVE({$clog2(N_TARG_PORT) {1'b0}})
	);
endmodule
