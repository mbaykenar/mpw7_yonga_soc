module generic_fifo 
#(
   parameter                       DATA_WIDTH = 32,
   parameter                       DATA_DEPTH = 8
)
(
	clk,
	rst_n,
	data_i,
	valid_i,
	grant_o,
	data_o,
	valid_o,
	grant_i,
	test_mode_i
);
	//parameter DATA_WIDTH = 32;
	//parameter DATA_DEPTH = 8;
	input wire clk;
	input wire rst_n;
	input wire [DATA_WIDTH - 1:0] data_i;
	input wire valid_i;
	output reg grant_o;
	output wire [DATA_WIDTH - 1:0] data_o;
	output reg valid_o;
	input wire grant_i;
	input wire test_mode_i;
	localparam ADDR_DEPTH = $clog2(DATA_DEPTH);
	reg [1:0] CS;
	reg [1:0] NS;
	reg gate_clock;
	wire clk_gated;
	reg [ADDR_DEPTH - 1:0] Pop_Pointer_CS;
	reg [ADDR_DEPTH - 1:0] Pop_Pointer_NS;
	reg [ADDR_DEPTH - 1:0] Push_Pointer_CS;
	reg [ADDR_DEPTH - 1:0] Push_Pointer_NS;
	reg [DATA_WIDTH - 1:0] FIFO_REGISTERS [DATA_DEPTH - 1:0];
	integer i;
	initial begin : parameter_check
		integer param_err_flg;
		param_err_flg = 0;
		if (DATA_WIDTH < 1) begin
			param_err_flg = 1;
			$display("ERROR: %m :\n  Invalid value (%d) for parameter DATA_WIDTH (legal range: greater than 1)", DATA_WIDTH);
		end
		if (DATA_DEPTH < 1) begin
			param_err_flg = 1;
			$display("ERROR: %m :\n  Invalid value (%d) for parameter DATA_DEPTH (legal range: greater than 1)", DATA_DEPTH);
		end
	end
	cluster_clock_gating cg_cell(
		.clk_i(clk),
		.en_i(~gate_clock),
		.test_en_i(test_mode_i),
		.clk_o(clk_gated)
	);
	always @(posedge clk or negedge rst_n)
		if (rst_n == 1'b0) begin
			CS <= 2'd0;
			Pop_Pointer_CS <= {ADDR_DEPTH {1'b0}};
			Push_Pointer_CS <= {ADDR_DEPTH {1'b0}};
		end
		else begin
			CS <= NS;
			Pop_Pointer_CS <= Pop_Pointer_NS;
			Push_Pointer_CS <= Push_Pointer_NS;
		end
	always @(*) begin
		gate_clock = 1'b0;
		case (CS)
			2'd0: begin
				grant_o = 1'b1;
				valid_o = 1'b0;
				case (valid_i)
					1'b0: begin
						NS = 2'd0;
						Push_Pointer_NS = Push_Pointer_CS;
						Pop_Pointer_NS = Pop_Pointer_CS;
						gate_clock = 1'b1;
					end
					1'b1: begin
						NS = 2'd2;
						Push_Pointer_NS = Push_Pointer_CS + 1'b1;
						Pop_Pointer_NS = Pop_Pointer_CS;
					end
				endcase
			end
			2'd2: begin
				grant_o = 1'b1;
				valid_o = 1'b1;
				case ({valid_i, grant_i})
					2'b01: begin
						gate_clock = 1'b1;
						if ((Pop_Pointer_CS == (Push_Pointer_CS - 1)) || ((Pop_Pointer_CS == (DATA_DEPTH - 1)) && (Push_Pointer_CS == 0)))
							NS = 2'd0;
						else
							NS = 2'd2;
						Push_Pointer_NS = Push_Pointer_CS;
						if (Pop_Pointer_CS == (DATA_DEPTH - 1))
							Pop_Pointer_NS = 0;
						else
							Pop_Pointer_NS = Pop_Pointer_CS + 1'b1;
					end
					2'b00: begin
						gate_clock = 1'b1;
						NS = 2'd2;
						Push_Pointer_NS = Push_Pointer_CS;
						Pop_Pointer_NS = Pop_Pointer_CS;
					end
					2'b11: begin
						NS = 2'd2;
						if (Push_Pointer_CS == (DATA_DEPTH - 1))
							Push_Pointer_NS = 0;
						else
							Push_Pointer_NS = Push_Pointer_CS + 1'b1;
						if (Pop_Pointer_CS == (DATA_DEPTH - 1))
							Pop_Pointer_NS = 0;
						else
							Pop_Pointer_NS = Pop_Pointer_CS + 1'b1;
					end
					2'b10: begin
						if ((Push_Pointer_CS == (Pop_Pointer_CS - 1)) || ((Push_Pointer_CS == (DATA_DEPTH - 1)) && (Pop_Pointer_CS == 0)))
							NS = 2'd1;
						else
							NS = 2'd2;
						if (Push_Pointer_CS == (DATA_DEPTH - 1))
							Push_Pointer_NS = 0;
						else
							Push_Pointer_NS = Push_Pointer_CS + 1'b1;
						Pop_Pointer_NS = Pop_Pointer_CS;
					end
				endcase
			end
			2'd1: begin
				grant_o = 1'b0;
				valid_o = 1'b1;
				gate_clock = 1'b1;
				case (grant_i)
					1'b1: begin
						NS = 2'd2;
						Push_Pointer_NS = Push_Pointer_CS;
						if (Pop_Pointer_CS == (DATA_DEPTH - 1))
							Pop_Pointer_NS = 0;
						else
							Pop_Pointer_NS = Pop_Pointer_CS + 1'b1;
					end
					1'b0: begin
						NS = 2'd1;
						Push_Pointer_NS = Push_Pointer_CS;
						Pop_Pointer_NS = Pop_Pointer_CS;
					end
				endcase
			end
			default: begin
				gate_clock = 1'b1;
				grant_o = 1'b0;
				valid_o = 1'b0;
				NS = 2'd0;
				Pop_Pointer_NS = 0;
				Push_Pointer_NS = 0;
			end
		endcase
	end
	always @(posedge clk_gated or negedge rst_n)
		if (rst_n == 1'b0) begin
			for (i = 0; i < DATA_DEPTH; i = i + 1)
				FIFO_REGISTERS[i] <= {DATA_WIDTH {1'b0}};
		end
		else if ((grant_o == 1'b1) && (valid_i == 1'b1))
			FIFO_REGISTERS[Push_Pointer_CS] <= data_i;
	assign data_o = FIFO_REGISTERS[Pop_Pointer_CS];
endmodule
