module clk_rst_gen (
	clk_i,
	rstn_i,
	clk_sel_i,
	clk_standalone_i,
	testmode_i,
	scan_en_i,
	scan_i,
	scan_o,
	fll_req_i,
	fll_wrn_i,
	fll_add_i,
	fll_data_i,
	fll_ack_o,
	fll_r_data_o,
	fll_lock_o,
	clk_o,
	rstn_o
);
	input wire clk_i;
	input wire rstn_i;
	input wire clk_sel_i;
	input wire clk_standalone_i;
	input wire testmode_i;
	input wire scan_en_i;
	input wire scan_i;
	output wire scan_o;
	input wire fll_req_i;
	input wire fll_wrn_i;
	input wire [1:0] fll_add_i;
	input wire [31:0] fll_data_i;
	output wire fll_ack_o;
	output wire [31:0] fll_r_data_o;
	output wire fll_lock_o;
	output wire clk_o;
	output wire rstn_o;
	wire clk_fll_int;
	wire clk_int;
	assign clk_int = clk_i;
	assign fll_ack_o = fll_req_i;
	assign fll_r_data_o = 1'b0;
	assign fll_lock_o = 1'b0;
	assign scan_o = 1'b0;
	rstgen i_rst_gen_soc(
		.clk_i(clk_int),
		.rst_ni(rstn_i),
		.test_mode_i(testmode_i),
		.rst_no(rstn_o),
		.init_no()
	);
	assign clk_o = clk_int;
endmodule
