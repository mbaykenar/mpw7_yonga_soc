module fpu_ftoi (
	Sign_a_DI,
	Exp_a_DI,
	Mant_a_DI,
	Result_DO,
	OF_SO,
	UF_SO,
	Zero_SO,
	IX_SO,
	IV_SO,
	Inf_SO
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
	input wire Sign_a_DI;
	input wire [C_EXP - 1:0] Exp_a_DI;
	input wire [C_MANT:0] Mant_a_DI;
	output wire [C_OP - 1:0] Result_DO;
	output wire OF_SO;
	output wire UF_SO;
	output wire Zero_SO;
	output wire IX_SO;
	output wire IV_SO;
	output wire Inf_SO;
	wire Sign_a_D;
	wire [C_EXP - 1:0] Exp_a_D;
	wire [C_MANT:0] Mant_a_D;
	wire [C_OP - 1:0] Result_D;
	assign Sign_a_D = Sign_a_DI;
	assign Exp_a_D = Exp_a_DI;
	assign Mant_a_D = Mant_a_DI;
	wire signed [C_EXP_SHIFT - 1:0] Shift_amount_D;
	wire [(C_MANT + C_OP) - 2:0] Temp_shift_D;
	wire [C_OP - 1:0] Temp_twos_D;
	wire Shift_amount_neg_S;
	wire Result_zero_S;
	wire Input_zero_S;
	assign Shift_amount_D = $signed({1'b0, Exp_a_D}) - $signed(C_SHIFT_BIAS);
	assign Shift_amount_neg_S = Shift_amount_D[C_EXP_SHIFT - 1];
	assign Temp_shift_D = (Shift_amount_neg_S ? {(((C_MANT + C_OP) - 2) >= 0 ? (C_MANT + C_OP) - 1 : 3 - (C_MANT + C_OP)) {1'sb0}} : Mant_a_D << Shift_amount_D);
	assign Temp_twos_D = ~{1'b0, Temp_shift_D[(C_MANT + C_OP) - 2:C_MANT]} + 1'b1;
	assign Result_D = (OF_SO ? (Sign_a_D ? C_MINF : C_INF) : (Sign_a_D ? Temp_twos_D : {Sign_a_D, Temp_shift_D[(C_MANT + C_OP) - 2:C_MANT]}));
	assign Result_DO = Result_D;
	assign Result_zero_S = ~|Result_D;
	assign Input_zero_S = ~|{Exp_a_D, Mant_a_D};
	assign UF_SO = 1'b0;
	assign OF_SO = Shift_amount_D > (C_OP - 2);
	assign Zero_SO = Result_zero_S & ~OF_SO;
	assign IX_SO = ((|Temp_shift_D[C_MANT - 1:0] | Shift_amount_neg_S) | OF_SO) & ~Input_zero_S;
	assign IV_SO = &Exp_a_D && |Mant_a_D;
	assign Inf_SO = 1'b0;
endmodule
