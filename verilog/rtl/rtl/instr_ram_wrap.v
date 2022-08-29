`define USE_POWER_PINS
module instr_ram_wrap 
#(
    parameter RAM_SIZE   = 32768,                // in bytes
    parameter ADDR_WIDTH = $clog2(RAM_SIZE) + 1, // one bit more than necessary, for the boot rom
    parameter DATA_WIDTH = 32
  )
(
`ifdef USE_POWER_PINS
	vccd1,	// User area 1 1.8V supply
	vssd1,	// User area 1 digital ground
`endif
	clk,
	rst_n,
	en_i,
	addr_i,
	wdata_i,
	rdata_o,
	we_i,
	be_i,
	bypass_en_i
);
	//parameter RAM_SIZE = 32768;
	//parameter ADDR_WIDTH = $clog2(RAM_SIZE) + 1;
	//parameter DATA_WIDTH = 32;
`ifdef USE_POWER_PINS
inout wire vccd1;
inout wire vssd1;
`endif
	input wire clk;
	input wire rst_n;
	input wire en_i;
	input wire [ADDR_WIDTH - 1:0] addr_i;
	input wire [DATA_WIDTH - 1:0] wdata_i;
	output wire [DATA_WIDTH - 1:0] rdata_o;
	input wire we_i;
	input wire [(DATA_WIDTH / 8) - 1:0] be_i;
	input wire bypass_en_i;
	wire is_boot;
	reg is_boot_q;
	wire [DATA_WIDTH - 1:0] rdata_boot;
	wire [DATA_WIDTH - 1:0] rdata_ram;
	assign is_boot = addr_i[ADDR_WIDTH - 1] == 1'b1;
	sp_ram_wrap #(
		.RAM_SIZE(RAM_SIZE),
		.DATA_WIDTH(DATA_WIDTH)
	) sp_ram_wrap_i(
`ifdef USE_POWER_PINS
	.vccd1(vccd1),	// User area 1 1.8V supply
	.vssd1(vssd1),	// User area 1 digital ground
`endif
		.clk(clk),
		.rstn_i(rst_n),
		.en_i(en_i & ~is_boot),
		.addr_i(addr_i[ADDR_WIDTH - 2:0]),
		.wdata_i(wdata_i),
		.rdata_o(rdata_ram),
		.we_i(we_i),
		.be_i(be_i),
		.bypass_en_i(bypass_en_i)
	);
	boot_rom_wrap #(.DATA_WIDTH(DATA_WIDTH)) boot_rom_wrap_i(
		.clk(clk),
		.rst_n(rst_n),
		.en_i(en_i & is_boot),
		.addr_i(addr_i[11:0]),
		.rdata_o(rdata_boot)
	);
	assign rdata_o = (is_boot_q == 1'b1 ? rdata_boot : rdata_ram);
	always @(posedge clk or negedge rst_n)
		if (rst_n == 1'b0)
			is_boot_q <= 1'b0;
		else
			is_boot_q <= is_boot;
endmodule
