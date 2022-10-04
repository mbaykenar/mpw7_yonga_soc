module adbg_lint_biu 
#(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 64,
    parameter AUX_WIDTH = 6
)
(
	tck_i,
	trstn_i,
	data_i,
	data_o,
	addr_i,
	strobe_i,
	rd_wrn_i,
	rdy_o,
	err_o,
	word_size_i,
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
	input wire trstn_i;
	input wire [63:0] data_i;
	output reg [63:0] data_o;
	input wire [31:0] addr_i;
	input wire strobe_i;
	input wire rd_wrn_i;
	output reg rdy_o;
	output wire err_o;
	input wire [3:0] word_size_i;
	input wire clk_i;
	input wire rstn_i;
	output reg lint_req_o;
	output wire [ADDR_WIDTH - 1:0] lint_add_o;
	output reg lint_wen_o;
	output wire [DATA_WIDTH - 1:0] lint_wdata_o;
	output wire [(DATA_WIDTH / 8) - 1:0] lint_be_o;
	output wire [AUX_WIDTH - 1:0] lint_aux_o;
	input wire lint_gnt_i;
	input wire lint_r_aux_i;
	input wire lint_r_valid_i;
	input wire [DATA_WIDTH - 1:0] lint_r_rdata_i;
	input wire lint_r_opc_i;
	reg [(DATA_WIDTH / 8) - 1:0] sel_reg;
	reg [ADDR_WIDTH - 1:0] addr_reg;
	reg [DATA_WIDTH - 1:0] data_in_reg;
	reg [DATA_WIDTH - 1:0] data_out_reg;
	reg wr_reg;
	reg str_sync;
	reg rdy_sync;
	reg err_reg;
	reg rdy_sync_tff1;
	reg rdy_sync_tff2;
	reg rdy_sync_tff2q;
	reg str_sync_wbff1;
	reg str_sync_wbff2;
	reg str_sync_wbff2q;
	reg data_o_en;
	reg rdy_sync_en;
	reg err_en;
	reg [(DATA_WIDTH / 8) - 1:0] be_dec;
	wire start_toggle;
	reg [DATA_WIDTH - 1:0] swapped_data_i;
	reg [DATA_WIDTH - 1:0] swapped_data_out;
	reg [1:0] lint_fsm_state;
	reg [1:0] next_fsm_state;
	generate
		if (DATA_WIDTH == 64) begin : genblk1
			always @(*)
				case (word_size_i)
					4'h1:
						if (addr_i[2:0] == 3'b000)
							be_dec = 8'b00000001;
						else if (addr_i[2:0] == 3'b001)
							be_dec = 8'b00000010;
						else if (addr_i[2:0] == 3'b010)
							be_dec = 8'b00000100;
						else if (addr_i[2:0] == 3'b011)
							be_dec = 8'b00001000;
						else if (addr_i[2:0] == 3'b100)
							be_dec = 8'b00010000;
						else if (addr_i[2:0] == 3'b101)
							be_dec = 8'b00100000;
						else if (addr_i[2:0] == 3'b110)
							be_dec = 8'b01000000;
						else
							be_dec = 8'b10000000;
					4'h2:
						if (addr_i[2:1] == 2'b00)
							be_dec = 8'b00000011;
						else if (addr_i[2:1] == 2'b01)
							be_dec = 8'b00001100;
						else if (addr_i[2:1] == 2'b10)
							be_dec = 8'b00110000;
						else
							be_dec = 8'b11000000;
					4'h4:
						if (addr_i[2] == 1'b0)
							be_dec = 8'b00001111;
						else
							be_dec = 8'b11110000;
					4'h8: be_dec = 8'b11111111;
					default: be_dec = 8'b11111111;
				endcase
		end
		else if (DATA_WIDTH == 32) begin : genblk1
			always @(*)
				case (word_size_i)
					4'h1:
						if (addr_i[1:0] == 2'b00)
							be_dec = 4'b0001;
						else if (addr_i[1:0] == 2'b01)
							be_dec = 4'b0010;
						else if (addr_i[1:0] == 2'b10)
							be_dec = 4'b0100;
						else
							be_dec = 4'b1000;
					4'h2:
						if (addr_i[1] == 1'b0)
							be_dec = 4'b0011;
						else
							be_dec = 4'b1100;
					4'h4: be_dec = 4'b1111;
					4'h8: be_dec = 4'b1111;
					default: be_dec = 4'b1111;
				endcase
		end
		if (DATA_WIDTH == 64) begin : genblk2
			always @(*)
				case (be_dec)
					8'b00001111: swapped_data_i = {32'h00000000, data_i[63:32]};
					8'b11110000: swapped_data_i = {data_i[63:32], 32'h00000000};
					8'b00000011: swapped_data_i = {48'h000000000000, data_i[63:48]};
					8'b00001100: swapped_data_i = {32'h00000000, data_i[63:48], 16'h0000};
					8'b00110000: swapped_data_i = {16'h0000, data_i[63:48], 32'h00000000};
					8'b11000000: swapped_data_i = {data_i[63:48], 48'h000000000000};
					8'b00000001: swapped_data_i = {56'h00000000000000, data_i[63:56]};
					8'b00000010: swapped_data_i = {48'h000000000000, data_i[63:56], 8'h00};
					8'b00000100: swapped_data_i = {40'h0000000000, data_i[63:56], 16'h0000};
					8'b00001000: swapped_data_i = {32'h00000000, data_i[63:56], 24'h000000};
					8'b00010000: swapped_data_i = {24'h000000, data_i[63:56], 32'h00000000};
					8'b00100000: swapped_data_i = {16'h0000, data_i[63:56], 40'h0000000000};
					8'b01000000: swapped_data_i = {8'h00, data_i[63:56], 48'h000000000000};
					8'b10000000: swapped_data_i = {data_i[63:56], 56'h00000000000000};
					default: swapped_data_i = data_i;
				endcase
		end
		else if (DATA_WIDTH == 32) begin : genblk2
			always @(*)
				case (be_dec)
					4'b1111: swapped_data_i = data_i[63:32];
					4'b0011: swapped_data_i = {16'h0000, data_i[63:48]};
					4'b1100: swapped_data_i = {data_i[63:48], 16'h0000};
					4'b0001: swapped_data_i = {24'h000000, data_i[63:56]};
					4'b0010: swapped_data_i = {16'h0000, data_i[63:56], 8'h00};
					4'b0100: swapped_data_i = {8'h00, data_i[63:56], 16'h0000};
					4'b1000: swapped_data_i = {data_i[63:56], 24'h000000};
					default: swapped_data_i = data_i[63:32];
				endcase
		end
		if (DATA_WIDTH == 64) begin : genblk3
			always @(*)
				case (sel_reg)
					8'b00001111: swapped_data_out = lint_r_rdata_i;
					8'b11110000: swapped_data_out = {32'h00000000, lint_r_rdata_i[63:32]};
					8'b00000011: swapped_data_out = lint_r_rdata_i;
					8'b00001100: swapped_data_out = {16'h0000, lint_r_rdata_i[63:16]};
					8'b00110000: swapped_data_out = {32'h00000000, lint_r_rdata_i[63:32]};
					8'b11000000: swapped_data_out = {48'h000000000000, lint_r_rdata_i[63:48]};
					8'b00000001: swapped_data_out = lint_r_rdata_i;
					8'b00000010: swapped_data_out = {8'h00, lint_r_rdata_i[63:8]};
					8'b00000100: swapped_data_out = {16'h0000, lint_r_rdata_i[63:16]};
					8'b00001000: swapped_data_out = {24'h000000, lint_r_rdata_i[63:24]};
					8'b00010000: swapped_data_out = {32'h00000000, lint_r_rdata_i[63:32]};
					8'b00100000: swapped_data_out = {40'h0000000000, lint_r_rdata_i[63:40]};
					8'b01000000: swapped_data_out = {48'h000000000000, lint_r_rdata_i[63:48]};
					8'b10000000: swapped_data_out = {56'h00000000000000, lint_r_rdata_i[63:56]};
					default: swapped_data_out = lint_r_rdata_i;
				endcase
		end
		else if (DATA_WIDTH == 32) begin : genblk3
			always @(*)
				case (sel_reg)
					4'b1111: swapped_data_out = lint_r_rdata_i;
					4'b0011: swapped_data_out = lint_r_rdata_i;
					4'b1100: swapped_data_out = {16'h0000, lint_r_rdata_i[31:16]};
					4'b0001: swapped_data_out = lint_r_rdata_i;
					4'b0010: swapped_data_out = {8'h00, lint_r_rdata_i[31:8]};
					4'b0100: swapped_data_out = {16'h0000, lint_r_rdata_i[31:16]};
					4'b1000: swapped_data_out = {24'h000000, lint_r_rdata_i[31:24]};
					default: swapped_data_out = lint_r_rdata_i;
				endcase
		end
	endgenerate
	always @(posedge tck_i or negedge trstn_i)
		if (~trstn_i) begin
			sel_reg <= 'h0;
			addr_reg <= 'h0;
			data_in_reg <= 'h0;
			wr_reg <= 1'b0;
		end
		else if (strobe_i && rdy_o) begin
			sel_reg <= be_dec;
			addr_reg <= addr_i;
			if (!rd_wrn_i)
				data_in_reg <= swapped_data_i;
			wr_reg <= ~rd_wrn_i;
		end
	always @(posedge tck_i or negedge trstn_i)
		if (~trstn_i)
			str_sync <= 1'b0;
		else if (strobe_i && rdy_o)
			str_sync <= ~str_sync;
	always @(posedge tck_i or negedge trstn_i)
		if (~trstn_i) begin
			rdy_sync_tff1 <= 1'b0;
			rdy_sync_tff2 <= 1'b0;
			rdy_sync_tff2q <= 1'b0;
		end
		else begin
			rdy_sync_tff1 <= rdy_sync;
			rdy_sync_tff2 <= rdy_sync_tff1;
			rdy_sync_tff2q <= rdy_sync_tff2;
		end
	always @(posedge tck_i or negedge trstn_i)
		if (~trstn_i)
			rdy_o <= 1'b1;
		else if (strobe_i && rdy_o)
			rdy_o <= 1'b0;
		else if (rdy_sync_tff2 != rdy_sync_tff2q)
			rdy_o <= 1'b1;
	assign lint_add_o = addr_reg;
	assign lint_wdata_o = data_in_reg;
	assign lint_be_o = sel_reg;
	always @(*)
		if (DATA_WIDTH == 64)
			data_o = data_out_reg;
		else if (DATA_WIDTH == 32)
			data_o = {32'h00000000, data_out_reg};
	assign err_o = err_reg;
	assign lint_aux_o = 'h0;
	always @(posedge clk_i or negedge rstn_i)
		if (!rstn_i) begin
			str_sync_wbff1 <= 1'b0;
			str_sync_wbff2 <= 1'b0;
			str_sync_wbff2q <= 1'b0;
		end
		else begin
			str_sync_wbff1 <= str_sync;
			str_sync_wbff2 <= str_sync_wbff1;
			str_sync_wbff2q <= str_sync_wbff2;
		end
	assign start_toggle = str_sync_wbff2 != str_sync_wbff2q;
	always @(posedge clk_i or negedge rstn_i)
		if (!rstn_i)
			err_reg <= 1'b0;
		else if (err_en)
			err_reg <= 1'b0;
	always @(posedge clk_i or negedge rstn_i)
		if (!rstn_i)
			data_out_reg <= 32'h00000000;
		else if (data_o_en)
			data_out_reg <= swapped_data_out;
	always @(posedge clk_i or negedge rstn_i)
		if (!rstn_i)
			rdy_sync <= 1'b0;
		else if (rdy_sync_en)
			rdy_sync <= ~rdy_sync;
	always @(posedge clk_i or negedge rstn_i)
		if (~rstn_i)
			lint_fsm_state <= 2'd0;
		else
			lint_fsm_state <= next_fsm_state;
	always @(*) begin
		lint_wen_o = 1'b1;
		lint_req_o = 1'b0;
		next_fsm_state = lint_fsm_state;
		rdy_sync_en = 1'b0;
		data_o_en = 1'b0;
		err_en = 1'b0;
		case (lint_fsm_state)
			2'd0:
				if (start_toggle)
					next_fsm_state = 2'd1;
				else
					next_fsm_state = 2'd0;
			2'd1: begin
				lint_req_o = 1'b1;
				if (wr_reg)
					lint_wen_o = 1'b0;
				if (lint_gnt_i)
					if (wr_reg) begin
						next_fsm_state = 2'd0;
						rdy_sync_en = 1'b1;
						err_en = 1'b1;
					end
					else
						next_fsm_state = 2'd2;
			end
			2'd2:
				if (lint_r_valid_i) begin
					next_fsm_state = 2'd0;
					rdy_sync_en = 1'b1;
					err_en = 1'b1;
					if (!wr_reg)
						data_o_en = 1'b1;
				end
		endcase
	end
endmodule
