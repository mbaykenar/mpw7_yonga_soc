module spi_slave_tx (
	test_mode,
	sclk,
	cs,
	sdo0,
	sdo1,
	sdo2,
	sdo3,
	en_quad_in,
	counter_in,
	counter_in_upd,
	data,
	data_valid,
	done
);
	input wire test_mode;
	input wire sclk;
	input wire cs;
	output wire sdo0;
	output wire sdo1;
	output wire sdo2;
	output wire sdo3;
	input wire en_quad_in;
	input wire [7:0] counter_in;
	input wire counter_in_upd;
	input wire [31:0] data;
	input wire data_valid;
	output reg done;
	reg [31:0] data_int;
	reg [31:0] data_int_next;
	reg [7:0] counter;
	reg [7:0] counter_trgt;
	reg [7:0] counter_next;
	reg [7:0] counter_trgt_next;
	reg running;
	reg running_next;
	wire sclk_inv;
	wire sclk_test;
	assign sdo0 = (en_quad_in ? data_int[28] : data_int[31]);
	assign sdo1 = (en_quad_in ? data_int[29] : 1'b0);
	assign sdo2 = (en_quad_in ? data_int[30] : 1'b0);
	assign sdo3 = (en_quad_in ? data_int[31] : 1'b0);
	always @(*) begin
		done = 1'b0;
		if (counter_in_upd)
			counter_trgt_next = counter_in;
		else
			counter_trgt_next = counter_trgt;
		if (counter_in_upd)
			running_next = 1'b1;
		else if (counter == counter_trgt)
			running_next = 1'b0;
		else
			running_next = running;
		if (running || counter_in_upd) begin
			if (counter == counter_trgt) begin
				done = 1'b1;
				counter_next = 0;
			end
			else
				counter_next = counter + 1;
			if (data_valid)
				data_int_next = data;
			else if (en_quad_in)
				data_int_next = {data_int[27:0], 4'b0000};
			else
				data_int_next = {data_int[30:0], 1'b0};
		end
		else begin
			counter_next = counter;
			data_int_next = data_int;
		end
	end
	pulp_clock_inverter clk_inv_i(
		.clk_i(sclk),
		.clk_o(sclk_inv)
	);
	pulp_clock_mux2 clk_mux_i(
		.clk0_i(sclk_inv),
		.clk1_i(sclk),
		.clk_sel_i(test_mode),
		.clk_o(sclk_test)
	);
	always @(posedge sclk_test or posedge cs)
		if (cs == 1'b1) begin
			counter <= 'h0;
			counter_trgt <= 'h7;
			data_int <= 'h0;
			running <= 1'b0;
		end
		else begin
			counter <= counter_next;
			counter_trgt <= counter_trgt_next;
			data_int <= data_int_next;
			running <= running_next;
		end
endmodule
