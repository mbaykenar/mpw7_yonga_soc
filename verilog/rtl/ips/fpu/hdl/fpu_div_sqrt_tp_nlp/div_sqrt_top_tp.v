module div_sqrt_top_tp 
#(
   parameter   Precision_ctl_Enable_S = 1
)
(
	Clk_CI,
	Rst_RBI,
	Div_start_SI,
	Sqrt_start_SI,
	Operand_a_DI,
	Operand_b_DI,
	RM_SI,
	Precision_ctl_SI,
	Result_DO,
	Exp_OF_SO,
	Exp_UF_SO,
	Div_zero_SO,
	Ready_SO,
	Done_SO
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
	//parameter Precision_ctl_Enable_S = 1;
	input wire Clk_CI;
	input wire Rst_RBI;
	input wire Div_start_SI;
	input wire Sqrt_start_SI;
	input wire [C_DIV_OP - 1:0] Operand_a_DI;
	input wire [C_DIV_OP - 1:0] Operand_b_DI;
	input wire [C_DIV_RM - 1:0] RM_SI;
	input wire [C_DIV_PC - 1:0] Precision_ctl_SI;
	output wire [31:0] Result_DO;
	output wire Exp_OF_SO;
	output wire Exp_UF_SO;
	output wire Div_zero_SO;
	output wire Ready_SO;
	output wire Done_SO;
	wire [C_DIV_MANT - 1:0] Mant_res_DO;
	wire [C_DIV_EXP - 1:0] Exp_res_DO;
	wire Sign_res_DO;
	assign Result_DO = {Sign_res_DO, Exp_res_DO, Mant_res_DO};
	wire Sign_a_D;
	wire Sign_b_D;
	wire [C_DIV_EXP:0] Exp_a_D;
	wire [C_DIV_EXP:0] Exp_b_D;
	wire [C_DIV_MANT:0] Mant_a_D;
	wire [C_DIV_MANT:0] Mant_b_D;
	wire [C_DIV_EXP + 1:0] Exp_z_D;
	wire [C_DIV_MANT:0] Mant_z_D;
	wire Sign_z_D;
	wire Start_S;
	wire [C_DIV_RM - 1:0] RM_dly_S;
	wire Mant_zero_S_a;
	wire Mant_zero_S_b;
	wire Div_enable_S;
	wire Sqrt_enable_S;
	wire Inf_a_S;
	wire Inf_b_S;
	wire Zero_a_S;
	wire Zero_b_S;
	wire NaN_a_S;
	wire NaN_b_S;
	preprocess precess_U0(
		.Clk_CI(Clk_CI),
		.Rst_RBI(Rst_RBI),
		.Div_start_SI(Div_start_SI),
		.Sqrt_start_SI(Sqrt_start_SI),
		.Operand_a_DI(Operand_a_DI),
		.Operand_b_DI(Operand_b_DI),
		.RM_SI(RM_SI),
		.Start_SO(Start_S),
		.Exp_a_DO_norm(Exp_a_D),
		.Exp_b_DO_norm(Exp_b_D),
		.Mant_a_DO_norm(Mant_a_D),
		.Mant_b_DO_norm(Mant_b_D),
		.RM_dly_SO(RM_dly_S),
		.Sign_z_DO(Sign_z_D),
		.Inf_a_SO(Inf_a_S),
		.Inf_b_SO(Inf_b_S),
		.Zero_a_SO(Zero_a_S),
		.Zero_b_SO(Zero_b_S),
		.NaN_a_SO(NaN_a_S),
		.NaN_b_SO(NaN_b_S)
	);
	nrbd_nrsc_tp #(Precision_ctl_Enable_S) nrbd_nrsc_U0(
		.Clk_CI(Clk_CI),
		.Rst_RBI(Rst_RBI),
		.Div_start_SI(Div_start_SI),
		.Sqrt_start_SI(Sqrt_start_SI),
		.Start_SI(Start_S),
		.Div_enable_SO(Div_enable_S),
		.Sqrt_enable_SO(Sqrt_enable_S),
		.Precision_ctl_SI(Precision_ctl_SI),
		.Exp_a_DI(Exp_a_D),
		.Exp_b_DI(Exp_b_D),
		.Mant_a_DI(Mant_a_D),
		.Mant_b_DI(Mant_b_D),
		.Ready_SO(Ready_SO),
		.Done_SO(Done_SO),
		.Exp_z_DO(Exp_z_D),
		.Mant_z_DO(Mant_z_D)
	);
	fpu_norm_div_sqrt fpu_norm_U0(
		.Mant_in_DI(Mant_z_D),
		.Exp_in_DI(Exp_z_D),
		.Sign_in_DI(Sign_z_D),
		.Div_enable_SI(Div_enable_S),
		.Sqrt_enable_SI(Sqrt_enable_S),
		.Inf_a_SI(Inf_a_S),
		.Inf_b_SI(Inf_b_S),
		.Zero_a_SI(Zero_a_S),
		.Zero_b_SI(Zero_b_S),
		.NaN_a_SI(NaN_a_S),
		.NaN_b_SI(NaN_b_S),
		.RM_SI(RM_dly_S),
		.Mant_res_DO(Mant_res_DO),
		.Exp_res_DO(Exp_res_DO),
		.Sign_res_DO(Sign_res_DO),
		.Exp_OF_SO(Exp_OF_SO),
		.Exp_UF_SO(Exp_UF_SO),
		.Div_zero_SO(Div_zero_SO)
	);
endmodule
