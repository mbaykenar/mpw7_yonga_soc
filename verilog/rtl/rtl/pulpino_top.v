`define AXI_ADDR_WIDTH         32
`define AXI_DATA_WIDTH         32
`define AXI_ID_MASTER_WIDTH     2
`define AXI_ID_SLAVE_WIDTH      4
`define AXI_USER_WIDTH          1
`define USE_POWER_PINS          1


module pulpino_top 
#(
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
	clk_sel_i,
	clk_standalone_i,
	testmode_i,
	fetch_enable_i,
	scan_enable_i,
	spi_clk_i,
	spi_cs_i,
	spi_mode_o,
	spi_sdo0_o,
	spi_sdo1_o,
	spi_sdo2_o,
	spi_sdo3_o,
	spi_sdi0_i,
	spi_sdi1_i,
	spi_sdi2_i,
	spi_sdi3_i,
	spi_master_clk_o,
	spi_master_csn0_o,
	spi_master_csn1_o,
	spi_master_csn2_o,
	spi_master_csn3_o,
	spi_master_mode_o,
	spi_master_sdo0_o,
	spi_master_sdo1_o,
	spi_master_sdo2_o,
	spi_master_sdo3_o,
	spi_master_sdi0_i,
	spi_master_sdi1_i,
	spi_master_sdi2_i,
	spi_master_sdi3_i,
	scl_pad_i,
	scl_pad_o,
	scl_padoen_o,
	sda_pad_i,
	sda_pad_o,
	sda_padoen_o,
	uart_tx,
	uart_rx,
	uart_rts,
	uart_dtr,
	uart_cts,
	uart_dsr,
	gpio_in,
	gpio_out,
	gpio_dir,
	gpio_padcfg,
	tck_i,
	trstn_i,
	tms_i,
	tdi_i,
	tdo_o,
	pad_cfg_o,
	pad_mux_o
);
//parameter AXI_ADDR_WIDTH = 32;
//parameter AXI_DATA_WIDTH = 64;
//parameter AXI_ID_WIDTH   = 10;
//parameter AXI_USER_WIDTH = 6;
	//parameter USE_ZERO_RISCY = 1;
	//parameter RISCY_RV32F = 0;
	//parameter ZERO_RV32M = 1;
	//parameter ZERO_RV32E = 0;
	parameter AXI_STRB_WIDTH = `AXI_DATA_WIDTH/8;
	parameter ADDR_WIDTH = 15;
	input wire clk;
	inout wire vccd1;
	inout wire vssd1;
	input wire rst_n;
	input wire clk_sel_i;
	input wire clk_standalone_i;
	input wire testmode_i;
	input wire fetch_enable_i;
	input wire scan_enable_i;
	input wire spi_clk_i;
	input wire spi_cs_i;
	output wire [1:0] spi_mode_o;
	output wire spi_sdo0_o;
	output wire spi_sdo1_o;
	output wire spi_sdo2_o;
	output wire spi_sdo3_o;
	input wire spi_sdi0_i;
	input wire spi_sdi1_i;
	input wire spi_sdi2_i;
	input wire spi_sdi3_i;
	output wire spi_master_clk_o;
	output wire spi_master_csn0_o;
	output wire spi_master_csn1_o;
	output wire spi_master_csn2_o;
	output wire spi_master_csn3_o;
	output wire [1:0] spi_master_mode_o;
	output wire spi_master_sdo0_o;
	output wire spi_master_sdo1_o;
	output wire spi_master_sdo2_o;
	output wire spi_master_sdo3_o;
	input wire spi_master_sdi0_i;
	input wire spi_master_sdi1_i;
	input wire spi_master_sdi2_i;
	input wire spi_master_sdi3_i;
	input wire scl_pad_i;
	output wire scl_pad_o;
	output wire scl_padoen_o;
	input wire sda_pad_i;
	output wire sda_pad_o;
	output wire sda_padoen_o;
	output wire uart_tx;
	input wire uart_rx;
	output wire uart_rts;
	output wire uart_dtr;
	input wire uart_cts;
	input wire uart_dsr;
	input wire [31:0] gpio_in;
	output wire [31:0] gpio_out;
	output wire [31:0] gpio_dir;
	output wire [191:0] gpio_padcfg;
	input wire tck_i;
	input wire trstn_i;
	input wire tms_i;
	input wire tdi_i;
	output wire tdo_o;
	output wire [191:0] pad_cfg_o;
	output wire [31:0] pad_mux_o;
	wire clk_int;
	wire fetch_enable_int;
	wire core_busy_int;
	wire clk_gate_core_int;
	wire [31:0] irq_to_core_int;
	wire lock_fll_int;
	wire cfgreq_fll_int;
	wire cfgack_fll_int;
	wire [1:0] cfgad_fll_int;
	wire [31:0] cfgd_fll_int;
	wire [31:0] cfgq_fll_int;
	wire cfgweb_n_fll_int;
	wire rstn_int;
	wire [31:0] boot_addr_int;
	wire [`AXI_ADDR_WIDTH - 1:0] slaves_00_aw_addr;
	wire [2:0] slaves_00_aw_prot;
	wire [3:0] slaves_00_aw_region;
	wire [7:0] slaves_00_aw_len;
	wire [2:0] slaves_00_aw_size;
	wire [1:0] slaves_00_aw_burst;
	wire slaves_00_aw_lock;
	wire [3:0] slaves_00_aw_cache;
	wire [3:0] slaves_00_aw_qos;
	wire [`AXI_ID_SLAVE_WIDTH - 1:0] slaves_00_aw_id;
	wire [`AXI_USER_WIDTH - 1:0] slaves_00_aw_user;
	wire slaves_00_aw_ready;
	wire slaves_00_aw_valid;
	wire [`AXI_ADDR_WIDTH - 1:0] slaves_00_ar_addr;
	wire [2:0] slaves_00_ar_prot;
	wire [3:0] slaves_00_ar_region;
	wire [7:0] slaves_00_ar_len;
	wire [2:0] slaves_00_ar_size;
	wire [1:0] slaves_00_ar_burst;
	wire slaves_00_ar_lock;
	wire [3:0] slaves_00_ar_cache;
	wire [3:0] slaves_00_ar_qos;
	wire [`AXI_ID_SLAVE_WIDTH - 1:0] slaves_00_ar_id;
	wire [`AXI_USER_WIDTH - 1:0] slaves_00_ar_user;
	wire slaves_00_ar_ready;
	wire slaves_00_ar_valid;
	wire slaves_00_w_valid;
	wire [`AXI_DATA_WIDTH - 1:0] slaves_00_w_data;
	wire [AXI_STRB_WIDTH - 1:0] slaves_00_w_strb;
	wire [`AXI_USER_WIDTH - 1:0] slaves_00_w_user;
	wire slaves_00_w_last;
	wire slaves_00_w_ready;
	wire [`AXI_DATA_WIDTH - 1:0] slaves_00_r_data;
	wire [1:0] slaves_00_r_resp;
	wire slaves_00_r_last;
	wire [`AXI_ID_SLAVE_WIDTH - 1:0] slaves_00_r_id;
	wire [`AXI_USER_WIDTH - 1:0] slaves_00_r_user;
	wire slaves_00_r_ready;
	wire slaves_00_r_valid;
	wire [1:0] slaves_00_b_resp;
	wire [`AXI_ID_SLAVE_WIDTH - 1:0] slaves_00_b_id;
	wire [`AXI_USER_WIDTH - 1:0] slaves_00_b_user;
	wire slaves_00_b_ready;
	wire slaves_00_b_valid;
	wire [`AXI_ADDR_WIDTH - 1:0] slaves_01_aw_addr;
	wire [2:0] slaves_01_aw_prot;
	wire [3:0] slaves_01_aw_region;
	wire [7:0] slaves_01_aw_len;
	wire [2:0] slaves_01_aw_size;
	wire [1:0] slaves_01_aw_burst;
	wire slaves_01_aw_lock;
	wire [3:0] slaves_01_aw_cache;
	wire [3:0] slaves_01_aw_qos;
	wire [`AXI_ID_SLAVE_WIDTH - 1:0] slaves_01_aw_id;
	wire [`AXI_USER_WIDTH - 1:0] slaves_01_aw_user;
	wire slaves_01_aw_ready;
	wire slaves_01_aw_valid;
	wire [`AXI_ADDR_WIDTH - 1:0] slaves_01_ar_addr;
	wire [2:0] slaves_01_ar_prot;
	wire [3:0] slaves_01_ar_region;
	wire [7:0] slaves_01_ar_len;
	wire [2:0] slaves_01_ar_size;
	wire [1:0] slaves_01_ar_burst;
	wire slaves_01_ar_lock;
	wire [3:0] slaves_01_ar_cache;
	wire [3:0] slaves_01_ar_qos;
	wire [`AXI_ID_SLAVE_WIDTH - 1:0] slaves_01_ar_id;
	wire [`AXI_USER_WIDTH - 1:0] slaves_01_ar_user;
	wire slaves_01_ar_ready;
	wire slaves_01_ar_valid;
	wire slaves_01_w_valid;
	wire [`AXI_DATA_WIDTH - 1:0] slaves_01_w_data;
	wire [AXI_STRB_WIDTH - 1:0] slaves_01_w_strb;
	wire [`AXI_USER_WIDTH - 1:0] slaves_01_w_user;
	wire slaves_01_w_last;
	wire slaves_01_w_ready;
	wire [`AXI_DATA_WIDTH - 1:0] slaves_01_r_data;
	wire [1:0] slaves_01_r_resp;
	wire slaves_01_r_last;
	wire [`AXI_ID_SLAVE_WIDTH - 1:0] slaves_01_r_id;
	wire [`AXI_USER_WIDTH - 1:0] slaves_01_r_user;
	wire slaves_01_r_ready;
	wire slaves_01_r_valid;
	wire [1:0] slaves_01_b_resp;
	wire [`AXI_ID_SLAVE_WIDTH - 1:0] slaves_01_b_id;
	wire [`AXI_USER_WIDTH - 1:0] slaves_01_b_user;
	wire slaves_01_b_ready;
	wire slaves_01_b_valid;
	wire [`AXI_ADDR_WIDTH - 1:0] slaves_02_aw_addr;
	wire [2:0] slaves_02_aw_prot;
	wire [3:0] slaves_02_aw_region;
	wire [7:0] slaves_02_aw_len;
	wire [2:0] slaves_02_aw_size;
	wire [1:0] slaves_02_aw_burst;
	wire slaves_02_aw_lock;
	wire [3:0] slaves_02_aw_cache;
	wire [3:0] slaves_02_aw_qos;
	wire [`AXI_ID_SLAVE_WIDTH - 1:0] slaves_02_aw_id;
	wire [`AXI_USER_WIDTH - 1:0] slaves_02_aw_user;
	wire slaves_02_aw_ready;
	wire slaves_02_aw_valid;
	wire [`AXI_ADDR_WIDTH - 1:0] slaves_02_ar_addr;
	wire [2:0] slaves_02_ar_prot;
	wire [3:0] slaves_02_ar_region;
	wire [7:0] slaves_02_ar_len;
	wire [2:0] slaves_02_ar_size;
	wire [1:0] slaves_02_ar_burst;
	wire slaves_02_ar_lock;
	wire [3:0] slaves_02_ar_cache;
	wire [3:0] slaves_02_ar_qos;
	wire [`AXI_ID_SLAVE_WIDTH - 1:0] slaves_02_ar_id;
	wire [`AXI_USER_WIDTH - 1:0] slaves_02_ar_user;
	wire slaves_02_ar_ready;
	wire slaves_02_ar_valid;
	wire slaves_02_w_valid;
	wire [`AXI_DATA_WIDTH - 1:0] slaves_02_w_data;
	wire [AXI_STRB_WIDTH - 1:0] slaves_02_w_strb;
	wire [`AXI_USER_WIDTH - 1:0] slaves_02_w_user;
	wire slaves_02_w_last;
	wire slaves_02_w_ready;
	wire [`AXI_DATA_WIDTH - 1:0] slaves_02_r_data;
	wire [1:0] slaves_02_r_resp;
	wire slaves_02_r_last;
	wire [`AXI_ID_SLAVE_WIDTH - 1:0] slaves_02_r_id;
	wire [`AXI_USER_WIDTH - 1:0] slaves_02_r_user;
	wire slaves_02_r_ready;
	wire slaves_02_r_valid;
	wire [1:0] slaves_02_b_resp;
	wire [`AXI_ID_SLAVE_WIDTH - 1:0] slaves_02_b_id;
	wire [`AXI_USER_WIDTH - 1:0] slaves_02_b_user;
	wire slaves_02_b_ready;
	wire slaves_02_b_valid;
	wire [`AXI_ADDR_WIDTH - 1:0] masters_00_aw_addr;
	wire [2:0] masters_00_aw_prot;
	wire [3:0] masters_00_aw_region;
	wire [7:0] masters_00_aw_len;
	wire [2:0] masters_00_aw_size;
	wire [1:0] masters_00_aw_burst;
	wire masters_00_aw_lock;
	wire [3:0] masters_00_aw_cache;
	wire [3:0] masters_00_aw_qos;
	wire [`AXI_ID_MASTER_WIDTH - 1:0] masters_00_aw_id;
	wire [`AXI_USER_WIDTH - 1:0] masters_00_aw_user;
	wire masters_00_aw_ready;
	wire masters_00_aw_valid;
	wire [`AXI_ADDR_WIDTH - 1:0] masters_00_ar_addr;
	wire [2:0] masters_00_ar_prot;
	wire [3:0] masters_00_ar_region;
	wire [7:0] masters_00_ar_len;
	wire [2:0] masters_00_ar_size;
	wire [1:0] masters_00_ar_burst;
	wire masters_00_ar_lock;
	wire [3:0] masters_00_ar_cache;
	wire [3:0] masters_00_ar_qos;
	wire [`AXI_ID_MASTER_WIDTH - 1:0] masters_00_ar_id;
	wire [`AXI_USER_WIDTH - 1:0] masters_00_ar_user;
	wire masters_00_ar_ready;
	wire masters_00_ar_valid;
	wire masters_00_w_valid;
	wire [`AXI_DATA_WIDTH - 1:0] masters_00_w_data;
	wire [AXI_STRB_WIDTH - 1:0] masters_00_w_strb;
	wire [`AXI_USER_WIDTH - 1:0] masters_00_w_user;
	wire masters_00_w_last;
	wire masters_00_w_ready;
	wire [`AXI_DATA_WIDTH - 1:0] masters_00_r_data;
	wire [1:0] masters_00_r_resp;
	wire masters_00_r_last;
	wire [`AXI_ID_MASTER_WIDTH - 1:0] masters_00_r_id;
	wire [`AXI_USER_WIDTH - 1:0] masters_00_r_user;
	wire masters_00_r_ready;
	wire masters_00_r_valid;
	wire [1:0] masters_00_b_resp;
	wire [`AXI_ID_MASTER_WIDTH - 1:0] masters_00_b_id;
	wire [`AXI_USER_WIDTH - 1:0] masters_00_b_user;
	wire masters_00_b_ready;
	wire masters_00_b_valid;
	wire [`AXI_ADDR_WIDTH - 1:0] masters_01_aw_addr;
	wire [2:0] masters_01_aw_prot;
	wire [3:0] masters_01_aw_region;
	wire [7:0] masters_01_aw_len;
	wire [2:0] masters_01_aw_size;
	wire [1:0] masters_01_aw_burst;
	wire masters_01_aw_lock;
	wire [3:0] masters_01_aw_cache;
	wire [3:0] masters_01_aw_qos;
	wire [`AXI_ID_MASTER_WIDTH - 1:0] masters_01_aw_id;
	wire [`AXI_USER_WIDTH - 1:0] masters_01_aw_user;
	wire masters_01_aw_ready;
	wire masters_01_aw_valid;
	wire [`AXI_ADDR_WIDTH - 1:0] masters_01_ar_addr;
	wire [2:0] masters_01_ar_prot;
	wire [3:0] masters_01_ar_region;
	wire [7:0] masters_01_ar_len;
	wire [2:0] masters_01_ar_size;
	wire [1:0] masters_01_ar_burst;
	wire masters_01_ar_lock;
	wire [3:0] masters_01_ar_cache;
	wire [3:0] masters_01_ar_qos;
	wire [`AXI_ID_MASTER_WIDTH - 1:0] masters_01_ar_id;
	wire [`AXI_USER_WIDTH - 1:0] masters_01_ar_user;
	wire masters_01_ar_ready;
	wire masters_01_ar_valid;
	wire masters_01_w_valid;
	wire [`AXI_DATA_WIDTH - 1:0] masters_01_w_data;
	wire [AXI_STRB_WIDTH - 1:0] masters_01_w_strb;
	wire [`AXI_USER_WIDTH - 1:0] masters_01_w_user;
	wire masters_01_w_last;
	wire masters_01_w_ready;
	wire [`AXI_DATA_WIDTH - 1:0] masters_01_r_data;
	wire [1:0] masters_01_r_resp;
	wire masters_01_r_last;
	wire [`AXI_ID_MASTER_WIDTH - 1:0] masters_01_r_id;
	wire [`AXI_USER_WIDTH - 1:0] masters_01_r_user;
	wire masters_01_r_ready;
	wire masters_01_r_valid;
	wire [1:0] masters_01_b_resp;
	wire [`AXI_ID_MASTER_WIDTH - 1:0] masters_01_b_id;
	wire [`AXI_USER_WIDTH - 1:0] masters_01_b_user;
	wire masters_01_b_ready;
	wire masters_01_b_valid;
	wire [`AXI_ADDR_WIDTH - 1:0] masters_02_aw_addr;
	wire [2:0] masters_02_aw_prot;
	wire [3:0] masters_02_aw_region;
	wire [7:0] masters_02_aw_len;
	wire [2:0] masters_02_aw_size;
	wire [1:0] masters_02_aw_burst;
	wire masters_02_aw_lock;
	wire [3:0] masters_02_aw_cache;
	wire [3:0] masters_02_aw_qos;
	wire [`AXI_ID_MASTER_WIDTH - 1:0] masters_02_aw_id;
	wire [`AXI_USER_WIDTH - 1:0] masters_02_aw_user;
	wire masters_02_aw_ready;
	wire masters_02_aw_valid;
	wire [`AXI_ADDR_WIDTH - 1:0] masters_02_ar_addr;
	wire [2:0] masters_02_ar_prot;
	wire [3:0] masters_02_ar_region;
	wire [7:0] masters_02_ar_len;
	wire [2:0] masters_02_ar_size;
	wire [1:0] masters_02_ar_burst;
	wire masters_02_ar_lock;
	wire [3:0] masters_02_ar_cache;
	wire [3:0] masters_02_ar_qos;
	wire [`AXI_ID_MASTER_WIDTH - 1:0] masters_02_ar_id;
	wire [`AXI_USER_WIDTH - 1:0] masters_02_ar_user;
	wire masters_02_ar_ready;
	wire masters_02_ar_valid;
	wire masters_02_w_valid;
	wire [`AXI_DATA_WIDTH - 1:0] masters_02_w_data;
	wire [AXI_STRB_WIDTH - 1:0] masters_02_w_strb;
	wire [`AXI_USER_WIDTH - 1:0] masters_02_w_user;
	wire masters_02_w_last;
	wire masters_02_w_ready;
	wire [`AXI_DATA_WIDTH - 1:0] masters_02_r_data;
	wire [1:0] masters_02_r_resp;
	wire masters_02_r_last;
	wire [`AXI_ID_MASTER_WIDTH - 1:0] masters_02_r_id;
	wire [`AXI_USER_WIDTH - 1:0] masters_02_r_user;
	wire masters_02_r_ready;
	wire masters_02_r_valid;
	wire [1:0] masters_02_b_resp;
	wire [`AXI_ID_MASTER_WIDTH - 1:0] masters_02_b_id;
	wire [`AXI_USER_WIDTH - 1:0] masters_02_b_user;
	wire masters_02_b_ready;
	wire masters_02_b_valid;
	wire debug_req;
	wire debug_gnt;
	wire debug_rvalid;
	wire [ADDR_WIDTH - 1:0] debug_addr;
	wire debug_we;
	wire [31:0] debug_wdata;
	wire [31:0] debug_rdata;
	clk_rst_gen clk_rst_gen_i(
		.clk_i(clk),
		.rstn_i(rst_n),
		.clk_sel_i(clk_sel_i),
		.clk_standalone_i(clk_standalone_i),
		.testmode_i(testmode_i),
		.scan_i(1'b0),
		.scan_o(),
		.scan_en_i(scan_enable_i),
		.fll_req_i(cfgreq_fll_int),
		.fll_wrn_i(cfgweb_n_fll_int),
		.fll_add_i(cfgad_fll_int),
		.fll_data_i(cfgd_fll_int),
		.fll_ack_o(cfgack_fll_int),
		.fll_r_data_o(cfgq_fll_int),
		.fll_lock_o(lock_fll_int),
		.clk_o(clk_int),
		.rstn_o(rstn_int)
	);
	core_region #(
		.AXI_ADDR_WIDTH       (`AXI_ADDR_WIDTH     ),
		.AXI_DATA_WIDTH       (`AXI_DATA_WIDTH     ),
		.AXI_ID_MASTER_WIDTH  (`AXI_ID_MASTER_WIDTH),
		.AXI_ID_SLAVE_WIDTH   (`AXI_ID_SLAVE_WIDTH ),
		.AXI_USER_WIDTH       (`AXI_USER_WIDTH     ),
		.USE_ZERO_RISCY       ( USE_ZERO_RISCY     ),
		.RISCY_RV32F          ( RISCY_RV32F        ),
		.ZERO_RV32M           ( ZERO_RV32M         ),
		.ZERO_RV32E           ( ZERO_RV32E         )
	) core_region_i(
	`ifdef USE_POWER_PINS
		.vccd1(vccd1),	// User area 1 1.8V supply
		.vssd1(vssd1),	// User area 1 digital ground
	`endif
		.clk(clk_int),
		.rst_n(rstn_int),
		.testmode_i(testmode_i),
		.fetch_enable_i(fetch_enable_int),
		.irq_i(irq_to_core_int),
		.core_busy_o(core_busy_int),
		.clock_gating_i(clk_gate_core_int),
		.boot_addr_i(boot_addr_int),
		.core_master_aw_addr(masters_00_aw_addr),
		.core_master_aw_prot(masters_00_aw_prot),
		.core_master_aw_region(masters_00_aw_region),
		.core_master_aw_len(masters_00_aw_len),
		.core_master_aw_size(masters_00_aw_size),
		.core_master_aw_burst(masters_00_aw_burst),
		.core_master_aw_lock(masters_00_aw_lock),
		.core_master_aw_cache(masters_00_aw_cache),
		.core_master_aw_qos(masters_00_aw_qos),
		.core_master_aw_id(masters_00_aw_id),
		.core_master_aw_user(masters_00_aw_user),
		.core_master_aw_ready(masters_00_aw_ready),
		.core_master_aw_valid(masters_00_aw_valid),
		.core_master_ar_addr(masters_00_ar_addr),
		.core_master_ar_prot(masters_00_ar_prot),
		.core_master_ar_region(masters_00_ar_region),
		.core_master_ar_len(masters_00_ar_len),
		.core_master_ar_size(masters_00_ar_size),
		.core_master_ar_burst(masters_00_ar_burst),
		.core_master_ar_lock(masters_00_ar_lock),
		.core_master_ar_cache(masters_00_ar_cache),
		.core_master_ar_qos(masters_00_ar_qos),
		.core_master_ar_id(masters_00_ar_id),
		.core_master_ar_user(masters_00_ar_user),
		.core_master_ar_ready(masters_00_ar_ready),
		.core_master_ar_valid(masters_00_ar_valid),
		.core_master_w_valid(masters_00_w_valid),
		.core_master_w_data(masters_00_w_data),
		.core_master_w_strb(masters_00_w_strb),
		.core_master_w_user(masters_00_w_user),
		.core_master_w_last(masters_00_w_last),
		.core_master_w_ready(masters_00_w_ready),
		.core_master_r_data(masters_00_r_data),
		.core_master_r_resp(masters_00_r_resp),
		.core_master_r_last(masters_00_r_last),
		.core_master_r_id(masters_00_r_id),
		.core_master_r_user(masters_00_r_user),
		.core_master_r_ready(masters_00_r_ready),
		.core_master_r_valid(masters_00_r_valid),
		.core_master_b_resp(masters_00_b_resp),
		.core_master_b_id(masters_00_b_id),
		.core_master_b_user(masters_00_b_user),
		.core_master_b_ready(masters_00_b_ready),
		.core_master_b_valid(masters_00_b_valid),
		.dbg_master_aw_addr(masters_01_aw_addr),
		.dbg_master_aw_prot(masters_01_aw_prot),
		.dbg_master_aw_region(masters_01_aw_region),
		.dbg_master_aw_len(masters_01_aw_len),
		.dbg_master_aw_size(masters_01_aw_size),
		.dbg_master_aw_burst(masters_01_aw_burst),
		.dbg_master_aw_lock(masters_01_aw_lock),
		.dbg_master_aw_cache(masters_01_aw_cache),
		.dbg_master_aw_qos(masters_01_aw_qos),
		.dbg_master_aw_id(masters_01_aw_id),
		.dbg_master_aw_user(masters_01_aw_user),
		.dbg_master_aw_ready(masters_01_aw_ready),
		.dbg_master_aw_valid(masters_01_aw_valid),
		.dbg_master_ar_addr(masters_01_ar_addr),
		.dbg_master_ar_prot(masters_01_ar_prot),
		.dbg_master_ar_region(masters_01_ar_region),
		.dbg_master_ar_len(masters_01_ar_len),
		.dbg_master_ar_size(masters_01_ar_size),
		.dbg_master_ar_burst(masters_01_ar_burst),
		.dbg_master_ar_lock(masters_01_ar_lock),
		.dbg_master_ar_cache(masters_01_ar_cache),
		.dbg_master_ar_qos(masters_01_ar_qos),
		.dbg_master_ar_id(masters_01_ar_id),
		.dbg_master_ar_user(masters_01_ar_user),
		.dbg_master_ar_ready(masters_01_ar_ready),
		.dbg_master_ar_valid(masters_01_ar_valid),
		.dbg_master_w_valid(masters_01_w_valid),
		.dbg_master_w_data(masters_01_w_data),
		.dbg_master_w_strb(masters_01_w_strb),
		.dbg_master_w_user(masters_01_w_user),
		.dbg_master_w_last(masters_01_w_last),
		.dbg_master_w_ready(masters_01_w_ready),
		.dbg_master_r_data(masters_01_r_data),
		.dbg_master_r_resp(masters_01_r_resp),
		.dbg_master_r_last(masters_01_r_last),
		.dbg_master_r_id(masters_01_r_id),
		.dbg_master_r_user(masters_01_r_user),
		.dbg_master_r_ready(masters_01_r_ready),
		.dbg_master_r_valid(masters_01_r_valid),
		.dbg_master_b_resp(masters_01_b_resp),
		.dbg_master_b_id(masters_01_b_id),
		.dbg_master_b_user(masters_01_b_user),
		.dbg_master_b_ready(masters_01_b_ready),
		.dbg_master_b_valid(masters_01_b_valid),
		.data_slave_aw_addr(slaves_01_aw_addr),
		.data_slave_aw_prot(slaves_01_aw_prot),
		.data_slave_aw_region(slaves_01_aw_region),
		.data_slave_aw_len(slaves_01_aw_len),
		.data_slave_aw_size(slaves_01_aw_size),
		.data_slave_aw_burst(slaves_01_aw_burst),
		.data_slave_aw_lock(slaves_01_aw_lock),
		.data_slave_aw_cache(slaves_01_aw_cache),
		.data_slave_aw_qos(slaves_01_aw_qos),
		.data_slave_aw_id(slaves_01_aw_id),
		.data_slave_aw_user(slaves_01_aw_user),
		.data_slave_aw_ready(slaves_01_aw_ready),
		.data_slave_aw_valid(slaves_01_aw_valid),
		.data_slave_ar_addr(slaves_01_ar_addr),
		.data_slave_ar_prot(slaves_01_ar_prot),
		.data_slave_ar_region(slaves_01_ar_region),
		.data_slave_ar_len(slaves_01_ar_len),
		.data_slave_ar_size(slaves_01_ar_size),
		.data_slave_ar_burst(slaves_01_ar_burst),
		.data_slave_ar_lock(slaves_01_ar_lock),
		.data_slave_ar_cache(slaves_01_ar_cache),
		.data_slave_ar_qos(slaves_01_ar_qos),
		.data_slave_ar_id(slaves_01_ar_id),
		.data_slave_ar_user(slaves_01_ar_user),
		.data_slave_ar_ready(slaves_01_ar_ready),
		.data_slave_ar_valid(slaves_01_ar_valid),
		.data_slave_w_valid(slaves_01_w_valid),
		.data_slave_w_data(slaves_01_w_data),
		.data_slave_w_strb(slaves_01_w_strb),
		.data_slave_w_user(slaves_01_w_user),
		.data_slave_w_last(slaves_01_w_last),
		.data_slave_w_ready(slaves_01_w_ready),
		.data_slave_r_data(slaves_01_r_data),
		.data_slave_r_resp(slaves_01_r_resp),
		.data_slave_r_last(slaves_01_r_last),
		.data_slave_r_id(slaves_01_r_id),
		.data_slave_r_user(slaves_01_r_user),
		.data_slave_r_ready(slaves_01_r_ready),
		.data_slave_r_valid(slaves_01_r_valid),
		.data_slave_b_resp(slaves_01_b_resp),
		.data_slave_b_id(slaves_01_b_id),
		.data_slave_b_user(slaves_01_b_user),
		.data_slave_b_ready(slaves_01_b_ready),
		.data_slave_b_valid(slaves_01_b_valid),
		.instr_slave_aw_addr(slaves_00_aw_addr),
		.instr_slave_aw_prot(slaves_00_aw_prot),
		.instr_slave_aw_region(slaves_00_aw_region),
		.instr_slave_aw_len(slaves_00_aw_len),
		.instr_slave_aw_size(slaves_00_aw_size),
		.instr_slave_aw_burst(slaves_00_aw_burst),
		.instr_slave_aw_lock(slaves_00_aw_lock),
		.instr_slave_aw_cache(slaves_00_aw_cache),
		.instr_slave_aw_qos(slaves_00_aw_qos),
		.instr_slave_aw_id(slaves_00_aw_id),
		.instr_slave_aw_user(slaves_00_aw_user),
		.instr_slave_aw_ready(slaves_00_aw_ready),
		.instr_slave_aw_valid(slaves_00_aw_valid),
		.instr_slave_ar_addr(slaves_00_ar_addr),
		.instr_slave_ar_prot(slaves_00_ar_prot),
		.instr_slave_ar_region(slaves_00_ar_region),
		.instr_slave_ar_len(slaves_00_ar_len),
		.instr_slave_ar_size(slaves_00_ar_size),
		.instr_slave_ar_burst(slaves_00_ar_burst),
		.instr_slave_ar_lock(slaves_00_ar_lock),
		.instr_slave_ar_cache(slaves_00_ar_cache),
		.instr_slave_ar_qos(slaves_00_ar_qos),
		.instr_slave_ar_id(slaves_00_ar_id),
		.instr_slave_ar_user(slaves_00_ar_user),
		.instr_slave_ar_ready(slaves_00_ar_ready),
		.instr_slave_ar_valid(slaves_00_ar_valid),
		.instr_slave_w_valid(slaves_00_w_valid),
		.instr_slave_w_data(slaves_00_w_data),
		.instr_slave_w_strb(slaves_00_w_strb),
		.instr_slave_w_user(slaves_00_w_user),
		.instr_slave_w_last(slaves_00_w_last),
		.instr_slave_w_ready(slaves_00_w_ready),
		.instr_slave_r_data(slaves_00_r_data),
		.instr_slave_r_resp(slaves_00_r_resp),
		.instr_slave_r_last(slaves_00_r_last),
		.instr_slave_r_id(slaves_00_r_id),
		.instr_slave_r_user(slaves_00_r_user),
		.instr_slave_r_ready(slaves_00_r_ready),
		.instr_slave_r_valid(slaves_00_r_valid),
		.instr_slave_b_resp(slaves_00_b_resp),
		.instr_slave_b_id(slaves_00_b_id),
		.instr_slave_b_user(slaves_00_b_user),
		.instr_slave_b_ready(slaves_00_b_ready),
		.instr_slave_b_valid(slaves_00_b_valid),
		.debug_req(debug_req),
		.debug_gnt(debug_gnt),
		.debug_rvalid(debug_rvalid),
		.debug_addr(debug_addr),
		.debug_we(debug_we),
		.debug_wdata(debug_wdata),
		.debug_rdata(debug_rdata),
		.tck_i(tck_i),
		.trstn_i(trstn_i),
		.tms_i(tms_i),
		.tdi_i(tdi_i),
		.tdo_o(tdo_o)
	);
	peripherals #(
		.AXI_ADDR_WIDTH     (`AXI_ADDR_WIDTH     ),
		.AXI_DATA_WIDTH     (`AXI_DATA_WIDTH     ),
		.AXI_SLAVE_ID_WIDTH (`AXI_ID_SLAVE_WIDTH ),
		.AXI_MASTER_ID_WIDTH(`AXI_ID_MASTER_WIDTH),
		.AXI_USER_WIDTH     (`AXI_USER_WIDTH     )
	) peripherals_i(
		.clk_i(clk_int),
		.rst_n(rstn_int),
		.axi_spi_master_aw_addr(masters_02_aw_addr),
		.axi_spi_master_aw_prot(masters_02_aw_prot),
		.axi_spi_master_aw_region(masters_02_aw_region),
		.axi_spi_master_aw_len(masters_02_aw_len),
		.axi_spi_master_aw_size(masters_02_aw_size),
		.axi_spi_master_aw_burst(masters_02_aw_burst),
		.axi_spi_master_aw_lock(masters_02_aw_lock),
		.axi_spi_master_aw_cache(masters_02_aw_cache),
		.axi_spi_master_aw_qos(masters_02_aw_qos),
		.axi_spi_master_aw_id(masters_02_aw_id),
		.axi_spi_master_aw_user(masters_02_aw_user),
		.axi_spi_master_aw_ready(masters_02_aw_ready),
		.axi_spi_master_aw_valid(masters_02_aw_valid),
		.axi_spi_master_ar_addr(masters_02_ar_addr),
		.axi_spi_master_ar_prot(masters_02_ar_prot),
		.axi_spi_master_ar_region(masters_02_ar_region),
		.axi_spi_master_ar_len(masters_02_ar_len),
		.axi_spi_master_ar_size(masters_02_ar_size),
		.axi_spi_master_ar_burst(masters_02_ar_burst),
		.axi_spi_master_ar_lock(masters_02_ar_lock),
		.axi_spi_master_ar_cache(masters_02_ar_cache),
		.axi_spi_master_ar_qos(masters_02_ar_qos),
		.axi_spi_master_ar_id(masters_02_ar_id),
		.axi_spi_master_ar_user(masters_02_ar_user),
		.axi_spi_master_ar_ready(masters_02_ar_ready),
		.axi_spi_master_ar_valid(masters_02_ar_valid),
		.axi_spi_master_w_valid(masters_02_w_valid),
		.axi_spi_master_w_data(masters_02_w_data),
		.axi_spi_master_w_strb(masters_02_w_strb),
		.axi_spi_master_w_user(masters_02_w_user),
		.axi_spi_master_w_last(masters_02_w_last),
		.axi_spi_master_w_ready(masters_02_w_ready),
		.axi_spi_master_r_data(masters_02_r_data),
		.axi_spi_master_r_resp(masters_02_r_resp),
		.axi_spi_master_r_last(masters_02_r_last),
		.axi_spi_master_r_id(masters_02_r_id),
		.axi_spi_master_r_user(masters_02_r_user),
		.axi_spi_master_r_ready(masters_02_r_ready),
		.axi_spi_master_r_valid(masters_02_r_valid),
		.axi_spi_master_b_resp(masters_02_b_resp),
		.axi_spi_master_b_id(masters_02_b_id),
		.axi_spi_master_b_user(masters_02_b_user),
		.axi_spi_master_b_ready(masters_02_b_ready),
		.axi_spi_master_b_valid(masters_02_b_valid),
		.debug_req(debug_req),
		.debug_gnt(debug_gnt),
		.debug_rvalid(debug_rvalid),
		.debug_addr(debug_addr),
		.debug_we(debug_we),
		.debug_wdata(debug_wdata),
		.debug_rdata(debug_rdata),
		.spi_clk_i(spi_clk_i),
		.testmode_i(testmode_i),
		.spi_cs_i(spi_cs_i),
		.spi_mode_o(spi_mode_o),
		.spi_sdo0_o(spi_sdo0_o),
		.spi_sdo1_o(spi_sdo1_o),
		.spi_sdo2_o(spi_sdo2_o),
		.spi_sdo3_o(spi_sdo3_o),
		.spi_sdi0_i(spi_sdi0_i),
		.spi_sdi1_i(spi_sdi1_i),
		.spi_sdi2_i(spi_sdi2_i),
		.spi_sdi3_i(spi_sdi3_i),
		.slave_aw_addr(slaves_02_aw_addr),
		.slave_aw_prot(slaves_02_aw_prot),
		.slave_aw_region(slaves_02_aw_region),
		.slave_aw_len(slaves_02_aw_len),
		.slave_aw_size(slaves_02_aw_size),
		.slave_aw_burst(slaves_02_aw_burst),
		.slave_aw_lock(slaves_02_aw_lock),
		.slave_aw_cache(slaves_02_aw_cache),
		.slave_aw_qos(slaves_02_aw_qos),
		.slave_aw_id(slaves_02_aw_id),
		.slave_aw_user(slaves_02_aw_user),
		.slave_aw_ready(slaves_02_aw_ready),
		.slave_aw_valid(slaves_02_aw_valid),
		.slave_ar_addr(slaves_02_ar_addr),
		.slave_ar_prot(slaves_02_ar_prot),
		.slave_ar_region(slaves_02_ar_region),
		.slave_ar_len(slaves_02_ar_len),
		.slave_ar_size(slaves_02_ar_size),
		.slave_ar_burst(slaves_02_ar_burst),
		.slave_ar_lock(slaves_02_ar_lock),
		.slave_ar_cache(slaves_02_ar_cache),
		.slave_ar_qos(slaves_02_ar_qos),
		.slave_ar_id(slaves_02_ar_id),
		.slave_ar_user(slaves_02_ar_user),
		.slave_ar_ready(slaves_02_ar_ready),
		.slave_ar_valid(slaves_02_ar_valid),
		.slave_w_valid(slaves_02_w_valid),
		.slave_w_data(slaves_02_w_data),
		.slave_w_strb(slaves_02_w_strb),
		.slave_w_user(slaves_02_w_user),
		.slave_w_last(slaves_02_w_last),
		.slave_w_ready(slaves_02_w_ready),
		.slave_r_data(slaves_02_r_data),
		.slave_r_resp(slaves_02_r_resp),
		.slave_r_last(slaves_02_r_last),
		.slave_r_id(slaves_02_r_id),
		.slave_r_user(slaves_02_r_user),
		.slave_r_ready(slaves_02_r_ready),
		.slave_r_valid(slaves_02_r_valid),
		.slave_b_resp(slaves_02_b_resp),
		.slave_b_id(slaves_02_b_id),
		.slave_b_user(slaves_02_b_user),
		.slave_b_ready(slaves_02_b_ready),
		.slave_b_valid(slaves_02_b_valid),
		.uart_tx(uart_tx),
		.uart_rx(uart_rx),
		.uart_rts(uart_rts),
		.uart_dtr(uart_dtr),
		.uart_cts(uart_cts),
		.uart_dsr(uart_dsr),
		.spi_master_clk(spi_master_clk_o),
		.spi_master_csn0(spi_master_csn0_o),
		.spi_master_csn1(spi_master_csn1_o),
		.spi_master_csn2(spi_master_csn2_o),
		.spi_master_csn3(spi_master_csn3_o),
		.spi_master_mode(spi_master_mode_o),
		.spi_master_sdo0(spi_master_sdo0_o),
		.spi_master_sdo1(spi_master_sdo1_o),
		.spi_master_sdo2(spi_master_sdo2_o),
		.spi_master_sdo3(spi_master_sdo3_o),
		.spi_master_sdi0(spi_master_sdi0_i),
		.spi_master_sdi1(spi_master_sdi1_i),
		.spi_master_sdi2(spi_master_sdi2_i),
		.spi_master_sdi3(spi_master_sdi3_i),
		.scl_pad_i(scl_pad_i),
		.scl_pad_o(scl_pad_o),
		.scl_padoen_o(scl_padoen_o),
		.sda_pad_i(sda_pad_i),
		.sda_pad_o(sda_pad_o),
		.sda_padoen_o(sda_padoen_o),
		.gpio_in(gpio_in),
		.gpio_out(gpio_out),
		.gpio_dir(gpio_dir),
		.gpio_padcfg(gpio_padcfg),
		.core_busy_i(core_busy_int),
		.irq_o(irq_to_core_int),
		.fetch_enable_i(fetch_enable_i),
		.fetch_enable_o(fetch_enable_int),
		.clk_gate_core_o(clk_gate_core_int),
		.fll1_req_o(cfgreq_fll_int),
		.fll1_wrn_o(cfgweb_n_fll_int),
		.fll1_add_o(cfgad_fll_int),
		.fll1_wdata_o(cfgd_fll_int),
		.fll1_ack_i(cfgack_fll_int),
		.fll1_rdata_i(cfgq_fll_int),
		.fll1_lock_i(lock_fll_int),
		.pad_cfg_o(pad_cfg_o),
		.pad_mux_o(pad_mux_o),
		.boot_addr_o(boot_addr_int)
	);
	axi_node_intf_wrap #(
		.NB_MASTER(3),
		.NB_SLAVE(3),
		.AXI_ADDR_WIDTH(`AXI_ADDR_WIDTH     ),
		.AXI_DATA_WIDTH(`AXI_DATA_WIDTH     ),
		.AXI_ID_WIDTH  (`AXI_ID_MASTER_WIDTH),
		.AXI_USER_WIDTH(`AXI_USER_WIDTH     )
	) axi_interconnect_i(
		.clk(clk_int),
		.rst_n(rstn_int),
		.test_en_i(testmode_i),
		.m00_aw_addr(slaves_00_aw_addr),
		.m00_aw_prot(slaves_00_aw_prot),
		.m00_aw_region(slaves_00_aw_region),
		.m00_aw_len(slaves_00_aw_len),
		.m00_aw_size(slaves_00_aw_size),
		.m00_aw_burst(slaves_00_aw_burst),
		.m00_aw_lock(slaves_00_aw_lock),
		.m00_aw_cache(slaves_00_aw_cache),
		.m00_aw_qos(slaves_00_aw_qos),
		.m00_aw_id(slaves_00_aw_id),
		.m00_aw_user(slaves_00_aw_user),
		.m00_aw_ready(slaves_00_aw_ready),
		.m00_aw_valid(slaves_00_aw_valid),
		.m00_ar_addr(slaves_00_ar_addr),
		.m00_ar_prot(slaves_00_ar_prot),
		.m00_ar_region(slaves_00_ar_region),
		.m00_ar_len(slaves_00_ar_len),
		.m00_ar_size(slaves_00_ar_size),
		.m00_ar_burst(slaves_00_ar_burst),
		.m00_ar_lock(slaves_00_ar_lock),
		.m00_ar_cache(slaves_00_ar_cache),
		.m00_ar_qos(slaves_00_ar_qos),
		.m00_ar_id(slaves_00_ar_id),
		.m00_ar_user(slaves_00_ar_user),
		.m00_ar_ready(slaves_00_ar_ready),
		.m00_ar_valid(slaves_00_ar_valid),
		.m00_w_valid(slaves_00_w_valid),
		.m00_w_data(slaves_00_w_data),
		.m00_w_strb(slaves_00_w_strb),
		.m00_w_user(slaves_00_w_user),
		.m00_w_last(slaves_00_w_last),
		.m00_w_ready(slaves_00_w_ready),
		.m00_r_data(slaves_00_r_data),
		.m00_r_resp(slaves_00_r_resp),
		.m00_r_last(slaves_00_r_last),
		.m00_r_id(slaves_00_r_id),
		.m00_r_user(slaves_00_r_user),
		.m00_r_ready(slaves_00_r_ready),
		.m00_r_valid(slaves_00_r_valid),
		.m00_b_resp(slaves_00_b_resp),
		.m00_b_id(slaves_00_b_id),
		.m00_b_user(slaves_00_b_user),
		.m00_b_ready(slaves_00_b_ready),
		.m00_b_valid(slaves_00_b_valid),
		.m01_aw_addr(slaves_01_aw_addr),
		.m01_aw_prot(slaves_01_aw_prot),
		.m01_aw_region(slaves_01_aw_region),
		.m01_aw_len(slaves_01_aw_len),
		.m01_aw_size(slaves_01_aw_size),
		.m01_aw_burst(slaves_01_aw_burst),
		.m01_aw_lock(slaves_01_aw_lock),
		.m01_aw_cache(slaves_01_aw_cache),
		.m01_aw_qos(slaves_01_aw_qos),
		.m01_aw_id(slaves_01_aw_id),
		.m01_aw_user(slaves_01_aw_user),
		.m01_aw_ready(slaves_01_aw_ready),
		.m01_aw_valid(slaves_01_aw_valid),
		.m01_ar_addr(slaves_01_ar_addr),
		.m01_ar_prot(slaves_01_ar_prot),
		.m01_ar_region(slaves_01_ar_region),
		.m01_ar_len(slaves_01_ar_len),
		.m01_ar_size(slaves_01_ar_size),
		.m01_ar_burst(slaves_01_ar_burst),
		.m01_ar_lock(slaves_01_ar_lock),
		.m01_ar_cache(slaves_01_ar_cache),
		.m01_ar_qos(slaves_01_ar_qos),
		.m01_ar_id(slaves_01_ar_id),
		.m01_ar_user(slaves_01_ar_user),
		.m01_ar_ready(slaves_01_ar_ready),
		.m01_ar_valid(slaves_01_ar_valid),
		.m01_w_valid(slaves_01_w_valid),
		.m01_w_data(slaves_01_w_data),
		.m01_w_strb(slaves_01_w_strb),
		.m01_w_user(slaves_01_w_user),
		.m01_w_last(slaves_01_w_last),
		.m01_w_ready(slaves_01_w_ready),
		.m01_r_data(slaves_01_r_data),
		.m01_r_resp(slaves_01_r_resp),
		.m01_r_last(slaves_01_r_last),
		.m01_r_id(slaves_01_r_id),
		.m01_r_user(slaves_01_r_user),
		.m01_r_ready(slaves_01_r_ready),
		.m01_r_valid(slaves_01_r_valid),
		.m01_b_resp(slaves_01_b_resp),
		.m01_b_id(slaves_01_b_id),
		.m01_b_user(slaves_01_b_user),
		.m01_b_ready(slaves_01_b_ready),
		.m01_b_valid(slaves_01_b_valid),
		.m02_aw_addr(slaves_02_aw_addr),
		.m02_aw_prot(slaves_02_aw_prot),
		.m02_aw_region(slaves_02_aw_region),
		.m02_aw_len(slaves_02_aw_len),
		.m02_aw_size(slaves_02_aw_size),
		.m02_aw_burst(slaves_02_aw_burst),
		.m02_aw_lock(slaves_02_aw_lock),
		.m02_aw_cache(slaves_02_aw_cache),
		.m02_aw_qos(slaves_02_aw_qos),
		.m02_aw_id(slaves_02_aw_id),
		.m02_aw_user(slaves_02_aw_user),
		.m02_aw_ready(slaves_02_aw_ready),
		.m02_aw_valid(slaves_02_aw_valid),
		.m02_ar_addr(slaves_02_ar_addr),
		.m02_ar_prot(slaves_02_ar_prot),
		.m02_ar_region(slaves_02_ar_region),
		.m02_ar_len(slaves_02_ar_len),
		.m02_ar_size(slaves_02_ar_size),
		.m02_ar_burst(slaves_02_ar_burst),
		.m02_ar_lock(slaves_02_ar_lock),
		.m02_ar_cache(slaves_02_ar_cache),
		.m02_ar_qos(slaves_02_ar_qos),
		.m02_ar_id(slaves_02_ar_id),
		.m02_ar_user(slaves_02_ar_user),
		.m02_ar_ready(slaves_02_ar_ready),
		.m02_ar_valid(slaves_02_ar_valid),
		.m02_w_valid(slaves_02_w_valid),
		.m02_w_data(slaves_02_w_data),
		.m02_w_strb(slaves_02_w_strb),
		.m02_w_user(slaves_02_w_user),
		.m02_w_last(slaves_02_w_last),
		.m02_w_ready(slaves_02_w_ready),
		.m02_r_data(slaves_02_r_data),
		.m02_r_resp(slaves_02_r_resp),
		.m02_r_last(slaves_02_r_last),
		.m02_r_id(slaves_02_r_id),
		.m02_r_user(slaves_02_r_user),
		.m02_r_ready(slaves_02_r_ready),
		.m02_r_valid(slaves_02_r_valid),
		.m02_b_resp(slaves_02_b_resp),
		.m02_b_id(slaves_02_b_id),
		.m02_b_user(slaves_02_b_user),
		.m02_b_ready(slaves_02_b_ready),
		.m02_b_valid(slaves_02_b_valid),
		.s00_aw_addr(masters_00_aw_addr),
		.s00_aw_prot(masters_00_aw_prot),
		.s00_aw_region(masters_00_aw_region),
		.s00_aw_len(masters_00_aw_len),
		.s00_aw_size(masters_00_aw_size),
		.s00_aw_burst(masters_00_aw_burst),
		.s00_aw_lock(masters_00_aw_lock),
		.s00_aw_cache(masters_00_aw_cache),
		.s00_aw_qos(masters_00_aw_qos),
		.s00_aw_id(masters_00_aw_id),
		.s00_aw_user(masters_00_aw_user),
		.s00_aw_ready(masters_00_aw_ready),
		.s00_aw_valid(masters_00_aw_valid),
		.s00_ar_addr(masters_00_ar_addr),
		.s00_ar_prot(masters_00_ar_prot),
		.s00_ar_region(masters_00_ar_region),
		.s00_ar_len(masters_00_ar_len),
		.s00_ar_size(masters_00_ar_size),
		.s00_ar_burst(masters_00_ar_burst),
		.s00_ar_lock(masters_00_ar_lock),
		.s00_ar_cache(masters_00_ar_cache),
		.s00_ar_qos(masters_00_ar_qos),
		.s00_ar_id(masters_00_ar_id),
		.s00_ar_user(masters_00_ar_user),
		.s00_ar_ready(masters_00_ar_ready),
		.s00_ar_valid(masters_00_ar_valid),
		.s00_w_valid(masters_00_w_valid),
		.s00_w_data(masters_00_w_data),
		.s00_w_strb(masters_00_w_strb),
		.s00_w_user(masters_00_w_user),
		.s00_w_last(masters_00_w_last),
		.s00_w_ready(masters_00_w_ready),
		.s00_r_data(masters_00_r_data),
		.s00_r_resp(masters_00_r_resp),
		.s00_r_last(masters_00_r_last),
		.s00_r_id(masters_00_r_id),
		.s00_r_user(masters_00_r_user),
		.s00_r_ready(masters_00_r_ready),
		.s00_r_valid(masters_00_r_valid),
		.s00_b_resp(masters_00_b_resp),
		.s00_b_id(masters_00_b_id),
		.s00_b_user(masters_00_b_user),
		.s00_b_ready(masters_00_b_ready),
		.s00_b_valid(masters_00_b_valid),
		.s01_aw_addr(masters_01_aw_addr),
		.s01_aw_prot(masters_01_aw_prot),
		.s01_aw_region(masters_01_aw_region),
		.s01_aw_len(masters_01_aw_len),
		.s01_aw_size(masters_01_aw_size),
		.s01_aw_burst(masters_01_aw_burst),
		.s01_aw_lock(masters_01_aw_lock),
		.s01_aw_cache(masters_01_aw_cache),
		.s01_aw_qos(masters_01_aw_qos),
		.s01_aw_id(masters_01_aw_id),
		.s01_aw_user(masters_01_aw_user),
		.s01_aw_ready(masters_01_aw_ready),
		.s01_aw_valid(masters_01_aw_valid),
		.s01_ar_addr(masters_01_ar_addr),
		.s01_ar_prot(masters_01_ar_prot),
		.s01_ar_region(masters_01_ar_region),
		.s01_ar_len(masters_01_ar_len),
		.s01_ar_size(masters_01_ar_size),
		.s01_ar_burst(masters_01_ar_burst),
		.s01_ar_lock(masters_01_ar_lock),
		.s01_ar_cache(masters_01_ar_cache),
		.s01_ar_qos(masters_01_ar_qos),
		.s01_ar_id(masters_01_ar_id),
		.s01_ar_user(masters_01_ar_user),
		.s01_ar_ready(masters_01_ar_ready),
		.s01_ar_valid(masters_01_ar_valid),
		.s01_w_valid(masters_01_w_valid),
		.s01_w_data(masters_01_w_data),
		.s01_w_strb(masters_01_w_strb),
		.s01_w_user(masters_01_w_user),
		.s01_w_last(masters_01_w_last),
		.s01_w_ready(masters_01_w_ready),
		.s01_r_data(masters_01_r_data),
		.s01_r_resp(masters_01_r_resp),
		.s01_r_last(masters_01_r_last),
		.s01_r_id(masters_01_r_id),
		.s01_r_user(masters_01_r_user),
		.s01_r_ready(masters_01_r_ready),
		.s01_r_valid(masters_01_r_valid),
		.s01_b_resp(masters_01_b_resp),
		.s01_b_id(masters_01_b_id),
		.s01_b_user(masters_01_b_user),
		.s01_b_ready(masters_01_b_ready),
		.s01_b_valid(masters_01_b_valid),
		.s02_aw_addr(masters_02_aw_addr),
		.s02_aw_prot(masters_02_aw_prot),
		.s02_aw_region(masters_02_aw_region),
		.s02_aw_len(masters_02_aw_len),
		.s02_aw_size(masters_02_aw_size),
		.s02_aw_burst(masters_02_aw_burst),
		.s02_aw_lock(masters_02_aw_lock),
		.s02_aw_cache(masters_02_aw_cache),
		.s02_aw_qos(masters_02_aw_qos),
		.s02_aw_id(masters_02_aw_id),
		.s02_aw_user(masters_02_aw_user),
		.s02_aw_ready(masters_02_aw_ready),
		.s02_aw_valid(masters_02_aw_valid),
		.s02_ar_addr(masters_02_ar_addr),
		.s02_ar_prot(masters_02_ar_prot),
		.s02_ar_region(masters_02_ar_region),
		.s02_ar_len(masters_02_ar_len),
		.s02_ar_size(masters_02_ar_size),
		.s02_ar_burst(masters_02_ar_burst),
		.s02_ar_lock(masters_02_ar_lock),
		.s02_ar_cache(masters_02_ar_cache),
		.s02_ar_qos(masters_02_ar_qos),
		.s02_ar_id(masters_02_ar_id),
		.s02_ar_user(masters_02_ar_user),
		.s02_ar_ready(masters_02_ar_ready),
		.s02_ar_valid(masters_02_ar_valid),
		.s02_w_valid(masters_02_w_valid),
		.s02_w_data(masters_02_w_data),
		.s02_w_strb(masters_02_w_strb),
		.s02_w_user(masters_02_w_user),
		.s02_w_last(masters_02_w_last),
		.s02_w_ready(masters_02_w_ready),
		.s02_r_data(masters_02_r_data),
		.s02_r_resp(masters_02_r_resp),
		.s02_r_last(masters_02_r_last),
		.s02_r_id(masters_02_r_id),
		.s02_r_user(masters_02_r_user),
		.s02_r_ready(masters_02_r_ready),
		.s02_r_valid(masters_02_r_valid),
		.s02_b_resp(masters_02_b_resp),
		.s02_b_id(masters_02_b_id),
		.s02_b_user(masters_02_b_user),
		.s02_b_ready(masters_02_b_ready),
		.s02_b_valid(masters_02_b_valid),
		.start_addr_i(96'h1a1000000010000000000000),
		.end_addr_i(96'h1a11ffff001fffff000fffff)
	);
endmodule
