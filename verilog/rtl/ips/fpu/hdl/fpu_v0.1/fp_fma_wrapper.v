module fp_fma_wrapper 
#(
  parameter C_MAC_PIPE_REGS = 2,
  parameter RND_WIDTH       = 2,
  parameter STAT_WIDTH      = 5
)
(
	clk_i,
	rst_ni,
	En_i,
	OpA_i,
	OpB_i,
	OpC_i,
	Op_i,
	Rnd_i,
	Status_o,
	Res_o,
	Valid_o,
	Ready_o,
	Ack_i
);
	//parameter C_MAC_PIPE_REGS = 2;
	//parameter RND_WIDTH = 2;
	//parameter STAT_WIDTH = 5;
	input wire clk_i;
	input wire rst_ni;
	input wire En_i;
	input wire [31:0] OpA_i;
	input wire [31:0] OpB_i;
	input wire [31:0] OpC_i;
	input wire [1:0] Op_i;
	input wire [RND_WIDTH - 1:0] Rnd_i;
	output wire [STAT_WIDTH - 1:0] Status_o;
	output wire [31:0] Res_o;
	output wire Valid_o;
	output wire Ready_o;
	input wire Ack_i;
	parameter C_PRE_PIPE_REGS = C_MAC_PIPE_REGS - 1;
	parameter C_POST_PIPE_REGS = 1;
	reg [31:0] OpA_DP [0:C_PRE_PIPE_REGS];
	reg [31:0] OpB_DP [0:C_PRE_PIPE_REGS];
	reg [31:0] OpC_DP [0:C_PRE_PIPE_REGS];
	reg En_SP [0:C_PRE_PIPE_REGS];
	reg [RND_WIDTH - 1:0] Rnd_DP [0:C_PRE_PIPE_REGS];
	reg EnPost_SP [0:C_POST_PIPE_REGS];
	reg [31:0] Res_DP [0:C_POST_PIPE_REGS];
	reg [STAT_WIDTH - 1:0] Status_DP [0:C_POST_PIPE_REGS];
	wire [7:0] status;
	wire [32:1] sv2v_tmp_29B01;
	assign sv2v_tmp_29B01 = (En_i ? OpA_i : {32 {1'sb0}});
	always @(*) OpA_DP[0] = sv2v_tmp_29B01;
	wire [32:1] sv2v_tmp_0E9BB;
	assign sv2v_tmp_0E9BB = (En_i ? {OpB_i[31] ^ Op_i[1], OpB_i[30:0]} : {32 {1'sb0}});
	always @(*) OpB_DP[0] = sv2v_tmp_0E9BB;
	wire [32:1] sv2v_tmp_8E8DA;
	assign sv2v_tmp_8E8DA = (En_i ? {OpC_i[31] ^ Op_i[0], OpC_i[30:0]} : {32 {1'sb0}});
	always @(*) OpC_DP[0] = sv2v_tmp_8E8DA;
	wire [1:1] sv2v_tmp_1D7A2;
	assign sv2v_tmp_1D7A2 = En_i;
	always @(*) En_SP[0] = sv2v_tmp_1D7A2;
	wire [RND_WIDTH:1] sv2v_tmp_A3B99;
	assign sv2v_tmp_A3B99 = Rnd_i;
	always @(*) Rnd_DP[0] = sv2v_tmp_A3B99;
	wire [1:1] sv2v_tmp_45B84;
	assign sv2v_tmp_45B84 = En_SP[C_PRE_PIPE_REGS];
	always @(*) EnPost_SP[0] = sv2v_tmp_45B84;
	assign Res_o = Res_DP[C_POST_PIPE_REGS];
	assign Valid_o = EnPost_SP[C_POST_PIPE_REGS];
	assign Status_o = Status_DP[C_POST_PIPE_REGS];
	assign Ready_o = 1'b1;
	wire [STAT_WIDTH:1] sv2v_tmp_04800;
	assign sv2v_tmp_04800 = {2'b00, status[4], status[3], 1'b0};
	always @(*) Status_DP[0] = sv2v_tmp_04800;
	fmac fp_fma_i(
		.Operand_a_DI(OpC_DP[C_PRE_PIPE_REGS]),
		.Operand_b_DI(OpB_DP[C_PRE_PIPE_REGS]),
		.Operand_c_DI(OpA_DP[C_PRE_PIPE_REGS]),
		.RM_SI(Rnd_DP[C_PRE_PIPE_REGS]),
		.Result_DO(Res_DP[0]),
		.Exp_OF_SO(status[4]),
		.Exp_UF_SO(status[3]),
		.Exp_NX_SO(status[5])
	);
	genvar i;
	generate
		for (i = 1; i <= C_PRE_PIPE_REGS; i = i + 1) begin : g_pre_regs
			always @(posedge clk_i or negedge rst_ni) begin : p_pre_regs
				if (~rst_ni) begin
					En_SP[i] <= 1'sb0;
					OpA_DP[i] <= 1'sb0;
					OpB_DP[i] <= 1'sb0;
					OpC_DP[i] <= 1'sb0;
					Rnd_DP[i] <= 1'sb0;
				end
				else begin
					En_SP[i] <= En_SP[i - 1];
					if (En_SP[i - 1]) begin
						OpA_DP[i] <= OpA_DP[i - 1];
						OpB_DP[i] <= OpB_DP[i - 1];
						OpC_DP[i] <= OpC_DP[i - 1];
						Rnd_DP[i] <= Rnd_DP[i - 1];
					end
				end
			end
		end
	endgenerate
	genvar j;
	generate
		for (j = 1; j <= C_POST_PIPE_REGS; j = j + 1) begin : g_post_regs
			always @(posedge clk_i or negedge rst_ni) begin : p_post_regs
				if (~rst_ni) begin
					EnPost_SP[j] <= 1'sb0;
					Res_DP[j] <= 1'sb0;
					Status_DP[j] <= 1'sb0;
				end
				else begin
					EnPost_SP[j] <= EnPost_SP[j - 1];
					if (EnPost_SP[j - 1]) begin
						Res_DP[j] <= Res_DP[j - 1];
						Status_DP[j] <= Status_DP[j - 1];
					end
				end
			end
		end
	endgenerate
endmodule
