`define log2(VALUE) ((VALUE) < ( 1 ) ? 0 : (VALUE) < ( 2 ) ? 1 : (VALUE) < ( 4 ) ? 2 : (VALUE) < ( 8 ) ? 3 : (VALUE) < ( 16 )  ? 4 : (VALUE) < ( 32 )  ? 5 : (VALUE) < ( 64 )  ? 6 : (VALUE) < ( 128 ) ? 7 : (VALUE) < ( 256 ) ? 8 : (VALUE) < ( 512 ) ? 9 : (VALUE) < ( 1024 ) ? 10 : (VALUE) < ( 2048 ) ? 11 : (VALUE) < ( 4096 ) ? 12 : (VALUE) < ( 8192 ) ? 13 : (VALUE) < ( 16384 ) ? 14 : (VALUE) < ( 32768 ) ? 15 : (VALUE) < ( 65536 ) ? 16 : (VALUE) < ( 131072 ) ? 17 : (VALUE) < ( 262144 ) ? 18 : (VALUE) < ( 524288 ) ? 19 : (VALUE) < ( 1048576 ) ? 20 : (VALUE) < ( 1048576 * 2 ) ? 21 : (VALUE) < ( 1048576 * 4 ) ? 22 : (VALUE) < ( 1048576 * 8 ) ? 23 : (VALUE) < ( 1048576 * 16 ) ? 24 : 25)

`define REG_STATUS 4'b0000 // BASEREG + 0x00
`define REG_CLKDIV 4'b0001 // BASEREG + 0x04
`define REG_SPICMD 4'b0010 // BASEREG + 0x08
`define REG_SPIADR 4'b0011 // BASEREG + 0x0C
`define REG_SPILEN 4'b0100 // BASEREG + 0x10
`define REG_SPIDUM 4'b0101 // BASEREG + 0x14
`define REG_TXFIFO 4'b0110 // BASEREG + 0x18
`define REG_RXFIFO 4'b1000 // BASEREG + 0x20
`define REG_INTCFG 4'b1001 // BASEREG + 0x24
`define REG_INTSTA 4'b1010 // BASEREG + 0x28

module spi_master_apb_if 
#(
    parameter BUFFER_DEPTH   = 10,
    parameter APB_ADDR_WIDTH = 12,  //APB slaves are 4KB by default
    parameter LOG_BUFFER_DEPTH = `log2(BUFFER_DEPTH)
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
	spi_clk_div,
	spi_clk_div_valid,
	spi_status,
	spi_addr,
	spi_addr_len,
	spi_cmd,
	spi_cmd_len,
	spi_csreg,
	spi_data_len,
	spi_dummy_rd,
	spi_dummy_wr,
	spi_int_th_tx,
	spi_int_th_rx,
	spi_int_cnt_tx,
	spi_int_cnt_rx,
	spi_int_en,
	spi_int_cnt_en,
	spi_int_rd_sta,
	spi_swrst,
	spi_rd,
	spi_wr,
	spi_qrd,
	spi_qwr,
	spi_data_tx,
	spi_data_tx_valid,
	spi_data_tx_ready,
	spi_data_rx,
	spi_data_rx_valid,
	spi_data_rx_ready
);
	//parameter BUFFER_DEPTH = 10;
	//parameter APB_ADDR_WIDTH = 12;
	//parameter LOG_BUFFER_DEPTH = (BUFFER_DEPTH < 1 ? 0 : (BUFFER_DEPTH < 2 ? 1 : (BUFFER_DEPTH < 4 ? 2 : (BUFFER_DEPTH < 8 ? 3 : (BUFFER_DEPTH < 16 ? 4 : (BUFFER_DEPTH < 32 ? 5 : (BUFFER_DEPTH < 64 ? 6 : (BUFFER_DEPTH < 128 ? 7 : (BUFFER_DEPTH < 256 ? 8 : (BUFFER_DEPTH < 512 ? 9 : (BUFFER_DEPTH < 1024 ? 10 : (BUFFER_DEPTH < 2048 ? 11 : (BUFFER_DEPTH < 4096 ? 12 : (BUFFER_DEPTH < 8192 ? 13 : (BUFFER_DEPTH < 16384 ? 14 : (BUFFER_DEPTH < 32768 ? 15 : (BUFFER_DEPTH < 65536 ? 16 : (BUFFER_DEPTH < 131072 ? 17 : (BUFFER_DEPTH < 262144 ? 18 : (BUFFER_DEPTH < 524288 ? 19 : (BUFFER_DEPTH < 1048576 ? 20 : (BUFFER_DEPTH < 2097152 ? 21 : (BUFFER_DEPTH < 4194304 ? 22 : (BUFFER_DEPTH < 8388608 ? 23 : (BUFFER_DEPTH < 16777216 ? 24 : 25)))))))))))))))))))))))));
	input wire HCLK;
	input wire HRESETn;
	input wire [APB_ADDR_WIDTH - 1:0] PADDR;
	input wire [31:0] PWDATA;
	input wire PWRITE;
	input wire PSEL;
	input wire PENABLE;
	output reg [31:0] PRDATA;
	output wire PREADY;
	output wire PSLVERR;
	output reg [7:0] spi_clk_div;
	output reg spi_clk_div_valid;
	input wire [31:0] spi_status;
	output reg [31:0] spi_addr;
	output reg [5:0] spi_addr_len;
	output reg [31:0] spi_cmd;
	output reg [5:0] spi_cmd_len;
	output reg [3:0] spi_csreg;
	output reg [15:0] spi_data_len;
	output reg [15:0] spi_dummy_rd;
	output reg [15:0] spi_dummy_wr;
	output reg [LOG_BUFFER_DEPTH:0] spi_int_th_tx;
	output reg [LOG_BUFFER_DEPTH:0] spi_int_th_rx;
	output reg [LOG_BUFFER_DEPTH:0] spi_int_cnt_tx;
	output reg [LOG_BUFFER_DEPTH:0] spi_int_cnt_rx;
	output reg spi_int_en;
	output reg spi_int_cnt_en;
	output wire spi_int_rd_sta;
	output reg spi_swrst;
	output reg spi_rd;
	output reg spi_wr;
	output reg spi_qrd;
	output reg spi_qwr;
	output wire [31:0] spi_data_tx;
	output wire spi_data_tx_valid;
	input wire spi_data_tx_ready;
	input wire [31:0] spi_data_rx;
	input wire spi_data_rx_valid;
	output wire spi_data_rx_ready;
	wire [3:0] write_address;
	wire [3:0] read_address;
	assign write_address = PADDR[5:2];
	assign read_address = PADDR[5:2];
	assign PSLVERR = 1'b0;
	assign PREADY = 1'b1;
	assign spi_int_rd_sta = ((PSEL & PENABLE) & ~PWRITE) & (read_address == 4'b1010);
	always @(posedge HCLK or negedge HRESETn)
		if (HRESETn == 1'b0) begin
			spi_swrst <= 1'b0;
			spi_rd <= 1'b0;
			spi_wr <= 1'b0;
			spi_qrd <= 1'b0;
			spi_qwr <= 1'b0;
			spi_clk_div_valid <= 1'b0;
			spi_clk_div <= 1'sb0;
			spi_cmd <= 1'sb0;
			spi_addr <= 1'sb0;
			spi_cmd_len <= 1'sb0;
			spi_addr_len <= 1'sb0;
			spi_data_len <= 1'sb0;
			spi_dummy_rd <= 1'sb0;
			spi_dummy_wr <= 1'sb0;
			spi_csreg <= 1'sb0;
			spi_int_th_tx <= 1'sb0;
			spi_int_th_rx <= 1'sb0;
			spi_int_cnt_tx <= 1'sb0;
			spi_int_cnt_rx <= 1'sb0;
			spi_int_cnt_en <= 1'b0;
			spi_int_en <= 1'b0;
		end
		else if ((PSEL && PENABLE) && PWRITE) begin
			spi_swrst <= 1'b0;
			spi_rd <= 1'b0;
			spi_wr <= 1'b0;
			spi_qrd <= 1'b0;
			spi_qwr <= 1'b0;
			spi_clk_div_valid <= 1'b0;
			case (write_address)
				4'b0000: begin
					spi_rd <= PWDATA[0];
					spi_wr <= PWDATA[1];
					spi_qrd <= PWDATA[2];
					spi_qwr <= PWDATA[3];
					spi_swrst <= PWDATA[4];
					spi_csreg <= PWDATA[11:8];
				end
				4'b0001: begin
					spi_clk_div <= PWDATA[7:0];
					spi_clk_div_valid <= 1'b1;
				end
				4'b0010: spi_cmd <= PWDATA;
				4'b0011: spi_addr <= PWDATA;
				4'b0100: begin
					spi_cmd_len <= PWDATA[5:0];
					spi_addr_len <= PWDATA[13:8];
					spi_data_len[7:0] <= PWDATA[23:16];
					spi_data_len[15:8] <= PWDATA[31:24];
				end
				4'b0101: begin
					spi_dummy_rd[7:0] <= PWDATA[7:0];
					spi_dummy_rd[15:8] <= PWDATA[15:8];
					spi_dummy_wr[7:0] <= PWDATA[23:16];
					spi_dummy_wr[15:8] <= PWDATA[31:24];
				end
				4'b1001: begin
					spi_int_th_tx <= PWDATA[LOG_BUFFER_DEPTH:0];
					spi_int_th_rx <= PWDATA[8 + LOG_BUFFER_DEPTH:8];
					spi_int_cnt_tx <= PWDATA[16 + LOG_BUFFER_DEPTH:16];
					spi_int_cnt_rx <= PWDATA[24 + LOG_BUFFER_DEPTH:24];
					spi_int_cnt_en <= PWDATA[30];
					spi_int_en <= PWDATA[31];
				end
			endcase
		end
		else begin
			spi_swrst <= 1'b0;
			spi_rd <= 1'b0;
			spi_wr <= 1'b0;
			spi_qrd <= 1'b0;
			spi_qwr <= 1'b0;
			spi_clk_div_valid <= 1'b0;
		end
	always @(*)
		case (read_address)
			4'b0000: PRDATA = spi_status;
			4'b0001: PRDATA = {24'h000000, spi_clk_div};
			4'b0010: PRDATA = spi_cmd;
			4'b0011: PRDATA = spi_addr;
			4'b0100: PRDATA = {spi_data_len, 2'b00, spi_addr_len, 2'b00, spi_cmd_len};
			4'b0101: PRDATA = {spi_dummy_wr, spi_dummy_rd};
			4'b1000: PRDATA = spi_data_rx;
			4'b1001: begin
				PRDATA = 1'sb0;
				PRDATA[LOG_BUFFER_DEPTH:0] = spi_int_th_tx;
				PRDATA[8 + LOG_BUFFER_DEPTH:8] = spi_int_th_rx;
				PRDATA[16 + LOG_BUFFER_DEPTH:16] = spi_int_cnt_tx;
				PRDATA[24 + LOG_BUFFER_DEPTH:24] = spi_int_cnt_rx;
				PRDATA[30] = spi_int_cnt_en;
				PRDATA[31] = spi_int_en;
			end
			default: PRDATA = 1'sb0;
		endcase
	assign spi_data_tx = PWDATA;
	assign spi_data_tx_valid = ((PSEL & PENABLE) & PWRITE) & (write_address == 4'b0110);
	assign spi_data_rx_ready = ((PSEL & PENABLE) & ~PWRITE) & (read_address == 4'b1000);
endmodule
