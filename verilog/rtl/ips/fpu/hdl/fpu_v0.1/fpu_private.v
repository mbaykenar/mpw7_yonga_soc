module fpu_private (
	clk_i,
	rst_ni,
	fpu_en_i,
	operand_a_i,
	operand_b_i,
	operand_c_i,
	rm_i,
	fpu_op_i,
	prec_i,
	result_o,
	valid_o,
	flags_o,
	divsqrt_busy_o
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
	input wire clk_i;
	input wire rst_ni;
	input wire fpu_en_i;
	input wire [C_OP - 1:0] operand_a_i;
	input wire [C_OP - 1:0] operand_b_i;
	input wire [C_OP - 1:0] operand_c_i;
	input wire [C_RM - 1:0] rm_i;
	input wire [C_CMD - 1:0] fpu_op_i;
	input wire [C_PC - 1:0] prec_i;
	output wire [C_OP - 1:0] result_o;
	output wire valid_o;
	output wire [C_FFLAG - 1:0] flags_o;
	output wire divsqrt_busy_o;
	wire divsqrt_enable;
	wire fpu_enable;
	wire fma_enable;
	assign divsqrt_enable = fpu_en_i & ((fpu_op_i == C_FPU_DIV_CMD) | (fpu_op_i == C_FPU_SQRT_CMD));
	assign fpu_enable = fpu_en_i & (((((fpu_op_i == C_FPU_ADD_CMD) | (fpu_op_i == C_FPU_SUB_CMD)) | (fpu_op_i == C_FPU_MUL_CMD)) | (fpu_op_i == C_FPU_I2F_CMD)) | (fpu_op_i == C_FPU_F2I_CMD));
	assign fma_enable = fpu_en_i & ((((fpu_op_i == C_FPU_FMADD_CMD) | (fpu_op_i == C_FPU_FMSUB_CMD)) | (fpu_op_i == C_FPU_FNMADD_CMD)) | (fpu_op_i == C_FPU_FNMSUB_CMD));
	wire [31:0] fpu_operand_a;
	wire [31:0] fpu_operand_b;
	wire [31:0] fpu_result;
	wire [C_FFLAG - 1:0] fpu_flags;
	wire fpu_of;
	wire fpu_uf;
	wire fpu_zero;
	wire fpu_ix;
	wire fpu_iv;
	wire fpu_inf;
	assign fpu_operand_a = (fpu_enable ? operand_a_i : {32 {1'sb0}});
	assign fpu_operand_b = (fpu_enable ? operand_b_i : {32 {1'sb0}});
	wire fpu_valid;
	fpu_core fpu_core(
		.Clk_CI(clk_i),
		.Rst_RBI(rst_ni),
		.Enable_SI(fpu_enable),
		.Operand_a_DI(fpu_operand_a),
		.Operand_b_DI(fpu_operand_b),
		.RM_SI(rm_i),
		.OP_SI(fpu_op_i),
		.Result_DO(fpu_result),
		.Valid_SO(fpu_valid),
		.OF_SO(fpu_of),
		.UF_SO(fpu_uf),
		.Zero_SO(fpu_zero),
		.IX_SO(fpu_ix),
		.IV_SO(fpu_iv),
		.Inf_SO(fpu_inf)
	);
	assign fpu_flags = {fpu_iv, 1'b0, fpu_of, fpu_uf, fpu_ix};
	wire div_start;
	wire sqrt_start;
	wire [31:0] divsqrt_operand_a;
	wire [31:0] divsqrt_operand_b;
	wire [31:0] divsqrt_result;
	wire [C_FFLAG - 1:0] divsqrt_flags;
	wire divsqrt_nv;
	wire divsqrt_ix;
	assign sqrt_start = divsqrt_enable & (fpu_op_i == C_FPU_SQRT_CMD);
	assign div_start = divsqrt_enable & (fpu_op_i == C_FPU_DIV_CMD);
	assign divsqrt_operand_a = (div_start | sqrt_start ? operand_a_i : {32 {1'sb0}});
	assign divsqrt_operand_b = (div_start ? operand_b_i : {32 {1'sb0}});
	wire divsqrt_of;
	wire divsqrt_uf;
	wire divsqrt_zero;
	wire divsqrt_valid;
	div_sqrt_top_tp fpu_divsqrt_tp(
		.Clk_CI(clk_i),
		.Rst_RBI(rst_ni),
		.Div_start_SI(div_start),
		.Sqrt_start_SI(sqrt_start),
		.Operand_a_DI(divsqrt_operand_a),
		.Operand_b_DI(divsqrt_operand_b),
		.RM_SI(rm_i[1:0]),
		.Precision_ctl_SI(prec_i),
		.Result_DO(divsqrt_result),
		.Exp_OF_SO(divsqrt_of),
		.Exp_UF_SO(divsqrt_uf),
		.Div_zero_SO(divsqrt_zero),
		.Ready_SO(divsqrt_busy_o),
		.Done_SO(divsqrt_valid)
	);
	assign divsqrt_nv = 1'b0;
	assign divsqrt_ix = 1'b0;
	assign divsqrt_flags = {divsqrt_nv, divsqrt_zero, divsqrt_of, divsqrt_uf, divsqrt_ix};
	wire [31:0] fma_operand_a;
	wire [31:0] fma_operand_b;
	wire [31:0] fma_operand_c;
	wire [31:0] fma_result;
	reg [1:0] fma_op;
	wire fma_valid;
	wire [C_FFLAG - 1:0] fma_flags;
	always @(*) begin
		fma_op = 2'b00;
		case (fpu_op_i)
			C_FPU_FMADD_CMD: fma_op = 2'b00;
			C_FPU_FMSUB_CMD: fma_op = 2'b01;
			C_FPU_FNMADD_CMD: fma_op = 2'b11;
			C_FPU_FNMSUB_CMD: fma_op = 2'b10;
			default: fma_op = 2'b00;
		endcase
	end
	fp_fma_wrapper #(
		.C_MAC_PIPE_REGS(2),
		.RND_WIDTH(2),
		.STAT_WIDTH(5)
	) fp_fma_wrap_i(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.En_i(fma_enable),
		.OpA_i(operand_a_i),
		.OpB_i(operand_b_i),
		.OpC_i(operand_c_i),
		.Op_i(fma_op),
		.Rnd_i(rm_i[1:0]),
		.Status_o(fma_flags),
		.Res_o(fma_result),
		.Valid_o(fma_valid),
		.Ready_o(),
		.Ack_i(1'b1)
	);
	assign valid_o = (divsqrt_valid | fpu_valid) | fma_valid;
	assign result_o = (divsqrt_valid ? divsqrt_result : (fpu_valid ? fpu_result : (fma_valid ? fma_result : {C_OP {1'sb0}})));
	assign flags_o = (divsqrt_valid ? divsqrt_flags : (fpu_valid ? fpu_flags : (fma_valid ? fma_flags : {C_FFLAG {1'sb0}})));
endmodule
