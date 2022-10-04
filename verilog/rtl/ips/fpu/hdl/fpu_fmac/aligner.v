`include "fpu_defs_fmac.sv"

module aligner (
	Exp_a_DI,
	Exp_b_DI,
	Exp_c_DI,
	Mant_a_DI,
	Sign_a_DI,
	Sign_b_DI,
	Sign_c_DI,
	Pp_sum_DI,
	Pp_carry_DI,
	Sub_SO,
	Mant_postalig_a_DO,
	Exp_postalig_DO,
	Sign_postalig_DO,
	Sign_amt_DO,
	Sft_stop_SO,
	Pp_sum_postcal_DO,
	Pp_carry_postcal_DO
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
	input wire [C_EXP - 1:0] Exp_a_DI;
	input wire [C_EXP - 1:0] Exp_b_DI;
	input wire [C_EXP - 1:0] Exp_c_DI;
	input wire [C_MANT:0] Mant_a_DI;
	input wire Sign_a_DI;
	input wire Sign_b_DI;
	input wire Sign_c_DI;
	input wire [(2 * C_MANT) + 2:0] Pp_sum_DI;
	input wire [(2 * C_MANT) + 2:0] Pp_carry_DI;
	output wire Sub_SO;
	output wire [74:0] Mant_postalig_a_DO;
	output wire [C_EXP + 1:0] Exp_postalig_DO;
	output wire Sign_postalig_DO;
	output wire Sign_amt_DO;
	output wire Sft_stop_SO;
	output wire [(2 * C_MANT) + 2:0] Pp_sum_postcal_DO;
	output wire [(2 * C_MANT) + 2:0] Pp_carry_postcal_DO;
	wire [C_EXP + 1:0] Exp_dif_D;
	wire [C_EXP + 1:0] Sft_amt_D;
	assign Sub_SO = (Sign_a_DI ^ Sign_b_DI) ^ Sign_c_DI;
	assign Exp_dif_D = ((Exp_a_DI - Exp_b_DI) - Exp_c_DI) + C_BIAS;
	assign Sft_amt_D = (((Exp_b_DI + Exp_c_DI) - Exp_a_DI) - C_BIAS) + 27;
	assign Sign_amt_DO = Sft_amt_D[C_EXP + 1];
	wire Sft_stop_S;
	assign Sft_stop_S = ~Sft_amt_D[C_EXP + 1] && (Sft_amt_D[C_EXP:0] >= 74);
	assign Sft_stop_SO = Sft_stop_S;
	function automatic [0:0] sv2v_cast_1;
		input reg [0:0] inp;
		sv2v_cast_1 = inp;
	endfunction
	assign Exp_postalig_DO = (Sft_amt_D[C_EXP + 1] ? Exp_a_DI : {sv2v_cast_1(((Exp_b_DI + Exp_c_DI) - C_BIAS) + 27)});
	wire [73:0] Mant_postalig_a_D;
	wire [C_MANT:0] Bit_sftout_D;
	assign {Mant_postalig_a_D, Bit_sftout_D} = {Mant_a_DI, 74'h0000000000000000000} >> {(Sft_stop_S ? 0 : Sft_amt_D)};
	assign Mant_postalig_a_DO = (Sft_amt_D[C_EXP + 1] ? {1'b0, Mant_a_DI, 50'h0000000000000} : {(Sft_stop_S ? 75'h0000000000000000000 : {(Sub_SO ? {1'b1, ~Mant_postalig_a_D} : {1'b0, Mant_postalig_a_D})})});
	assign Sign_postalig_DO = (Sft_amt_D[C_EXP + 1] ? Sign_a_DI : Sign_b_DI ^ Sign_c_DI);
	assign Pp_sum_postcal_DO = (Sft_amt_D[C_EXP + 1] ? {(((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2)) {1'sb0}} : Pp_sum_DI);
	assign Pp_carry_postcal_DO = (Sft_amt_D[C_EXP + 1] ? {(((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2)) {1'sb0}} : Pp_carry_DI);
endmodule
