module sp_ram 
#(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 32,
    parameter NUM_WORDS  = 256
  )
(
	clk,
	en_i,
	addr_i,
	wdata_i,
	rdata_o,
	we_i,
	be_i
);
	//parameter ADDR_WIDTH = 8;
	//parameter DATA_WIDTH = 32;
	//parameter NUM_WORDS = 256;
	input wire clk;
	input wire en_i;
	input wire [ADDR_WIDTH - 1:0] addr_i;
	input wire [DATA_WIDTH - 1:0] wdata_i;
	output reg [DATA_WIDTH - 1:0] rdata_o;
	input wire we_i;
	input wire [(DATA_WIDTH / 8) - 1:0] be_i;
	localparam words = NUM_WORDS / (DATA_WIDTH / 8);
	reg [((DATA_WIDTH / 8) * 8) - 1:0] mem [0:words - 1];
	wire [((DATA_WIDTH / 8) * 8) - 1:0] wdata;
	wire [(ADDR_WIDTH - 1) - $clog2(DATA_WIDTH / 8):0] addr;
	integer i;
	assign addr = addr_i[ADDR_WIDTH - 1:$clog2(DATA_WIDTH / 8)];
	always @(posedge clk) begin
		if (en_i && we_i)
			for (i = 0; i < (DATA_WIDTH / 8); i = i + 1)
				if (be_i[i])
					mem[addr][i * 8+:8] <= wdata[i * 8+:8];
		rdata_o <= mem[addr];
	end
	genvar w;
	generate
		for (w = 0; w < (DATA_WIDTH / 8); w = w + 1) begin : genblk1
			assign wdata[w * 8+:8] = wdata_i[((w + 1) * 8) - 1:w * 8];
		end
	endgenerate
endmodule
