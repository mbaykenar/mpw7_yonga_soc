module zeroriscy_decoder 
#(
  parameter RV32M      = 1
)
(
	deassert_we_i,
	data_misaligned_i,
	branch_mux_i,
	jump_mux_i,
	illegal_insn_o,
	ebrk_insn_o,
	mret_insn_o,
	ecall_insn_o,
	pipe_flush_o,
	instr_rdata_i,
	illegal_c_insn_i,
	alu_operator_o,
	alu_op_a_mux_sel_o,
	alu_op_b_mux_sel_o,
	imm_a_mux_sel_o,
	imm_b_mux_sel_o,
	mult_int_en_o,
	div_int_en_o,
	multdiv_operator_o,
	multdiv_signed_mode_o,
	regfile_we_o,
	csr_access_o,
	csr_op_o,
	csr_status_o,
	data_req_o,
	data_we_o,
	data_type_o,
	data_sign_extension_o,
	data_reg_offset_o,
	data_load_event_o,
	jump_in_id_o,
	branch_in_id_o
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
	//parameter RV32M = 1;
	input wire deassert_we_i;
	input wire data_misaligned_i;
	input wire branch_mux_i;
	input wire jump_mux_i;
	output reg illegal_insn_o;
	output reg ebrk_insn_o;
	output reg mret_insn_o;
	output reg ecall_insn_o;
	output reg pipe_flush_o;
	input wire [31:0] instr_rdata_i;
	input wire illegal_c_insn_i;
	output reg [ALU_OP_WIDTH - 1:0] alu_operator_o;
	output reg [2:0] alu_op_a_mux_sel_o;
	output reg [2:0] alu_op_b_mux_sel_o;
	output reg [0:0] imm_a_mux_sel_o;
	output reg [3:0] imm_b_mux_sel_o;
	output wire mult_int_en_o;
	output wire div_int_en_o;
	output reg [1:0] multdiv_operator_o;
	output reg [1:0] multdiv_signed_mode_o;
	output wire regfile_we_o;
	output reg csr_access_o;
	output wire [1:0] csr_op_o;
	output reg csr_status_o;
	output wire data_req_o;
	output reg data_we_o;
	output reg [1:0] data_type_o;
	output reg data_sign_extension_o;
	output reg [1:0] data_reg_offset_o;
	output reg data_load_event_o;
	output wire jump_in_id_o;
	output wire branch_in_id_o;
	reg regfile_we;
	reg data_req;
	reg mult_int_en;
	reg div_int_en;
	reg branch_in_id;
	reg jump_in_id;
	reg [1:0] csr_op;
	reg csr_illegal;
	always @(*) begin
		jump_in_id = 1'b0;
		branch_in_id = 1'b0;
		alu_operator_o = ALU_SLTU;
		alu_op_a_mux_sel_o = OP_A_REGA_OR_FWD;
		alu_op_b_mux_sel_o = OP_B_REGB_OR_FWD;
		imm_a_mux_sel_o = IMMA_ZERO;
		imm_b_mux_sel_o = IMMB_I;
		mult_int_en = 1'b0;
		div_int_en = 1'b0;
		multdiv_operator_o = MD_OP_MULL;
		multdiv_signed_mode_o = 2'b00;
		regfile_we = 1'b0;
		csr_access_o = 1'b0;
		csr_status_o = 1'b0;
		csr_illegal = 1'b0;
		csr_op = CSR_OP_NONE;
		data_we_o = 1'b0;
		data_type_o = 2'b00;
		data_sign_extension_o = 1'b0;
		data_reg_offset_o = 2'b00;
		data_req = 1'b0;
		data_load_event_o = 1'b0;
		illegal_insn_o = 1'b0;
		ebrk_insn_o = 1'b0;
		mret_insn_o = 1'b0;
		ecall_insn_o = 1'b0;
		pipe_flush_o = 1'b0;
		case (instr_rdata_i[6:0])
			OPCODE_JAL: begin
				jump_in_id = 1'b1;
				if (jump_mux_i) begin
					alu_op_a_mux_sel_o = OP_A_CURRPC;
					alu_op_b_mux_sel_o = OP_B_IMM;
					imm_b_mux_sel_o = IMMB_UJ;
					alu_operator_o = ALU_ADD;
					regfile_we = 1'b0;
				end
				else begin
					alu_op_a_mux_sel_o = OP_A_CURRPC;
					alu_op_b_mux_sel_o = OP_B_IMM;
					imm_b_mux_sel_o = IMMB_PCINCR;
					alu_operator_o = ALU_ADD;
					regfile_we = 1'b1;
				end
			end
			OPCODE_JALR: begin
				jump_in_id = 1'b1;
				if (jump_mux_i) begin
					alu_op_a_mux_sel_o = OP_A_REGA_OR_FWD;
					alu_op_b_mux_sel_o = OP_B_IMM;
					imm_b_mux_sel_o = IMMB_I;
					alu_operator_o = ALU_ADD;
					regfile_we = 1'b0;
				end
				else begin
					alu_op_a_mux_sel_o = OP_A_CURRPC;
					alu_op_b_mux_sel_o = OP_B_IMM;
					imm_b_mux_sel_o = IMMB_PCINCR;
					alu_operator_o = ALU_ADD;
					regfile_we = 1'b1;
				end
				if (instr_rdata_i[14:12] != 3'b000) begin
					jump_in_id = 1'b0;
					regfile_we = 1'b0;
					illegal_insn_o = 1'b1;
				end
			end
			OPCODE_BRANCH: begin
				branch_in_id = 1'b1;
				if (branch_mux_i)
					case (instr_rdata_i[14:12])
						3'b000: alu_operator_o = ALU_EQ;
						3'b001: alu_operator_o = ALU_NE;
						3'b100: alu_operator_o = ALU_LTS;
						3'b101: alu_operator_o = ALU_GES;
						3'b110: alu_operator_o = ALU_LTU;
						3'b111: alu_operator_o = ALU_GEU;
						default: illegal_insn_o = 1'b1;
					endcase
				else begin
					alu_op_a_mux_sel_o = OP_A_CURRPC;
					alu_op_b_mux_sel_o = OP_B_IMM;
					imm_b_mux_sel_o = IMMB_SB;
					alu_operator_o = ALU_ADD;
					regfile_we = 1'b0;
				end
			end
			OPCODE_STORE: begin
				data_req = 1'b1;
				data_we_o = 1'b1;
				alu_operator_o = ALU_ADD;
				if (instr_rdata_i[14] == 1'b0) begin
					imm_b_mux_sel_o = IMMB_S;
					alu_op_b_mux_sel_o = OP_B_IMM;
				end
				else begin
					data_req = 1'b0;
					data_we_o = 1'b0;
					illegal_insn_o = 1'b1;
				end
				case (instr_rdata_i[13:12])
					2'b00: data_type_o = 2'b10;
					2'b01: data_type_o = 2'b01;
					2'b10: data_type_o = 2'b00;
					default: begin
						data_req = 1'b0;
						data_we_o = 1'b0;
						illegal_insn_o = 1'b1;
					end
				endcase
			end
			OPCODE_LOAD: begin
				data_req = 1'b1;
				regfile_we = 1'b1;
				data_type_o = 2'b00;
				alu_operator_o = ALU_ADD;
				alu_op_b_mux_sel_o = OP_B_IMM;
				imm_b_mux_sel_o = IMMB_I;
				data_sign_extension_o = ~instr_rdata_i[14];
				case (instr_rdata_i[13:12])
					2'b00: data_type_o = 2'b10;
					2'b01: data_type_o = 2'b01;
					2'b10: data_type_o = 2'b00;
					default: data_type_o = 2'b00;
				endcase
				if (instr_rdata_i[14:12] == 3'b111) begin
					alu_op_b_mux_sel_o = OP_B_REGB_OR_FWD;
					data_sign_extension_o = ~instr_rdata_i[30];
					case (instr_rdata_i[31:25])
						7'b0000000, 7'b0100000: data_type_o = 2'b10;
						7'b0001000, 7'b0101000: data_type_o = 2'b01;
						7'b0010000: data_type_o = 2'b00;
						default: illegal_insn_o = 1'b1;
					endcase
				end
				if (instr_rdata_i[14:12] == 3'b110)
					data_load_event_o = 1'b1;
				if (instr_rdata_i[14:12] == 3'b011)
					illegal_insn_o = 1'b1;
			end
			OPCODE_LUI: begin
				alu_op_a_mux_sel_o = OP_A_IMM;
				alu_op_b_mux_sel_o = OP_B_IMM;
				imm_a_mux_sel_o = IMMA_ZERO;
				imm_b_mux_sel_o = IMMB_U;
				alu_operator_o = ALU_ADD;
				regfile_we = 1'b1;
			end
			OPCODE_AUIPC: begin
				alu_op_a_mux_sel_o = OP_A_CURRPC;
				alu_op_b_mux_sel_o = OP_B_IMM;
				imm_b_mux_sel_o = IMMB_U;
				alu_operator_o = ALU_ADD;
				regfile_we = 1'b1;
			end
			OPCODE_OPIMM: begin
				alu_op_b_mux_sel_o = OP_B_IMM;
				imm_b_mux_sel_o = IMMB_I;
				regfile_we = 1'b1;
				case (instr_rdata_i[14:12])
					3'b000: alu_operator_o = ALU_ADD;
					3'b010: alu_operator_o = ALU_SLTS;
					3'b011: alu_operator_o = ALU_SLTU;
					3'b100: alu_operator_o = ALU_XOR;
					3'b110: alu_operator_o = ALU_OR;
					3'b111: alu_operator_o = ALU_AND;
					3'b001: begin
						alu_operator_o = ALU_SLL;
						if (instr_rdata_i[31:25] != 7'b0000000)
							illegal_insn_o = 1'b1;
					end
					3'b101:
						if (instr_rdata_i[31:25] == 7'b0000000)
							alu_operator_o = ALU_SRL;
						else if (instr_rdata_i[31:25] == 7'b0100000)
							alu_operator_o = ALU_SRA;
						else
							illegal_insn_o = 1'b1;
					default: illegal_insn_o = 1'b1;
				endcase
			end
			OPCODE_OP: begin
				regfile_we = 1'b1;
				if (instr_rdata_i[31])
					illegal_insn_o = 1'b1;
				else if (~instr_rdata_i[28])
					case ({instr_rdata_i[30:25], instr_rdata_i[14:12]})
						9'b000000000: alu_operator_o = ALU_ADD;
						9'b100000000: alu_operator_o = ALU_SUB;
						9'b000000010: alu_operator_o = ALU_SLTS;
						9'b000000011: alu_operator_o = ALU_SLTU;
						9'b000000100: alu_operator_o = ALU_XOR;
						9'b000000110: alu_operator_o = ALU_OR;
						9'b000000111: alu_operator_o = ALU_AND;
						9'b000000001: alu_operator_o = ALU_SLL;
						9'b000000101: alu_operator_o = ALU_SRL;
						9'b100000101: alu_operator_o = ALU_SRA;
						9'b000001000: begin
							alu_operator_o = ALU_ADD;
							multdiv_operator_o = MD_OP_MULL;
							mult_int_en = 1'b1;
							multdiv_signed_mode_o = 2'b00;
							illegal_insn_o = (RV32M ? 1'b0 : 1'b1);
						end
						9'b000001001: begin
							alu_operator_o = ALU_ADD;
							multdiv_operator_o = MD_OP_MULH;
							mult_int_en = 1'b1;
							multdiv_signed_mode_o = 2'b11;
							illegal_insn_o = (RV32M ? 1'b0 : 1'b1);
						end
						9'b000001010: begin
							alu_operator_o = ALU_ADD;
							multdiv_operator_o = MD_OP_MULH;
							mult_int_en = 1'b1;
							multdiv_signed_mode_o = 2'b01;
							illegal_insn_o = (RV32M ? 1'b0 : 1'b1);
						end
						9'b000001011: begin
							alu_operator_o = ALU_ADD;
							multdiv_operator_o = MD_OP_MULH;
							mult_int_en = 1'b1;
							multdiv_signed_mode_o = 2'b00;
							illegal_insn_o = (RV32M ? 1'b0 : 1'b1);
						end
						9'b000001100: begin
							alu_operator_o = ALU_ADD;
							multdiv_operator_o = MD_OP_DIV;
							div_int_en = 1'b1;
							multdiv_signed_mode_o = 2'b11;
							illegal_insn_o = (RV32M ? 1'b0 : 1'b1);
						end
						9'b000001101: begin
							alu_operator_o = ALU_ADD;
							multdiv_operator_o = MD_OP_DIV;
							div_int_en = 1'b1;
							multdiv_signed_mode_o = 2'b00;
							illegal_insn_o = (RV32M ? 1'b0 : 1'b1);
						end
						9'b000001110: begin
							alu_operator_o = ALU_ADD;
							multdiv_operator_o = MD_OP_REM;
							div_int_en = 1'b1;
							multdiv_signed_mode_o = 2'b11;
							illegal_insn_o = (RV32M ? 1'b0 : 1'b1);
						end
						9'b000001111: begin
							alu_operator_o = ALU_ADD;
							multdiv_operator_o = MD_OP_REM;
							div_int_en = 1'b1;
							multdiv_signed_mode_o = 2'b00;
							illegal_insn_o = (RV32M ? 1'b0 : 1'b1);
						end
						default: illegal_insn_o = 1'b1;
					endcase
			end
			OPCODE_SYSTEM:
				if (instr_rdata_i[14:12] == 3'b000)
					case (instr_rdata_i[31:20])
						12'h000: ecall_insn_o = 1'b1;
						12'h001: ebrk_insn_o = 1'b1;
						12'h302: mret_insn_o = 1'b1;
						12'h105: pipe_flush_o = 1'b1;
						default: illegal_insn_o = 1'b1;
					endcase
				else begin
					csr_access_o = 1'b1;
					regfile_we = 1'b1;
					alu_op_b_mux_sel_o = OP_B_IMM;
					imm_a_mux_sel_o = IMMA_Z;
					imm_b_mux_sel_o = IMMB_I;
					if (instr_rdata_i[14] == 1'b1)
						alu_op_a_mux_sel_o = OP_A_IMM;
					else
						alu_op_a_mux_sel_o = OP_A_REGA_OR_FWD;
					case (instr_rdata_i[13:12])
						2'b01: csr_op = CSR_OP_WRITE;
						2'b10: csr_op = CSR_OP_SET;
						2'b11: csr_op = CSR_OP_CLEAR;
						default: csr_illegal = 1'b1;
					endcase
					if (~csr_illegal)
						if (instr_rdata_i[31:20] == 12'h300)
							csr_status_o = 1'b1;
					illegal_insn_o = csr_illegal;
				end
			default: illegal_insn_o = 1'b1;
		endcase
		if (illegal_c_insn_i)
			illegal_insn_o = 1'b1;
		if (data_misaligned_i == 1'b1) begin
			alu_op_a_mux_sel_o = OP_A_REGA_OR_FWD;
			alu_op_b_mux_sel_o = OP_B_IMM;
			imm_b_mux_sel_o = IMMB_PCINCR;
			regfile_we = 1'b0;
		end
	end
	assign regfile_we_o = (deassert_we_i ? 1'b0 : regfile_we);
	assign mult_int_en_o = (RV32M ? (deassert_we_i ? 1'b0 : mult_int_en) : 1'b0);
	assign div_int_en_o = (RV32M ? (deassert_we_i ? 1'b0 : div_int_en) : 1'b0);
	assign data_req_o = (deassert_we_i ? 1'b0 : data_req);
	assign csr_op_o = (deassert_we_i ? CSR_OP_NONE : csr_op);
	assign jump_in_id_o = (deassert_we_i ? 1'b0 : jump_in_id);
	assign branch_in_id_o = (deassert_we_i ? 1'b0 : branch_in_id);
endmodule
