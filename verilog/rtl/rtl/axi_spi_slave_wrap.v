module axi_spi_slave_wrap 
#(
    parameter AXI_ADDRESS_WIDTH = 32,
    parameter AXI_DATA_WIDTH    = 64,
    parameter AXI_ID_WIDTH      = 16,
    parameter AXI_USER_WIDTH    = 10
  )
(
	clk_i,
	rst_ni,
	test_mode,
	m00_aw_addr,
	m00_aw_prot,
	m00_aw_region,
	m00_aw_len,
	m00_aw_size,
	m00_aw_burst,
	m00_aw_lock,
	m00_aw_cache,
	m00_aw_qos,
	m00_aw_id,
	m00_aw_user,
	m00_aw_ready,
	m00_aw_valid,
	m00_ar_addr,
	m00_ar_prot,
	m00_ar_region,
	m00_ar_len,
	m00_ar_size,
	m00_ar_burst,
	m00_ar_lock,
	m00_ar_cache,
	m00_ar_qos,
	m00_ar_id,
	m00_ar_user,
	m00_ar_ready,
	m00_ar_valid,
	m00_w_valid,
	m00_w_data,
	m00_w_strb,
	m00_w_user,
	m00_w_last,
	m00_w_ready,
	m00_r_data,
	m00_r_resp,
	m00_r_last,
	m00_r_id,
	m00_r_user,
	m00_r_ready,
	m00_r_valid,
	m00_b_resp,
	m00_b_id,
	m00_b_user,
	m00_b_ready,
	m00_b_valid,
	spi_clk,
	spi_cs,
	spi_mode,
	spi_sdo0,
	spi_sdo1,
	spi_sdo2,
	spi_sdo3,
	spi_sdi0,
	spi_sdi1,
	spi_sdi2,
	spi_sdi3
);
	//parameter AXI_ADDRESS_WIDTH = 32;
	//parameter AXI_DATA_WIDTH = 64;
	//parameter AXI_ID_WIDTH = 16;
	//parameter AXI_USER_WIDTH = 10;
	parameter AXI_STRB_WIDTH = AXI_DATA_WIDTH / 8;
	parameter AXI_ADDR_WIDTH = AXI_ADDRESS_WIDTH;
	input wire clk_i;
	input wire rst_ni;
	input wire test_mode;
	output wire [AXI_ADDR_WIDTH - 1:0] m00_aw_addr;
	output wire [2:0] m00_aw_prot;
	output wire [3:0] m00_aw_region;
	output wire [7:0] m00_aw_len;
	output wire [2:0] m00_aw_size;
	output wire [1:0] m00_aw_burst;
	output wire m00_aw_lock;
	output wire [3:0] m00_aw_cache;
	output wire [3:0] m00_aw_qos;
	output wire [AXI_ID_WIDTH - 1:0] m00_aw_id;
	output wire [AXI_USER_WIDTH - 1:0] m00_aw_user;
	input wire m00_aw_ready;
	output wire m00_aw_valid;
	output wire [AXI_ADDR_WIDTH - 1:0] m00_ar_addr;
	output wire [2:0] m00_ar_prot;
	output wire [3:0] m00_ar_region;
	output wire [7:0] m00_ar_len;
	output wire [2:0] m00_ar_size;
	output wire [1:0] m00_ar_burst;
	output wire m00_ar_lock;
	output wire [3:0] m00_ar_cache;
	output wire [3:0] m00_ar_qos;
	output wire [AXI_ID_WIDTH - 1:0] m00_ar_id;
	output wire [AXI_USER_WIDTH - 1:0] m00_ar_user;
	input wire m00_ar_ready;
	output wire m00_ar_valid;
	output wire m00_w_valid;
	output wire [AXI_DATA_WIDTH - 1:0] m00_w_data;
	output wire [AXI_STRB_WIDTH - 1:0] m00_w_strb;
	output wire [AXI_USER_WIDTH - 1:0] m00_w_user;
	output wire m00_w_last;
	input wire m00_w_ready;
	input wire [AXI_DATA_WIDTH - 1:0] m00_r_data;
	input wire [1:0] m00_r_resp;
	input wire m00_r_last;
	input wire [AXI_ID_WIDTH - 1:0] m00_r_id;
	input wire [AXI_USER_WIDTH - 1:0] m00_r_user;
	output wire m00_r_ready;
	input wire m00_r_valid;
	input wire [1:0] m00_b_resp;
	input wire [AXI_ID_WIDTH - 1:0] m00_b_id;
	input wire [AXI_USER_WIDTH - 1:0] m00_b_user;
	output wire m00_b_ready;
	input wire m00_b_valid;
	input wire spi_clk;
	input wire spi_cs;
	output wire [1:0] spi_mode;
	output wire spi_sdo0;
	output wire spi_sdo1;
	output wire spi_sdo2;
	output wire spi_sdo3;
	input wire spi_sdi0;
	input wire spi_sdi1;
	input wire spi_sdi2;
	input wire spi_sdi3;
	axi_spi_slave #(
		.AXI_ADDR_WIDTH(AXI_ADDRESS_WIDTH),
		.AXI_DATA_WIDTH(AXI_DATA_WIDTH),
		.AXI_ID_WIDTH(AXI_ID_WIDTH),
		.AXI_USER_WIDTH(AXI_USER_WIDTH)
	) axi_spi_slave_i(
		.axi_aclk(clk_i),
		.axi_aresetn(rst_ni),
		.axi_master_aw_valid(m00_aw_valid),
		.axi_master_aw_id(m00_aw_id),
		.axi_master_aw_prot(m00_aw_prot),
		.axi_master_aw_region(m00_aw_region),
		.axi_master_aw_qos(m00_aw_qos),
		.axi_master_aw_cache(m00_aw_cache),
		.axi_master_aw_lock(m00_aw_lock),
		.axi_master_aw_burst(m00_aw_burst),
		.axi_master_aw_size(m00_aw_size),
		.axi_master_aw_len(m00_aw_len),
		.axi_master_aw_addr(m00_aw_addr),
		.axi_master_aw_user(m00_aw_user),
		.axi_master_aw_ready(m00_aw_ready),
		.axi_master_w_valid(m00_w_valid),
		.axi_master_w_data(m00_w_data),
		.axi_master_w_strb(m00_w_strb),
		.axi_master_w_last(m00_w_last),
		.axi_master_w_user(m00_w_user),
		.axi_master_w_ready(m00_w_ready),
		.axi_master_b_valid(m00_b_valid),
		.axi_master_b_id(m00_b_id),
		.axi_master_b_resp(m00_b_resp),
		.axi_master_b_user(m00_b_user),
		.axi_master_b_ready(m00_b_ready),
		.axi_master_ar_valid(m00_ar_valid),
		.axi_master_ar_id(m00_ar_id),
		.axi_master_ar_prot(m00_ar_prot),
		.axi_master_ar_region(m00_ar_region),
		.axi_master_ar_qos(m00_ar_qos),
		.axi_master_ar_cache(m00_ar_cache),
		.axi_master_ar_lock(m00_ar_lock),
		.axi_master_ar_burst(m00_ar_burst),
		.axi_master_ar_size(m00_ar_size),
		.axi_master_ar_len(m00_ar_len),
		.axi_master_ar_addr(m00_ar_addr),
		.axi_master_ar_user(m00_ar_user),
		.axi_master_ar_ready(m00_ar_ready),
		.axi_master_r_valid(m00_r_valid),
		.axi_master_r_id(m00_r_id),
		.axi_master_r_data(m00_r_data),
		.axi_master_r_resp(m00_r_resp),
		.axi_master_r_last(m00_r_last),
		.axi_master_r_user(m00_r_user),
		.axi_master_r_ready(m00_r_ready),
		.test_mode(test_mode),
		.spi_sclk(spi_clk),
		.spi_cs(spi_cs),
		.spi_mode(spi_mode),
		.spi_sdo0(spi_sdo0),
		.spi_sdo1(spi_sdo1),
		.spi_sdo2(spi_sdo2),
		.spi_sdo3(spi_sdo3),
		.spi_sdi0(spi_sdi0),
		.spi_sdi1(spi_sdi1),
		.spi_sdi2(spi_sdi2),
		.spi_sdi3(spi_sdi3)
	);
endmodule
