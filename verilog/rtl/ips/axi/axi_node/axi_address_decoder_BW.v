module axi_address_decoder_BW 
#(
    parameter  N_TARG_PORT     = 3,
    parameter  AXI_ID_IN       = 3,
    parameter  AXI_ID_OUT      = AXI_ID_IN+$clog2(N_TARG_PORT)
)
(
	bid_i,
	bvalid_i,
	bready_o,
	bvalid_o,
	bready_i
);
	//parameter N_TARG_PORT = 3;
	//parameter AXI_ID_IN = 3;
	//parameter AXI_ID_OUT = AXI_ID_IN + $clog2(N_TARG_PORT);
	input wire [AXI_ID_OUT - 1:0] bid_i;
	input wire bvalid_i;
	output reg bready_o;
	output reg [N_TARG_PORT - 1:0] bvalid_o;
	input wire [N_TARG_PORT - 1:0] bready_i;
	reg [N_TARG_PORT - 1:0] req_mask;
	wire [$clog2(N_TARG_PORT) - 1:0] ROUTING;
	assign ROUTING = bid_i[(AXI_ID_IN + $clog2(N_TARG_PORT)) - 1:AXI_ID_IN];
	always @(*) begin
		req_mask = 1'sb0;
		req_mask[ROUTING] = 1'b1;
	end
	always @(*) begin
		if (bvalid_i)
			bvalid_o = {N_TARG_PORT {bvalid_i}} & req_mask;
		else
			bvalid_o = 1'sb0;
		bready_o = |(bready_i & req_mask);
	end
endmodule
