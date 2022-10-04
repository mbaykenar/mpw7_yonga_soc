module zeroriscy_debug_unit 
#(
    parameter REG_ADDR_WIDTH      = 5
)
(
	clk,
	rst_n,
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
	settings_o,
	trap_i,
	exc_cause_i,
	stall_o,
	dbg_req_o,
	dbg_ack_i,
	regfile_rreq_o,
	regfile_raddr_o,
	regfile_rdata_i,
	regfile_wreq_o,
	regfile_waddr_o,
	regfile_wdata_o,
	csr_req_o,
	csr_addr_o,
	csr_we_o,
	csr_wdata_o,
	csr_rdata_i,
	pc_if_i,
	pc_id_i,
	instr_valid_id_i,
	sleeping_i,
	jump_req_o,
	jump_addr_o
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
	input wire debug_req_i;
	output reg debug_gnt_o;
	output reg debug_rvalid_o;
	input wire [14:0] debug_addr_i;
	input wire debug_we_i;
	input wire [31:0] debug_wdata_i;
	output reg [31:0] debug_rdata_o;
	output reg debug_halted_o;
	input wire debug_halt_i;
	input wire debug_resume_i;
	output wire [DBG_SETS_W - 1:0] settings_o;
	input wire trap_i;
	input wire [5:0] exc_cause_i;
	output reg stall_o;
	output reg dbg_req_o;
	input wire dbg_ack_i;
	output wire regfile_rreq_o;
	output wire [REG_ADDR_WIDTH - 1:0] regfile_raddr_o;
	input wire [31:0] regfile_rdata_i;
	output wire regfile_wreq_o;
	output wire [REG_ADDR_WIDTH - 1:0] regfile_waddr_o;
	output wire [31:0] regfile_wdata_o;
	output wire csr_req_o;
	output wire [11:0] csr_addr_o;
	output reg csr_we_o;
	output wire [31:0] csr_wdata_o;
	input wire [31:0] csr_rdata_i;
	input wire [31:0] pc_if_i;
	input wire [31:0] pc_id_i;
	input wire instr_valid_id_i;
	input wire sleeping_i;
	output wire jump_req_o;
	output wire [31:0] jump_addr_o;
	reg [2:0] rdata_sel_q;
	reg [2:0] rdata_sel_n;
	reg [0:0] state_q;
	reg [0:0] state_n;
	reg [DBG_SETS_W - 1:0] settings_q;
	reg [DBG_SETS_W - 1:0] settings_n;
	reg [14:0] addr_q;
	reg [31:0] wdata_q;
	reg regfile_rreq_q;
	reg regfile_rreq_n;
	reg jump_req_q;
	reg jump_req_n;
	reg csr_req_q;
	reg csr_req_n;
	reg regfile_wreq;
	reg [1:0] stall_cs;
	reg [1:0] stall_ns;
	reg [31:0] dbg_rdata;
	reg dbg_resume;
	reg dbg_halt;
	reg [5:0] dbg_cause_q;
	reg [5:0] dbg_cause_n;
	reg dbg_ssth_q;
	reg dbg_ssth_n;
	reg ssth_clear;
	wire [31:0] ppc_int;
	wire [31:0] npc_int;
	always @(*) begin
		rdata_sel_n = 3'd0;
		state_n = 1'd0;
		debug_gnt_o = 1'b0;
		regfile_rreq_n = 1'b0;
		regfile_wreq = 1'b0;
		csr_req_n = 1'b0;
		csr_we_o = 1'b0;
		jump_req_n = 1'b0;
		dbg_resume = 1'b0;
		dbg_halt = 1'b0;
		settings_n = settings_q;
		ssth_clear = 1'b0;
		if (debug_req_i)
			if (debug_we_i) begin
				if (debug_addr_i[14]) begin
					if (state_q == 1'd0) begin
						debug_gnt_o = 1'b0;
						state_n = 1'd1;
						if (debug_halted_o)
							csr_req_n = 1'b1;
					end
					else begin
						debug_gnt_o = 1'b1;
						state_n = 1'd0;
						csr_we_o = 1'b1;
					end
				end
				else
					case (debug_addr_i[13:8])
						6'b000000: begin
							debug_gnt_o = 1'b1;
							case (debug_addr_i[6:2])
								5'b00000: begin
									if (debug_wdata_i[16]) begin
										if (~debug_halted_o)
											dbg_halt = 1'b1;
									end
									else if (debug_halted_o)
										dbg_resume = 1'b1;
									settings_n[DBG_SETS_SSTE] = debug_wdata_i[0];
								end
								5'b00001: ssth_clear = debug_wdata_i[0];
								5'b00010: begin
									settings_n[DBG_SETS_ECALL] = debug_wdata_i[11];
									settings_n[DBG_SETS_ELSU] = debug_wdata_i[7] | debug_wdata_i[5];
									settings_n[DBG_SETS_EBRK] = debug_wdata_i[3];
									settings_n[DBG_SETS_EILL] = debug_wdata_i[2];
								end
								default:
									;
							endcase
						end
						6'b100000: begin
							debug_gnt_o = 1'b1;
							if (debug_halted_o)
								case (debug_addr_i[6:2])
									5'b00000: jump_req_n = 1'b1;
									default:
										;
								endcase
						end
						6'b000100: begin
							debug_gnt_o = 1'b1;
							if (debug_halted_o)
								regfile_wreq = 1'b1;
						end
						default: debug_gnt_o = 1'b1;
					endcase
			end
			else if (debug_addr_i[14]) begin
				debug_gnt_o = 1'b1;
				if (debug_halted_o) begin
					csr_req_n = 1'b1;
					rdata_sel_n = 3'd1;
				end
			end
			else
				case (debug_addr_i[13:8])
					6'b000000: begin
						debug_gnt_o = 1'b1;
						rdata_sel_n = 3'd3;
					end
					6'b100000: begin
						debug_gnt_o = 1'b1;
						rdata_sel_n = 3'd4;
					end
					6'b000100: begin
						debug_gnt_o = 1'b1;
						if (debug_halted_o) begin
							regfile_rreq_n = 1'b1;
							rdata_sel_n = 3'd2;
						end
					end
					default: debug_gnt_o = 1'b1;
				endcase
	end
	always @(*) begin
		dbg_rdata = 1'sb0;
		case (rdata_sel_q)
			3'd3:
				case (addr_q[6:2])
					5'h00: dbg_rdata[31:0] = {15'b000000000000000, debug_halted_o, 15'b000000000000000, settings_q[DBG_SETS_SSTE]};
					5'h01: dbg_rdata[31:0] = {15'b000000000000000, sleeping_i, 15'b000000000000000, dbg_ssth_q};
					5'h02: begin
						dbg_rdata[31:16] = 1'sb0;
						dbg_rdata[15:12] = 1'sb0;
						dbg_rdata[11] = settings_q[DBG_SETS_ECALL];
						dbg_rdata[10:8] = 1'sb0;
						dbg_rdata[7] = settings_q[DBG_SETS_ELSU];
						dbg_rdata[6] = 1'b0;
						dbg_rdata[5] = settings_q[DBG_SETS_ELSU];
						dbg_rdata[4] = 1'b0;
						dbg_rdata[3] = settings_q[DBG_SETS_EBRK];
						dbg_rdata[2] = settings_q[DBG_SETS_EILL];
						dbg_rdata[1:0] = 1'sb0;
					end
					5'h03: dbg_rdata = {dbg_cause_q[5], 26'b00000000000000000000000000, dbg_cause_q[4:0]};
					5'h10: dbg_rdata = 1'sb0;
					5'h12: dbg_rdata = 1'sb0;
					5'h14: dbg_rdata = 1'sb0;
					5'h16: dbg_rdata = 1'sb0;
					5'h18: dbg_rdata = 1'sb0;
					5'h1a: dbg_rdata = 1'sb0;
					5'h1c: dbg_rdata = 1'sb0;
					5'h1e: dbg_rdata = 1'sb0;
					default:
						;
				endcase
			3'd4:
				case (addr_q[2:2])
					1'b0: dbg_rdata = npc_int;
					1'b1: dbg_rdata = ppc_int;
					default:
						;
				endcase
			default:
				;
		endcase
	end
	always @(*) begin
		debug_rdata_o = 1'sb0;
		case (rdata_sel_q)
			3'd1: debug_rdata_o = csr_rdata_i;
			3'd2: debug_rdata_o = regfile_rdata_i;
			3'd3: debug_rdata_o = dbg_rdata;
			3'd4: debug_rdata_o = dbg_rdata;
			default:
				;
		endcase
	end
	always @(posedge clk or negedge rst_n)
		if (~rst_n)
			debug_rvalid_o <= 1'b0;
		else
			debug_rvalid_o <= debug_gnt_o;
	always @(*) begin
		stall_ns = stall_cs;
		dbg_req_o = 1'b0;
		stall_o = 1'b0;
		debug_halted_o = 1'b0;
		dbg_cause_n = dbg_cause_q;
		dbg_ssth_n = dbg_ssth_q;
		case (stall_cs)
			2'd0: begin
				dbg_ssth_n = 1'b0;
				if ((dbg_halt | debug_halt_i) | trap_i) begin
					dbg_req_o = 1'b1;
					stall_ns = 2'd1;
					if (trap_i) begin
						if (settings_q[DBG_SETS_SSTE])
							dbg_ssth_n = 1'b1;
						dbg_cause_n = exc_cause_i;
					end
					else
						dbg_cause_n = DBG_CAUSE_HALT;
				end
			end
			2'd1: begin
				dbg_req_o = 1'b1;
				if (dbg_ack_i)
					stall_ns = 2'd2;
				if (dbg_resume | debug_resume_i)
					stall_ns = 2'd0;
			end
			2'd2: begin
				stall_o = 1'b1;
				debug_halted_o = 1'b1;
				if (dbg_resume | debug_resume_i) begin
					stall_ns = 2'd0;
					stall_o = 1'b0;
				end
			end
		endcase
		if (ssth_clear)
			dbg_ssth_n = 1'b0;
	end
	always @(posedge clk or negedge rst_n)
		if (~rst_n) begin
			stall_cs <= 2'd0;
			dbg_cause_q <= DBG_CAUSE_HALT;
			dbg_ssth_q <= 1'b0;
		end
		else begin
			stall_cs <= stall_ns;
			dbg_cause_q <= dbg_cause_n;
			dbg_ssth_q <= dbg_ssth_n;
		end
	assign ppc_int = pc_id_i;
	assign npc_int = pc_if_i;
	always @(posedge clk or negedge rst_n)
		if (~rst_n) begin
			addr_q <= 1'sb0;
			wdata_q <= 1'sb0;
			state_q <= 1'd0;
			rdata_sel_q <= 3'd0;
			regfile_rreq_q <= 1'b0;
			csr_req_q <= 1'b0;
			jump_req_q <= 1'b0;
			settings_q <= 1'b0;
		end
		else begin
			settings_q <= settings_n;
			if (debug_req_i) begin
				addr_q <= debug_addr_i;
				wdata_q <= debug_wdata_i;
				state_q <= state_n;
			end
			if (debug_req_i | debug_rvalid_o) begin
				regfile_rreq_q <= regfile_rreq_n;
				csr_req_q <= csr_req_n;
				jump_req_q <= jump_req_n;
				rdata_sel_q <= rdata_sel_n;
			end
		end
	assign regfile_rreq_o = regfile_rreq_q;
	assign regfile_raddr_o = addr_q[6:2];
	assign regfile_wreq_o = regfile_wreq;
	assign regfile_waddr_o = debug_addr_i[6:2];
	assign regfile_wdata_o = debug_wdata_i;
	assign csr_req_o = csr_req_q;
	assign csr_addr_o = addr_q[13:2];
	assign csr_wdata_o = wdata_q;
	assign jump_req_o = jump_req_q;
	assign jump_addr_o = wdata_q;
	assign settings_o = settings_q;
endmodule
