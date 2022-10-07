module apb_uart_sv 
#(
    parameter APB_ADDR_WIDTH = 12  //APB slaves are 4KB by default
)
(
	CLK,
	RSTN,
	PADDR,
	PWDATA,
	PWRITE,
	PSEL,
	PENABLE,
	PRDATA,
	PREADY,
	PSLVERR,
	rx_i,
	tx_o,
	event_o
);
	//parameter APB_ADDR_WIDTH = 12;
	input wire CLK;
	input wire RSTN;
	input wire [APB_ADDR_WIDTH - 1:0] PADDR;
	input wire [31:0] PWDATA;
	input wire PWRITE;
	input wire PSEL;
	input wire PENABLE;
	output reg [31:0] PRDATA;
	output wire PREADY;
	output wire PSLVERR;
	input wire rx_i;
	output wire tx_o;
	output wire event_o;
	parameter RBR = 3'h0;
	parameter THR = 3'h0;
	parameter DLL = 3'h0;
	parameter IER = 3'h1;
	parameter DLM = 3'h1;
	parameter IIR = 3'h2;
	parameter FCR = 3'h2;
	parameter LCR = 3'h3;
	parameter MCR = 3'h4;
	parameter LSR = 3'h5;
	parameter MSR = 3'h6;
	parameter SCR = 3'h7;
	parameter TX_FIFO_DEPTH = 16;
	parameter RX_FIFO_DEPTH = 16;
	wire [2:0] register_adr;
	reg [79:0] regs_q;
	reg [79:0] regs_n;
	reg [1:0] trigger_level_n;
	reg [1:0] trigger_level_q;
	wire [7:0] rx_data;
	wire parity_error;
	wire [3:0] IIR_o;
	reg [3:0] clr_int;
	wire tx_ready;
	reg apb_rx_ready;
	wire rx_valid;
	reg tx_fifo_clr_n;
	reg tx_fifo_clr_q;
	reg rx_fifo_clr_n;
	reg rx_fifo_clr_q;
	reg fifo_tx_valid;
	wire tx_valid;
	wire fifo_rx_valid;
	reg fifo_rx_ready;
	wire rx_ready;
	reg [7:0] fifo_tx_data;
	wire [8:0] fifo_rx_data;
	wire [7:0] tx_data;
	wire [$clog2(TX_FIFO_DEPTH):0] tx_elements;
	wire [$clog2(RX_FIFO_DEPTH):0] rx_elements;
	uart_rx uart_rx_i(
		.clk_i(CLK),
		.rstn_i(RSTN),
		.rx_i(rx_i),
		.cfg_en_i(1'b1),
		.cfg_div_i({regs_q[(DLM + 'd8) * 8+:8], regs_q[(DLL + 'd8) * 8+:8]}),
		.cfg_parity_en_i(regs_q[(LCR * 8) + 3]),
		.cfg_bits_i(regs_q[(LCR * 8) + 1-:2]),
		.busy_o(),
		.err_o(parity_error),
		.err_clr_i(1'b1),
		.rx_data_o(rx_data),
		.rx_valid_o(rx_valid),
		.rx_ready_i(rx_ready)
	);
	uart_tx uart_tx_i(
		.clk_i(CLK),
		.rstn_i(RSTN),
		.tx_o(tx_o),
		.busy_o(),
		.cfg_en_i(1'b1),
		.cfg_div_i({regs_q[(DLM + 'd8) * 8+:8], regs_q[(DLL + 'd8) * 8+:8]}),
		.cfg_parity_en_i(regs_q[(LCR * 8) + 3]),
		.cfg_bits_i(regs_q[(LCR * 8) + 1-:2]),
		.cfg_stop_bits_i(regs_q[(LCR * 8) + 2]),
		.tx_data_i(tx_data),
		.tx_valid_i(tx_valid),
		.tx_ready_o(tx_ready)
	);
	io_generic_fifo #(
		.DATA_WIDTH(9),
		.BUFFER_DEPTH(RX_FIFO_DEPTH)
	) uart_rx_fifo_i(
		.clk_i(CLK),
		.rstn_i(RSTN),
		.clr_i(rx_fifo_clr_q),
		.elements_o(rx_elements),
		.data_o(fifo_rx_data),
		.valid_o(fifo_rx_valid),
		.ready_i(fifo_rx_ready),
		.valid_i(rx_valid),
		.data_i({parity_error, rx_data}),
		.ready_o(rx_ready)
	);
	io_generic_fifo #(
		.DATA_WIDTH(8),
		.BUFFER_DEPTH(TX_FIFO_DEPTH)
	) uart_tx_fifo_i(
		.clk_i(CLK),
		.rstn_i(RSTN),
		.clr_i(tx_fifo_clr_q),
		.elements_o(tx_elements),
		.data_o(tx_data),
		.valid_o(tx_valid),
		.ready_i(tx_ready),
		.valid_i(fifo_tx_valid),
		.data_i(fifo_tx_data),
		.ready_o()
	);
	uart_interrupt #(
		.TX_FIFO_DEPTH(TX_FIFO_DEPTH),
		.RX_FIFO_DEPTH(RX_FIFO_DEPTH)
	) uart_interrupt_i(
		.clk_i(CLK),
		.rstn_i(RSTN),
		.IER_i(regs_q[(IER * 8) + 2-:3]),
		.RDA_i(regs_n[(LSR * 8) + 5]),
		.CTI_i(1'b0),
		.error_i(regs_n[(LSR * 8) + 2]),
		.rx_elements_i(rx_elements),
		.tx_elements_i(tx_elements),
		.trigger_level_i(trigger_level_q),
		.clr_int_i(clr_int),
		.interrupt_o(event_o),
		.IIR_o(IIR_o)
	);
	always @(*) begin
		regs_n = regs_q;
		trigger_level_n = trigger_level_q;
		fifo_tx_valid = 1'b0;
		tx_fifo_clr_n = 1'b0;
		rx_fifo_clr_n = 1'b0;
		regs_n[LSR * 8] = fifo_rx_valid;
		regs_n[(LSR * 8) + 2] = fifo_rx_data[8];
		regs_n[(LSR * 8) + 5] = ~(|tx_elements);
		regs_n[(LSR * 8) + 6] = tx_ready & ~(|tx_elements);
		if ((PSEL && PENABLE) && PWRITE)
			case (register_adr)
				THR:
					if (regs_q[(LCR * 8) + 7])
						regs_n[(DLL + 'd8) * 8+:8] = PWDATA[7:0];
					else begin
						fifo_tx_data = PWDATA[7:0];
						fifo_tx_valid = 1'b1;
					end
				IER:
					if (regs_q[(LCR * 8) + 7])
						regs_n[(DLM + 'd8) * 8+:8] = PWDATA[7:0];
					else
						regs_n[IER * 8+:8] = PWDATA[7:0];
				LCR: regs_n[LCR * 8+:8] = PWDATA[7:0];
				FCR: begin
					rx_fifo_clr_n = PWDATA[1];
					tx_fifo_clr_n = PWDATA[2];
					trigger_level_n = PWDATA[7:6];
				end
				default:
					;
			endcase
	end
	always @(*) begin
		PRDATA = 'b0;
		apb_rx_ready = 1'b0;
		fifo_rx_ready = 1'b0;
		clr_int = 4'b0000;
		if ((PSEL && PENABLE) && !PWRITE)
			case (register_adr)
				RBR:
					if (regs_q[(LCR * 8) + 7])
						PRDATA = {24'b000000000000000000000000, regs_q[(DLL + 'd8) * 8+:8]};
					else begin
						fifo_rx_ready = 1'b1;
						PRDATA = {24'b000000000000000000000000, fifo_rx_data[7:0]};
						clr_int = 4'b1000;
					end
				LSR: begin
					PRDATA = {24'b000000000000000000000000, regs_q[LSR * 8+:8]};
					clr_int = 4'b1100;
				end
				LCR: PRDATA = {24'b000000000000000000000000, regs_q[LCR * 8+:8]};
				IER:
					if (regs_q[(LCR * 8) + 7])
						PRDATA = {24'b000000000000000000000000, regs_q[(DLM + 'd8) * 8+:8]};
					else
						PRDATA = {24'b000000000000000000000000, regs_q[IER * 8+:8]};
				IIR: begin
					PRDATA = {28'b0000000000000000000000001100, IIR_o};
					clr_int = 4'b0100;
				end
				default:
					;
			endcase
	end
	always @(posedge CLK or negedge RSTN)
		if (~RSTN) begin
			regs_q[IER * 8+:8] <= 8'h00;
			regs_q[IIR * 8+:8] <= 8'h01;
			regs_q[LCR * 8+:8] <= 8'h00;
			regs_q[MCR * 8+:8] <= 8'h00;
			regs_q[LSR * 8+:8] <= 8'h60;
			regs_q[MSR * 8+:8] <= 8'h00;
			regs_q[SCR * 8+:8] <= 8'h00;
			regs_q[(DLM + 'd8) * 8+:8] <= 8'h00;
			regs_q[(DLL + 'd8) * 8+:8] <= 8'h00;
			trigger_level_q <= 2'b00;
			tx_fifo_clr_q <= 1'b0;
			rx_fifo_clr_q <= 1'b0;
		end
		else begin
			regs_q <= regs_n;
			trigger_level_q <= trigger_level_n;
			tx_fifo_clr_q <= tx_fifo_clr_n;
			rx_fifo_clr_q <= rx_fifo_clr_n;
		end
	assign register_adr = {PADDR[2:0]};
	assign PREADY = 1'b1;
	assign PSLVERR = 1'b0;
endmodule
