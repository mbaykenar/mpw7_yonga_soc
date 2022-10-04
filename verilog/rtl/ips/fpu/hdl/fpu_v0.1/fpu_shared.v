module fpu_shared 
#(
    parameter ADD_REGISTER = 1
    )
(
	Clk_CI,
	Rst_RBI,
	Interface
);
	//parameter ADD_REGISTER = 1;
	input wire Clk_CI;
	input wire Rst_RBI;
	input marx_apu_if.apu Interface;
	reg [C_OP - 1:0] Operand_a_D;
	reg [C_OP - 1:0] Operand_b_D;
	reg [C_CMD - 1:0] Op_S;
	reg [C_RM - 1:0] RM_S;
	reg Valid_S;
	reg [C_TAG - 1:0] Tag_D;
	generate
		if (ADD_REGISTER == 1) begin : genblk1
			wire [C_OP - 1:0] Operand_a_DN;
			wire [C_OP - 1:0] Operand_b_DN;
			wire [C_RM - 1:0] RM_SN;
			wire [C_CMD - 1:0] Op_SN;
			wire Valid_SN;
			wire [C_TAG - 1:0] Tag_DN;
			assign Operand_a_DN = Interface.arga_ds_d;
			assign Operand_b_DN = Interface.argb_ds_d;
			assign RM_SN = Interface.flags_ds_d;
			assign Op_SN = Interface.op_ds_d;
			assign Valid_SN = Interface.valid_ds_s;
			assign Tag_DN = Interface.tag_ds_d;
			always @(posedge Clk_CI or negedge Rst_RBI)
				if (~Rst_RBI) begin
					Operand_a_D <= 1'sb0;
					Operand_b_D <= 1'sb0;
					Op_S <= 1'sb0;
					RM_S <= 1'sb0;
					Valid_S <= 1'sb0;
					Tag_D <= 1'sb0;
				end
				else begin
					Operand_a_D <= Operand_a_DN;
					Operand_b_D <= Operand_b_DN;
					RM_S <= RM_SN;
					Op_S <= Op_SN;
					Valid_S <= Valid_SN;
					Tag_D <= Tag_DN;
				end
		end
		else begin : genblk1
			wire [C_OP:1] sv2v_tmp_6B435;
			assign sv2v_tmp_6B435 = Interface.arga_ds_d;
			always @(*) Operand_a_D = sv2v_tmp_6B435;
			wire [C_OP:1] sv2v_tmp_8961F;
			assign sv2v_tmp_8961F = Interface.argb_ds_d;
			always @(*) Operand_b_D = sv2v_tmp_8961F;
			wire [C_RM:1] sv2v_tmp_A4AE8;
			assign sv2v_tmp_A4AE8 = Interface.flags_ds_d;
			always @(*) RM_S = sv2v_tmp_A4AE8;
			wire [C_CMD:1] sv2v_tmp_AEC49;
			assign sv2v_tmp_AEC49 = Interface.op_ds_d;
			always @(*) Op_S = sv2v_tmp_AEC49;
			wire [1:1] sv2v_tmp_078D4;
			assign sv2v_tmp_078D4 = Interface.valid_ds_s;
			always @(*) Valid_S = sv2v_tmp_078D4;
			wire [C_TAG:1] sv2v_tmp_37E7A;
			assign sv2v_tmp_37E7A = Interface.tag_ds_d;
			always @(*) Tag_D = sv2v_tmp_37E7A;
		end
	endgenerate
	wire [C_OP - 1:0] Result_D;
	wire [C_FLAG - 1:0] Flags_S;
	wire UF_S;
	wire OF_S;
	wire Zero_S;
	wire IX_S;
	wire IV_S;
	wire Inf_S;
	fpu_core core(
		.Clk_CI(Clk_CI),
		.Rst_RBI(Rst_RBI),
		.Enable_SI(Valid_S),
		.Operand_a_DI(Operand_a_D),
		.Operand_b_DI(Operand_b_D),
		.RM_SI(RM_S),
		.OP_SI(Op_S),
		.Result_DO(Result_D),
		.OF_SO(OF_S),
		.UF_SO(UF_S),
		.Zero_SO(Zero_S),
		.IX_SO(IX_S),
		.IV_SO(IV_S),
		.Inf_SO(Inf_S)
	);
	reg ValidDelayed_SP;
	wire ValidDelayed_SN;
	reg [C_TAG - 1:0] TagDelayed_DP;
	wire [C_TAG - 1:0] TagDelayed_DN;
	assign ValidDelayed_SN = Valid_S;
	assign TagDelayed_DN = Tag_D;
	always @(posedge Clk_CI or negedge Rst_RBI)
		if (~Rst_RBI) begin
			ValidDelayed_SP <= 1'sb0;
			TagDelayed_DP <= 1'sb0;
		end
		else begin
			ValidDelayed_SP <= ValidDelayed_SN;
			TagDelayed_DP <= TagDelayed_DN;
		end
	assign Interface.result_us_d = Result_D;
	assign Interface.flags_us_d = {1'b0, Inf_S, IV_S, IX_S, Zero_S, 2'b00, UF_S, OF_S};
	assign Interface.tag_us_d = TagDelayed_DP;
	assign Interface.req_us_s = ValidDelayed_SP;
	assign Interface.ready_ds_s = 1'b1;
endmodule
