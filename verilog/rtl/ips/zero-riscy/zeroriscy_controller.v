module zeroriscy_controller 
#(
  parameter REG_ADDR_WIDTH      = 5
)
(
	clk,
	rst_n,
	fetch_enable_i,
	ctrl_busy_o,
	first_fetch_o,
	is_decoding_o,
	deassert_we_o,
	illegal_insn_i,
	ecall_insn_i,
	mret_insn_i,
	pipe_flush_i,
	ebrk_insn_i,
	csr_status_i,
	instr_valid_i,
	instr_req_o,
	pc_set_o,
	pc_mux_o,
	exc_pc_mux_o,
	data_misaligned_i,
	branch_in_id_i,
	branch_taken_ex_i,
	branch_set_i,
	jump_set_i,
	instr_multicyle_i,
	irq_req_ctrl_i,
	irq_id_ctrl_i,
	m_IE_i,
	irq_ack_o,
	irq_id_o,
	exc_cause_o,
	exc_ack_o,
	exc_kill_o,
	csr_save_if_o,
	csr_save_id_o,
	csr_cause_o,
	csr_restore_mret_id_o,
	csr_save_cause_o,
	dbg_req_i,
	dbg_ack_o,
	dbg_stall_i,
	dbg_jump_req_i,
	dbg_settings_i,
	dbg_trap_o,
	operand_a_fw_mux_sel_o,
	halt_if_o,
	halt_id_o,
	id_ready_i,
	perf_jump_o,
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
	//parameter REG_ADDR_WIDTH = 5;
	input wire clk;
	input wire rst_n;
	input wire fetch_enable_i;
	output reg ctrl_busy_o;
	output reg first_fetch_o;
	output reg is_decoding_o;
	output reg deassert_we_o;
	input wire illegal_insn_i;
	input wire ecall_insn_i;
	input wire mret_insn_i;
	input wire pipe_flush_i;
	input wire ebrk_insn_i;
	input wire csr_status_i;
	input wire instr_valid_i;
	output reg instr_req_o;
	output reg pc_set_o;
	output reg [2:0] pc_mux_o;
	output reg [1:0] exc_pc_mux_o;
	input wire data_misaligned_i;
	input wire branch_in_id_i;
	input wire branch_taken_ex_i;
	input wire branch_set_i;
	input wire jump_set_i;
	input wire instr_multicyle_i;
	input wire irq_req_ctrl_i;
	input wire [4:0] irq_id_ctrl_i;
	input wire m_IE_i;
	output reg irq_ack_o;
	output reg [4:0] irq_id_o;
	output reg [5:0] exc_cause_o;
	output reg exc_ack_o;
	output reg exc_kill_o;
	output reg csr_save_if_o;
	output reg csr_save_id_o;
	output reg [5:0] csr_cause_o;
	output reg csr_restore_mret_id_o;
	output reg csr_save_cause_o;
	input wire dbg_req_i;
	output reg dbg_ack_o;
	input wire dbg_stall_i;
	input wire dbg_jump_req_i;
	input wire [DBG_SETS_W - 1:0] dbg_settings_i;
	output reg dbg_trap_o;
	output wire [1:0] operand_a_fw_mux_sel_o;
	output reg halt_if_o;
	output reg halt_id_o;
	input wire id_ready_i;
	output reg perf_jump_o;
	output reg perf_tbranch_o;
	reg [3:0] ctrl_fsm_cs;
	reg [3:0] ctrl_fsm_ns;
	reg irq_enable_int;
	always @(*) begin
		instr_req_o = 1'b1;
		exc_ack_o = 1'b0;
		exc_kill_o = 1'b0;
		csr_save_if_o = 1'b0;
		csr_save_id_o = 1'b0;
		csr_restore_mret_id_o = 1'b0;
		csr_save_cause_o = 1'b0;
		exc_cause_o = 1'sb0;
		exc_pc_mux_o = EXC_PC_IRQ;
		csr_cause_o = 1'sb0;
		pc_mux_o = PC_BOOT;
		pc_set_o = 1'b0;
		ctrl_fsm_ns = ctrl_fsm_cs;
		ctrl_busy_o = 1'b1;
		is_decoding_o = 1'b0;
		first_fetch_o = 1'b0;
		halt_if_o = 1'b0;
		halt_id_o = 1'b0;
		dbg_ack_o = 1'b0;
		irq_ack_o = 1'b0;
		irq_id_o = irq_id_ctrl_i;
		irq_enable_int = m_IE_i;
		dbg_trap_o = 1'b0;
		perf_tbranch_o = 1'b0;
		perf_jump_o = 1'b0;
		case (ctrl_fsm_cs)
			4'd0: begin
				ctrl_busy_o = 1'b0;
				instr_req_o = 1'b0;
				if (fetch_enable_i == 1'b1)
					ctrl_fsm_ns = 4'd1;
				else if (dbg_req_i)
					ctrl_fsm_ns = 4'd8;
			end
			4'd1: begin
				instr_req_o = 1'b1;
				pc_mux_o = PC_BOOT;
				pc_set_o = 1'b1;
				ctrl_fsm_ns = 4'd4;
			end
			4'd2: begin
				ctrl_busy_o = 1'b0;
				instr_req_o = 1'b0;
				halt_if_o = 1'b1;
				halt_id_o = 1'b1;
				ctrl_fsm_ns = 4'd3;
			end
			4'd3: begin
				ctrl_busy_o = 1'b0;
				instr_req_o = 1'b0;
				halt_if_o = 1'b1;
				halt_id_o = 1'b1;
				dbg_trap_o = dbg_settings_i[DBG_SETS_SSTE];
				if (dbg_req_i) begin
					if (fetch_enable_i || irq_req_ctrl_i)
						ctrl_fsm_ns = 4'd8;
					else
						ctrl_fsm_ns = 4'd9;
				end
				else if (fetch_enable_i || irq_req_ctrl_i)
					ctrl_fsm_ns = 4'd4;
			end
			4'd4: begin
				first_fetch_o = 1'b1;
				if ((id_ready_i == 1'b1) && (dbg_stall_i == 1'b0))
					ctrl_fsm_ns = 4'd5;
				if (irq_req_ctrl_i & irq_enable_int) begin
					ctrl_fsm_ns = 4'd7;
					halt_if_o = 1'b1;
					halt_id_o = 1'b1;
				end
			end
			4'd5: begin
				is_decoding_o = 1'b0;
				if (instr_valid_i) begin
					is_decoding_o = 1'b1;
					case (1'b1)
						branch_set_i: begin
							pc_mux_o = PC_JUMP;
							pc_set_o = 1'b1;
							perf_tbranch_o = 1'b1;
							dbg_trap_o = dbg_settings_i[DBG_SETS_SSTE];
							if (dbg_req_i)
								ctrl_fsm_ns = 4'd8;
						end
						jump_set_i: begin
							pc_mux_o = PC_JUMP;
							pc_set_o = 1'b1;
							perf_jump_o = 1'b1;
							dbg_trap_o = dbg_settings_i[DBG_SETS_SSTE];
						end
						((((mret_insn_i | ecall_insn_i) | pipe_flush_i) | ebrk_insn_i) | illegal_insn_i) | csr_status_i: begin
							ctrl_fsm_ns = 4'd6;
							halt_if_o = 1'b1;
							halt_id_o = 1'b1;
						end
						default: begin
							dbg_trap_o = dbg_settings_i[DBG_SETS_SSTE];
							case (1'b1)
								((irq_req_ctrl_i & irq_enable_int) & ~instr_multicyle_i) & ~branch_in_id_i: begin
									ctrl_fsm_ns = 4'd7;
									halt_if_o = 1'b1;
									halt_id_o = 1'b1;
								end
								dbg_req_i & ~branch_taken_ex_i: begin
									halt_if_o = 1'b1;
									if (id_ready_i)
										ctrl_fsm_ns = 4'd8;
								end
								default: exc_kill_o = ((irq_req_ctrl_i & ~instr_multicyle_i) & ~branch_in_id_i ? 1'b1 : 1'b0);
							endcase
						end
					endcase
				end
				else if (irq_req_ctrl_i & irq_enable_int) begin
					ctrl_fsm_ns = 4'd7;
					halt_if_o = 1'b1;
					halt_id_o = 1'b1;
				end
			end
			4'd8: begin
				dbg_ack_o = 1'b1;
				halt_if_o = 1'b1;
				ctrl_fsm_ns = 4'd10;
			end
			4'd9: begin
				dbg_ack_o = 1'b1;
				halt_if_o = 1'b1;
				ctrl_fsm_ns = 4'd12;
			end
			4'd12: begin
				halt_if_o = 1'b1;
				if (dbg_jump_req_i) begin
					pc_mux_o = PC_DBG_NPC;
					pc_set_o = 1'b1;
					ctrl_fsm_ns = 4'd10;
				end
				if (dbg_stall_i == 1'b0)
					ctrl_fsm_ns = 4'd3;
			end
			4'd10: begin
				halt_if_o = 1'b1;
				if (dbg_jump_req_i) begin
					pc_mux_o = PC_DBG_NPC;
					pc_set_o = 1'b1;
					ctrl_fsm_ns = 4'd10;
				end
				if (dbg_stall_i == 1'b0)
					ctrl_fsm_ns = 4'd5;
			end
			4'd7: begin
				pc_mux_o = PC_EXCEPTION;
				pc_set_o = 1'b1;
				exc_pc_mux_o = EXC_PC_IRQ;
				exc_cause_o = {1'b0, irq_id_ctrl_i};
				csr_save_cause_o = 1'b1;
				csr_cause_o = {1'b1, irq_id_ctrl_i};
				csr_save_if_o = 1'b1;
				irq_ack_o = 1'b1;
				exc_ack_o = 1'b1;
				ctrl_fsm_ns = 4'd5;
			end
			4'd6: begin
				halt_if_o = (fetch_enable_i ? dbg_req_i : 1'b1);
				halt_id_o = 1'b1;
				ctrl_fsm_ns = (dbg_req_i ? 4'd8 : 4'd5);
				case (1'b1)
					ecall_insn_i: begin
						pc_mux_o = PC_EXCEPTION;
						pc_set_o = 1'b1;
						csr_save_id_o = 1'b1;
						csr_save_cause_o = 1'b1;
						exc_pc_mux_o = EXC_PC_ECALL;
						exc_cause_o = EXC_CAUSE_ECALL_MMODE;
						csr_cause_o = EXC_CAUSE_ECALL_MMODE;
						dbg_trap_o = dbg_settings_i[DBG_SETS_ECALL] | dbg_settings_i[DBG_SETS_SSTE];
					end
					illegal_insn_i: begin
						pc_mux_o = PC_EXCEPTION;
						pc_set_o = 1'b1;
						csr_save_id_o = 1'b1;
						csr_save_cause_o = 1'b1;
						exc_pc_mux_o = EXC_PC_ILLINSN;
						exc_cause_o = EXC_CAUSE_ILLEGAL_INSN;
						csr_cause_o = EXC_CAUSE_ILLEGAL_INSN;
						dbg_trap_o = dbg_settings_i[DBG_SETS_EILL] | dbg_settings_i[DBG_SETS_SSTE];
					end
					mret_insn_i: begin
						pc_mux_o = PC_ERET;
						pc_set_o = 1'b1;
						csr_restore_mret_id_o = 1'b1;
						dbg_trap_o = dbg_settings_i[DBG_SETS_SSTE];
					end
					ebrk_insn_i: begin
						dbg_trap_o = dbg_settings_i[DBG_SETS_EBRK] | dbg_settings_i[DBG_SETS_SSTE];
						exc_cause_o = EXC_CAUSE_BREAKPOINT;
					end
					csr_status_i: dbg_trap_o = dbg_settings_i[DBG_SETS_SSTE];
					pipe_flush_i: dbg_trap_o = dbg_settings_i[DBG_SETS_SSTE];
					default:
						;
				endcase
				if (fetch_enable_i) begin
					if (dbg_req_i)
						ctrl_fsm_ns = 4'd8;
					else
						ctrl_fsm_ns = 4'd5;
				end
				else if (dbg_req_i)
					ctrl_fsm_ns = 4'd9;
				else
					ctrl_fsm_ns = (mret_insn_i | pipe_flush_i ? 4'd2 : 4'd5);
			end
			default: begin
				instr_req_o = 1'b0;
				ctrl_fsm_ns = 4'd0;
			end
		endcase
	end
	always @(*) begin
		deassert_we_o = 1'b0;
		if (~is_decoding_o)
			deassert_we_o = 1'b1;
		if (illegal_insn_i)
			deassert_we_o = 1'b1;
	end
	assign operand_a_fw_mux_sel_o = (data_misaligned_i ? SEL_MISALIGNED : SEL_REGFILE);
	always @(posedge clk or negedge rst_n) begin : UPDATE_REGS
		if (rst_n == 1'b0)
			ctrl_fsm_cs <= 4'd0;
		else
			ctrl_fsm_cs <= ctrl_fsm_ns;
	end
endmodule
