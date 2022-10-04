`define ASIC_SYNTHESIS

module zeroriscy_cs_registers (
	clk,
	rst_n,
	core_id_i,
	cluster_id_i,
	boot_addr_i,
	csr_access_i,
	csr_addr_i,
	csr_wdata_i,
	csr_op_i,
	csr_rdata_o,
	m_irq_enable_o,
	mepc_o,
	pc_if_i,
	pc_id_i,
	csr_save_if_i,
	csr_save_id_i,
	csr_restore_mret_i,
	csr_cause_i,
	csr_save_cause_i,
	if_valid_i,
	id_valid_i,
	is_compressed_i,
	is_decoding_i,
	imiss_i,
	pc_set_i,
	jump_i,
	branch_i,
	branch_taken_i,
	mem_load_i,
	mem_store_i,
	ext_counters_i
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
	parameter N_EXT_CNT = 0;
	input wire clk;
	input wire rst_n;
	input wire [3:0] core_id_i;
	input wire [5:0] cluster_id_i;
	input wire [23:0] boot_addr_i;
	input wire csr_access_i;
	input wire [11:0] csr_addr_i;
	input wire [31:0] csr_wdata_i;
	input wire [1:0] csr_op_i;
	output reg [31:0] csr_rdata_o;
	output wire m_irq_enable_o;
	output wire [31:0] mepc_o;
	input wire [31:0] pc_if_i;
	input wire [31:0] pc_id_i;
	input wire csr_save_if_i;
	input wire csr_save_id_i;
	input wire csr_restore_mret_i;
	input wire [5:0] csr_cause_i;
	input wire csr_save_cause_i;
	input wire if_valid_i;
	input wire id_valid_i;
	input wire is_compressed_i;
	input wire is_decoding_i;
	input wire imiss_i;
	input wire pc_set_i;
	input wire jump_i;
	input wire branch_i;
	input wire branch_taken_i;
	input wire mem_load_i;
	input wire mem_store_i;
	input wire [N_EXT_CNT - 1:0] ext_counters_i;
	localparam N_PERF_COUNTERS = 11 + N_EXT_CNT;
	localparam N_PERF_REGS = 1;
	reg id_valid_q;
	wire [N_PERF_COUNTERS - 1:0] PCCR_in;
	wire [N_PERF_COUNTERS - 1:0] PCCR_inc;
	reg [N_PERF_COUNTERS - 1:0] PCCR_inc_q;
	reg [31:0] PCCR_q;
	reg [31:0] PCCR_n;
	reg [1:0] PCMR_n;
	reg [1:0] PCMR_q;
	reg [N_PERF_COUNTERS - 1:0] PCER_n;
	reg [N_PERF_COUNTERS - 1:0] PCER_q;
	reg [31:0] perf_rdata;
	reg [4:0] pccr_index;
	reg pccr_all_sel;
	reg is_pccr;
	reg is_pcer;
	reg is_pcmr;
	reg [31:0] csr_wdata_int;
	reg [31:0] csr_rdata_int;
	reg csr_we_int;
	reg [31:0] mepc_q;
	reg [31:0] mepc_n;
	reg [5:0] mcause_q;
	reg [5:0] mcause_n;
	struct packed {
		logic mie;
		logic mpie;
		PrivLvl_t mpp;
	} mstatus_q;
	struct packed {
		logic mie;
		logic mpie;
		PrivLvl_t mpp;
	} mstatus_n;
	always @(*) begin
		csr_rdata_int = 1'sb0;
		case (csr_addr_i)
			12'h300: csr_rdata_int = {19'b0000000000000000000, mstatus_q.mpp, 3'b000, mstatus_q.mpie, 3'h0, mstatus_q.mie, 3'h0};
			12'h305: csr_rdata_int = {boot_addr_i, 8'h00};
			12'h341: csr_rdata_int = mepc_q;
			12'h342: csr_rdata_int = {mcause_q[5], 26'b00000000000000000000000000, mcause_q[4:0]};
			12'hf14: csr_rdata_int = {21'b000000000000000000000, cluster_id_i[5:0], 1'b0, core_id_i[3:0]};
			default:
				;
		endcase
	end
	always @(*) begin
		mepc_n = mepc_q;
		mstatus_n = mstatus_q;
		mcause_n = mcause_q;
		case (csr_addr_i)
			12'h300:
				if (csr_we_int)
					mstatus_n = {
						csr_wdata_int[3],
						csr_wdata_int[7],
						1'b0
					};
			12'h341:
				if (csr_we_int)
					mepc_n = csr_wdata_int;
			12'h342:
				if (csr_we_int)
					mcause_n = {csr_wdata_int[31], csr_wdata_int[4:0]};
			default:
				;
		endcase
		case (1'b1)
			csr_save_cause_i: begin
				case (1'b1)
					csr_save_if_i: mepc_n = pc_if_i;
					csr_save_id_i: mepc_n = pc_id_i;
					default:
						;
				endcase
				mstatus_n.mpie = mstatus_q.mie;
				mstatus_n.mie = 1'b0;
				mcause_n = csr_cause_i;
			end
			csr_restore_mret_i: begin
				mstatus_n.mie = mstatus_q.mpie;
				mstatus_n.mpie = 1'b1;
			end
			default:
				;
		endcase
	end
	always @(*) begin
		csr_wdata_int = csr_wdata_i;
		csr_we_int = 1'b1;
		case (csr_op_i)
			CSR_OP_WRITE: csr_wdata_int = csr_wdata_i;
			CSR_OP_SET: csr_wdata_int = csr_wdata_i | csr_rdata_o;
			CSR_OP_CLEAR: csr_wdata_int = ~csr_wdata_i & csr_rdata_o;
			CSR_OP_NONE: begin
				csr_wdata_int = csr_wdata_i;
				csr_we_int = 1'b0;
			end
			default:
				;
		endcase
	end
	always @(*) begin
		csr_rdata_o = csr_rdata_int;
		if ((is_pccr || is_pcer) || is_pcmr)
			csr_rdata_o = perf_rdata;
	end
	assign m_irq_enable_o = mstatus_q.mie;
	assign mepc_o = mepc_q;
	always @(posedge clk or negedge rst_n)
		if (rst_n == 1'b0) begin
			mstatus_q <= {
				1'b0,
				1'b0,
				PRIV_LVL_M
			};
			mepc_q <= 1'sb0;
			mcause_q <= 1'sb0;
		end
		else begin
			mstatus_q <= {
				mstatus_n.mie,
				mstatus_n.mpie,
				PRIV_LVL_M
			};
			mepc_q <= mepc_n;
			mcause_q <= mcause_n;
		end
	assign PCCR_in[0] = 1'b1;
	assign PCCR_in[1] = if_valid_i;
	assign PCCR_in[2] = 1'b0;
	assign PCCR_in[3] = 1'b0;
	assign PCCR_in[4] = imiss_i & ~pc_set_i;
	assign PCCR_in[5] = mem_load_i;
	assign PCCR_in[6] = mem_store_i;
	assign PCCR_in[7] = jump_i;
	assign PCCR_in[8] = branch_i;
	assign PCCR_in[9] = branch_taken_i;
	assign PCCR_in[10] = (id_valid_i & is_decoding_i) & is_compressed_i;
	genvar i;
	generate
		for (i = 0; i < N_EXT_CNT; i = i + 1) begin : g_extcounters
			assign PCCR_in[(N_PERF_COUNTERS - N_EXT_CNT) + i] = ext_counters_i[i];
		end
	endgenerate
	always @(*) begin
		is_pccr = 1'b0;
		is_pcmr = 1'b0;
		is_pcer = 1'b0;
		pccr_all_sel = 1'b0;
		pccr_index = 1'sb0;
		perf_rdata = 1'sb0;
		if (csr_access_i) begin
			case (csr_addr_i)
				12'h7a0: begin
					is_pcer = 1'b1;
					perf_rdata[15:0] = PCER_q;
				end
				12'h7a1: begin
					is_pcmr = 1'b1;
					perf_rdata[1:0] = PCMR_q;
				end
				12'h79f: begin
					is_pccr = 1'b1;
					pccr_all_sel = 1'b1;
				end
				default:
					;
			endcase
			if (csr_addr_i[11:5] == 7'b0111100) begin
				is_pccr = 1'b1;
				pccr_index = csr_addr_i[4:0];
				perf_rdata = PCCR_q[0+:32];
			end
		end
	end
	assign PCCR_inc[0] = |(PCCR_in & PCER_q) & PCMR_q[0];
	always @(*) begin
		PCCR_n[0+:32] = PCCR_q[0+:32];
		if ((PCCR_inc_q[0] == 1'b1) && ((PCCR_q[0+:32] != 32'hffffffff) || (PCMR_q[1] == 1'b0)))
			PCCR_n[0+:32] = PCCR_q[0+:32] + 1;
		if (is_pccr == 1'b1)
			case (csr_op_i)
				CSR_OP_NONE:
					;
				CSR_OP_WRITE: PCCR_n[0+:32] = csr_wdata_i;
				CSR_OP_SET: PCCR_n[0+:32] = csr_wdata_i | PCCR_q[0+:32];
				CSR_OP_CLEAR: PCCR_n[0+:32] = csr_wdata_i & ~PCCR_q[0+:32];
			endcase
	end
	always @(*) begin
		PCMR_n = PCMR_q;
		PCER_n = PCER_q;
		if (is_pcmr)
			case (csr_op_i)
				CSR_OP_NONE:
					;
				CSR_OP_WRITE: PCMR_n = csr_wdata_i[1:0];
				CSR_OP_SET: PCMR_n = csr_wdata_i[1:0] | PCMR_q;
				CSR_OP_CLEAR: PCMR_n = csr_wdata_i[1:0] & ~PCMR_q;
			endcase
		if (is_pcer)
			case (csr_op_i)
				CSR_OP_NONE:
					;
				CSR_OP_WRITE: PCER_n = csr_wdata_i[N_PERF_COUNTERS - 1:0];
				CSR_OP_SET: PCER_n = csr_wdata_i[N_PERF_COUNTERS - 1:0] | PCER_q;
				CSR_OP_CLEAR: PCER_n = csr_wdata_i[N_PERF_COUNTERS - 1:0] & ~PCER_q;
			endcase
	end
	always @(posedge clk or negedge rst_n)
		if (rst_n == 1'b0) begin
			id_valid_q <= 1'b0;
			PCER_q <= 1'sb0;
			PCMR_q <= 2'h3;
			begin : sv2v_autoblock_1
				reg signed [31:0] i;
				for (i = 0; i < N_PERF_REGS; i = i + 1)
					begin
						PCCR_q[i * 32+:32] <= 1'sb0;
						PCCR_inc_q[i] <= 1'sb0;
					end
			end
		end
		else begin
			id_valid_q <= id_valid_i;
			PCER_q <= PCER_n;
			PCMR_q <= PCMR_n;
			begin : sv2v_autoblock_2
				reg signed [31:0] i;
				for (i = 0; i < N_PERF_REGS; i = i + 1)
					begin
						PCCR_q[i * 32+:32] <= PCCR_n[i * 32+:32];
						PCCR_inc_q[i] <= PCCR_inc[i];
					end
			end
		end
endmodule
