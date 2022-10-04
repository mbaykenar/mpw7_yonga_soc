module adbg_axi_biu 
#(
    parameter AXI_ADDR_WIDTH = 32,
    parameter AXI_DATA_WIDTH = 64,
    parameter AXI_USER_WIDTH = 6,
    parameter AXI_ID_WIDTH   = 3
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
	input wire trstn_i;
	input wire [63:0] data_i;
	output reg [63:0] data_o;
	input wire [31:0] addr_i;
	input wire strobe_i;
	input wire rd_wrn_i;
	output reg rdy_o;
	output wire err_o;
	input wire [3:0] word_size_i;
	input wire axi_aclk;
	input wire axi_aresetn;
	output reg axi_master_aw_valid;
	output wire [AXI_ADDR_WIDTH - 1:0] axi_master_aw_addr;
	output wire [2:0] axi_master_aw_prot;
	output wire [3:0] axi_master_aw_region;
	output wire [7:0] axi_master_aw_len;
	output reg [2:0] axi_master_aw_size;
	output wire [1:0] axi_master_aw_burst;
	output wire axi_master_aw_lock;
	output wire [3:0] axi_master_aw_cache;
	output wire [3:0] axi_master_aw_qos;
	output wire [AXI_ID_WIDTH - 1:0] axi_master_aw_id;
	output wire [AXI_USER_WIDTH - 1:0] axi_master_aw_user;
	input wire axi_master_aw_ready;
	output reg axi_master_ar_valid;
	output wire [AXI_ADDR_WIDTH - 1:0] axi_master_ar_addr;
	output wire [2:0] axi_master_ar_prot;
	output wire [3:0] axi_master_ar_region;
	output wire [7:0] axi_master_ar_len;
	output reg [2:0] axi_master_ar_size;
	output wire [1:0] axi_master_ar_burst;
	output wire axi_master_ar_lock;
	output wire [3:0] axi_master_ar_cache;
	output wire [3:0] axi_master_ar_qos;
	output wire [AXI_ID_WIDTH - 1:0] axi_master_ar_id;
	output wire [AXI_USER_WIDTH - 1:0] axi_master_ar_user;
	input wire axi_master_ar_ready;
	output reg axi_master_w_valid;
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
	output reg axi_master_r_ready;
	input wire axi_master_b_valid;
	input wire [1:0] axi_master_b_resp;
	input wire [AXI_ID_WIDTH - 1:0] axi_master_b_id;
	input wire [AXI_USER_WIDTH - 1:0] axi_master_b_user;
	output reg axi_master_b_ready;
	reg [(AXI_DATA_WIDTH / 8) - 1:0] sel_reg;
	reg [AXI_ADDR_WIDTH - 1:0] addr_reg;
	reg [AXI_DATA_WIDTH - 1:0] data_in_reg;
	reg [AXI_DATA_WIDTH - 1:0] data_out_reg;
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
	reg [(AXI_DATA_WIDTH / 8) - 1:0] be_dec;
	wire start_toggle;
	reg [AXI_DATA_WIDTH - 1:0] swapped_data_i;
	reg [AXI_DATA_WIDTH - 1:0] swapped_data_out;
	reg [1:0] axi_fsm_state;
	reg [1:0] next_fsm_state;
	always @(*)
		if (AXI_DATA_WIDTH == 64)
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
		else if (AXI_DATA_WIDTH == 32)
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
	always @(*)
		if (AXI_DATA_WIDTH == 64)
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
		else if (AXI_DATA_WIDTH == 32)
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
	generate
		if (AXI_DATA_WIDTH == 64) begin : genblk1
			always @(*)
				case (sel_reg)
					8'b00001111: swapped_data_out = axi_master_r_data;
					8'b11110000: swapped_data_out = {32'h00000000, axi_master_r_data[63:32]};
					8'b00000011: swapped_data_out = axi_master_r_data;
					8'b00001100: swapped_data_out = {16'h0000, axi_master_r_data[63:16]};
					8'b00110000: swapped_data_out = {32'h00000000, axi_master_r_data[63:32]};
					8'b11000000: swapped_data_out = {48'h000000000000, axi_master_r_data[63:48]};
					8'b00000001: swapped_data_out = axi_master_r_data;
					8'b00000010: swapped_data_out = {8'h00, axi_master_r_data[63:8]};
					8'b00000100: swapped_data_out = {16'h0000, axi_master_r_data[63:16]};
					8'b00001000: swapped_data_out = {24'h000000, axi_master_r_data[63:24]};
					8'b00010000: swapped_data_out = {32'h00000000, axi_master_r_data[63:32]};
					8'b00100000: swapped_data_out = {40'h0000000000, axi_master_r_data[63:40]};
					8'b01000000: swapped_data_out = {48'h000000000000, axi_master_r_data[63:48]};
					8'b10000000: swapped_data_out = {56'h00000000000000, axi_master_r_data[63:56]};
					default: swapped_data_out = axi_master_r_data;
				endcase
		end
		else if (AXI_DATA_WIDTH == 32) begin : genblk1
			always @(*)
				case (sel_reg)
					4'b1111: swapped_data_out = axi_master_r_data;
					4'b0011: swapped_data_out = axi_master_r_data;
					4'b1100: swapped_data_out = {16'h0000, axi_master_r_data[31:16]};
					4'b0001: swapped_data_out = axi_master_r_data;
					4'b0010: swapped_data_out = {8'h00, axi_master_r_data[31:8]};
					4'b0100: swapped_data_out = {16'h0000, axi_master_r_data[31:16]};
					4'b1000: swapped_data_out = {24'h000000, axi_master_r_data[31:24]};
					default: swapped_data_out = axi_master_r_data;
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
	assign axi_master_ar_addr = addr_reg;
	assign axi_master_aw_addr = addr_reg;
	assign axi_master_w_data = data_in_reg;
	assign axi_master_w_strb = sel_reg;
	always @(*)
		if (AXI_DATA_WIDTH == 64)
			data_o = data_out_reg;
		else if (AXI_DATA_WIDTH == 32)
			data_o = {32'h00000000, data_out_reg};
	assign err_o = err_reg;
	assign axi_master_aw_prot = 'h0;
	assign axi_master_aw_region = 'h0;
	assign axi_master_aw_len = 'h0;
	assign axi_master_aw_burst = 'h0;
	assign axi_master_aw_lock = 'h0;
	assign axi_master_aw_cache = 'h0;
	assign axi_master_aw_qos = 'h0;
	assign axi_master_aw_id = 'h0;
	assign axi_master_aw_user = 'h0;
	assign axi_master_ar_prot = 'h0;
	assign axi_master_ar_region = 'h0;
	assign axi_master_ar_len = 'h0;
	assign axi_master_ar_burst = 'h0;
	assign axi_master_ar_lock = 'h0;
	assign axi_master_ar_cache = 'h0;
	assign axi_master_ar_qos = 'h0;
	assign axi_master_ar_id = 'h0;
	assign axi_master_ar_user = 'h0;
	assign axi_master_w_user = 'h0;
	assign axi_master_w_last = 1'b1;
	always @(*)
		case (word_size_i)
			4'h1: begin
				axi_master_aw_size = 3'b000;
				axi_master_ar_size = 3'b000;
			end
			4'h2: begin
				axi_master_aw_size = 3'b001;
				axi_master_ar_size = 3'b001;
			end
			4'h4: begin
				axi_master_aw_size = 3'b010;
				axi_master_ar_size = 3'b010;
			end
			4'h8: begin
				axi_master_aw_size = 3'b011;
				axi_master_ar_size = 3'b011;
			end
			default: begin
				axi_master_aw_size = 3'b011;
				axi_master_ar_size = 3'b011;
			end
		endcase
	always @(posedge axi_aclk or negedge axi_aresetn)
		if (!axi_aresetn) begin
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
	always @(posedge axi_aclk or negedge axi_aresetn)
		if (!axi_aresetn)
			err_reg <= 1'b0;
		else if (err_en)
			err_reg <= (wr_reg ? (axi_master_b_resp == 2'b00 ? 1'b0 : 1'b1) : (axi_master_r_resp == 2'b00 ? 1'b0 : 1'b1));
	always @(posedge axi_aclk or negedge axi_aresetn)
		if (!axi_aresetn)
			data_out_reg <= 32'h00000000;
		else if (data_o_en)
			data_out_reg <= swapped_data_out;
	always @(posedge axi_aclk or negedge axi_aresetn)
		if (!axi_aresetn)
			rdy_sync <= 1'b0;
		else if (rdy_sync_en)
			rdy_sync <= ~rdy_sync;
	always @(posedge axi_aclk or negedge axi_aresetn)
		if (~axi_aresetn)
			axi_fsm_state <= 2'd0;
		else
			axi_fsm_state <= next_fsm_state;
	always @(*) begin
		axi_master_aw_valid = 1'b0;
		axi_master_w_valid = 1'b0;
		axi_master_ar_valid = 1'b0;
		axi_master_b_ready = 1'b0;
		axi_master_r_ready = 1'b0;
		next_fsm_state = axi_fsm_state;
		rdy_sync_en = 1'b0;
		data_o_en = 1'b0;
		err_en = 1'b0;
		case (axi_fsm_state)
			2'd0:
				if (start_toggle)
					next_fsm_state = 2'd1;
				else
					next_fsm_state = 2'd0;
			2'd1: begin
				if (wr_reg)
					axi_master_aw_valid = 1'b1;
				else
					axi_master_ar_valid = 1'b1;
				if (wr_reg && axi_master_aw_ready)
					next_fsm_state = 2'd2;
				else if (!wr_reg && axi_master_ar_ready)
					next_fsm_state = 2'd3;
			end
			2'd2: begin
				axi_master_w_valid = 1'b1;
				if (axi_master_w_ready)
					next_fsm_state = 2'd3;
			end
			2'd3: begin
				if (wr_reg)
					axi_master_b_ready = 1'b1;
				else
					axi_master_r_ready = 1'b1;
				if (wr_reg && axi_master_b_valid) begin
					next_fsm_state = 2'd0;
					rdy_sync_en = 1'b1;
					err_en = 1'b1;
				end
				else if (!wr_reg && axi_master_r_valid) begin
					data_o_en = 1'b1;
					next_fsm_state = 2'd0;
					rdy_sync_en = 1'b1;
					err_en = 1'b1;
				end
			end
		endcase
	end
endmodule
