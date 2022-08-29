`define USE_POWER_PINS
module mba_core_region 
#(
    parameter AXI_ADDR_WIDTH       = 32,
    parameter AXI_DATA_WIDTH       = 64,
    parameter AXI_ID_MASTER_WIDTH  = 10,
    parameter AXI_ID_SLAVE_WIDTH   = 10,
    parameter AXI_USER_WIDTH       = 0,
//    parameter DATA_RAM_SIZE        = 32768, // in bytes
//    parameter INSTR_RAM_SIZE       = 32768, // in bytes
    parameter DATA_RAM_SIZE        = 2048, // in bytes
    parameter INSTR_RAM_SIZE       = 2048, // in bytes
    parameter USE_ZERO_RISCY       = 1,
    parameter RISCY_RV32F          = 0,
    parameter ZERO_RV32M           = 1,
    parameter ZERO_RV32E           = 0

  )
(
`ifdef USE_POWER_PINS
	vccd1,	// User area 1 1.8V supply
	vssd1,	// User area 1 digital ground
`endif
	clk,
	rst_n,
	testmode_i,
	fetch_enable_i,
	irq_i,
	core_busy_o,
	clock_gating_i,
	boot_addr_i,
	core_master_aw_addr,
	core_master_aw_prot,
	core_master_aw_region,
	core_master_aw_len,
	core_master_aw_size,
	core_master_aw_burst,
	core_master_aw_lock,
	core_master_aw_cache,
	core_master_aw_qos,
	core_master_aw_id,
	core_master_aw_user,
	core_master_aw_ready,
	core_master_aw_valid,
	core_master_ar_addr,
	core_master_ar_prot,
	core_master_ar_region,
	core_master_ar_len,
	core_master_ar_size,
	core_master_ar_burst,
	core_master_ar_lock,
	core_master_ar_cache,
	core_master_ar_qos,
	core_master_ar_id,
	core_master_ar_user,
	core_master_ar_ready,
	core_master_ar_valid,
	core_master_w_valid,
	core_master_w_data,
	core_master_w_strb,
	core_master_w_user,
	core_master_w_last,
	core_master_w_ready,
	core_master_r_data,
	core_master_r_resp,
	core_master_r_last,
	core_master_r_id,
	core_master_r_user,
	core_master_r_ready,
	core_master_r_valid,
	core_master_b_resp,
	core_master_b_id,
	core_master_b_user,
	core_master_b_ready,
	core_master_b_valid,
	dbg_master_aw_addr,
	dbg_master_aw_prot,
	dbg_master_aw_region,
	dbg_master_aw_len,
	dbg_master_aw_size,
	dbg_master_aw_burst,
	dbg_master_aw_lock,
	dbg_master_aw_cache,
	dbg_master_aw_qos,
	dbg_master_aw_id,
	dbg_master_aw_user,
	dbg_master_aw_ready,
	dbg_master_aw_valid,
	dbg_master_ar_addr,
	dbg_master_ar_prot,
	dbg_master_ar_region,
	dbg_master_ar_len,
	dbg_master_ar_size,
	dbg_master_ar_burst,
	dbg_master_ar_lock,
	dbg_master_ar_cache,
	dbg_master_ar_qos,
	dbg_master_ar_id,
	dbg_master_ar_user,
	dbg_master_ar_ready,
	dbg_master_ar_valid,
	dbg_master_w_valid,
	dbg_master_w_data,
	dbg_master_w_strb,
	dbg_master_w_user,
	dbg_master_w_last,
	dbg_master_w_ready,
	dbg_master_r_data,
	dbg_master_r_resp,
	dbg_master_r_last,
	dbg_master_r_id,
	dbg_master_r_user,
	dbg_master_r_ready,
	dbg_master_r_valid,
	dbg_master_b_resp,
	dbg_master_b_id,
	dbg_master_b_user,
	dbg_master_b_ready,
	dbg_master_b_valid,
	data_slave_aw_addr,
	data_slave_aw_prot,
	data_slave_aw_region,
	data_slave_aw_len,
	data_slave_aw_size,
	data_slave_aw_burst,
	data_slave_aw_lock,
	data_slave_aw_cache,
	data_slave_aw_qos,
	data_slave_aw_id,
	data_slave_aw_user,
	data_slave_aw_ready,
	data_slave_aw_valid,
	data_slave_ar_addr,
	data_slave_ar_prot,
	data_slave_ar_region,
	data_slave_ar_len,
	data_slave_ar_size,
	data_slave_ar_burst,
	data_slave_ar_lock,
	data_slave_ar_cache,
	data_slave_ar_qos,
	data_slave_ar_id,
	data_slave_ar_user,
	data_slave_ar_ready,
	data_slave_ar_valid,
	data_slave_w_valid,
	data_slave_w_data,
	data_slave_w_strb,
	data_slave_w_user,
	data_slave_w_last,
	data_slave_w_ready,
	data_slave_r_data,
	data_slave_r_resp,
	data_slave_r_last,
	data_slave_r_id,
	data_slave_r_user,
	data_slave_r_ready,
	data_slave_r_valid,
	data_slave_b_resp,
	data_slave_b_id,
	data_slave_b_user,
	data_slave_b_ready,
	data_slave_b_valid,
	instr_slave_aw_addr,
	instr_slave_aw_prot,
	instr_slave_aw_region,
	instr_slave_aw_len,
	instr_slave_aw_size,
	instr_slave_aw_burst,
	instr_slave_aw_lock,
	instr_slave_aw_cache,
	instr_slave_aw_qos,
	instr_slave_aw_id,
	instr_slave_aw_user,
	instr_slave_aw_ready,
	instr_slave_aw_valid,
	instr_slave_ar_addr,
	instr_slave_ar_prot,
	instr_slave_ar_region,
	instr_slave_ar_len,
	instr_slave_ar_size,
	instr_slave_ar_burst,
	instr_slave_ar_lock,
	instr_slave_ar_cache,
	instr_slave_ar_qos,
	instr_slave_ar_id,
	instr_slave_ar_user,
	instr_slave_ar_ready,
	instr_slave_ar_valid,
	instr_slave_w_valid,
	instr_slave_w_data,
	instr_slave_w_strb,
	instr_slave_w_user,
	instr_slave_w_last,
	instr_slave_w_ready,
	instr_slave_r_data,
	instr_slave_r_resp,
	instr_slave_r_last,
	instr_slave_r_id,
	instr_slave_r_user,
	instr_slave_r_ready,
	instr_slave_r_valid,
	instr_slave_b_resp,
	instr_slave_b_id,
	instr_slave_b_user,
	instr_slave_b_ready,
	instr_slave_b_valid,
	debug_req,
	debug_gnt,
	debug_rvalid,
	debug_addr,
	debug_we,
	debug_wdata,
	debug_rdata,
	tck_i,
	trstn_i,
	tms_i,
	tdi_i,
	tdo_o,
	// MBA START
	//////////////////////////////////////////
	// instruction memory port
	mba_instr_mem_csb0_o,
	mba_instr_mem_web0_o,
	mba_instr_mem_wmask0_o,
	mba_instr_mem_addr0_o,
	mba_instr_mem_din0_o,
	mba_instr_mem_dout0_i,
	mba_instr_mem_csb1_o,
	mba_instr_mem_addr1_o,
	// data memory port
	mba_data_mem_csb0_o,
	mba_data_mem_web0_o,
	mba_data_mem_wmask0_o,
	mba_data_mem_addr0_o,
	mba_data_mem_din0_o,
	mba_data_mem_dout0_i,
	mba_data_mem_csb1_o,
	mba_data_mem_addr1_o	
	//////////////////////////////////////////
	// MBA END
);
	//parameter AXI_ADDR_WIDTH = 32;
	//parameter AXI_DATA_WIDTH = 64;
	//parameter AXI_ID_MASTER_WIDTH = 10;
	//parameter AXI_ID_SLAVE_WIDTH = 10;
	//parameter AXI_USER_WIDTH = 0;
	parameter AXI_STRB_WIDTH = AXI_DATA_WIDTH / 8;
	parameter ADDR_WIDTH = AXI_ADDR_WIDTH;
	//parameter DATA_RAM_SIZE = 2048;
	//parameter INSTR_RAM_SIZE = 2048;
	//parameter USE_ZERO_RISCY = 1;
	//parameter RISCY_RV32F = 0;
	//parameter ZERO_RV32M = 1;
	//parameter ZERO_RV32E = 0;
    parameter AXI_ID_WIDTH   = AXI_ID_MASTER_WIDTH;

	// MBA START
	//////////////////////////////////////////
	// instruction memory port
	output wire mba_instr_mem_csb0_o;
	output wire mba_instr_mem_web0_o;
 	output wire [3:0] mba_instr_mem_wmask0_o;
	output wire [31:0] mba_instr_mem_addr0_o;
	output wire [31:0] mba_instr_mem_din0_o;
	input  wire [31:0] mba_instr_mem_dout0_i;
	output wire mba_instr_mem_csb1_o;
	output wire [31:0] mba_instr_mem_addr1_o;
	// data memory port
	output wire mba_data_mem_csb0_o;
	output wire mba_data_mem_web0_o;
	output wire [3:0] mba_data_mem_wmask0_o;
	output wire [31:0] mba_data_mem_addr0_o;
	output wire [31:0] mba_data_mem_din0_o;
	input  wire [31:0] mba_data_mem_dout0_i;
	output wire mba_data_mem_csb1_o;
	output wire [31:0] mba_data_mem_addr1_o;	
	//////////////////////////////////////////
	// MBA END

`ifdef USE_POWER_PINS
	inout wire vccd1;
	inout wire vssd1;
`endif
	input wire clk;
	input wire rst_n;
	input wire testmode_i;
	input wire fetch_enable_i;
	input wire [31:0] irq_i;
	output wire core_busy_o;
	input wire clock_gating_i;
	input wire [31:0] boot_addr_i;
	output wire [AXI_ADDR_WIDTH - 1:0] core_master_aw_addr;
	output wire [2:0] core_master_aw_prot;
	output wire [3:0] core_master_aw_region;
	output wire [7:0] core_master_aw_len;
	output wire [2:0] core_master_aw_size;
	output wire [1:0] core_master_aw_burst;
	output wire core_master_aw_lock;
	output wire [3:0] core_master_aw_cache;
	output wire [3:0] core_master_aw_qos;
	output wire [AXI_ID_MASTER_WIDTH - 1:0] core_master_aw_id;
	output wire [AXI_USER_WIDTH - 1:0] core_master_aw_user;
	input wire core_master_aw_ready;
	output wire core_master_aw_valid;
	output wire [AXI_ADDR_WIDTH - 1:0] core_master_ar_addr;
	output wire [2:0] core_master_ar_prot;
	output wire [3:0] core_master_ar_region;
	output wire [7:0] core_master_ar_len;
	output wire [2:0] core_master_ar_size;
	output wire [1:0] core_master_ar_burst;
	output wire core_master_ar_lock;
	output wire [3:0] core_master_ar_cache;
	output wire [3:0] core_master_ar_qos;
	output wire [AXI_ID_MASTER_WIDTH - 1:0] core_master_ar_id;
	output wire [AXI_USER_WIDTH - 1:0] core_master_ar_user;
	input wire core_master_ar_ready;
	output wire core_master_ar_valid;
	output wire core_master_w_valid;
	output wire [AXI_DATA_WIDTH - 1:0] core_master_w_data;
	output wire [AXI_STRB_WIDTH - 1:0] core_master_w_strb;
	output wire [AXI_USER_WIDTH - 1:0] core_master_w_user;
	output wire core_master_w_last;
	input wire core_master_w_ready;
	input wire [AXI_DATA_WIDTH - 1:0] core_master_r_data;
	input wire [1:0] core_master_r_resp;
	input wire core_master_r_last;
	input wire [AXI_ID_MASTER_WIDTH - 1:0] core_master_r_id;
	input wire [AXI_USER_WIDTH - 1:0] core_master_r_user;
	output wire core_master_r_ready;
	input wire core_master_r_valid;
	input wire [1:0] core_master_b_resp;
	input wire [AXI_ID_MASTER_WIDTH - 1:0] core_master_b_id;
	input wire [AXI_USER_WIDTH - 1:0] core_master_b_user;
	output wire core_master_b_ready;
	input wire core_master_b_valid;
	output wire [AXI_ADDR_WIDTH - 1:0] dbg_master_aw_addr;
	output wire [2:0] dbg_master_aw_prot;
	output wire [3:0] dbg_master_aw_region;
	output wire [7:0] dbg_master_aw_len;
	output wire [2:0] dbg_master_aw_size;
	output wire [1:0] dbg_master_aw_burst;
	output wire dbg_master_aw_lock;
	output wire [3:0] dbg_master_aw_cache;
	output wire [3:0] dbg_master_aw_qos;
	output wire [AXI_ID_MASTER_WIDTH - 1:0] dbg_master_aw_id;
	output wire [AXI_USER_WIDTH - 1:0] dbg_master_aw_user;
	input wire dbg_master_aw_ready;
	output wire dbg_master_aw_valid;
	output wire [AXI_ADDR_WIDTH - 1:0] dbg_master_ar_addr;
	output wire [2:0] dbg_master_ar_prot;
	output wire [3:0] dbg_master_ar_region;
	output wire [7:0] dbg_master_ar_len;
	output wire [2:0] dbg_master_ar_size;
	output wire [1:0] dbg_master_ar_burst;
	output wire dbg_master_ar_lock;
	output wire [3:0] dbg_master_ar_cache;
	output wire [3:0] dbg_master_ar_qos;
	output wire [AXI_ID_MASTER_WIDTH - 1:0] dbg_master_ar_id;
	output wire [AXI_USER_WIDTH - 1:0] dbg_master_ar_user;
	input wire dbg_master_ar_ready;
	output wire dbg_master_ar_valid;
	output wire dbg_master_w_valid;
	output wire [AXI_DATA_WIDTH - 1:0] dbg_master_w_data;
	output wire [AXI_STRB_WIDTH - 1:0] dbg_master_w_strb;
	output wire [AXI_USER_WIDTH - 1:0] dbg_master_w_user;
	output wire dbg_master_w_last;
	input wire dbg_master_w_ready;
	input wire [AXI_DATA_WIDTH - 1:0] dbg_master_r_data;
	input wire [1:0] dbg_master_r_resp;
	input wire dbg_master_r_last;
	input wire [AXI_ID_MASTER_WIDTH - 1:0] dbg_master_r_id;
	input wire [AXI_USER_WIDTH - 1:0] dbg_master_r_user;
	output wire dbg_master_r_ready;
	input wire dbg_master_r_valid;
	input wire [1:0] dbg_master_b_resp;
	input wire [AXI_ID_MASTER_WIDTH - 1:0] dbg_master_b_id;
	input wire [AXI_USER_WIDTH - 1:0] dbg_master_b_user;
	output wire dbg_master_b_ready;
	input wire dbg_master_b_valid;
	input wire [AXI_ADDR_WIDTH - 1:0] data_slave_aw_addr;
	input wire [2:0] data_slave_aw_prot;
	input wire [3:0] data_slave_aw_region;
	input wire [7:0] data_slave_aw_len;
	input wire [2:0] data_slave_aw_size;
	input wire [1:0] data_slave_aw_burst;
	input wire data_slave_aw_lock;
	input wire [3:0] data_slave_aw_cache;
	input wire [3:0] data_slave_aw_qos;
	input wire [AXI_ID_SLAVE_WIDTH - 1:0] data_slave_aw_id;
	input wire [AXI_USER_WIDTH - 1:0] data_slave_aw_user;
	output wire data_slave_aw_ready;
	input wire data_slave_aw_valid;
	input wire [AXI_ADDR_WIDTH - 1:0] data_slave_ar_addr;
	input wire [2:0] data_slave_ar_prot;
	input wire [3:0] data_slave_ar_region;
	input wire [7:0] data_slave_ar_len;
	input wire [2:0] data_slave_ar_size;
	input wire [1:0] data_slave_ar_burst;
	input wire data_slave_ar_lock;
	input wire [3:0] data_slave_ar_cache;
	input wire [3:0] data_slave_ar_qos;
	input wire [AXI_ID_SLAVE_WIDTH - 1:0] data_slave_ar_id;
	input wire [AXI_USER_WIDTH - 1:0] data_slave_ar_user;
	output wire data_slave_ar_ready;
	input wire data_slave_ar_valid;
	input wire data_slave_w_valid;
	input wire [AXI_DATA_WIDTH - 1:0] data_slave_w_data;
	input wire [AXI_STRB_WIDTH - 1:0] data_slave_w_strb;
	input wire [AXI_USER_WIDTH - 1:0] data_slave_w_user;
	input wire data_slave_w_last;
	output wire data_slave_w_ready;
	output wire [AXI_DATA_WIDTH - 1:0] data_slave_r_data;
	output wire [1:0] data_slave_r_resp;
	output wire data_slave_r_last;
	output wire [AXI_ID_SLAVE_WIDTH - 1:0] data_slave_r_id;
	output wire [AXI_USER_WIDTH - 1:0] data_slave_r_user;
	input wire data_slave_r_ready;
	output wire data_slave_r_valid;
	output wire [1:0] data_slave_b_resp;
	output wire [AXI_ID_SLAVE_WIDTH - 1:0] data_slave_b_id;
	output wire [AXI_USER_WIDTH - 1:0] data_slave_b_user;
	input wire data_slave_b_ready;
	output wire data_slave_b_valid;
	input wire [AXI_ADDR_WIDTH - 1:0] instr_slave_aw_addr;
	input wire [2:0] instr_slave_aw_prot;
	input wire [3:0] instr_slave_aw_region;
	input wire [7:0] instr_slave_aw_len;
	input wire [2:0] instr_slave_aw_size;
	input wire [1:0] instr_slave_aw_burst;
	input wire instr_slave_aw_lock;
	input wire [3:0] instr_slave_aw_cache;
	input wire [3:0] instr_slave_aw_qos;
	input wire [AXI_ID_SLAVE_WIDTH - 1:0] instr_slave_aw_id;
	input wire [AXI_USER_WIDTH - 1:0] instr_slave_aw_user;
	output wire instr_slave_aw_ready;
	input wire instr_slave_aw_valid;
	input wire [AXI_ADDR_WIDTH - 1:0] instr_slave_ar_addr;
	input wire [2:0] instr_slave_ar_prot;
	input wire [3:0] instr_slave_ar_region;
	input wire [7:0] instr_slave_ar_len;
	input wire [2:0] instr_slave_ar_size;
	input wire [1:0] instr_slave_ar_burst;
	input wire instr_slave_ar_lock;
	input wire [3:0] instr_slave_ar_cache;
	input wire [3:0] instr_slave_ar_qos;
	input wire [AXI_ID_SLAVE_WIDTH - 1:0] instr_slave_ar_id;
	input wire [AXI_USER_WIDTH - 1:0] instr_slave_ar_user;
	output wire instr_slave_ar_ready;
	input wire instr_slave_ar_valid;
	input wire instr_slave_w_valid;
	input wire [AXI_DATA_WIDTH - 1:0] instr_slave_w_data;
	input wire [AXI_STRB_WIDTH - 1:0] instr_slave_w_strb;
	input wire [AXI_USER_WIDTH - 1:0] instr_slave_w_user;
	input wire instr_slave_w_last;
	output wire instr_slave_w_ready;
	output wire [AXI_DATA_WIDTH - 1:0] instr_slave_r_data;
	output wire [1:0] instr_slave_r_resp;
	output wire instr_slave_r_last;
	output wire [AXI_ID_SLAVE_WIDTH - 1:0] instr_slave_r_id;
	output wire [AXI_USER_WIDTH - 1:0] instr_slave_r_user;
	input wire instr_slave_r_ready;
	output wire instr_slave_r_valid;
	output wire [1:0] instr_slave_b_resp;
	output wire [AXI_ID_SLAVE_WIDTH - 1:0] instr_slave_b_id;
	output wire [AXI_USER_WIDTH - 1:0] instr_slave_b_user;
	input wire instr_slave_b_ready;
	output wire instr_slave_b_valid;
	input wire debug_req;
	output wire debug_gnt;
	output wire debug_rvalid;
	input wire [15-1:0] debug_addr;
	input wire debug_we;
	input wire [31:0] debug_wdata;
	output wire [31:0] debug_rdata;
	input wire tck_i;
	input wire trstn_i;
	input wire tms_i;
	input wire tdi_i;
	output wire tdo_o;
	localparam INSTR_ADDR_WIDTH = $clog2(INSTR_RAM_SIZE) + 1;
	localparam DATA_ADDR_WIDTH = $clog2(DATA_RAM_SIZE);
	localparam AXI_B_WIDTH = $clog2(AXI_DATA_WIDTH / 8);
	wire core_instr_req;
	wire core_instr_gnt;
	wire core_instr_rvalid;
	wire [31:0] core_instr_addr;
	wire [31:0] core_instr_rdata;
	wire core_lsu_req;
	reg core_lsu_gnt;
	wire core_lsu_rvalid;
	wire [31:0] core_lsu_addr;
	wire core_lsu_we;
	wire [3:0] core_lsu_be;
	wire [31:0] core_lsu_rdata;
	wire [31:0] core_lsu_wdata;
	wire core_data_req;
	wire core_data_gnt;
	wire core_data_rvalid;
	wire [31:0] core_data_addr;
	wire core_data_we;
	wire [3:0] core_data_be;
	wire [31:0] core_data_rdata;
	wire [31:0] core_data_wdata;
	wire is_axi_addr;
	wire axi_mem_req;
	wire [DATA_ADDR_WIDTH - 1:0] axi_mem_addr;
	wire axi_mem_we;
	wire [(AXI_DATA_WIDTH / 8) - 1:0] axi_mem_be;
	wire [AXI_DATA_WIDTH - 1:0] axi_mem_rdata;
	wire [AXI_DATA_WIDTH - 1:0] axi_mem_wdata;
	wire axi_instr_req;
	wire [INSTR_ADDR_WIDTH - 1:0] axi_instr_addr;
	wire axi_instr_we;
	wire [(AXI_DATA_WIDTH / 8) - 1:0] axi_instr_be;
	wire [AXI_DATA_WIDTH - 1:0] axi_instr_rdata;
	wire [AXI_DATA_WIDTH - 1:0] axi_instr_wdata;
	wire instr_mem_en;
	wire [INSTR_ADDR_WIDTH - 1:0] instr_mem_addr;
	wire instr_mem_we;
	wire [(AXI_DATA_WIDTH / 8) - 1:0] instr_mem_be;
	wire [AXI_DATA_WIDTH - 1:0] instr_mem_rdata;
	wire [AXI_DATA_WIDTH - 1:0] instr_mem_wdata;
	wire data_mem_en;
	wire [DATA_ADDR_WIDTH - 1:0] data_mem_addr;
	wire data_mem_we;
	wire [(AXI_DATA_WIDTH / 8) - 1:0] data_mem_be;
	wire [AXI_DATA_WIDTH - 1:0] data_mem_rdata;
	wire [AXI_DATA_WIDTH - 1:0] data_mem_wdata;
	reg [0:0] lsu_resp_CS;
	reg [0:0] lsu_resp_NS;
	wire core_axi_req;
	wire core_axi_gnt;
	wire core_axi_rvalid;
	wire [31:0] core_axi_addr;
	wire core_axi_we;
	wire [3:0] core_axi_be;
	wire [31:0] core_axi_rdata;
	wire [31:0] core_axi_wdata;
	wire [AXI_ADDR_WIDTH - 1:0] core_master_int_aw_addr;
	wire [2:0] core_master_int_aw_prot;
	wire [3:0] core_master_int_aw_region;
	wire [7:0] core_master_int_aw_len;
	wire [2:0] core_master_int_aw_size;
	wire [1:0] core_master_int_aw_burst;
	wire core_master_int_aw_lock;
	wire [3:0] core_master_int_aw_cache;
	wire [3:0] core_master_int_aw_qos;
	wire [AXI_ID_MASTER_WIDTH - 1:0] core_master_int_aw_id;
	wire [AXI_USER_WIDTH - 1:0] core_master_int_aw_user;
	wire core_master_int_aw_ready;
	wire core_master_int_aw_valid;
	wire [AXI_ADDR_WIDTH - 1:0] core_master_int_ar_addr;
	wire [2:0] core_master_int_ar_prot;
	wire [3:0] core_master_int_ar_region;
	wire [7:0] core_master_int_ar_len;
	wire [2:0] core_master_int_ar_size;
	wire [1:0] core_master_int_ar_burst;
	wire core_master_int_ar_lock;
	wire [3:0] core_master_int_ar_cache;
	wire [3:0] core_master_int_ar_qos;
	wire [AXI_ID_MASTER_WIDTH - 1:0] core_master_int_ar_id;
	wire [AXI_USER_WIDTH - 1:0] core_master_int_ar_user;
	wire core_master_int_ar_ready;
	wire core_master_int_ar_valid;
	wire core_master_int_w_valid;
	wire [AXI_DATA_WIDTH - 1:0] core_master_int_w_data;
	wire [AXI_STRB_WIDTH - 1:0] core_master_int_w_strb;
	wire [AXI_USER_WIDTH - 1:0] core_master_int_w_user;
	wire core_master_int_w_last;
	wire core_master_int_w_ready;
	wire [AXI_DATA_WIDTH - 1:0] core_master_int_r_data;
	wire [1:0] core_master_int_r_resp;
	wire core_master_int_r_last;
	wire [AXI_ID_MASTER_WIDTH - 1:0] core_master_int_r_id;
	wire [AXI_USER_WIDTH - 1:0] core_master_int_r_user;
	wire core_master_int_r_ready;
	wire core_master_int_r_valid;
	wire [1:0] core_master_int_b_resp;
	wire [AXI_ID_MASTER_WIDTH - 1:0] core_master_int_b_id;
	wire [AXI_USER_WIDTH - 1:0] core_master_int_b_user;
	wire core_master_int_b_ready;
	wire core_master_int_b_valid;
	reg [4:0] irq_id;
	always @(*) begin
		irq_id = 1'sb0;
		begin : sv2v_autoblock_1
			reg signed [31:0] i;
			for (i = 0; i < 32; i = i + 1)
				if (irq_i[i])
					irq_id = i[4:0];
		end
	end
	generate
		if (USE_ZERO_RISCY) begin : CORE
			zeroriscy_core #(
				.N_EXT_PERF_COUNTERS(0),
				.RV32E(ZERO_RV32E),
				.RV32M(ZERO_RV32M)
			) RISCV_CORE(
				.clk_i(clk),
				.rst_ni(rst_n),
				.clock_en_i(clock_gating_i),
				.test_en_i(testmode_i),
				.boot_addr_i(boot_addr_i),
				.core_id_i(4'h0),
				.cluster_id_i(6'h00),
				.instr_addr_o(core_instr_addr),
				.instr_req_o(core_instr_req),
				.instr_rdata_i(core_instr_rdata),
				.instr_gnt_i(core_instr_gnt),
				.instr_rvalid_i(core_instr_rvalid),
				.data_addr_o(core_lsu_addr),
				.data_wdata_o(core_lsu_wdata),
				.data_we_o(core_lsu_we),
				.data_req_o(core_lsu_req),
				.data_be_o(core_lsu_be),
				.data_rdata_i(core_lsu_rdata),
				.data_gnt_i(core_lsu_gnt),
				.data_rvalid_i(core_lsu_rvalid),
				.data_err_i(1'b0),
				.irq_i(|irq_i),
				.irq_id_i(irq_id),
				.irq_ack_o(),
				.irq_id_o(),
				.debug_req_i(debug_req),
				.debug_gnt_o(debug_gnt),
				.debug_rvalid_o(debug_rvalid),
				.debug_addr_i(debug_addr),
				.debug_we_i(debug_we),
				.debug_wdata_i(debug_wdata),
				.debug_rdata_o(debug_rdata),
				.debug_halted_o(),
				.debug_halt_i(1'b0),
				.debug_resume_i(1'b0),
				.fetch_enable_i(fetch_enable_i),
				.core_busy_o(core_busy_o),
				.ext_perf_counters_i()
			);
		end
		else begin : CORE
			riscv_core #(
				.N_EXT_PERF_COUNTERS(0),
				.FPU(RISCY_RV32F),
				.SHARED_FP(0),
				.SHARED_FP_DIVSQRT(2)
			) RISCV_CORE(
				.clk_i(clk),
				.rst_ni(rst_n),
				.clock_en_i(clock_gating_i),
				.test_en_i(testmode_i),
				.boot_addr_i(boot_addr_i),
				.core_id_i(4'h0),
				.cluster_id_i(6'h00),
				.instr_addr_o(core_instr_addr),
				.instr_req_o(core_instr_req),
				.instr_rdata_i(core_instr_rdata),
				.instr_gnt_i(core_instr_gnt),
				.instr_rvalid_i(core_instr_rvalid),
				.data_addr_o(core_lsu_addr),
				.data_wdata_o(core_lsu_wdata),
				.data_we_o(core_lsu_we),
				.data_req_o(core_lsu_req),
				.data_be_o(core_lsu_be),
				.data_rdata_i(core_lsu_rdata),
				.data_gnt_i(core_lsu_gnt),
				.data_rvalid_i(core_lsu_rvalid),
				.data_err_i(1'b0),
				.irq_i(|irq_i),
				.irq_id_i(irq_id),
				.irq_ack_o(),
				.irq_id_o(),
				.irq_sec_i(1'b0),
				.sec_lvl_o(),
				.debug_req_i(debug_req),
				.debug_gnt_o(debug_gnt),
				.debug_rvalid_o(debug_rvalid),
				.debug_addr_i(debug_addr),
				.debug_we_i(debug_we),
				.debug_wdata_i(debug_wdata),
				.debug_rdata_o(debug_rdata),
				.debug_halted_o(),
				.debug_halt_i(1'b0),
				.debug_resume_i(1'b0),
				.fetch_enable_i(fetch_enable_i),
				.core_busy_o(core_busy_o),
				.apu_master_req_o(),
				.apu_master_ready_o(),
				.apu_master_gnt_i(1'b1),
				.apu_master_operands_o(),
				.apu_master_op_o(),
				.apu_master_type_o(),
				.apu_master_flags_o(),
				.apu_master_valid_i(1'sb0),
				.apu_master_result_i(1'sb0),
				.apu_master_flags_i(1'sb0),
				.ext_perf_counters_i()
			);
		end
	endgenerate
	core2axi_wrap #(
		.AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
		.AXI_DATA_WIDTH(AXI_DATA_WIDTH),
		.AXI_ID_WIDTH(AXI_ID_MASTER_WIDTH),
		.AXI_USER_WIDTH(AXI_USER_WIDTH),
		.REGISTERED_GRANT("FALSE")
	) core2axi_i(
		.clk_i(clk),
		.rst_ni(rst_n),
		.data_req_i(core_axi_req),
		.data_gnt_o(core_axi_gnt),
		.data_rvalid_o(core_axi_rvalid),
		.data_addr_i(core_axi_addr),
		.data_we_i(core_axi_we),
		.data_be_i(core_axi_be),
		.data_rdata_o(core_axi_rdata),
		.data_wdata_i(core_axi_wdata),
		.m00_aw_addr(core_master_int_aw_addr),
		.m00_aw_prot(core_master_int_aw_prot),
		.m00_aw_region(core_master_int_aw_region),
		.m00_aw_len(core_master_int_aw_len),
		.m00_aw_size(core_master_int_aw_size),
		.m00_aw_burst(core_master_int_aw_burst),
		.m00_aw_lock(core_master_int_aw_lock),
		.m00_aw_cache(core_master_int_aw_cache),
		.m00_aw_qos(core_master_int_aw_qos),
		.m00_aw_id(core_master_int_aw_id),
		.m00_aw_user(core_master_int_aw_user),
		.m00_aw_ready(core_master_int_aw_ready),
		.m00_aw_valid(core_master_int_aw_valid),
		.m00_ar_addr(core_master_int_ar_addr),
		.m00_ar_prot(core_master_int_ar_prot),
		.m00_ar_region(core_master_int_ar_region),
		.m00_ar_len(core_master_int_ar_len),
		.m00_ar_size(core_master_int_ar_size),
		.m00_ar_burst(core_master_int_ar_burst),
		.m00_ar_lock(core_master_int_ar_lock),
		.m00_ar_cache(core_master_int_ar_cache),
		.m00_ar_qos(core_master_int_ar_qos),
		.m00_ar_id(core_master_int_ar_id),
		.m00_ar_user(core_master_int_ar_user),
		.m00_ar_ready(core_master_int_ar_ready),
		.m00_ar_valid(core_master_int_ar_valid),
		.m00_w_valid(core_master_int_w_valid),
		.m00_w_data(core_master_int_w_data),
		.m00_w_strb(core_master_int_w_strb),
		.m00_w_user(core_master_int_w_user),
		.m00_w_last(core_master_int_w_last),
		.m00_w_ready(core_master_int_w_ready),
		.m00_r_data(core_master_int_r_data),
		.m00_r_resp(core_master_int_r_resp),
		.m00_r_last(core_master_int_r_last),
		.m00_r_id(core_master_int_r_id),
		.m00_r_user(core_master_int_r_user),
		.m00_r_ready(core_master_int_r_ready),
		.m00_r_valid(core_master_int_r_valid),
		.m00_b_resp(core_master_int_b_resp),
		.m00_b_id(core_master_int_b_id),
		.m00_b_user(core_master_int_b_user),
		.m00_b_ready(core_master_int_b_ready),
		.m00_b_valid(core_master_int_b_valid)
	);
	axi_slice_wrap #(
		.AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
		.AXI_DATA_WIDTH(AXI_DATA_WIDTH),
		.AXI_USER_WIDTH(AXI_USER_WIDTH),
		.AXI_ID_WIDTH(AXI_ID_MASTER_WIDTH),
		.SLICE_DEPTH(2)
	) axi_slice_core2axi(
		.clk_i(clk),
		.rst_ni(rst_n),
		.test_en_i(testmode_i),
		.s00_aw_addr(core_master_int_aw_addr),
		.s00_aw_prot(core_master_int_aw_prot),
		.s00_aw_region(core_master_int_aw_region),
		.s00_aw_len(core_master_int_aw_len),
		.s00_aw_size(core_master_int_aw_size),
		.s00_aw_burst(core_master_int_aw_burst),
		.s00_aw_lock(core_master_int_aw_lock),
		.s00_aw_cache(core_master_int_aw_cache),
		.s00_aw_qos(core_master_int_aw_qos),
		.s00_aw_id(core_master_int_aw_id),
		.s00_aw_user(core_master_int_aw_user),
		.s00_aw_ready(core_master_int_aw_ready),
		.s00_aw_valid(core_master_int_aw_valid),
		.s00_ar_addr(core_master_int_ar_addr),
		.s00_ar_prot(core_master_int_ar_prot),
		.s00_ar_region(core_master_int_ar_region),
		.s00_ar_len(core_master_int_ar_len),
		.s00_ar_size(core_master_int_ar_size),
		.s00_ar_burst(core_master_int_ar_burst),
		.s00_ar_lock(core_master_int_ar_lock),
		.s00_ar_cache(core_master_int_ar_cache),
		.s00_ar_qos(core_master_int_ar_qos),
		.s00_ar_id(core_master_int_ar_id),
		.s00_ar_user(core_master_int_ar_user),
		.s00_ar_ready(core_master_int_ar_ready),
		.s00_ar_valid(core_master_int_ar_valid),
		.s00_w_valid(core_master_int_w_valid),
		.s00_w_data(core_master_int_w_data),
		.s00_w_strb(core_master_int_w_strb),
		.s00_w_user(core_master_int_w_user),
		.s00_w_last(core_master_int_w_last),
		.s00_w_ready(core_master_int_w_ready),
		.s00_r_data(core_master_int_r_data),
		.s00_r_resp(core_master_int_r_resp),
		.s00_r_last(core_master_int_r_last),
		.s00_r_id(core_master_int_r_id),
		.s00_r_user(core_master_int_r_user),
		.s00_r_ready(core_master_int_r_ready),
		.s00_r_valid(core_master_int_r_valid),
		.s00_b_resp(core_master_int_b_resp),
		.s00_b_id(core_master_int_b_id),
		.s00_b_user(core_master_int_b_user),
		.s00_b_ready(core_master_int_b_ready),
		.s00_b_valid(core_master_int_b_valid),
		.m00_aw_addr(core_master_aw_addr),
		.m00_aw_prot(core_master_aw_prot),
		.m00_aw_region(core_master_aw_region),
		.m00_aw_len(core_master_aw_len),
		.m00_aw_size(core_master_aw_size),
		.m00_aw_burst(core_master_aw_burst),
		.m00_aw_lock(core_master_aw_lock),
		.m00_aw_cache(core_master_aw_cache),
		.m00_aw_qos(core_master_aw_qos),
		.m00_aw_id(core_master_aw_id),
		.m00_aw_user(core_master_aw_user),
		.m00_aw_ready(core_master_aw_ready),
		.m00_aw_valid(core_master_aw_valid),
		.m00_ar_addr(core_master_ar_addr),
		.m00_ar_prot(core_master_ar_prot),
		.m00_ar_region(core_master_ar_region),
		.m00_ar_len(core_master_ar_len),
		.m00_ar_size(core_master_ar_size),
		.m00_ar_burst(core_master_ar_burst),
		.m00_ar_lock(core_master_ar_lock),
		.m00_ar_cache(core_master_ar_cache),
		.m00_ar_qos(core_master_ar_qos),
		.m00_ar_id(core_master_ar_id),
		.m00_ar_user(core_master_ar_user),
		.m00_ar_ready(core_master_ar_ready),
		.m00_ar_valid(core_master_ar_valid),
		.m00_w_valid(core_master_w_valid),
		.m00_w_data(core_master_w_data),
		.m00_w_strb(core_master_w_strb),
		.m00_w_user(core_master_w_user),
		.m00_w_last(core_master_w_last),
		.m00_w_ready(core_master_w_ready),
		.m00_r_data(core_master_r_data),
		.m00_r_resp(core_master_r_resp),
		.m00_r_last(core_master_r_last),
		.m00_r_id(core_master_r_id),
		.m00_r_user(core_master_r_user),
		.m00_r_ready(core_master_r_ready),
		.m00_r_valid(core_master_r_valid),
		.m00_b_resp(core_master_b_resp),
		.m00_b_id(core_master_b_id),
		.m00_b_user(core_master_b_user),
		.m00_b_ready(core_master_b_ready),
		.m00_b_valid(core_master_b_valid)
	);
	assign is_axi_addr = core_lsu_addr[31:20] != 12'h001;
	assign core_data_req = ~is_axi_addr & core_lsu_req;
	assign core_axi_req = is_axi_addr & core_lsu_req;
	assign core_data_addr = core_lsu_addr;
	assign core_data_we = core_lsu_we;
	assign core_data_be = core_lsu_be;
	assign core_data_wdata = core_lsu_wdata;
	assign core_axi_addr = core_lsu_addr;
	assign core_axi_we = core_lsu_we;
	assign core_axi_be = core_lsu_be;
	assign core_axi_wdata = core_lsu_wdata;
	always @(posedge clk or negedge rst_n)
		if (rst_n == 1'b0)
			lsu_resp_CS <= 1'd1;
		else
			lsu_resp_CS <= lsu_resp_NS;
	always @(*) begin
		lsu_resp_NS = lsu_resp_CS;
		core_lsu_gnt = 1'b0;
		if (core_axi_req) begin
			core_lsu_gnt = core_axi_gnt;
			lsu_resp_NS = 1'd0;
		end
		else if (core_data_req) begin
			core_lsu_gnt = core_data_gnt;
			lsu_resp_NS = 1'd1;
		end
	end
	assign core_lsu_rdata = (lsu_resp_CS == 1'd0 ? core_axi_rdata : core_data_rdata);
	assign core_lsu_rvalid = core_axi_rvalid | core_data_rvalid;
	mba_instr_ram_wrap #(
		.RAM_SIZE(INSTR_RAM_SIZE),
		.DATA_WIDTH(AXI_DATA_WIDTH)
	) instr_mem(
//`ifdef USE_POWER_PINS
//	.vccd1(vccd1),	// User area 1 1.8V supply
//	.vssd1(vssd1),	// User area 1 digital ground
//`endif
		.clk(clk),
		.rst_n(rst_n),
		.en_i(instr_mem_en),
		.addr_i(instr_mem_addr),
		.wdata_i(instr_mem_wdata),
		.rdata_o(instr_mem_rdata),
		.we_i(instr_mem_we),
		.be_i(instr_mem_be),
		.bypass_en_i(testmode_i),
		// MBA START
		.mba_instr_mem_csb0_o	(mba_instr_mem_csb0_o),
		.mba_instr_mem_web0_o	(mba_instr_mem_web0_o),
		.mba_instr_mem_wmask0_o	(mba_instr_mem_wmask0_),
		.mba_instr_mem_addr0_o	(mba_instr_mem_addr0_o),
		.mba_instr_mem_din0_o	(mba_instr_mem_din0_o),
		.mba_instr_mem_dout0_i	(mba_instr_mem_dout0_i),
		.mba_instr_mem_csb1_o	(mba_instr_mem_csb1_o),
		.mba_instr_mem_addr1_o	(mba_instr_mem_addr1_o)
		// MBA END
	);
	axi_mem_if_SP_wrap #(
		.AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
		.AXI_DATA_WIDTH(AXI_DATA_WIDTH),
		.AXI_ID_WIDTH(AXI_ID_SLAVE_WIDTH),
		.AXI_USER_WIDTH(AXI_USER_WIDTH),
		.MEM_ADDR_WIDTH(INSTR_ADDR_WIDTH)
	) instr_mem_axi_if(
		.clk(clk),
		.rst_n(rst_n),
		.test_en_i(testmode_i),
		.mem_req_o(axi_instr_req),
		.mem_addr_o(axi_instr_addr),
		.mem_we_o(axi_instr_we),
		.mem_be_o(axi_instr_be),
		.mem_rdata_i(axi_instr_rdata),
		.mem_wdata_o(axi_instr_wdata),
		.aw_addr(instr_slave_aw_addr),
		.aw_prot(instr_slave_aw_prot),
		.aw_region(instr_slave_aw_region),
		.aw_len(instr_slave_aw_len),
		.aw_size(instr_slave_aw_size),
		.aw_burst(instr_slave_aw_burst),
		.aw_lock(instr_slave_aw_lock),
		.aw_cache(instr_slave_aw_cache),
		.aw_qos(instr_slave_aw_qos),
		.aw_id(instr_slave_aw_id),
		.aw_user(instr_slave_aw_user),
		.aw_ready(instr_slave_aw_ready),
		.aw_valid(instr_slave_aw_valid),
		.ar_addr(instr_slave_ar_addr),
		.ar_prot(instr_slave_ar_prot),
		.ar_region(instr_slave_ar_region),
		.ar_len(instr_slave_ar_len),
		.ar_size(instr_slave_ar_size),
		.ar_burst(instr_slave_ar_burst),
		.ar_lock(instr_slave_ar_lock),
		.ar_cache(instr_slave_ar_cache),
		.ar_qos(instr_slave_ar_qos),
		.ar_id(instr_slave_ar_id),
		.ar_user(instr_slave_ar_user),
		.ar_ready(instr_slave_ar_ready),
		.ar_valid(instr_slave_ar_valid),
		.w_valid(instr_slave_w_valid),
		.w_data(instr_slave_w_data),
		.w_strb(instr_slave_w_strb),
		.w_user(instr_slave_w_user),
		.w_last(instr_slave_w_last),
		.w_ready(instr_slave_w_ready),
		.r_data(instr_slave_r_data),
		.r_resp(instr_slave_r_resp),
		.r_last(instr_slave_r_last),
		.r_id(instr_slave_r_id),
		.r_user(instr_slave_r_user),
		.r_ready(instr_slave_r_ready),
		.r_valid(instr_slave_r_valid),
		.b_resp(instr_slave_b_resp),
		.b_id(instr_slave_b_id),
		.b_user(instr_slave_b_user),
		.b_ready(instr_slave_b_ready),
		.b_valid(instr_slave_b_valid)
	);
	ram_mux #(
		.ADDR_WIDTH(INSTR_ADDR_WIDTH),
		.IN0_WIDTH(AXI_DATA_WIDTH),
		.IN1_WIDTH(32),
		.OUT_WIDTH(AXI_DATA_WIDTH)
	) instr_ram_mux_i(
		.clk(clk),
		.rst_n(rst_n),
		.port0_req_i(axi_instr_req),
		.port0_gnt_o(),
		.port0_rvalid_o(),
		.port0_addr_i({axi_instr_addr[(INSTR_ADDR_WIDTH - AXI_B_WIDTH) - 1:0], {AXI_B_WIDTH {1'b0}}}),
		.port0_we_i(axi_instr_we),
		.port0_be_i(axi_instr_be),
		.port0_rdata_o(axi_instr_rdata),
		.port0_wdata_i(axi_instr_wdata),
		.port1_req_i(core_instr_req),
		.port1_gnt_o(core_instr_gnt),
		.port1_rvalid_o(core_instr_rvalid),
		.port1_addr_i(core_instr_addr[INSTR_ADDR_WIDTH - 1:0]),
		.port1_we_i(1'b0),
		.port1_be_i(4'sb1),
		.port1_rdata_o(core_instr_rdata),
		.port1_wdata_i({AXI_DATA_WIDTH{ 1'b0 }}),
		.ram_en_o(instr_mem_en),
		.ram_addr_o(instr_mem_addr),
		.ram_we_o(instr_mem_we),
		.ram_be_o(instr_mem_be),
		.ram_rdata_i(instr_mem_rdata),
		.ram_wdata_o(instr_mem_wdata)
	);
	mba_sp_ram_wrap #(
		.RAM_SIZE(DATA_RAM_SIZE),
		.DATA_WIDTH(AXI_DATA_WIDTH)
	) data_mem(
	//`ifdef USE_POWER_PINS
    //    .vccd1(vccd1),	// User area 1 1.8V supply
    //    .vssd1(vssd1),	// User area 1 digital ground
    //`endif
		.clk(clk),
		.rstn_i(rst_n),
		.en_i(data_mem_en),
		.addr_i(data_mem_addr),
		.wdata_i(data_mem_wdata),
		.rdata_o(data_mem_rdata),
		.we_i(data_mem_we),
		.be_i(data_mem_be),
		.bypass_en_i(testmode_i),
		// MBA START
		.mba_mem_csb0_o		(mba_data_mem_csb0_o),
		.mba_mem_web0_o		(mba_data_mem_web0_o),
		.mba_mem_wmask0_o	(mba_data_mem_wmask0_),
		.mba_mem_addr0_o	(mba_data_mem_addr0_o),
		.mba_mem_din0_o		(mba_data_mem_din0_o),
		.mba_mem_dout0_i	(mba_data_mem_dout0_i),
		.mba_mem_csb1_o		(mba_data_mem_csb1_o),
		.mba_mem_addr1_o	(mba_data_mem_addr1_o)
		// MBA END
	);
	axi_mem_if_SP_wrap #(
		.AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
		.AXI_DATA_WIDTH(AXI_DATA_WIDTH),
		.AXI_ID_WIDTH(AXI_ID_SLAVE_WIDTH),
		.AXI_USER_WIDTH(AXI_USER_WIDTH),
		.MEM_ADDR_WIDTH(DATA_ADDR_WIDTH)
	) data_mem_axi_if(
		.clk(clk),
		.rst_n(rst_n),
		.test_en_i(testmode_i),
		.mem_req_o(axi_mem_req),
		.mem_addr_o(axi_mem_addr),
		.mem_we_o(axi_mem_we),
		.mem_be_o(axi_mem_be),
		.mem_rdata_i(axi_mem_rdata),
		.mem_wdata_o(axi_mem_wdata),
		.aw_addr(data_slave_aw_addr),
		.aw_prot(data_slave_aw_prot),
		.aw_region(data_slave_aw_region),
		.aw_len(data_slave_aw_len),
		.aw_size(data_slave_aw_size),
		.aw_burst(data_slave_aw_burst),
		.aw_lock(data_slave_aw_lock),
		.aw_cache(data_slave_aw_cache),
		.aw_qos(data_slave_aw_qos),
		.aw_id(data_slave_aw_id),
		.aw_user(data_slave_aw_user),
		.aw_ready(data_slave_aw_ready),
		.aw_valid(data_slave_aw_valid),
		.ar_addr(data_slave_ar_addr),
		.ar_prot(data_slave_ar_prot),
		.ar_region(data_slave_ar_region),
		.ar_len(data_slave_ar_len),
		.ar_size(data_slave_ar_size),
		.ar_burst(data_slave_ar_burst),
		.ar_lock(data_slave_ar_lock),
		.ar_cache(data_slave_ar_cache),
		.ar_qos(data_slave_ar_qos),
		.ar_id(data_slave_ar_id),
		.ar_user(data_slave_ar_user),
		.ar_ready(data_slave_ar_ready),
		.ar_valid(data_slave_ar_valid),
		.w_valid(data_slave_w_valid),
		.w_data(data_slave_w_data),
		.w_strb(data_slave_w_strb),
		.w_user(data_slave_w_user),
		.w_last(data_slave_w_last),
		.w_ready(data_slave_w_ready),
		.r_data(data_slave_r_data),
		.r_resp(data_slave_r_resp),
		.r_last(data_slave_r_last),
		.r_id(data_slave_r_id),
		.r_user(data_slave_r_user),
		.r_ready(data_slave_r_ready),
		.r_valid(data_slave_r_valid),
		.b_resp(data_slave_b_resp),
		.b_id(data_slave_b_id),
		.b_user(data_slave_b_user),
		.b_ready(data_slave_b_ready),
		.b_valid(data_slave_b_valid)
	);
	ram_mux #(
		.ADDR_WIDTH(DATA_ADDR_WIDTH),
		.IN0_WIDTH(AXI_DATA_WIDTH),
		.IN1_WIDTH(32),
		.OUT_WIDTH(AXI_DATA_WIDTH)
	) data_ram_mux_i(
		.clk(clk),
		.rst_n(rst_n),
		.port0_req_i(axi_mem_req),
		.port0_gnt_o(),
		.port0_rvalid_o(),
		.port0_addr_i({axi_mem_addr[(DATA_ADDR_WIDTH - AXI_B_WIDTH) - 1:0], {AXI_B_WIDTH {1'b0}}}),
		.port0_we_i(axi_mem_we),
		.port0_be_i(axi_mem_be),
		.port0_rdata_o(axi_mem_rdata),
		.port0_wdata_i(axi_mem_wdata),
		.port1_req_i(core_data_req),
		.port1_gnt_o(core_data_gnt),
		.port1_rvalid_o(core_data_rvalid),
		.port1_addr_i(core_data_addr[DATA_ADDR_WIDTH - 1:0]),
		.port1_we_i(core_data_we),
		.port1_be_i(core_data_be),
		.port1_rdata_o(core_data_rdata),
		.port1_wdata_i(core_data_wdata),
		.ram_en_o(data_mem_en),
		.ram_addr_o(data_mem_addr),
		.ram_we_o(data_mem_we),
		.ram_be_o(data_mem_be),
		.ram_rdata_i(data_mem_rdata),
		.ram_wdata_o(data_mem_wdata)
	);
	adv_dbg_if #(
		.NB_CORES(1),
		.AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
		.AXI_DATA_WIDTH(AXI_DATA_WIDTH),
		.AXI_USER_WIDTH(AXI_USER_WIDTH),
		.AXI_ID_WIDTH(AXI_ID_MASTER_WIDTH)
	) adv_dbg_if_i(
		.tms_pad_i(tms_i),
		.tck_pad_i(tck_i),
		.trstn_pad_i(trstn_i),
		.tdi_pad_i(tdi_i),
		.tdo_pad_o(tdo_o),
		.test_mode_i(testmode_i),
		.cpu_addr_o(),
		.cpu_data_i(32'sb0),
		.cpu_data_o(),
		.cpu_bp_i(1'sb0),
		.cpu_stall_o(),
		.cpu_stb_o(),
		.cpu_we_o(),
		.cpu_ack_i(1'sb1),
		.cpu_rst_o(),
		.axi_aclk(clk),
		.axi_aresetn(rst_n),
		.axi_master_aw_valid(dbg_master_aw_valid),
		.axi_master_aw_addr(dbg_master_aw_addr),
		.axi_master_aw_prot(dbg_master_aw_prot),
		.axi_master_aw_region(dbg_master_aw_region),
		.axi_master_aw_len(dbg_master_aw_len),
		.axi_master_aw_size(dbg_master_aw_size),
		.axi_master_aw_burst(dbg_master_aw_burst),
		.axi_master_aw_lock(dbg_master_aw_lock),
		.axi_master_aw_cache(dbg_master_aw_cache),
		.axi_master_aw_qos(dbg_master_aw_qos),
		.axi_master_aw_id(dbg_master_aw_id),
		.axi_master_aw_user(dbg_master_aw_user),
		.axi_master_aw_ready(dbg_master_aw_ready),
		.axi_master_ar_valid(dbg_master_ar_valid),
		.axi_master_ar_addr(dbg_master_ar_addr),
		.axi_master_ar_prot(dbg_master_ar_prot),
		.axi_master_ar_region(dbg_master_ar_region),
		.axi_master_ar_len(dbg_master_ar_len),
		.axi_master_ar_size(dbg_master_ar_size),
		.axi_master_ar_burst(dbg_master_ar_burst),
		.axi_master_ar_lock(dbg_master_ar_lock),
		.axi_master_ar_cache(dbg_master_ar_cache),
		.axi_master_ar_qos(dbg_master_ar_qos),
		.axi_master_ar_id(dbg_master_ar_id),
		.axi_master_ar_user(dbg_master_ar_user),
		.axi_master_ar_ready(dbg_master_ar_ready),
		.axi_master_w_valid(dbg_master_w_valid),
		.axi_master_w_data(dbg_master_w_data),
		.axi_master_w_strb(dbg_master_w_strb),
		.axi_master_w_user(dbg_master_w_user),
		.axi_master_w_last(dbg_master_w_last),
		.axi_master_w_ready(dbg_master_w_ready),
		.axi_master_r_valid(dbg_master_r_valid),
		.axi_master_r_data(dbg_master_r_data),
		.axi_master_r_resp(dbg_master_r_resp),
		.axi_master_r_last(dbg_master_r_last),
		.axi_master_r_id(dbg_master_r_id),
		.axi_master_r_user(dbg_master_r_user),
		.axi_master_r_ready(dbg_master_r_ready),
		.axi_master_b_valid(dbg_master_b_valid),
		.axi_master_b_resp(dbg_master_b_resp),
		.axi_master_b_id(dbg_master_b_id),
		.axi_master_b_user(dbg_master_b_user),
		.axi_master_b_ready(dbg_master_b_ready)
	);
endmodule
