module dp_ram 
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
	output reg [31:0] rdata_a_o;
	input wire we_a_i;
	input wire [3:0] be_a_i;
	input wire en_b_i;
	input wire [ADDR_WIDTH - 1:0] addr_b_i;
	input wire [31:0] wdata_b_i;
	output reg [31:0] rdata_b_o;
	input wire we_b_i;
	input wire [3:0] be_b_i;
	localparam words = 2 ** ADDR_WIDTH;
	reg [31:0] mem [0:words - 1];
	always @(posedge clk) begin
		if (en_a_i && we_a_i) begin
			if (be_a_i[0])
				mem[addr_a_i][0+:8] <= wdata_a_i[7:0];
			if (be_a_i[1])
				mem[addr_a_i][8+:8] <= wdata_a_i[15:8];
			if (be_a_i[2])
				mem[addr_a_i][16+:8] <= wdata_a_i[23:16];
			if (be_a_i[3])
				mem[addr_a_i][24+:8] <= wdata_a_i[31:24];
		end
		rdata_a_o <= mem[addr_a_i];
		if (en_b_i && we_b_i) begin
			if (be_b_i[0])
				mem[addr_b_i][0+:8] <= wdata_b_i[7:0];
			if (be_b_i[1])
				mem[addr_b_i][8+:8] <= wdata_b_i[15:8];
			if (be_b_i[2])
				mem[addr_b_i][16+:8] <= wdata_b_i[23:16];
			if (be_b_i[3])
				mem[addr_b_i][24+:8] <= wdata_b_i[31:24];
		end
		rdata_b_o <= mem[addr_b_i];
	end
endmodule
