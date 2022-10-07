module axi_AR_allocator 
#(
      parameter AXI_ADDRESS_W  = 32,
      parameter AXI_USER_W     = 6,
      parameter N_TARG_PORT    = 7,
      parameter LOG_N_TARG     = $clog2(N_TARG_PORT),
      parameter AXI_ID_IN      = 16,
      parameter AXI_ID_OUT     = AXI_ID_IN + $clog2(N_TARG_PORT)
)
(
	clk,
	rst_n,
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
	//parameter AXI_USER_W = 6;
	//parameter N_TARG_PORT = 7;
	//parameter LOG_N_TARG = $clog2(N_TARG_PORT);
	//parameter AXI_ID_IN = 16;
	//parameter AXI_ID_OUT = AXI_ID_IN + $clog2(N_TARG_PORT);
	input wire clk;
	input wire rst_n;
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
	localparam AUX_WIDTH = (((AXI_ID_IN + AXI_ADDRESS_W) + 25) + AXI_USER_W) + 4;
	wire [(N_TARG_PORT * AUX_WIDTH) - 1:0] AUX_VECTOR_IN;
	wire [AUX_WIDTH - 1:0] AUX_VECTOR_OUT;
	wire [(N_TARG_PORT * (LOG_N_TARG + N_TARG_PORT)) - 1:0] ID_in;
	wire [(LOG_N_TARG + N_TARG_PORT) - 1:0] ID_int;
	genvar i;
	assign {arqos_o, aruser_o, arregion_o, arprot_o, arcache_o, arlock_o, arburst_o, arsize_o, arlen_o, araddr_o, arid_o[AXI_ID_IN - 1:0]} = AUX_VECTOR_OUT;
	assign arid_o[AXI_ID_OUT - 1:AXI_ID_IN] = ID_int[(LOG_N_TARG + N_TARG_PORT) - 1:N_TARG_PORT];
	generate
		for (i = 0; i < N_TARG_PORT; i = i + 1) begin : AUX_VECTOR_BINDING
			assign AUX_VECTOR_IN[i * AUX_WIDTH+:AUX_WIDTH] = {arqos_i[i * 4+:4], aruser_i[i * AXI_USER_W+:AXI_USER_W], arregion_i[i * 4+:4], arprot_i[i * 3+:3], arcache_i[i * 4+:4], arlock_i[i], arburst_i[i * 2+:2], arsize_i[i * 3+:3], arlen_i[i * 8+:8], araddr_i[i * AXI_ADDRESS_W+:AXI_ADDRESS_W], arid_i[i * AXI_ID_IN+:AXI_ID_IN]};
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
		.data_req_i(arvalid_i),
		.data_AUX_i(AUX_VECTOR_IN),
		.data_ID_i(ID_in),
		.data_gnt_o(arready_o),
		.data_req_o(arvalid_o),
		.data_AUX_o(AUX_VECTOR_OUT),
		.data_ID_o(ID_int),
		.data_gnt_i(arready_i),
		.lock(1'b0),
		.SEL_EXCLUSIVE({$clog2(N_TARG_PORT) {1'b0}})
	);
endmodule
