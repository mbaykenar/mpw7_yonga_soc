module axi_FanInPrimitive_Req 
#(
      parameter AUX_WIDTH = 32,
      parameter ID_WIDTH = 16
)
(
	RR_FLAG,
	data_AUX0_i,
	data_AUX1_i,
	data_req0_i,
	data_req1_i,
	data_ID0_i,
	data_ID1_i,
	data_gnt0_o,
	data_gnt1_o,
	data_AUX_o,
	data_req_o,
	data_ID_o,
	data_gnt_i,
	lock_EXCLUSIVE,
	SEL_EXCLUSIVE
);
	//parameter AUX_WIDTH = 32;
	//parameter ID_WIDTH = 16;
	input wire RR_FLAG;
	input wire [AUX_WIDTH - 1:0] data_AUX0_i;
	input wire [AUX_WIDTH - 1:0] data_AUX1_i;
	input wire data_req0_i;
	input wire data_req1_i;
	input wire [ID_WIDTH - 1:0] data_ID0_i;
	input wire [ID_WIDTH - 1:0] data_ID1_i;
	output reg data_gnt0_o;
	output reg data_gnt1_o;
	output reg [AUX_WIDTH - 1:0] data_AUX_o;
	output reg data_req_o;
	output reg [ID_WIDTH - 1:0] data_ID_o;
	input wire data_gnt_i;
	input wire lock_EXCLUSIVE;
	input wire SEL_EXCLUSIVE;
	reg SEL;
	always @(*)
		if (lock_EXCLUSIVE) begin
			data_req_o = (SEL_EXCLUSIVE ? data_req1_i : data_req0_i);
			data_gnt0_o = (SEL_EXCLUSIVE ? 1'b0 : data_gnt_i);
			data_gnt1_o = (SEL_EXCLUSIVE ? data_gnt_i : 1'b0);
			SEL = SEL_EXCLUSIVE;
		end
		else begin
			data_req_o = data_req0_i | data_req1_i;
			data_gnt0_o = ((data_req0_i & ~data_req1_i) | (data_req0_i & ~RR_FLAG)) & data_gnt_i;
			data_gnt1_o = ((~data_req0_i & data_req1_i) | (data_req1_i & RR_FLAG)) & data_gnt_i;
			SEL = ~data_req0_i | (RR_FLAG & data_req1_i);
		end
	always @(*) begin : FanIn_MUX2
		case (SEL)
			1'b0: begin
				data_AUX_o = data_AUX0_i;
				data_ID_o = data_ID0_i;
			end
			1'b1: begin
				data_AUX_o = data_AUX1_i;
				data_ID_o = data_ID1_i;
			end
		endcase
	end
endmodule
