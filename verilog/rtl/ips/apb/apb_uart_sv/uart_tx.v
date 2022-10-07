module uart_tx (
	clk_i,
	rstn_i,
	tx_o,
	busy_o,
	cfg_en_i,
	cfg_div_i,
	cfg_parity_en_i,
	cfg_bits_i,
	cfg_stop_bits_i,
	tx_data_i,
	tx_valid_i,
	tx_ready_o
);
	input wire clk_i;
	input wire rstn_i;
	output reg tx_o;
	output wire busy_o;
	input wire cfg_en_i;
	input wire [15:0] cfg_div_i;
	input wire cfg_parity_en_i;
	input wire [1:0] cfg_bits_i;
	input wire cfg_stop_bits_i;
	input wire [7:0] tx_data_i;
	input wire tx_valid_i;
	output reg tx_ready_o;
	reg [2:0] CS;
	reg [2:0] NS;
	reg [7:0] reg_data;
	reg [7:0] reg_data_next;
	reg [2:0] reg_bit_count;
	reg [2:0] reg_bit_count_next;
	reg [2:0] s_target_bits;
	reg parity_bit;
	reg parity_bit_next;
	reg sampleData;
	reg [15:0] baud_cnt;
	reg baudgen_en;
	reg bit_done;
	assign busy_o = CS != 3'd0;
	always @(*)
		case (cfg_bits_i)
			2'b00: s_target_bits = 3'h4;
			2'b01: s_target_bits = 3'h5;
			2'b10: s_target_bits = 3'h6;
			2'b11: s_target_bits = 3'h7;
		endcase
	always @(*) begin
		NS = CS;
		tx_o = 1'b1;
		sampleData = 1'b0;
		reg_bit_count_next = reg_bit_count;
		reg_data_next = {1'b1, reg_data[7:1]};
		tx_ready_o = 1'b0;
		baudgen_en = 1'b0;
		parity_bit_next = parity_bit;
		case (CS)
			3'd0: begin
				if (cfg_en_i)
					tx_ready_o = 1'b1;
				if (tx_valid_i) begin
					NS = 3'd1;
					sampleData = 1'b1;
					reg_data_next = tx_data_i;
				end
			end
			3'd1: begin
				tx_o = 1'b0;
				parity_bit_next = 1'b0;
				baudgen_en = 1'b1;
				if (bit_done)
					NS = 3'd2;
			end
			3'd2: begin
				tx_o = reg_data[0];
				baudgen_en = 1'b1;
				parity_bit_next = parity_bit ^ reg_data[0];
				if (bit_done)
					if (reg_bit_count == s_target_bits) begin
						reg_bit_count_next = 'h0;
						if (cfg_parity_en_i)
							NS = 3'd3;
						else
							NS = 3'd4;
					end
					else begin
						reg_bit_count_next = reg_bit_count + 1;
						sampleData = 1'b1;
					end
			end
			3'd3: begin
				tx_o = parity_bit;
				baudgen_en = 1'b1;
				if (bit_done)
					NS = 3'd4;
			end
			3'd4: begin
				tx_o = 1'b1;
				baudgen_en = 1'b1;
				if (bit_done)
					if (cfg_stop_bits_i)
						NS = 3'd5;
					else
						NS = 3'd0;
			end
			3'd5: begin
				tx_o = 1'b1;
				baudgen_en = 1'b1;
				if (bit_done)
					NS = 3'd0;
			end
			default: NS = 3'd0;
		endcase
	end
	always @(posedge clk_i or negedge rstn_i)
		if (rstn_i == 1'b0) begin
			CS <= 3'd0;
			reg_data <= 8'hff;
			reg_bit_count <= 'h0;
			parity_bit <= 1'b0;
		end
		else begin
			if (bit_done)
				parity_bit <= parity_bit_next;
			if (sampleData)
				reg_data <= reg_data_next;
			reg_bit_count <= reg_bit_count_next;
			if (cfg_en_i)
				CS <= NS;
			else
				CS <= 3'd0;
		end
	always @(posedge clk_i or negedge rstn_i)
		if (rstn_i == 1'b0) begin
			baud_cnt <= 'h0;
			bit_done <= 1'b0;
		end
		else if (baudgen_en) begin
			if (baud_cnt == cfg_div_i) begin
				baud_cnt <= 'h0;
				bit_done <= 1'b1;
			end
			else begin
				baud_cnt <= baud_cnt + 1;
				bit_done <= 1'b0;
			end
		end
		else begin
			baud_cnt <= 'h0;
			bit_done <= 1'b0;
		end
endmodule
