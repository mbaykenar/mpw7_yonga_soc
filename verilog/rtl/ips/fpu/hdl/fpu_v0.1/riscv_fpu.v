module riscv_fpu (
	clk,
	rst_n,
	operand_a_i,
	operand_b_i,
	rounding_mode_i,
	operator_i,
	enable_i,
	stall_i,
	result_o,
	fpu_ready_o,
	result_valid_o
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
	input wire clk;
	input wire rst_n;
	input wire [C_OP - 1:0] operand_a_i;
	input wire [C_OP - 1:0] operand_b_i;
	input wire [C_RM - 1:0] rounding_mode_i;
	input wire [C_CMD - 1:0] operator_i;
	input wire enable_i;
	input wire stall_i;
	output wire [C_OP - 1:0] result_o;
	output reg fpu_ready_o;
	output wire result_valid_o;
	localparam CYCLES = 2;
	wire [C_OP - 1:0] operand_a_q;
	wire [C_OP - 1:0] operand_b_q;
	wire [C_RM - 1:0] rounding_mode_q;
	wire [C_CMD - 1:0] operator_q;
	reg [1:0] valid_count_q;
	reg [1:0] valid_count_n;
	assign result_valid_o = (valid_count_q == 1 ? 1'b1 : 1'b0);
	always @(*) begin
		valid_count_n = valid_count_q;
		fpu_ready_o = 1'b1;
		if (enable_i) begin
			valid_count_n = valid_count_q + 1;
			fpu_ready_o = 1'b0;
			if (valid_count_q == 1) begin
				fpu_ready_o = 1'b1;
				valid_count_n = 2'd0;
			end
		end
	end
	always @(posedge clk or negedge rst_n)
		if (~rst_n)
			valid_count_q <= 1'b0;
		else if (enable_i && ~stall_i)
			valid_count_q <= valid_count_n;
	fpu_core fpcore(
		.Clk_CI(clk),
		.Rst_RBI(rst_n),
		.Enable_SI(enable_i),
		.Operand_a_DI(operand_a_i),
		.Operand_b_DI(operand_b_i),
		.RM_SI(rounding_mode_i),
		.OP_SI(operator_i),
		.Stall_SI(stall_i),
		.Result_DO(result_o),
		.OF_SO(),
		.UF_SO(),
		.Zero_SO(),
		.IX_SO(),
		.IV_SO(),
		.Inf_SO()
	);
endmodule
