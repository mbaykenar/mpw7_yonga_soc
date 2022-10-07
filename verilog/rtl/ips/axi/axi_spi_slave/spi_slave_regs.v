module spi_slave_regs 
#(
  parameter REG_SIZE = 8
)
(
	sclk,
	rstn,
	wr_data,
	wr_addr,
	wr_data_valid,
	rd_data,
	rd_addr,
	dummy_cycles,
	en_qpi,
	wrap_length
);
	//parameter REG_SIZE = 8;
	input wire sclk;
	input wire rstn;
	input wire [REG_SIZE - 1:0] wr_data;
	input wire [1:0] wr_addr;
	input wire wr_data_valid;
	output reg [REG_SIZE - 1:0] rd_data;
	input wire [1:0] rd_addr;
	output wire [7:0] dummy_cycles;
	output wire en_qpi;
	output wire [15:0] wrap_length;
	reg [REG_SIZE - 1:0] reg0;
	reg [REG_SIZE - 1:0] reg1;
	reg [REG_SIZE - 1:0] reg2;
	reg [REG_SIZE - 1:0] reg3;
	assign en_qpi = reg0[0];
	assign dummy_cycles = reg1;
	assign wrap_length = {reg3, reg2};
	always @(*)
		case (rd_addr)
			2'b00: rd_data = reg0;
			2'b01: rd_data = reg1;
			2'b10: rd_data = reg2;
			2'b11: rd_data = reg3;
		endcase
	always @(posedge sclk or negedge rstn)
		if (rstn == 0) begin
			reg0 <= 'h0;
			reg1 <= 'd32;
			reg2 <= 'h0;
			reg3 <= 'h0;
		end
		else if (wr_data_valid)
			case (wr_addr)
				2'b00: reg0 <= wr_data;
				2'b01: reg1 <= wr_data;
				2'b10: reg2 <= wr_data;
				2'b11: reg3 <= wr_data;
			endcase
endmodule
