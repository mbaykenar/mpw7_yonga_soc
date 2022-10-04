module iteration_div_sqrt_first (
	A_DI,
	B_DI,
	Div_enable_SI,
	Div_start_dly_SI,
	Sqrt_enable_SI,
	D_DI,
	D_DO,
	Sum_DO,
	Carry_out_DO
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
	input wire [C_DIV_MANT + 1:0] A_DI;
	input wire [C_DIV_MANT + 1:0] B_DI;
	input wire Div_enable_SI;
	input wire Div_start_dly_SI;
	input wire Sqrt_enable_SI;
	input wire [1:0] D_DI;
	output wire [1:0] D_DO;
	output wire [C_DIV_MANT + 1:0] Sum_DO;
	output wire Carry_out_DO;
	wire D_carry_D;
	wire Sqrt_cin_D;
	wire Cin_D;
	assign D_DO[0] = ~D_DI[0];
	assign D_DO[1] = ~(D_DI[1] ^ D_DI[0]);
	assign D_carry_D = D_DI[1] | D_DI[0];
	assign Sqrt_cin_D = Sqrt_enable_SI && D_carry_D;
	assign Cin_D = (Div_enable_SI ? Div_start_dly_SI : Sqrt_cin_D);
	assign {Carry_out_DO, Sum_DO} = (A_DI + B_DI) + Cin_D;
endmodule
