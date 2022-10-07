module apb_spi_master 
#(
    parameter BUFFER_DEPTH   = 10,
    parameter APB_ADDR_WIDTH = 12  //APB slaves are 4KB by default
)
(
	HCLK,
	HRESETn,
	PADDR,
	PWDATA,
	PWRITE,
	PSEL,
	PENABLE,
	PRDATA,
	PREADY,
	PSLVERR,
	events_o,
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
	//parameter BUFFER_DEPTH = 10;
	//parameter APB_ADDR_WIDTH = 12;
	input wire HCLK;
	input wire HRESETn;
	input wire [APB_ADDR_WIDTH - 1:0] PADDR;
	input wire [31:0] PWDATA;
	input wire PWRITE;
	input wire PSEL;
	input wire PENABLE;
	output wire [31:0] PRDATA;
	output wire PREADY;
	output wire PSLVERR;
	output wire [1:0] events_o;
	output wire spi_clk;
	output wire spi_csn0;
	output wire spi_csn1;
	output wire spi_csn2;
	output wire spi_csn3;
	output wire [1:0] spi_mode;
	output wire spi_sdo0;
	output wire spi_sdo1;
	output wire spi_sdo2;
	output wire spi_sdo3;
	input wire spi_sdi0;
	input wire spi_sdi1;
	input wire spi_sdi2;
	input wire spi_sdi3;
	localparam LOG_BUFFER_DEPTH = (BUFFER_DEPTH < 1 ? 0 : (BUFFER_DEPTH < 2 ? 1 : (BUFFER_DEPTH < 4 ? 2 : (BUFFER_DEPTH < 8 ? 3 : (BUFFER_DEPTH < 16 ? 4 : (BUFFER_DEPTH < 32 ? 5 : (BUFFER_DEPTH < 64 ? 6 : (BUFFER_DEPTH < 128 ? 7 : (BUFFER_DEPTH < 256 ? 8 : (BUFFER_DEPTH < 512 ? 9 : (BUFFER_DEPTH < 1024 ? 10 : (BUFFER_DEPTH < 2048 ? 11 : (BUFFER_DEPTH < 4096 ? 12 : (BUFFER_DEPTH < 8192 ? 13 : (BUFFER_DEPTH < 16384 ? 14 : (BUFFER_DEPTH < 32768 ? 15 : (BUFFER_DEPTH < 65536 ? 16 : (BUFFER_DEPTH < 131072 ? 17 : (BUFFER_DEPTH < 262144 ? 18 : (BUFFER_DEPTH < 524288 ? 19 : (BUFFER_DEPTH < 1048576 ? 20 : (BUFFER_DEPTH < 2097152 ? 21 : (BUFFER_DEPTH < 4194304 ? 22 : (BUFFER_DEPTH < 8388608 ? 23 : (BUFFER_DEPTH < 16777216 ? 24 : 25)))))))))))))))))))))))));
	wire [7:0] spi_clk_div;
	wire spi_clk_div_valid;
	wire [31:0] spi_status;
	wire [31:0] spi_addr;
	wire [5:0] spi_addr_len;
	wire [31:0] spi_cmd;
	wire [5:0] spi_cmd_len;
	wire [15:0] spi_data_len;
	wire [15:0] spi_dummy_rd;
	wire [15:0] spi_dummy_wr;
	wire spi_swrst;
	wire spi_rd;
	wire spi_wr;
	wire spi_qrd;
	wire spi_qwr;
	wire [3:0] spi_csreg;
	wire [31:0] spi_data_tx;
	wire spi_data_tx_valid;
	wire spi_data_tx_ready;
	wire [31:0] spi_data_rx;
	wire spi_data_rx_valid;
	wire spi_data_rx_ready;
	wire [6:0] spi_ctrl_status;
	wire [31:0] spi_ctrl_data_tx;
	wire spi_ctrl_data_tx_valid;
	wire spi_ctrl_data_tx_ready;
	wire [31:0] spi_ctrl_data_rx;
	wire spi_ctrl_data_rx_valid;
	wire spi_ctrl_data_rx_ready;
	wire s_eot;
	wire [LOG_BUFFER_DEPTH:0] elements_tx;
	wire [LOG_BUFFER_DEPTH:0] elements_rx;
	reg [LOG_BUFFER_DEPTH:0] r_counter_tx;
	reg [LOG_BUFFER_DEPTH:0] r_counter_rx;
	wire [LOG_BUFFER_DEPTH:0] s_th_tx;
	wire [LOG_BUFFER_DEPTH:0] s_th_rx;
	wire [LOG_BUFFER_DEPTH:0] s_cnt_tx;
	wire [LOG_BUFFER_DEPTH:0] s_cnt_rx;
	wire s_rise_int_tx;
	wire s_rise_int_rx;
	reg s_int_tx;
	reg s_int_rx;
	wire s_int_en;
	wire s_int_cnt_en;
	wire s_int_rd_intsta;
	reg [1:0] r_state_rx;
	reg [1:0] s_state_rx_next;
	reg [1:0] r_state_tx;
	reg [1:0] s_state_tx_next;
	localparam FILL_BITS = 7 - LOG_BUFFER_DEPTH;
	assign s_rise_int_tx = elements_tx <= s_th_tx;
	assign s_rise_int_rx = elements_rx >= s_th_rx;
	assign spi_status = {{FILL_BITS {1'b0}}, elements_tx, {FILL_BITS {1'b0}}, elements_rx, 9'h000, spi_ctrl_status};
	assign events_o[0] = s_int_tx | s_int_rx;
	assign events_o[1] = s_eot;
	always @(posedge HCLK or negedge HRESETn)
		if (~HRESETn) begin
			r_state_tx <= 2'd0;
			r_state_rx <= 2'd0;
		end
		else begin
			r_state_tx <= s_state_tx_next;
			r_state_rx <= s_state_rx_next;
		end
	always @(posedge HCLK or negedge HRESETn)
		if (~HRESETn) begin
			r_counter_tx <= 'h0;
			r_counter_rx <= 'h0;
		end
		else if (s_int_cnt_en) begin
			if (spi_ctrl_data_tx_valid && spi_ctrl_data_tx_ready)
				if (r_counter_tx == (s_cnt_tx - 1))
					r_counter_tx <= 'h0;
				else
					r_counter_tx <= r_counter_tx + 1;
			if (spi_ctrl_data_rx_valid && spi_ctrl_data_rx_ready)
				if (r_counter_rx == (s_cnt_rx - 1))
					r_counter_rx <= 'h0;
				else
					r_counter_rx <= r_counter_rx + 1;
		end
		else begin
			r_counter_tx <= 'h0;
			r_counter_rx <= 'h0;
		end
	always @(*) begin
		s_state_tx_next = r_state_tx;
		s_int_tx = 1'b0;
		case (r_state_tx)
			2'd0:
				if (s_rise_int_tx && s_int_en)
					s_state_tx_next = 2'd1;
			2'd1: begin
				s_int_tx = 1'b1;
				s_state_tx_next = 2'd2;
			end
			2'd2:
				if (s_int_cnt_en) begin
					if ((spi_ctrl_data_tx_valid && spi_ctrl_data_tx_ready) && (r_counter_tx == (s_cnt_tx - 1)))
						s_state_tx_next = 2'd0;
				end
				else if (s_int_rd_intsta)
					s_state_tx_next = 2'd0;
			default: begin
				s_state_tx_next = r_state_tx;
				s_int_tx = 1'b0;
			end
		endcase
	end
	always @(*) begin
		s_state_rx_next = r_state_rx;
		s_int_rx = 1'b0;
		case (r_state_rx)
			2'd0:
				if (s_rise_int_rx && s_int_en)
					s_state_rx_next = 2'd1;
			2'd1: begin
				s_int_rx = 1'b1;
				s_state_rx_next = 2'd2;
			end
			2'd2:
				if (s_int_cnt_en) begin
					if ((spi_ctrl_data_rx_valid && spi_ctrl_data_rx_ready) && (r_counter_rx == (s_cnt_rx - 1)))
						s_state_rx_next = 2'd0;
				end
				else if (s_int_rd_intsta)
					s_state_rx_next = 2'd0;
		endcase
	end
	spi_master_apb_if #(
		.BUFFER_DEPTH(BUFFER_DEPTH),
		.APB_ADDR_WIDTH(APB_ADDR_WIDTH)
	) u_axiregs(
		.HCLK(HCLK),
		.HRESETn(HRESETn),
		.PADDR(PADDR),
		.PWDATA(PWDATA),
		.PWRITE(PWRITE),
		.PSEL(PSEL),
		.PENABLE(PENABLE),
		.PRDATA(PRDATA),
		.PREADY(PREADY),
		.PSLVERR(PSLVERR),
		.spi_clk_div(spi_clk_div),
		.spi_clk_div_valid(spi_clk_div_valid),
		.spi_status(spi_status),
		.spi_addr(spi_addr),
		.spi_addr_len(spi_addr_len),
		.spi_cmd(spi_cmd),
		.spi_cmd_len(spi_cmd_len),
		.spi_data_len(spi_data_len),
		.spi_dummy_rd(spi_dummy_rd),
		.spi_dummy_wr(spi_dummy_wr),
		.spi_swrst(spi_swrst),
		.spi_rd(spi_rd),
		.spi_wr(spi_wr),
		.spi_qrd(spi_qrd),
		.spi_qwr(spi_qwr),
		.spi_csreg(spi_csreg),
		.spi_int_th_rx(s_th_rx),
		.spi_int_th_tx(s_th_tx),
		.spi_int_cnt_rx(s_cnt_rx),
		.spi_int_cnt_tx(s_cnt_tx),
		.spi_int_en(s_int_en),
		.spi_int_cnt_en(s_int_cnt_en),
		.spi_int_rd_sta(s_int_rd_intsta),
		.spi_data_tx(spi_data_tx),
		.spi_data_tx_valid(spi_data_tx_valid),
		.spi_data_tx_ready(spi_data_tx_ready),
		.spi_data_rx(spi_data_rx),
		.spi_data_rx_valid(spi_data_rx_valid),
		.spi_data_rx_ready(spi_data_rx_ready)
	);
	spi_master_fifo #(
		.DATA_WIDTH(32),
		.BUFFER_DEPTH(BUFFER_DEPTH)
	) u_txfifo(
		.clk_i(HCLK),
		.rst_ni(HRESETn),
		.clr_i(spi_swrst),
		.elements_o(elements_tx),
		.data_o(spi_ctrl_data_tx),
		.valid_o(spi_ctrl_data_tx_valid),
		.ready_i(spi_ctrl_data_tx_ready),
		.valid_i(spi_data_tx_valid),
		.data_i(spi_data_tx),
		.ready_o(spi_data_tx_ready)
	);
	spi_master_fifo #(
		.DATA_WIDTH(32),
		.BUFFER_DEPTH(BUFFER_DEPTH)
	) u_rxfifo(
		.clk_i(HCLK),
		.rst_ni(HRESETn),
		.clr_i(spi_swrst),
		.elements_o(elements_rx),
		.data_o(spi_data_rx),
		.valid_o(spi_data_rx_valid),
		.ready_i(spi_data_rx_ready),
		.valid_i(spi_ctrl_data_rx_valid),
		.data_i(spi_ctrl_data_rx),
		.ready_o(spi_ctrl_data_rx_ready)
	);
	spi_master_controller u_spictrl(
		.clk(HCLK),
		.rstn(HRESETn),
		.eot(s_eot),
		.spi_clk_div(spi_clk_div),
		.spi_clk_div_valid(spi_clk_div_valid),
		.spi_status(spi_ctrl_status),
		.spi_addr(spi_addr),
		.spi_addr_len(spi_addr_len),
		.spi_cmd(spi_cmd),
		.spi_cmd_len(spi_cmd_len),
		.spi_data_len(spi_data_len),
		.spi_dummy_rd(spi_dummy_rd),
		.spi_dummy_wr(spi_dummy_wr),
		.spi_swrst(spi_swrst),
		.spi_rd(spi_rd),
		.spi_wr(spi_wr),
		.spi_qrd(spi_qrd),
		.spi_qwr(spi_qwr),
		.spi_csreg(spi_csreg),
		.spi_ctrl_data_tx(spi_ctrl_data_tx),
		.spi_ctrl_data_tx_valid(spi_ctrl_data_tx_valid),
		.spi_ctrl_data_tx_ready(spi_ctrl_data_tx_ready),
		.spi_ctrl_data_rx(spi_ctrl_data_rx),
		.spi_ctrl_data_rx_valid(spi_ctrl_data_rx_valid),
		.spi_ctrl_data_rx_ready(spi_ctrl_data_rx_ready),
		.spi_clk(spi_clk),
		.spi_csn0(spi_csn0),
		.spi_csn1(spi_csn1),
		.spi_csn2(spi_csn2),
		.spi_csn3(spi_csn3),
		.spi_mode(spi_mode),
		.spi_sdo0(spi_sdo0),
		.spi_sdo1(spi_sdo1),
		.spi_sdo2(spi_sdo2),
		.spi_sdo3(spi_sdo3),
		.spi_sdi0(spi_sdi0),
		.spi_sdi1(spi_sdi1),
		.spi_sdi2(spi_sdi2),
		.spi_sdi3(spi_sdi3)
	);
endmodule
