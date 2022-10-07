module axi_BR_allocator 
#(
    parameter                   AXI_USER_W     = 6,
    parameter                   N_INIT_PORT    = 1,
    parameter                   N_TARG_PORT    = 7,
    parameter                   AXI_DATA_W     = 64,
    parameter                   AXI_ID_IN      = 16,
    parameter                   LOG_N_TARG     = $clog2(N_TARG_PORT),
    parameter                   LOG_N_INIT     = $clog2(N_INIT_PORT),
    parameter                   AXI_ID_OUT     = AXI_ID_IN + $clog2(N_TARG_PORT)
)
(
	clk,
	rst_n,
	rid_i,
	rdata_i,
	rresp_i,
	rlast_i,
	ruser_i,
	rvalid_i,
	rready_o,
	rid_o,
	rdata_o,
	rresp_o,
	rlast_o,
	ruser_o,
	rvalid_o,
	rready_i,
	incr_req_i,
	full_counter_o,
	outstanding_trans_o,
	error_req_i,
	error_gnt_o,
	error_len_i,
	error_user_i,
	error_id_i,
	sample_ardata_info_i
);
	//parameter AXI_USER_W = 6;
	//parameter N_INIT_PORT = 1;
	//parameter N_TARG_PORT = 7;
	//parameter AXI_DATA_W = 64;
	//parameter AXI_ID_IN = 16;
	//parameter LOG_N_TARG = $clog2(N_TARG_PORT);
	//parameter LOG_N_INIT = $clog2(N_INIT_PORT);
	//parameter AXI_ID_OUT = AXI_ID_IN + $clog2(N_TARG_PORT);
	input wire clk;
	input wire rst_n;
	input wire [(N_INIT_PORT * AXI_ID_OUT) - 1:0] rid_i;
	input wire [(N_INIT_PORT * AXI_DATA_W) - 1:0] rdata_i;
	input wire [(N_INIT_PORT * 2) - 1:0] rresp_i;
	input wire [N_INIT_PORT - 1:0] rlast_i;
	input wire [(N_INIT_PORT * AXI_USER_W) - 1:0] ruser_i;
	input wire [N_INIT_PORT - 1:0] rvalid_i;
	output wire [N_INIT_PORT - 1:0] rready_o;
	output reg [AXI_ID_IN - 1:0] rid_o;
	output reg [AXI_DATA_W - 1:0] rdata_o;
	output reg [1:0] rresp_o;
	output reg rlast_o;
	output reg [AXI_USER_W - 1:0] ruser_o;
	output reg rvalid_o;
	input wire rready_i;
	input wire incr_req_i;
	output wire full_counter_o;
	output wire outstanding_trans_o;
	input wire error_req_i;
	output reg error_gnt_o;
	input wire [7:0] error_len_i;
	input wire [AXI_USER_W - 1:0] error_user_i;
	input wire [AXI_ID_IN - 1:0] error_id_i;
	input wire sample_ardata_info_i;
	localparam AUX_WIDTH = (AXI_DATA_W + 3) + AXI_USER_W;
	wire [(N_INIT_PORT * AUX_WIDTH) - 1:0] AUX_VECTOR_IN;
	wire [AUX_WIDTH - 1:0] AUX_VECTOR_OUT;
	wire [(N_INIT_PORT * AXI_ID_IN) - 1:0] rid_int;
	genvar i;
	reg [9:0] outstanding_counter;
	wire decr_req;
	reg [1:0] CS;
	reg [1:0] NS;
	reg [7:0] CounterBurstCS;
	reg [7:0] CounterBurstNS;
	reg [7:0] error_len_S;
	reg [AXI_USER_W - 1:0] error_user_S;
	reg [AXI_ID_IN - 1:0] error_id_S;
	wire [AXI_ID_IN - 1:0] rid_ARB_TREE;
	wire [AXI_DATA_W - 1:0] rdata_ARB_TREE;
	wire [1:0] rresp_ARB_TREE;
	wire rlast_ARB_TREE;
	wire [AXI_USER_W - 1:0] ruser_ARB_TREE;
	wire rvalid_ARB_TREE;
	reg rready_ARB_TREE;
	assign outstanding_trans_o = (outstanding_counter == {10 {1'sb0}} ? 1'b0 : 1'b1);
	assign decr_req = (rvalid_ARB_TREE & rready_ARB_TREE) & rlast_ARB_TREE;
	assign full_counter_o = (outstanding_counter == {10 {1'sb1}} ? 1'b1 : 1'b0);
	always @(posedge clk or negedge rst_n)
		if (rst_n == 1'b0)
			outstanding_counter <= 1'sb0;
		else
			case ({incr_req_i, decr_req})
				2'b00: outstanding_counter <= outstanding_counter;
				2'b01:
					if (outstanding_counter != {10 {1'sb0}})
						outstanding_counter <= outstanding_counter - 1'b1;
					else
						outstanding_counter <= 1'sb0;
				2'b10:
					if (outstanding_counter != {10 {1'sb1}})
						outstanding_counter <= outstanding_counter + 1'b1;
					else
						outstanding_counter <= 1'sb1;
				2'b11: outstanding_counter <= outstanding_counter;
			endcase
	always @(posedge clk or negedge rst_n)
		if (rst_n == 1'b0) begin
			CS <= 2'd0;
			CounterBurstCS <= 1'sb0;
			error_user_S <= 1'sb0;
			error_id_S <= 1'sb0;
			error_len_S <= 1'sb0;
		end
		else begin
			CS <= NS;
			CounterBurstCS <= CounterBurstNS;
			if (sample_ardata_info_i) begin
				error_user_S <= error_user_i;
				error_id_S <= error_id_i;
				error_len_S <= error_len_i;
			end
		end
	always @(*) begin
		rid_o = rid_ARB_TREE;
		rdata_o = rdata_ARB_TREE;
		rresp_o = rresp_ARB_TREE;
		rlast_o = rlast_ARB_TREE;
		ruser_o = ruser_ARB_TREE;
		rvalid_o = rvalid_ARB_TREE;
		rready_ARB_TREE = rready_i;
		CounterBurstNS = CounterBurstCS;
		error_gnt_o = 1'b0;
		case (CS)
			2'd0: begin
				CounterBurstNS = 1'sb0;
				rready_ARB_TREE = rready_i;
				error_gnt_o = 1'b0;
				if (error_req_i == 1'b1) begin
					if (outstanding_trans_o == 1'b0) begin
						if (error_len_i == {8 {1'sb0}})
							NS = 2'd1;
						else
							NS = 2'd2;
					end
					else
						NS = 2'd3;
				end
				else
					NS = 2'd0;
			end
			2'd3: begin
				CounterBurstNS = 1'sb0;
				rready_ARB_TREE = rready_i;
				error_gnt_o = 1'b0;
				if (outstanding_trans_o == 1'b0) begin
					if (error_len_S == {8 {1'sb0}})
						NS = 2'd1;
					else
						NS = 2'd2;
				end
				else
					NS = 2'd3;
			end
			2'd1: begin
				rready_ARB_TREE = 1'b0;
				CounterBurstNS = 1'sb0;
				error_gnt_o = 1'b1;
				rresp_o = 2'b11;
				rdata_o = {AXI_DATA_W / 32 {32'hdeadbeef}};
				rvalid_o = 1'b1;
				ruser_o = error_user_S;
				rlast_o = 1'b1;
				rid_o = error_id_S;
				if (rready_i)
					NS = 2'd0;
				else
					NS = 2'd1;
			end
			2'd2: begin
				rready_ARB_TREE = 1'b0;
				rresp_o = 2'b11;
				rdata_o = {AXI_DATA_W / 32 {32'hdeadbeef}};
				rvalid_o = 1'b1;
				ruser_o = error_user_S;
				rid_o = error_id_S;
				if (rready_i) begin
					if (CounterBurstCS < error_len_i) begin
						CounterBurstNS = CounterBurstCS + 1'b1;
						error_gnt_o = 1'b0;
						rlast_o = 1'b0;
						NS = 2'd2;
					end
					else begin
						error_gnt_o = 1'b1;
						CounterBurstNS = 1'sb0;
						NS = 2'd0;
						rlast_o = 1'b1;
					end
				end
				else begin
					NS = 2'd2;
					error_gnt_o = 1'b0;
				end
			end
			default: begin
				CounterBurstNS = 1'sb0;
				NS = 2'd0;
				error_gnt_o = 1'b0;
			end
		endcase
	end
	assign {ruser_ARB_TREE, rlast_ARB_TREE, rresp_ARB_TREE, rdata_ARB_TREE} = AUX_VECTOR_OUT;
	generate
		for (i = 0; i < N_INIT_PORT; i = i + 1) begin : AUX_VECTOR_BINDING
			assign AUX_VECTOR_IN[i * AUX_WIDTH+:AUX_WIDTH] = {ruser_i[i * AXI_USER_W+:AXI_USER_W], rlast_i[i], rresp_i[i * 2+:2], rdata_i[i * AXI_DATA_W+:AXI_DATA_W]};
		end
		for (i = 0; i < N_INIT_PORT; i = i + 1) begin : RID_VECTOR_BINDING
			assign rid_int[i * AXI_ID_IN+:AXI_ID_IN] = rid_i[(i * AXI_ID_OUT) + (AXI_ID_IN - 1)-:AXI_ID_IN];
		end
		if (N_INIT_PORT == 1) begin : DIRECT_BINDING
			assign rvalid_ARB_TREE = rvalid_i;
			assign AUX_VECTOR_OUT = AUX_VECTOR_IN;
			assign rid_ARB_TREE = rid_int;
			assign rready_o = rready_i;
		end
		else begin : ARB_TREE
			axi_ArbitrationTree #(
				.AUX_WIDTH(AUX_WIDTH),
				.ID_WIDTH(AXI_ID_IN),
				.N_MASTER(N_INIT_PORT)
			) BR_ARB_TREE(
				.clk(clk),
				.rst_n(rst_n),
				.data_req_i(rvalid_i),
				.data_AUX_i(AUX_VECTOR_IN),
				.data_ID_i(rid_int),
				.data_gnt_o(rready_o),
				.data_req_o(rvalid_ARB_TREE),
				.data_AUX_o(AUX_VECTOR_OUT),
				.data_ID_o(rid_ARB_TREE),
				.data_gnt_i(rready_ARB_TREE),
				.lock(1'b0),
				.SEL_EXCLUSIVE({$clog2(N_INIT_PORT) {1'b0}})
			);
		end
	endgenerate
endmodule
