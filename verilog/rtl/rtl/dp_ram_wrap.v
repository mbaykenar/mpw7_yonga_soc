module dp_ram_wrap 
#(
    parameter ADDR_WIDTH = 8
  )
(
	clk,
	en_a_i,
	addr_a_i,
	wdata_a_i,
	rdata_a_o,
	we_a_i,
	be_a_i,
	en_b_i,
	addr_b_i,
	wdata_b_i,
	rdata_b_o,
	we_b_i,
	be_b_i
);
	//parameter ADDR_WIDTH = 8;
	input wire clk;
	input wire en_a_i;
	input wire [ADDR_WIDTH - 1:0] addr_a_i;
	input wire [31:0] wdata_a_i;
	output wire [31:0] rdata_a_o;
	input wire we_a_i;
	input wire [3:0] be_a_i;
	input wire en_b_i;
	input wire [ADDR_WIDTH - 1:0] addr_b_i;
	input wire [31:0] wdata_b_i;
	output wire [31:0] rdata_b_o;
	input wire we_b_i;
	input wire [3:0] be_b_i;
	dp_ram #(.ADDR_WIDTH(ADDR_WIDTH)) dp_ram_i(
		.clk(clk),
		.en_a_i(en_a_i),
		.addr_a_i(addr_a_i),
		.wdata_a_i(wdata_a_i),
		.rdata_a_o(rdata_a_o),
		.we_a_i(we_a_i),
		.be_a_i(be_a_i),
		.en_b_i(en_b_i),
		.addr_b_i(addr_b_i),
		.wdata_b_i(wdata_b_i),
		.rdata_b_o(rdata_b_o),
		.we_b_i(we_b_i),
		.be_b_i(be_b_i)
	);
endmodule
