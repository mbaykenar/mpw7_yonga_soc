module fmac (
	Operand_a_DI,
	Operand_b_DI,
	Operand_c_DI,
	RM_SI,
	Result_DO,
	Exp_OF_SO,
	Exp_UF_SO,
	Exp_NX_SO
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
	input wire [C_OP - 1:0] Operand_a_DI;
	input wire [C_OP - 1:0] Operand_b_DI;
	input wire [C_OP - 1:0] Operand_c_DI;
	input wire [C_RM - 1:0] RM_SI;
	output wire [31:0] Result_DO;
	output wire Exp_OF_SO;
	output wire Exp_UF_SO;
	output wire Exp_NX_SO;
	wire [C_MANT - 1:0] Mant_res_DO;
	wire [C_EXP - 1:0] Exp_res_DO;
	wire Sign_res_DO;
	wire DeN_a_S;
	wire Sub_S;
	wire Sign_postalig_D;
	wire Sign_amt_D;
	wire Sft_stop_S;
	wire Sign_out_D;
	assign Result_DO = {Sign_res_DO, Exp_res_DO, Mant_res_DO};
	wire Sign_a_D;
	wire Sign_b_D;
	wire Sign_c_D;
	wire [C_EXP - 1:0] Exp_a_D;
	wire [C_EXP - 1:0] Exp_b_D;
	wire [C_EXP - 1:0] Exp_c_D;
	wire [C_MANT:0] Mant_a_D;
	wire [C_MANT:0] Mant_b_D;
	wire [C_MANT:0] Mant_c_D;
	wire Inf_a_S;
	wire Inf_b_S;
	wire Inf_c_S;
	wire NaN_a_S;
	wire NaN_b_S;
	wire NaN_c_S;
	wire Zero_a_S;
	wire Zero_b_S;
	wire Zero_c_S;
	preprocess_fmac precess_U0(
		.Operand_a_DI(Operand_a_DI),
		.Operand_b_DI(Operand_b_DI),
		.Operand_c_DI(Operand_c_DI),
		.Exp_a_DO(Exp_a_D),
		.Mant_a_DO(Mant_a_D),
		.Sign_a_DO(Sign_a_D),
		.Exp_b_DO(Exp_b_D),
		.Mant_b_DO(Mant_b_D),
		.Sign_b_DO(Sign_b_D),
		.Exp_c_DO(Exp_c_D),
		.Mant_c_DO(Mant_c_D),
		.Sign_c_DO(Sign_c_D),
		.DeN_a_SO(DeN_a_S),
		.Inf_a_SO(Inf_a_S),
		.Inf_b_SO(Inf_b_S),
		.Inf_c_SO(Inf_c_S),
		.Zero_a_SO(Zero_a_S),
		.Zero_b_SO(Zero_b_S),
		.Zero_c_SO(Zero_c_S),
		.NaN_a_SO(NaN_a_S),
		.NaN_b_SO(NaN_b_S),
		.NaN_c_SO(NaN_c_S)
	);
	wire [(((2 * C_MANT) + 2) >= 0 ? (13 * ((2 * C_MANT) + 3)) - 1 : (13 * (1 - ((2 * C_MANT) + 2))) + ((2 * C_MANT) + 1)):(((2 * C_MANT) + 2) >= 0 ? 0 : (2 * C_MANT) + 2)] Pp_index_D;
	pp_generation pp_gneration_U0(
		.Mant_a_DI(Mant_b_D),
		.Mant_b_DI(Mant_c_D),
		.Pp_index_DO(Pp_index_D)
	);
	wire [(2 * C_MANT) + 2:0] Pp_sum_D;
	wire [(2 * C_MANT) + 2:0] Pp_carry_D;
	wire MSB_cor_D;
	wallace wallace_U0(
		.Pp_index_DI(Pp_index_D),
		.Pp_sum_DO(Pp_sum_D),
		.Pp_carry_DO(Pp_carry_D),
		.MSB_cor_DO(MSB_cor_D)
	);
	wire [74:0] Mant_postalig_a_D;
	wire signed [C_EXP + 1:0] Exp_postalig_D;
	wire [(2 * C_MANT) + 2:0] Pp_sum_postcal_D;
	wire [(2 * C_MANT) + 2:0] Pp_carry_postcal_D;
	aligner aligner_U0(
		.Exp_a_DI(Exp_a_D),
		.Exp_b_DI(Exp_b_D),
		.Mant_a_DI(Mant_a_D),
		.Exp_c_DI(Exp_c_D),
		.Sign_a_DI(Sign_a_D),
		.Sign_b_DI(Sign_b_D),
		.Sign_c_DI(Sign_c_D),
		.Pp_sum_DI(Pp_sum_D),
		.Pp_carry_DI(Pp_carry_D),
		.Sub_SO(Sub_S),
		.Mant_postalig_a_DO(Mant_postalig_a_D),
		.Exp_postalig_DO(Exp_postalig_D),
		.Sign_postalig_DO(Sign_postalig_D),
		.Sign_amt_DO(Sign_amt_D),
		.Sft_stop_SO(Sft_stop_S),
		.Pp_sum_postcal_DO(Pp_sum_postcal_D),
		.Pp_carry_postcal_DO(Pp_carry_postcal_D)
	);
	wire [(2 * C_MANT) + 1:0] Csa_sum_D;
	wire [(2 * C_MANT) + 1:0] Csa_carry_D;
	CSA #((2 * C_MANT) + 2) CSA_U0(
		.A_DI(Mant_postalig_a_D[(2 * C_MANT) + 1:0]),
		.B_DI({Pp_sum_postcal_D[(2 * C_MANT) + 1:0]}),
		.C_DI({Pp_carry_postcal_D[2 * C_MANT:0], 1'b0}),
		.Sum_DO(Csa_sum_D),
		.Carry_DO(Csa_carry_D)
	);
	wire [73:0] Sum_pos_D;
	wire [(3 * C_MANT) + 4:0] A_LZA_D;
	wire [(3 * C_MANT) + 4:0] B_LZA_D;
	adders adders_U0(
		.AL_DI(Csa_sum_D),
		.BL_DI(Csa_carry_D),
		.Sub_SI(Sub_S),
		.Sign_cor_SI({MSB_cor_D, Pp_carry_postcal_D[(2 * C_MANT) + 2], {Pp_sum_postcal_D[(2 * C_MANT) + 2] && Pp_carry_postcal_D[(2 * C_MANT) + 1]}}),
		.Sign_amt_DI(Sign_amt_D),
		.Sft_stop_SI(Sft_stop_S),
		.BH_DI(Mant_postalig_a_D[(3 * C_MANT) + 5:(2 * C_MANT) + 2]),
		.Sign_postalig_DI(Sign_postalig_D),
		.Sum_pos_DO(Sum_pos_D),
		.Sign_out_DO(Sign_out_D),
		.A_LZA_DO(A_LZA_D),
		.B_LZA_DO(B_LZA_D)
	);
	wire [C_LEADONE_WIDTH - 1:0] Leading_one_D;
	wire No_one_S;
	LZA #((3 * C_MANT) + 5) LZA_U0(
		.A_DI(A_LZA_D),
		.B_DI(B_LZA_D),
		.Leading_one_DO(Leading_one_D),
		.No_one_SO(No_one_S)
	);
	fpu_norm_fmac fpu_norm_U0(
		.Mant_in_DI(Sum_pos_D),
		.Exp_in_DI(Exp_postalig_D),
		.Sign_in_DI(Sign_out_D),
		.Leading_one_DI(Leading_one_D),
		.No_one_SI(No_one_S),
		.Sign_amt_DI(Sign_amt_D),
		.Sub_SI(Sub_S),
		.Exp_a_DI(Operand_a_DI[C_OP - 2:C_MANT]),
		.Mant_a_DI(Mant_a_D),
		.Sign_a_DI(Sign_a_D),
		.DeN_a_SI(DeN_a_S),
		.RM_SI(RM_SI),
		.Inf_a_SI(Inf_a_S),
		.Inf_b_SI(Inf_b_S),
		.Inf_c_SI(Inf_c_S),
		.Zero_a_SI(Zero_a_S),
		.Zero_b_SI(Zero_b_S),
		.Zero_c_SI(Zero_c_S),
		.NaN_a_SI(NaN_a_S),
		.NaN_b_SI(NaN_b_S),
		.NaN_c_SI(NaN_c_S),
		.Mant_res_DO(Mant_res_DO),
		.Exp_res_DO(Exp_res_DO),
		.Sign_res_DO(Sign_res_DO),
		.Exp_OF_SO(Exp_OF_SO),
		.Exp_UF_SO(Exp_UF_SO),
		.Flag_Inexact_SO(Exp_NX_SO)
	);
endmodule
