module fpu_norm (
	Mant_in_DI,
	Exp_in_DI,
	Sign_in_DI,
	RM_SI,
	OP_SI,
	Mant_res_DO,
	Exp_res_DO,
	Rounded_SO,
	Exp_OF_SO,
	Exp_UF_SO
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

parameter C_CMD               = 4;
parameter C_FPU_ADD_CMD       = 4'h0;
parameter C_FPU_SUB_CMD       = 4'h1;
parameter C_FPU_MUL_CMD       = 4'h2;
parameter C_FPU_DIV_CMD       = 4'h3;
parameter C_FPU_I2F_CMD       = 4'h4;
parameter C_FPU_F2I_CMD       = 4'h5;
parameter C_FPU_SQRT_CMD      = 4'h6;
parameter C_FPU_NOP_CMD       = 4'h7;
parameter C_FPU_FMADD_CMD     = 4'h8;
parameter C_FPU_FMSUB_CMD     = 4'h9;
parameter C_FPU_FNMADD_CMD    = 4'hA;
parameter C_FPU_FNMSUB_CMD    = 4'hB;
parameter C_RM_NEAREST_MAX = 3'h4;
parameter C_EXP_PRENORM  = C_EXP+2;
parameter C_MANT_ADDIN   = C_MANT+4;
parameter C_MANT_ADDOUT  = C_MANT+5;
parameter C_MANT_SHIFTIN = C_MANT+3;
parameter C_MANT_SHIFTED = C_MANT+4;
parameter C_MANT_INT     = C_OP-1;
parameter C_INF          = 32'h7fffffff;
parameter C_MINF         = 32'h80000000;
parameter C_EXP_SHIFT    = C_EXP_PRENORM;
parameter C_SHIFT_BIAS   = 9'd127;
parameter C_UNKNOWN      = 8'd157;
parameter C_PADMANT      = 16'b0;
parameter C_MANT_NoHB_ZERO   = 23'h0;
parameter C_MANT_PRENORM_IND = 6;
parameter F_QNAN         =32'h7FC00000;
	input wire [C_MANT_PRENORM - 1:0] Mant_in_DI;
	input wire signed [C_EXP_PRENORM - 1:0] Exp_in_DI;
	input wire Sign_in_DI;
	input wire [C_RM - 1:0] RM_SI;
	input wire [C_CMD - 1:0] OP_SI;
	output wire [C_MANT:0] Mant_res_DO;
	output wire [C_EXP - 1:0] Exp_res_DO;
	output wire Rounded_SO;
	output reg Exp_OF_SO;
	output reg Exp_UF_SO;
	wire [C_MANT_PRENORM_IND - 1:0] Mant_leadingOne_D;
	wire Mant_zero_S;
	reg [C_MANT + 4:0] Mant_norm_D;
	wire signed [C_EXP_PRENORM - 1:0] Exp_norm_D;
	wire signed [C_EXP_PRENORM - 1:0] Mant_shAmt_D;
	wire signed [C_EXP_PRENORM:0] Mant_shAmt2_D;
	wire [C_EXP - 1:0] Exp_final_D;
	wire signed [C_EXP_PRENORM - 1:0] Exp_rounded_D;
	reg Mant_sticky_D;
	wire Denormal_S;
	wire Mant_renorm_S;
	fpu_ff #(.LEN(C_MANT_PRENORM)) LOD(
		.in_i(Mant_in_DI),
		.first_one_o(Mant_leadingOne_D),
		.no_ones_o(Mant_zero_S)
	);
	wire Denormals_shift_add_D;
	wire Denormals_exp_add_D;
	assign Denormals_shift_add_D = (~Mant_zero_S & (Exp_in_DI == C_EXP_ZERO)) & ((OP_SI != C_FPU_MUL_CMD) | (~Mant_in_DI[C_MANT_PRENORM - 1] & ~Mant_in_DI[C_MANT_PRENORM - 2]));
	assign Denormals_exp_add_D = (Mant_in_DI[C_MANT_PRENORM - 2] & (Exp_in_DI == C_EXP_ZERO)) & ((OP_SI == C_FPU_ADD_CMD) | (OP_SI == C_FPU_SUB_CMD));
	assign Denormal_S = (C_EXP_PRENORM'($signed(Mant_leadingOne_D)) >= Exp_in_DI) || Mant_zero_S;
	assign Mant_shAmt_D = (Denormal_S ? Exp_in_DI + Denormals_shift_add_D : Mant_leadingOne_D);
	assign Mant_shAmt2_D = {Mant_shAmt_D[C_EXP_PRENORM - 1], Mant_shAmt_D} + (C_MANT + 5);
	function automatic [(((C_MANT_PRENORM + C_MANT) + 4) >= 0 ? (C_MANT_PRENORM + C_MANT) + 5 : 1 - ((C_MANT_PRENORM + C_MANT) + 4)) - 1:0] sv2v_cast_F3481;
		input reg [(((C_MANT_PRENORM + C_MANT) + 4) >= 0 ? (C_MANT_PRENORM + C_MANT) + 5 : 1 - ((C_MANT_PRENORM + C_MANT) + 4)) - 1:0] inp;
		sv2v_cast_F3481 = inp;
	endfunction
	always @(*) begin : sv2v_autoblock_1
		reg [(C_MANT_PRENORM + C_MANT) + 4:0] temp;
		temp = sv2v_cast_F3481(Mant_in_DI) << Mant_shAmt2_D;
		Mant_norm_D = temp[(C_MANT_PRENORM + C_MANT) + 4:C_MANT_PRENORM];
	end
	always @(*) begin
		Mant_sticky_D = 1'b0;
		if (Mant_shAmt2_D <= 0)
			Mant_sticky_D = |Mant_in_DI;
		else if (Mant_shAmt2_D <= C_MANT_PRENORM)
			Mant_sticky_D = |(Mant_in_DI << Mant_shAmt2_D);
	end
	assign Exp_norm_D = ((Exp_in_DI - C_EXP_PRENORM'($signed(Mant_leadingOne_D))) + 1) + Denormals_exp_add_D;
	assign Exp_rounded_D = Exp_norm_D + Mant_renorm_S;
	assign Exp_final_D = Exp_rounded_D[C_EXP - 1:0];
	always @(*) begin
		Exp_OF_SO = 1'b0;
		Exp_UF_SO = 1'b0;
		if (Exp_rounded_D >= $signed({2'b00, C_EXP_INF}))
			Exp_OF_SO = 1'b1;
		else if (Exp_rounded_D <= $signed({2'b00, C_EXP_ZERO}))
			Exp_UF_SO = 1'b1;
	end
	wire [C_MANT:0] Mant_upper_D;
	wire [3:0] Mant_lower_D;
	wire [C_MANT + 1:0] Mant_upperRounded_D;
	reg Mant_roundUp_S;
	wire Mant_rounded_S;
	assign Mant_lower_D = Mant_norm_D[3:0];
	assign Mant_upper_D = Mant_norm_D[C_MANT + 4:4];
	assign Mant_rounded_S = |Mant_lower_D | Mant_sticky_D;
	always @(*) begin
		Mant_roundUp_S = 1'b0;
		case (RM_SI)
			C_RM_NEAREST: Mant_roundUp_S = Mant_lower_D[3] && ((|Mant_lower_D[2:0] | Mant_sticky_D) || Mant_upper_D[0]);
			C_RM_TRUNC: Mant_roundUp_S = 0;
			C_RM_PLUSINF: Mant_roundUp_S = Mant_rounded_S & ~Sign_in_DI;
			C_RM_MINUSINF: Mant_roundUp_S = Mant_rounded_S & Sign_in_DI;
			default: Mant_roundUp_S = 0;
		endcase
	end
	assign Mant_upperRounded_D = Mant_upper_D + Mant_roundUp_S;
	assign Mant_renorm_S = Mant_upperRounded_D[C_MANT + 1];
	assign Mant_res_DO = Mant_upperRounded_D >> (Mant_renorm_S & ~Denormal_S);
	assign Exp_res_DO = Exp_final_D;
	assign Rounded_SO = Mant_rounded_S;
endmodule
