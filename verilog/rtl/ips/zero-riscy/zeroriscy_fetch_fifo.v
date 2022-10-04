module zeroriscy_fetch_fifo (
	clk,
	rst_n,
	clear_i,
	in_addr_i,
	in_rdata_i,
	in_valid_i,
	in_ready_o,
	out_valid_o,
	out_ready_i,
	out_rdata_o,
	out_addr_o,
	out_valid_stored_o
);
	input wire clk;
	input wire rst_n;
	input wire clear_i;
	input wire [31:0] in_addr_i;
	input wire [31:0] in_rdata_i;
	input wire in_valid_i;
	output wire in_ready_o;
	output reg out_valid_o;
	input wire out_ready_i;
	output reg [31:0] out_rdata_o;
	output wire [31:0] out_addr_o;
	output reg out_valid_stored_o;
	localparam DEPTH = 3;
	reg [95:0] addr_n;
	reg [95:0] addr_int;
	reg [95:0] addr_Q;
	reg [95:0] rdata_n;
	reg [95:0] rdata_int;
	reg [95:0] rdata_Q;
	reg [2:0] valid_n;
	reg [2:0] valid_int;
	reg [2:0] valid_Q;
	wire [31:0] addr_next;
	wire [31:0] rdata;
	wire [31:0] rdata_unaligned;
	wire valid;
	wire valid_unaligned;
	wire aligned_is_compressed;
	wire unaligned_is_compressed;
	wire aligned_is_compressed_st;
	wire unaligned_is_compressed_st;
	assign rdata = (valid_Q[0] ? rdata_Q[0+:32] : in_rdata_i);
	assign valid = valid_Q[0] || in_valid_i;
	assign rdata_unaligned = (valid_Q[1] ? {rdata_Q[47-:16], rdata[31:16]} : {in_rdata_i[15:0], rdata[31:16]});
	assign valid_unaligned = valid_Q[1] || (valid_Q[0] && in_valid_i);
	assign unaligned_is_compressed = rdata[17:16] != 2'b11;
	assign aligned_is_compressed = rdata[1:0] != 2'b11;
	assign unaligned_is_compressed_st = rdata_Q[17-:2] != 2'b11;
	assign aligned_is_compressed_st = rdata_Q[1-:2] != 2'b11;
	always @(*)
		if (out_addr_o[1]) begin
			out_rdata_o = rdata_unaligned;
			if (unaligned_is_compressed)
				out_valid_o = valid;
			else
				out_valid_o = valid_unaligned;
		end
		else begin
			out_rdata_o = rdata;
			out_valid_o = valid;
		end
	assign out_addr_o = (valid_Q[0] ? addr_Q[0+:32] : in_addr_i);
	always @(*) begin
		out_valid_stored_o = 1'b1;
		if (out_addr_o[1]) begin
			if (unaligned_is_compressed_st)
				out_valid_stored_o = 1'b1;
			else
				out_valid_stored_o = valid_Q[1];
		end
		else
			out_valid_stored_o = valid_Q[0];
	end
	assign in_ready_o = ~valid_Q[1];
	always @(*) begin : sv2v_autoblock_1
		reg [0:1] _sv2v_jump;
		_sv2v_jump = 2'b00;
		begin : sv2v_autoblock_2
			reg signed [31:0] j;
			addr_int = addr_Q;
			rdata_int = rdata_Q;
			valid_int = valid_Q;
			if (in_valid_i) begin : sv2v_autoblock_3
				reg signed [31:0] _sv2v_value_on_break;
				for (j = 0; j < DEPTH; j = j + 1)
					if (_sv2v_jump < 2'b10) begin
						_sv2v_jump = 2'b00;
						if (~valid_Q[j]) begin
							addr_int[j * 32+:32] = in_addr_i;
							rdata_int[j * 32+:32] = in_rdata_i;
							valid_int[j] = 1'b1;
							_sv2v_jump = 2'b10;
						end
						_sv2v_value_on_break = j;
					end
				if (!(_sv2v_jump < 2'b10))
					j = _sv2v_value_on_break;
				if (_sv2v_jump != 2'b11)
					_sv2v_jump = 2'b00;
			end
		end
	end
	assign addr_next = {addr_int[31-:30], 2'b00} + 32'h00000004;
	always @(*) begin
		addr_n = addr_int;
		rdata_n = rdata_int;
		valid_n = valid_int;
		if (out_ready_i && out_valid_o)
			if (addr_int[1]) begin
				if (unaligned_is_compressed)
					addr_n[0+:32] = {addr_next[31:2], 2'b00};
				else
					addr_n[0+:32] = {addr_next[31:2], 2'b10};
				rdata_n = {32'b00000000000000000000000000000000, rdata_int[32+:64]};
				valid_n = {1'b0, valid_int[2:1]};
			end
			else if (aligned_is_compressed)
				addr_n[0+:32] = {addr_int[31-:30], 2'b10};
			else begin
				addr_n[0+:32] = {addr_next[31:2], 2'b00};
				rdata_n = {32'b00000000000000000000000000000000, rdata_int[32+:64]};
				valid_n = {1'b0, valid_int[2:1]};
			end
	end
	always @(posedge clk or negedge rst_n)
		if (rst_n == 1'b0) begin
			addr_Q <= {DEPTH {32'b00000000000000000000000000000000}};
			rdata_Q <= {DEPTH {32'b00000000000000000000000000000000}};
			valid_Q <= 1'sb0;
		end
		else if (clear_i)
			valid_Q <= 1'sb0;
		else begin
			addr_Q <= addr_n;
			rdata_Q <= rdata_n;
			valid_Q <= valid_n;
		end
endmodule
