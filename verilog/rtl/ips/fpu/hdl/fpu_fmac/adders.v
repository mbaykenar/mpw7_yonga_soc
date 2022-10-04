`include "fpu_defs_fmac.sv"

module adders (
	AL_DI,
	BL_DI,
	Sub_SI,
	Sign_cor_SI,
	Sign_amt_DI,
	Sft_stop_SI,
	BH_DI,
	Sign_postalig_DI,
	Sum_pos_DO,
	Sign_out_DO,
	A_LZA_DO,
	B_LZA_DO
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
	input wire [(2 * C_MANT) + 1:0] AL_DI;
	input wire [(2 * C_MANT) + 1:0] BL_DI;
	input wire Sub_SI;
	input wire [2:0] Sign_cor_SI;
	input wire Sign_amt_DI;
	input wire Sft_stop_SI;
	input wire [C_MANT + 3:0] BH_DI;
	input wire Sign_postalig_DI;
	output wire [(3 * C_MANT) + 4:0] Sum_pos_DO;
	output wire Sign_out_DO;
	output wire [(3 * C_MANT) + 4:0] A_LZA_DO;
	output wire [(3 * C_MANT) + 4:0] B_LZA_DO;
	wire Carry_postcor_D;
	assign Carry_postcor_D = (Sign_amt_DI ? 1'b0 : {~(|Sign_cor_SI) ^ BL_DI[(2 * C_MANT) + 1]});
	wire Carry_uninv_LS;
	wire [(2 * C_MANT) + 1:0] Sum_uninv_LD;
	assign {Carry_uninv_LS, Sum_uninv_LD} = {1'b0, AL_DI} + {Carry_postcor_D, BL_DI[2 * C_MANT:0], Sub_SI};
	wire Carry_inv_LS;
	wire [(2 * C_MANT) + 2:0] Sum_inv_LD;
	assign {Carry_inv_LS, Sum_inv_LD} = ({1'b1, ~AL_DI, 1'b1} + {~Carry_postcor_D, ~BL_DI[2 * C_MANT:0], 2'b11}) + 2;
	wire [C_MANT + 3:0] BH_inv_D;
	wire [C_MANT + 3:0] Sum_uninv_HD;
	wire [C_MANT + 3:0] Sum_inv_HD;
	assign BH_inv_D = ~BH_DI;
	assign {Carryout_uninv_HS, Sum_uninv_HD} = (Carry_uninv_LS ? {BH_DI + 1} : BH_DI);
	assign {Carryout_inv_HS, Sum_inv_HD} = (Carry_inv_LS ? BH_inv_D : {BH_inv_D - 1});
	assign Sum_pos_DO = (Sft_stop_SI ? {26'h0000000, Sum_uninv_LD[(2 * C_MANT) + 1:0]} : {(Sign_amt_DI ? {BH_DI[C_MANT + 2:0], 48'b000000000000000000000000000000000000000000000000} : {(Sum_uninv_HD[C_MANT + 3] ? {Sum_inv_HD[C_MANT + 2:0], Sum_inv_LD[(2 * C_MANT) + 2:1]} : {Sum_uninv_HD[C_MANT + 2:0], Sum_uninv_LD})})});
	assign Sign_out_DO = (Sign_amt_DI ? Sign_postalig_DI : Sum_uninv_HD[C_MANT + 3] ^ Sign_postalig_DI);
	assign A_LZA_DO = (Sign_amt_DI ? {BH_DI[C_MANT + 2:0], 48'b000000000000000000000000000000000000000000000000} : {BH_DI[C_MANT + 2:0], 48'b000000000000000000000000000000000000000000000000});
	assign B_LZA_DO = (Sign_amt_DI ? 74'h0000000000000000000 : {25'h0000000, Carry_uninv_LS, Sum_uninv_LD});
endmodule
