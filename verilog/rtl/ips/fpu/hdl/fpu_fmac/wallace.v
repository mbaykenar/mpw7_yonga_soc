module wallace (
	Pp_index_DI,
	Pp_sum_DO,
	Pp_carry_DO,
	MSB_cor_DO
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
	input wire [(((2 * C_MANT) + 2) >= 0 ? (13 * ((2 * C_MANT) + 3)) - 1 : (13 * (1 - ((2 * C_MANT) + 2))) + ((2 * C_MANT) + 1)):(((2 * C_MANT) + 2) >= 0 ? 0 : (2 * C_MANT) + 2)] Pp_index_DI;
	output wire [(2 * C_MANT) + 2:0] Pp_sum_DO;
	output wire [(2 * C_MANT) + 2:0] Pp_carry_DO;
	output wire MSB_cor_DO;
	wire [(2 * C_MANT) + 2:0] CSA_u0_Sum_DI;
	wire [(2 * C_MANT) + 2:0] CSA_u0_Carry_DI;
	wire [(2 * C_MANT) + 2:0] CSA_u1_Sum_DI;
	wire [(2 * C_MANT) + 2:0] CSA_u1_Carry_DI;
	wire [(2 * C_MANT) + 2:0] CSA_u2_Sum_DI;
	wire [(2 * C_MANT) + 2:0] CSA_u2_Carry_DI;
	wire [(2 * C_MANT) + 2:0] CSA_u3_Sum_DI;
	wire [(2 * C_MANT) + 2:0] CSA_u3_Carry_DI;
	wire [(2 * C_MANT) + 2:0] CSA_u4_Sum_DI;
	wire [(2 * C_MANT) + 2:0] CSA_u4_Carry_DI;
	wire [(2 * C_MANT) + 2:0] CSA_u5_Sum_DI;
	wire [(2 * C_MANT) + 2:0] CSA_u5_Carry_DI;
	wire [(2 * C_MANT) + 2:0] CSA_u6_Sum_DI;
	wire [(2 * C_MANT) + 2:0] CSA_u6_Carry_DI;
	wire [(2 * C_MANT) + 2:0] CSA_u7_Sum_DI;
	wire [(2 * C_MANT) + 2:0] CSA_u7_Carry_DI;
	wire [(2 * C_MANT) + 2:0] CSA_u8_Sum_DI;
	wire [(2 * C_MANT) + 2:0] CSA_u8_Carry_DI;
	wire [(2 * C_MANT) + 2:0] CSA_u9_Sum_DI;
	wire [(2 * C_MANT) + 2:0] CSA_u9_Carry_DI;
	CSA #((2 * C_MANT) + 3) CSA_U0(
		.A_DI(Pp_index_DI[(((2 * C_MANT) + 2) >= 0 ? 0 : (2 * C_MANT) + 2)+:(((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2))]),
		.B_DI(Pp_index_DI[(((2 * C_MANT) + 2) >= 0 ? 0 : (2 * C_MANT) + 2) + (((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2))+:(((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2))]),
		.C_DI(Pp_index_DI[(((2 * C_MANT) + 2) >= 0 ? 0 : (2 * C_MANT) + 2) + (2 * (((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2)))+:(((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2))]),
		.Sum_DO(CSA_u0_Sum_DI),
		.Carry_DO(CSA_u0_Carry_DI)
	);
	CSA #((2 * C_MANT) + 3) CSA_U1(
		.A_DI(Pp_index_DI[(((2 * C_MANT) + 2) >= 0 ? 0 : (2 * C_MANT) + 2) + (3 * (((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2)))+:(((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2))]),
		.B_DI(Pp_index_DI[(((2 * C_MANT) + 2) >= 0 ? 0 : (2 * C_MANT) + 2) + (4 * (((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2)))+:(((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2))]),
		.C_DI(Pp_index_DI[(((2 * C_MANT) + 2) >= 0 ? 0 : (2 * C_MANT) + 2) + (5 * (((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2)))+:(((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2))]),
		.Sum_DO(CSA_u1_Sum_DI),
		.Carry_DO(CSA_u1_Carry_DI)
	);
	CSA #((2 * C_MANT) + 3) CSA_U2(
		.A_DI(Pp_index_DI[(((2 * C_MANT) + 2) >= 0 ? 0 : (2 * C_MANT) + 2) + (6 * (((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2)))+:(((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2))]),
		.B_DI(Pp_index_DI[(((2 * C_MANT) + 2) >= 0 ? 0 : (2 * C_MANT) + 2) + (7 * (((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2)))+:(((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2))]),
		.C_DI(Pp_index_DI[(((2 * C_MANT) + 2) >= 0 ? 0 : (2 * C_MANT) + 2) + (8 * (((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2)))+:(((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2))]),
		.Sum_DO(CSA_u2_Sum_DI),
		.Carry_DO(CSA_u2_Carry_DI)
	);
	CSA #((2 * C_MANT) + 3) CSA_U3(
		.A_DI(Pp_index_DI[(((2 * C_MANT) + 2) >= 0 ? 0 : (2 * C_MANT) + 2) + (9 * (((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2)))+:(((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2))]),
		.B_DI(Pp_index_DI[(((2 * C_MANT) + 2) >= 0 ? 0 : (2 * C_MANT) + 2) + (10 * (((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2)))+:(((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2))]),
		.C_DI(Pp_index_DI[(((2 * C_MANT) + 2) >= 0 ? 0 : (2 * C_MANT) + 2) + (11 * (((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2)))+:(((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2))]),
		.Sum_DO(CSA_u3_Sum_DI),
		.Carry_DO(CSA_u3_Carry_DI)
	);
	CSA #((2 * C_MANT) + 3) CSA_U4(
		.A_DI(CSA_u0_Sum_DI),
		.B_DI({CSA_u0_Carry_DI[(2 * C_MANT) + 1:0], 1'b0}),
		.C_DI(CSA_u1_Sum_DI),
		.Sum_DO(CSA_u4_Sum_DI),
		.Carry_DO(CSA_u4_Carry_DI)
	);
	CSA #((2 * C_MANT) + 3) CSA_U5(
		.A_DI({CSA_u1_Carry_DI[(2 * C_MANT) + 1:0], 1'b0}),
		.B_DI({CSA_u2_Carry_DI[(2 * C_MANT) + 1:0], 1'b0}),
		.C_DI(CSA_u2_Sum_DI),
		.Sum_DO(CSA_u5_Sum_DI),
		.Carry_DO(CSA_u5_Carry_DI)
	);
	CSA #((2 * C_MANT) + 3) CSA_U6(
		.A_DI(CSA_u3_Sum_DI),
		.B_DI({CSA_u3_Carry_DI[(2 * C_MANT) + 1:0], 1'b0}),
		.C_DI(CSA_u4_Sum_DI),
		.Sum_DO(CSA_u6_Sum_DI),
		.Carry_DO(CSA_u6_Carry_DI)
	);
	CSA #((2 * C_MANT) + 3) CSA_U7(
		.A_DI({CSA_u4_Carry_DI[(2 * C_MANT) + 1:0], 1'b0}),
		.B_DI({CSA_u5_Carry_DI[(2 * C_MANT) + 1:0], 1'b0}),
		.C_DI(CSA_u5_Sum_DI),
		.Sum_DO(CSA_u7_Sum_DI),
		.Carry_DO(CSA_u7_Carry_DI)
	);
	CSA #((2 * C_MANT) + 3) CSA_U8(
		.A_DI(CSA_u6_Sum_DI),
		.B_DI({CSA_u6_Carry_DI[(2 * C_MANT) + 1:0], 1'b0}),
		.C_DI(CSA_u7_Sum_DI),
		.Sum_DO(CSA_u8_Sum_DI),
		.Carry_DO(CSA_u8_Carry_DI)
	);
	CSA #((2 * C_MANT) + 3) CSA_U9(
		.A_DI({CSA_u7_Carry_DI[(2 * C_MANT) + 1:0], 1'b0}),
		.B_DI({CSA_u8_Carry_DI[(2 * C_MANT) + 1:0], 1'b0}),
		.C_DI(CSA_u8_Sum_DI),
		.Sum_DO(CSA_u9_Sum_DI),
		.Carry_DO(CSA_u9_Carry_DI)
	);
	CSA #((2 * C_MANT) + 3) CSA_U10(
		.A_DI(CSA_u9_Sum_DI),
		.B_DI({CSA_u9_Carry_DI[(2 * C_MANT) + 1:0], 1'b0}),
		.C_DI(Pp_index_DI[(((2 * C_MANT) + 2) >= 0 ? 0 : (2 * C_MANT) + 2) + (12 * (((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2)))+:(((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2))]),
		.Sum_DO(Pp_sum_DO),
		.Carry_DO(Pp_carry_DO)
	);
	assign MSB_cor_DO = (((((CSA_u9_Carry_DI[(2 * C_MANT) + 2] | CSA_u8_Carry_DI[(2 * C_MANT) + 2]) | CSA_u7_Carry_DI[(2 * C_MANT) + 2]) | CSA_u6_Carry_DI[(2 * C_MANT) + 2]) | CSA_u5_Carry_DI[(2 * C_MANT) + 2]) | CSA_u4_Carry_DI[(2 * C_MANT) + 2]) | CSA_u3_Carry_DI[(2 * C_MANT) + 2];
endmodule
