module spi_master_clkgen (
	clk,
	rstn,
	en,
	clk_div,
	clk_div_valid,
	spi_clk,
	spi_fall,
	spi_rise
);
	input wire clk;
	input wire rstn;
	input wire en;
	input wire [7:0] clk_div;
	input wire clk_div_valid;
	output reg spi_clk;
	output reg spi_fall;
	output reg spi_rise;
	reg [7:0] counter_trgt;
	reg [7:0] counter_trgt_next;
	reg [7:0] counter;
	reg [7:0] counter_next;
	reg spi_clk_next;
	reg running;
	always @(*) begin
		spi_rise = 1'b0;
		spi_fall = 1'b0;
		if (clk_div_valid)
			counter_trgt_next = clk_div;
		else
			counter_trgt_next = counter_trgt;
		if (counter == counter_trgt) begin
			counter_next = 0;
			spi_clk_next = ~spi_clk;
			if (spi_clk == 1'b0)
				spi_rise = running;
			else
				spi_fall = running;
		end
		else begin
			counter_next = counter + 1;
			spi_clk_next = spi_clk;
		end
	end
	always @(posedge clk or negedge rstn)
		if (rstn == 1'b0) begin
			counter_trgt <= 'h0;
			counter <= 'h0;
			spi_clk <= 1'b0;
			running <= 1'b0;
		end
		else begin
			counter_trgt <= counter_trgt_next;
			if (!((spi_clk == 1'b0) && ~en)) begin
				running <= 1'b1;
				spi_clk <= spi_clk_next;
				counter <= counter_next;
			end
			else
				running <= 1'b0;
		end
endmodule
