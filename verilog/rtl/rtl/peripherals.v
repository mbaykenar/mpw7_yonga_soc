module peripherals 
#(
    parameter AXI_ADDR_WIDTH       = 32,
    parameter AXI_DATA_WIDTH       = 64,
    parameter AXI_USER_WIDTH       = 6,
    parameter AXI_SLAVE_ID_WIDTH   = 6,
    parameter AXI_MASTER_ID_WIDTH  = 6,
    parameter ROM_START_ADDR       = 32'h8000
  )
(
	clk_i,
	rst_n,
	axi_spi_master_aw_addr,
	axi_spi_master_aw_prot,
	axi_spi_master_aw_region,
	axi_spi_master_aw_len,
	axi_spi_master_aw_size,
	axi_spi_master_aw_burst,
	axi_spi_master_aw_lock,
	axi_spi_master_aw_cache,
	axi_spi_master_aw_qos,
	axi_spi_master_aw_id,
	axi_spi_master_aw_user,
	axi_spi_master_aw_ready,
	axi_spi_master_aw_valid,
	axi_spi_master_ar_addr,
	axi_spi_master_ar_prot,
	axi_spi_master_ar_region,
	axi_spi_master_ar_len,
	axi_spi_master_ar_size,
	axi_spi_master_ar_burst,
	axi_spi_master_ar_lock,
	axi_spi_master_ar_cache,
	axi_spi_master_ar_qos,
	axi_spi_master_ar_id,
	axi_spi_master_ar_user,
	axi_spi_master_ar_ready,
	axi_spi_master_ar_valid,
	axi_spi_master_w_valid,
	axi_spi_master_w_data,
	axi_spi_master_w_strb,
	axi_spi_master_w_user,
	axi_spi_master_w_last,
	axi_spi_master_w_ready,
	axi_spi_master_r_data,
	axi_spi_master_r_resp,
	axi_spi_master_r_last,
	axi_spi_master_r_id,
	axi_spi_master_r_user,
	axi_spi_master_r_ready,
	axi_spi_master_r_valid,
	axi_spi_master_b_resp,
	axi_spi_master_b_id,
	axi_spi_master_b_user,
	axi_spi_master_b_ready,
	axi_spi_master_b_valid,
	debug_req,
	debug_gnt,
	debug_rvalid,
	debug_addr,
	debug_we,
	debug_wdata,
	debug_rdata,
	spi_clk_i,
	testmode_i,
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
	slave_aw_addr,
	slave_aw_prot,
	slave_aw_region,
	slave_aw_len,
	slave_aw_size,
	slave_aw_burst,
	slave_aw_lock,
	slave_aw_cache,
	slave_aw_qos,
	slave_aw_id,
	slave_aw_user,
	slave_aw_ready,
	slave_aw_valid,
	slave_ar_addr,
	slave_ar_prot,
	slave_ar_region,
	slave_ar_len,
	slave_ar_size,
	slave_ar_burst,
	slave_ar_lock,
	slave_ar_cache,
	slave_ar_qos,
	slave_ar_id,
	slave_ar_user,
	slave_ar_ready,
	slave_ar_valid,
	slave_w_valid,
	slave_w_data,
	slave_w_strb,
	slave_w_user,
	slave_w_last,
	slave_w_ready,
	slave_r_data,
	slave_r_resp,
	slave_r_last,
	slave_r_id,
	slave_r_user,
	slave_r_ready,
	slave_r_valid,
	slave_b_resp,
	slave_b_id,
	slave_b_user,
	slave_b_ready,
	slave_b_valid,
	uart_tx,
	uart_rx,
	uart_rts,
	uart_dtr,
	uart_cts,
	uart_dsr,
	spi_master_clk,
	spi_master_csn0,
	spi_master_csn1,
	spi_master_csn2,
	spi_master_csn3,
	spi_master_mode,
	spi_master_sdo0,
	spi_master_sdo1,
	spi_master_sdo2,
	spi_master_sdo3,
	spi_master_sdi0,
	spi_master_sdi1,
	spi_master_sdi2,
	spi_master_sdi3,
	scl_pad_i,
	scl_pad_o,
	scl_padoen_o,
	sda_pad_i,
	sda_pad_o,
	sda_padoen_o,
	gpio_in,
	gpio_out,
	gpio_dir,
	gpio_padcfg,
	core_busy_i,
	irq_o,
	fetch_enable_i,
	fetch_enable_o,
	clk_gate_core_o,
	fll1_req_o,
	fll1_wrn_o,
	fll1_add_o,
	fll1_wdata_o,
	fll1_ack_i,
	fll1_rdata_i,
	fll1_lock_i,
	pad_cfg_o,
	pad_mux_o,
	boot_addr_o
);
	//parameter AXI_ADDR_WIDTH = 32;
	//parameter AXI_DATA_WIDTH = 64;
	//parameter AXI_USER_WIDTH = 6;
	//parameter AXI_SLAVE_ID_WIDTH = 6;
	//parameter AXI_MASTER_ID_WIDTH = 6;
	//parameter ROM_START_ADDR = 32'h00008000;
	parameter ADDR_WIDTH = 15;
    parameter AXI_STRB_WIDTH = AXI_DATA_WIDTH/8;
	parameter APB_ADDR_WIDTH = 32;
    parameter APB_DATA_WIDTH = 32;
	input wire clk_i;
	input wire rst_n;
	output wire [AXI_ADDR_WIDTH - 1:0] axi_spi_master_aw_addr;
	output wire [2:0] axi_spi_master_aw_prot;
	output wire [3:0] axi_spi_master_aw_region;
	output wire [7:0] axi_spi_master_aw_len;
	output wire [2:0] axi_spi_master_aw_size;
	output wire [1:0] axi_spi_master_aw_burst;
	output wire axi_spi_master_aw_lock;
	output wire [3:0] axi_spi_master_aw_cache;
	output wire [3:0] axi_spi_master_aw_qos;
	output wire [AXI_MASTER_ID_WIDTH - 1:0] axi_spi_master_aw_id;
	output wire [AXI_USER_WIDTH - 1:0] axi_spi_master_aw_user;
	input wire axi_spi_master_aw_ready;
	output wire axi_spi_master_aw_valid;
	output wire [AXI_ADDR_WIDTH - 1:0] axi_spi_master_ar_addr;
	output wire [2:0] axi_spi_master_ar_prot;
	output wire [3:0] axi_spi_master_ar_region;
	output wire [7:0] axi_spi_master_ar_len;
	output wire [2:0] axi_spi_master_ar_size;
	output wire [1:0] axi_spi_master_ar_burst;
	output wire axi_spi_master_ar_lock;
	output wire [3:0] axi_spi_master_ar_cache;
	output wire [3:0] axi_spi_master_ar_qos;
	output wire [AXI_MASTER_ID_WIDTH - 1:0] axi_spi_master_ar_id;
	output wire [AXI_USER_WIDTH - 1:0] axi_spi_master_ar_user;
	input wire axi_spi_master_ar_ready;
	output wire axi_spi_master_ar_valid;
	output wire axi_spi_master_w_valid;
	output wire [AXI_DATA_WIDTH - 1:0] axi_spi_master_w_data;
	output wire [AXI_STRB_WIDTH - 1:0] axi_spi_master_w_strb;
	output wire [AXI_USER_WIDTH - 1:0] axi_spi_master_w_user;
	output wire axi_spi_master_w_last;
	input wire axi_spi_master_w_ready;
	input wire [AXI_DATA_WIDTH - 1:0] axi_spi_master_r_data;
	input wire [1:0] axi_spi_master_r_resp;
	input wire axi_spi_master_r_last;
	input wire [AXI_MASTER_ID_WIDTH - 1:0] axi_spi_master_r_id;
	input wire [AXI_USER_WIDTH - 1:0] axi_spi_master_r_user;
	output wire axi_spi_master_r_ready;
	input wire axi_spi_master_r_valid;
	input wire [1:0] axi_spi_master_b_resp;
	input wire [AXI_MASTER_ID_WIDTH - 1:0] axi_spi_master_b_id;
	input wire [AXI_USER_WIDTH - 1:0] axi_spi_master_b_user;
	output wire axi_spi_master_b_ready;
	input wire axi_spi_master_b_valid;
	output wire debug_req;
	input wire debug_gnt;
	input wire debug_rvalid;
	output wire [ADDR_WIDTH - 1:0] debug_addr;
	output wire debug_we;
	output wire [31:0] debug_wdata;
	input wire [31:0] debug_rdata;
	input wire spi_clk_i;
	input wire testmode_i;
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
	input wire [AXI_ADDR_WIDTH - 1:0] slave_aw_addr;
	input wire [2:0] slave_aw_prot;
	input wire [3:0] slave_aw_region;
	input wire [7:0] slave_aw_len;
	input wire [2:0] slave_aw_size;
	input wire [1:0] slave_aw_burst;
	input wire slave_aw_lock;
	input wire [3:0] slave_aw_cache;
	input wire [3:0] slave_aw_qos;
	input wire [AXI_SLAVE_ID_WIDTH - 1:0] slave_aw_id;
	input wire [AXI_USER_WIDTH - 1:0] slave_aw_user;
	output wire slave_aw_ready;
	input wire slave_aw_valid;
	input wire [AXI_ADDR_WIDTH - 1:0] slave_ar_addr;
	input wire [2:0] slave_ar_prot;
	input wire [3:0] slave_ar_region;
	input wire [7:0] slave_ar_len;
	input wire [2:0] slave_ar_size;
	input wire [1:0] slave_ar_burst;
	input wire slave_ar_lock;
	input wire [3:0] slave_ar_cache;
	input wire [3:0] slave_ar_qos;
	input wire [AXI_SLAVE_ID_WIDTH - 1:0] slave_ar_id;
	input wire [AXI_USER_WIDTH - 1:0] slave_ar_user;
	output wire slave_ar_ready;
	input wire slave_ar_valid;
	input wire slave_w_valid;
	input wire [AXI_DATA_WIDTH - 1:0] slave_w_data;
	input wire [AXI_STRB_WIDTH - 1:0] slave_w_strb;
	input wire [AXI_USER_WIDTH - 1:0] slave_w_user;
	input wire slave_w_last;
	output wire slave_w_ready;
	output wire [AXI_DATA_WIDTH - 1:0] slave_r_data;
	output wire [1:0] slave_r_resp;
	output wire slave_r_last;
	output wire [AXI_SLAVE_ID_WIDTH - 1:0] slave_r_id;
	output wire [AXI_USER_WIDTH - 1:0] slave_r_user;
	input wire slave_r_ready;
	output wire slave_r_valid;
	output wire [1:0] slave_b_resp;
	output wire [AXI_SLAVE_ID_WIDTH - 1:0] slave_b_id;
	output wire [AXI_USER_WIDTH - 1:0] slave_b_user;
	input wire slave_b_ready;
	output wire slave_b_valid;
	output wire uart_tx;
	input wire uart_rx;
	output wire uart_rts;
	output wire uart_dtr;
	input wire uart_cts;
	input wire uart_dsr;
	output wire spi_master_clk;
	output wire spi_master_csn0;
	output wire spi_master_csn1;
	output wire spi_master_csn2;
	output wire spi_master_csn3;
	output wire [1:0] spi_master_mode;
	output wire spi_master_sdo0;
	output wire spi_master_sdo1;
	output wire spi_master_sdo2;
	output wire spi_master_sdo3;
	input wire spi_master_sdi0;
	input wire spi_master_sdi1;
	input wire spi_master_sdi2;
	input wire spi_master_sdi3;
	input wire scl_pad_i;
	output wire scl_pad_o;
	output wire scl_padoen_o;
	input wire sda_pad_i;
	output wire sda_pad_o;
	output wire sda_padoen_o;
	input wire [31:0] gpio_in;
	output wire [31:0] gpio_out;
	output wire [31:0] gpio_dir;
	output wire [191:0] gpio_padcfg;
	input wire core_busy_i;
	output wire [31:0] irq_o;
	input wire fetch_enable_i;
	output wire fetch_enable_o;
	output wire clk_gate_core_o;
	output wire fll1_req_o;
	output wire fll1_wrn_o;
	output wire [1:0] fll1_add_o;
	output wire [31:0] fll1_wdata_o;
	input wire fll1_ack_i;
	input wire [31:0] fll1_rdata_i;
	input wire fll1_lock_i;
	output wire [191:0] pad_cfg_o;
	output wire [31:0] pad_mux_o;
	output wire [31:0] boot_addr_o;
	//localparam APB_ADDR_WIDTH = 32;
	localparam APB_NUM_SLAVES = 8;
	wire [31:0] s_apb_bus_paddr;
	wire [APB_DATA_WIDTH - 1:0] s_apb_bus_pwdata;
	wire s_apb_bus_pwrite;
	wire s_apb_bus_psel;
	wire s_apb_bus_penable;
	wire [APB_DATA_WIDTH - 1:0] s_apb_bus_prdata;
	wire s_apb_bus_pready;
	wire s_apb_bus_pslverr;
	wire [31:0] s_uart_bus_paddr;
	wire [APB_DATA_WIDTH - 1:0] s_uart_bus_pwdata;
	wire s_uart_bus_pwrite;
	wire s_uart_bus_psel;
	wire s_uart_bus_penable;
	wire [APB_DATA_WIDTH - 1:0] s_uart_bus_prdata;
	wire s_uart_bus_pready;
	wire s_uart_bus_pslverr;
	wire [31:0] s_gpio_bus_paddr;
	wire [APB_DATA_WIDTH - 1:0] s_gpio_bus_pwdata;
	wire s_gpio_bus_pwrite;
	wire s_gpio_bus_psel;
	wire s_gpio_bus_penable;
	wire [APB_DATA_WIDTH - 1:0] s_gpio_bus_prdata;
	wire s_gpio_bus_pready;
	wire s_gpio_bus_pslverr;
	wire [31:0] s_spi_bus_paddr;
	wire [APB_DATA_WIDTH - 1:0] s_spi_bus_pwdata;
	wire s_spi_bus_pwrite;
	wire s_spi_bus_psel;
	wire s_spi_bus_penable;
	wire [APB_DATA_WIDTH - 1:0] s_spi_bus_prdata;
	wire s_spi_bus_pready;
	wire s_spi_bus_pslverr;
	wire [31:0] s_timer_bus_paddr;
	wire [APB_DATA_WIDTH - 1:0] s_timer_bus_pwdata;
	wire s_timer_bus_pwrite;
	wire s_timer_bus_psel;
	wire s_timer_bus_penable;
	wire [APB_DATA_WIDTH - 1:0] s_timer_bus_prdata;
	wire s_timer_bus_pready;
	wire s_timer_bus_pslverr;
	wire [31:0] s_event_unit_bus_paddr;
	wire [APB_DATA_WIDTH - 1:0] s_event_unit_bus_pwdata;
	wire s_event_unit_bus_pwrite;
	wire s_event_unit_bus_psel;
	wire s_event_unit_bus_penable;
	wire [APB_DATA_WIDTH - 1:0] s_event_unit_bus_prdata;
	wire s_event_unit_bus_pready;
	wire s_event_unit_bus_pslverr;
	wire [31:0] s_i2c_bus_paddr;
	wire [APB_DATA_WIDTH - 1:0] s_i2c_bus_pwdata;
	wire s_i2c_bus_pwrite;
	wire s_i2c_bus_psel;
	wire s_i2c_bus_penable;
	wire [APB_DATA_WIDTH - 1:0] s_i2c_bus_prdata;
	wire s_i2c_bus_pready;
	wire s_i2c_bus_pslverr;
	wire [31:0] s_fll_bus_paddr;
	wire [APB_DATA_WIDTH - 1:0] s_fll_bus_pwdata;
	wire s_fll_bus_pwrite;
	wire s_fll_bus_psel;
	wire s_fll_bus_penable;
	wire [APB_DATA_WIDTH - 1:0] s_fll_bus_prdata;
	wire s_fll_bus_pready;
	wire s_fll_bus_pslverr;
	wire [31:0] s_soc_ctrl_bus_paddr;
	wire [APB_DATA_WIDTH - 1:0] s_soc_ctrl_bus_pwdata;
	wire s_soc_ctrl_bus_pwrite;
	wire s_soc_ctrl_bus_psel;
	wire s_soc_ctrl_bus_penable;
	wire [APB_DATA_WIDTH - 1:0] s_soc_ctrl_bus_prdata;
	wire s_soc_ctrl_bus_pready;
	wire s_soc_ctrl_bus_pslverr;
	wire [31:0] s_debug_bus_paddr;
	wire [APB_DATA_WIDTH - 1:0] s_debug_bus_pwdata;
	wire s_debug_bus_pwrite;
	wire s_debug_bus_psel;
	wire s_debug_bus_penable;
	wire [APB_DATA_WIDTH - 1:0] s_debug_bus_prdata;
	wire s_debug_bus_pready;
	wire s_debug_bus_pslverr;
	wire [1:0] s_spim_event;
	wire [3:0] timer_irq;
	wire [31:0] peripheral_clock_gate_ctrl;
	wire [31:0] clk_int;
	wire s_uart_event;
	wire i2c_event;
	wire s_gpio_event;
	genvar i;
	generate
		for (i = 0; i < APB_NUM_SLAVES; i = i + 1) begin : genblk1
			cluster_clock_gating core_clock_gate(
				.clk_o(clk_int[i]),
				.en_i(peripheral_clock_gate_ctrl[i]),
				.test_en_i(testmode_i),
				.clk_i(clk_i)
			);
		end
	endgenerate
	axi_spi_slave_wrap #(
		.AXI_ADDRESS_WIDTH(AXI_ADDR_WIDTH),
		.AXI_DATA_WIDTH(AXI_DATA_WIDTH),
		.AXI_USER_WIDTH(AXI_USER_WIDTH),
		.AXI_ID_WIDTH(AXI_MASTER_ID_WIDTH)
	) axi_spi_slave_i(
		.clk_i(clk_int[0]),
		.rst_ni(rst_n),
		.test_mode(testmode_i),
		.m00_aw_addr(axi_spi_master_aw_addr),
		.m00_aw_prot(axi_spi_master_aw_prot),
		.m00_aw_region(axi_spi_master_aw_region),
		.m00_aw_len(axi_spi_master_aw_len),
		.m00_aw_size(axi_spi_master_aw_size),
		.m00_aw_burst(axi_spi_master_aw_burst),
		.m00_aw_lock(axi_spi_master_aw_lock),
		.m00_aw_cache(axi_spi_master_aw_cache),
		.m00_aw_qos(axi_spi_master_aw_qos),
		.m00_aw_id(axi_spi_master_aw_id),
		.m00_aw_user(axi_spi_master_aw_user),
		.m00_aw_ready(axi_spi_master_aw_ready),
		.m00_aw_valid(axi_spi_master_aw_valid),
		.m00_ar_addr(axi_spi_master_ar_addr),
		.m00_ar_prot(axi_spi_master_ar_prot),
		.m00_ar_region(axi_spi_master_ar_region),
		.m00_ar_len(axi_spi_master_ar_len),
		.m00_ar_size(axi_spi_master_ar_size),
		.m00_ar_burst(axi_spi_master_ar_burst),
		.m00_ar_lock(axi_spi_master_ar_lock),
		.m00_ar_cache(axi_spi_master_ar_cache),
		.m00_ar_qos(axi_spi_master_ar_qos),
		.m00_ar_id(axi_spi_master_ar_id),
		.m00_ar_user(axi_spi_master_ar_user),
		.m00_ar_ready(axi_spi_master_ar_ready),
		.m00_ar_valid(axi_spi_master_ar_valid),
		.m00_w_valid(axi_spi_master_w_valid),
		.m00_w_data(axi_spi_master_w_data),
		.m00_w_strb(axi_spi_master_w_strb),
		.m00_w_user(axi_spi_master_w_user),
		.m00_w_last(axi_spi_master_w_last),
		.m00_w_ready(axi_spi_master_w_ready),
		.m00_r_data(axi_spi_master_r_data),
		.m00_r_resp(axi_spi_master_r_resp),
		.m00_r_last(axi_spi_master_r_last),
		.m00_r_id(axi_spi_master_r_id),
		.m00_r_user(axi_spi_master_r_user),
		.m00_r_ready(axi_spi_master_r_ready),
		.m00_r_valid(axi_spi_master_r_valid),
		.m00_b_resp(axi_spi_master_b_resp),
		.m00_b_id(axi_spi_master_b_id),
		.m00_b_user(axi_spi_master_b_user),
		.m00_b_ready(axi_spi_master_b_ready),
		.m00_b_valid(axi_spi_master_b_valid),
		.spi_clk(spi_clk_i),
		.spi_cs(spi_cs_i),
		.spi_mode(spi_mode_o),
		.spi_sdo0(spi_sdo0_o),
		.spi_sdo1(spi_sdo1_o),
		.spi_sdo2(spi_sdo2_o),
		.spi_sdo3(spi_sdo3_o),
		.spi_sdi0(spi_sdi0_i),
		.spi_sdi1(spi_sdi1_i),
		.spi_sdi2(spi_sdi2_i),
		.spi_sdi3(spi_sdi3_i)
	);
	axi2apb_wrap #(
		.AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
		.AXI_DATA_WIDTH(AXI_DATA_WIDTH),
		.AXI_USER_WIDTH(AXI_USER_WIDTH),
		.AXI_ID_WIDTH(AXI_SLAVE_ID_WIDTH),
		.APB_ADDR_WIDTH(APB_ADDR_WIDTH)
	) axi2apb_i(
		.clk_i(clk_i),
		.rst_ni(rst_n),
		.test_en_i(testmode_i),
		.s00_aw_addr(slave_aw_addr),
		.s00_aw_prot(slave_aw_prot),
		.s00_aw_region(slave_aw_region),
		.s00_aw_len(slave_aw_len),
		.s00_aw_size(slave_aw_size),
		.s00_aw_burst(slave_aw_burst),
		.s00_aw_lock(slave_aw_lock),
		.s00_aw_cache(slave_aw_cache),
		.s00_aw_qos(slave_aw_qos),
		.s00_aw_id(slave_aw_id),
		.s00_aw_user(slave_aw_user),
		.s00_aw_ready(slave_aw_ready),
		.s00_aw_valid(slave_aw_valid),
		.s00_ar_addr(slave_ar_addr),
		.s00_ar_prot(slave_ar_prot),
		.s00_ar_region(slave_ar_region),
		.s00_ar_len(slave_ar_len),
		.s00_ar_size(slave_ar_size),
		.s00_ar_burst(slave_ar_burst),
		.s00_ar_lock(slave_ar_lock),
		.s00_ar_cache(slave_ar_cache),
		.s00_ar_qos(slave_ar_qos),
		.s00_ar_id(slave_ar_id),
		.s00_ar_user(slave_ar_user),
		.s00_ar_ready(slave_ar_ready),
		.s00_ar_valid(slave_ar_valid),
		.s00_w_valid(slave_w_valid),
		.s00_w_data(slave_w_data),
		.s00_w_strb(slave_w_strb),
		.s00_w_user(slave_w_user),
		.s00_w_last(slave_w_last),
		.s00_w_ready(slave_w_ready),
		.s00_r_data(slave_r_data),
		.s00_r_resp(slave_r_resp),
		.s00_r_last(slave_r_last),
		.s00_r_id(slave_r_id),
		.s00_r_user(slave_r_user),
		.s00_r_ready(slave_r_ready),
		.s00_r_valid(slave_r_valid),
		.s00_b_resp(slave_b_resp),
		.s00_b_id(slave_b_id),
		.s00_b_user(slave_b_user),
		.s00_b_ready(slave_b_ready),
		.s00_b_valid(slave_b_valid),
		.m00_paddr(s_apb_bus_paddr),
		.m00_pwdata(s_apb_bus_pwdata),
		.m00_pwrite(s_apb_bus_pwrite),
		.m00_psel(s_apb_bus_psel),
		.m00_penable(s_apb_bus_penable),
		.m00_prdata(s_apb_bus_prdata),
		.m00_pready(s_apb_bus_pready),
		.m00_pslverr(s_apb_bus_pslverr)
	);
	periph_bus_wrap #(
		.APB_ADDR_WIDTH(APB_ADDR_WIDTH),
		.APB_DATA_WIDTH(32)
	) periph_bus_i(
		.clk_i(clk_i),
		.rst_ni(rst_n),
		.apb_slave_paddr(s_apb_bus_paddr),
		.apb_slave_pwdata(s_apb_bus_pwdata),
		.apb_slave_pwrite(s_apb_bus_pwrite),
		.apb_slave_psel(s_apb_bus_psel),
		.apb_slave_penable(s_apb_bus_penable),
		.apb_slave_prdata(s_apb_bus_prdata),
		.apb_slave_pready(s_apb_bus_pready),
		.apb_slave_pslverr(s_apb_bus_pslverr),
		.uart_master_paddr(s_uart_bus_paddr),
		.uart_master_pwdata(s_uart_bus_pwdata),
		.uart_master_pwrite(s_uart_bus_pwrite),
		.uart_master_psel(s_uart_bus_psel),
		.uart_master_penable(s_uart_bus_penable),
		.uart_master_prdata(s_uart_bus_prdata),
		.uart_master_pready(s_uart_bus_pready),
		.uart_master_pslverr(s_uart_bus_pslverr),
		.gpio_master_paddr(s_gpio_bus_paddr),
		.gpio_master_pwdata(s_gpio_bus_pwdata),
		.gpio_master_pwrite(s_gpio_bus_pwrite),
		.gpio_master_psel(s_gpio_bus_psel),
		.gpio_master_penable(s_gpio_bus_penable),
		.gpio_master_prdata(s_gpio_bus_prdata),
		.gpio_master_pready(s_gpio_bus_pready),
		.gpio_master_pslverr(s_gpio_bus_pslverr),
		.spi_master_paddr(s_spi_bus_paddr),
		.spi_master_pwdata(s_spi_bus_pwdata),
		.spi_master_pwrite(s_spi_bus_pwrite),
		.spi_master_psel(s_spi_bus_psel),
		.spi_master_penable(s_spi_bus_penable),
		.spi_master_prdata(s_spi_bus_prdata),
		.spi_master_pready(s_spi_bus_pready),
		.spi_master_pslverr(s_spi_bus_pslverr),
		.timer_master_paddr(s_timer_bus_paddr),
		.timer_master_pwdata(s_timer_bus_pwdata),
		.timer_master_pwrite(s_timer_bus_pwrite),
		.timer_master_psel(s_timer_bus_psel),
		.timer_master_penable(s_timer_bus_penable),
		.timer_master_prdata(s_timer_bus_prdata),
		.timer_master_pready(s_timer_bus_pready),
		.timer_master_pslverr(s_timer_bus_pslverr),
		.event_unit_master_paddr(s_event_unit_bus_paddr),
		.event_unit_master_pwdata(s_event_unit_bus_pwdata),
		.event_unit_master_pwrite(s_event_unit_bus_pwrite),
		.event_unit_master_psel(s_event_unit_bus_psel),
		.event_unit_master_penable(s_event_unit_bus_penable),
		.event_unit_master_prdata(s_event_unit_bus_prdata),
		.event_unit_master_pready(s_event_unit_bus_pready),
		.event_unit_master_pslverr(s_event_unit_bus_pslverr),
		.i2c_unit_master_paddr(s_i2c_bus_paddr),
		.i2c_unit_master_pwdata(s_i2c_bus_pwdata),
		.i2c_unit_master_pwrite(s_i2c_bus_pwrite),
		.i2c_unit_master_psel(s_i2c_bus_psel),
		.i2c_unit_master_penable(s_i2c_bus_penable),
		.i2c_unit_master_prdata(s_i2c_bus_prdata),
		.i2c_unit_master_pready(s_i2c_bus_pready),
		.i2c_unit_master_pslverr(s_i2c_bus_pslverr),
		.fll_master_paddr(s_fll_bus_paddr),
		.fll_master_pwdata(s_fll_bus_pwdata),
		.fll_master_pwrite(s_fll_bus_pwrite),
		.fll_master_psel(s_fll_bus_psel),
		.fll_master_penable(s_fll_bus_penable),
		.fll_master_prdata(s_fll_bus_prdata),
		.fll_master_pready(s_fll_bus_pready),
		.fll_master_pslverr(s_fll_bus_pslverr),
		.soc_ctrl_master_paddr(s_soc_ctrl_bus_paddr),
		.soc_ctrl_master_pwdata(s_soc_ctrl_bus_pwdata),
		.soc_ctrl_master_pwrite(s_soc_ctrl_bus_pwrite),
		.soc_ctrl_master_psel(s_soc_ctrl_bus_psel),
		.soc_ctrl_master_penable(s_soc_ctrl_bus_penable),
		.soc_ctrl_master_prdata(s_soc_ctrl_bus_prdata),
		.soc_ctrl_master_pready(s_soc_ctrl_bus_pready),
		.soc_ctrl_master_pslverr(s_soc_ctrl_bus_pslverr),
		.debug_master_paddr(s_debug_bus_paddr),
		.debug_master_pwdata(s_debug_bus_pwdata),
		.debug_master_pwrite(s_debug_bus_pwrite),
		.debug_master_psel(s_debug_bus_psel),
		.debug_master_penable(s_debug_bus_penable),
		.debug_master_prdata(s_debug_bus_prdata),
		.debug_master_pready(s_debug_bus_pready),
		.debug_master_pslverr(s_debug_bus_pslverr)
	);

	apb_uart_sv
    #(
       .APB_ADDR_WIDTH( 3 )
    )
    apb_uart_i
    (
      .CLK      ( clk_int[1]            ),
      .RSTN     ( rst_n                 ),

      .PSEL     ( s_uart_bus_psel       ),
      .PENABLE  ( s_uart_bus_penable    ),
      .PWRITE   ( s_uart_bus_pwrite     ),
      .PADDR    ( s_uart_bus_paddr[4:2] ),
      .PWDATA   ( s_uart_bus_pwdata     ),
      .PRDATA   ( s_uart_bus_prdata     ),
      .PREADY   ( s_uart_bus_pready     ),
      .PSLVERR  ( s_uart_bus_pslverr    ),

      .rx_i     ( uart_rx               ),
      .tx_o     ( uart_tx               ),
      .event_o  ( s_uart_event          )
    );

//	apb_uart apb_uart_i(
//		.CLK(clk_int[1]),
//		.RSTN(rst_n),
//		.PSEL(s_uart_bus_psel),
//		.PENABLE(s_uart_bus_penable),
//		.PWRITE(s_uart_bus_pwrite),
//		.PADDR(s_uart_bus_paddr[4:2]),
//		.PWDATA(s_uart_bus_pwdata),
//		.PRDATA(s_uart_bus_prdata),
//		.PREADY(s_uart_bus_pready),
//		.PSLVERR(s_uart_bus_pslverr),
//		.INT(s_uart_event),
//		.OUT1N(),
//		.OUT2N(),
//		.RTSN(uart_rts),
//		.DTRN(uart_dtr),
//		.CTSN(uart_cts),
//		.DSRN(uart_dsr),
//		.DCDN(1'b1),
//		.RIN(1'b1),
//		.SIN(uart_rx),
//		.SOUT(uart_tx)
//	);
	apb_gpio apb_gpio_i(
		.HCLK(clk_int[2]),
		.HRESETn(rst_n),
		.PADDR(s_gpio_bus_paddr[11:0]),
		.PWDATA(s_gpio_bus_pwdata),
		.PWRITE(s_gpio_bus_pwrite),
		.PSEL(s_gpio_bus_psel),
		.PENABLE(s_gpio_bus_penable),
		.PRDATA(s_gpio_bus_prdata),
		.PREADY(s_gpio_bus_pready),
		.PSLVERR(s_gpio_bus_pslverr),
		.gpio_in(gpio_in),
		.gpio_out(gpio_out),
		.gpio_dir(gpio_dir),
		.gpio_padcfg(gpio_padcfg),
		.interrupt(s_gpio_event)
	);
	apb_spi_master #(.BUFFER_DEPTH(8)) apb_spi_master_i(
		.HCLK(clk_int[3]),
		.HRESETn(rst_n),
		.PADDR(s_spi_bus_paddr[11:0]),
		.PWDATA(s_spi_bus_pwdata),
		.PWRITE(s_spi_bus_pwrite),
		.PSEL(s_spi_bus_psel),
		.PENABLE(s_spi_bus_penable),
		.PRDATA(s_spi_bus_prdata),
		.PREADY(s_spi_bus_pready),
		.PSLVERR(s_spi_bus_pslverr),
		.events_o(s_spim_event),
		.spi_clk(spi_master_clk),
		.spi_csn0(spi_master_csn0),
		.spi_csn1(spi_master_csn1),
		.spi_csn2(spi_master_csn2),
		.spi_csn3(spi_master_csn3),
		.spi_mode(spi_master_mode),
		.spi_sdo0(spi_master_sdo0),
		.spi_sdo1(spi_master_sdo1),
		.spi_sdo2(spi_master_sdo2),
		.spi_sdo3(spi_master_sdo3),
		.spi_sdi0(spi_master_sdi0),
		.spi_sdi1(spi_master_sdi1),
		.spi_sdi2(spi_master_sdi2),
		.spi_sdi3(spi_master_sdi3)
	);
	apb_timer apb_timer_i(
		.HCLK(clk_int[4]),
		.HRESETn(rst_n),
		.PADDR(s_timer_bus_paddr[11:0]),
		.PWDATA(s_timer_bus_pwdata),
		.PWRITE(s_timer_bus_pwrite),
		.PSEL(s_timer_bus_psel),
		.PENABLE(s_timer_bus_penable),
		.PRDATA(s_timer_bus_prdata),
		.PREADY(s_timer_bus_pready),
		.PSLVERR(s_timer_bus_pslverr),
		.irq_o(timer_irq)
	);
	apb_event_unit apb_event_unit_i(
		.clk_i(clk_i),
		.HCLK(clk_int[5]),
		.HRESETn(rst_n),
		.PADDR(s_event_unit_bus_paddr[11:0]),
		.PWDATA(s_event_unit_bus_pwdata),
		.PWRITE(s_event_unit_bus_pwrite),
		.PSEL(s_event_unit_bus_psel),
		.PENABLE(s_event_unit_bus_penable),
		.PRDATA(s_event_unit_bus_prdata),
		.PREADY(s_event_unit_bus_pready),
		.PSLVERR(s_event_unit_bus_pslverr),
		.irq_i({timer_irq, s_spim_event, s_gpio_event, s_uart_event, i2c_event, 23'b00000000000000000000000}),
		.event_i({timer_irq, s_spim_event, s_gpio_event, s_uart_event, i2c_event, 23'b00000000000000000000000}),
		.irq_o(irq_o),
		.fetch_enable_i(fetch_enable_i),
		.fetch_enable_o(fetch_enable_o),
		.clk_gate_core_o(clk_gate_core_o),
		.core_busy_i(core_busy_i)
	);
	apb_i2c apb_i2c_i(
		.HCLK(clk_int[6]),
		.HRESETn(rst_n),
		.PADDR(s_i2c_bus_paddr[11:0]),
		.PWDATA(s_i2c_bus_pwdata),
		.PWRITE(s_i2c_bus_pwrite),
		.PSEL(s_i2c_bus_psel),
		.PENABLE(s_i2c_bus_penable),
		.PRDATA(s_i2c_bus_prdata),
		.PREADY(s_i2c_bus_pready),
		.PSLVERR(s_i2c_bus_pslverr),
		.interrupt_o(i2c_event),
		.scl_pad_i(scl_pad_i),
		.scl_pad_o(scl_pad_o),
		.scl_padoen_o(scl_padoen_o),
		.sda_pad_i(sda_pad_i),
		.sda_pad_o(sda_pad_o),
		.sda_padoen_o(sda_padoen_o)
	);
	apb_fll_if apb_fll_if_i(
		.HCLK(clk_int[7]),
		.HRESETn(rst_n),
		.PADDR(s_fll_bus_paddr[11:0]),
		.PWDATA(s_fll_bus_pwdata),
		.PWRITE(s_fll_bus_pwrite),
		.PSEL(s_fll_bus_psel),
		.PENABLE(s_fll_bus_penable),
		.PRDATA(s_fll_bus_prdata),
		.PREADY(s_fll_bus_pready),
		.PSLVERR(s_fll_bus_pslverr),
		.fll1_req(fll1_req_o),
		.fll1_wrn(fll1_wrn_o),
		.fll1_add(fll1_add_o),
		.fll1_data(fll1_wdata_o),
		.fll1_ack(fll1_ack_i),
		.fll1_r_data(fll1_rdata_i),
		.fll1_lock(fll1_lock_i),
		.fll2_req(),
		.fll2_wrn(),
		.fll2_add(),
		.fll2_data(),
		.fll2_ack(1'b0),
		.fll2_r_data(32'sb0),
		.fll2_lock(1'b0)
	);
	apb_pulpino #(.BOOT_ADDR(ROM_START_ADDR)) apb_pulpino_i(
		.HCLK(clk_i),
		.HRESETn(rst_n),
		.PADDR(s_soc_ctrl_bus_paddr[11:0]),
		.PWDATA(s_soc_ctrl_bus_pwdata),
		.PWRITE(s_soc_ctrl_bus_pwrite),
		.PSEL(s_soc_ctrl_bus_psel),
		.PENABLE(s_soc_ctrl_bus_penable),
		.PRDATA(s_soc_ctrl_bus_prdata),
		.PREADY(s_soc_ctrl_bus_pready),
		.PSLVERR(s_soc_ctrl_bus_pslverr),
		.pad_cfg_o(pad_cfg_o),
		.clk_gate_o(peripheral_clock_gate_ctrl),
		.pad_mux_o(pad_mux_o),
		.boot_addr_o(boot_addr_o)
	);
	apb2per #(
		.PER_ADDR_WIDTH(15),
		.APB_ADDR_WIDTH(APB_ADDR_WIDTH)
	) apb2per_debug_i(
		.clk_i(clk_i),
		.rst_ni(rst_n),
		.PADDR(s_debug_bus_paddr),
		.PWDATA(s_debug_bus_pwdata),
		.PWRITE(s_debug_bus_pwrite),
		.PSEL(s_debug_bus_psel),
		.PENABLE(s_debug_bus_penable),
		.PRDATA(s_debug_bus_prdata),
		.PREADY(s_debug_bus_pready),
		.PSLVERR(s_debug_bus_pslverr),
		.per_master_req_o(debug_req),
		.per_master_add_o(debug_addr),
		.per_master_we_o(debug_we),
		.per_master_wdata_o(debug_wdata),
		.per_master_be_o(),
		.per_master_gnt_i(debug_gnt),
		.per_master_r_valid_i(debug_rvalid),
		.per_master_r_opc_i(1'sb0),
		.per_master_r_rdata_i(debug_rdata)
	);
endmodule
