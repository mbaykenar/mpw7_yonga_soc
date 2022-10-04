module preprocess_fmac (
	Operand_a_DI,
	Operand_b_DI,
	Operand_c_DI,
	Exp_a_DO,
	Mant_a_DO,
	Sign_a_DO,
	Exp_b_DO,
	Mant_b_DO,
	Sign_b_DO,
	Exp_c_DO,
	Mant_c_DO,
	Sign_c_DO,
	Inf_a_SO,
	Inf_b_SO,
	Inf_c_SO,
	Zero_a_SO,
	Zero_b_SO,
	Zero_c_SO,
	NaN_a_SO,
	NaN_b_SO,
	NaN_c_SO,
	DeN_a_SO,
	DeN_b_SO,
	DeN_c_SO
);
parameter C_DIV_RM           = 2;
parameter C_DIV_RM_NEAREST   = 2'h0;
parameter C_DIV_RM_TRUNC     = 2'h1;
parameter C_DIV_RM_PLUSINF   = 2'h2;
parameter C_DIV_RM_MINUSINF  = 2'h3;
parameter C_DIV_PC           = 5;
parameter C_DIV_OP           = 32;
parameter C_DIV_MANT         = 23;
parameter C_DIV_EXP          = 8;
parameter C_DIV_BIAS         = 127;
parameter C_DIV_BIAS_AONE    = 8'h80;
parameter C_DIV_HALF_BIAS    = 63;
parameter C_DIV_MANT_PRENORM = C_DIV_MANT+1;
parameter C_DIV_EXP_ZERO     = 8'h00;
parameter C_DIV_EXP_ONE      = 8'h01;
parameter C_DIV_EXP_INF      = 8'hff;
parameter C_DIV_MANT_ZERO    = 23'h0;
parameter C_DIV_MANT_NAN     = 23'h400000;
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
parameter C_FFLAG         = 5;
	input wire [C_OP - 1:0] Operand_a_DI;
	input wire [C_OP - 1:0] Operand_b_DI;
	input wire [C_OP - 1:0] Operand_c_DI;
	output wire [C_EXP - 1:0] Exp_a_DO;
	output wire [C_MANT:0] Mant_a_DO;
	output wire Sign_a_DO;
	output wire [C_EXP - 1:0] Exp_b_DO;
	output wire [C_MANT:0] Mant_b_DO;
	output wire Sign_b_DO;
	output wire [C_EXP - 1:0] Exp_c_DO;
	output wire [C_MANT:0] Mant_c_DO;
	output wire Sign_c_DO;
	output wire Inf_a_SO;
	output wire Inf_b_SO;
	output wire Inf_c_SO;
	output wire Zero_a_SO;
	output wire Zero_b_SO;
	output wire Zero_c_SO;
	output wire NaN_a_SO;
	output wire NaN_b_SO;
	output wire NaN_c_SO;
	output wire DeN_a_SO;
	output wire DeN_b_SO;
	output wire DeN_c_SO;
	wire Hb_a_D;
	wire Hb_b_D;
	wire Hb_c_D;
	assign Sign_a_DO = Operand_a_DI[C_OP - 1];
	assign Sign_b_DO = Operand_b_DI[C_OP - 1];
	assign Sign_c_DO = Operand_c_DI[C_OP - 1];
	assign Exp_a_DO = (DeN_a_SO ? C_EXP_ONE : Operand_a_DI[C_OP - 2:C_MANT]);
	assign Exp_b_DO = (DeN_b_SO ? C_EXP_ONE : Operand_b_DI[C_OP - 2:C_MANT]);
	assign Exp_c_DO = (DeN_c_SO ? C_EXP_ONE : Operand_c_DI[C_OP - 2:C_MANT]);
	assign Mant_a_DO = {Hb_a_D, Operand_a_DI[C_MANT - 1:0]};
	assign Mant_b_DO = {Hb_b_D, Operand_b_DI[C_MANT - 1:0]};
	assign Mant_c_DO = {Hb_c_D, Operand_c_DI[C_MANT - 1:0]};
	assign Hb_a_D = |Operand_a_DI[C_OP - 2:C_MANT];
	assign Hb_b_D = |Operand_b_DI[C_OP - 2:C_MANT];
	assign Hb_c_D = |Operand_c_DI[C_OP - 2:C_MANT];
	wire Mant_a_zero_S;
	wire Mant_b_zero_S;
	wire Mant_c_zero_S;
	assign Mant_a_zero_S = Operand_a_DI[C_MANT - 1:0] == C_MANT_ZERO;
	assign Mant_b_zero_S = Operand_b_DI[C_MANT - 1:0] == C_MANT_ZERO;
	assign Mant_c_zero_S = Operand_c_DI[C_MANT - 1:0] == C_MANT_ZERO;
	wire Exp_a_zero_S;
	wire Exp_b_zero_S;
	wire Exp_c_zero_S;
	assign Exp_a_zero_S = ~Hb_a_D;
	assign Exp_b_zero_S = ~Hb_b_D;
	assign Exp_c_zero_S = ~Hb_c_D;
	wire Exp_a_Inf_NaN_S;
	wire Exp_b_Inf_NaN_S;
	wire Exp_c_Inf_NaN_S;
	assign Exp_a_Inf_NaN_S = Exp_a_DO == C_EXP_INF;
	assign Exp_b_Inf_NaN_S = Exp_b_DO == C_EXP_INF;
	assign Exp_c_Inf_NaN_S = Exp_c_DO == C_EXP_INF;
	assign Zero_a_SO = Exp_a_zero_S && Mant_a_zero_S;
	assign Zero_b_SO = Exp_b_zero_S && Mant_b_zero_S;
	assign Zero_c_SO = Exp_c_zero_S && Mant_c_zero_S;
	assign Inf_a_SO = Exp_a_Inf_NaN_S && Mant_a_zero_S;
	assign Inf_b_SO = Exp_b_Inf_NaN_S && Mant_b_zero_S;
	assign Inf_c_SO = Exp_c_Inf_NaN_S && Mant_c_zero_S;
	assign NaN_a_SO = Exp_a_Inf_NaN_S && ~Mant_a_zero_S;
	assign NaN_b_SO = Exp_b_Inf_NaN_S && ~Mant_b_zero_S;
	assign NaN_c_SO = Exp_c_Inf_NaN_S && ~Mant_c_zero_S;
	assign DeN_a_SO = Exp_a_zero_S && ~Mant_a_zero_S;
	assign DeN_b_SO = Exp_b_zero_S && ~Mant_b_zero_S;
	assign DeN_c_SO = Exp_c_zero_S && ~Mant_c_zero_S;
endmodule
