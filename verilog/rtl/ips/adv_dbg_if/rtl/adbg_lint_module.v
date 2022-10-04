module adbg_lint_module 
#(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 64,
    parameter AUX_WIDTH = 6
)
(
	tck_i,
	module_tdo_o,
	tdi_i,
	capture_dr_i,
	shift_dr_i,
	update_dr_i,
	data_register_i,
	module_select_i,
	top_inhibit_o,
	trstn_i,
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
	output reg module_tdo_o;
	input wire tdi_i;
	input wire capture_dr_i;
	input wire shift_dr_i;
	input wire update_dr_i;
	input wire [63:0] data_register_i;
	input wire module_select_i;
	output reg top_inhibit_o;
	input wire trstn_i;
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
	reg [31:0] address_counter;
	reg [5:0] bit_count;
	reg [15:0] word_count;
	reg [3:0] operation;
	reg [64:0] data_out_shift_reg;
	reg [0:0] internal_register_select;
	reg [32:0] internal_reg_error;
	reg addr_sel;
	reg addr_ct_en;
	reg op_reg_en;
	reg bit_ct_en;
	reg bit_ct_rst;
	reg word_ct_sel;
	reg word_ct_en;
	reg out_reg_ld_en;
	reg out_reg_shift_en;
	reg out_reg_data_sel;
	reg [1:0] tdo_output_sel;
	reg biu_strobe;
	reg crc_clr;
	reg crc_en;
	reg crc_in_sel;
	reg crc_shift_en;
	reg regsel_ld_en;
	reg intreg_ld_en;
	reg error_reg_en;
	reg biu_clr_err;
	wire word_count_zero;
	wire bit_count_max;
	wire module_cmd;
	wire biu_ready;
	wire biu_err;
	wire burst_read;
	wire burst_write;
	wire intreg_instruction;
	wire intreg_write;
	reg rd_op;
	wire crc_match;
	wire bit_count_32;
	reg [5:0] word_size_bits;
	reg [3:0] word_size_bytes;
	wire [32:0] incremented_address;
	wire [31:0] data_to_addr_counter;
	wire [15:0] data_to_word_counter;
	wire [15:0] decremented_word_count;
	wire [31:0] address_data_in;
	wire [15:0] count_data_in;
	wire [3:0] operation_in;
	wire [63:0] data_to_biu;
	wire [63:0] data_from_biu;
	wire [31:0] crc_data_out;
	wire crc_data_in;
	wire crc_serial_out;
	wire [0:0] reg_select_data;
	wire [64:0] out_reg_data;
	reg [64:0] data_from_internal_reg;
	wire biu_rst;
	reg [3:0] module_state;
	reg [3:0] module_next_state;
	assign module_cmd = ~data_register_i[63];
	assign operation_in = data_register_i[62:59];
	assign address_data_in = data_register_i[58:27];
	assign count_data_in = data_register_i[26:11];
	assign data_to_biu = {tdi_i, data_register_i[63:1]};
	assign reg_select_data = data_register_i[58:57];
	assign intreg_instruction = (operation_in == 4'h9) | (operation_in == 4'hd);
	assign intreg_write = operation_in == 4'h9;
	assign burst_write = (((operation_in == 4'h1) | (operation_in == 4'h2)) | (operation_in == 4'h3)) | (operation_in == 4'h4);
	assign burst_read = (((operation_in == 4'h5) | (operation_in == 4'h6)) | (operation_in == 4'h7)) | (operation_in == 4'h8);
	always @(operation)
		case (operation)
			4'h1: begin
				word_size_bits <= 6'd7;
				word_size_bytes <= 4'd1;
				rd_op <= 1'b0;
			end
			4'h2: begin
				word_size_bits <= 6'd15;
				word_size_bytes <= 4'd2;
				rd_op <= 1'b0;
			end
			4'h3: begin
				word_size_bits <= 6'd31;
				word_size_bytes <= 4'd4;
				rd_op <= 1'b0;
			end
			4'h4: begin
				word_size_bits <= 6'd63;
				word_size_bytes <= 4'd8;
				rd_op <= 1'b0;
			end
			4'h5: begin
				word_size_bits <= 6'd7;
				word_size_bytes <= 4'd1;
				rd_op <= 1'b1;
			end
			4'h6: begin
				word_size_bits <= 6'd15;
				word_size_bytes <= 4'd2;
				rd_op <= 1'b1;
			end
			4'h7: begin
				word_size_bits <= 6'd31;
				word_size_bytes <= 4'd4;
				rd_op <= 1'b1;
			end
			4'h8: begin
				word_size_bits <= 6'd63;
				word_size_bytes <= 4'd4;
				rd_op <= 1'b1;
			end
			default: begin
				word_size_bits <= 6'hxx;
				word_size_bytes <= 4'hx;
				rd_op <= 1'bx;
			end
		endcase
	always @(posedge tck_i or negedge trstn_i)
		if (~trstn_i)
			internal_register_select = 1'h0;
		else if (regsel_ld_en)
			internal_register_select = reg_select_data;
	always @(internal_register_select or internal_reg_error)
		case (internal_register_select)
			1'b0: data_from_internal_reg = internal_reg_error;
			default: data_from_internal_reg = internal_reg_error;
		endcase
	always @(posedge tck_i or negedge trstn_i)
		if (~trstn_i)
			internal_reg_error = 33'h000000000;
		else if (intreg_ld_en && (reg_select_data == 1'b0)) begin
			if (data_register_i[46])
				internal_reg_error[0] = 1'b0;
		end
		else if (error_reg_en && !internal_reg_error[0]) begin
			if (biu_err || !biu_ready)
				internal_reg_error[0] = 1'b1;
			else if (biu_strobe)
				internal_reg_error[32:1] = address_counter;
		end
		else if (biu_strobe && !internal_reg_error[0])
			internal_reg_error[32:1] = address_counter;
	assign data_to_addr_counter = (addr_sel ? incremented_address[31:0] : address_data_in);
	assign incremented_address = address_counter + word_size_bytes;
	always @(posedge tck_i or negedge trstn_i)
		if (~trstn_i)
			address_counter <= 32'h00000000;
		else if (addr_ct_en)
			address_counter <= data_to_addr_counter;
	always @(posedge tck_i or negedge trstn_i)
		if (~trstn_i)
			operation <= 4'h0;
		else if (op_reg_en)
			operation <= operation_in;
	always @(posedge tck_i or negedge trstn_i)
		if (~trstn_i)
			bit_count <= 6'h00;
		else if (bit_ct_rst)
			bit_count <= 6'h00;
		else if (bit_ct_en)
			bit_count <= bit_count + 6'h01;
	assign bit_count_max = (bit_count == word_size_bits ? 1'b1 : 1'b0);
	assign bit_count_32 = (bit_count == 6'h20 ? 1'b1 : 1'b0);
	assign data_to_word_counter = (word_ct_sel ? decremented_word_count : count_data_in);
	assign decremented_word_count = word_count - 16'h0001;
	always @(posedge tck_i or negedge trstn_i)
		if (~trstn_i)
			word_count <= 16'h0000;
		else if (word_ct_en)
			word_count <= data_to_word_counter;
	assign word_count_zero = word_count == 16'h0000;
	assign out_reg_data = (out_reg_data_sel ? data_from_internal_reg : {1'b0, data_from_biu});
	always @(posedge tck_i or negedge trstn_i)
		if (~trstn_i)
			data_out_shift_reg <= 'h0;
		else if (out_reg_ld_en)
			data_out_shift_reg <= out_reg_data;
		else if (out_reg_shift_en)
			data_out_shift_reg <= {1'b0, data_out_shift_reg[64:1]};
	always @(tdo_output_sel or data_out_shift_reg[0] or biu_ready or crc_match or crc_serial_out)
		if (tdo_output_sel == 2'h0)
			module_tdo_o <= biu_ready;
		else if (tdo_output_sel == 2'h1)
			module_tdo_o <= data_out_shift_reg[0];
		else if (tdo_output_sel == 2'h2)
			module_tdo_o <= crc_match;
		else
			module_tdo_o <= crc_serial_out;
	adbg_lint_biu #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.DATA_WIDTH(DATA_WIDTH),
		.AUX_WIDTH(AUX_WIDTH)
	) lint_biu_i(
		.tck_i(tck_i),
		.trstn_i(trstn_i),
		.data_i(data_to_biu),
		.data_o(data_from_biu),
		.addr_i(address_counter),
		.strobe_i(biu_strobe),
		.rd_wrn_i(rd_op),
		.rdy_o(biu_ready),
		.err_o(biu_err),
		.word_size_i(word_size_bytes),
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
	assign crc_data_in = (crc_in_sel ? tdi_i : data_out_shift_reg[0]);
	adbg_crc32 lint_crc_i(
		.clk(tck_i),
		.data(crc_data_in),
		.enable(crc_en),
		.shift(crc_shift_en),
		.clr(crc_clr),
		.rstn(trstn_i),
		.crc_out(crc_data_out),
		.serial_out(crc_serial_out)
	);
	assign crc_match = (data_register_i[63:32] == crc_data_out ? 1'b1 : 1'b0);
	always @(posedge tck_i or negedge trstn_i)
		if (~trstn_i)
			module_state <= 4'd0;
		else
			module_state <= module_next_state;
	always @(module_state or module_select_i or module_cmd or update_dr_i or capture_dr_i or operation_in[2] or word_count_zero or bit_count_max or data_register_i[63] or bit_count_32 or biu_ready or burst_read or burst_write)
		case (module_state)
			4'd0:
				if (((module_cmd && module_select_i) && update_dr_i) && burst_read)
					module_next_state <= 4'd1;
				else if (((module_cmd && module_select_i) && update_dr_i) && burst_write)
					module_next_state <= 4'd5;
				else
					module_next_state <= 4'd0;
			4'd1:
				if (word_count_zero)
					module_next_state <= 4'd0;
				else
					module_next_state <= 4'd2;
			4'd2:
				if (module_select_i && capture_dr_i)
					module_next_state <= 4'd3;
				else
					module_next_state <= 4'd2;
			4'd3:
				if (update_dr_i)
					module_next_state <= 4'd0;
				else if (biu_ready)
					module_next_state <= 4'd4;
				else
					module_next_state <= 4'd3;
			4'd4:
				if (update_dr_i)
					module_next_state <= 4'd0;
				else if (bit_count_max && word_count_zero)
					module_next_state <= 4'd9;
				else
					module_next_state <= 4'd4;
			4'd9:
				if (update_dr_i)
					module_next_state <= 4'd0;
				else
					module_next_state <= 4'd9;
			4'd5:
				if (word_count_zero)
					module_next_state <= 4'd0;
				else if (module_select_i && capture_dr_i)
					module_next_state <= 4'd6;
				else
					module_next_state <= 4'd5;
			4'd6:
				if (update_dr_i)
					module_next_state <= 4'd0;
				else if (module_select_i && data_register_i[63])
					module_next_state <= 4'd7;
				else
					module_next_state <= 4'd6;
			4'd7:
				if (update_dr_i)
					module_next_state <= 4'd0;
				else if (bit_count_max) begin
					if (word_count_zero)
						module_next_state <= 4'd10;
					else
						module_next_state <= 4'd7;
				end
				else
					module_next_state <= 4'd7;
			4'd8:
				if (update_dr_i)
					module_next_state <= 4'd0;
				else if (word_count_zero)
					module_next_state <= 4'd10;
				else
					module_next_state <= 4'd7;
			4'd10:
				if (update_dr_i)
					module_next_state <= 4'd0;
				else if (bit_count_32)
					module_next_state <= 4'd11;
				else
					module_next_state <= 4'd10;
			4'd11:
				if (update_dr_i)
					module_next_state <= 4'd0;
				else
					module_next_state <= 4'd11;
			default: module_next_state <= 4'd0;
		endcase
	always @(module_state or module_next_state or module_select_i or update_dr_i or capture_dr_i or shift_dr_i or operation_in[2] or word_count_zero or bit_count_max or data_register_i[52] or biu_ready or intreg_instruction or module_cmd or intreg_write or decremented_word_count) begin
		addr_sel <= 1'b1;
		addr_ct_en <= 1'b0;
		op_reg_en <= 1'b0;
		bit_ct_en <= 1'b0;
		bit_ct_rst <= 1'b0;
		word_ct_sel <= 1'b1;
		word_ct_en <= 1'b0;
		out_reg_ld_en <= 1'b0;
		out_reg_shift_en <= 1'b0;
		tdo_output_sel <= 2'b01;
		biu_strobe <= 1'b0;
		crc_clr <= 1'b0;
		crc_en <= 1'b0;
		crc_in_sel <= 1'b0;
		crc_shift_en <= 1'b0;
		out_reg_data_sel <= 1'b1;
		regsel_ld_en <= 1'b0;
		intreg_ld_en <= 1'b0;
		error_reg_en <= 1'b0;
		biu_clr_err <= 1'b0;
		top_inhibit_o <= 1'b0;
		case (module_state)
			4'd0: begin
				addr_sel <= 1'b0;
				word_ct_sel <= 1'b0;
				if (module_select_i & shift_dr_i)
					out_reg_shift_en <= 1'b1;
				if (module_select_i & capture_dr_i) begin
					out_reg_data_sel <= 1'b1;
					out_reg_ld_en <= 1'b1;
				end
				if ((module_select_i & module_cmd) & update_dr_i) begin
					if (intreg_instruction)
						regsel_ld_en <= 1'b1;
					if (intreg_write)
						intreg_ld_en <= 1'b1;
				end
				if (module_next_state != 4'd0) begin
					addr_ct_en <= 1'b1;
					op_reg_en <= 1'b1;
					bit_ct_rst <= 1'b1;
					word_ct_en <= 1'b1;
					crc_clr <= 1'b1;
				end
			end
			4'd1:
				if (!word_count_zero) begin
					biu_strobe <= 1'b1;
					addr_sel <= 1'b1;
					addr_ct_en <= 1'b1;
				end
			4'd2:
				;
			4'd3: begin
				tdo_output_sel <= 2'h0;
				top_inhibit_o <= 1'b1;
				if (module_next_state == 4'd4) begin
					error_reg_en <= 1'b1;
					out_reg_data_sel <= 1'b0;
					out_reg_ld_en <= 1'b1;
					bit_ct_rst <= 1'b1;
					word_ct_sel <= 1'b1;
					word_ct_en <= 1'b1;
					if ((decremented_word_count != 0) && !word_count_zero) begin
						biu_strobe <= 1'b1;
						addr_sel <= 1'b1;
						addr_ct_en <= 1'b1;
					end
				end
			end
			4'd4: begin
				tdo_output_sel <= 2'h1;
				out_reg_shift_en <= 1'b1;
				bit_ct_en <= 1'b1;
				crc_en <= 1'b1;
				crc_in_sel <= 1'b0;
				top_inhibit_o <= 1'b1;
				if (bit_count_max) begin
					error_reg_en <= 1'b1;
					out_reg_data_sel <= 1'b0;
					out_reg_ld_en <= 1'b1;
					bit_ct_rst <= 1'b1;
					word_ct_sel <= 1'b1;
					word_ct_en <= 1'b1;
					if ((decremented_word_count != 0) && !word_count_zero) begin
						biu_strobe <= 1'b1;
						addr_sel <= 1'b1;
						addr_ct_en <= 1'b1;
					end
				end
			end
			4'd9: begin
				tdo_output_sel <= 2'h3;
				crc_shift_en <= 1'b1;
				top_inhibit_o <= 1'b1;
			end
			4'd5:
				;
			4'd6: begin
				tdo_output_sel <= 2'h1;
				top_inhibit_o <= 1'b1;
				if (module_next_state == 4'd7) begin
					biu_clr_err <= 1'b1;
					bit_ct_en <= 1'b1;
					word_ct_sel <= 1'b1;
					word_ct_en <= 1'b1;
					crc_en <= 1'b1;
					crc_in_sel <= 1'b1;
				end
			end
			4'd7: begin
				bit_ct_en <= 1'b1;
				tdo_output_sel <= 2'h1;
				crc_en <= 1'b1;
				crc_in_sel <= 1'b1;
				top_inhibit_o <= 1'b1;
				if (bit_count_max) begin
					error_reg_en <= 1'b1;
					bit_ct_rst <= 1'b1;
					biu_strobe <= 1'b1;
					addr_ct_en <= 1'b1;
					word_ct_sel <= 1'b1;
					word_ct_en <= 1'b1;
				end
			end
			4'd8: begin
				tdo_output_sel <= 2'h0;
				error_reg_en <= 1'b1;
				biu_strobe <= 1'b1;
				word_ct_sel <= 1'b1;
				word_ct_en <= 1'b1;
				bit_ct_rst <= 1'b1;
				addr_ct_en <= 1'b1;
				top_inhibit_o <= 1'b1;
			end
			4'd10: begin
				bit_ct_en <= 1'b1;
				top_inhibit_o <= 1'b1;
				if (module_next_state == 4'd11)
					tdo_output_sel <= 2'h2;
			end
			4'd11: begin
				tdo_output_sel <= 2'h2;
				top_inhibit_o <= 1'b1;
				if (module_next_state == 4'd0)
					error_reg_en <= 1'b1;
			end
			default:
				;
		endcase
	end
endmodule
