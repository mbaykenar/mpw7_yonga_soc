module adbg_lintonly_top 
#(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 64,
    parameter AUX_WIDTH = 6
)
(
	tck_i,
	tdi_i,
	tdo_o,
	trstn_i,
	shift_dr_i,
	pause_dr_i,
	update_dr_i,
	capture_dr_i,
	debug_select_i,
	clk_i,
	rstn_i,
	lint_req_o,
	lint_add_o,
	lint_wen_o,
	lint_wdata_o,
	lint_be_o,
	lint_aux_o,
	lint_gnt_i,
	lint_r_aux_i,
	lint_r_valid_i,
	lint_r_rdata_i,
	lint_r_opc_i
);
	//parameter ADDR_WIDTH = 32;
	//parameter DATA_WIDTH = 64;
	//parameter AUX_WIDTH = 6;
	input wire tck_i;
	input wire tdi_i;
	output reg tdo_o;
	input wire trstn_i;
	input wire shift_dr_i;
	input wire pause_dr_i;
	input wire update_dr_i;
	input wire capture_dr_i;
	input wire debug_select_i;
	input wire clk_i;
	input wire rstn_i;
	output wire lint_req_o;
	output wire [ADDR_WIDTH - 1:0] lint_add_o;
	output wire lint_wen_o;
	output wire [DATA_WIDTH - 1:0] lint_wdata_o;
	output wire [(DATA_WIDTH / 8) - 1:0] lint_be_o;
	output wire [AUX_WIDTH - 1:0] lint_aux_o;
	input wire lint_gnt_i;
	input wire lint_r_aux_i;
	input wire lint_r_valid_i;
	input wire [DATA_WIDTH - 1:0] lint_r_rdata_i;
	input wire lint_r_opc_i;
	wire tdo_axi;
	wire tdo_cpu;
	reg [63:0] input_shift_reg;
	reg [4:0] module_id_reg;
	wire select_cmd;
	wire [4:0] module_id_in;
	reg [1:0] module_selects;
	wire select_inhibit;
	wire [1:0] module_inhibit;
	integer j;
	assign select_cmd = input_shift_reg[63];
	assign module_id_in = input_shift_reg[62:58];
	always @(posedge tck_i or negedge trstn_i)
		if (~trstn_i)
			module_id_reg <= 5'h00;
		else if (((debug_select_i && select_cmd) && update_dr_i) && !select_inhibit)
			module_id_reg <= module_id_in;
	always @(*)
		if (module_id_reg == 0)
			module_selects = 2'b01;
		else
			module_selects = 2'b10;
	always @(posedge tck_i or negedge trstn_i)
		if (~trstn_i)
			input_shift_reg <= 'h0;
		else if (debug_select_i && shift_dr_i)
			input_shift_reg <= {tdi_i, input_shift_reg[63:1]};
	adbg_lint_module #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.DATA_WIDTH(DATA_WIDTH),
		.AUX_WIDTH(AUX_WIDTH)
	) i_dbg_lint(
		.tck_i(tck_i),
		.module_tdo_o(tdo_axi),
		.tdi_i(tdi_i),
		.capture_dr_i(capture_dr_i),
		.shift_dr_i(shift_dr_i),
		.update_dr_i(update_dr_i),
		.data_register_i(input_shift_reg),
		.module_select_i(module_selects[0]),
		.top_inhibit_o(module_inhibit[0]),
		.trstn_i(trstn_i),
		.clk_i(clk_i),
		.rstn_i(rstn_i),
		.lint_req_o(lint_req_o),
		.lint_add_o(lint_add_o),
		.lint_wen_o(lint_wen_o),
		.lint_wdata_o(lint_wdata_o),
		.lint_be_o(lint_be_o),
		.lint_aux_o(lint_aux_o),
		.lint_gnt_i(lint_gnt_i),
		.lint_r_aux_i(lint_r_aux_i),
		.lint_r_valid_i(lint_r_valid_i),
		.lint_r_rdata_i(lint_r_rdata_i),
		.lint_r_opc_i(lint_r_opc_i)
	);
	assign select_inhibit = |module_inhibit;
	always @(module_id_reg or tdo_axi or tdo_cpu)
		if (module_id_reg == 0)
			tdo_o <= tdo_axi;
		else if (module_id_reg == 1)
			tdo_o <= tdo_cpu;
		else
			tdo_o <= 1'b0;
endmodule
