module fpu (
	Clk_CI,
	Rst_RBI,
	Operand_a_DI,
	Operand_b_DI,
	RM_SI,
	OP_SI,
	Enable_SI,
	Stall_SI,
	Result_DO,
	OF_SO,
	UF_SO,
	Zero_SO,
	IX_SO,
	IV_SO,
	Inf_SO
);
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

parameter C_RM           = 3;
parameter C_RM_NEAREST   = 3'h0;
parameter C_RM_TRUNC     = 3'h1;
parameter C_RM_PLUSINF   = 3'h3;
parameter C_RM_MINUSINF  = 3'h2;
parameter C_RM_NEAREST_MAX = 3'h4;

parameter C_PC           = 5;

parameter C_OP           = 32;
parameter C_MANT         = 23;
parameter C_EXP          = 8;

parameter C_EXP_PRENORM  = C_EXP+2;
parameter C_MANT_PRENORM = C_MANT*2+2;
parameter C_MANT_ADDIN   = C_MANT+4;
parameter C_MANT_ADDOUT  = C_MANT+5;
parameter C_MANT_SHIFTIN = C_MANT+3;
parameter C_MANT_SHIFTED = C_MANT+4;
parameter C_MANT_INT     = C_OP-1;
parameter C_INF          = 32'h7fffffff;
parameter C_MINF         = 32'h80000000;
parameter C_EXP_SHIFT    = C_EXP_PRENORM;
parameter C_SHIFT_BIAS   = 9'd127;
parameter C_BIAS         = 10'd127;
parameter C_UNKNOWN      = 8'd157;
parameter C_PADMANT      = 16'b0;
parameter C_EXP_ZERO     = 8'h00;
parameter C_EXP_INF      = 8'hff;
parameter C_MANT_ZERO    = 24'h0;
parameter C_MANT_NoHB_ZERO   = 23'h0;
parameter C_MANT_PRENORM_IND = 6;
parameter F_QNAN         =32'h7FC00000;

	input wire Clk_CI;
	input wire Rst_RBI;
	input wire [C_OP - 1:0] Operand_a_DI;
	input wire [C_OP - 1:0] Operand_b_DI;
	input wire [C_RM - 1:0] RM_SI;
	input wire [C_CMD - 1:0] OP_SI;
	input wire Enable_SI;
	input wire Stall_SI;
	output wire [C_OP - 1:0] Result_DO;
	output wire OF_SO;
	output wire UF_SO;
	output wire Zero_SO;
	output wire IX_SO;
	output wire IV_SO;
	output wire Inf_SO;
	reg [C_OP - 1:0] Operand_a_D;
	reg [C_OP - 1:0] Operand_b_D;
	reg [C_RM - 1:0] RM_S;
	reg [C_CMD - 1:0] OP_S;
	wire Stall_S;
	always @(posedge Clk_CI or negedge Rst_RBI)
		if (~Rst_RBI) begin
			Operand_a_D <= 1'sb0;
			Operand_b_D <= 1'sb0;
			RM_S <= 1'sb0;
			OP_S <= 1'sb0;
		end
		else if (~Stall_SI) begin
			Operand_a_D <= Operand_a_DI;
			Operand_b_D <= Operand_b_DI;
			RM_S <= RM_SI;
			OP_S <= OP_SI;
		end
	wire UF_S;
	wire OF_S;
	wire Zero_S;
	wire IX_S;
	wire IV_S;
	wire Inf_S;
	wire [C_OP - 1:0] Result_D;
	fpu_core fpcore(
		.Clk_CI(Clk_CI),
		.Rst_RBI(Rst_RBI),
		.Enable_SI(Enable_SI),
		.Operand_a_DI(Operand_a_D),
		.Operand_b_DI(Operand_b_D),
		.RM_SI(RM_S),
		.OP_SI(OP_S),
		.Stall_SI(Stall_SI),
		.Result_DO(Result_D),
		.OF_SO(OF_S),
		.UF_SO(UF_S),
		.Zero_SO(Zero_S),
		.IX_SO(IX_S),
		.IV_SO(IV_S),
		.Inf_SO(Inf_S)
	);
	assign Result_DO = Result_D;
	assign OF_SO = OF_S;
	assign UF_SO = UF_S;
	assign Zero_SO = Zero_S;
	assign IX_SO = IX_S;
	assign IV_SO = IV_S;
	assign Inf_SO = Inf_S;
endmodule
