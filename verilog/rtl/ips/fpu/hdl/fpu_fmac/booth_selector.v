module booth_selector (
	Booth_a_DI,
	Sel_1x_SI,
	Sel_2x_SI,
	Sel_sign_SI,
	Booth_pp_DO
);
	input wire [1:0] Booth_a_DI;
	input wire Sel_1x_SI;
	input wire Sel_2x_SI;
	input wire Sel_sign_SI;
	output wire Booth_pp_DO;
	assign Booth_pp_DO = ~(~((Sel_1x_SI && Booth_a_DI[1]) | (Sel_2x_SI && Booth_a_DI[0])) ^ Sel_sign_SI);
endmodule
