module booth_encoder (
	Booth_b_DI,
	Sel_1x_SO,
	Sel_2x_SO,
	Sel_sign_SO
);
	input wire [2:0] Booth_b_DI;
	output wire Sel_1x_SO;
	output wire Sel_2x_SO;
	output wire Sel_sign_SO;
	wire Sel_xnor_S;
	assign Sel_1x_SO = ^Booth_b_DI[1:0];
	assign Sel_xnor_S = ~(^Booth_b_DI[2:1]);
	assign Sel_2x_SO = ~(Sel_1x_SO | Sel_xnor_S);
	assign Sel_sign_SO = Booth_b_DI[2];
endmodule
