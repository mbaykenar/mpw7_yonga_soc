module control_tp 
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
	Numerator_DI,
	Exp_num_DI,
	Denominator_DI,
	Exp_den_DI,
	First_iteration_cell_sum_DI,
	First_iteration_cell_carry_DI,
	Sqrt_Da0,
	Sec_iteration_cell_sum_DI,
	Sec_iteration_cell_carry_DI,
	Sqrt_Da1,
	Thi_iteration_cell_sum_DI,
	Thi_iteration_cell_carry_DI,
	Sqrt_Da2,
	Fou_iteration_cell_sum_DI,
	Fou_iteration_cell_carry_DI,
	Sqrt_Da3,
	Div_start_dly_SO,
	Sqrt_start_dly_SO,
	Div_enable_SO,
	Sqrt_enable_SO,
	Sqrt_D0,
	Sqrt_D1,
	Sqrt_D2,
	Sqrt_D3,
	First_iteration_cell_a_DO,
	First_iteration_cell_b_DO,
	Sec_iteration_cell_a_DO,
	Sec_iteration_cell_b_DO,
	Thi_iteration_cell_a_DO,
	Thi_iteration_cell_b_DO,
	Fou_iteration_cell_a_DO,
	Fou_iteration_cell_b_DO,
	Ready_SO,
	Done_SO,
	Mant_result_prenorm_DO,
	Exp_result_prenorm_DO
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
	//parameter Precision_ctl_Enable_S = 1;
	input wire Clk_CI;
	input wire Rst_RBI;
	input wire Div_start_SI;
	input wire Sqrt_start_SI;
	input wire Start_SI;
	input wire [C_DIV_PC - 1:0] Precision_ctl_SI;
	input wire [C_DIV_MANT:0] Numerator_DI;
	input wire [C_DIV_EXP:0] Exp_num_DI;
	input wire [C_DIV_MANT:0] Denominator_DI;
	input wire [C_DIV_EXP:0] Exp_den_DI;
	input wire [C_DIV_MANT + 1:0] First_iteration_cell_sum_DI;
	input wire First_iteration_cell_carry_DI;
	input wire [1:0] Sqrt_Da0;
	input wire [C_DIV_MANT + 1:0] Sec_iteration_cell_sum_DI;
	input wire Sec_iteration_cell_carry_DI;
	input wire [1:0] Sqrt_Da1;
	input wire [C_DIV_MANT + 1:0] Thi_iteration_cell_sum_DI;
	input wire Thi_iteration_cell_carry_DI;
	input wire [1:0] Sqrt_Da2;
	input wire [C_DIV_MANT + 1:0] Fou_iteration_cell_sum_DI;
	input wire Fou_iteration_cell_carry_DI;
	input wire [1:0] Sqrt_Da3;
	output wire Div_start_dly_SO;
	output wire Sqrt_start_dly_SO;
	output reg Div_enable_SO;
	output reg Sqrt_enable_SO;
	output reg [1:0] Sqrt_D0;
	output reg [1:0] Sqrt_D1;
	output reg [1:0] Sqrt_D2;
	output reg [1:0] Sqrt_D3;
	output wire [C_DIV_MANT + 1:0] First_iteration_cell_a_DO;
	output wire [C_DIV_MANT + 1:0] First_iteration_cell_b_DO;
	output wire [C_DIV_MANT + 1:0] Sec_iteration_cell_a_DO;
	output wire [C_DIV_MANT + 1:0] Sec_iteration_cell_b_DO;
	output wire [C_DIV_MANT + 1:0] Thi_iteration_cell_a_DO;
	output wire [C_DIV_MANT + 1:0] Thi_iteration_cell_b_DO;
	output wire [C_DIV_MANT + 1:0] Fou_iteration_cell_a_DO;
	output wire [C_DIV_MANT + 1:0] Fou_iteration_cell_b_DO;
	output reg Ready_SO;
	output reg Done_SO;
	output wire [C_DIV_MANT:0] Mant_result_prenorm_DO;
	output wire [C_DIV_EXP + 1:0] Exp_result_prenorm_DO;
	reg [C_DIV_MANT + 1:0] Partial_remainder_DN;
	reg [C_DIV_MANT + 1:0] Partial_remainder_DP;
	reg [C_DIV_MANT:0] Quotient_DP;
	wire [C_DIV_MANT + 1:0] Numerator_se_D;
	wire [C_DIV_MANT + 1:0] Denominator_se_D;
	wire [C_DIV_MANT + 1:0] Denominator_se_DB;
	assign Numerator_se_D = {1'b0, Numerator_DI};
	assign Denominator_se_D = {1'b0, Denominator_DI};
	assign Denominator_se_DB = ~Denominator_se_D;
	wire [C_DIV_MANT + 1:0] Mant_D_sqrt_Norm;
	assign Mant_D_sqrt_Norm = (Exp_num_DI[0] ? {1'b0, Numerator_DI} : {Numerator_DI, 1'b0});
	reg [C_DIV_PC - 1:0] Precision_ctl_S;
	always @(posedge Clk_CI or negedge Rst_RBI)
		if (~Rst_RBI)
			Precision_ctl_S <= 'b0;
		else if (Start_SI) begin
			if (Precision_ctl_Enable_S == 1)
				Precision_ctl_S <= Precision_ctl_SI;
			else
				Precision_ctl_S <= 5'b10111;
		end
		else
			Precision_ctl_S <= Precision_ctl_S;
	reg [2:0] State_ctl_S;
	always @(*)
		if (Precision_ctl_Enable_S == 1)
			case (Precision_ctl_S)
				5'b01000, 5'b01001, 5'b01010, 5'b01011: State_ctl_S <= 3'b010;
				5'b01100, 5'b01101, 5'b01110, 5'b01111: State_ctl_S <= 3'b011;
				5'b10000, 5'b10001, 5'b10010, 5'b10011: State_ctl_S <= 3'b100;
				5'b10100, 5'b10101, 5'b10110, 5'b10111: State_ctl_S <= 3'b101;
				default: State_ctl_S <= 3'b101;
			endcase
		else
			State_ctl_S <= 3'b101;
	reg Div_start_dly_S;
	always @(posedge Clk_CI or negedge Rst_RBI)
		if (~Rst_RBI)
			Div_start_dly_S <= 1'b0;
		else if (Div_start_SI)
			Div_start_dly_S <= 1'b1;
		else
			Div_start_dly_S <= 1'b0;
	assign Div_start_dly_SO = Div_start_dly_S;
	always @(posedge Clk_CI or negedge Rst_RBI)
		if (~Rst_RBI)
			Div_enable_SO <= 1'b0;
		else if (Div_start_SI)
			Div_enable_SO <= 1'b1;
		else if (Done_SO)
			Div_enable_SO <= 1'b0;
		else
			Div_enable_SO <= Div_enable_SO;
	reg Sqrt_start_dly_S;
	always @(posedge Clk_CI or negedge Rst_RBI)
		if (~Rst_RBI)
			Sqrt_start_dly_S <= 1'b0;
		else if (Sqrt_start_SI)
			Sqrt_start_dly_S <= 1'b1;
		else
			Sqrt_start_dly_S <= 1'b0;
	assign Sqrt_start_dly_SO = Sqrt_start_dly_S;
	always @(posedge Clk_CI or negedge Rst_RBI)
		if (~Rst_RBI)
			Sqrt_enable_SO <= 1'b0;
		else if (Sqrt_start_SI)
			Sqrt_enable_SO <= 1'b1;
		else if (Done_SO)
			Sqrt_enable_SO <= 1'b0;
		else
			Sqrt_enable_SO <= Sqrt_enable_SO;
	reg [2:0] Crtl_cnt_S;
	wire Start_dly_S;
	assign Start_dly_S = Div_start_dly_S | Sqrt_start_dly_S;
	wire Fsm_enable_S;
	assign Fsm_enable_S = Start_dly_S | |Crtl_cnt_S[2:0];
	wire Final_state_S;
	assign Final_state_S = Crtl_cnt_S == State_ctl_S;
	always @(posedge Clk_CI or negedge Rst_RBI)
		if (~Rst_RBI)
			Crtl_cnt_S <= 1'sb0;
		else if (Final_state_S)
			Crtl_cnt_S <= 1'sb0;
		else if (Fsm_enable_S)
			Crtl_cnt_S <= Crtl_cnt_S + 1;
		else
			Crtl_cnt_S <= 1'sb0;
	always @(posedge Clk_CI or negedge Rst_RBI)
		if (~Rst_RBI)
			Done_SO <= 1'b0;
		else if (Start_SI)
			Done_SO <= 1'b0;
		else if (Final_state_S)
			Done_SO <= 1'b1;
		else
			Done_SO <= 1'b0;
	always @(posedge Clk_CI or negedge Rst_RBI)
		if (~Rst_RBI)
			Ready_SO <= 1'b1;
		else if (Start_SI)
			Ready_SO <= 1'b0;
		else if (Final_state_S)
			Ready_SO <= 1'b1;
		else
			Ready_SO <= Ready_SO;
	wire [C_DIV_MANT + 1:0] Sqrt_R0;
	wire [C_DIV_MANT + 1:0] Sqrt_R1;
	wire [C_DIV_MANT + 1:0] Sqrt_R2;
	wire [C_DIV_MANT + 1:0] Sqrt_R3;
	wire [C_DIV_MANT + 1:0] Sqrt_R4;
	wire [3:0] Qcnt0;
	wire [3:0] Q_cnt_cmp_0;
	wire [6:0] Qcnt1;
	wire [6:0] Q_cnt_cmp_1;
	wire [10:0] Qcnt2;
	wire [10:0] Q_cnt_cmp_2;
	wire [14:0] Qcnt3;
	wire [14:0] Q_cnt_cmp_3;
	wire [18:0] Qcnt4;
	wire [18:0] Q_cnt_cmp_4;
	wire [22:0] Qcnt5;
	wire [22:0] Q_cnt_cmp_5;
	reg [C_DIV_MANT + 1:0] Sqrt_Q0;
	reg [C_DIV_MANT + 1:0] Sqrt_Q1;
	reg [C_DIV_MANT + 1:0] Sqrt_Q2;
	reg [C_DIV_MANT + 1:0] Sqrt_Q3;
	wire [C_DIV_MANT + 1:0] Sqrt_Q4;
	reg [C_DIV_MANT + 1:0] Q_sqrt0;
	reg [C_DIV_MANT + 1:0] Q_sqrt1;
	reg [C_DIV_MANT + 1:0] Q_sqrt2;
	reg [C_DIV_MANT + 1:0] Q_sqrt3;
	reg [C_DIV_MANT + 1:0] Q_sqrt4;
	reg [C_DIV_MANT + 1:0] Q_sqrt_com_0;
	reg [C_DIV_MANT + 1:0] Q_sqrt_com_1;
	reg [C_DIV_MANT + 1:0] Q_sqrt_com_2;
	reg [C_DIV_MANT + 1:0] Q_sqrt_com_3;
	reg [C_DIV_MANT + 1:0] Q_sqrt_com_4;
	assign Qcnt0 = {1'b0, ~First_iteration_cell_sum_DI[24], ~Sec_iteration_cell_sum_DI[24], ~Thi_iteration_cell_sum_DI[24]};
	assign Qcnt1 = {Quotient_DP[3:0], ~First_iteration_cell_sum_DI[24], ~Sec_iteration_cell_sum_DI[24], ~Thi_iteration_cell_sum_DI[24]};
	assign Qcnt2 = {Quotient_DP[7:0], ~First_iteration_cell_sum_DI[24], ~Sec_iteration_cell_sum_DI[24], ~Thi_iteration_cell_sum_DI[24]};
	assign Qcnt3 = {Quotient_DP[11:0], ~First_iteration_cell_sum_DI[24], ~Sec_iteration_cell_sum_DI[24], ~Thi_iteration_cell_sum_DI[24]};
	assign Qcnt4 = {Quotient_DP[15:0], ~First_iteration_cell_sum_DI[24], ~Sec_iteration_cell_sum_DI[24], ~Thi_iteration_cell_sum_DI[24]};
	assign Qcnt5 = {Quotient_DP[19:0], ~First_iteration_cell_sum_DI[24], ~Sec_iteration_cell_sum_DI[24], ~Thi_iteration_cell_sum_DI[24]};
	assign Q_cnt_cmp_0 = ~Qcnt0;
	assign Q_cnt_cmp_1 = ~Qcnt1;
	assign Q_cnt_cmp_2 = ~Qcnt2;
	assign Q_cnt_cmp_3 = ~Qcnt3;
	assign Q_cnt_cmp_4 = ~Qcnt4;
	assign Q_cnt_cmp_5 = ~Qcnt5;
	always @(*)
		case (Crtl_cnt_S)
			3'b000: begin
				Sqrt_D0 = Mant_D_sqrt_Norm[C_DIV_MANT + 1:C_DIV_MANT];
				Sqrt_D1 = Mant_D_sqrt_Norm[C_DIV_MANT - 1:C_DIV_MANT - 2];
				Sqrt_D2 = Mant_D_sqrt_Norm[C_DIV_MANT - 3:C_DIV_MANT - 4];
				Sqrt_D3 = Mant_D_sqrt_Norm[C_DIV_MANT - 5:C_DIV_MANT - 6];
				Q_sqrt0 = {24'h000000, Qcnt0[3]};
				Q_sqrt1 = {23'h000000, Qcnt0[3:2]};
				Q_sqrt2 = {22'h000000, Qcnt0[3:1]};
				Q_sqrt3 = {21'h000000, Qcnt0[3:0]};
				Q_sqrt_com_0 = {24'hffffff, Q_cnt_cmp_0[3]};
				Q_sqrt_com_1 = {23'h7fffff, Q_cnt_cmp_0[3:2]};
				Q_sqrt_com_2 = {22'h3fffff, Q_cnt_cmp_0[3:1]};
				Q_sqrt_com_3 = {21'h1fffff, Q_cnt_cmp_0[3:0]};
				Sqrt_Q0 = Q_sqrt_com_0;
				Sqrt_Q1 = (First_iteration_cell_sum_DI[24] ? Q_sqrt1 : Q_sqrt_com_1);
				Sqrt_Q2 = (Sec_iteration_cell_sum_DI[24] ? Q_sqrt2 : Q_sqrt_com_2);
				Sqrt_Q3 = (Thi_iteration_cell_sum_DI[24] ? Q_sqrt3 : Q_sqrt_com_3);
			end
			3'b001: begin
				Sqrt_D0 = Mant_D_sqrt_Norm[C_DIV_MANT - 7:C_DIV_MANT - 8];
				Sqrt_D1 = Mant_D_sqrt_Norm[C_DIV_MANT - 9:C_DIV_MANT - 10];
				Sqrt_D2 = Mant_D_sqrt_Norm[C_DIV_MANT - 11:C_DIV_MANT - 12];
				Sqrt_D3 = Mant_D_sqrt_Norm[C_DIV_MANT - 13:C_DIV_MANT - 14];
				Q_sqrt0 = {21'h000000, Qcnt1[6:3]};
				Q_sqrt1 = {20'h00000, Qcnt1[6:2]};
				Q_sqrt2 = {19'h00000, Qcnt1[6:1]};
				Q_sqrt3 = {18'h00000, Qcnt1[6:0]};
				Q_sqrt_com_0 = {21'h1fffff, Q_cnt_cmp_1[6:3]};
				Q_sqrt_com_1 = {20'hfffff, Q_cnt_cmp_1[6:2]};
				Q_sqrt_com_2 = {19'h7ffff, Q_cnt_cmp_1[6:1]};
				Q_sqrt_com_3 = {18'h3ffff, Q_cnt_cmp_1[6:0]};
				Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
				Sqrt_Q1 = (First_iteration_cell_sum_DI[24] ? Q_sqrt1 : Q_sqrt_com_1);
				Sqrt_Q2 = (Sec_iteration_cell_sum_DI[24] ? Q_sqrt2 : Q_sqrt_com_2);
				Sqrt_Q3 = (Thi_iteration_cell_sum_DI[24] ? Q_sqrt3 : Q_sqrt_com_3);
			end
			3'b010: begin
				Sqrt_D0 = Mant_D_sqrt_Norm[C_DIV_MANT - 15:C_DIV_MANT - 16];
				Sqrt_D1 = Mant_D_sqrt_Norm[C_DIV_MANT - 17:C_DIV_MANT - 18];
				Sqrt_D2 = Mant_D_sqrt_Norm[C_DIV_MANT - 19:C_DIV_MANT - 20];
				Sqrt_D3 = Mant_D_sqrt_Norm[C_DIV_MANT - 21:C_DIV_MANT - 22];
				Q_sqrt0 = {17'h00000, Qcnt2[10:3]};
				Q_sqrt1 = {16'h0000, Qcnt2[10:2]};
				Q_sqrt2 = {15'h0000, Qcnt2[10:1]};
				Q_sqrt3 = {14'h0000, Qcnt2[10:0]};
				Q_sqrt_com_0 = {17'h1ffff, Q_cnt_cmp_2[10:3]};
				Q_sqrt_com_1 = {16'hffff, Q_cnt_cmp_2[10:2]};
				Q_sqrt_com_2 = {15'h7fff, Q_cnt_cmp_2[10:1]};
				Q_sqrt_com_3 = {14'h3fff, Q_cnt_cmp_2[10:0]};
				Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
				Sqrt_Q1 = (First_iteration_cell_sum_DI[24] ? Q_sqrt1 : Q_sqrt_com_1);
				Sqrt_Q2 = (Sec_iteration_cell_sum_DI[24] ? Q_sqrt2 : Q_sqrt_com_2);
				Sqrt_Q3 = (Thi_iteration_cell_sum_DI[24] ? Q_sqrt3 : Q_sqrt_com_3);
			end
			3'b011: begin
				Sqrt_D0 = {Mant_D_sqrt_Norm[0], 1'b0};
				Sqrt_D1 = 1'sb0;
				Sqrt_D2 = 1'sb0;
				Sqrt_D3 = 1'sb0;
				Q_sqrt0 = {13'h0000, Qcnt3[14:3]};
				Q_sqrt1 = {12'h000, Qcnt3[14:2]};
				Q_sqrt2 = {11'h000, Qcnt3[14:1]};
				Q_sqrt3 = {10'h000, Qcnt3[14:0]};
				Q_sqrt_com_0 = {13'h1fff, Q_cnt_cmp_3[14:3]};
				Q_sqrt_com_1 = {12'hfff, Q_cnt_cmp_3[14:2]};
				Q_sqrt_com_2 = {11'h7ff, Q_cnt_cmp_3[14:1]};
				Q_sqrt_com_3 = {10'h3ff, Q_cnt_cmp_3[14:0]};
				Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
				Sqrt_Q1 = (First_iteration_cell_sum_DI[24] ? Q_sqrt1 : Q_sqrt_com_1);
				Sqrt_Q2 = (Sec_iteration_cell_sum_DI[24] ? Q_sqrt2 : Q_sqrt_com_2);
				Sqrt_Q3 = (Thi_iteration_cell_sum_DI[24] ? Q_sqrt3 : Q_sqrt_com_3);
			end
			3'b100: begin
				Sqrt_D0 = 1'sb0;
				Sqrt_D1 = 1'sb0;
				Sqrt_D2 = 1'sb0;
				Sqrt_D3 = 1'sb0;
				Q_sqrt0 = {9'h000, Qcnt4[18:3]};
				Q_sqrt1 = {8'h00, Qcnt4[18:2]};
				Q_sqrt2 = {7'h00, Qcnt4[18:1]};
				Q_sqrt3 = {6'h00, Qcnt4[18:0]};
				Q_sqrt_com_0 = {9'h1ff, Q_cnt_cmp_4[18:3]};
				Q_sqrt_com_1 = {8'hff, Q_cnt_cmp_4[18:2]};
				Q_sqrt_com_2 = {7'h7f, Q_cnt_cmp_4[18:1]};
				Q_sqrt_com_3 = {6'h3f, Q_cnt_cmp_4[18:0]};
				Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
				Sqrt_Q1 = (First_iteration_cell_sum_DI[24] ? Q_sqrt1 : Q_sqrt_com_1);
				Sqrt_Q2 = (Sec_iteration_cell_sum_DI[24] ? Q_sqrt2 : Q_sqrt_com_2);
				Sqrt_Q3 = (Thi_iteration_cell_sum_DI[24] ? Q_sqrt3 : Q_sqrt_com_3);
			end
			3'b101: begin
				Sqrt_D0 = 1'sb0;
				Sqrt_D1 = 1'sb0;
				Sqrt_D2 = 1'sb0;
				Sqrt_D3 = 1'sb0;
				Q_sqrt0 = {5'h00, Qcnt5[22:3]};
				Q_sqrt1 = {4'h0, Qcnt5[22:2]};
				Q_sqrt2 = {3'h0, Qcnt5[22:1]};
				Q_sqrt3 = {2'h0, Qcnt5[22:0]};
				Q_sqrt_com_0 = {5'h1f, Q_cnt_cmp_5[22:3]};
				Q_sqrt_com_1 = {4'hf, Q_cnt_cmp_5[22:2]};
				Q_sqrt_com_2 = {3'h7, Q_cnt_cmp_5[22:1]};
				Q_sqrt_com_3 = {2'h3, Q_cnt_cmp_5[22:0]};
				Sqrt_Q0 = (Quotient_DP[0] ? Q_sqrt_com_0 : Q_sqrt0);
				Sqrt_Q1 = (First_iteration_cell_sum_DI[24] ? Q_sqrt1 : Q_sqrt_com_1);
				Sqrt_Q2 = (Sec_iteration_cell_sum_DI[24] ? Q_sqrt2 : Q_sqrt_com_2);
				Sqrt_Q3 = (Thi_iteration_cell_sum_DI[24] ? Q_sqrt3 : Q_sqrt_com_3);
			end
			default: begin
				Sqrt_D0 = 1'sb0;
				Sqrt_D1 = 1'sb0;
				Sqrt_D2 = 1'sb0;
				Sqrt_D3 = 1'sb0;
				Q_sqrt0 = 1'sb0;
				Q_sqrt1 = 1'sb0;
				Q_sqrt2 = 1'sb0;
				Q_sqrt3 = 1'sb0;
				Q_sqrt4 = 1'sb0;
				Q_sqrt_com_0 = 1'sb0;
				Q_sqrt_com_1 = 1'sb0;
				Q_sqrt_com_2 = 1'sb0;
				Q_sqrt_com_3 = 1'sb0;
				Q_sqrt_com_4 = 1'sb0;
				Sqrt_Q0 = 1'sb0;
				Sqrt_Q1 = 1'sb0;
				Sqrt_Q2 = 1'sb0;
				Sqrt_Q3 = 1'sb0;
			end
		endcase
	assign Sqrt_R0 = (Sqrt_start_dly_S ? {((C_DIV_MANT + 1) >= 0 ? C_DIV_MANT + 2 : 1 - (C_DIV_MANT + 1)) {1'sb0}} : Partial_remainder_DP);
	assign Sqrt_R1 = {First_iteration_cell_sum_DI[24], First_iteration_cell_sum_DI[21:0], Sqrt_Da0};
	assign Sqrt_R2 = {Sec_iteration_cell_sum_DI[24], Sec_iteration_cell_sum_DI[21:0], Sqrt_Da1};
	assign Sqrt_R3 = {Thi_iteration_cell_sum_DI[24], Thi_iteration_cell_sum_DI[21:0], Sqrt_Da2};
	assign Sqrt_R4 = {Fou_iteration_cell_sum_DI[24], Fou_iteration_cell_sum_DI[21:0], Sqrt_Da3};
	wire [C_DIV_MANT + 1:0] First_iteration_cell_div_a_D;
	wire [C_DIV_MANT + 1:0] First_iteration_cell_div_b_D;
	wire Sel_b_for_first_S;
	assign First_iteration_cell_div_a_D = (Div_start_dly_S ? Numerator_se_D : {Partial_remainder_DP[C_DIV_MANT:0], Quotient_DP[0]});
	assign Sel_b_for_first_S = (Div_start_dly_S ? 1 : Quotient_DP[0]);
	assign First_iteration_cell_div_b_D = (Sel_b_for_first_S ? Denominator_se_DB : Denominator_se_D);
	assign First_iteration_cell_a_DO = (Sqrt_enable_SO ? Sqrt_R0 : First_iteration_cell_div_a_D);
	assign First_iteration_cell_b_DO = (Sqrt_enable_SO ? Sqrt_Q0 : First_iteration_cell_div_b_D);
	wire [C_DIV_MANT + 1:0] Sec_iteration_cell_div_a_D;
	wire [C_DIV_MANT + 1:0] Sec_iteration_cell_div_b_D;
	wire Sel_b_for_sec_S;
	assign Sec_iteration_cell_div_a_D = {First_iteration_cell_sum_DI[C_DIV_MANT:0], First_iteration_cell_carry_DI};
	assign Sel_b_for_sec_S = First_iteration_cell_carry_DI;
	assign Sec_iteration_cell_div_b_D = (Sel_b_for_sec_S ? Denominator_se_DB : Denominator_se_D);
	assign Sec_iteration_cell_a_DO = (Sqrt_enable_SO ? Sqrt_R1 : Sec_iteration_cell_div_a_D);
	assign Sec_iteration_cell_b_DO = (Sqrt_enable_SO ? Sqrt_Q1 : Sec_iteration_cell_div_b_D);
	wire [C_DIV_MANT + 1:0] Thi_iteration_cell_div_a_D;
	wire [C_DIV_MANT + 1:0] Thi_iteration_cell_div_b_D;
	wire Sel_b_for_thi_S;
	assign Thi_iteration_cell_div_a_D = {Sec_iteration_cell_sum_DI[C_DIV_MANT:0], Sec_iteration_cell_carry_DI};
	assign Sel_b_for_thi_S = Sec_iteration_cell_carry_DI;
	assign Thi_iteration_cell_div_b_D = (Sel_b_for_thi_S ? Denominator_se_DB : Denominator_se_D);
	assign Thi_iteration_cell_a_DO = (Sqrt_enable_SO ? Sqrt_R2 : Thi_iteration_cell_div_a_D);
	assign Thi_iteration_cell_b_DO = (Sqrt_enable_SO ? Sqrt_Q2 : Thi_iteration_cell_div_b_D);
	wire [C_DIV_MANT + 1:0] Fou_iteration_cell_div_a_D;
	wire [C_DIV_MANT + 1:0] Fou_iteration_cell_div_b_D;
	wire Sel_b_for_fou_S;
	assign Fou_iteration_cell_div_a_D = {Thi_iteration_cell_sum_DI[C_DIV_MANT:0], Thi_iteration_cell_carry_DI};
	assign Sel_b_for_fou_S = Thi_iteration_cell_carry_DI;
	assign Fou_iteration_cell_div_b_D = (Sel_b_for_fou_S ? Denominator_se_DB : Denominator_se_D);
	assign Fou_iteration_cell_a_DO = (Sqrt_enable_SO ? Sqrt_R3 : Fou_iteration_cell_div_a_D);
	assign Fou_iteration_cell_b_DO = (Sqrt_enable_SO ? Sqrt_Q3 : Fou_iteration_cell_div_b_D);
	always @(*)
		if (Fsm_enable_S)
			Partial_remainder_DN = (Sqrt_enable_SO ? Sqrt_R4 : Fou_iteration_cell_sum_DI);
		else
			Partial_remainder_DN = Partial_remainder_DP;
	always @(posedge Clk_CI or negedge Rst_RBI)
		if (~Rst_RBI)
			Partial_remainder_DP <= 1'sb0;
		else
			Partial_remainder_DP <= Partial_remainder_DN;
	reg [C_DIV_MANT:0] Quotient_DN;
	always @(*)
		if (Fsm_enable_S)
			Quotient_DN = {Quotient_DP[C_DIV_MANT - 4:0], First_iteration_cell_carry_DI, Sec_iteration_cell_carry_DI, Thi_iteration_cell_carry_DI, Fou_iteration_cell_carry_DI};
		else
			Quotient_DN = Quotient_DP;
	always @(posedge Clk_CI or negedge Rst_RBI)
		if (~Rst_RBI)
			Quotient_DP <= 1'sb0;
		else
			Quotient_DP <= Quotient_DN;
	wire Msc_D;
	wire [C_DIV_MANT + 1:0] Sum_msc_D;
	assign {Msc_D, Sum_msc_D} = First_iteration_cell_div_a_D + First_iteration_cell_div_b_D;
	reg [C_DIV_MANT:0] Mant_result_prenorm_noncorrect_D;
	reg [C_DIV_MANT:0] Msc_forcorrect_D;
	wire [C_DIV_MANT + 1:0] Mant_result_prenorm_correct_D;
	always @(*)
		if (Precision_ctl_Enable_S == 1)
			case (Precision_ctl_S)
				5'b01000: begin
					Mant_result_prenorm_noncorrect_D = {Quotient_DP[C_DIV_MANT - 12:3], 15'b000000000000000};
					Msc_forcorrect_D = {8'b00000000, Quotient_DP[2], 15'b000000000000000};
				end
				5'b01001: begin
					Mant_result_prenorm_noncorrect_D = {Quotient_DP[C_DIV_MANT - 12:2], 14'b00000000000000};
					Msc_forcorrect_D = {9'b000000000, Quotient_DP[1], 14'b00000000000000};
				end
				5'b01010: begin
					Mant_result_prenorm_noncorrect_D = {Quotient_DP[C_DIV_MANT - 12:1], 13'b0000000000000};
					Msc_forcorrect_D = {10'b0000000000, Quotient_DP[0], 13'b0000000000000};
				end
				5'b01011: begin
					Mant_result_prenorm_noncorrect_D = {Quotient_DP[C_DIV_MANT - 12:0], 12'b000000000000};
					Msc_forcorrect_D = {11'b00000000000, Msc_D, 12'b000000000000};
				end
				5'b01100: begin
					Mant_result_prenorm_noncorrect_D = {Quotient_DP[C_DIV_MANT - 8:3], 11'b00000000000};
					Msc_forcorrect_D = {12'b000000000000, Quotient_DP[2], 11'b00000000000};
				end
				5'b01101: begin
					Mant_result_prenorm_noncorrect_D = {Quotient_DP[C_DIV_MANT - 8:2], 10'b0000000000};
					Msc_forcorrect_D = {13'b0000000000000, Quotient_DP[1], 10'b0000000000};
				end
				5'b01110: begin
					Mant_result_prenorm_noncorrect_D = {Quotient_DP[C_DIV_MANT - 8:1], 9'b000000000};
					Msc_forcorrect_D = {14'b00000000000000, Quotient_DP[0], 9'b000000000};
				end
				5'b01111: begin
					Mant_result_prenorm_noncorrect_D = {Quotient_DP[C_DIV_MANT - 8:0], 8'b00000000};
					Msc_forcorrect_D = {15'b000000000000000, Msc_D, 8'b00000000};
				end
				5'b10000: begin
					Mant_result_prenorm_noncorrect_D = {Quotient_DP[C_DIV_MANT - 4:3], 7'b0000000};
					Msc_forcorrect_D = {16'b0000000000000000, Quotient_DP[2], 7'b0000000};
				end
				5'b10001: begin
					Mant_result_prenorm_noncorrect_D = {Quotient_DP[C_DIV_MANT - 4:2], 6'b000000};
					Msc_forcorrect_D = {17'b00000000000000000, Quotient_DP[1], 6'b000000};
				end
				5'b10010: begin
					Mant_result_prenorm_noncorrect_D = {Quotient_DP[C_DIV_MANT - 4:1], 5'b00000};
					Msc_forcorrect_D = {18'b000000000000000000, Quotient_DP[0], 5'b00000};
				end
				5'b10011: begin
					Mant_result_prenorm_noncorrect_D = {Quotient_DP[C_DIV_MANT - 4:0], 4'b0000};
					Msc_forcorrect_D = {19'b0000000000000000000, Msc_D, 4'b0000};
				end
				5'b10100: begin
					Mant_result_prenorm_noncorrect_D = {Quotient_DP[C_DIV_MANT:3], 3'b000};
					Msc_forcorrect_D = {20'b00000000000000000000, Quotient_DP[2], 3'b000};
				end
				5'b10101: begin
					Mant_result_prenorm_noncorrect_D = {Quotient_DP[C_DIV_MANT:2], 2'b00};
					Msc_forcorrect_D = {21'b000000000000000000000, Quotient_DP[1], 2'b00};
				end
				5'b10110: begin
					Mant_result_prenorm_noncorrect_D = {Quotient_DP[C_DIV_MANT:1], 1'b0};
					Msc_forcorrect_D = {22'b0000000000000000000000, Quotient_DP[0], 1'b0};
				end
				5'b10111: begin
					Mant_result_prenorm_noncorrect_D = Quotient_DP[C_DIV_MANT:0];
					Msc_forcorrect_D = {23'b00000000000000000000000, Msc_D};
				end
				default: begin
					Mant_result_prenorm_noncorrect_D = Quotient_DP[C_DIV_MANT:0];
					Msc_forcorrect_D = {23'b00000000000000000000000, Msc_D};
				end
			endcase
		else begin
			Mant_result_prenorm_noncorrect_D = Quotient_DP[C_DIV_MANT:0];
			Msc_forcorrect_D = {23'b00000000000000000000000, Msc_D};
		end
	assign Mant_result_prenorm_correct_D = Mant_result_prenorm_noncorrect_D + {(Div_enable_SO ? Msc_forcorrect_D : 24'b000000000000000000000000)};
	assign Mant_result_prenorm_DO = (Mant_result_prenorm_correct_D[C_DIV_MANT + 1] ? Mant_result_prenorm_noncorrect_D : Mant_result_prenorm_correct_D[C_DIV_MANT:0]);
	wire [C_DIV_EXP + 1:0] Exp_result_prenorm_DN;
	reg [C_DIV_EXP + 1:0] Exp_result_prenorm_DP;
	wire [C_DIV_EXP + 1:0] Exp_add_a_D;
	wire [C_DIV_EXP + 1:0] Exp_add_b_D;
	wire [C_DIV_EXP + 1:0] Exp_add_c_D;
	assign Exp_add_a_D = {(Sqrt_start_dly_S ? {Exp_num_DI[C_DIV_EXP], Exp_num_DI[C_DIV_EXP], Exp_num_DI[C_DIV_EXP], Exp_num_DI[C_DIV_EXP:1]} : {Exp_num_DI[C_DIV_EXP], Exp_num_DI[C_DIV_EXP], Exp_num_DI})};
	assign Exp_add_b_D = {(Sqrt_start_dly_S ? {1'b0, {C_DIV_EXP_ZERO}, Exp_num_DI[0]} : {~Exp_den_DI[C_DIV_EXP], ~Exp_den_DI[C_DIV_EXP], ~Exp_den_DI})};
	assign Exp_add_c_D = {(Div_start_dly_S ? {2'b00, {C_DIV_BIAS_AONE}} : {2'b00, {C_DIV_HALF_BIAS}})};
	assign Exp_result_prenorm_DN = (Start_dly_S ? {(Exp_add_a_D + Exp_add_b_D) + Exp_add_c_D} : Exp_result_prenorm_DP);
	always @(posedge Clk_CI or negedge Rst_RBI)
		if (~Rst_RBI)
			Exp_result_prenorm_DP <= 1'sb0;
		else
			Exp_result_prenorm_DP <= Exp_result_prenorm_DN;
	assign Exp_result_prenorm_DO = Exp_result_prenorm_DP;
endmodule
