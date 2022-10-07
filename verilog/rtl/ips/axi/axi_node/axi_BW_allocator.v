module axi_BW_allocator 
#(
    parameter                   AXI_USER_W     = 6,
    parameter                   N_INIT_PORT    = 1,
    parameter                   N_TARG_PORT    = 7,
    parameter                   AXI_DATA_W     = 64,
    parameter                   AXI_ID_IN      = 16,
    parameter                   AXI_ID_OUT     = AXI_ID_IN + $clog2(N_TARG_PORT)
)
(
	clk,
	rst_n,
	bid_i,
	bresp_i,
	buser_i,
	bvalid_i,
	bready_o,
	bid_o,
	bresp_o,
	buser_o,
	bvalid_o,
	bready_i,
	incr_req_i,
	full_counter_o,
	outstanding_trans_o,
	sample_awdata_info_i,
	error_req_i,
	error_gnt_o,
	error_user_i,
	error_id_i
);
	//parameter AXI_USER_W = 6;
	//parameter N_INIT_PORT = 1;
	//parameter N_TARG_PORT = 7;
	//parameter AXI_DATA_W = 64;
	//parameter AXI_ID_IN = 16;
	//parameter AXI_ID_OUT = AXI_ID_IN + $clog2(N_TARG_PORT);
	input wire clk;
	input wire rst_n;
	input wire [(N_INIT_PORT * AXI_ID_OUT) - 1:0] bid_i;
	input wire [(N_INIT_PORT * 2) - 1:0] bresp_i;
	input wire [(N_INIT_PORT * AXI_USER_W) - 1:0] buser_i;
	input wire [N_INIT_PORT - 1:0] bvalid_i;
	output wire [N_INIT_PORT - 1:0] bready_o;
	output reg [AXI_ID_IN - 1:0] bid_o;
	output reg [1:0] bresp_o;
	output reg [AXI_USER_W - 1:0] buser_o;
	output reg bvalid_o;
	input wire bready_i;
	input wire incr_req_i;
	output wire full_counter_o;
	output wire outstanding_trans_o;
	input wire sample_awdata_info_i;
	input wire error_req_i;
	output reg error_gnt_o;
	input wire [AXI_USER_W - 1:0] error_user_i;
	input wire [AXI_ID_IN - 1:0] error_id_i;
	localparam AUX_WIDTH = 2 + AXI_USER_W;
	wire [(N_INIT_PORT * AUX_WIDTH) - 1:0] AUX_VECTOR_IN;
	wire [AUX_WIDTH - 1:0] AUX_VECTOR_OUT;
	wire [(N_INIT_PORT * AXI_ID_IN) - 1:0] bid_int;
	genvar i;
	reg [9:0] outstanding_counter;
	wire decr_req;
	reg [AXI_USER_W - 1:0] error_user_S;
	reg [AXI_ID_IN - 1:0] error_id_S;
	reg [1:0] CS;
	reg [1:0] NS;
	wire [AXI_ID_IN - 1:0] bid_ARB_TREE;
	wire [1:0] bresp_ARB_TREE;
	wire [AXI_USER_W - 1:0] buser_ARB_TREE;
	wire bvalid_ARB_TREE;
	reg bready_ARB_TREE;
	assign {buser_ARB_TREE, bresp_ARB_TREE} = AUX_VECTOR_OUT;
	assign outstanding_trans_o = (outstanding_counter == {10 {1'sb0}} ? 1'b0 : 1'b1);
	assign decr_req = bvalid_o & bready_i;
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
			error_user_S <= 1'sb0;
			error_id_S <= 1'sb0;
		end
		else if (sample_awdata_info_i) begin
			error_user_S <= error_user_i;
			error_id_S <= error_id_i;
		end
	always @(posedge clk or negedge rst_n)
		if (rst_n == 1'b0)
			CS <= 2'd0;
		else
			CS <= NS;
	always @(*) begin
		bid_o = bid_ARB_TREE;
		bresp_o = bresp_ARB_TREE;
		buser_o = buser_ARB_TREE;
		bvalid_o = bvalid_ARB_TREE;
		bready_ARB_TREE = bready_i;
		error_gnt_o = 1'b0;
		case (CS)
			2'd0: begin
				bready_ARB_TREE = bready_i;
				error_gnt_o = 1'b0;
				if ((error_req_i == 1'b1) && (outstanding_trans_o == 1'b0))
					NS = 2'd1;
				else
					NS = 2'd0;
			end
			2'd1: begin
				bready_ARB_TREE = 1'b0;
				error_gnt_o = 1'b1;
				bresp_o = 2'b11;
				bvalid_o = 1'b1;
				buser_o = error_user_S;
				bid_o = error_id_S;
				if (bready_i)
					NS = 2'd0;
				else
					NS = 2'd1;
			end
			default: begin
				NS = 2'd0;
				error_gnt_o = 1'b0;
			end
		endcase
	end
	generate
		for (i = 0; i < N_INIT_PORT; i = i + 1) begin : AUX_VECTOR_BINDING
			assign AUX_VECTOR_IN[i * AUX_WIDTH+:AUX_WIDTH] = {buser_i[i * AXI_USER_W+:AXI_USER_W], bresp_i[i * 2+:2]};
		end
		for (i = 0; i < N_INIT_PORT; i = i + 1) begin : BID_VECTOR_BINDING
			assign bid_int[i * AXI_ID_IN+:AXI_ID_IN] = bid_i[(i * AXI_ID_OUT) + (AXI_ID_IN - 1)-:AXI_ID_IN];
		end
		if (N_INIT_PORT == 1) begin : DIRECT_BINDING
			assign bvalid_ARB_TREE = bvalid_i;
			assign AUX_VECTOR_OUT = AUX_VECTOR_IN;
			assign bid_ARB_TREE = bid_int;
			assign bready_o = bready_i;
		end
		else begin : ARB_TREE
			axi_ArbitrationTree #(
				.AUX_WIDTH(AUX_WIDTH),
				.ID_WIDTH(AXI_ID_IN),
				.N_MASTER(N_INIT_PORT)
			) BW_ARB_TREE(
				.clk(clk),
				.rst_n(rst_n),
				.data_req_i(bvalid_i),
				.data_AUX_i(AUX_VECTOR_IN),
				.data_ID_i(bid_int),
				.data_gnt_o(bready_o),
				.data_req_o(bvalid_ARB_TREE),
				.data_AUX_o(AUX_VECTOR_OUT),
				.data_ID_o(bid_ARB_TREE),
				.data_gnt_i(bready_ARB_TREE),
				.lock(1'b0),
				.SEL_EXCLUSIVE({$clog2(N_INIT_PORT) {1'b0}})
			);
		end
	endgenerate
endmodule
