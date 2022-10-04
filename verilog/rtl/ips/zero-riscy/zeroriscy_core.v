module zeroriscy_core 
#(
  parameter N_EXT_PERF_COUNTERS = 0,
  parameter RV32E               = 0,
  parameter RV32M               = 1
)
(
	clk_i,
	rst_ni,
	clock_en_i,
	test_en_i,
	core_id_i,
	cluster_id_i,
	boot_addr_i,
	instr_req_o,
	instr_gnt_i,
	instr_rvalid_i,
	instr_addr_o,
	instr_rdata_i,
	data_req_o,
	data_gnt_i,
	data_rvalid_i,
	data_we_o,
	data_be_o,
	data_addr_o,
	data_wdata_o,
	data_rdata_i,
	data_err_i,
	irq_i,
	irq_id_i,
	irq_ack_o,
	irq_id_o,
	debug_req_i,
	debug_gnt_o,
	debug_rvalid_o,
	debug_addr_i,
	debug_we_i,
	debug_wdata_i,
	debug_rdata_o,
	debug_halted_o,
	debug_halt_i,
	debug_resume_i,
	fetch_enable_i,
	core_busy_o,
	ext_perf_counters_i
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
	//parameter N_EXT_PERF_COUNTERS = 0;
	//parameter RV32E = 0;
	//parameter RV32M = 1;
	input wire clk_i;
	input wire rst_ni;
	input wire clock_en_i;
	input wire test_en_i;
	input wire [3:0] core_id_i;
	input wire [5:0] cluster_id_i;
	input wire [31:0] boot_addr_i;
	output wire instr_req_o;
	input wire instr_gnt_i;
	input wire instr_rvalid_i;
	output wire [31:0] instr_addr_o;
	input wire [31:0] instr_rdata_i;
	output wire data_req_o;
	input wire data_gnt_i;
	input wire data_rvalid_i;
	output wire data_we_o;
	output wire [3:0] data_be_o;
	output wire [31:0] data_addr_o;
	output wire [31:0] data_wdata_o;
	input wire [31:0] data_rdata_i;
	input wire data_err_i;
	input wire irq_i;
	input wire [4:0] irq_id_i;
	output wire irq_ack_o;
	output wire [4:0] irq_id_o;
	input wire debug_req_i;
	output wire debug_gnt_o;
	output wire debug_rvalid_o;
	input wire [14:0] debug_addr_i;
	input wire debug_we_i;
	input wire [31:0] debug_wdata_i;
	output wire [31:0] debug_rdata_o;
	output wire debug_halted_o;
	input wire debug_halt_i;
	input wire debug_resume_i;
	input wire fetch_enable_i;
	output wire core_busy_o;
	input wire [N_EXT_PERF_COUNTERS - 1:0] ext_perf_counters_i;
	localparam N_HWLP = 2;
	localparam N_HWLP_BITS = 1;
	wire instr_valid_id;
	wire [31:0] instr_rdata_id;
	wire is_compressed_id;
	wire illegal_c_insn_id;
	wire [31:0] pc_if;
	wire [31:0] pc_id;
	wire clear_instr_valid;
	wire pc_set;
	wire [2:0] pc_mux_id;
	wire [1:0] exc_pc_mux_id;
	wire [5:0] exc_cause;
	wire lsu_load_err;
	wire lsu_store_err;
	wire is_decoding;
	wire data_misaligned;
	wire [31:0] misaligned_addr;
	wire [31:0] jump_target_ex;
	wire branch_in_ex;
	wire branch_decision;
	wire ctrl_busy;
	wire if_busy;
	wire lsu_busy;
	wire [ALU_OP_WIDTH - 1:0] alu_operator_ex;
	wire [31:0] alu_operand_a_ex;
	wire [31:0] alu_operand_b_ex;
	wire [31:0] alu_adder_result_ex;
	wire [31:0] regfile_wdata_ex;
	wire mult_en_ex;
	wire div_en_ex;
	wire [1:0] multdiv_operator_ex;
	wire [1:0] multdiv_signed_mode_ex;
	wire [31:0] multdiv_operand_a_ex;
	wire [31:0] multdiv_operand_b_ex;
	wire csr_access_ex;
	wire [1:0] csr_op_ex;
	wire csr_access;
	wire [1:0] csr_op;
	wire [11:0] csr_addr;
	wire [11:0] csr_addr_int;
	wire [31:0] csr_rdata;
	wire [31:0] csr_wdata;
	wire data_we_ex;
	wire [1:0] data_type_ex;
	wire data_sign_ext_ex;
	wire [1:0] data_reg_offset_ex;
	wire data_req_ex;
	wire [31:0] data_wdata_ex;
	wire data_load_event_ex;
	wire data_misaligned_ex;
	wire [31:0] regfile_wdata_lsu;
	wire halt_if;
	wire id_ready;
	wire ex_ready;
	wire if_valid;
	wire id_valid;
	wire wb_valid;
	wire lsu_ready_ex;
	wire data_valid_lsu;
	wire instr_req_int;
	wire m_irq_enable;
	wire [31:0] mepc;
	wire csr_save_cause;
	wire csr_save_if;
	wire csr_save_id;
	wire [5:0] csr_cause;
	wire csr_restore_mret_id;
	wire csr_restore_uret_id;
	wire [DBG_SETS_W - 1:0] dbg_settings;
	wire dbg_req;
	wire dbg_ack;
	wire dbg_stall;
	wire dbg_trap;
	wire dbg_reg_rreq;
	wire [4:0] dbg_reg_raddr;
	wire [31:0] dbg_reg_rdata;
	wire dbg_reg_wreq;
	wire [4:0] dbg_reg_waddr;
	wire [31:0] dbg_reg_wdata;
	wire dbg_csr_req;
	wire [11:0] dbg_csr_addr;
	wire dbg_csr_we;
	wire [31:0] dbg_csr_wdata;
	wire [31:0] dbg_jump_addr;
	wire dbg_jump_req;
	wire perf_imiss;
	wire perf_jump;
	wire perf_branch;
	wire perf_tbranch;
	wire core_ctrl_firstfetch;
	wire core_busy_int;
	reg core_busy_q;
	wire clk;
	wire clock_en;
	wire dbg_busy;
	wire sleeping;
	assign core_busy_int = (data_load_event_ex & data_req_o ? if_busy : (if_busy | ctrl_busy) | lsu_busy);
	always @(posedge clk or negedge rst_ni)
		if (rst_ni == 1'b0)
			core_busy_q <= 1'b0;
		else
			core_busy_q <= core_busy_int;
	assign core_busy_o = (core_ctrl_firstfetch ? 1'b1 : core_busy_q);
	assign dbg_busy = (((dbg_req | dbg_csr_req) | dbg_jump_req) | dbg_reg_wreq) | debug_req_i;
	assign clock_en = (clock_en_i | core_busy_o) | dbg_busy;
	assign sleeping = ~fetch_enable_i & ~core_busy_o;
	cluster_clock_gating core_clock_gate_i(
		.clk_i(clk_i),
		.en_i(clock_en),
		.test_en_i(test_en_i),
		.clk_o(clk)
	);
	zeroriscy_if_stage if_stage_i(
		.clk(clk),
		.rst_n(rst_ni),
		.boot_addr_i(boot_addr_i),
		.req_i(instr_req_int),
		.instr_req_o(instr_req_o),
		.instr_addr_o(instr_addr_o),
		.instr_gnt_i(instr_gnt_i),
		.instr_rvalid_i(instr_rvalid_i),
		.instr_rdata_i(instr_rdata_i),
		.instr_valid_id_o(instr_valid_id),
		.instr_rdata_id_o(instr_rdata_id),
		.is_compressed_id_o(is_compressed_id),
		.illegal_c_insn_id_o(illegal_c_insn_id),
		.pc_if_o(pc_if),
		.pc_id_o(pc_id),
		.clear_instr_valid_i(clear_instr_valid),
		.pc_set_i(pc_set),
		.exception_pc_reg_i(mepc),
		.pc_mux_i(pc_mux_id),
		.exc_pc_mux_i(exc_pc_mux_id),
		.exc_vec_pc_mux_i(exc_cause[4:0]),
		.dbg_jump_addr_i(dbg_jump_addr),
		.jump_target_ex_i(jump_target_ex),
		.halt_if_i(halt_if),
		.id_ready_i(id_ready),
		.if_valid_o(if_valid),
		.if_busy_o(if_busy),
		.perf_imiss_o(perf_imiss)
	);
	zeroriscy_id_stage #(
		.RV32E(RV32E),
		.RV32M(RV32M)
	) id_stage_i(
		.clk(clk),
		.rst_n(rst_ni),
		.test_en_i(test_en_i),
		.fetch_enable_i(fetch_enable_i),
		.ctrl_busy_o(ctrl_busy),
		.core_ctrl_firstfetch_o(core_ctrl_firstfetch),
		.is_decoding_o(is_decoding),
		.instr_valid_i(instr_valid_id),
		.instr_rdata_i(instr_rdata_id),
		.instr_req_o(instr_req_int),
		.branch_in_ex_o(branch_in_ex),
		.branch_decision_i(branch_decision),
		.clear_instr_valid_o(clear_instr_valid),
		.pc_set_o(pc_set),
		.pc_mux_o(pc_mux_id),
		.exc_pc_mux_o(exc_pc_mux_id),
		.exc_cause_o(exc_cause),
		.illegal_c_insn_i(illegal_c_insn_id),
		.is_compressed_i(is_compressed_id),
		.pc_id_i(pc_id),
		.halt_if_o(halt_if),
		.id_ready_o(id_ready),
		.ex_ready_i(ex_ready),
		.id_valid_o(id_valid),
		.alu_operator_ex_o(alu_operator_ex),
		.alu_operand_a_ex_o(alu_operand_a_ex),
		.alu_operand_b_ex_o(alu_operand_b_ex),
		.mult_en_ex_o(mult_en_ex),
		.div_en_ex_o(div_en_ex),
		.multdiv_operator_ex_o(multdiv_operator_ex),
		.multdiv_signed_mode_ex_o(multdiv_signed_mode_ex),
		.multdiv_operand_a_ex_o(multdiv_operand_a_ex),
		.multdiv_operand_b_ex_o(multdiv_operand_b_ex),
		.csr_access_ex_o(csr_access_ex),
		.csr_op_ex_o(csr_op_ex),
		.csr_cause_o(csr_cause),
		.csr_save_if_o(csr_save_if),
		.csr_save_id_o(csr_save_id),
		.csr_restore_mret_id_o(csr_restore_mret_id),
		.csr_save_cause_o(csr_save_cause),
		.data_req_ex_o(data_req_ex),
		.data_we_ex_o(data_we_ex),
		.data_type_ex_o(data_type_ex),
		.data_sign_ext_ex_o(data_sign_ext_ex),
		.data_reg_offset_ex_o(data_reg_offset_ex),
		.data_load_event_ex_o(data_load_event_ex),
		.data_wdata_ex_o(data_wdata_ex),
		.data_misaligned_i(data_misaligned),
		.misaligned_addr_i(misaligned_addr),
		.irq_i(irq_i),
		.irq_id_i(irq_id_i),
		.m_irq_enable_i(m_irq_enable),
		.irq_ack_o(irq_ack_o),
		.irq_id_o(irq_id_o),
		.lsu_load_err_i(lsu_load_err),
		.lsu_store_err_i(lsu_store_err),
		.dbg_settings_i(dbg_settings),
		.dbg_req_i(dbg_req),
		.dbg_ack_o(dbg_ack),
		.dbg_stall_i(dbg_stall),
		.dbg_trap_o(dbg_trap),
		.dbg_reg_rreq_i(dbg_reg_rreq),
		.dbg_reg_raddr_i(dbg_reg_raddr),
		.dbg_reg_rdata_o(dbg_reg_rdata),
		.dbg_reg_wreq_i(dbg_reg_wreq),
		.dbg_reg_waddr_i(dbg_reg_waddr),
		.dbg_reg_wdata_i(dbg_reg_wdata),
		.dbg_jump_req_i(dbg_jump_req),
		.regfile_wdata_lsu_i(regfile_wdata_lsu),
		.regfile_wdata_ex_i(regfile_wdata_ex),
		.csr_rdata_i(csr_rdata),
		.perf_jump_o(perf_jump),
		.perf_branch_o(perf_branch),
		.perf_tbranch_o(perf_tbranch)
	);
	zeroriscy_ex_block #(.RV32M(RV32M)) ex_block_i(
		.clk(clk),
		.rst_n(rst_ni),
		.alu_operator_i(alu_operator_ex),
		.multdiv_operator_i(multdiv_operator_ex),
		.alu_operand_a_i(alu_operand_a_ex),
		.alu_operand_b_i(alu_operand_b_ex),
		.mult_en_i(mult_en_ex),
		.div_en_i(div_en_ex),
		.multdiv_signed_mode_i(multdiv_signed_mode_ex),
		.multdiv_operand_a_i(multdiv_operand_a_ex),
		.multdiv_operand_b_i(multdiv_operand_b_ex),
		.alu_adder_result_ex_o(alu_adder_result_ex),
		.regfile_wdata_ex_o(regfile_wdata_ex),
		.jump_target_o(jump_target_ex),
		.branch_decision_o(branch_decision),
		.lsu_en_i(data_req_ex),
		.lsu_ready_ex_i(data_valid_lsu),
		.ex_ready_o(ex_ready)
	);
	zeroriscy_load_store_unit load_store_unit_i(
		.clk(clk),
		.rst_n(rst_ni),
		.data_req_o(data_req_o),
		.data_gnt_i(data_gnt_i),
		.data_rvalid_i(data_rvalid_i),
		.data_err_i(data_err_i),
		.data_addr_o(data_addr_o),
		.data_we_o(data_we_o),
		.data_be_o(data_be_o),
		.data_wdata_o(data_wdata_o),
		.data_rdata_i(data_rdata_i),
		.data_we_ex_i(data_we_ex),
		.data_type_ex_i(data_type_ex),
		.data_wdata_ex_i(data_wdata_ex),
		.data_reg_offset_ex_i(data_reg_offset_ex),
		.data_sign_ext_ex_i(data_sign_ext_ex),
		.data_rdata_ex_o(regfile_wdata_lsu),
		.data_req_ex_i(data_req_ex),
		.adder_result_ex_i(alu_adder_result_ex),
		.data_misaligned_o(data_misaligned),
		.misaligned_addr_o(misaligned_addr),
		.load_err_o(lsu_load_err),
		.store_err_o(lsu_store_err),
		.data_valid_o(data_valid_lsu),
		.lsu_update_addr_o(),
		.busy_o(lsu_busy)
	);
	zeroriscy_cs_registers #(.N_EXT_CNT(N_EXT_PERF_COUNTERS)) cs_registers_i(
		.clk(clk),
		.rst_n(rst_ni),
		.core_id_i(core_id_i),
		.cluster_id_i(cluster_id_i),
		.boot_addr_i(boot_addr_i[31:8]),
		.csr_access_i(csr_access),
		.csr_addr_i(csr_addr),
		.csr_wdata_i(csr_wdata),
		.csr_op_i(csr_op),
		.csr_rdata_o(csr_rdata),
		.m_irq_enable_o(m_irq_enable),
		.mepc_o(mepc),
		.pc_if_i(pc_if),
		.pc_id_i(pc_id),
		.csr_save_if_i(csr_save_if),
		.csr_save_id_i(csr_save_id),
		.csr_restore_mret_i(csr_restore_mret_id),
		.csr_cause_i(csr_cause),
		.csr_save_cause_i(csr_save_cause),
		.if_valid_i(if_valid),
		.id_valid_i(id_valid),
		.is_compressed_i(is_compressed_id),
		.is_decoding_i(is_decoding),
		.imiss_i(perf_imiss),
		.pc_set_i(pc_set),
		.jump_i(perf_jump),
		.branch_i(perf_branch),
		.branch_taken_i(perf_tbranch),
		.mem_load_i((data_req_o & data_gnt_i) & ~data_we_o),
		.mem_store_i((data_req_o & data_gnt_i) & data_we_o),
		.ext_counters_i(ext_perf_counters_i)
	);
	assign csr_access = (dbg_csr_req == 1'b0 ? csr_access_ex : 1'b1);
	assign csr_addr = (dbg_csr_req == 1'b0 ? csr_addr_int : dbg_csr_addr);
	assign csr_wdata = (dbg_csr_req == 1'b0 ? alu_operand_a_ex : dbg_csr_wdata);
	assign csr_op = (dbg_csr_req == 1'b0 ? csr_op_ex : (dbg_csr_we == 1'b1 ? CSR_OP_WRITE : CSR_OP_NONE));
	assign csr_addr_int = (csr_access_ex ? alu_operand_b_ex[11:0] : {12 {1'sb0}});
	zeroriscy_debug_unit debug_unit_i(
		.clk(clk_i),
		.rst_n(rst_ni),
		.debug_req_i(debug_req_i),
		.debug_gnt_o(debug_gnt_o),
		.debug_rvalid_o(debug_rvalid_o),
		.debug_addr_i(debug_addr_i),
		.debug_we_i(debug_we_i),
		.debug_wdata_i(debug_wdata_i),
		.debug_rdata_o(debug_rdata_o),
		.debug_halt_i(debug_halt_i),
		.debug_resume_i(debug_resume_i),
		.debug_halted_o(debug_halted_o),
		.settings_o(dbg_settings),
		.trap_i(dbg_trap),
		.exc_cause_i(exc_cause),
		.stall_o(dbg_stall),
		.dbg_req_o(dbg_req),
		.dbg_ack_i(dbg_ack),
		.regfile_rreq_o(dbg_reg_rreq),
		.regfile_raddr_o(dbg_reg_raddr),
		.regfile_rdata_i(dbg_reg_rdata),
		.regfile_wreq_o(dbg_reg_wreq),
		.regfile_waddr_o(dbg_reg_waddr),
		.regfile_wdata_o(dbg_reg_wdata),
		.csr_req_o(dbg_csr_req),
		.csr_addr_o(dbg_csr_addr),
		.csr_we_o(dbg_csr_we),
		.csr_wdata_o(dbg_csr_wdata),
		.csr_rdata_i(csr_rdata),
		.pc_if_i(pc_if),
		.pc_id_i(pc_id),
		.instr_valid_id_i(instr_valid_id),
		.sleeping_i(sleeping),
		.jump_addr_o(dbg_jump_addr),
		.jump_req_o(dbg_jump_req)
	);
endmodule
