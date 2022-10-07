module spi_slave_controller 
#(
    parameter DUMMY_CYCLES = 32
    )
(
	sclk,
	sys_rstn,
	cs,
	en_quad,
	pad_mode,
	rx_counter,
	rx_counter_upd,
	rx_data,
	rx_data_valid,
	tx_counter,
	tx_counter_upd,
	tx_data,
	tx_data_valid,
	tx_done,
	ctrl_rd_wr,
	ctrl_addr,
	ctrl_addr_valid,
	ctrl_data_rx,
	ctrl_data_rx_valid,
	ctrl_data_rx_ready,
	ctrl_data_tx,
	ctrl_data_tx_valid,
	ctrl_data_tx_ready,
	wrap_length
);
	//parameter DUMMY_CYCLES = 32;
	input wire sclk;
	input wire sys_rstn;
	input wire cs;
	output wire en_quad;
	output reg [1:0] pad_mode;
	output reg [7:0] rx_counter;
	output reg rx_counter_upd;
	input wire [31:0] rx_data;
	input wire rx_data_valid;
	output reg [7:0] tx_counter;
	output reg tx_counter_upd;
	output reg [31:0] tx_data;
	output reg tx_data_valid;
	input wire tx_done;
	output wire ctrl_rd_wr;
	output wire [31:0] ctrl_addr;
	output reg ctrl_addr_valid;
	output wire [31:0] ctrl_data_rx;
	output reg ctrl_data_rx_valid;
	input wire ctrl_data_rx_ready;
	input wire [31:0] ctrl_data_tx;
	input wire ctrl_data_tx_valid;
	output reg ctrl_data_tx_ready;
	output wire [15:0] wrap_length;
	localparam REG_SIZE = 8;
	reg [2:0] state;
	reg [2:0] state_next;
	wire [7:0] command;
	reg decode_cmd_comb;
	reg [31:0] addr_reg;
	reg [7:0] cmd_reg;
	reg [7:0] mode_reg;
	reg [31:0] data_reg;
	reg sample_ADDR;
	reg sample_MODE;
	reg sample_CMD;
	reg sample_DATA;
	wire get_addr;
	wire wait_dummy;
	wire get_mode;
	wire get_data;
	wire send_data;
	wire enable_cont;
	wire enable_regs;
	wire cmd_error;
	wire [1:0] reg_sel;
	wire [7:0] reg_data;
	reg reg_valid;
	reg ctrl_data_tx_ready_next;
	reg [7:0] tx_counter_next;
	reg tx_counter_upd_next;
	reg tx_data_valid_next;
	reg tx_done_reg;
	reg [1:0] pad_mode_next;
	wire [7:0] s_dummy_cycles;
	assign command = (decode_cmd_comb ? rx_data[7:0] : cmd_reg);
	spi_slave_cmd_parser u_cmd_parser(
		.cmd(command),
		.get_addr(get_addr),
		.get_mode(get_mode),
		.get_data(get_data),
		.send_data(send_data),
		.wait_dummy(wait_dummy),
		.enable_cont(enable_cont),
		.enable_regs(enable_regs),
		.error(cmd_error),
		.reg_sel(reg_sel)
	);
	spi_slave_regs #(.REG_SIZE(REG_SIZE)) u_spiregs(
		.sclk(sclk),
		.rstn(sys_rstn),
		.wr_data(rx_data[7:0]),
		.wr_addr(reg_sel),
		.wr_data_valid(reg_valid),
		.rd_data(reg_data),
		.rd_addr(reg_sel),
		.dummy_cycles(s_dummy_cycles),
		.en_qpi(en_quad),
		.wrap_length(wrap_length)
	);
	always @(*) begin
		pad_mode = (en_quad ? 2'b11 : 2'b01);
		rx_counter = 8'h1f;
		rx_counter_upd = 0;
		tx_counter_next = 8'h1f;
		tx_counter_upd_next = 0;
		decode_cmd_comb = 1'b0;
		sample_ADDR = 1'b0;
		sample_MODE = 1'b0;
		sample_CMD = 1'b0;
		sample_DATA = 1'b0;
		ctrl_data_rx_valid = 1'b0;
		ctrl_data_tx_ready_next = 1'b0;
		reg_valid = 1'b0;
		tx_data_valid_next = 1'b0;
		state_next = state;
		case (state)
			3'd0: begin
				pad_mode = (en_quad ? 2'b11 : 2'b01);
				decode_cmd_comb = 1'b1;
				ctrl_data_tx_ready_next = 1'b1;
				if (rx_data_valid) begin
					sample_CMD = 1'b1;
					if (get_addr) begin
						state_next = 3'd1;
						rx_counter_upd = 1;
						rx_counter = (en_quad ? 8'h07 : 8'h1f);
					end
					else if (get_data) begin
						state_next = 3'd4;
						rx_counter_upd = 1;
						if (enable_regs)
							rx_counter = (en_quad ? 8'h01 : 8'h07);
					end
					else begin
						state_next = 3'd3;
						tx_counter_upd_next = 1;
						tx_data_valid_next = 1'b1;
						tx_counter_next = (en_quad ? 8'h07 : 8'h1f);
						if (~enable_regs)
							ctrl_data_tx_ready_next = 1'b1;
					end
				end
				else
					state_next = 3'd0;
			end
			3'd1: begin
				pad_mode = (en_quad ? 2'b11 : 2'b01);
				ctrl_data_tx_ready_next = 1'b1;
				if (rx_data_valid) begin
					sample_ADDR = 1'b1;
					if (wait_dummy) begin
						state_next = 3'd5;
						rx_counter = s_dummy_cycles;
						rx_counter_upd = 1;
					end
					else if (send_data) begin
						state_next = 3'd3;
						tx_counter_upd_next = 1;
						tx_counter_next = (en_quad ? 8'h07 : 8'h1f);
					end
					else if (get_data) begin
						state_next = 3'd4;
						rx_counter_upd = 1;
						rx_counter = (en_quad ? 8'h07 : 8'h1f);
					end
				end
				else
					state_next = 3'd1;
			end
			3'd2: begin
				pad_mode = (en_quad ? 2'b11 : 2'b01);
				if (rx_data_valid) begin
					if (wait_dummy) begin
						state_next = 3'd5;
						rx_counter = DUMMY_CYCLES;
						rx_counter_upd = 1;
					end
					else if (get_data) begin
						state_next = 3'd4;
						rx_counter = (en_quad ? 8'h07 : 8'h1f);
						rx_counter_upd = 1;
					end
					else if (send_data) begin
						state_next = 3'd3;
						tx_counter_next = (en_quad ? 8'h07 : 8'h1f);
						tx_counter_upd_next = 1;
						tx_data_valid_next = 1'b1;
						if (~enable_regs)
							ctrl_data_tx_ready_next = 1'b1;
					end
				end
				else
					state_next = 3'd2;
			end
			3'd5: begin
				pad_mode = (en_quad ? 2'b11 : 2'b01);
				if (rx_data_valid) begin
					if (get_data) begin
						state_next = 3'd4;
						rx_counter = (en_quad ? 8'h07 : 8'h1f);
						rx_counter_upd = 1;
					end
					else begin
						if (en_quad)
							pad_mode_next = 2'b10;
						state_next = 3'd3;
						tx_counter_next = (en_quad ? 8'h07 : 8'h1f);
						tx_counter_upd_next = 1;
						tx_data_valid_next = 1'b1;
						if (~enable_regs)
							ctrl_data_tx_ready_next = 1'b1;
					end
				end
				else
					state_next = 3'd5;
			end
			3'd4: begin
				pad_mode = (en_quad ? 2'b11 : 2'b01);
				if (rx_data_valid) begin
					if (enable_regs)
						reg_valid = 1'b1;
					else
						ctrl_data_rx_valid = 1'b1;
					if (enable_cont) begin
						state_next = 3'd4;
						rx_counter = (en_quad ? 8'h07 : 8'h1f);
						rx_counter_upd = 1;
					end
					else begin
						state_next = 3'd0;
						rx_counter = (en_quad ? 8'h01 : 8'h07);
						rx_counter_upd = 1;
					end
				end
				else
					state_next = 3'd4;
			end
			3'd3: begin
				pad_mode = (en_quad ? 2'b10 : 2'b00);
				if (tx_done_reg) begin
					if (enable_cont) begin
						state_next = 3'd3;
						tx_counter_next = (en_quad ? 8'h07 : 8'h1f);
						tx_counter_upd_next = 1;
						tx_data_valid_next = 1'b1;
						if (~enable_regs)
							ctrl_data_tx_ready_next = 1'b1;
					end
					else begin
						state_next = 3'd0;
						rx_counter = (en_quad ? 8'h01 : 8'h07);
						rx_counter_upd = 1;
					end
				end
				else
					state_next = 3'd3;
			end
			3'd6: state_next = 3'd6;
		endcase
	end
	always @(posedge sclk or posedge cs)
		if (cs == 1'b1)
			state <= 3'd0;
		else
			state <= state_next;
	always @(posedge sclk or posedge cs)
		if (cs == 1'b1) begin
			addr_reg <= 'h0;
			mode_reg <= 'h0;
			data_reg <= 'h0;
			cmd_reg <= 'h0;
			tx_done_reg <= 1'b0;
			ctrl_addr_valid <= 1'b0;
			tx_counter_upd <= 1'b0;
			tx_data_valid <= 1'b0;
			ctrl_data_tx_ready <= 1'b0;
			tx_counter <= 'h0;
			tx_data <= 'h0;
		end
		else begin
			if (sample_ADDR)
				addr_reg <= rx_data;
			if (sample_MODE)
				mode_reg <= rx_data[7:0];
			if (sample_CMD)
				cmd_reg <= rx_data[7:0];
			if (sample_DATA)
				data_reg <= rx_data;
			ctrl_addr_valid <= sample_ADDR;
			tx_counter_upd <= tx_counter_upd_next;
			tx_counter <= tx_counter_next;
			tx_data_valid <= tx_data_valid_next;
			tx_done_reg <= tx_done;
			ctrl_data_tx_ready <= ctrl_data_tx_ready_next;
			tx_data <= (enable_regs ? reg_data : ctrl_data_tx);
		end
	assign ctrl_data_rx = rx_data;
	assign ctrl_addr = addr_reg;
	assign ctrl_rd_wr = send_data;
endmodule
