module cluster_clock_mux2 (
	clk0_i,
	clk1_i,
	clk_sel_i,
	clk_o
);
	input wire clk0_i;
	input wire clk1_i;
	input wire clk_sel_i;
	output reg clk_o;
	always @(*)
		if (clk_sel_i == 1'b0)
			clk_o = clk0_i;
		else
			clk_o = clk1_i;
endmodule
