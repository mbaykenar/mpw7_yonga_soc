module adbg_axi_module 
#(
	parameter AXI_ADDR_WIDTH = 32,
	parameter AXI_DATA_WIDTH = 64,
	parameter AXI_USER_WIDTH = 6,
	parameter AXI_ID_WIDTH   = 3
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
	axi_aclk,
	axi_aresetn,
	axi_master_aw_valid,
	axi_master_aw_addr,
	axi_master_aw_prot,
	axi_master_aw_region,
	axi_master_aw_len,
	axi_master_aw_size,
	axi_master_aw_burst,
	axi_master_aw_lock,
	axi_master_aw_cache,
	axi_master_aw_qos,
	axi_master_aw_id,
	axi_master_aw_user,
	axi_master_aw_ready,
	axi_master_ar_valid,
	axi_master_ar_addr,
	axi_master_ar_prot,
	axi_master_ar_region,
	axi_master_ar_len,
	axi_master_ar_size,
	axi_master_ar_burst,
	axi_master_ar_lock,
	axi_master_ar_cache,
	axi_master_ar_qos,
	axi_master_ar_id,
	axi_master_ar_user,
	axi_master_ar_ready,
	axi_master_w_valid,
	axi_master_w_data,
	axi_master_w_strb,
	axi_master_w_user,
	axi_master_w_last,
	axi_master_w_ready,
	axi_master_r_valid,
	axi_master_r_data,
	axi_master_r_resp,
	axi_master_r_last,
	axi_master_r_id,
	axi_master_r_user,
	axi_master_r_ready,
	axi_master_b_valid,
	axi_master_b_resp,
	axi_master_b_id,
	axi_master_b_user,
	axi_master_b_ready
);
	//parameter AXI_ADDR_WIDTH = 32;
	//parameter AXI_DATA_WIDTH = 64;
	//parameter AXI_USER_WIDTH = 6;
	//parameter AXI_ID_WIDTH = 3;
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
	input wire axi_aclk;
	input wire axi_aresetn;
	output wire axi_master_aw_valid;
	output wire [AXI_ADDR_WIDTH - 1:0] axi_master_aw_addr;
	output wire [2:0] axi_master_aw_prot;
	output wire [3:0] axi_master_aw_region;
	output wire [7:0] axi_master_aw_len;
	output wire [2:0] axi_master_aw_size;
	output wire [1:0] axi_master_aw_burst;
	output wire axi_master_aw_lock;
	output wire [3:0] axi_master_aw_cache;
	output wire [3:0] axi_master_aw_qos;
	output wire [AXI_ID_WIDTH - 1:0] axi_master_aw_id;
	output wire [AXI_USER_WIDTH - 1:0] axi_master_aw_user;
	input wire axi_master_aw_ready;
	output wire axi_master_ar_valid;
	output wire [AXI_ADDR_WIDTH - 1:0] axi_master_ar_addr;
	output wire [2:0] axi_master_ar_prot;
	output wire [3:0] axi_master_ar_region;
	output wire [7:0] axi_master_ar_len;
	output wire [2:0] axi_master_ar_size;
	output wire [1:0] axi_master_ar_burst;
	output wire axi_master_ar_lock;
	output wire [3:0] axi_master_ar_cache;
	output wire [3:0] axi_master_ar_qos;
	output wire [AXI_ID_WIDTH - 1:0] axi_master_ar_id;
	output wire [AXI_USER_WIDTH - 1:0] axi_master_ar_user;
	input wire axi_master_ar_ready;
	output wire axi_master_w_valid;
	output wire [AXI_DATA_WIDTH - 1:0] axi_master_w_data;
	output wire [(AXI_DATA_WIDTH / 8) - 1:0] axi_master_w_strb;
	output wire [AXI_USER_WIDTH - 1:0] axi_master_w_user;
	output wire axi_master_w_last;
	input wire axi_master_w_ready;
	input wire axi_master_r_valid;
	input wire [AXI_DATA_WIDTH - 1:0] axi_master_r_data;
	input wire [1:0] axi_master_r_resp;
	input wire axi_master_r_last;
	input wire [AXI_ID_WIDTH - 1:0] axi_master_r_id;
	input wire [AXI_USER_WIDTH - 1:0] axi_master_r_user;
	output wire axi_master_r_ready;
	input wire axi_master_b_valid;
	input wire [1:0] axi_master_b_resp;
	input wire [AXI_ID_WIDTH - 1:0] axi_master_b_id;
	input wire [AXI_USER_WIDTH - 1:0] axi_master_b_user;
	output wire axi_master_b_ready;
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
	always @(*)
		case (operation)
			4'h1: begin
				word_size_bits = 6'd7;
				word_size_bytes = 4'd1;
				rd_op = 1'b0;
			end
			4'h2: begin
				word_size_bits = 6'd15;
				word_size_bytes = 4'd2;
				rd_op = 1'b0;
			end
			4'h3: begin
				word_size_bits = 6'd31;
				word_size_bytes = 4'd4;
				rd_op = 1'b0;
			end
			4'h4: begin
				word_size_bits = 6'd63;
				word_size_bytes = 4'd8;
				rd_op = 1'b0;
			end
			4'h5: begin
				word_size_bits = 6'd7;
				word_size_bytes = 4'd1;
				rd_op = 1'b1;
			end
			4'h6: begin
				word_size_bits = 6'd15;
				word_size_bytes = 4'd2;
				rd_op = 1'b1;
			end
			4'h7: begin
				word_size_bits = 6'd31;
				word_size_bytes = 4'd4;
				rd_op = 1'b1;
			end
			4'h8: begin
				word_size_bits = 6'd63;
				word_size_bytes = 4'd4;
				rd_op = 1'b1;
			end
			default: begin
				word_size_bits = 6'b000000;
				word_size_bytes = 4'b0000;
				rd_op = 1'b0;
			end
		endcase
	always @(posedge tck_i or negedge trstn_i)
		if (~trstn_i)
			internal_register_select <= 1'h0;
		else if (regsel_ld_en)
			internal_register_select <= reg_select_data;
	always @(*)
		case (internal_register_select)
			1'b0: data_from_internal_reg = internal_reg_error;
			default: data_from_internal_reg = internal_reg_error;
		endcase
	always @(posedge tck_i or negedge trstn_i)
		if (~trstn_i)
			internal_reg_error <= 33'h000000000;
		else if (intreg_ld_en && (reg_select_data == 1'b0)) begin
			if (data_register_i[46])
				internal_reg_error[0] <= 1'b0;
		end
		else if (error_reg_en && !internal_reg_error[0]) begin
			if (biu_err || !biu_ready)
				internal_reg_error[0] <= 1'b1;
			else if (biu_strobe)
				internal_reg_error[32:1] <= address_counter;
		end
		else if (biu_strobe && !internal_reg_error[0])
			internal_reg_error[32:1] <= address_counter;
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
	always @(*)
		if (tdo_output_sel == 2'h0)
			module_tdo_o = biu_ready;
		else if (tdo_output_sel == 2'h1)
			module_tdo_o = data_out_shift_reg[0];
		else if (tdo_output_sel == 2'h2)
			module_tdo_o = crc_match;
		else
			module_tdo_o = crc_serial_out;
	adbg_axi_biu #(
		.AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
		.AXI_DATA_WIDTH(AXI_DATA_WIDTH),
		.AXI_USER_WIDTH(AXI_USER_WIDTH),
		.AXI_ID_WIDTH(AXI_ID_WIDTH)
	) axi_biu_i(
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
		.axi_aclk(axi_aclk),
		.axi_aresetn(axi_aresetn),
		.axi_master_aw_valid(axi_master_aw_valid),
		.axi_master_aw_addr(axi_master_aw_addr),
		.axi_master_aw_prot(axi_master_aw_prot),
		.axi_master_aw_region(axi_master_aw_region),
		.axi_master_aw_len(axi_master_aw_len),
		.axi_master_aw_size(axi_master_aw_size),
		.axi_master_aw_burst(axi_master_aw_burst),
		.axi_master_aw_lock(axi_master_aw_lock),
		.axi_master_aw_cache(axi_master_aw_cache),
		.axi_master_aw_qos(axi_master_aw_qos),
		.axi_master_aw_id(axi_master_aw_id),
		.axi_master_aw_user(axi_master_aw_user),
		.axi_master_aw_ready(axi_master_aw_ready),
		.axi_master_ar_valid(axi_master_ar_valid),
		.axi_master_ar_addr(axi_master_ar_addr),
		.axi_master_ar_prot(axi_master_ar_prot),
		.axi_master_ar_region(axi_master_ar_region),
		.axi_master_ar_len(axi_master_ar_len),
		.axi_master_ar_size(axi_master_ar_size),
		.axi_master_ar_burst(axi_master_ar_burst),
		.axi_master_ar_lock(axi_master_ar_lock),
		.axi_master_ar_cache(axi_master_ar_cache),
		.axi_master_ar_qos(axi_master_ar_qos),
		.axi_master_ar_id(axi_master_ar_id),
		.axi_master_ar_user(axi_master_ar_user),
		.axi_master_ar_ready(axi_master_ar_ready),
		.axi_master_w_valid(axi_master_w_valid),
		.axi_master_w_data(axi_master_w_data),
		.axi_master_w_strb(axi_master_w_strb),
		.axi_master_w_user(axi_master_w_user),
		.axi_master_w_last(axi_master_w_last),
		.axi_master_w_ready(axi_master_w_ready),
		.axi_master_r_valid(axi_master_r_valid),
		.axi_master_r_data(axi_master_r_data),
		.axi_master_r_resp(axi_master_r_resp),
		.axi_master_r_last(axi_master_r_last),
		.axi_master_r_id(axi_master_r_id),
		.axi_master_r_user(axi_master_r_user),
		.axi_master_r_ready(axi_master_r_ready),
		.axi_master_b_valid(axi_master_b_valid),
		.axi_master_b_resp(axi_master_b_resp),
		.axi_master_b_id(axi_master_b_id),
		.axi_master_b_user(axi_master_b_user),
		.axi_master_b_ready(axi_master_b_ready)
	);
	assign crc_data_in = (crc_in_sel ? tdi_i : data_out_shift_reg[0]);
	adbg_crc32 axi_crc_i(
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
	always @(*)
		case (module_state)
			4'd0:
				if (((module_cmd && module_select_i) && update_dr_i) && burst_read)
					module_next_state = 4'd1;
				else if (((module_cmd && module_select_i) && update_dr_i) && burst_write)
					module_next_state = 4'd5;
				else
					module_next_state = 4'd0;
			4'd1:
				if (word_count_zero)
					module_next_state = 4'd0;
				else
					module_next_state = 4'd2;
			4'd2:
				if (module_select_i && capture_dr_i)
					module_next_state = 4'd3;
				else
					module_next_state = 4'd2;
			4'd3:
				if (update_dr_i)
					module_next_state = 4'd0;
				else if (biu_ready)
					module_next_state = 4'd4;
				else
					module_next_state = 4'd3;
			4'd4:
				if (update_dr_i)
					module_next_state = 4'd0;
				else if (bit_count_max && word_count_zero)
					module_next_state = 4'd9;
				else
					module_next_state = 4'd4;
			4'd9:
				if (update_dr_i)
					module_next_state = 4'd0;
				else
					module_next_state = 4'd9;
			4'd5:
				if (word_count_zero)
					module_next_state = 4'd0;
				else if (module_select_i && capture_dr_i)
					module_next_state = 4'd6;
				else
					module_next_state = 4'd5;
			4'd6:
				if (update_dr_i)
					module_next_state = 4'd0;
				else if (module_select_i && data_register_i[63])
					module_next_state = 4'd7;
				else
					module_next_state = 4'd6;
			4'd7:
				if (update_dr_i)
					module_next_state = 4'd0;
				else if (bit_count_max) begin
					if (word_count_zero)
						module_next_state = 4'd10;
					else
						module_next_state = 4'd7;
				end
				else
					module_next_state = 4'd7;
			4'd8:
				if (update_dr_i)
					module_next_state = 4'd0;
				else if (word_count_zero)
					module_next_state = 4'd10;
				else
					module_next_state = 4'd7;
			4'd10:
				if (update_dr_i)
					module_next_state = 4'd0;
				else if (bit_count_32)
					module_next_state = 4'd11;
				else
					module_next_state = 4'd10;
			4'd11:
				if (update_dr_i)
					module_next_state = 4'd0;
				else
					module_next_state = 4'd11;
			default: module_next_state = 4'd0;
		endcase
	always @(*) begin
		addr_sel = 1'b1;
		addr_ct_en = 1'b0;
		op_reg_en = 1'b0;
		bit_ct_en = 1'b0;
		bit_ct_rst = 1'b0;
		word_ct_sel = 1'b1;
		word_ct_en = 1'b0;
		out_reg_ld_en = 1'b0;
		out_reg_shift_en = 1'b0;
		tdo_output_sel = 2'b01;
		biu_strobe = 1'b0;
		crc_clr = 1'b0;
		crc_en = 1'b0;
		crc_in_sel = 1'b0;
		crc_shift_en = 1'b0;
		out_reg_data_sel = 1'b1;
		regsel_ld_en = 1'b0;
		intreg_ld_en = 1'b0;
		error_reg_en = 1'b0;
		biu_clr_err = 1'b0;
		top_inhibit_o = 1'b0;
		case (module_state)
			4'd0: begin
				addr_sel = 1'b0;
				word_ct_sel = 1'b0;
				if (module_select_i & shift_dr_i)
					out_reg_shift_en = 1'b1;
				if (module_select_i & capture_dr_i) begin
					out_reg_data_sel = 1'b1;
					out_reg_ld_en = 1'b1;
				end
				if ((module_select_i & module_cmd) & update_dr_i) begin
					if (intreg_instruction)
						regsel_ld_en = 1'b1;
					if (intreg_write)
						intreg_ld_en = 1'b1;
				end
				if (module_next_state != 4'd0) begin
					addr_ct_en = 1'b1;
					op_reg_en = 1'b1;
					bit_ct_rst = 1'b1;
					word_ct_en = 1'b1;
					crc_clr = 1'b1;
				end
			end
			4'd1:
				if (!word_count_zero) begin
					biu_strobe = 1'b1;
					addr_sel = 1'b1;
					addr_ct_en = 1'b1;
				end
			4'd2:
				;
			4'd3: begin
				tdo_output_sel = 2'h0;
				top_inhibit_o = 1'b1;
				if (module_next_state == 4'd4) begin
					error_reg_en = 1'b1;
					out_reg_data_sel = 1'b0;
					out_reg_ld_en = 1'b1;
					bit_ct_rst = 1'b1;
					word_ct_sel = 1'b1;
					word_ct_en = 1'b1;
					if ((decremented_word_count != 0) && !word_count_zero) begin
						biu_strobe = 1'b1;
						addr_sel = 1'b1;
						addr_ct_en = 1'b1;
					end
				end
			end
			4'd4: begin
				tdo_output_sel = 2'h1;
				out_reg_shift_en = 1'b1;
				bit_ct_en = 1'b1;
				crc_en = 1'b1;
				crc_in_sel = 1'b0;
				top_inhibit_o = 1'b1;
				if (bit_count_max) begin
					error_reg_en = 1'b1;
					out_reg_data_sel = 1'b0;
					out_reg_ld_en = 1'b1;
					bit_ct_rst = 1'b1;
					word_ct_sel = 1'b1;
					word_ct_en = 1'b1;
					if ((decremented_word_count != 0) && !word_count_zero) begin
						biu_strobe = 1'b1;
						addr_sel = 1'b1;
						addr_ct_en = 1'b1;
					end
				end
			end
			4'd9: begin
				tdo_output_sel = 2'h3;
				crc_shift_en = 1'b1;
				top_inhibit_o = 1'b1;
			end
			4'd5:
				;
			4'd6: begin
				tdo_output_sel = 2'h1;
				top_inhibit_o = 1'b1;
				if (module_next_state == 4'd7) begin
					biu_clr_err = 1'b1;
					bit_ct_en = 1'b1;
					word_ct_sel = 1'b1;
					word_ct_en = 1'b1;
					crc_en = 1'b1;
					crc_in_sel = 1'b1;
				end
			end
			4'd7: begin
				bit_ct_en = 1'b1;
				tdo_output_sel = 2'h1;
				crc_en = 1'b1;
				crc_in_sel = 1'b1;
				top_inhibit_o = 1'b1;
				if (bit_count_max) begin
					error_reg_en = 1'b1;
					bit_ct_rst = 1'b1;
					biu_strobe = 1'b1;
					addr_ct_en = 1'b1;
					word_ct_sel = 1'b1;
					word_ct_en = 1'b1;
				end
			end
			4'd8: begin
				tdo_output_sel = 2'h0;
				error_reg_en = 1'b1;
				biu_strobe = 1'b1;
				word_ct_sel = 1'b1;
				word_ct_en = 1'b1;
				bit_ct_rst = 1'b1;
				addr_ct_en = 1'b1;
				top_inhibit_o = 1'b1;
			end
			4'd10: begin
				bit_ct_en = 1'b1;
				top_inhibit_o = 1'b1;
				if (module_next_state == 4'd11)
					tdo_output_sel = 2'h2;
			end
			4'd11: begin
				tdo_output_sel = 2'h2;
				top_inhibit_o = 1'b1;
				if (module_next_state == 4'd0)
					error_reg_en = 1'b1;
			end
			default:
				;
		endcase
	end
endmodule
