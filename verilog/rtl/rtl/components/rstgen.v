module rstgen (
	clk_i,
	rst_ni,
	test_mode_i,
	rst_no,
	init_no
);
	input wire clk_i;
	input wire rst_ni;
	input wire test_mode_i;
	output reg rst_no;
	output reg init_no;
	reg s_rst_ff3;
	reg s_rst_ff2;
	reg s_rst_ff1;
	reg s_rst_ff0;
	reg s_rst_n;
	always @(posedge clk_i or negedge rst_ni)
		if (~rst_ni) begin
			s_rst_ff0 <= 1'b0;
			s_rst_ff1 <= 1'b0;
			s_rst_ff2 <= 1'b0;
			s_rst_ff3 <= 1'b0;
			s_rst_n <= 1'b0;
		end
		else begin
			s_rst_ff3 <= 1'b1;
			s_rst_ff2 <= s_rst_ff3;
			s_rst_ff1 <= s_rst_ff2;
			s_rst_ff0 <= s_rst_ff1;
			s_rst_n <= s_rst_ff0;
		end
	always @(*)
		if (test_mode_i == 1'b0)
			rst_no = s_rst_n;
		else
			rst_no = rst_ni;
	always @(*)
		if (test_mode_i == 1'b0)
			init_no = s_rst_n;
		else
			init_no = 1'b1;
endmodule
