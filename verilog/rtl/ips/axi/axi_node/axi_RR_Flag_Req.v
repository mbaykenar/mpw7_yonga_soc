module axi_RR_Flag_Req 
#(

    parameter MAX_COUNT   = 8,
    parameter WIDTH       = $clog2(MAX_COUNT)
)
(
	clk,
	rst_n,
	RR_FLAG_o,
	data_req_i,
	data_gnt_i
);
	//parameter MAX_COUNT = 8;
	//parameter WIDTH = $clog2(MAX_COUNT);
	input wire clk;
	input wire rst_n;
	output reg [WIDTH - 1:0] RR_FLAG_o;
	input wire data_req_i;
	input wire data_gnt_i;
	always @(posedge clk or negedge rst_n) begin : RR_Flag_Req_SEQ
		if (rst_n == 1'b0)
			RR_FLAG_o <= 1'sb0;
		else if (data_req_i & data_gnt_i)
			if (RR_FLAG_o < (MAX_COUNT - 1))
				RR_FLAG_o <= RR_FLAG_o + 1'b1;
			else
				RR_FLAG_o <= 1'sb0;
	end
endmodule
