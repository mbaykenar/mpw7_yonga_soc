module spi_master_controller (
	clk,
	rstn,
	eot,
	spi_clk_div,
	spi_clk_div_valid,
	spi_status,
	spi_addr,
	spi_addr_len,
	spi_cmd,
	spi_cmd_len,
	spi_data_len,
	spi_dummy_rd,
	spi_dummy_wr,
	spi_csreg,
	spi_swrst,
	spi_rd,
	spi_wr,
	spi_qrd,
	spi_qwr,
	spi_ctrl_data_tx,
	spi_ctrl_data_tx_valid,
	spi_ctrl_data_tx_ready,
	spi_ctrl_data_rx,
	spi_ctrl_data_rx_valid,
	spi_ctrl_data_rx_ready,
	spi_clk,
	spi_csn0,
	spi_csn1,
	spi_csn2,
	spi_csn3,
	spi_mode,
	spi_sdo0,
	spi_sdo1,
	spi_sdo2,
	spi_sdo3,
	spi_sdi0,
	spi_sdi1,
	spi_sdi2,
	spi_sdi3
);
	input wire clk;
	input wire rstn;
	output reg eot;
	input wire [7:0] spi_clk_div;
	input wire spi_clk_div_valid;
	output reg [6:0] spi_status;
	input wire [31:0] spi_addr;
	input wire [5:0] spi_addr_len;
	input wire [31:0] spi_cmd;
	input wire [5:0] spi_cmd_len;
	input wire [15:0] spi_data_len;
	input wire [15:0] spi_dummy_rd;
	input wire [15:0] spi_dummy_wr;
	input wire [3:0] spi_csreg;
	input wire spi_swrst;
	input wire spi_rd;
	input wire spi_wr;
	input wire spi_qrd;
	input wire spi_qwr;
	input wire [31:0] spi_ctrl_data_tx;
	input wire spi_ctrl_data_tx_valid;
	output reg spi_ctrl_data_tx_ready;
	output wire [31:0] spi_ctrl_data_rx;
	output wire spi_ctrl_data_rx_valid;
	input wire spi_ctrl_data_rx_ready;
	output wire spi_clk;
	output wire spi_csn0;
	output wire spi_csn1;
	output wire spi_csn2;
	output wire spi_csn3;
	output reg [1:0] spi_mode;
	output wire spi_sdo0;
	output wire spi_sdo1;
	output wire spi_sdo2;
	output wire spi_sdo3;
	input wire spi_sdi0;
	input wire spi_sdi1;
	input wire spi_sdi2;
	input wire spi_sdi3;
	wire spi_rise;
	wire spi_fall;
	reg spi_clock_en;
	reg spi_en_tx;
	reg spi_en_rx;
	reg [15:0] counter_tx;
	reg counter_tx_valid;
	reg [15:0] counter_rx;
	reg counter_rx_valid;
	reg [31:0] data_to_tx;
	reg data_to_tx_valid;
	wire data_to_tx_ready;
	wire en_quad;
	reg en_quad_int;
	reg do_tx;
	reg do_rx;
	wire tx_done;
	wire rx_done;
	reg [1:0] s_spi_mode;
	reg ctrl_data_valid;
	reg spi_cs;
	wire tx_clk_en;
	wire rx_clk_en;
	reg [2:0] ctrl_data_mux;
	reg [4:0] state;
	reg [4:0] state_next;
	assign en_quad = (spi_qrd | spi_qwr) | en_quad_int;
	spi_master_clkgen u_clkgen(
		.clk(clk),
		.rstn(rstn),
		.en(spi_clock_en),
		.clk_div(spi_clk_div),
		.clk_div_valid(spi_clk_div_valid),
		.spi_clk(spi_clk),
		.spi_fall(spi_fall),
		.spi_rise(spi_rise)
	);
	spi_master_tx u_txreg(
		.clk(clk),
		.rstn(rstn),
		.en(spi_en_tx),
		.tx_edge(spi_fall),
		.tx_done(tx_done),
		.sdo0(spi_sdo0),
		.sdo1(spi_sdo1),
		.sdo2(spi_sdo2),
		.sdo3(spi_sdo3),
		.en_quad_in(en_quad),
		.counter_in(counter_tx),
		.counter_in_upd(counter_tx_valid),
		.data(data_to_tx),
		.data_valid(data_to_tx_valid),
		.data_ready(data_to_tx_ready),
		.clk_en_o(tx_clk_en)
	);
	spi_master_rx u_rxreg(
		.clk(clk),
		.rstn(rstn),
		.en(spi_en_rx),
		.rx_edge(spi_rise),
		.rx_done(rx_done),
		.sdi0(spi_sdi0),
		.sdi1(spi_sdi1),
		.sdi2(spi_sdi2),
		.sdi3(spi_sdi3),
		.en_quad_in(en_quad),
		.counter_in(counter_rx),
		.counter_in_upd(counter_rx_valid),
		.data(spi_ctrl_data_rx),
		.data_valid(spi_ctrl_data_rx_valid),
		.data_ready(spi_ctrl_data_rx_ready),
		.clk_en_o(rx_clk_en)
	);
	always @(*) begin
		data_to_tx = 'h0;
		data_to_tx_valid = 1'b0;
		spi_ctrl_data_tx_ready = 1'b0;
		case (ctrl_data_mux)
			3'd0: begin
				data_to_tx = 1'sb0;
				data_to_tx_valid = 1'b0;
				spi_ctrl_data_tx_ready = 1'b0;
			end
			3'd1: begin
				data_to_tx = 1'sb0;
				data_to_tx_valid = 1'b1;
			end
			3'd2: begin
				data_to_tx = spi_cmd;
				data_to_tx_valid = ctrl_data_valid;
				spi_ctrl_data_tx_ready = 1'b0;
			end
			3'd3: begin
				data_to_tx = spi_addr;
				data_to_tx_valid = ctrl_data_valid;
				spi_ctrl_data_tx_ready = 1'b0;
			end
			3'd4: begin
				data_to_tx = spi_ctrl_data_tx;
				data_to_tx_valid = spi_ctrl_data_tx_valid;
				spi_ctrl_data_tx_ready = data_to_tx_ready;
			end
		endcase
	end
	always @(*) begin
		spi_cs = 1'b1;
		spi_clock_en = 1'b0;
		counter_tx = 1'sb0;
		counter_tx_valid = 1'b0;
		counter_rx = 1'sb0;
		counter_rx_valid = 1'b0;
		state_next = state;
		ctrl_data_mux = 3'd0;
		ctrl_data_valid = 1'b0;
		spi_en_rx = 1'b0;
		spi_en_tx = 1'b0;
		spi_status = 1'sb0;
		s_spi_mode = 2'b10;
		eot = 1'b0;
		case (state)
			5'd0: begin
				spi_status[0] = 1'b1;
				s_spi_mode = 2'b10;
				if (((spi_rd || spi_wr) || spi_qrd) || spi_qwr) begin
					spi_cs = 1'b0;
					spi_clock_en = 1'b1;
					if (spi_cmd_len != 0) begin
						s_spi_mode = (spi_qrd | spi_qwr ? 2'b01 : 2'b00);
						counter_tx = {8'h00, spi_cmd_len};
						counter_tx_valid = 1'b1;
						ctrl_data_mux = 3'd2;
						ctrl_data_valid = 1'b1;
						spi_en_tx = 1'b1;
						state_next = 5'd1;
					end
					else if (spi_addr_len != 0) begin
						s_spi_mode = (spi_qrd | spi_qwr ? 2'b01 : 2'b00);
						counter_tx = {8'h00, spi_addr_len};
						counter_tx_valid = 1'b1;
						ctrl_data_mux = 3'd3;
						ctrl_data_valid = 1'b1;
						spi_en_tx = 1'b1;
						state_next = 5'd2;
					end
					else if (spi_data_len != 0)
						if (spi_rd || spi_qrd) begin
							s_spi_mode = (spi_qrd ? 2'b10 : 2'b00);
							if (spi_dummy_rd != 0) begin
								counter_tx = (en_quad ? {spi_dummy_rd[13:0], 2'b00} : spi_dummy_rd);
								counter_tx_valid = 1'b1;
								spi_en_tx = 1'b1;
								ctrl_data_mux = 3'd1;
								state_next = 5'd4;
							end
							else begin
								counter_rx = spi_data_len;
								counter_rx_valid = 1'b1;
								spi_en_rx = 1'b1;
								state_next = 5'd6;
							end
						end
						else begin
							s_spi_mode = (spi_qwr ? 2'b01 : 2'b00);
							if (spi_dummy_wr != 0) begin
								counter_tx = (en_quad ? {spi_dummy_wr[13:0], 2'b00} : spi_dummy_wr);
								counter_tx_valid = 1'b1;
								ctrl_data_mux = 3'd1;
								spi_en_tx = 1'b1;
								state_next = 5'd4;
							end
							else begin
								counter_tx = spi_data_len;
								counter_tx_valid = 1'b1;
								ctrl_data_mux = 3'd4;
								ctrl_data_valid = 1'b0;
								spi_en_tx = 1'b1;
								state_next = 5'd5;
							end
						end
				end
				else begin
					spi_cs = 1'b1;
					state_next = 5'd0;
				end
			end
			5'd1: begin
				spi_status[1] = 1'b1;
				spi_cs = 1'b0;
				spi_clock_en = 1'b1;
				s_spi_mode = (en_quad ? 2'b01 : 2'b00);
				if (tx_done) begin
					if (spi_addr_len != 0) begin
						s_spi_mode = (en_quad ? 2'b01 : 2'b00);
						counter_tx = {8'h00, spi_addr_len};
						counter_tx_valid = 1'b1;
						ctrl_data_mux = 3'd3;
						ctrl_data_valid = 1'b1;
						spi_en_tx = 1'b1;
						state_next = 5'd2;
					end
					else if (spi_data_len != 0) begin
						if (do_rx) begin
							s_spi_mode = (en_quad ? 2'b10 : 2'b00);
							if (spi_dummy_rd != 0) begin
								counter_tx = (en_quad ? {spi_dummy_rd[13:0], 2'b00} : spi_dummy_rd);
								counter_tx_valid = 1'b1;
								spi_en_tx = 1'b1;
								ctrl_data_mux = 3'd1;
								state_next = 5'd4;
							end
							else begin
								counter_rx = spi_data_len;
								counter_rx_valid = 1'b1;
								spi_en_rx = 1'b1;
								state_next = 5'd6;
							end
						end
						else begin
							s_spi_mode = (en_quad ? 2'b01 : 2'b00);
							if (spi_dummy_wr != 0) begin
								counter_tx = (en_quad ? {spi_dummy_wr[13:0], 2'b00} : spi_dummy_wr);
								counter_tx_valid = 1'b1;
								ctrl_data_mux = 3'd1;
								spi_en_tx = 1'b1;
								state_next = 5'd4;
							end
							else begin
								counter_tx = spi_data_len;
								counter_tx_valid = 1'b1;
								ctrl_data_mux = 3'd4;
								ctrl_data_valid = 1'b1;
								spi_en_tx = 1'b1;
								state_next = 5'd5;
							end
						end
					end
					else
						state_next = 5'd0;
				end
				else begin
					spi_en_tx = 1'b1;
					state_next = 5'd1;
				end
			end
			5'd2: begin
				spi_en_tx = 1'b1;
				spi_status[2] = 1'b1;
				spi_cs = 1'b0;
				spi_clock_en = 1'b1;
				s_spi_mode = (en_quad ? 2'b01 : 2'b00);
				if (tx_done)
					if (spi_data_len != 0) begin
						if (do_rx) begin
							s_spi_mode = (en_quad ? 2'b10 : 2'b00);
							if (spi_dummy_rd != 0) begin
								counter_tx = (en_quad ? {spi_dummy_rd[13:0], 2'b00} : spi_dummy_rd);
								counter_tx_valid = 1'b1;
								spi_en_tx = 1'b1;
								ctrl_data_mux = 3'd1;
								state_next = 5'd4;
							end
							else begin
								counter_rx = spi_data_len;
								counter_rx_valid = 1'b1;
								spi_en_rx = 1'b1;
								state_next = 5'd6;
							end
						end
						else begin
							s_spi_mode = (en_quad ? 2'b01 : 2'b00);
							spi_en_tx = 1'b1;
							if (spi_dummy_wr != 0) begin
								counter_tx = (en_quad ? {spi_dummy_wr[13:0], 2'b00} : spi_dummy_wr);
								counter_tx_valid = 1'b1;
								ctrl_data_mux = 3'd1;
								state_next = 5'd4;
							end
							else begin
								counter_tx = spi_data_len;
								counter_tx_valid = 1'b1;
								ctrl_data_mux = 3'd4;
								ctrl_data_valid = 1'b1;
								state_next = 5'd5;
							end
						end
					end
					else
						state_next = 5'd0;
			end
			5'd3: begin
				spi_status[3] = 1'b1;
				spi_cs = 1'b0;
				spi_clock_en = 1'b1;
				spi_en_tx = 1'b1;
			end
			5'd4: begin
				spi_en_tx = 1'b1;
				spi_status[4] = 1'b1;
				spi_cs = 1'b0;
				spi_clock_en = 1'b1;
				s_spi_mode = (en_quad ? 2'b10 : 2'b00);
				if (tx_done) begin
					if (spi_data_len != 0) begin
						if (do_rx) begin
							counter_rx = spi_data_len;
							counter_rx_valid = 1'b1;
							spi_en_rx = 1'b1;
							state_next = 5'd6;
						end
						else begin
							counter_tx = spi_data_len;
							counter_tx_valid = 1'b1;
							s_spi_mode = (en_quad ? 2'b01 : 2'b00);
							spi_clock_en = tx_clk_en;
							spi_en_tx = 1'b1;
							state_next = 5'd5;
						end
					end
					else begin
						eot = 1'b1;
						state_next = 5'd0;
					end
				end
				else begin
					ctrl_data_mux = 3'd1;
					spi_en_tx = 1'b1;
					state_next = 5'd4;
				end
			end
			5'd5: begin
				spi_status[5] = 1'b1;
				spi_cs = 1'b0;
				spi_clock_en = tx_clk_en;
				ctrl_data_mux = 3'd4;
				ctrl_data_valid = 1'b1;
				spi_en_tx = 1'b1;
				s_spi_mode = (en_quad ? 2'b01 : 2'b00);
				if (tx_done) begin
					eot = 1'b1;
					state_next = 5'd0;
					spi_clock_en = 1'b0;
				end
				else
					state_next = 5'd5;
			end
			5'd6: begin
				spi_status[6] = 1'b1;
				spi_cs = 1'b0;
				spi_clock_en = rx_clk_en;
				s_spi_mode = (en_quad ? 2'b10 : 2'b00);
				if (rx_done)
					state_next = 5'd7;
				else begin
					spi_en_rx = 1'b1;
					state_next = 5'd6;
				end
			end
			5'd7: begin
				spi_status[6] = 1'b1;
				spi_cs = 1'b0;
				spi_clock_en = 1'b0;
				s_spi_mode = (en_quad ? 2'b10 : 2'b00);
				if (spi_fall) begin
					eot = 1'b1;
					state_next = 5'd0;
				end
				else
					state_next = 5'd7;
			end
		endcase
	end
	always @(posedge clk or negedge rstn)
		if (rstn == 1'b0) begin
			state <= 5'd0;
			en_quad_int <= 1'b0;
			do_rx <= 1'b0;
			do_tx <= 1'b0;
			spi_mode <= 2'b10;
		end
		else begin
			state <= state_next;
			spi_mode <= s_spi_mode;
			if (spi_qrd || spi_qwr)
				en_quad_int <= 1'b1;
			else if (state_next == 5'd0)
				en_quad_int <= 1'b0;
			if (spi_rd || spi_qrd) begin
				do_rx <= 1'b1;
				do_tx <= 1'b0;
			end
			else if (spi_wr || spi_qwr) begin
				do_rx <= 1'b0;
				do_tx <= 1'b1;
			end
			else if (state_next == 5'd0) begin
				do_rx <= 1'b0;
				do_tx <= 1'b0;
			end
		end
	assign spi_csn0 = ~spi_csreg[0] | spi_cs;
	assign spi_csn1 = ~spi_csreg[1] | spi_cs;
	assign spi_csn2 = ~spi_csreg[2] | spi_cs;
	assign spi_csn3 = ~spi_csreg[3] | spi_cs;
endmodule
