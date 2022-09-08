//`define USE_POWER_PINS

module clk_rst_gen (
//`ifdef USE_POWER_PINS
//	vccd1,	// User area 1 1.8V supply
//	vssd1,	// User area 1 digital ground
//`endif
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
	rstn_o,
// MBA START
// constant assignments
user_irq,
io_oeb,
io_out,
wbs_ack_o,
wbs_dat_o,
la_data_out
// MBA END
);
//`ifdef USE_POWER_PINS
//	inout wire vccd1;
//	inout wire vssd1;
//`endif
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
// MBA START	
	output wire [2:0] user_irq;
	output wire [37:0] io_oeb;
	output wire [25:0] io_out;
	output wire wbs_ack_o;
	output wire [31:0] wbs_dat_o;
	output wire [63:0] la_data_out;
// MBA END
	wire clk_fll_int;
	wire clk_int;
// MBA START
wire rstn;
assign rstn = ~rstn_i;
// constant assignments
	assign user_irq = 3'b000;
	assign io_oeb[37:26] = 12'b000000000000;	
	assign io_out[25:0] = 26'b11111111111111111111111111; // does not have effect due to io_oeb
	assign io_oeb[25:0] = 26'b11111111111111111111111111;
	assign wbs_ack_o = 1'b0;
	assign wbs_dat_o = 32'b00000000000000000000000000000000;
	assign la_data_out[63:0] = 64'b0000000000000000000000000000000000000000000000000000000000000000;
// MBA END
	assign clk_int = clk_i;
	assign fll_ack_o = fll_req_i;
	assign fll_r_data_o = 1'b0;
	assign fll_lock_o = 1'b0;
	assign scan_o = 1'b0;
	rstgen i_rst_gen_soc(
		.clk_i(clk_int),
// MBA START
//		.rst_ni(rstn_i),
		.rst_ni(rstn),
// MBA END
		.test_mode_i(testmode_i),
		.rst_no(rstn_o),
		.init_no()
	);
	assign clk_o = clk_int;
endmodule
