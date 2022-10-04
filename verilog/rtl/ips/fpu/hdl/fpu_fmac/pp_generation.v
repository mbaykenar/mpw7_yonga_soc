module pp_generation (
	Mant_a_DI,
	Mant_b_DI,
	Pp_index_DO
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
parameter C_FFLAG         = 5;
	input wire [C_MANT:0] Mant_a_DI;
	input wire [C_MANT:0] Mant_b_DI;
	output wire [(((2 * C_MANT) + 2) >= 0 ? (13 * ((2 * C_MANT) + 3)) - 1 : (13 * (1 - ((2 * C_MANT) + 2))) + ((2 * C_MANT) + 1)):(((2 * C_MANT) + 2) >= 0 ? 0 : (2 * C_MANT) + 2)] Pp_index_DO;
	wire Sel_xnor_S;
	wire [C_MANT + 5:0] Mant_b_D;
	assign Mant_b_D = {2'b00, Mant_b_DI, 2'b00};
	wire [12:0] Sel_1x_S;
	wire [12:0] Sel_2x_S;
	wire [12:0] Sel_sign_S;
	genvar i;
	generate
		for (i = 1; i <= 13; i = i + 1) begin : genblk1
			booth_encoder booth_encoding(
				.Booth_b_DI(Mant_b_D[(2 * i) + 1:(2 * i) - 1]),
				.Sel_1x_SO(Sel_1x_S[i - 1]),
				.Sel_2x_SO(Sel_2x_S[i - 1]),
				.Sel_sign_SO(Sel_sign_S[i - 1])
			);
		end
	endgenerate
	wire [C_MANT + 2:0] Mant_a_D;
	assign Mant_a_D = {Mant_a_DI, 1'b0};
	wire [((C_MANT + 1) >= 0 ? (13 * (C_MANT + 2)) - 1 : (13 * (1 - (C_MANT + 1))) + C_MANT):((C_MANT + 1) >= 0 ? 0 : C_MANT + 1)] Booth_pp_D;
	genvar l;
	genvar j;
	generate
		for (l = 1; l <= 13; l = l + 1) begin : genblk2
			for (j = 1; j <= (C_MANT + 2); j = j + 1) begin : genblk1
				booth_selector booth_selection(
					.Booth_a_DI(Mant_a_D[j:j - 1]),
					.Sel_1x_SI(Sel_1x_S[l - 1]),
					.Sel_2x_SI(Sel_2x_S[l - 1]),
					.Sel_sign_SI(Sel_sign_S[l - 1]),
					.Booth_pp_DO(Booth_pp_D[((l - 1) * ((C_MANT + 1) >= 0 ? C_MANT + 2 : 1 - (C_MANT + 1))) + ((C_MANT + 1) >= 0 ? j - 1 : (C_MANT + 1) - (j - 1))])
				);
			end
		end
	endgenerate
	assign Pp_index_DO[(((2 * C_MANT) + 2) >= 0 ? 0 : (2 * C_MANT) + 2)+:(((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2))] = {21'h000000, ~Sel_sign_S[0], Sel_sign_S[0], Sel_sign_S[0], Booth_pp_D[((C_MANT + 1) >= 0 ? 0 : C_MANT + 1)+:((C_MANT + 1) >= 0 ? C_MANT + 2 : 1 - (C_MANT + 1))]};
	assign Pp_index_DO[(((2 * C_MANT) + 2) >= 0 ? 0 : (2 * C_MANT) + 2) + (((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2))+:(((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2))] = {21'b000000000000000000001, ~Sel_sign_S[1], Booth_pp_D[((C_MANT + 1) >= 0 ? 0 : C_MANT + 1) + ((C_MANT + 1) >= 0 ? C_MANT + 2 : 1 - (C_MANT + 1))+:((C_MANT + 1) >= 0 ? C_MANT + 2 : 1 - (C_MANT + 1))], 1'b0, Sel_sign_S[0]};
	assign Pp_index_DO[(((2 * C_MANT) + 2) >= 0 ? 0 : (2 * C_MANT) + 2) + (2 * (((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2)))+:(((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2))] = {19'b0000000000000000001, ~Sel_sign_S[2], Booth_pp_D[((C_MANT + 1) >= 0 ? 0 : C_MANT + 1) + (2 * ((C_MANT + 1) >= 0 ? C_MANT + 2 : 1 - (C_MANT + 1)))+:((C_MANT + 1) >= 0 ? C_MANT + 2 : 1 - (C_MANT + 1))], 1'b0, Sel_sign_S[1], 2'h0};
	assign Pp_index_DO[(((2 * C_MANT) + 2) >= 0 ? 0 : (2 * C_MANT) + 2) + (3 * (((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2)))+:(((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2))] = {17'b00000000000000001, ~Sel_sign_S[3], Booth_pp_D[((C_MANT + 1) >= 0 ? 0 : C_MANT + 1) + (3 * ((C_MANT + 1) >= 0 ? C_MANT + 2 : 1 - (C_MANT + 1)))+:((C_MANT + 1) >= 0 ? C_MANT + 2 : 1 - (C_MANT + 1))], 1'b0, Sel_sign_S[2], 4'h0};
	assign Pp_index_DO[(((2 * C_MANT) + 2) >= 0 ? 0 : (2 * C_MANT) + 2) + (4 * (((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2)))+:(((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2))] = {15'b000000000000001, ~Sel_sign_S[4], Booth_pp_D[((C_MANT + 1) >= 0 ? 0 : C_MANT + 1) + (4 * ((C_MANT + 1) >= 0 ? C_MANT + 2 : 1 - (C_MANT + 1)))+:((C_MANT + 1) >= 0 ? C_MANT + 2 : 1 - (C_MANT + 1))], 1'b0, Sel_sign_S[3], 6'h00};
	assign Pp_index_DO[(((2 * C_MANT) + 2) >= 0 ? 0 : (2 * C_MANT) + 2) + (5 * (((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2)))+:(((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2))] = {13'b0000000000001, ~Sel_sign_S[5], Booth_pp_D[((C_MANT + 1) >= 0 ? 0 : C_MANT + 1) + (5 * ((C_MANT + 1) >= 0 ? C_MANT + 2 : 1 - (C_MANT + 1)))+:((C_MANT + 1) >= 0 ? C_MANT + 2 : 1 - (C_MANT + 1))], 1'b0, Sel_sign_S[4], 8'h00};
	assign Pp_index_DO[(((2 * C_MANT) + 2) >= 0 ? 0 : (2 * C_MANT) + 2) + (6 * (((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2)))+:(((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2))] = {11'b00000000001, ~Sel_sign_S[6], Booth_pp_D[((C_MANT + 1) >= 0 ? 0 : C_MANT + 1) + (6 * ((C_MANT + 1) >= 0 ? C_MANT + 2 : 1 - (C_MANT + 1)))+:((C_MANT + 1) >= 0 ? C_MANT + 2 : 1 - (C_MANT + 1))], 1'b0, Sel_sign_S[5], 10'h000};
	assign Pp_index_DO[(((2 * C_MANT) + 2) >= 0 ? 0 : (2 * C_MANT) + 2) + (7 * (((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2)))+:(((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2))] = {9'b000000001, ~Sel_sign_S[7], Booth_pp_D[((C_MANT + 1) >= 0 ? 0 : C_MANT + 1) + (7 * ((C_MANT + 1) >= 0 ? C_MANT + 2 : 1 - (C_MANT + 1)))+:((C_MANT + 1) >= 0 ? C_MANT + 2 : 1 - (C_MANT + 1))], 1'b0, Sel_sign_S[6], 12'h000};
	assign Pp_index_DO[(((2 * C_MANT) + 2) >= 0 ? 0 : (2 * C_MANT) + 2) + (8 * (((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2)))+:(((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2))] = {7'b0000001, ~Sel_sign_S[8], Booth_pp_D[((C_MANT + 1) >= 0 ? 0 : C_MANT + 1) + (8 * ((C_MANT + 1) >= 0 ? C_MANT + 2 : 1 - (C_MANT + 1)))+:((C_MANT + 1) >= 0 ? C_MANT + 2 : 1 - (C_MANT + 1))], 1'b0, Sel_sign_S[7], 14'h0000};
	assign Pp_index_DO[(((2 * C_MANT) + 2) >= 0 ? 0 : (2 * C_MANT) + 2) + (9 * (((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2)))+:(((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2))] = {5'b00001, ~Sel_sign_S[9], Booth_pp_D[((C_MANT + 1) >= 0 ? 0 : C_MANT + 1) + (9 * ((C_MANT + 1) >= 0 ? C_MANT + 2 : 1 - (C_MANT + 1)))+:((C_MANT + 1) >= 0 ? C_MANT + 2 : 1 - (C_MANT + 1))], 1'b0, Sel_sign_S[8], 16'h0000};
	assign Pp_index_DO[(((2 * C_MANT) + 2) >= 0 ? 0 : (2 * C_MANT) + 2) + (10 * (((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2)))+:(((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2))] = {3'b001, ~Sel_sign_S[10], Booth_pp_D[((C_MANT + 1) >= 0 ? 0 : C_MANT + 1) + (10 * ((C_MANT + 1) >= 0 ? C_MANT + 2 : 1 - (C_MANT + 1)))+:((C_MANT + 1) >= 0 ? C_MANT + 2 : 1 - (C_MANT + 1))], 1'b0, Sel_sign_S[9], 18'h00000};
	assign Pp_index_DO[(((2 * C_MANT) + 2) >= 0 ? 0 : (2 * C_MANT) + 2) + (11 * (((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2)))+:(((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2))] = {1'b1, ~Sel_sign_S[11], Booth_pp_D[((C_MANT + 1) >= 0 ? 0 : C_MANT + 1) + (11 * ((C_MANT + 1) >= 0 ? C_MANT + 2 : 1 - (C_MANT + 1)))+:((C_MANT + 1) >= 0 ? C_MANT + 2 : 1 - (C_MANT + 1))], 1'b0, Sel_sign_S[10], 20'h00000};
	assign Pp_index_DO[(((2 * C_MANT) + 2) >= 0 ? 0 : (2 * C_MANT) + 2) + (12 * (((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2)))+:(((2 * C_MANT) + 2) >= 0 ? (2 * C_MANT) + 3 : 1 - ((2 * C_MANT) + 2))] = {Booth_pp_D[((C_MANT + 1) >= 0 ? 0 : C_MANT + 1) + (12 * ((C_MANT + 1) >= 0 ? C_MANT + 2 : 1 - (C_MANT + 1)))+:((C_MANT + 1) >= 0 ? C_MANT + 2 : 1 - (C_MANT + 1))], 1'b0, Sel_sign_S[11], 22'h000000};
endmodule
