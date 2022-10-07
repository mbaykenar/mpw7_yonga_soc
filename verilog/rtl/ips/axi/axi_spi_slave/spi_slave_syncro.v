module spi_slave_syncro 
#(
    parameter AXI_ADDR_WIDTH = 32
    )
(
	sys_clk,
	rstn,
	cs,
	address,
	address_valid,
	rd_wr,
	cs_sync,
	address_sync,
	address_valid_sync,
	rd_wr_sync
);
	//parameter AXI_ADDR_WIDTH = 32;
	input wire sys_clk;
	input wire rstn;
	input wire cs;
	input wire [AXI_ADDR_WIDTH - 1:0] address;
	input wire address_valid;
	input wire rd_wr;
	output wire cs_sync;
	output wire [AXI_ADDR_WIDTH - 1:0] address_sync;
	output wire address_valid_sync;
	output wire rd_wr_sync;
	reg [1:0] cs_reg;
	reg [2:0] valid_reg;
	reg [1:0] rdwr_reg;
	assign cs_sync = cs_reg[1];
	assign address_valid_sync = ~valid_reg[2] & valid_reg[1];
	assign address_sync = address;
	assign rd_wr_sync = rdwr_reg[1];
	always @(posedge sys_clk or negedge rstn)
		if (rstn == 1'b0) begin
			cs_reg <= 2'b11;
			valid_reg <= 3'b000;
			rdwr_reg <= 2'b00;
		end
		else begin
			cs_reg <= {cs_reg[0], cs};
			valid_reg <= {valid_reg[1:0], address_valid};
			rdwr_reg <= {rdwr_reg[0], rd_wr};
		end
endmodule
