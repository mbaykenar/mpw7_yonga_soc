module fpu_core (
	Clk_CI,
	Rst_RBI,
	Enable_SI,
	Operand_a_DI,
	Operand_b_DI,
	RM_SI,
	OP_SI,
	Result_DO,
	Valid_SO,
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
	input wire Clk_CI;
	input wire Rst_RBI;
	input wire Enable_SI;
	input wire [C_OP - 1:0] Operand_a_DI;
	input wire [C_OP - 1:0] Operand_b_DI;
	input wire [C_RM - 1:0] RM_SI;
	input wire [C_CMD - 1:0] OP_SI;
	output wire [C_OP - 1:0] Result_DO;
	output wire Valid_SO;
	output wire OF_SO;
	output wire UF_SO;
	output wire Zero_SO;
	output wire IX_SO;
	output wire IV_SO;
	output wire Inf_SO;
	wire Sign_a_D;
	wire Sign_b_D;
	wire [C_EXP - 1:0] Exp_a_D;
	wire [C_EXP - 1:0] Exp_b_D;
	wire [C_MANT:0] Mant_a_D;
	wire [C_MANT:0] Mant_b_D;
	wire Hb_a_D;
	wire Hb_b_D;
	reg signed [C_EXP_PRENORM - 1:0] Exp_prenorm_D;
	reg [C_MANT_PRENORM - 1:0] Mant_prenorm_D;
	reg Sign_norm_D;
	wire [C_EXP - 1:0] Exp_norm_D;
	wire [C_MANT:0] Mant_norm_D;
	wire [C_OP - 1:0] Result_D;
	wire Sign_res_D;
	reg [C_EXP - 1:0] Exp_res_D;
	wire [C_MANT:0] Mant_res_D;
	reg [C_RM - 1:0] RM_SP;
	reg [C_CMD - 1:0] OP_SP;
	reg [C_OP - 1:0] Operand_a_DP;
	reg [C_OP - 1:0] Operand_b_DP;
	reg Enable_SP;
	always @(posedge Clk_CI or negedge Rst_RBI)
		if (~Rst_RBI) begin
			Operand_a_DP <= 1'sb0;
			Operand_b_DP <= 1'sb0;
			OP_SP <= 1'sb0;
			RM_SP <= 1'sb0;
			Enable_SP <= 1'sb0;
		end
		else begin
			Operand_a_DP <= Operand_a_DI;
			Operand_b_DP <= Operand_b_DI;
			OP_SP <= OP_SI;
			RM_SP <= RM_SI;
			Enable_SP <= Enable_SI;
		end
	assign Valid_SO = Enable_SP;
	assign Sign_a_D = Operand_a_DP[C_OP - 1];
	assign Sign_b_D = (OP_SP == C_FPU_SUB_CMD ? ~Operand_b_DP[C_OP - 1] : Operand_b_DP[C_OP - 1]);
	assign Exp_a_D = Operand_a_DP[C_OP - 2:C_MANT];
	assign Exp_b_D = Operand_b_DP[C_OP - 2:C_MANT];
	assign Mant_a_D = {Hb_a_D, Operand_a_DP[C_MANT - 1:0]};
	assign Mant_b_D = {Hb_b_D, Operand_b_DP[C_MANT - 1:0]};
	assign Hb_a_D = |Exp_a_D;
	assign Hb_b_D = |Exp_b_D;
	wire Sign_prenorm_add_D;
	wire signed [C_EXP_PRENORM - 1:0] Exp_prenorm_add_D;
	wire [C_MANT_PRENORM - 1:0] Mant_prenorm_add_D;
	wire EnableAdd_S;
	assign EnableAdd_S = Enable_SP & ((OP_SP == C_FPU_ADD_CMD) | (OP_SP == C_FPU_SUB_CMD));
	fpu_add adder(
		.Sign_a_DI((EnableAdd_S ? Sign_a_D : 1'b0)),
		.Sign_b_DI((EnableAdd_S ? Sign_b_D : 1'b0)),
		.Exp_a_DI((EnableAdd_S ? Exp_a_D : {C_EXP {1'sb0}})),
		.Exp_b_DI((EnableAdd_S ? Exp_b_D : {C_EXP {1'sb0}})),
		.Mant_a_DI((EnableAdd_S ? Mant_a_D : {(C_MANT >= 0 ? C_MANT + 1 : 1 - C_MANT) {1'sb0}})),
		.Mant_b_DI((EnableAdd_S ? Mant_b_D : {(C_MANT >= 0 ? C_MANT + 1 : 1 - C_MANT) {1'sb0}})),
		.Sign_prenorm_DO(Sign_prenorm_add_D),
		.Exp_prenorm_DO(Exp_prenorm_add_D),
		.Mant_prenorm_DO(Mant_prenorm_add_D)
	);
	wire Sign_prenorm_mult_D;
	wire signed [C_EXP_PRENORM - 1:0] Exp_prenorm_mult_D;
	wire [C_MANT_PRENORM - 1:0] Mant_prenorm_mult_D;
	wire EnableMult_S;
	assign EnableMult_S = Enable_SP & (OP_SP == C_FPU_MUL_CMD);
	fpu_mult multiplier(
		.Sign_a_DI((EnableMult_S ? Sign_a_D : 1'b0)),
		.Sign_b_DI((EnableMult_S ? Sign_b_D : 1'b0)),
		.Exp_a_DI((EnableMult_S ? Exp_a_D : {C_EXP {1'sb0}})),
		.Exp_b_DI((EnableMult_S ? Exp_b_D : {C_EXP {1'sb0}})),
		.Mant_a_DI((EnableMult_S ? Mant_a_D : {(C_MANT >= 0 ? C_MANT + 1 : 1 - C_MANT) {1'sb0}})),
		.Mant_b_DI((EnableMult_S ? Mant_b_D : {(C_MANT >= 0 ? C_MANT + 1 : 1 - C_MANT) {1'sb0}})),
		.Sign_prenorm_DO(Sign_prenorm_mult_D),
		.Exp_prenorm_DO(Exp_prenorm_mult_D),
		.Mant_prenorm_DO(Mant_prenorm_mult_D)
	);
	wire Sign_prenorm_itof_D;
	wire signed [C_EXP_PRENORM - 1:0] Exp_prenorm_itof_D;
	wire [C_MANT_PRENORM - 1:0] Mant_prenorm_itof_D;
	wire EnableITOF_S;
	assign EnableITOF_S = Enable_SP & (OP_SP == C_FPU_I2F_CMD);
	fpu_itof int2fp(
		.Operand_a_DI((EnableITOF_S ? Operand_a_DP : {C_OP {1'sb0}})),
		.Sign_prenorm_DO(Sign_prenorm_itof_D),
		.Exp_prenorm_DO(Exp_prenorm_itof_D),
		.Mant_prenorm_DO(Mant_prenorm_itof_D)
	);
	wire [C_OP - 1:0] Result_ftoi_D;
	wire UF_ftoi_S;
	wire OF_ftoi_S;
	wire Zero_ftoi_S;
	wire IX_ftoi_S;
	wire IV_ftoi_S;
	wire Inf_ftoi_S;
	wire EnableFTOI_S;
	assign EnableFTOI_S = Enable_SP & (OP_SP == C_FPU_F2I_CMD);
	fpu_ftoi fp2int(
		.Sign_a_DI((EnableFTOI_S ? Sign_a_D : 1'b0)),
		.Exp_a_DI((EnableFTOI_S ? Exp_a_D : {C_EXP {1'sb0}})),
		.Mant_a_DI((EnableFTOI_S ? Mant_a_D : {(C_MANT >= 0 ? C_MANT + 1 : 1 - C_MANT) {1'sb0}})),
		.Result_DO(Result_ftoi_D),
		.UF_SO(UF_ftoi_S),
		.OF_SO(OF_ftoi_S),
		.Zero_SO(Zero_ftoi_S),
		.IX_SO(IX_ftoi_S),
		.IV_SO(IV_ftoi_S),
		.Inf_SO(Inf_ftoi_S)
	);
	wire Mant_rounded_S;
	wire Exp_OF_S;
	wire Exp_UF_S;
	always @(*) begin
		Sign_norm_D = 1'sb0;
		Exp_prenorm_D = 1'sb0;
		Mant_prenorm_D = 1'sb0;
		case (OP_SP)
			C_FPU_ADD_CMD, C_FPU_SUB_CMD: begin
				Sign_norm_D = Sign_prenorm_add_D;
				Exp_prenorm_D = Exp_prenorm_add_D;
				Mant_prenorm_D = Mant_prenorm_add_D;
			end
			C_FPU_MUL_CMD: begin
				Sign_norm_D = Sign_prenorm_mult_D;
				Exp_prenorm_D = Exp_prenorm_mult_D;
				Mant_prenorm_D = Mant_prenorm_mult_D;
			end
			C_FPU_I2F_CMD: begin
				Sign_norm_D = Sign_prenorm_itof_D;
				Exp_prenorm_D = Exp_prenorm_itof_D;
				Mant_prenorm_D = Mant_prenorm_itof_D;
			end
		endcase
	end
	fpu_norm normalizer(
		.Mant_in_DI(Mant_prenorm_D),
		.Exp_in_DI(Exp_prenorm_D),
		.Sign_in_DI(Sign_norm_D),
		.RM_SI(RM_SP),
		.OP_SI(OP_SP),
		.Mant_res_DO(Mant_norm_D),
		.Exp_res_DO(Exp_norm_D),
		.Rounded_SO(Mant_rounded_S),
		.Exp_OF_SO(Exp_OF_S),
		.Exp_UF_SO(Exp_UF_S)
	);
	wire UF_S;
	wire OF_S;
	wire Zero_S;
	wire IX_S;
	wire IV_S;
	wire Inf_S;
	wire Exp_toZero_S;
	wire Exp_toInf_S;
	wire Mant_toZero_S;
	fpexc except(
		.Mant_a_DI(Mant_a_D),
		.Mant_b_DI(Mant_b_D),
		.Exp_a_DI(Exp_a_D),
		.Exp_b_DI(Exp_b_D),
		.Sign_a_DI(Sign_a_D),
		.Sign_b_DI(Sign_b_D),
		.Mant_norm_DI(Mant_norm_D),
		.Exp_res_DI(Exp_norm_D),
		.Op_SI(OP_SP),
		.UF_SI(UF_ftoi_S),
		.OF_SI(OF_ftoi_S),
		.Zero_SI(Zero_ftoi_S),
		.IX_SI(IX_ftoi_S),
		.IV_SI(IV_ftoi_S),
		.Inf_SI(Inf_ftoi_S),
		.Mant_rounded_SI(Mant_rounded_S),
		.Exp_OF_SI(Exp_OF_S),
		.Exp_UF_SI(Exp_UF_S),
		.Exp_toZero_SO(Exp_toZero_S),
		.Exp_toInf_SO(Exp_toInf_S),
		.Mant_toZero_SO(Mant_toZero_S),
		.UF_SO(UF_S),
		.OF_SO(OF_S),
		.Zero_SO(Zero_S),
		.IX_SO(IX_S),
		.IV_SO(IV_S),
		.Inf_SO(Inf_S)
	);
	assign Sign_res_D = (Zero_S ? 1'b0 : Sign_norm_D);
	always @(*) begin
		Exp_res_D = Exp_norm_D;
		if (Exp_toZero_S)
			Exp_res_D = C_EXP_ZERO;
		else if (Exp_toInf_S)
			Exp_res_D = C_EXP_INF;
	end
	assign Mant_res_D = (Mant_toZero_S ? C_MANT_ZERO : Mant_norm_D);
	assign Result_D = (IV_S ? F_QNAN : (OP_SP == C_FPU_F2I_CMD ? Result_ftoi_D : {Sign_res_D, Exp_res_D, Mant_res_D[C_MANT - 1:0]}));
	assign Result_DO = Result_D;
	assign UF_SO = UF_S;
	assign OF_SO = OF_S;
	assign Zero_SO = Zero_S;
	assign IX_SO = IX_S;
	assign IV_SO = IV_S;
	assign Inf_SO = Inf_S;
endmodule
