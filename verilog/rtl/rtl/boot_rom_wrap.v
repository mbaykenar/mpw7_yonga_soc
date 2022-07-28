`define ROM_ADDR_WIDTH      12
`define ROM_START_ADDR      32'h8000
`define ASIC                1
`define USE_ZERO_RISCY      1 

module boot_rom_wrap 
#(
    parameter ADDR_WIDTH = `ROM_ADDR_WIDTH,
    parameter DATA_WIDTH = 32
  )
(
	clk,
	rst_n,
	en_i,
	addr_i,
	rdata_o
);
	//parameter ADDR_WIDTH = 12;
	//parameter DATA_WIDTH = 32;
	input wire clk;
	input wire rst_n;
	input wire en_i;
	input wire [ADDR_WIDTH - 1:0] addr_i;
	output wire [DATA_WIDTH - 1:0] rdata_o;
	boot_code boot_code_i(
		.CLK(clk),
		.RSTN(rst_n),
		.CSN(~en_i),
		.A(addr_i[ADDR_WIDTH - 1:2]),
		.Q(rdata_o)
	);
endmodule
