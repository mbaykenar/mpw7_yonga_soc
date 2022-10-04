module LZA 
#( parameter  C_WIDTH = 74)
(
	A_DI,
	B_DI,
	Leading_one_DO,
	No_one_SO
);
parameter C_RM            = 2;
parameter C_RM_NEAREST    = 2'h0;
parameter C_RM_TRUNC      = 2'h1;
parameter C_RM_PLUSINF    = 2'h2;
parameter C_RM_MINUSINF   = 2'h3;
parameter C_PC            = 5;
parameter C_OP            = 32;
parameter C_MANT          = 23;
parameter C_EXP           = 8;
parameter C_BIAS          = 127;
parameter C_HALF_BIAS     = 63;
parameter C_LEADONE_WIDTH = 7;
parameter C_MANT_PRENORM  = C_MANT+1;
parameter C_EXP_ZERO      = 8'h00;
parameter C_EXP_ONE       = 8'h01;
parameter C_EXP_INF       = 8'hff;
parameter C_MANT_ZERO     = 23'h0;
parameter C_MANT_NAN      = 23'h400000;
	//parameter C_WIDTH = 74;
	input wire [C_WIDTH - 1:0] A_DI;
	input wire [C_WIDTH - 1:0] B_DI;
	output wire [C_LEADONE_WIDTH - 1:0] Leading_one_DO;
	output wire No_one_SO;
	reg [C_WIDTH - 1:0] T_D;
	reg [C_WIDTH - 1:0] G_D;
	reg [C_WIDTH - 1:0] Z_D;
	reg [C_WIDTH - 1:0] F_S;
	genvar i;
	generate
		for (i = 0; i <= (C_WIDTH - 1); i = i + 1) begin : genblk1
			always @(*) begin
				T_D[i] = A_DI[i] ^ B_DI[i];
				G_D[i] = A_DI[i] && B_DI[i];
				Z_D[i] = ~(A_DI[i] | B_DI[i]);
			end
		end
	endgenerate
	wire [1:1] sv2v_tmp_CEAFB;
	assign sv2v_tmp_CEAFB = ~T_D[C_WIDTH - 1] & T_D[C_WIDTH - 2];
	always @(*) F_S[C_WIDTH - 1] = sv2v_tmp_CEAFB;
	genvar j;
	generate
		for (j = 1; j < (C_WIDTH - 1); j = j + 1) begin : genblk2
			always @(*) F_S[j] = (T_D[j + 1] & ((G_D[j] & ~Z_D[j - 1]) | (Z_D[j] & ~G_D[j - 1]))) | (~T_D[j + 1] & ((Z_D[j] && ~Z_D[j - 1]) | (G_D[j] & ~G_D[j - 1])));
		end
	endgenerate
	wire [1:1] sv2v_tmp_42D88;
	assign sv2v_tmp_42D88 = (T_D[1] & Z_D[0]) | (~T_D[1] & (T_D[0] | G_D[0]));
	always @(*) F_S[0] = sv2v_tmp_42D88;
	wire [C_LEADONE_WIDTH - 1:0] Leading_one_D;
	wire No_one_S;
	fpu_ff #(.LEN(C_WIDTH)) LOD_Ub(
		.in_i(F_S),
		.first_one_o(Leading_one_D),
		.no_ones_o(No_one_S)
	);
	assign Leading_one_DO = Leading_one_D;
	assign No_one_SO = No_one_S;
endmodule
