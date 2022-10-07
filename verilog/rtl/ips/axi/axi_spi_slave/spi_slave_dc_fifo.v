module spi_slave_dc_fifo 
#(
    parameter DATA_WIDTH = 32,
      parameter BUFFER_DEPTH = 8
      )
(
	clk_a,
	rstn_a,
	data_a,
	valid_a,
	ready_a,
	clk_b,
	rstn_b,
	data_b,
	valid_b,
	ready_b
);
	//parameter DATA_WIDTH = 32;
	//parameter BUFFER_DEPTH = 8;
	input wire clk_a;
	input wire rstn_a;
	input wire [DATA_WIDTH - 1:0] data_a;
	input wire valid_a;
	output wire ready_a;
	input wire clk_b;
	input wire rstn_b;
	output wire [DATA_WIDTH - 1:0] data_b;
	output wire valid_b;
	input wire ready_b;
	wire [DATA_WIDTH - 1:0] data_async;
	wire [BUFFER_DEPTH - 1:0] write_token;
	wire [BUFFER_DEPTH - 1:0] read_pointer;
	dc_token_ring_fifo_din #(
		.DATA_WIDTH(DATA_WIDTH),
		.BUFFER_DEPTH(BUFFER_DEPTH)
	) u_din(
		.clk(clk_a),
		.rstn(rstn_a),
		.data(data_a),
		.valid(valid_a),
		.ready(ready_a),
		.write_token(write_token),
		.read_pointer(read_pointer),
		.data_async(data_async)
	);
	dc_token_ring_fifo_dout #(
		.DATA_WIDTH(DATA_WIDTH),
		.BUFFER_DEPTH(BUFFER_DEPTH)
	) u_dout(
		.clk(clk_b),
		.rstn(rstn_b),
		.data(data_b),
		.valid(valid_b),
		.ready(ready_b),
		.write_token(write_token),
		.read_pointer(read_pointer),
		.data_async(data_async)
	);
endmodule
