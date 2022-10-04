module adbg_or1k_module 
#(
		parameter NB_CORES = 4
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
	cpu_clk_i,
	cpu_rstn_i,
	cpu_addr_o,
	cpu_data_i,
	cpu_data_o,
	cpu_bp_i,
	cpu_stall_o,
	cpu_stb_o,
	cpu_we_o,
	cpu_ack_i
);
	//parameter NB_CORES = 4;
	input wire tck_i;
	output reg module_tdo_o;
	input wire tdi_i;
	input wire capture_dr_i;
	input wire shift_dr_i;
	input wire update_dr_i;
	input wire [56:0] data_register_i;
	input wire module_select_i;
	output reg top_inhibit_o;
	input wire trstn_i;
	input cpu_clk_i;
	input cpu_rstn_i;
	output wire [(NB_CORES * 16) - 1:0] cpu_addr_o;
	input wire [(NB_CORES * 32) - 1:0] cpu_data_i;
	output wire [(NB_CORES * 32) - 1:0] cpu_data_o;
	input wire [NB_CORES - 1:0] cpu_bp_i;
	output wire [NB_CORES - 1:0] cpu_stall_o;
	output wire [NB_CORES - 1:0] cpu_stb_o;
	output wire [NB_CORES - 1:0] cpu_we_o;
	input wire [NB_CORES - 1:0] cpu_ack_i;
	reg [31:0] address_counter;
	reg [5:0] bit_count;
	reg [15:0] word_count;
	reg [3:0] operation;
	reg [31:0] data_out_shift_reg;
	reg [2:0] internal_register_select;
	wire [NB_CORES - 1:0] internal_reg_status;
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
	reg cpusel_ld_en;
	wire word_count_zero;
	wire bit_count_max;
	wire module_cmd;
	wire biu_ready;
	wire burst_instruction;
	wire intreg_instruction;
	wire intreg_write;
	wire rd_op;
	wire crc_match;
	wire bit_count_32;
	wire [5:0] word_size_bits;
	wire [2:0] address_increment;
	wire [32:0] incremented_address;
	wire [31:0] data_to_addr_counter;
	wire [15:0] data_to_word_counter;
	wire [15:0] decremented_word_count;
	wire [31:0] address_data_in;
	wire [15:0] count_data_in;
	wire [3:0] operation_in;
	wire [31:0] data_to_biu;
	wire [31:0] data_from_biu;
	wire [31:0] crc_data_out;
	wire crc_data_in;
	wire crc_serial_out;
	wire [2:0] reg_select_data;
	wire [31:0] out_reg_data;
	reg [31:0] data_from_internal_reg;
	wire status_reg_wr;
	reg [3:0] cpu_select;
	wire [3:0] cpu_select_in;
	wire [15:0] status_reg_data;
	reg [3:0] module_state;
	reg [3:0] module_next_state;
	assign module_cmd = ~data_register_i[56];
	assign operation_in = data_register_i[55:52];
	assign cpu_select_in = data_register_i[51:48];
	assign address_data_in = data_register_i[47:16];
	assign count_data_in = data_register_i[15:0];
	assign data_to_biu = {tdi_i, data_register_i[56:26]};
	assign reg_select_data = data_register_i[51:49];
	assign status_reg_data = data_register_i[48:33];
	assign burst_instruction = (operation_in == 4'h3) | (operation_in == 4'h7);
	assign intreg_instruction = (operation_in == 4'h9) | (operation_in == 4'hd);
	assign intreg_write = operation_in == 4'h9;
	assign word_size_bits = 5'd31;
	assign address_increment = 3'd1;
	assign rd_op = operation[2];
	always @(posedge tck_i or negedge trstn_i)
		if (~trstn_i)
			internal_register_select = 'h0;
		else if (regsel_ld_en)
			internal_register_select = reg_select_data;
	always @(posedge tck_i or negedge trstn_i)
		if (~trstn_i)
			cpu_select = 'h0;
		else if (cpusel_ld_en)
			cpu_select = cpu_select_in;
	always @(internal_register_select or internal_reg_status)
		case (internal_register_select)
			3'b000: data_from_internal_reg = {{32 - NB_CORES {1'b0}}, internal_reg_status};
			default: data_from_internal_reg = {{32 - NB_CORES {1'b0}}, internal_reg_status};
		endcase
	assign status_reg_wr = intreg_ld_en & (reg_select_data == 3'b000);
	adbg_or1k_status_reg #(.NB_CORES(NB_CORES)) or1k_statusreg_i(
		.data_i(status_reg_data),
		.we_i(status_reg_wr),
		.tck_i(tck_i),
		.bp_i(cpu_bp_i),
		.trstn_i(trstn_i),
		.cpu_clk_i(cpu_clk_i),
		.cpu_rstn_i(cpu_rstn_i),
		.ctrl_reg_o(internal_reg_status),
		.cpu_stall_o(cpu_stall_o)
	);
	assign data_to_addr_counter = (addr_sel ? incremented_address[31:0] : address_data_in);
	assign incremented_address = address_counter + address_increment;
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
	assign out_reg_data = (out_reg_data_sel ? data_from_internal_reg : data_from_biu);
	always @(posedge tck_i or negedge trstn_i)
		if (~trstn_i)
			data_out_shift_reg <= 32'h00000000;
		else if (out_reg_ld_en)
			data_out_shift_reg <= out_reg_data;
		else if (out_reg_shift_en)
			data_out_shift_reg <= {1'b0, data_out_shift_reg[31:1]};
	always @(tdo_output_sel or data_out_shift_reg[0] or biu_ready or crc_match or crc_serial_out)
		if (tdo_output_sel == 2'h0)
			module_tdo_o <= biu_ready;
		else if (tdo_output_sel == 2'h1)
			module_tdo_o <= data_out_shift_reg[0];
		else if (tdo_output_sel == 2'h2)
			module_tdo_o <= crc_match;
		else
			module_tdo_o <= crc_serial_out;
	adbg_or1k_biu #(.NB_CORES(NB_CORES)) or1k_biu_i(
		.tck_i(tck_i),
		.trstn_i(trstn_i),
		.cpu_select_i(cpu_select),
		.data_i(data_to_biu),
		.data_o(data_from_biu),
		.addr_i(address_counter),
		.strobe_i(biu_strobe),
		.rd_wrn_i(rd_op),
		.rdy_o(biu_ready),
		.cpu_clk_i(cpu_clk_i),
		.cpu_rstn_i(cpu_rstn_i),
		.cpu_addr_o(cpu_addr_o),
		.cpu_data_i(cpu_data_i),
		.cpu_data_o(cpu_data_o),
		.cpu_stb_o(cpu_stb_o),
		.cpu_we_o(cpu_we_o),
		.cpu_ack_i(cpu_ack_i)
	);
	assign crc_data_in = (crc_in_sel ? tdi_i : data_out_shift_reg[0]);
	adbg_crc32 or1k_crc_i(
		.clk(tck_i),
		.data(crc_data_in),
		.enable(crc_en),
		.shift(crc_shift_en),
		.clr(crc_clr),
		.rstn(trstn_i),
		.crc_out(crc_data_out),
		.serial_out(crc_serial_out)
	);
	assign crc_match = (data_register_i[56:25] == crc_data_out ? 1'b1 : 1'b0);
	always @(posedge tck_i or negedge trstn_i)
		if (~trstn_i)
			module_state <= 4'd0;
		else
			module_state <= module_next_state;
	always @(module_state or module_select_i or update_dr_i or capture_dr_i or shift_dr_i or operation_in[2] or word_count_zero or bit_count_max or data_register_i[56] or bit_count_32 or biu_ready or module_cmd or intreg_write or decremented_word_count or burst_instruction)
		case (module_state)
			4'd0:
				if ((((module_cmd && module_select_i) && update_dr_i) && burst_instruction) && operation_in[2])
					module_next_state <= 4'd1;
				else if (((module_cmd && module_select_i) && update_dr_i) && burst_instruction)
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
				else if (module_select_i && data_register_i[56])
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
	always @(module_state or module_next_state or module_select_i or update_dr_i or capture_dr_i or shift_dr_i or operation_in[2] or word_count_zero or bit_count_max or data_register_i[52] or biu_ready or intreg_instruction or burst_instruction or module_cmd or intreg_write or decremented_word_count) begin
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
		cpusel_ld_en <= 1'b0;
		intreg_ld_en <= 1'b0;
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
					if (burst_instruction)
						cpusel_ld_en <= 1'b1;
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
					bit_ct_rst <= 1'b1;
					biu_strobe <= 1'b1;
					addr_ct_en <= 1'b1;
					word_ct_sel <= 1'b1;
					word_ct_en <= 1'b1;
				end
			end
			4'd8: begin
				tdo_output_sel <= 2'h0;
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
			end
			default:
				;
		endcase
	end
endmodule
