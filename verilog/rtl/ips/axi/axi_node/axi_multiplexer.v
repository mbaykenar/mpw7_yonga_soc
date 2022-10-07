module axi_multiplexer 
#(
    parameter DATA_WIDTH = 64,
    parameter N_IN       = 16,
    parameter SEL_WIDTH  = $clog2(N_IN)
)
(
	IN_DATA,
	OUT_DATA,
	SEL
);
	//parameter DATA_WIDTH = 64;
	//parameter N_IN = 16;
	//parameter SEL_WIDTH = $clog2(N_IN);
	input wire [(N_IN * DATA_WIDTH) - 1:0] IN_DATA;
	output wire [DATA_WIDTH - 1:0] OUT_DATA;
	input wire [SEL_WIDTH - 1:0] SEL;
	assign OUT_DATA = IN_DATA[SEL * DATA_WIDTH+:DATA_WIDTH];
endmodule
