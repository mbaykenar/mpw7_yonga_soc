module nrbd_nrsc_tp 
#(
   parameter   Precision_ctl_Enable_S = 1
)
(
	Clk_CI,
	Rst_RBI,
	Div_start_SI,
	Sqrt_start_SI,
	Start_SI,
	Precision_ctl_SI,
	Mant_a_DI,
	Mant_b_DI,
	Exp_a_DI,
	Exp_b_DI,
	Div_enable_SO,
	Sqrt_enable_SO,
	Ready_SO,
	Done_SO,
	Mant_z_DO,
	Exp_z_DO
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
	input wire Start_SI;
	input wire [C_DIV_PC - 1:0] Precision_ctl_SI;
	input wire [C_DIV_MANT:0] Mant_a_DI;
	input wire [C_DIV_MANT:0] Mant_b_DI;
	input wire [C_DIV_EXP:0] Exp_a_DI;
	input wire [C_DIV_EXP:0] Exp_b_DI;
	output wire Div_enable_SO;
	output wire Sqrt_enable_SO;
	output wire Ready_SO;
	output wire Done_SO;
	output wire [C_DIV_MANT:0] Mant_z_DO;
	output wire [C_DIV_EXP + 1:0] Exp_z_DO;
	wire [C_DIV_MANT + 1:0] First_iteration_cell_sum_D;
	wire [C_DIV_MANT + 1:0] Sec_iteration_cell_sum_D;
	wire [C_DIV_MANT + 1:0] Thi_iteration_cell_sum_D;
	wire [C_DIV_MANT + 1:0] Fou_iteration_cell_sum_D;
	wire First_iteration_cell_carry_D;
	wire Sec_iteration_cell_carry_D;
	wire Thi_iteration_cell_carry_D;
	wire Fou_iteration_cell_carry_D;
	wire [1:0] Sqrt_Da0;
	wire [1:0] Sqrt_Da1;
	wire [1:0] Sqrt_Da2;
	wire [1:0] Sqrt_Da3;
	wire [1:0] Sqrt_D0;
	wire [1:0] Sqrt_D1;
	wire [1:0] Sqrt_D2;
	wire [1:0] Sqrt_D3;
	wire [C_DIV_MANT + 1:0] First_iteration_cell_a_D;
	wire [C_DIV_MANT + 1:0] First_iteration_cell_b_D;
	wire [C_DIV_MANT + 1:0] Sec_iteration_cell_a_D;
	wire [C_DIV_MANT + 1:0] Sec_iteration_cell_b_D;
	wire [C_DIV_MANT + 1:0] Thi_iteration_cell_a_D;
	wire [C_DIV_MANT + 1:0] Thi_iteration_cell_b_D;
	wire [C_DIV_MANT + 1:0] Fou_iteration_cell_a_D;
	wire [C_DIV_MANT + 1:0] Fou_iteration_cell_b_D;
	wire Div_start_dly_S;
	wire Sqrt_start_dly_S;
	control_tp #(Precision_ctl_Enable_S) control_U0(
		.Clk_CI(Clk_CI),
		.Rst_RBI(Rst_RBI),
		.Div_start_SI(Div_start_SI),
		.Sqrt_start_SI(Sqrt_start_SI),
		.Start_SI(Start_SI),
		.Precision_ctl_SI(Precision_ctl_SI),
		.Numerator_DI(Mant_a_DI),
		.Exp_num_DI(Exp_a_DI),
		.Denominator_DI(Mant_b_DI),
		.Exp_den_DI(Exp_b_DI),
		.First_iteration_cell_sum_DI(First_iteration_cell_sum_D),
		.First_iteration_cell_carry_DI(First_iteration_cell_carry_D),
		.Sqrt_Da0(Sqrt_Da0),
		.Sec_iteration_cell_sum_DI(Sec_iteration_cell_sum_D),
		.Sec_iteration_cell_carry_DI(Sec_iteration_cell_carry_D),
		.Sqrt_Da1(Sqrt_Da1),
		.Thi_iteration_cell_sum_DI(Thi_iteration_cell_sum_D),
		.Thi_iteration_cell_carry_DI(Thi_iteration_cell_carry_D),
		.Sqrt_Da2(Sqrt_Da2),
		.Fou_iteration_cell_sum_DI(Fou_iteration_cell_sum_D),
		.Fou_iteration_cell_carry_DI(Fou_iteration_cell_carry_D),
		.Sqrt_Da3(Sqrt_Da3),
		.Div_start_dly_SO(Div_start_dly_S),
		.Sqrt_start_dly_SO(Sqrt_start_dly_S),
		.Div_enable_SO(Div_enable_SO),
		.Sqrt_enable_SO(Sqrt_enable_SO),
		.Sqrt_D0(Sqrt_D0),
		.Sqrt_D1(Sqrt_D1),
		.Sqrt_D2(Sqrt_D2),
		.Sqrt_D3(Sqrt_D3),
		.First_iteration_cell_a_DO(First_iteration_cell_a_D),
		.First_iteration_cell_b_DO(First_iteration_cell_b_D),
		.Sec_iteration_cell_a_DO(Sec_iteration_cell_a_D),
		.Sec_iteration_cell_b_DO(Sec_iteration_cell_b_D),
		.Thi_iteration_cell_a_DO(Thi_iteration_cell_a_D),
		.Thi_iteration_cell_b_DO(Thi_iteration_cell_b_D),
		.Fou_iteration_cell_a_DO(Fou_iteration_cell_a_D),
		.Fou_iteration_cell_b_DO(Fou_iteration_cell_b_D),
		.Ready_SO(Ready_SO),
		.Done_SO(Done_SO),
		.Mant_result_prenorm_DO(Mant_z_DO),
		.Exp_result_prenorm_DO(Exp_z_DO)
	);
	iteration_div_sqrt_first iteration_unit_U0(
		.A_DI(First_iteration_cell_a_D),
		.B_DI(First_iteration_cell_b_D),
		.Div_enable_SI(Div_enable_SO),
		.Div_start_dly_SI(Div_start_dly_S),
		.Sqrt_enable_SI(Sqrt_enable_SO),
		.D_DI(Sqrt_D0),
		.D_DO(Sqrt_Da0),
		.Sum_DO(First_iteration_cell_sum_D),
		.Carry_out_DO(First_iteration_cell_carry_D)
	);
	iteration_div_sqrt iteration_unit_U1(
		.A_DI(Sec_iteration_cell_a_D),
		.B_DI(Sec_iteration_cell_b_D),
		.Div_enable_SI(Div_enable_SO),
		.Sqrt_enable_SI(Sqrt_enable_SO),
		.D_DI(Sqrt_D1),
		.D_DO(Sqrt_Da1),
		.Sum_DO(Sec_iteration_cell_sum_D),
		.Carry_out_DO(Sec_iteration_cell_carry_D)
	);
	iteration_div_sqrt iteration_unit_U2(
		.A_DI(Thi_iteration_cell_a_D),
		.B_DI(Thi_iteration_cell_b_D),
		.Div_enable_SI(Div_enable_SO),
		.Sqrt_enable_SI(Sqrt_enable_SO),
		.D_DI(Sqrt_D2),
		.D_DO(Sqrt_Da2),
		.Sum_DO(Thi_iteration_cell_sum_D),
		.Carry_out_DO(Thi_iteration_cell_carry_D)
	);
	iteration_div_sqrt iteration_unit_U3(
		.A_DI(Fou_iteration_cell_a_D),
		.B_DI(Fou_iteration_cell_b_D),
		.Div_enable_SI(Div_enable_SO),
		.Sqrt_enable_SI(Sqrt_enable_SO),
		.D_DI(Sqrt_D3),
		.D_DO(Sqrt_Da3),
		.Sum_DO(Fou_iteration_cell_sum_D),
		.Carry_out_DO(Fou_iteration_cell_carry_D)
	);
endmodule
