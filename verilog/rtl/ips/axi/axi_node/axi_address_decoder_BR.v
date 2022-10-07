module axi_address_decoder_BR 
#(
   parameter N_TARG_PORT     = 8,
   parameter AXI_ID_IN       = 16,
   parameter AXI_ID_OUT      = AXI_ID_IN+$clog2(N_TARG_PORT)
)
(
	rid_i,
	rvalid_i,
	rready_o,
	rvalid_o,
	rready_i
);
	//parameter N_TARG_PORT = 8;
	//parameter AXI_ID_IN = 16;
	//parameter AXI_ID_OUT = AXI_ID_IN + $clog2(N_TARG_PORT);
	input wire [AXI_ID_OUT - 1:0] rid_i;
	input wire rvalid_i;
	output reg rready_o;
	output reg [N_TARG_PORT - 1:0] rvalid_o;
	input wire [N_TARG_PORT - 1:0] rready_i;
	reg [N_TARG_PORT - 1:0] req_mask;
	wire [$clog2(N_TARG_PORT) - 1:0] ROUTING;
	assign ROUTING = rid_i[(AXI_ID_IN + $clog2(N_TARG_PORT)) - 1:AXI_ID_IN];
	always @(*) begin
		req_mask = 1'sb0;
		req_mask[ROUTING] = 1'b1;
	end
	always @(*) begin
		if (rvalid_i)
			rvalid_o = {N_TARG_PORT {rvalid_i}} & req_mask;
		else
			rvalid_o = 1'sb0;
		rready_o = |(rready_i & req_mask);
	end
endmodule
