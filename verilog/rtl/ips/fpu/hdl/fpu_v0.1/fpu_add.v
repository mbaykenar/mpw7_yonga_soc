module fpu_add (
	Sign_a_DI,
	Sign_b_DI,
	Exp_a_DI,
	Exp_b_DI,
	Mant_a_DI,
	Mant_b_DI,
	Sign_prenorm_DO,
	Exp_prenorm_DO,
	Mant_prenorm_DO
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
	input wire Sign_b_DI;
	input wire [C_EXP - 1:0] Exp_a_DI;
	input wire [C_EXP - 1:0] Exp_b_DI;
	input wire [C_MANT:0] Mant_a_DI;
	input wire [C_MANT:0] Mant_b_DI;
	output wire Sign_prenorm_DO;
	output wire signed [C_EXP_PRENORM - 1:0] Exp_prenorm_DO;
	output wire [C_MANT_PRENORM - 1:0] Mant_prenorm_DO;
	wire Sign_a_D;
	wire Sign_b_D;
	wire [C_EXP - 1:0] Exp_a_D;
	wire [C_EXP - 1:0] Exp_b_D;
	wire [C_MANT:0] Mant_a_D;
	wire [C_MANT:0] Mant_b_D;
	reg Sign_norm_D;
	assign Sign_a_D = Sign_a_DI;
	assign Sign_b_D = Sign_b_DI;
	assign Exp_a_D = Exp_a_DI;
	assign Exp_b_D = Exp_b_DI;
	assign Mant_a_D = Mant_a_DI;
	assign Mant_b_D = Mant_b_DI;
	wire Exp_agtb_S;
	wire Exp_equal_S;
	reg [C_EXP - 1:0] Exp_diff_D;
	reg [C_EXP - 1:0] Exp_prenorm_D;
	assign Exp_agtb_S = Exp_a_D > Exp_b_D;
	assign Exp_equal_S = Exp_diff_D == 0;
	always @(*)
		if (Exp_agtb_S) begin
			Exp_diff_D = Exp_a_D - Exp_b_D;
			Exp_prenorm_D = Exp_a_D;
		end
		else begin
			Exp_diff_D = Exp_b_D - Exp_a_D;
			Exp_prenorm_D = Exp_b_D;
		end
	wire Mant_agtb_S;
	wire [C_MANT_SHIFTIN - 1:0] Mant_shiftIn_D;
	wire [C_MANT_SHIFTED - 1:0] Mant_shifted_D;
	reg Mant_sticky_D;
	wire [C_MANT_SHIFTED - 1:0] Mant_unshifted_D;
	wire [C_MANT_ADDIN - 1:0] Mant_addInA_D;
	wire [C_MANT_ADDIN - 1:0] Mant_addInB_D;
	wire [C_MANT_ADDOUT - 1:0] Mant_addOut_D;
	wire [C_MANT_PRENORM - 1:0] Mant_prenorm_D;
	wire Mant_addCarryIn_D;
	reg Mant_invA_S;
	reg Mant_invB_S;
	wire Subtract_S;
	assign Mant_agtb_S = Mant_a_D > Mant_b_D;
	assign Mant_unshifted_D = {(Exp_agtb_S ? Mant_a_D : Mant_b_D), 3'b000};
	assign Mant_shiftIn_D = {(Exp_agtb_S ? Mant_b_D : Mant_a_D), 2'b00};
	always @(*) begin
		Mant_sticky_D = 1'b0;
		if (Exp_diff_D >= (C_MANT + 3))
			Mant_sticky_D = |Mant_shiftIn_D;
		else
			Mant_sticky_D = |(Mant_shiftIn_D << ((C_MANT + 3) - Exp_diff_D));
	end
	assign Mant_shifted_D = {Mant_shiftIn_D >> Exp_diff_D, Mant_sticky_D};
	always @(*) begin
		Mant_invA_S = 1'sb0;
		Mant_invB_S = 1'sb0;
		if (Subtract_S)
			if (Exp_agtb_S)
				Mant_invA_S = 1'b1;
			else if (Exp_equal_S) begin
				if (Mant_agtb_S)
					Mant_invB_S = 1'b1;
				else
					Mant_invA_S = 1'b1;
			end
			else
				Mant_invA_S = 1'b1;
	end
	assign Mant_addCarryIn_D = Subtract_S;
	assign Mant_addInA_D = (Mant_invA_S ? ~Mant_shifted_D : Mant_shifted_D);
	assign Mant_addInB_D = (Mant_invB_S ? ~Mant_unshifted_D : Mant_unshifted_D);
	assign Mant_addOut_D = (Mant_addInA_D + Mant_addInB_D) + Mant_addCarryIn_D;
	assign Mant_prenorm_D = {Mant_addOut_D[C_MANT_ADDOUT - 1] & ~Subtract_S, Mant_addOut_D[C_MANT_ADDOUT - 2:0], 20'b00000000000000000000};
	assign Subtract_S = Sign_a_D ^ Sign_b_D;
	always @(*) begin
		Sign_norm_D = 1'b0;
		if (Exp_agtb_S)
			Sign_norm_D = Sign_a_D;
		else if (Exp_equal_S) begin
			if (Mant_agtb_S)
				Sign_norm_D = Sign_a_D;
			else
				Sign_norm_D = Sign_b_D;
		end
		else
			Sign_norm_D = Sign_b_D;
	end
	assign Sign_prenorm_DO = Sign_norm_D;
	assign Exp_prenorm_DO = $signed({2'b00, Exp_prenorm_D});
	assign Mant_prenorm_DO = Mant_prenorm_D;
endmodule
