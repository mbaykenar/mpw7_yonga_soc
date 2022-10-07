module spi_master_tx (
	clk,
	rstn,
	en,
	tx_edge,
	tx_done,
	sdo0,
	sdo1,
	sdo2,
	sdo3,
	en_quad_in,
	counter_in,
	counter_in_upd,
	data,
	data_valid,
	data_ready,
	clk_en_o
);
	input wire clk;
	input wire rstn;
	input wire en;
	input wire tx_edge;
	output wire tx_done;
	output wire sdo0;
	output wire sdo1;
	output wire sdo2;
	output wire sdo3;
	input wire en_quad_in;
	input wire [15:0] counter_in;
	input wire counter_in_upd;
	input wire [31:0] data;
	input wire data_valid;
	output reg data_ready;
	output reg clk_en_o;
	reg [31:0] data_int;
	reg [31:0] data_int_next;
	reg [15:0] counter;
	reg [15:0] counter_trgt;
	reg [15:0] counter_next;
	reg [15:0] counter_trgt_next;
	wire done;
	wire reg_done;
	reg [0:0] tx_CS;
	reg [0:0] tx_NS;
	assign sdo0 = (en_quad_in ? data_int[28] : data_int[31]);
	assign sdo1 = data_int[29];
	assign sdo2 = data_int[30];
	assign sdo3 = data_int[31];
	assign tx_done = done;
	assign reg_done = (!en_quad_in && (counter[4:0] == 5'b11111)) || (en_quad_in && (counter[2:0] == 3'b111));
	always @(*)
		if (counter_in_upd)
			counter_trgt_next = (en_quad_in ? {2'b00, counter_in[15:2]} : counter_in);
		else
			counter_trgt_next = counter_trgt;
	assign done = (counter == (counter_trgt - 1)) && tx_edge;
	always @(*) begin
		tx_NS = tx_CS;
		clk_en_o = 1'b0;
		data_int_next = data_int;
		data_ready = 1'b0;
		counter_next = counter;
		case (tx_CS)
			1'd0: begin
				clk_en_o = 1'b0;
				if (en && data_valid) begin
					data_int_next = data;
					data_ready = 1'b1;
					tx_NS = 1'd1;
				end
			end
			1'd1: begin
				clk_en_o = 1'b1;
				if (tx_edge) begin
					counter_next = counter + 1;
					data_int_next = (en_quad_in ? {data_int[27:0], 4'b0000} : {data_int[30:0], 1'b0});
					if (tx_done) begin
						counter_next = 0;
						if (en && data_valid) begin
							data_int_next = data;
							data_ready = 1'b1;
							tx_NS = 1'd1;
						end
						else begin
							clk_en_o = 1'b0;
							tx_NS = 1'd0;
						end
					end
					else if (reg_done)
						if (data_valid) begin
							data_int_next = data;
							data_ready = 1'b1;
						end
						else begin
							clk_en_o = 1'b0;
							tx_NS = 1'd0;
						end
				end
			end
		endcase
	end
	always @(posedge clk or negedge rstn)
		if (~rstn) begin
			counter <= 0;
			counter_trgt <= 'h8;
			data_int <= 'h0;
			tx_CS <= 1'd0;
		end
		else begin
			counter <= counter_next;
			counter_trgt <= counter_trgt_next;
			data_int <= data_int_next;
			tx_CS <= tx_NS;
		end
endmodule
