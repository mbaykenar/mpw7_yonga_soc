//`include "fpu_defs.sv"
//`include "fpu_defs_fmac.sv"



module fpexc (
	Mant_a_DI,
	Mant_b_DI,
	Exp_a_DI,
	Exp_b_DI,
	Sign_a_DI,
	Sign_b_DI,
	Mant_norm_DI,
	Exp_res_DI,
	Op_SI,
	Mant_rounded_SI,
	Exp_OF_SI,
	Exp_UF_SI,
	OF_SI,
	UF_SI,
	Zero_SI,
	IX_SI,
	IV_SI,
	Inf_SI,
	Exp_toZero_SO,
	Exp_toInf_SO,
	Mant_toZero_SO,
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


	input wire [C_MANT:0] Mant_a_DI;
	input wire [C_MANT:0] Mant_b_DI;
	input wire [C_EXP - 1:0] Exp_a_DI;
	input wire [C_EXP - 1:0] Exp_b_DI;
	input wire Sign_a_DI;
	input wire Sign_b_DI;
	input wire [C_MANT:0] Mant_norm_DI;
	input wire [C_EXP - 1:0] Exp_res_DI;
	input wire [C_CMD - 1:0] Op_SI;
	input wire Mant_rounded_SI;
	input wire Exp_OF_SI;
	input wire Exp_UF_SI;
	input wire OF_SI;
	input wire UF_SI;
	input wire Zero_SI;
	input wire IX_SI;
	input wire IV_SI;
	input wire Inf_SI;
	output wire Exp_toZero_SO;
	output wire Exp_toInf_SO;
	output wire Mant_toZero_SO;
	output wire OF_SO;
	output wire UF_SO;
	output wire Zero_SO;
	output wire IX_SO;
	output reg IV_SO;
	output wire Inf_SO;
	wire Inf_a_S;
	wire Inf_b_S;
	wire Zero_a_S;
	wire Zero_b_S;
	wire NaN_a_S;
	wire NaN_b_S;
	wire Mant_zero_S;
	assign Inf_a_S = (Exp_a_DI == C_EXP_INF) & (Mant_a_DI[C_MANT - 1:0] == C_MANT_NoHB_ZERO);
	assign Inf_b_S = (Exp_b_DI == C_EXP_INF) & (Mant_b_DI[C_MANT - 1:0] == C_MANT_NoHB_ZERO);
	assign Zero_a_S = (Exp_a_DI == C_EXP_ZERO) & (Mant_a_DI == C_MANT_ZERO);
	assign Zero_b_S = (Exp_b_DI == C_EXP_ZERO) & (Mant_b_DI == C_MANT_ZERO);
	assign NaN_a_S = (Exp_a_DI == C_EXP_INF) & (Mant_a_DI[C_MANT - 1:0] != C_MANT_NoHB_ZERO);
	assign NaN_b_S = (Exp_b_DI == C_EXP_INF) & (Mant_b_DI[C_MANT - 1:0] != C_MANT_NoHB_ZERO);
	assign Mant_zero_S = Mant_norm_DI == C_MANT_ZERO;
	assign OF_SO = (Op_SI == C_FPU_F2I_CMD ? OF_SI : (Exp_OF_SI & ~Mant_zero_S) | ((~IV_SO & (Inf_a_S ^ Inf_b_S)) & (Op_SI != C_FPU_I2F_CMD)));
	assign UF_SO = (Op_SI == C_FPU_F2I_CMD ? UF_SI : Exp_UF_SI & Mant_rounded_SI);
	assign Zero_SO = (Op_SI == C_FPU_F2I_CMD ? Zero_SI : Mant_zero_S & ~IV_SO);
	assign IX_SO = (Op_SI == C_FPU_F2I_CMD ? IX_SI : Mant_rounded_SI | OF_SO);
	always @(*) begin
		IV_SO = 1'b0;
		case (Op_SI)
			C_FPU_ADD_CMD, C_FPU_SUB_CMD:
				if ((((Inf_a_S & Inf_b_S) & (Sign_a_DI ^ Sign_b_DI)) | NaN_a_S) | NaN_b_S)
					IV_SO = 1'b1;
			C_FPU_MUL_CMD:
				if ((((Inf_a_S & Zero_b_S) | (Inf_b_S & Zero_a_S)) | NaN_a_S) | NaN_b_S)
					IV_SO = 1'b1;
			C_FPU_F2I_CMD: IV_SO = IV_SI;
		endcase
	end
	reg Inf_temp_S;
	always @(*) begin
		Inf_temp_S = 1'b0;
		case (Op_SI)
			C_FPU_ADD_CMD, C_FPU_SUB_CMD:
				if ((Inf_a_S ^ Inf_b_S) | ((Inf_a_S & Inf_b_S) & ~(Sign_a_DI ^ Sign_b_DI)))
					Inf_temp_S = 1'b1;
			C_FPU_MUL_CMD:
				if ((Inf_a_S & ~Zero_b_S) | (Inf_b_S & ~Zero_a_S))
					Inf_temp_S = 1'b1;
		endcase
	end
	assign Inf_SO = (Op_SI == C_FPU_F2I_CMD ? Inf_SI : Inf_temp_S | (Exp_OF_SI & ~Mant_zero_S));
	assign Exp_toZero_SO = (Op_SI == C_FPU_I2F_CMD ? Zero_a_S & ~Sign_a_DI : Exp_UF_SI | (Mant_zero_S & ~Exp_toInf_SO));
	assign Exp_toInf_SO = OF_SO | IV_SO;
	assign Mant_toZero_SO = Inf_SO;
endmodule
