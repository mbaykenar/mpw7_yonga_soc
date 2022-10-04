module fpu_norm_fmac (
	Mant_in_DI,
	Exp_in_DI,
	Sign_in_DI,
	Leading_one_DI,
	No_one_SI,
	Sign_amt_DI,
	Sub_SI,
	Exp_a_DI,
	Mant_a_DI,
	Sign_a_DI,
	DeN_a_SI,
	RM_SI,
	Stick_one_SI,
	Inf_a_SI,
	Inf_b_SI,
	Inf_c_SI,
	Zero_a_SI,
	Zero_b_SI,
	Zero_c_SI,
	NaN_a_SI,
	NaN_b_SI,
	NaN_c_SI,
	Mant_res_DO,
	Exp_res_DO,
	Sign_res_DO,
	Exp_OF_SO,
	Exp_UF_SO,
	Flag_Inexact_SO
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
	input wire [(3 * C_MANT) + 4:0] Mant_in_DI;
	input wire signed [C_EXP + 1:0] Exp_in_DI;
	input wire Sign_in_DI;
	input wire [C_LEADONE_WIDTH - 1:0] Leading_one_DI;
	input wire No_one_SI;
	input wire Sign_amt_DI;
	input wire Sub_SI;
	input wire [C_EXP - 1:0] Exp_a_DI;
	input wire [C_MANT:0] Mant_a_DI;
	input wire Sign_a_DI;
	input wire DeN_a_SI;
	input wire [C_RM - 1:0] RM_SI;
	input wire Stick_one_SI;
	input wire Inf_a_SI;
	input wire Inf_b_SI;
	input wire Inf_c_SI;
	input wire Zero_a_SI;
	input wire Zero_b_SI;
	input wire Zero_c_SI;
	input wire NaN_a_SI;
	input wire NaN_b_SI;
	input wire NaN_c_SI;
	output wire [C_MANT - 1:0] Mant_res_DO;
	output wire [C_EXP - 1:0] Exp_res_DO;
	output reg Sign_res_DO;
	output reg Exp_OF_SO;
	output reg Exp_UF_SO;
	output wire Flag_Inexact_SO;
	reg [C_MANT:0] Mant_res_norm_D;
	reg [C_EXP - 1:0] Exp_res_norm_D;
	reg [1:0] Mant_lower_D;
	wire Stick_one_HD;
	wire [(3 * C_MANT) + 4:0] Mant_postsft_D;
	wire [C_EXP + 1:0] Exp_postsft_D;
	wire [C_EXP + 1:0] Exp_postsft_addone_D;
	wire [C_LEADONE_WIDTH - 1:0] Leading_one_D;
	wire [C_EXP:0] LSt_Mant_D;
	assign Leading_one_D = (Sign_amt_DI | Mant_in_DI[(3 * C_MANT) + 4] ? 0 : Leading_one_DI);
	wire Exp_lg_S;
	assign Exp_lg_S = Exp_in_DI > Leading_one_D;
	assign LSt_Mant_D = (Exp_in_DI[C_EXP + 1] ? 0 : (Exp_lg_S ? Leading_one_D : Exp_in_DI[C_EXP:0] - 1));
	assign Mant_postsft_D = Mant_in_DI << LSt_Mant_D;
	assign Exp_postsft_D = (Exp_in_DI[C_EXP + 1] ? 0 : (Exp_lg_S ? Exp_in_DI - Leading_one_D : 1));
	assign Exp_postsft_addone_D = (Exp_in_DI - Leading_one_D) - 1;
	wire [C_EXP + 1:0] Exp_Max_RS_D;
	assign Exp_Max_RS_D = Exp_in_DI[C_EXP:0] + 74;
	wire [C_EXP + 1:0] Num_RS_D;
	assign Num_RS_D = ~Exp_in_DI + 2;
	wire [(3 * C_MANT) + 6:0] Mant_RS_D;
	assign Mant_RS_D = {Mant_in_DI, 1'b0, 1'b0} >> Num_RS_D;
	wire [(2 * C_MANT) + 1:0] Mant_StickCh_D;
	assign Mant_StickCh_D = (Exp_postsft_D[C_EXP + 1] ? Mant_RS_D[(2 * C_MANT) + 3:2] : (Exp_postsft_D[C_EXP + 1:0] == {((C_EXP + 1) >= 0 ? C_EXP + 2 : 1 - (C_EXP + 1)) {1'sb0}} ? Mant_postsft_D[(2 * C_MANT) + 2:1] : (Mant_postsft_D[(3 * C_MANT) + 4] | (Exp_postsft_D == 0) ? Mant_postsft_D[(2 * C_MANT) + 1:0] : {Mant_postsft_D[2 * C_MANT:0], 1'b0})));
	assign Stick_one_HD = |Mant_StickCh_D;
	wire Stick_one_D;
	assign Stick_one_D = Stick_one_HD;
	reg Mant_sticky_D;
	always @(*)
		if (((((NaN_a_SI | NaN_b_SI) | NaN_c_SI) | (Zero_b_SI && Inf_c_SI)) | (Zero_c_SI && Inf_b_SI)) | ((Sub_SI && Inf_a_SI) && (Inf_b_SI | Inf_c_SI))) begin
			Exp_OF_SO = 1'b0;
			Exp_UF_SO = 1'b0;
			Mant_res_norm_D = {1'b0, C_MANT_NAN};
			Exp_res_norm_D = 1'sb1;
			Mant_lower_D = 2'b00;
			Sign_res_DO = 1'b0;
			Mant_sticky_D = 1'b0;
		end
		else if ((Inf_a_SI | Inf_b_SI) | Inf_c_SI) begin
			Exp_OF_SO = 1'b1;
			Exp_UF_SO = 1'b0;
			Mant_res_norm_D = 1'sb0;
			Exp_res_norm_D = 1'sb1;
			Mant_lower_D = 2'b00;
			Sign_res_DO = Sign_in_DI;
			Mant_sticky_D = 1'b0;
		end
		else if (Sign_amt_DI) begin
			Exp_OF_SO = 1'b0;
			Exp_UF_SO = DeN_a_SI;
			Mant_res_norm_D = Mant_a_DI;
			Exp_res_norm_D = Exp_a_DI;
			Mant_lower_D = 2'b00;
			Sign_res_DO = Sign_a_DI;
			Mant_sticky_D = 1'b0;
		end
		else if (No_one_SI) begin
			Exp_OF_SO = 1'b0;
			Exp_UF_SO = 1'b0;
			Mant_res_norm_D = 1'sb0;
			Exp_res_norm_D = 1'sb0;
			Mant_lower_D = 2'b00;
			Sign_res_DO = Sign_in_DI;
			Mant_sticky_D = 1'b0;
		end
		else if (Exp_in_DI[C_EXP + 1]) begin
			if (~Exp_Max_RS_D[C_EXP + 1]) begin
				Exp_OF_SO = 1'b1;
				Exp_UF_SO = 1'b0;
				Mant_res_norm_D = 1'sb0;
				Exp_res_norm_D = 1'sb0;
				Mant_lower_D = 2'b00;
				Sign_res_DO = Sign_in_DI;
				Mant_sticky_D = 1'b0;
			end
			else begin
				Exp_OF_SO = 1'b0;
				Exp_UF_SO = 1'b1;
				Mant_res_norm_D = {1'b0, Mant_RS_D[(3 * C_MANT) + 6:(2 * C_MANT) + 6]};
				Exp_res_norm_D = 1'sb0;
				Mant_lower_D = Mant_RS_D[(2 * C_MANT) + 5:(2 * C_MANT) + 4];
				Sign_res_DO = Sign_in_DI;
				Mant_sticky_D = Stick_one_D;
			end
		end
		else if (((Exp_postsft_D[C_EXP:0] == 256) && ~Mant_postsft_D[(3 * C_MANT) + 4]) && (Mant_postsft_D[(3 * C_MANT) + 3:(2 * C_MANT) + 3] != {(((3 * C_MANT) + 3) >= ((2 * C_MANT) + 3) ? (((3 * C_MANT) + 3) - ((2 * C_MANT) + 3)) + 1 : (((2 * C_MANT) + 3) - ((3 * C_MANT) + 3)) + 1) {1'sb0}})) begin
			Exp_OF_SO = 1'b0;
			Exp_UF_SO = 1'b0;
			Mant_res_norm_D = {1'b0, C_MANT_NAN};
			Exp_res_norm_D = 1'sb1;
			Mant_lower_D = 2'b00;
			Sign_res_DO = 1'b0;
			Mant_sticky_D = 1'b0;
		end
		else if (Exp_postsft_D[C_EXP - 1:0] == {C_EXP {1'sb1}}) begin
			if (Mant_postsft_D[(3 * C_MANT) + 4]) begin
				Exp_OF_SO = 1'b1;
				Exp_UF_SO = 1'b0;
				Mant_res_norm_D = {1'b0, C_MANT_NAN};
				Exp_res_norm_D = 1'sb1;
				Mant_lower_D = 2'b00;
				Sign_res_DO = Sign_in_DI;
				Mant_sticky_D = 1'b0;
			end
			else if (Mant_postsft_D[(3 * C_MANT) + 4:(2 * C_MANT) + 4] == {(((3 * C_MANT) + 4) >= ((2 * C_MANT) + 4) ? (((3 * C_MANT) + 4) - ((2 * C_MANT) + 4)) + 1 : (((2 * C_MANT) + 4) - ((3 * C_MANT) + 4)) + 1) {1'sb0}}) begin
				Exp_OF_SO = 1'b1;
				Exp_UF_SO = 1'b0;
				Mant_res_norm_D = 1'sb0;
				Exp_res_norm_D = 1'sb1;
				Mant_lower_D = 2'b00;
				Sign_res_DO = Sign_in_DI;
				Mant_sticky_D = 1'b0;
			end
			else begin
				Exp_OF_SO = 1'b0;
				Exp_UF_SO = 1'b0;
				Mant_res_norm_D = Mant_postsft_D[(3 * C_MANT) + 3:(2 * C_MANT) + 3];
				Exp_res_norm_D = 254;
				Mant_lower_D = Mant_postsft_D[(2 * C_MANT) + 2:(2 * C_MANT) + 1];
				Sign_res_DO = Sign_in_DI;
				Mant_sticky_D = Stick_one_D;
			end
		end
		else if (Exp_postsft_D[C_EXP]) begin
			Exp_OF_SO = 1'b1;
			Exp_UF_SO = 1'b0;
			Mant_res_norm_D = 1'sb0;
			Exp_res_norm_D = 1'sb1;
			Mant_lower_D = 2'b00;
			Sign_res_DO = Sign_in_DI;
			Mant_sticky_D = 1'b0;
		end
		else if (Exp_postsft_D[C_EXP + 1:0] == {((C_EXP + 1) >= 0 ? C_EXP + 2 : 1 - (C_EXP + 1)) {1'sb0}}) begin
			Exp_OF_SO = 1'b0;
			Exp_UF_SO = 1'b1;
			Mant_res_norm_D = {1'b0, Mant_postsft_D[(3 * C_MANT) + 4:(2 * C_MANT) + 5]};
			Exp_res_norm_D = 1'sb0;
			Mant_lower_D = Mant_postsft_D[(2 * C_MANT) + 4:(2 * C_MANT) + 3];
			Sign_res_DO = Sign_in_DI;
			Mant_sticky_D = Stick_one_D;
		end
		else if (Exp_postsft_D[C_EXP + 1:0] == 1) begin
			if (Mant_postsft_D[(3 * C_MANT) + 4]) begin
				Exp_OF_SO = 1'b0;
				Exp_UF_SO = 1'b0;
				Mant_res_norm_D = {Mant_postsft_D[(3 * C_MANT) + 4:(2 * C_MANT) + 4]};
				Exp_res_norm_D = 1;
				Mant_lower_D = Mant_postsft_D[(2 * C_MANT) + 3:(2 * C_MANT) + 2];
				Sign_res_DO = Sign_in_DI;
				Mant_sticky_D = Stick_one_D;
			end
			else begin
				Exp_OF_SO = 1'b0;
				Exp_UF_SO = 1'b1;
				Mant_res_norm_D = {Mant_postsft_D[(3 * C_MANT) + 4:(2 * C_MANT) + 4]};
				Exp_res_norm_D = 1'sb0;
				Mant_lower_D = Mant_postsft_D[(2 * C_MANT) + 3:(2 * C_MANT) + 2];
				Sign_res_DO = Sign_in_DI;
				Mant_sticky_D = Stick_one_D;
			end
		end
		else if (~Mant_postsft_D[(3 * C_MANT) + 4]) begin
			Exp_OF_SO = 1'b0;
			Exp_UF_SO = 1'b0;
			Mant_res_norm_D = Mant_postsft_D[(3 * C_MANT) + 3:(2 * C_MANT) + 3];
			Exp_res_norm_D = Exp_postsft_addone_D[C_EXP - 1:0];
			Mant_lower_D = Mant_postsft_D[(2 * C_MANT) + 2:(2 * C_MANT) + 1];
			Sign_res_DO = Sign_in_DI;
			Mant_sticky_D = Stick_one_D;
		end
		else begin
			Exp_OF_SO = 1'b0;
			Exp_UF_SO = 1'b0;
			Mant_res_norm_D = Mant_postsft_D[(3 * C_MANT) + 4:(2 * C_MANT) + 4];
			Exp_res_norm_D = Exp_postsft_D[C_EXP - 1:0];
			Mant_lower_D = Mant_postsft_D[(2 * C_MANT) + 3:(2 * C_MANT) + 2];
			Sign_res_DO = Sign_in_DI;
			Mant_sticky_D = Stick_one_D;
		end
	wire [C_MANT:0] Mant_upper_D;
	wire [C_MANT + 1:0] Mant_upperRounded_D;
	reg Mant_roundUp_S;
	wire Mant_rounded_S;
	assign Mant_upper_D = Mant_res_norm_D;
	assign Flag_Inexact_SO = Mant_rounded_S;
	assign Mant_rounded_S = |Mant_lower_D | Mant_sticky_D;
	always @(*) begin
		Mant_roundUp_S = 1'b0;
		case (RM_SI)
			C_RM_NEAREST: Mant_roundUp_S = Mant_lower_D[1] && ((Mant_lower_D[0] | Mant_sticky_D) || Mant_upper_D[0]);
			C_RM_TRUNC: Mant_roundUp_S = 0;
			C_RM_PLUSINF: Mant_roundUp_S = Mant_rounded_S & ~Sign_in_DI;
			C_RM_MINUSINF: Mant_roundUp_S = Mant_rounded_S & Sign_in_DI;
			default: Mant_roundUp_S = 0;
		endcase
	end
	wire Mant_renorm_S;
	assign Mant_upperRounded_D = Mant_upper_D + Mant_roundUp_S;
	assign Mant_renorm_S = Mant_upperRounded_D[C_MANT + 1];
	wire Rounded_SO;
	assign Mant_res_DO = (Mant_renorm_S ? Mant_upperRounded_D[C_MANT:1] : Mant_upperRounded_D[C_MANT - 1:0]);
	assign Exp_res_DO = Exp_res_norm_D + Mant_renorm_S;
	assign Rounded_SO = Mant_rounded_S;
endmodule
