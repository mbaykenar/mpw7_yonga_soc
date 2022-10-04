module preprocess (
	Clk_CI,
	Rst_RBI,
	Div_start_SI,
	Sqrt_start_SI,
	Operand_a_DI,
	Operand_b_DI,
	RM_SI,
	Start_SO,
	Exp_a_DO_norm,
	Exp_b_DO_norm,
	Mant_a_DO_norm,
	Mant_b_DO_norm,
	RM_dly_SO,
	Sign_z_DO,
	Inf_a_SO,
	Inf_b_SO,
	Zero_a_SO,
	Zero_b_SO,
	NaN_a_SO,
	NaN_b_SO
);
parameter C_DIV_RM           = 2;
parameter C_DIV_RM_NEAREST   = 2'h0;
parameter C_DIV_RM_TRUNC     = 2'h1;
parameter C_DIV_RM_PLUSINF   = 2'h2;
parameter C_DIV_RM_MINUSINF  = 2'h3;
parameter C_DIV_PC           = 5;
parameter C_DIV_OP           = 32;
parameter C_DIV_MANT         = 23;
parameter C_DIV_EXP          = 8;
parameter C_DIV_BIAS         = 127;
parameter C_DIV_BIAS_AONE    = 8'h80;
parameter C_DIV_HALF_BIAS    = 63;
parameter C_DIV_MANT_PRENORM = C_DIV_MANT+1;
parameter C_DIV_EXP_ZERO     = 8'h00;
parameter C_DIV_EXP_ONE      = 8'h01;
parameter C_DIV_EXP_INF      = 8'hff;
parameter C_DIV_MANT_ZERO    = 23'h0;
parameter C_DIV_MANT_NAN     = 23'h400000;
	input wire Clk_CI;
	input wire Rst_RBI;
	input wire Div_start_SI;
	input wire Sqrt_start_SI;
	input wire [C_DIV_OP - 1:0] Operand_a_DI;
	input wire [C_DIV_OP - 1:0] Operand_b_DI;
	input wire [C_DIV_RM - 1:0] RM_SI;
	output wire Start_SO;
	output wire [C_DIV_EXP:0] Exp_a_DO_norm;
	output wire [C_DIV_EXP:0] Exp_b_DO_norm;
	output wire [C_DIV_MANT:0] Mant_a_DO_norm;
	output wire [C_DIV_MANT:0] Mant_b_DO_norm;
	output wire [C_DIV_RM - 1:0] RM_dly_SO;
	output wire Sign_z_DO;
	output wire Inf_a_SO;
	output wire Inf_b_SO;
	output wire Zero_a_SO;
	output wire Zero_b_SO;
	output wire NaN_a_SO;
	output wire NaN_b_SO;
	wire Hb_a_D;
	wire Hb_b_D;
	wire [C_DIV_EXP - 1:0] Exp_a_D;
	wire [C_DIV_EXP - 1:0] Exp_b_D;
	wire [C_DIV_MANT:0] Mant_a_D;
	wire [C_DIV_MANT:0] Mant_b_D;
	wire Sign_a_D;
	wire Sign_b_D;
	wire Start_S;
	assign Sign_a_D = Operand_a_DI[C_DIV_OP - 1];
	assign Sign_b_D = Operand_b_DI[C_DIV_OP - 1];
	assign Exp_a_D = Operand_a_DI[C_DIV_OP - 2:C_DIV_MANT];
	assign Exp_b_D = Operand_b_DI[C_DIV_OP - 2:C_DIV_MANT];
	assign Mant_a_D = {Hb_a_D, Operand_a_DI[C_DIV_MANT - 1:0]};
	assign Mant_b_D = {Hb_b_D, Operand_b_DI[C_DIV_MANT - 1:0]};
	assign Hb_a_D = |Exp_a_D;
	assign Hb_b_D = |Exp_b_D;
	assign Start_S = Div_start_SI | Sqrt_start_SI;
	wire Mant_a_prenorm_zero_S;
	wire Mant_b_prenorm_zero_S;
	assign Mant_a_prenorm_zero_S = Operand_a_DI[C_DIV_MANT - 1:0] == C_DIV_MANT_ZERO;
	assign Mant_b_prenorm_zero_S = Operand_b_DI[C_DIV_MANT - 1:0] == C_DIV_MANT_ZERO;
	wire Exp_a_prenorm_zero_S;
	wire Exp_b_prenorm_zero_S;
	assign Exp_a_prenorm_zero_S = Exp_a_D == C_DIV_EXP_ZERO;
	assign Exp_b_prenorm_zero_S = Exp_b_D == C_DIV_EXP_ZERO;
	wire Exp_a_prenorm_Inf_NaN_S;
	wire Exp_b_prenorm_Inf_NaN_S;
	assign Exp_a_prenorm_Inf_NaN_S = Exp_a_D == C_DIV_EXP_INF;
	assign Exp_b_prenorm_Inf_NaN_S = Exp_b_D == C_DIV_EXP_INF;
	wire Zero_a_SN;
	reg Zero_a_SP;
	wire Zero_b_SN;
	reg Zero_b_SP;
	wire Inf_a_SN;
	reg Inf_a_SP;
	wire Inf_b_SN;
	reg Inf_b_SP;
	wire NaN_a_SN;
	reg NaN_a_SP;
	wire NaN_b_SN;
	reg NaN_b_SP;
	assign Zero_a_SN = (Start_S ? Exp_a_prenorm_zero_S && Mant_a_prenorm_zero_S : Zero_a_SP);
	assign Zero_b_SN = (Start_S ? Exp_b_prenorm_zero_S && Mant_b_prenorm_zero_S : Zero_b_SP);
	assign Inf_a_SN = (Start_S ? Exp_a_prenorm_Inf_NaN_S && Mant_a_prenorm_zero_S : Inf_a_SP);
	assign Inf_b_SN = (Start_S ? Exp_b_prenorm_Inf_NaN_S && Mant_b_prenorm_zero_S : Inf_b_SP);
	assign NaN_a_SN = (Start_S ? Exp_a_prenorm_Inf_NaN_S && ~Mant_a_prenorm_zero_S : NaN_a_SP);
	assign NaN_b_SN = (Start_S ? Exp_b_prenorm_Inf_NaN_S && ~Mant_b_prenorm_zero_S : NaN_b_SP);
	always @(posedge Clk_CI or negedge Rst_RBI)
		if (~Rst_RBI) begin
			Zero_a_SP <= 1'sb0;
			Zero_b_SP <= 1'sb0;
			Inf_a_SP <= 1'sb0;
			Inf_b_SP <= 1'sb0;
			NaN_a_SP <= 1'sb0;
			NaN_b_SP <= 1'sb0;
		end
		else begin
			Inf_a_SP <= Inf_a_SN;
			Inf_b_SP <= Inf_b_SN;
			Zero_a_SP <= Zero_a_SN;
			Zero_b_SP <= Zero_b_SN;
			NaN_a_SP <= NaN_a_SN;
			NaN_b_SP <= NaN_b_SN;
		end
	reg Sign_z_DN;
	reg Sign_z_DP;
	always @(*)
		if (~Rst_RBI)
			Sign_z_DN = 1'sb0;
		else if (Div_start_SI)
			Sign_z_DN = Sign_a_D ^ Sign_b_D;
		else if (Sqrt_start_SI)
			Sign_z_DN = Sign_a_D;
		else
			Sign_z_DN = Sign_z_DP;
	always @(posedge Clk_CI or negedge Rst_RBI)
		if (~Rst_RBI)
			Sign_z_DP <= 1'sb0;
		else
			Sign_z_DP <= Sign_z_DN;
	reg [C_DIV_RM - 1:0] RM_DN;
	reg [C_DIV_RM - 1:0] RM_DP;
	always @(*)
		if (~Rst_RBI)
			RM_DN = 1'sb0;
		else if (Start_S)
			RM_DN = RM_SI;
		else
			RM_DN = RM_DP;
	always @(posedge Clk_CI or negedge Rst_RBI)
		if (~Rst_RBI)
			RM_DP <= 1'sb0;
		else
			RM_DP <= RM_DN;
	assign RM_dly_SO = RM_DP;
	wire [4:0] Mant_leadingOne_a;
	wire [4:0] Mant_leadingOne_b;
	wire Mant_zero_S_a;
	wire Mant_zero_S_b;
	fpu_ff #(.LEN(C_DIV_MANT + 1)) LOD_Ua(
		.in_i(Mant_a_D),
		.first_one_o(Mant_leadingOne_a),
		.no_ones_o(Mant_zero_S_a)
	);
	wire [C_DIV_MANT:0] Mant_a_norm_DN;
	reg [C_DIV_MANT:0] Mant_a_norm_DP;
	assign Mant_a_norm_DN = (Start_S ? Mant_a_D << Mant_leadingOne_a : Mant_a_norm_DP);
	always @(posedge Clk_CI or negedge Rst_RBI)
		if (~Rst_RBI)
			Mant_a_norm_DP <= 1'sb0;
		else
			Mant_a_norm_DP <= Mant_a_norm_DN;
	wire [C_DIV_EXP:0] Exp_a_norm_DN;
	reg [C_DIV_EXP:0] Exp_a_norm_DP;
	assign Exp_a_norm_DN = (Start_S ? (Exp_a_D - Mant_leadingOne_a) + |Mant_leadingOne_a : Exp_a_norm_DP);
	always @(posedge Clk_CI or negedge Rst_RBI)
		if (~Rst_RBI)
			Exp_a_norm_DP <= 1'sb0;
		else
			Exp_a_norm_DP <= Exp_a_norm_DN;
	fpu_ff #(.LEN(C_DIV_MANT + 1)) LOD_Ub(
		.in_i(Mant_b_D),
		.first_one_o(Mant_leadingOne_b),
		.no_ones_o(Mant_zero_S_b)
	);
	wire [C_DIV_MANT:0] Mant_b_norm_DN;
	reg [C_DIV_MANT:0] Mant_b_norm_DP;
	assign Mant_b_norm_DN = (Start_S ? Mant_b_D << Mant_leadingOne_b : Mant_b_norm_DP);
	always @(posedge Clk_CI or negedge Rst_RBI)
		if (~Rst_RBI)
			Mant_b_norm_DP <= 1'sb0;
		else
			Mant_b_norm_DP <= Mant_b_norm_DN;
	wire [C_DIV_EXP:0] Exp_b_norm_DN;
	reg [C_DIV_EXP:0] Exp_b_norm_DP;
	assign Exp_b_norm_DN = (Start_S ? (Exp_b_D - Mant_leadingOne_b) + |Mant_leadingOne_b : Exp_b_norm_DP);
	always @(posedge Clk_CI or negedge Rst_RBI)
		if (~Rst_RBI)
			Exp_b_norm_DP <= 1'sb0;
		else
			Exp_b_norm_DP <= Exp_b_norm_DN;
	assign Start_SO = Start_S;
	assign Exp_a_DO_norm = Exp_a_norm_DP;
	assign Exp_b_DO_norm = Exp_b_norm_DP;
	assign Mant_a_DO_norm = Mant_a_norm_DP;
	assign Mant_b_DO_norm = Mant_b_norm_DP;
	assign Sign_z_DO = Sign_z_DP;
	assign Inf_a_SO = Inf_a_SP;
	assign Inf_b_SO = Inf_b_SP;
	assign Zero_a_SO = Zero_a_SP;
	assign Zero_b_SO = Zero_b_SP;
	assign NaN_a_SO = NaN_a_SP;
	assign NaN_b_SO = NaN_b_SP;
endmodule
