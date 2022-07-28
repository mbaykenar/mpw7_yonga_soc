module pulp_clock_inverter (
	clk_i,
	clk_o
);
	input wire clk_i;
	output wire clk_o;
	assign clk_o = ~clk_i;
endmodule
