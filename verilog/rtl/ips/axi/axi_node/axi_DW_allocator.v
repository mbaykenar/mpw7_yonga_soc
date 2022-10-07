module axi_DW_allocator 
#(
    parameter                   AXI_USER_W     = 6,
    parameter                   N_TARG_PORT    = 7,
    parameter                   LOG_N_TARG     = $clog2(N_TARG_PORT),
    parameter                   FIFO_DEPTH     = 8,

    parameter                   AXI_DATA_W     = 64,
    parameter                   AXI_NUMBYTES   = AXI_DATA_W/8
)
(
	clk,
	rst_n,
	test_en_i,
	wdata_i,
	wstrb_i,
	wlast_i,
	wuser_i,
	wvalid_i,
	wready_o,
	wdata_o,
	wstrb_o,
	wlast_o,
	wuser_o,
	wvalid_o,
	wready_i,
	push_ID_i,
	ID_i,
	grant_FIFO_ID_o
);
	//parameter AXI_USER_W = 6;
	//parameter N_TARG_PORT = 7;
	//parameter LOG_N_TARG = $clog2(N_TARG_PORT);
	//parameter FIFO_DEPTH = 8;
	//parameter AXI_DATA_W = 64;
	//parameter AXI_NUMBYTES = AXI_DATA_W / 8;
	input wire clk;
	input wire rst_n;
	input wire test_en_i;
	input wire [(N_TARG_PORT * AXI_DATA_W) - 1:0] wdata_i;
	input wire [(N_TARG_PORT * AXI_NUMBYTES) - 1:0] wstrb_i;
	input wire [N_TARG_PORT - 1:0] wlast_i;
	input wire [(N_TARG_PORT * AXI_USER_W) - 1:0] wuser_i;
	input wire [N_TARG_PORT - 1:0] wvalid_i;
	output reg [N_TARG_PORT - 1:0] wready_o;
	output wire [AXI_DATA_W - 1:0] wdata_o;
	output wire [AXI_NUMBYTES - 1:0] wstrb_o;
	output wire wlast_o;
	output wire [AXI_USER_W - 1:0] wuser_o;
	output reg wvalid_o;
	input wire wready_i;
	input wire push_ID_i;
	input wire [(LOG_N_TARG + N_TARG_PORT) - 1:0] ID_i;
	output wire grant_FIFO_ID_o;
	localparam AUX_WIDTH = ((AXI_DATA_W + AXI_NUMBYTES) + 1) + AXI_USER_W;
	reg pop_from_ID_FIFO;
	wire valid_ID;
	wire [(LOG_N_TARG + N_TARG_PORT) - 1:0] ID_int;
	wire [LOG_N_TARG - 1:0] ID_int_BIN;
	wire [N_TARG_PORT - 1:0] ID_int_OH;
	wire [AUX_WIDTH - 1:0] AUX_VECTOR_OUT;
	wire [(N_TARG_PORT * AUX_WIDTH) - 1:0] AUX_VECTOR_IN;
	reg CS;
	reg NS;
	genvar i;
	generate
		for (i = 0; i < N_TARG_PORT; i = i + 1) begin : AUX_VECTOR_BINDING
			assign AUX_VECTOR_IN[i * AUX_WIDTH+:AUX_WIDTH] = {wdata_i[i * AXI_DATA_W+:AXI_DATA_W], wstrb_i[i * AXI_NUMBYTES+:AXI_NUMBYTES], wlast_i[i], wuser_i[i * AXI_USER_W+:AXI_USER_W]};
		end
	endgenerate
	assign {wdata_o, wstrb_o, wlast_o, wuser_o} = AUX_VECTOR_OUT;
	generic_fifo #(
		.DATA_WIDTH(LOG_N_TARG + N_TARG_PORT),
		.DATA_DEPTH(FIFO_DEPTH)
	) MASTER_ID_FIFO(
		.clk(clk),
		.rst_n(rst_n),
		.test_mode_i(test_en_i),
		.data_i(ID_i),
		.valid_i(push_ID_i),
		.grant_o(grant_FIFO_ID_o),
		.data_o(ID_int),
		.valid_o(valid_ID),
		.grant_i(pop_from_ID_FIFO)
	);
	assign ID_int_BIN = ID_int[(LOG_N_TARG + N_TARG_PORT) - 1:N_TARG_PORT];
	assign ID_int_OH = ID_int[N_TARG_PORT - 1:0];
	always @(posedge clk or negedge rst_n) begin : UPDATE_STATE_FSM
		if (rst_n == 1'b0)
			CS <= 1'd0;
		else
			CS <= NS;
	end
	always @(*) begin : NEXT_STATE_FSM
		pop_from_ID_FIFO = 1'b0;
		wvalid_o = 1'b0;
		wready_o = 1'sb0;
		case (CS)
			1'd0: begin : _CS_IN_SINGLE_IDLE
				if (valid_ID) begin : _valid_ID
					wvalid_o = wvalid_i[ID_int_BIN];
					wready_o = {N_TARG_PORT {wready_i}} & ID_int_OH;
					if (wvalid_i[ID_int_BIN] & wready_i) begin : _granted_request
						if (wlast_i[ID_int_BIN]) begin : _last_packet
							NS = 1'd0;
							pop_from_ID_FIFO = 1'b1;
						end
						else begin : _payload_packet
							NS = 1'd1;
							pop_from_ID_FIFO = 1'b0;
						end
					end
					else begin : _not_granted_request
						NS = 1'd0;
						pop_from_ID_FIFO = 1'b0;
					end
				end
				else begin : _not_valid_ID
					NS = 1'd0;
					pop_from_ID_FIFO = 1'b0;
					wvalid_o = 1'b0;
					wready_o = 1'sb0;
				end
			end
			1'd1: begin : _CS_IN_BUSRT
				wvalid_o = wvalid_i[ID_int_BIN];
				wready_o = ({N_TARG_PORT {wready_i}} & ID_int_OH) & {N_TARG_PORT {valid_ID}};
				if (wvalid_i[ID_int_BIN] & wready_i) begin
					if (wlast_i[ID_int_BIN]) begin
						NS = 1'd0;
						pop_from_ID_FIFO = 1'b1;
					end
					else begin
						NS = 1'd1;
						pop_from_ID_FIFO = 1'b0;
					end
				end
				else begin
					NS = 1'd1;
					pop_from_ID_FIFO = 1'b0;
				end
			end
			default: begin
				NS = 1'd0;
				pop_from_ID_FIFO = 1'b0;
				wvalid_o = 1'b0;
				wready_o = 1'sb0;
			end
		endcase
	end
	axi_multiplexer #(
		.DATA_WIDTH(AUX_WIDTH),
		.N_IN(N_TARG_PORT)
	) WRITE_DATA_MUX(
		.IN_DATA(AUX_VECTOR_IN),
		.OUT_DATA(AUX_VECTOR_OUT),
		.SEL(ID_int_BIN)
	);
endmodule
