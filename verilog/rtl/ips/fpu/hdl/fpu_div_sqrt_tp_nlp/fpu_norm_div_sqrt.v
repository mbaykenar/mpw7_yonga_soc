module fpu_norm_div_sqrt (
	Mant_in_DI,
	Exp_in_DI,
	Sign_in_DI,
	Div_enable_SI,
	Sqrt_enable_SI,
	Inf_a_SI,
	Inf_b_SI,
	Zero_a_SI,
	Zero_b_SI,
	NaN_a_SI,
	NaN_b_SI,
	RM_SI,
	Mant_res_DO,
	Exp_res_DO,
	Sign_res_DO,
	Exp_OF_SO,
	Exp_UF_SO,
	Div_zero_SO
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
	input wire [C_DIV_MANT_PRENORM - 1:0] Mant_in_DI;
	input wire signed [C_DIV_EXP + 1:0] Exp_in_DI;
	input wire Sign_in_DI;
	input wire Div_enable_SI;
	input wire Sqrt_enable_SI;
	input wire Inf_a_SI;
	input wire Inf_b_SI;
	input wire Zero_a_SI;
	input wire Zero_b_SI;
	input wire NaN_a_SI;
	input wire NaN_b_SI;
	input wire [C_DIV_RM - 1:0] RM_SI;
	output wire [C_DIV_MANT - 1:0] Mant_res_DO;
	output wire [C_DIV_EXP - 1:0] Exp_res_DO;
	output reg Sign_res_DO;
	output reg Exp_OF_SO;
	output reg Exp_UF_SO;
	output reg Div_zero_SO;
	reg [C_DIV_MANT:0] Mant_res_norm_D;
	reg [C_DIV_EXP - 1:0] Exp_res_norm_D;
	wire [C_DIV_EXP + 1:0] Exp_Max_RS_D;
	assign Exp_Max_RS_D = (Exp_in_DI[C_DIV_EXP:0] + C_DIV_MANT) + 1;
	wire [C_DIV_EXP + 1:0] Num_RS_D;
	assign Num_RS_D = ~Exp_in_DI + 2;
	wire [C_DIV_MANT_PRENORM + 1:0] Mant_RS_D;
	wire [C_DIV_MANT - 2:0] Mant_forsticky_D;
	assign {Mant_RS_D, Mant_forsticky_D} = {Mant_in_DI, 1'b0, 1'b0, 22'h000000} >> Num_RS_D;
	wire Mant_sticky_D;
	assign Mant_sticky_D = (Exp_in_DI[C_DIV_EXP + 1] && Exp_Max_RS_D[C_DIV_EXP + 1]) && |Mant_forsticky_D;
	reg [1:0] Mant_lower_D;
	always @(*)
		if (NaN_a_SI) begin
			Div_zero_SO = 1'b0;
			Exp_OF_SO = 1'b0;
			Exp_UF_SO = 1'b0;
			Mant_res_norm_D = {1'b0, C_DIV_MANT_NAN};
			Exp_res_norm_D = 1'sb1;
			Mant_lower_D = 2'b00;
			Sign_res_DO = 1'b0;
		end
		else if (NaN_b_SI) begin
			Div_zero_SO = 1'b0;
			Exp_OF_SO = 1'b0;
			Exp_UF_SO = 1'b0;
			Mant_res_norm_D = {1'b0, C_DIV_MANT_NAN};
			Exp_res_norm_D = 1'sb1;
			Mant_lower_D = 2'b00;
			Sign_res_DO = 1'b0;
		end
		else if (Inf_a_SI) begin
			if (Div_enable_SI && Inf_b_SI) begin
				Div_zero_SO = 1'b0;
				Exp_OF_SO = 1'b0;
				Exp_UF_SO = 1'b0;
				Mant_res_norm_D = {1'b0, C_DIV_MANT_NAN};
				Exp_res_norm_D = 1'sb1;
				Mant_lower_D = 2'b00;
				Sign_res_DO = 1'b0;
			end
			else begin
				Div_zero_SO = 1'b0;
				Exp_OF_SO = 1'b1;
				Exp_UF_SO = 1'b0;
				Mant_res_norm_D = 1'sb0;
				Exp_res_norm_D = 1'sb1;
				Mant_lower_D = 2'b00;
				Sign_res_DO = Sign_in_DI;
			end
		end
		else if (Div_enable_SI && Inf_b_SI) begin
			Div_zero_SO = 1'b0;
			Exp_OF_SO = 1'b1;
			Exp_UF_SO = 1'b0;
			Mant_res_norm_D = 1'sb0;
			Exp_res_norm_D = 1'sb0;
			Mant_lower_D = 2'b00;
			Sign_res_DO = Sign_in_DI;
		end
		else if (Zero_a_SI) begin
			if (Div_enable_SI && Zero_b_SI) begin
				Div_zero_SO = 1'b1;
				Exp_OF_SO = 1'b0;
				Exp_UF_SO = 1'b0;
				Mant_res_norm_D = {1'b0, C_DIV_MANT_NAN};
				Exp_res_norm_D = 1'sb1;
				Mant_lower_D = 2'b00;
				Sign_res_DO = 1'b0;
			end
			else begin
				Div_zero_SO = 1'b0;
				Exp_OF_SO = 1'b0;
				Exp_UF_SO = 1'b0;
				Mant_res_norm_D = 1'sb0;
				Exp_res_norm_D = 1'sb0;
				Mant_lower_D = 2'b00;
				Sign_res_DO = Sign_in_DI;
			end
		end
		else if (Div_enable_SI && Zero_b_SI) begin
			Div_zero_SO = 1'b1;
			Exp_OF_SO = 1'b0;
			Exp_UF_SO = 1'b0;
			Mant_res_norm_D = 1'sb0;
			Exp_res_norm_D = 1'sb1;
			Mant_lower_D = 2'b00;
			Sign_res_DO = Sign_in_DI;
		end
		else if (Sign_in_DI && Sqrt_enable_SI) begin
			Div_zero_SO = 1'b0;
			Exp_OF_SO = 1'b0;
			Exp_UF_SO = 1'b0;
			Mant_res_norm_D = {1'b0, C_DIV_MANT_NAN};
			Exp_res_norm_D = 1'sb1;
			Mant_lower_D = 2'b00;
			Sign_res_DO = 1'b0;
		end
		else if (Exp_in_DI[C_DIV_EXP:0] == {(C_DIV_EXP >= 0 ? C_DIV_EXP + 1 : 1 - C_DIV_EXP) {1'sb0}}) begin
			if (Mant_in_DI != {C_DIV_MANT_PRENORM {1'sb0}}) begin
				Div_zero_SO = 1'b0;
				Exp_OF_SO = 1'b0;
				Exp_UF_SO = 1'b1;
				Mant_res_norm_D = {2'b00, Mant_in_DI[C_DIV_MANT_PRENORM - 1:1]};
				Exp_res_norm_D = 1'sb0;
				Mant_lower_D = {Mant_in_DI[0], 1'b0};
				Sign_res_DO = Sign_in_DI;
			end
			else begin
				Div_zero_SO = 1'b0;
				Exp_OF_SO = 1'b0;
				Exp_UF_SO = 1'b0;
				Mant_res_norm_D = 1'sb0;
				Exp_res_norm_D = 1'sb0;
				Mant_lower_D = 2'b00;
				Sign_res_DO = Sign_in_DI;
			end
		end
		else if ((Exp_in_DI[C_DIV_EXP:0] == C_DIV_EXP_ONE) && ~Mant_in_DI[C_DIV_MANT_PRENORM - 1]) begin
			Div_zero_SO = 1'b0;
			Exp_OF_SO = 1'b0;
			Exp_UF_SO = 1'b1;
			Mant_res_norm_D = Mant_in_DI[C_DIV_MANT_PRENORM - 1:0];
			Exp_res_norm_D = 1'sb0;
			Mant_lower_D = 2'b00;
			Sign_res_DO = Sign_in_DI;
		end
		else if (Exp_in_DI[C_DIV_EXP + 1]) begin
			if (~Exp_Max_RS_D[C_DIV_EXP + 1]) begin
				Div_zero_SO = 1'b0;
				Exp_OF_SO = 1'b1;
				Exp_UF_SO = 1'b0;
				Mant_res_norm_D = 1'sb0;
				Exp_res_norm_D = 1'sb0;
				Mant_lower_D = 2'b00;
				Sign_res_DO = Sign_in_DI;
			end
			else begin
				Div_zero_SO = 1'b0;
				Exp_OF_SO = 1'b0;
				Exp_UF_SO = 1'b1;
				Mant_res_norm_D = {1'b0, Mant_RS_D[C_DIV_MANT + 1:2]};
				Exp_res_norm_D = 1'sb0;
				Mant_lower_D = Mant_RS_D[1:0];
				Sign_res_DO = Sign_in_DI;
			end
		end
		else if (Exp_in_DI[C_DIV_EXP]) begin
			Div_zero_SO = 1'b0;
			Exp_OF_SO = 1'b1;
			Exp_UF_SO = 1'b0;
			Mant_res_norm_D = 1'sb0;
			Exp_res_norm_D = 1'sb1;
			Mant_lower_D = 2'b00;
			Sign_res_DO = Sign_in_DI;
		end
		else if (Exp_in_DI[C_DIV_EXP - 1:0] == {C_DIV_EXP {1'sb1}}) begin
			if (~Mant_in_DI[C_DIV_MANT_PRENORM - 1]) begin
				Div_zero_SO = 1'b0;
				Exp_OF_SO = 1'b0;
				Exp_UF_SO = 1'b0;
				Mant_res_norm_D = {Mant_in_DI[C_DIV_MANT_PRENORM - 2:0], 1'b0};
				Exp_res_norm_D = Exp_in_DI[C_DIV_EXP - 1:0] - 1;
				Mant_lower_D = 2'b00;
				Sign_res_DO = Sign_in_DI;
			end
			else if (Mant_in_DI != {C_DIV_MANT_PRENORM {1'sb0}}) begin
				Div_zero_SO = 1'b0;
				Exp_OF_SO = 1'b1;
				Exp_UF_SO = 1'b0;
				Mant_res_norm_D = 1'sb0;
				Exp_res_norm_D = 1'sb1;
				Mant_lower_D = 2'b00;
				Sign_res_DO = Sign_in_DI;
			end
			else begin
				Div_zero_SO = 1'b0;
				Exp_OF_SO = 1'b1;
				Exp_UF_SO = 1'b0;
				Mant_res_norm_D = 1'sb0;
				Exp_res_norm_D = 1'sb1;
				Mant_lower_D = 2'b00;
				Sign_res_DO = Sign_in_DI;
			end
		end
		else if (Mant_in_DI[C_DIV_MANT_PRENORM - 1]) begin
			Div_zero_SO = 1'b0;
			Exp_OF_SO = 1'b0;
			Exp_UF_SO = 1'b0;
			Mant_res_norm_D = Mant_in_DI[C_DIV_MANT_PRENORM - 1:0];
			Exp_res_norm_D = Exp_in_DI[C_DIV_EXP - 1:0];
			Mant_lower_D = 2'b00;
			Sign_res_DO = Sign_in_DI;
		end
		else begin
			Div_zero_SO = 1'b0;
			Exp_OF_SO = 1'b0;
			Exp_UF_SO = 1'b0;
			Mant_res_norm_D = {Mant_in_DI[C_DIV_MANT_PRENORM - 2:0], 1'b0};
			Exp_res_norm_D = Exp_in_DI[C_DIV_EXP - 1:0] - 1;
			Mant_lower_D = 2'b00;
			Sign_res_DO = Sign_in_DI;
		end
	wire [C_DIV_MANT:0] Mant_upper_D;
	wire [C_DIV_MANT + 1:0] Mant_upperRounded_D;
	reg Mant_roundUp_S;
	wire Mant_rounded_S;
	assign Mant_upper_D = Mant_res_norm_D;
	assign Mant_rounded_S = |Mant_lower_D | Mant_sticky_D;
	always @(*) begin
		Mant_roundUp_S = 1'b0;
		case (RM_SI)
			C_DIV_RM_NEAREST: Mant_roundUp_S = Mant_lower_D[1] && ((Mant_lower_D[0] | Mant_sticky_D) || Mant_upper_D[0]);
			C_DIV_RM_TRUNC: Mant_roundUp_S = 0;
			C_DIV_RM_PLUSINF: Mant_roundUp_S = Mant_rounded_S & ~Sign_in_DI;
			C_DIV_RM_MINUSINF: Mant_roundUp_S = Mant_rounded_S & Sign_in_DI;
			default: Mant_roundUp_S = 0;
		endcase
	end
	wire Mant_renorm_S;
	assign Mant_upperRounded_D = Mant_upper_D + Mant_roundUp_S;
	assign Mant_renorm_S = Mant_upperRounded_D[C_DIV_MANT + 1];
	wire Rounded_SO;
	assign Mant_res_DO = (Mant_renorm_S ? Mant_upperRounded_D[C_DIV_MANT:1] : Mant_upperRounded_D[C_DIV_MANT - 1:0]);
	assign Exp_res_DO = Exp_res_norm_D + Mant_renorm_S;
	assign Rounded_SO = Mant_rounded_S;
endmodule
