module spi_master_rx (
	clk,
	rstn,
	en,
	rx_edge,
	rx_done,
	sdi0,
	sdi1,
	sdi2,
	sdi3,
	en_quad_in,
	counter_in,
	counter_in_upd,
	data,
	data_ready,
	data_valid,
	clk_en_o
);
	input wire clk;
	input wire rstn;
	input wire en;
	input wire rx_edge;
	output wire rx_done;
	input wire sdi0;
	input wire sdi1;
	input wire sdi2;
	input wire sdi3;
	input wire en_quad_in;
	input wire [15:0] counter_in;
	input wire counter_in_upd;
	output wire [31:0] data;
	input wire data_ready;
	output reg data_valid;
	output reg clk_en_o;
	reg [31:0] data_int;
	reg [31:0] data_int_next;
	reg [15:0] counter;
	reg [15:0] counter_trgt;
	reg [15:0] counter_next;
	reg [15:0] counter_trgt_next;
	wire done;
	wire reg_done;
	reg [1:0] rx_CS;
	reg [1:0] rx_NS;
	assign reg_done = (!en_quad_in && (counter[4:0] == 5'b11111)) || (en_quad_in && (counter[2:0] == 3'b111));
	assign data = data_int_next;
	assign rx_done = done;
	always @(*)
		if (counter_in_upd)
			counter_trgt_next = (en_quad_in ? {2'b00, counter_in[15:2]} : counter_in);
		else
			counter_trgt_next = counter_trgt;
	assign done = (counter == (counter_trgt - 1)) && rx_edge;
	always @(*) begin
		rx_NS = rx_CS;
		clk_en_o = 1'b0;
		data_int_next = data_int;
		data_valid = 1'b0;
		counter_next = counter;
		case (rx_CS)
			2'd0: begin
				clk_en_o = 1'b0;
				if (en)
					rx_NS = 2'd1;
			end
			2'd1: begin
				clk_en_o = 1'b1;
				if (rx_edge) begin
					counter_next = counter + 1;
					if (en_quad_in)
						data_int_next = {data_int[27:0], sdi3, sdi2, sdi1, sdi0};
					else
						data_int_next = {data_int[30:0], sdi0};
					if (rx_done) begin
						counter_next = 0;
						data_valid = 1'b1;
						if (data_ready)
							rx_NS = 2'd0;
						else
							rx_NS = 2'd3;
					end
					else if (reg_done) begin
						data_valid = 1'b1;
						if (~data_ready) begin
							clk_en_o = 1'b0;
							rx_NS = 2'd2;
						end
					end
				end
			end
			2'd3: begin
				data_valid = 1'b1;
				if (data_ready)
					rx_NS = 2'd0;
			end
			2'd2: begin
				data_valid = 1'b1;
				if (data_ready)
					rx_NS = 2'd1;
			end
		endcase
	end
	always @(posedge clk or negedge rstn)
		if (rstn == 0) begin
			counter <= 0;
			counter_trgt <= 'h8;
			data_int <= 1'sb0;
			rx_CS <= 2'd0;
		end
		else begin
			counter <= counter_next;
			counter_trgt <= counter_trgt_next;
			data_int <= data_int_next;
			rx_CS <= rx_NS;
		end
endmodule
