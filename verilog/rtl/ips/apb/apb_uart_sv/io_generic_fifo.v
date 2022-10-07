module io_generic_fifo 
#(
    parameter DATA_WIDTH = 32,
    parameter BUFFER_DEPTH = 2,
    parameter LOG_BUFFER_DEPTH = $clog2(BUFFER_DEPTH)
)
(
	clk_i,
	rstn_i,
	clr_i,
	elements_o,
	data_o,
	valid_o,
	ready_i,
	valid_i,
	data_i,
	ready_o
);
	//parameter DATA_WIDTH = 32;
	//parameter BUFFER_DEPTH = 2;
	//parameter LOG_BUFFER_DEPTH = $clog2(BUFFER_DEPTH);
	input wire clk_i;
	input wire rstn_i;
	input wire clr_i;
	output wire [LOG_BUFFER_DEPTH:0] elements_o;
	output wire [DATA_WIDTH - 1:0] data_o;
	output wire valid_o;
	input wire ready_i;
	input wire valid_i;
	input wire [DATA_WIDTH - 1:0] data_i;
	output wire ready_o;
	reg [LOG_BUFFER_DEPTH - 1:0] pointer_in;
	reg [LOG_BUFFER_DEPTH - 1:0] pointer_out;
	reg [LOG_BUFFER_DEPTH:0] elements;
	reg [DATA_WIDTH - 1:0] buffer [BUFFER_DEPTH - 1:0];
	wire full;
	reg [31:0] loop1;
	assign full = elements == BUFFER_DEPTH;
	assign elements_o = elements;
	always @(posedge clk_i or negedge rstn_i) begin : elements_sequential
		if (rstn_i == 1'b0)
			elements <= 0;
		else if (clr_i)
			elements <= 0;
		else if ((ready_i && valid_o) && (!valid_i || full))
			elements <= elements - 1;
		else if (((!valid_o || !ready_i) && valid_i) && !full)
			elements <= elements + 1;
	end
	always @(posedge clk_i or negedge rstn_i) begin : buffers_sequential
		if (rstn_i == 1'b0) begin
			for (loop1 = 0; loop1 < BUFFER_DEPTH; loop1 = loop1 + 1)
				buffer[loop1] <= 0;
		end
		else if (valid_i && !full)
			buffer[pointer_in] <= data_i;
	end
	always @(posedge clk_i or negedge rstn_i) begin : sequential
		if (rstn_i == 1'b0) begin
			pointer_out <= 0;
			pointer_in <= 0;
		end
		else if (clr_i) begin
			pointer_out <= 0;
			pointer_in <= 0;
		end
		else begin
			if (valid_i && !full)
				if (pointer_in == $unsigned(BUFFER_DEPTH - 1))
					pointer_in <= 0;
				else
					pointer_in <= pointer_in + 1;
			if (ready_i && valid_o)
				if (pointer_out == $unsigned(BUFFER_DEPTH - 1))
					pointer_out <= 0;
				else
					pointer_out <= pointer_out + 1;
		end
	end
	assign data_o = buffer[pointer_out];
	assign valid_o = elements != 0;
	assign ready_o = ~full;
endmodule
