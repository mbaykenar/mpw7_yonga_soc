module zeroriscy_id_stage (
	clk,
	rst_n,
	test_en_i,
	fetch_enable_i,
	ctrl_busy_o,
	core_ctrl_firstfetch_o,
	is_decoding_o,
	instr_valid_i,
	instr_rdata_i,
	instr_req_o,
	branch_in_ex_o,
	branch_decision_i,
	clear_instr_valid_o,
	pc_set_o,
	pc_mux_o,
	exc_pc_mux_o,
	illegal_c_insn_i,
	is_compressed_i,
	pc_id_i,
	halt_if_o,
	id_ready_o,
	ex_ready_i,
	id_valid_o,
	alu_operator_ex_o,
	alu_operand_a_ex_o,
	alu_operand_b_ex_o,
	mult_en_ex_o,
	div_en_ex_o,
	multdiv_operator_ex_o,
	multdiv_signed_mode_ex_o,
	multdiv_operand_a_ex_o,
	multdiv_operand_b_ex_o,
	csr_access_ex_o,
	csr_op_ex_o,
	csr_cause_o,
	csr_save_if_o,
	csr_save_id_o,
	csr_restore_mret_id_o,
	csr_save_cause_o,
	data_req_ex_o,
	data_we_ex_o,
	data_type_ex_o,
	data_sign_ext_ex_o,
	data_reg_offset_ex_o,
	data_load_event_ex_o,
	data_wdata_ex_o,
	data_misaligned_i,
	misaligned_addr_i,
	irq_i,
	irq_id_i,
	m_irq_enable_i,
	irq_ack_o,
	irq_id_o,
	exc_cause_o,
	lsu_load_err_i,
	lsu_store_err_i,
	dbg_settings_i,
	dbg_req_i,
	dbg_ack_o,
	dbg_stall_i,
	dbg_trap_o,
	dbg_reg_rreq_i,
	dbg_reg_raddr_i,
	dbg_reg_rdata_o,
	dbg_reg_wreq_i,
	dbg_reg_waddr_i,
	dbg_reg_wdata_i,
	dbg_jump_req_i,
	regfile_wdata_lsu_i,
	regfile_wdata_ex_i,
	csr_rdata_i,
	perf_jump_o,
	perf_branch_o,
	perf_tbranch_o
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
	parameter RV32M = 1;
	parameter RV32E = 0;
	input wire clk;
	input wire rst_n;
	input wire test_en_i;
	input wire fetch_enable_i;
	output wire ctrl_busy_o;
	output wire core_ctrl_firstfetch_o;
	output wire is_decoding_o;
	input wire instr_valid_i;
	input wire [31:0] instr_rdata_i;
	output wire instr_req_o;
	output wire branch_in_ex_o;
	input wire branch_decision_i;
	output wire clear_instr_valid_o;
	output wire pc_set_o;
	output wire [2:0] pc_mux_o;
	output wire [1:0] exc_pc_mux_o;
	input wire illegal_c_insn_i;
	input wire is_compressed_i;
	input wire [31:0] pc_id_i;
	output wire halt_if_o;
	output wire id_ready_o;
	input wire ex_ready_i;
	output wire id_valid_o;
	output wire [ALU_OP_WIDTH - 1:0] alu_operator_ex_o;
	output wire [31:0] alu_operand_a_ex_o;
	output wire [31:0] alu_operand_b_ex_o;
	output wire mult_en_ex_o;
	output wire div_en_ex_o;
	output wire [1:0] multdiv_operator_ex_o;
	output wire [1:0] multdiv_signed_mode_ex_o;
	output wire [31:0] multdiv_operand_a_ex_o;
	output wire [31:0] multdiv_operand_b_ex_o;
	output wire csr_access_ex_o;
	output wire [1:0] csr_op_ex_o;
	output wire [5:0] csr_cause_o;
	output wire csr_save_if_o;
	output wire csr_save_id_o;
	output wire csr_restore_mret_id_o;
	output wire csr_save_cause_o;
	output wire data_req_ex_o;
	output wire data_we_ex_o;
	output wire [1:0] data_type_ex_o;
	output wire data_sign_ext_ex_o;
	output wire [1:0] data_reg_offset_ex_o;
	output wire data_load_event_ex_o;
	output wire [31:0] data_wdata_ex_o;
	input wire data_misaligned_i;
	input wire [31:0] misaligned_addr_i;
	input wire irq_i;
	input wire [4:0] irq_id_i;
	input wire m_irq_enable_i;
	output wire irq_ack_o;
	output wire [4:0] irq_id_o;
	output wire [5:0] exc_cause_o;
	input wire lsu_load_err_i;
	input wire lsu_store_err_i;
	input wire [DBG_SETS_W - 1:0] dbg_settings_i;
	input wire dbg_req_i;
	output wire dbg_ack_o;
	input wire dbg_stall_i;
	output wire dbg_trap_o;
	input wire dbg_reg_rreq_i;
	input wire [4:0] dbg_reg_raddr_i;
	output wire [31:0] dbg_reg_rdata_o;
	input wire dbg_reg_wreq_i;
	input wire [4:0] dbg_reg_waddr_i;
	input wire [31:0] dbg_reg_wdata_i;
	input wire dbg_jump_req_i;
	input wire [31:0] regfile_wdata_lsu_i;
	input wire [31:0] regfile_wdata_ex_i;
	input wire [31:0] csr_rdata_i;
	output wire perf_jump_o;
	output reg perf_branch_o;
	output wire perf_tbranch_o;
	wire [31:0] instr;
	wire deassert_we;
	wire illegal_insn_dec;
	wire illegal_reg_rv32e;
	wire ebrk_insn;
	wire mret_insn_dec;
	wire ecall_insn_dec;
	wire pipe_flush_dec;
	wire branch_taken_ex;
	wire branch_in_id;
	reg branch_set_n;
	reg branch_set_q;
	reg branch_mux_dec;
	reg jump_set;
	reg jump_mux_dec;
	wire jump_in_id;
	reg instr_multicyle;
	reg load_stall;
	reg multdiv_stall;
	reg branch_stall;
	reg jump_stall;
	wire halt_id;
	reg regfile_we;
	reg select_data_rf;
	wire [31:0] imm_i_type;
	wire [31:0] imm_iz_type;
	wire [31:0] imm_s_type;
	wire [31:0] imm_sb_type;
	wire [31:0] imm_u_type;
	wire [31:0] imm_uj_type;
	wire [31:0] imm_z_type;
	wire [31:0] imm_s2_type;
	wire [31:0] imm_bi_type;
	wire [31:0] imm_s3_type;
	wire [31:0] imm_vs_type;
	wire [31:0] imm_vu_type;
	reg [31:0] imm_a;
	reg [31:0] imm_b;
	wire irq_req_ctrl;
	wire [4:0] irq_id_ctrl;
	wire exc_ack;
	wire exc_kill;
	wire [4:0] regfile_addr_ra_id;
	wire [4:0] regfile_addr_rb_id;
	wire [4:0] regfile_alu_waddr_id;
	wire regfile_we_id;
	wire [31:0] regfile_data_ra_id;
	wire [31:0] regfile_data_rb_id;
	wire [ALU_OP_WIDTH - 1:0] alu_operator;
	wire [2:0] alu_op_a_mux_sel;
	wire [2:0] alu_op_b_mux_sel;
	wire [0:0] imm_a_mux_sel;
	wire [3:0] imm_b_mux_sel;
	wire mult_int_en;
	wire div_int_en;
	wire multdiv_int_en;
	wire [1:0] multdiv_operator;
	wire [1:0] multdiv_signed_mode;
	wire data_we_id;
	wire [1:0] data_type_id;
	wire data_sign_ext_id;
	wire [1:0] data_reg_offset_id;
	wire data_req_id;
	wire data_load_event_id;
	wire csr_access;
	wire [1:0] csr_op;
	wire csr_status;
	wire [1:0] operand_a_fw_mux_sel;
	reg [31:0] operand_a_fw_id;
	wire [31:0] operand_b_fw_id;
	reg [31:0] operand_b;
	reg [31:0] alu_operand_a;
	wire [31:0] alu_operand_b;
	assign instr = instr_rdata_i;
	assign imm_i_type = {{20 {instr[31]}}, instr[31:20]};
	assign imm_iz_type = {20'b00000000000000000000, instr[31:20]};
	assign imm_s_type = {{20 {instr[31]}}, instr[31:25], instr[11:7]};
	assign imm_sb_type = {{19 {instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
	assign imm_u_type = {instr[31:12], 12'b000000000000};
	assign imm_uj_type = {{12 {instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
	assign imm_z_type = {27'b000000000000000000000000000, instr[19:15]};
	assign imm_s2_type = {27'b000000000000000000000000000, instr[24:20]};
	assign imm_bi_type = {{27 {instr[24]}}, instr[24:20]};
	assign imm_s3_type = {27'b000000000000000000000000000, instr[29:25]};
	assign imm_vs_type = {{26 {instr[24]}}, instr[24:20], instr[25]};
	assign imm_vu_type = {26'b00000000000000000000000000, instr[24:20], instr[25]};
	assign regfile_addr_ra_id = instr[19:15];
	assign regfile_addr_rb_id = instr[24:20];
	assign regfile_alu_waddr_id = instr[11:7];
	assign illegal_reg_rv32e = 1'b0;
	assign clear_instr_valid_o = id_ready_o | halt_id;
	assign branch_taken_ex = branch_in_id & branch_decision_i;
	always @(*) begin : alu_operand_a_mux
		case (alu_op_a_mux_sel)
			OP_A_REGA_OR_FWD: alu_operand_a = operand_a_fw_id;
			OP_A_CURRPC: alu_operand_a = pc_id_i;
			OP_A_IMM: alu_operand_a = imm_a;
			default: alu_operand_a = operand_a_fw_id;
		endcase
	end
	always @(*) begin : immediate_a_mux
		case (imm_a_mux_sel)
			IMMA_Z: imm_a = imm_z_type;
			IMMA_ZERO: imm_a = 1'sb0;
			default: imm_a = 1'sb0;
		endcase
	end
	always @(*) begin : operand_a_fw_mux
		case (operand_a_fw_mux_sel)
			SEL_MISALIGNED: operand_a_fw_id = misaligned_addr_i;
			SEL_REGFILE: operand_a_fw_id = regfile_data_ra_id;
			default: operand_a_fw_id = regfile_data_ra_id;
		endcase
	end
	always @(*) begin : immediate_b_mux
		case (imm_b_mux_sel)
			IMMB_I: imm_b = imm_i_type;
			IMMB_S: imm_b = imm_s_type;
			IMMB_U: imm_b = imm_u_type;
			IMMB_PCINCR: imm_b = (is_compressed_i && ~data_misaligned_i ? 32'h00000002 : 32'h00000004);
			IMMB_S2: imm_b = imm_s2_type;
			IMMB_BI: imm_b = imm_bi_type;
			IMMB_S3: imm_b = imm_s3_type;
			IMMB_VS: imm_b = imm_vs_type;
			IMMB_VU: imm_b = imm_vu_type;
			IMMB_UJ: imm_b = imm_uj_type;
			IMMB_SB: imm_b = imm_sb_type;
			default: imm_b = imm_i_type;
		endcase
	end
	always @(*) begin : alu_operand_b_mux
		case (alu_op_b_mux_sel)
			OP_B_REGB_OR_FWD: operand_b = regfile_data_rb_id;
			OP_B_IMM: operand_b = imm_b;
			default: operand_b = regfile_data_rb_id;
		endcase
	end
	assign alu_operand_b = operand_b;
	assign operand_b_fw_id = regfile_data_rb_id;
	reg [31:0] regfile_wdata_mux;
	reg regfile_we_mux;
	reg [4:0] regfile_waddr_mux;
	always @(*)
		if (dbg_reg_wreq_i) begin
			regfile_wdata_mux = dbg_reg_wdata_i;
			regfile_waddr_mux = dbg_reg_waddr_i;
			regfile_we_mux = 1'b1;
		end
		else begin
			regfile_we_mux = regfile_we;
			regfile_waddr_mux = regfile_alu_waddr_id;
			if (select_data_rf == 1'd0)
				regfile_wdata_mux = regfile_wdata_lsu_i;
			else if (csr_access)
				regfile_wdata_mux = csr_rdata_i;
			else
				regfile_wdata_mux = regfile_wdata_ex_i;
		end
	zeroriscy_register_file #(.RV32E(RV32E)) registers_i(
		.clk(clk),
		.rst_n(rst_n),
		.test_en_i(test_en_i),
		.raddr_a_i(regfile_addr_ra_id),
		.rdata_a_o(regfile_data_ra_id),
		.raddr_b_i((dbg_reg_rreq_i == 1'b0 ? regfile_addr_rb_id : dbg_reg_raddr_i)),
		.rdata_b_o(regfile_data_rb_id),
		.waddr_a_i(regfile_waddr_mux),
		.wdata_a_i(regfile_wdata_mux),
		.we_a_i(regfile_we_mux)
	);
	assign dbg_reg_rdata_o = regfile_data_rb_id;
	assign multdiv_int_en = mult_int_en | div_int_en;
	zeroriscy_decoder #(.RV32M(RV32M)) decoder_i(
		.deassert_we_i(deassert_we),
		.data_misaligned_i(data_misaligned_i),
		.branch_mux_i(branch_mux_dec),
		.jump_mux_i(jump_mux_dec),
		.illegal_insn_o(illegal_insn_dec),
		.ebrk_insn_o(ebrk_insn),
		.mret_insn_o(mret_insn_dec),
		.ecall_insn_o(ecall_insn_dec),
		.pipe_flush_o(pipe_flush_dec),
		.instr_rdata_i(instr),
		.illegal_c_insn_i(illegal_c_insn_i),
		.alu_operator_o(alu_operator),
		.alu_op_a_mux_sel_o(alu_op_a_mux_sel),
		.alu_op_b_mux_sel_o(alu_op_b_mux_sel),
		.imm_a_mux_sel_o(imm_a_mux_sel),
		.imm_b_mux_sel_o(imm_b_mux_sel),
		.mult_int_en_o(mult_int_en),
		.div_int_en_o(div_int_en),
		.multdiv_operator_o(multdiv_operator),
		.multdiv_signed_mode_o(multdiv_signed_mode),
		.regfile_we_o(regfile_we_id),
		.csr_access_o(csr_access),
		.csr_op_o(csr_op),
		.csr_status_o(csr_status),
		.data_req_o(data_req_id),
		.data_we_o(data_we_id),
		.data_type_o(data_type_id),
		.data_sign_extension_o(data_sign_ext_id),
		.data_reg_offset_o(data_reg_offset_id),
		.data_load_event_o(data_load_event_id),
		.jump_in_id_o(jump_in_id),
		.branch_in_id_o(branch_in_id)
	);
	zeroriscy_controller controller_i(
		.clk(clk),
		.rst_n(rst_n),
		.fetch_enable_i(fetch_enable_i),
		.ctrl_busy_o(ctrl_busy_o),
		.first_fetch_o(core_ctrl_firstfetch_o),
		.is_decoding_o(is_decoding_o),
		.deassert_we_o(deassert_we),
		.illegal_insn_i(illegal_insn_dec | illegal_reg_rv32e),
		.ecall_insn_i(ecall_insn_dec),
		.mret_insn_i(mret_insn_dec),
		.pipe_flush_i(pipe_flush_dec),
		.ebrk_insn_i(ebrk_insn),
		.csr_status_i(csr_status),
		.instr_valid_i(instr_valid_i),
		.instr_req_o(instr_req_o),
		.pc_set_o(pc_set_o),
		.pc_mux_o(pc_mux_o),
		.exc_pc_mux_o(exc_pc_mux_o),
		.exc_cause_o(exc_cause_o),
		.data_misaligned_i(data_misaligned_i),
		.branch_in_id_i(branch_in_id),
		.branch_taken_ex_i(branch_taken_ex),
		.branch_set_i(branch_set_q),
		.jump_set_i(jump_set),
		.instr_multicyle_i(instr_multicyle),
		.irq_req_ctrl_i(irq_req_ctrl),
		.irq_id_ctrl_i(irq_id_ctrl),
		.m_IE_i(m_irq_enable_i),
		.irq_ack_o(irq_ack_o),
		.irq_id_o(irq_id_o),
		.exc_ack_o(exc_ack),
		.exc_kill_o(exc_kill),
		.csr_save_cause_o(csr_save_cause_o),
		.csr_cause_o(csr_cause_o),
		.csr_save_if_o(csr_save_if_o),
		.csr_save_id_o(csr_save_id_o),
		.csr_restore_mret_id_o(csr_restore_mret_id_o),
		.dbg_req_i(dbg_req_i),
		.dbg_ack_o(dbg_ack_o),
		.dbg_stall_i(dbg_stall_i),
		.dbg_jump_req_i(dbg_jump_req_i),
		.dbg_settings_i(dbg_settings_i),
		.dbg_trap_o(dbg_trap_o),
		.operand_a_fw_mux_sel_o(operand_a_fw_mux_sel),
		.halt_if_o(halt_if_o),
		.halt_id_o(halt_id),
		.id_ready_i(id_ready_o),
		.perf_jump_o(perf_jump_o),
		.perf_tbranch_o(perf_tbranch_o)
	);
	zeroriscy_int_controller int_controller_i(
		.clk(clk),
		.rst_n(rst_n),
		.irq_req_ctrl_o(irq_req_ctrl),
		.irq_id_ctrl_o(irq_id_ctrl),
		.ctrl_ack_i(exc_ack),
		.ctrl_kill_i(exc_kill),
		.irq_i(irq_i),
		.irq_id_i(irq_id_i),
		.m_IE_i(m_irq_enable_i)
	);
	assign data_we_ex_o = data_we_id;
	assign data_type_ex_o = data_type_id;
	assign data_sign_ext_ex_o = data_sign_ext_id;
	assign data_wdata_ex_o = regfile_data_rb_id;
	assign data_req_ex_o = data_req_id;
	assign data_reg_offset_ex_o = data_reg_offset_id;
	assign data_load_event_ex_o = data_load_event_id;
	assign alu_operator_ex_o = alu_operator;
	assign alu_operand_a_ex_o = alu_operand_a;
	assign alu_operand_b_ex_o = alu_operand_b;
	assign csr_access_ex_o = csr_access;
	assign csr_op_ex_o = csr_op;
	assign branch_in_ex_o = branch_in_id;
	assign mult_en_ex_o = mult_int_en;
	assign div_en_ex_o = div_int_en;
	assign multdiv_operator_ex_o = multdiv_operator;
	assign multdiv_signed_mode_ex_o = multdiv_signed_mode;
	assign multdiv_operand_a_ex_o = regfile_data_ra_id;
	assign multdiv_operand_b_ex_o = regfile_data_rb_id;
	reg id_wb_fsm_cs;
	reg id_wb_fsm_ns;
	always @(posedge clk or negedge rst_n) begin : EX_WB_Pipeline_Register
		if (~rst_n) begin
			id_wb_fsm_cs <= 1'd0;
			branch_set_q <= 1'b0;
		end
		else begin
			id_wb_fsm_cs <= id_wb_fsm_ns;
			branch_set_q <= branch_set_n;
		end
	end
	always @(*) begin
		id_wb_fsm_ns = id_wb_fsm_cs;
		regfile_we = regfile_we_id;
		load_stall = 1'b0;
		multdiv_stall = 1'b0;
		jump_stall = 1'b0;
		branch_stall = 1'b0;
		select_data_rf = 1'd1;
		instr_multicyle = 1'b0;
		branch_set_n = 1'b0;
		branch_mux_dec = 1'b0;
		jump_set = 1'b0;
		jump_mux_dec = 1'b0;
		perf_branch_o = 1'b0;
		case (id_wb_fsm_cs)
			1'd0: begin
				jump_mux_dec = 1'b1;
				branch_mux_dec = 1'b1;
				case (1'b1)
					data_req_id: begin
						regfile_we = 1'b0;
						id_wb_fsm_ns = 1'd1;
						load_stall = 1'b1;
						instr_multicyle = 1'b1;
					end
					branch_in_id: begin
						id_wb_fsm_ns = (branch_decision_i ? 1'd1 : 1'd0);
						branch_stall = branch_decision_i;
						instr_multicyle = branch_decision_i;
						branch_set_n = branch_decision_i;
						perf_branch_o = 1'b1;
					end
					multdiv_int_en: begin
						regfile_we = 1'b0;
						id_wb_fsm_ns = 1'd1;
						multdiv_stall = 1'b1;
						instr_multicyle = 1'b1;
					end
					jump_in_id: begin
						regfile_we = 1'b0;
						id_wb_fsm_ns = 1'd1;
						jump_stall = 1'b1;
						instr_multicyle = 1'b1;
						jump_set = 1'b1;
					end
					default:
						;
				endcase
			end
			1'd1:
				if (ex_ready_i) begin
					regfile_we = regfile_we_id;
					id_wb_fsm_ns = 1'd0;
					load_stall = 1'b0;
					multdiv_stall = 1'b0;
					select_data_rf = (data_req_id ? 1'd0 : 1'd1);
				end
				else begin
					regfile_we = 1'b0;
					instr_multicyle = 1'b1;
					case (1'b1)
						data_req_id: load_stall = 1'b1;
						multdiv_int_en: multdiv_stall = 1'b1;
						default:
							;
					endcase
				end
			default:
				;
		endcase
	end
	assign id_ready_o = ((~load_stall & ~branch_stall) & ~jump_stall) & ~multdiv_stall;
	assign id_valid_o = ~halt_id & id_ready_o;
endmodule
