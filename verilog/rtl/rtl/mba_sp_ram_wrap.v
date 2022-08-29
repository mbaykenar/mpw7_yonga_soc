`define USE_POWER_PINS

module mba_sp_ram_wrap 
#(
    parameter RAM_SIZE   = 32768,              // in bytes
    parameter ADDR_WIDTH = $clog2(RAM_SIZE),
    parameter DATA_WIDTH = 32
  )
(
// `ifdef USE_POWER_PINS
// 	vccd1,	// User area 1 1.8V supply
// 	vssd1,	// User area 1 digital ground
// `endif
	clk,
	rstn_i,
	en_i,
	addr_i,
	wdata_i,
	rdata_o,
	we_i,
	be_i,
	bypass_en_i,
	// MBA START
	mba_mem_csb0_o		,
	mba_mem_web0_o		,
	mba_mem_wmask0_o	,
	mba_mem_addr0_o		,
	mba_mem_din0_o		,
	mba_mem_dout0_i		,
	mba_mem_csb1_o		,
	mba_mem_addr1_o		
	// MBA END	
);
	//parameter RAM_SIZE = 32768;
	//parameter ADDR_WIDTH = $clog2(RAM_SIZE);
	//parameter DATA_WIDTH = 32;
// `ifdef USE_POWER_PINS
// inout wire vccd1;
// inout wire vssd1;
// `endif
	// MBA START
output wire 		mba_mem_csb0_o;
output wire 		mba_mem_web0_o;
output wire [3:0]	mba_mem_wmask0_o;
output wire [31:0]	mba_mem_addr0_o;
output wire [31:0] 	mba_mem_din0_o;
input  wire [31:0] 	mba_mem_dout0_i;
output wire 		mba_mem_csb1_o;
output wire [31:0] 	mba_mem_addr1_o;
// MBA END
	input wire clk;
	input wire rstn_i;
	input wire en_i;
	input wire [ADDR_WIDTH - 1:0] addr_i;
	input wire [DATA_WIDTH - 1:0] wdata_i;
	output wire [DATA_WIDTH - 1:0] rdata_o;
	input wire we_i;
	input wire [(DATA_WIDTH / 8) - 1:0] be_i;
	input wire bypass_en_i;
	wire [31:0] ram_out_int;
	assign rdata_o = ram_out_int;

	// MBA START
//	sky130_sram_2kbyte_1rw1r_32x512_8 open_ram_2k(
//	`ifdef USE_POWER_PINS
//		.vccd1(vccd1),
//		.vssd1(vssd1),
//	`endif
//		.clk0(clk),
//		.csb0(1'b0),
//		.web0(~(we_i & ~bypass_en_i)),
//		.wmask0(be_i),
//		.addr0(addr_i[10:2]),
//		.din0(wdata_i),
//		.dout0(ram_out_int),
//		.clk1(1'b0),
//		.csb1(1'b1),
//		.addr1(9'b000000000),
//		.dout1()
//	);

assign mba_mem_csb0_o 	= 1'b0;
assign mba_mem_web0_o	= ~(we_i & ~bypass_en_i);	
assign mba_mem_wmask0_o	= be_i;
assign mba_mem_addr0_o  = addr_i;
assign mba_mem_din0_o   = wdata_i;
assign ram_out_int 		= mba_mem_dout0_i;
assign mba_mem_csb1_o	= 1'b1;
assign mba_mem_addr1_o	= addr_i;

	// MBA END

endmodule