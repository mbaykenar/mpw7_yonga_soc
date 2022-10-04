module zeroriscy_multdiv_fast (
	clk,
	rst_n,
	mult_en_i,
	div_en_i,
	operator_i,
	signed_mode_i,
	op_a_i,
	op_b_i,
	alu_adder_ext_i,
	alu_adder_i,
	equal_to_zero,
	alu_operand_a_o,
	alu_operand_b_o,
	multdiv_result_o,
	ready_o
);
parameter OPCODE_SYSTEM    = 7'h73;
parameter OPCODE_FENCE     = 7'h0f;
parameter OPCODE_OP        = 7'h33;
parameter OPCODE_OPIMM     = 7'h13;
parameter OPCODE_STORE     = 7'h23;
parameter OPCODE_LOAD      = 7'h03;
parameter OPCODE_BRANCH    = 7'h63;
parameter OPCODE_JALR      = 7'h67;
parameter OPCODE_JAL       = 7'h6f;
parameter OPCODE_AUIPC     = 7'h17;
parameter OPCODE_LUI       = 7'h37;

// those opcodes are now used for PULP custom instructions
// parameter OPCODE_CUST0     = 7'h0b
// parameter OPCODE_CUST1     = 7'h2b

// PULP custom
parameter OPCODE_LOAD_POST  = 7'h0b;
parameter OPCODE_STORE_POST = 7'h2b;
parameter OPCODE_PULP_OP    = 7'h5b;
parameter OPCODE_VECOP      = 7'h57;
parameter OPCODE_HWLOOP     = 7'h7b;

parameter REGC_S1   = 2'b10;
parameter REGC_RD   = 2'b01;
parameter REGC_ZERO = 2'b11;


//////////////////////////////////////////////////////////////////////////////
//      _    _    _   _    ___                       _   _                  //
//     / \  | |  | | | |  / _ \ _ __   ___ _ __ __ _| |_(_) ___  _ __  ___  //
//    / _ \ | |  | | | | | | | | '_ \ / _ \ '__/ _` | __| |/ _ \| '_ \/ __| //
//   / ___ \| |__| |_| | | |_| | |_) |  __/ | | (_| | |_| | (_) | | | \__ \ //
//  /_/   \_\_____\___/   \___/| .__/ \___|_|  \__,_|\__|_|\___/|_| |_|___/ //
//                             |_|                                          //
//////////////////////////////////////////////////////////////////////////////

parameter ALU_OP_WIDTH = 6;

parameter ALU_ADD   = 6'b011000;
parameter ALU_SUB   = 6'b011001;
parameter ALU_ADDU  = 6'b011010;
parameter ALU_SUBU  = 6'b011011;
parameter ALU_ADDR  = 6'b011100;
parameter ALU_SUBR  = 6'b011101;
parameter ALU_ADDUR = 6'b011110;
parameter ALU_SUBUR = 6'b011111;

parameter ALU_XOR   = 6'b101111;
parameter ALU_OR    = 6'b101110;
parameter ALU_AND   = 6'b010101;

// Shifts
parameter ALU_SRA   = 6'b100100;
parameter ALU_SRL   = 6'b100101;
parameter ALU_ROR   = 6'b100110;
parameter ALU_SLL   = 6'b100111;

// bit manipulation
parameter ALU_BEXT  = 6'b101000;
parameter ALU_BEXTU = 6'b101001;
parameter ALU_BINS  = 6'b101010;
parameter ALU_BCLR  = 6'b101011;
parameter ALU_BSET  = 6'b101100;

// Bit counting
parameter ALU_FF1   = 6'b110110;
parameter ALU_FL1   = 6'b110111;
parameter ALU_CNT   = 6'b110100;
parameter ALU_CLB   = 6'b110101;

// Sign-/zero-extensions
parameter ALU_EXTS  = 6'b111110;
parameter ALU_EXT   = 6'b111111;

// Comparisons
parameter ALU_LTS   = 6'b000000;
parameter ALU_LTU   = 6'b000001;
parameter ALU_LES   = 6'b000100;
parameter ALU_LEU   = 6'b000101;
parameter ALU_GTS   = 6'b001000;
parameter ALU_GTU   = 6'b001001;
parameter ALU_GES   = 6'b001010;
parameter ALU_GEU   = 6'b001011;
parameter ALU_EQ    = 6'b001100;
parameter ALU_NE    = 6'b001101;

// Set Lower Than operations
parameter ALU_SLTS  = 6'b000010;
parameter ALU_SLTU  = 6'b000011;
parameter ALU_SLETS = 6'b000110;
parameter ALU_SLETU = 6'b000111;

// Absolute value
parameter ALU_ABS   = 6'b010100;
parameter ALU_CLIP  = 6'b010110;
parameter ALU_CLIPU = 6'b010111;

// Insert/extract
parameter ALU_INS   = 6'b101101;

// min/max
parameter ALU_MIN   = 6'b010000;
parameter ALU_MINU  = 6'b010001;
parameter ALU_MAX   = 6'b010010;
parameter ALU_MAXU  = 6'b010011;

// div/rem
parameter ALU_DIVU  = 6'b110000; // bit 0 is used for signed mode, bit 1 is used for remdiv
parameter ALU_DIV   = 6'b110001; // bit 0 is used for signed mode, bit 1 is used for remdiv
parameter ALU_REMU  = 6'b110010; // bit 0 is used for signed mode, bit 1 is used for remdiv
parameter ALU_REM   = 6'b110011; // bit 0 is used for signed mode, bit 1 is used for remdiv

parameter ALU_SHUF  = 6'b111010;
parameter ALU_SHUF2 = 6'b111011;
parameter ALU_PCKLO = 6'b111000;
parameter ALU_PCKHI = 6'b111001;


parameter MD_OP_MULL  = 2'b00;
parameter MD_OP_MULH  = 2'b01;
parameter MD_OP_DIV   = 2'b10;
parameter MD_OP_REM   = 2'b11;

// vector modes
parameter VEC_MODE32 = 2'b00;
parameter VEC_MODE16 = 2'b10;
parameter VEC_MODE8  = 2'b11;


/////////////////////////////////////////////////////////
//    ____ ____    ____            _     _             //
//   / ___/ ___|  |  _ \ ___  __ _(_)___| |_ ___ _ __  //
//  | |   \___ \  | |_) / _ \/ _` | / __| __/ _ \ '__| //
//  | |___ ___) | |  _ <  __/ (_| | \__ \ ||  __/ |    //
//   \____|____/  |_| \_\___|\__, |_|___/\__\___|_|    //
//                           |___/                     //
/////////////////////////////////////////////////////////

// CSR operations
parameter CSR_OP_NONE  = 2'b00;
parameter CSR_OP_WRITE = 2'b01;
parameter CSR_OP_SET   = 2'b10;
parameter CSR_OP_CLEAR = 2'b11;


// SPR for debugger, not accessible by CPU
parameter SP_DVR0       = 16'h3000;
parameter SP_DCR0       = 16'h3008;
parameter SP_DMR1       = 16'h3010;
parameter SP_DMR2       = 16'h3011;

parameter SP_DVR_MSB = 8'h00;
parameter SP_DCR_MSB = 8'h01;
parameter SP_DMR_MSB = 8'h02;
parameter SP_DSR_MSB = 8'h04;

// Privileged mode
typedef enum logic[1:0] {
  PRIV_LVL_M = 2'b11,
  PRIV_LVL_H = 2'b10,
  PRIV_LVL_S = 2'b01,
  PRIV_LVL_U = 2'b00
} PrivLvl_t;

///////////////////////////////////////////////
//   ___ ____    ____  _                     //
//  |_ _|  _ \  / ___|| |_ __ _  __ _  ___   //
//   | || | | | \___ \| __/ _` |/ _` |/ _ \  //
//   | || |_| |  ___) | || (_| | (_| |  __/  //
//  |___|____/  |____/ \__\__,_|\__, |\___|  //
//                              |___/        //
///////////////////////////////////////////////

// forwarding operand mux
parameter SEL_REGFILE      = 2'b00;
parameter SEL_FW_EX        = 2'b01;
parameter SEL_FW_WB        = 2'b10;
parameter SEL_MISALIGNED   = 2'b11;

// operand a selection
parameter OP_A_REGA_OR_FWD = 3'b000;
parameter OP_A_CURRPC      = 3'b001;
parameter OP_A_IMM         = 3'b010;
parameter OP_A_REGB_OR_FWD = 3'b011;
parameter OP_A_REGC_OR_FWD = 3'b100;

// immediate a selection
parameter IMMA_Z      = 1'b0;
parameter IMMA_ZERO   = 1'b1;

// operand b selection
parameter OP_B_REGB_OR_FWD = 3'b000;
parameter OP_B_REGC_OR_FWD = 3'b001;
parameter OP_B_IMM         = 3'b010;
parameter OP_B_REGA_OR_FWD = 3'b011;
parameter OP_B_BMASK       = 3'b100;
parameter OP_B_ZERO        = 3'b101;

// immediate b selection
parameter IMMB_I      = 4'b0000;
parameter IMMB_S      = 4'b0001;
parameter IMMB_U      = 4'b0010;
parameter IMMB_PCINCR = 4'b0011;
parameter IMMB_S2     = 4'b0100;
parameter IMMB_S3     = 4'b0101;
parameter IMMB_VS     = 4'b0110;
parameter IMMB_VU     = 4'b0111;
parameter IMMB_SHUF   = 4'b1000;
parameter IMMB_CLIP   = 4'b1001;
parameter IMMB_BI     = 4'b1011;
parameter IMMB_UJ	  = 4'b1100;
parameter IMMB_SB	  = 4'b1101;

// bit mask selection
parameter BMASK_A_ZERO = 1'b0;
parameter BMASK_A_S3   = 1'b1;

parameter BMASK_B_S2   = 2'b00;
parameter BMASK_B_S3   = 2'b01;
parameter BMASK_B_ZERO = 2'b10;
parameter BMASK_B_ONE  = 2'b11;

parameter BMASK_A_REG  = 1'b0;
parameter BMASK_A_IMM  = 1'b1;
parameter BMASK_B_REG  = 1'b0;
parameter BMASK_B_IMM  = 1'b1;



///////////////////////////////////////////////
//   ___ _____   ____  _                     //
//  |_ _|  ___| / ___|| |_ __ _  __ _  ___   //
//   | || |_    \___ \| __/ _` |/ _` |/ _ \  //
//   | ||  _|    ___) | || (_| | (_| |  __/  //
//  |___|_|     |____/ \__\__,_|\__, |\___|  //
//                              |___/        //
///////////////////////////////////////////////

// PC mux selector defines
parameter PC_BOOT          = 3'b000;
parameter PC_JUMP          = 3'b010;
parameter PC_EXCEPTION     = 3'b100;
parameter PC_ERET          = 3'b101;
parameter PC_DBG_NPC       = 3'b111;

// Exception PC mux selector defines
parameter EXC_PC_ILLINSN   = 2'b00;
parameter EXC_PC_ECALL     = 2'b01;
parameter EXC_PC_LOAD      = 2'b10;
parameter EXC_PC_STORE     = 2'b10;
parameter EXC_PC_IRQ       = 2'b11;

// Exception Cause
parameter EXC_CAUSE_ILLEGAL_INSN = 6'h02;
parameter EXC_CAUSE_BREAKPOINT   = 6'h03;
parameter EXC_CAUSE_ECALL_MMODE  = 6'h0B;

// Exceptions offsets
// target address = {boot_addr[31:8], EXC_OFF} (boot_addr must be 32 BYTE aligned!)
// offset 00 to 7e is used for external interrupts
parameter EXC_OFF_RST      = 8'h80;
parameter EXC_OFF_ILLINSN  = 8'h84;
parameter EXC_OFF_ECALL    = 8'h88;
parameter EXC_OFF_LSUERR   = 8'h8c;


// Debug module
parameter DBG_SETS_W = 6;

parameter DBG_SETS_IRQ    = 5;
parameter DBG_SETS_ECALL  = 4;
parameter DBG_SETS_EILL   = 3;
parameter DBG_SETS_ELSU   = 2;
parameter DBG_SETS_EBRK   = 1;
parameter DBG_SETS_SSTE   = 0;

parameter DBG_CAUSE_HALT   = 6'h1F;
	input wire clk;
	input wire rst_n;
	input wire mult_en_i;
	input wire div_en_i;
	input wire [1:0] operator_i;
	input wire [1:0] signed_mode_i;
	input wire [31:0] op_a_i;
	input wire [31:0] op_b_i;
	input wire [33:0] alu_adder_ext_i;
	input wire [31:0] alu_adder_i;
	input wire equal_to_zero;
	output reg [32:0] alu_operand_a_o;
	output reg [32:0] alu_operand_b_o;
	output wire [31:0] multdiv_result_o;
	output wire ready_o;
	reg [4:0] div_counter_q;
	reg [4:0] div_counter_n;
	reg [1:0] mult_state_q;
	reg [1:0] mult_state_n;
	reg [2:0] divcurr_state_q;
	reg [2:0] divcurr_state_n;
	wire [34:0] mac_res_ext;
	reg [33:0] mac_res_q;
	reg [33:0] mac_res_n;
	wire [33:0] mac_res;
	reg [33:0] op_reminder_n;
	reg [15:0] mult_op_a;
	reg [15:0] mult_op_b;
	reg [33:0] accum;
	reg sign_a;
	reg sign_b;
	wire div_sign_a;
	wire div_sign_b;
	wire signed_mult;
	reg is_greater_equal;
	wire div_change_sign;
	wire rem_change_sign;
	wire [31:0] one_shift;
	reg [31:0] op_denominator_q;
	reg [31:0] op_numerator_q;
	reg [31:0] op_quotient_q;
	reg [31:0] op_denominator_n;
	reg [31:0] op_numerator_n;
	reg [31:0] op_quotient_n;
	wire [32:0] next_reminder;
	wire [32:0] next_quotient;
	wire [32:0] res_adder_h;
	reg mult_is_ready;
	always @(posedge clk or negedge rst_n) begin : proc_mult_state_q
		if (~rst_n) begin
			mult_state_q <= 2'd0;
			mac_res_q <= 1'sb0;
			div_counter_q <= 1'sb0;
			divcurr_state_q <= 3'd0;
			op_denominator_q <= 1'sb0;
			op_numerator_q <= 1'sb0;
			op_quotient_q <= 1'sb0;
		end
		else begin
			if (mult_en_i)
				mult_state_q <= mult_state_n;
			if (div_en_i) begin
				div_counter_q <= div_counter_n;
				op_denominator_q <= op_denominator_n;
				op_numerator_q <= op_numerator_n;
				op_quotient_q <= op_quotient_n;
				divcurr_state_q <= divcurr_state_n;
			end
			case (1'b1)
				mult_en_i: mac_res_q <= mac_res_n;
				div_en_i: mac_res_q <= op_reminder_n;
				default: mac_res_q <= mac_res_q;
			endcase
		end
	end
	assign signed_mult = signed_mode_i != 2'b00;
	assign multdiv_result_o = (div_en_i ? mac_res_q[31:0] : mac_res_n[31:0]);
	assign mac_res_ext = ($signed({sign_a, mult_op_a}) * $signed({sign_b, mult_op_b})) + $signed(accum);
	assign mac_res = mac_res_ext[33:0];
	assign res_adder_h = alu_adder_ext_i[33:1];
	assign next_reminder = (is_greater_equal ? res_adder_h : mac_res_q[32:0]);
	assign next_quotient = (is_greater_equal ? op_quotient_q | one_shift : op_quotient_q);
	assign one_shift = 32'b00000000000000000000000000000001 << div_counter_q;
	always @(*)
		if ((mac_res_q[31] ^ op_denominator_q[31]) == 0)
			is_greater_equal = res_adder_h[31] == 0;
		else
			is_greater_equal = mac_res_q[31];
	assign div_sign_a = op_a_i[31] & signed_mode_i[0];
	assign div_sign_b = op_b_i[31] & signed_mode_i[1];
	assign div_change_sign = div_sign_a ^ div_sign_b;
	assign rem_change_sign = div_sign_a;
	always @(*) begin : div_fsm
		div_counter_n = div_counter_q - 1;
		op_reminder_n = mac_res_q;
		op_quotient_n = op_quotient_q;
		divcurr_state_n = divcurr_state_q;
		op_numerator_n = op_numerator_q;
		op_denominator_n = op_denominator_q;
		alu_operand_a_o = 33'b000000000000000000000000000000001;
		alu_operand_b_o = {~op_b_i, 1'b1};
		case (divcurr_state_q)
			3'd0: begin
				case (operator_i)
					MD_OP_DIV: begin
						op_reminder_n = 1'sb1;
						divcurr_state_n = (equal_to_zero ? 3'd6 : 3'd1);
					end
					default: begin
						op_reminder_n = {2'b00, op_a_i};
						divcurr_state_n = (equal_to_zero ? 3'd6 : 3'd1);
					end
				endcase
				alu_operand_a_o = 33'b000000000000000000000000000000001;
				alu_operand_b_o = {~op_b_i, 1'b1};
				div_counter_n = 5'd31;
			end
			3'd1: begin
				op_quotient_n = 1'sb0;
				op_numerator_n = (div_sign_a ? alu_adder_i : op_a_i);
				divcurr_state_n = 3'd2;
				div_counter_n = 5'd31;
				alu_operand_a_o = 33'b000000000000000000000000000000001;
				alu_operand_b_o = {~op_a_i, 1'b1};
			end
			3'd2: begin
				op_reminder_n = {33'h000000000, op_numerator_q[31]};
				op_denominator_n = (div_sign_b ? alu_adder_i : op_b_i);
				divcurr_state_n = 3'd3;
				div_counter_n = 5'd31;
				alu_operand_a_o = 33'b000000000000000000000000000000001;
				alu_operand_b_o = {~op_b_i, 1'b1};
			end
			3'd3: begin
				op_reminder_n = {1'b0, next_reminder[31:0], op_numerator_q[div_counter_n]};
				op_quotient_n = next_quotient;
				if (div_counter_q == 5'd1)
					divcurr_state_n = 3'd4;
				else
					divcurr_state_n = 3'd3;
				alu_operand_a_o = {mac_res_q[31:0], 1'b1};
				alu_operand_b_o = {~op_denominator_q[31:0], 1'b1};
			end
			3'd4: begin
				case (operator_i)
					MD_OP_DIV: op_reminder_n = {1'b0, next_quotient};
					default: op_reminder_n = {2'b00, next_reminder[31:0]};
				endcase
				alu_operand_a_o = {mac_res_q[31:0], 1'b1};
				alu_operand_b_o = {~op_denominator_q[31:0], 1'b1};
				divcurr_state_n = 3'd5;
			end
			3'd5: begin
				divcurr_state_n = 3'd6;
				case (operator_i)
					MD_OP_DIV: op_reminder_n = (div_change_sign ? alu_adder_i : mac_res_q);
					default: op_reminder_n = (rem_change_sign ? alu_adder_i : mac_res_q);
				endcase
				alu_operand_a_o = 33'b000000000000000000000000000000001;
				alu_operand_b_o = {~mac_res_q[31:0], 1'b1};
			end
			3'd6: divcurr_state_n = 3'd0;
			default:
				;
		endcase
	end
	assign ready_o = mult_is_ready | (divcurr_state_q == 3'd6);
	always @(*) begin : mult_fsm
		mult_op_a = op_a_i[15:0];
		mult_op_b = op_b_i[15:0];
		sign_a = 1'b0;
		sign_b = 1'b0;
		accum = mac_res_q;
		mac_res_n = mac_res;
		mult_state_n = mult_state_q;
		mult_is_ready = 1'b0;
		case (mult_state_q)
			2'd0: begin
				mult_op_a = op_a_i[15:0];
				mult_op_b = op_b_i[15:0];
				sign_a = 1'b0;
				sign_b = 1'b0;
				accum = 1'sb0;
				mac_res_n = mac_res;
				mult_state_n = 2'd1;
			end
			2'd1: begin
				mult_op_a = op_a_i[15:0];
				mult_op_b = op_b_i[31:16];
				sign_a = 1'b0;
				sign_b = signed_mode_i[1] & op_b_i[31];
				accum = {18'b000000000000000000, mac_res_q[31:16]};
				case (operator_i)
					MD_OP_MULL: mac_res_n = {2'b00, mac_res[15:0], mac_res_q[15:0]};
					default: mac_res_n = mac_res;
				endcase
				mult_state_n = 2'd2;
			end
			2'd2: begin
				mult_op_a = op_a_i[31:16];
				mult_op_b = op_b_i[15:0];
				sign_a = signed_mode_i[0] & op_a_i[31];
				sign_b = 1'b0;
				case (operator_i)
					MD_OP_MULL: begin
						accum = {18'b000000000000000000, mac_res_q[31:16]};
						mac_res_n = {2'b00, mac_res[15:0], mac_res_q[15:0]};
						mult_is_ready = 1'b1;
						mult_state_n = 2'd0;
					end
					default: begin
						accum = mac_res_q;
						mac_res_n = mac_res;
						mult_state_n = 2'd3;
					end
				endcase
			end
			2'd3: begin
				mult_op_a = op_a_i[31:16];
				mult_op_b = op_b_i[31:16];
				sign_a = signed_mode_i[0] & op_a_i[31];
				sign_b = signed_mode_i[1] & op_b_i[31];
				accum[17:0] = mac_res_q[33:16];
				accum[33:18] = {18 {signed_mult & mac_res_q[33]}};
				mac_res_n = mac_res;
				mult_state_n = 2'd0;
				mult_is_ready = 1'b1;
			end
			default:
				;
		endcase
	end
endmodule
