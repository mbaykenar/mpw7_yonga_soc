module axi_mem_if_DP 
#(
    parameter AXI4_ADDRESS_WIDTH = 32,
    parameter AXI4_RDATA_WIDTH   = 64,
    parameter AXI4_WDATA_WIDTH   = 64,
    parameter AXI4_ID_WIDTH      = 16,
    parameter AXI4_USER_WIDTH    = 10,
    parameter AXI_NUMBYTES       = AXI4_WDATA_WIDTH/8,
    parameter MEM_ADDR_WIDTH     = 13,
    parameter BUFF_DEPTH_SLAVE   = 4
)
(
	ACLK,
	ARESETn,
	test_en_i,
	LP_AWID_i,
	LP_AWADDR_i,
	LP_AWLEN_i,
	LP_AWSIZE_i,
	LP_AWBURST_i,
	LP_AWLOCK_i,
	LP_AWCACHE_i,
	LP_AWPROT_i,
	LP_AWREGION_i,
	LP_AWUSER_i,
	LP_AWQOS_i,
	LP_AWVALID_i,
	LP_AWREADY_o,
	LP_WDATA_i,
	LP_WSTRB_i,
	LP_WLAST_i,
	LP_WUSER_i,
	LP_WVALID_i,
	LP_WREADY_o,
	LP_BID_o,
	LP_BRESP_o,
	LP_BVALID_o,
	LP_BUSER_o,
	LP_BREADY_i,
	LP_ARID_i,
	LP_ARADDR_i,
	LP_ARLEN_i,
	LP_ARSIZE_i,
	LP_ARBURST_i,
	LP_ARLOCK_i,
	LP_ARCACHE_i,
	LP_ARPROT_i,
	LP_ARREGION_i,
	LP_ARUSER_i,
	LP_ARQOS_i,
	LP_ARVALID_i,
	LP_ARREADY_o,
	LP_RID_o,
	LP_RDATA_o,
	LP_RRESP_o,
	LP_RLAST_o,
	LP_RUSER_o,
	LP_RVALID_o,
	LP_RREADY_i,
	HP_AWID_i,
	HP_AWADDR_i,
	HP_AWLEN_i,
	HP_AWSIZE_i,
	HP_AWBURST_i,
	HP_AWLOCK_i,
	HP_AWCACHE_i,
	HP_AWPROT_i,
	HP_AWREGION_i,
	HP_AWUSER_i,
	HP_AWQOS_i,
	HP_AWVALID_i,
	HP_AWREADY_o,
	HP_WDATA_i,
	HP_WSTRB_i,
	HP_WLAST_i,
	HP_WUSER_i,
	HP_WVALID_i,
	HP_WREADY_o,
	HP_BID_o,
	HP_BRESP_o,
	HP_BVALID_o,
	HP_BUSER_o,
	HP_BREADY_i,
	HP_ARID_i,
	HP_ARADDR_i,
	HP_ARLEN_i,
	HP_ARSIZE_i,
	HP_ARBURST_i,
	HP_ARLOCK_i,
	HP_ARCACHE_i,
	HP_ARPROT_i,
	HP_ARREGION_i,
	HP_ARUSER_i,
	HP_ARQOS_i,
	HP_ARVALID_i,
	HP_ARREADY_o,
	HP_RID_o,
	HP_RDATA_o,
	HP_RRESP_o,
	HP_RLAST_o,
	HP_RUSER_o,
	HP_RVALID_o,
	HP_RREADY_i,
	CEN,
	WEN,
	A,
	D,
	BE,
	Q
);
	//parameter AXI4_ADDRESS_WIDTH = 32;
	//parameter AXI4_RDATA_WIDTH = 64;
	//parameter AXI4_WDATA_WIDTH = 64;
	//parameter AXI4_ID_WIDTH = 16;
	//parameter AXI4_USER_WIDTH = 10;
	//parameter AXI_NUMBYTES = AXI4_WDATA_WIDTH / 8;
	//parameter MEM_ADDR_WIDTH = 13;
	//parameter BUFF_DEPTH_SLAVE = 4;
	input wire ACLK;
	input wire ARESETn;
	input wire test_en_i;
	input wire [AXI4_ID_WIDTH - 1:0] LP_AWID_i;
	input wire [AXI4_ADDRESS_WIDTH - 1:0] LP_AWADDR_i;
	input wire [7:0] LP_AWLEN_i;
	input wire [2:0] LP_AWSIZE_i;
	input wire [1:0] LP_AWBURST_i;
	input wire LP_AWLOCK_i;
	input wire [3:0] LP_AWCACHE_i;
	input wire [2:0] LP_AWPROT_i;
	input wire [3:0] LP_AWREGION_i;
	input wire [AXI4_USER_WIDTH - 1:0] LP_AWUSER_i;
	input wire [3:0] LP_AWQOS_i;
	input wire LP_AWVALID_i;
	output wire LP_AWREADY_o;
	input wire [(AXI_NUMBYTES * 8) - 1:0] LP_WDATA_i;
	input wire [AXI_NUMBYTES - 1:0] LP_WSTRB_i;
	input wire LP_WLAST_i;
	input wire [AXI4_USER_WIDTH - 1:0] LP_WUSER_i;
	input wire LP_WVALID_i;
	output wire LP_WREADY_o;
	output wire [AXI4_ID_WIDTH - 1:0] LP_BID_o;
	output wire [1:0] LP_BRESP_o;
	output wire LP_BVALID_o;
	output wire [AXI4_USER_WIDTH - 1:0] LP_BUSER_o;
	input wire LP_BREADY_i;
	input wire [AXI4_ID_WIDTH - 1:0] LP_ARID_i;
	input wire [AXI4_ADDRESS_WIDTH - 1:0] LP_ARADDR_i;
	input wire [7:0] LP_ARLEN_i;
	input wire [2:0] LP_ARSIZE_i;
	input wire [1:0] LP_ARBURST_i;
	input wire LP_ARLOCK_i;
	input wire [3:0] LP_ARCACHE_i;
	input wire [2:0] LP_ARPROT_i;
	input wire [3:0] LP_ARREGION_i;
	input wire [AXI4_USER_WIDTH - 1:0] LP_ARUSER_i;
	input wire [3:0] LP_ARQOS_i;
	input wire LP_ARVALID_i;
	output wire LP_ARREADY_o;
	output wire [AXI4_ID_WIDTH - 1:0] LP_RID_o;
	output wire [AXI4_RDATA_WIDTH - 1:0] LP_RDATA_o;
	output wire [1:0] LP_RRESP_o;
	output wire LP_RLAST_o;
	output wire [AXI4_USER_WIDTH - 1:0] LP_RUSER_o;
	output wire LP_RVALID_o;
	input wire LP_RREADY_i;
	input wire [AXI4_ID_WIDTH - 1:0] HP_AWID_i;
	input wire [AXI4_ADDRESS_WIDTH - 1:0] HP_AWADDR_i;
	input wire [7:0] HP_AWLEN_i;
	input wire [2:0] HP_AWSIZE_i;
	input wire [1:0] HP_AWBURST_i;
	input wire HP_AWLOCK_i;
	input wire [3:0] HP_AWCACHE_i;
	input wire [2:0] HP_AWPROT_i;
	input wire [3:0] HP_AWREGION_i;
	input wire [AXI4_USER_WIDTH - 1:0] HP_AWUSER_i;
	input wire [3:0] HP_AWQOS_i;
	input wire HP_AWVALID_i;
	output wire HP_AWREADY_o;
	input wire [(AXI_NUMBYTES * 8) - 1:0] HP_WDATA_i;
	input wire [AXI_NUMBYTES - 1:0] HP_WSTRB_i;
	input wire HP_WLAST_i;
	input wire [AXI4_USER_WIDTH - 1:0] HP_WUSER_i;
	input wire HP_WVALID_i;
	output wire HP_WREADY_o;
	output wire [AXI4_ID_WIDTH - 1:0] HP_BID_o;
	output wire [1:0] HP_BRESP_o;
	output wire HP_BVALID_o;
	output wire [AXI4_USER_WIDTH - 1:0] HP_BUSER_o;
	input wire HP_BREADY_i;
	input wire [AXI4_ID_WIDTH - 1:0] HP_ARID_i;
	input wire [AXI4_ADDRESS_WIDTH - 1:0] HP_ARADDR_i;
	input wire [7:0] HP_ARLEN_i;
	input wire [2:0] HP_ARSIZE_i;
	input wire [1:0] HP_ARBURST_i;
	input wire HP_ARLOCK_i;
	input wire [3:0] HP_ARCACHE_i;
	input wire [2:0] HP_ARPROT_i;
	input wire [3:0] HP_ARREGION_i;
	input wire [AXI4_USER_WIDTH - 1:0] HP_ARUSER_i;
	input wire [3:0] HP_ARQOS_i;
	input wire HP_ARVALID_i;
	output wire HP_ARREADY_o;
	output wire [AXI4_ID_WIDTH - 1:0] HP_RID_o;
	output wire [AXI4_RDATA_WIDTH - 1:0] HP_RDATA_o;
	output wire [1:0] HP_RRESP_o;
	output wire HP_RLAST_o;
	output wire [AXI4_USER_WIDTH - 1:0] HP_RUSER_o;
	output wire HP_RVALID_o;
	input wire HP_RREADY_i;
	output reg CEN;
	output reg WEN;
	output reg [MEM_ADDR_WIDTH - 1:0] A;
	output reg [AXI4_WDATA_WIDTH - 1:0] D;
	output reg [AXI_NUMBYTES - 1:0] BE;
	input wire [AXI4_RDATA_WIDTH - 1:0] Q;
	localparam OFFSET_BIT = $clog2(AXI4_WDATA_WIDTH) - 3;
	wire [AXI4_ID_WIDTH - 1:0] LP_AWID;
	wire [AXI4_ID_WIDTH - 1:0] HP_AWID;
	wire [AXI4_ADDRESS_WIDTH - 1:0] LP_AWADDR;
	wire [AXI4_ADDRESS_WIDTH - 1:0] HP_AWADDR;
	wire [7:0] LP_AWLEN;
	wire [7:0] HP_AWLEN;
	wire [2:0] LP_AWSIZE;
	wire [2:0] HP_AWSIZE;
	wire [1:0] LP_AWBURST;
	wire [1:0] HP_AWBURST;
	wire LP_AWLOCK;
	wire HP_AWLOCK;
	wire [3:0] LP_AWCACHE;
	wire [3:0] HP_AWCACHE;
	wire [2:0] LP_AWPROT;
	wire [2:0] HP_AWPROT;
	wire [3:0] LP_AWREGION;
	wire [3:0] HP_AWREGION;
	wire [AXI4_USER_WIDTH - 1:0] LP_AWUSER;
	wire [AXI4_USER_WIDTH - 1:0] HP_AWUSER;
	wire [3:0] LP_AWQOS;
	wire [3:0] HP_AWQOS;
	wire LP_AWVALID;
	wire HP_AWVALID;
	wire LP_AWREADY;
	wire HP_AWREADY;
	wire [(AXI_NUMBYTES * 8) - 1:0] LP_WDATA;
	wire [(AXI_NUMBYTES * 8) - 1:0] HP_WDATA;
	wire [AXI_NUMBYTES - 1:0] LP_WSTRB;
	wire [AXI_NUMBYTES - 1:0] HP_WSTRB;
	wire LP_WLAST;
	wire HP_WLAST;
	wire [AXI4_USER_WIDTH - 1:0] LP_WUSER;
	wire [AXI4_USER_WIDTH - 1:0] HP_WUSER;
	wire LP_WVALID;
	wire HP_WVALID;
	wire LP_WREADY;
	wire HP_WREADY;
	wire [AXI4_ID_WIDTH - 1:0] LP_BID;
	wire [AXI4_ID_WIDTH - 1:0] HP_BID;
	wire [1:0] LP_BRESP;
	wire [1:0] HP_BRESP;
	wire LP_BVALID;
	wire HP_BVALID;
	wire [AXI4_USER_WIDTH - 1:0] LP_BUSER;
	wire [AXI4_USER_WIDTH - 1:0] HP_BUSER;
	wire LP_BREADY;
	wire HP_BREADY;
	wire [AXI4_ID_WIDTH - 1:0] LP_ARID;
	wire [AXI4_ID_WIDTH - 1:0] HP_ARID;
	wire [AXI4_ADDRESS_WIDTH - 1:0] LP_ARADDR;
	wire [AXI4_ADDRESS_WIDTH - 1:0] HP_ARADDR;
	wire [7:0] LP_ARLEN;
	wire [7:0] HP_ARLEN;
	wire [2:0] LP_ARSIZE;
	wire [2:0] HP_ARSIZE;
	wire [1:0] LP_ARBURST;
	wire [1:0] HP_ARBURST;
	wire LP_ARLOCK;
	wire HP_ARLOCK;
	wire [3:0] LP_ARCACHE;
	wire [3:0] HP_ARCACHE;
	wire [2:0] LP_ARPROT;
	wire [2:0] HP_ARPROT;
	wire [3:0] LP_ARREGION;
	wire [3:0] HP_ARREGION;
	wire [AXI4_USER_WIDTH - 1:0] LP_ARUSER;
	wire [AXI4_USER_WIDTH - 1:0] HP_ARUSER;
	wire [3:0] LP_ARQOS;
	wire [3:0] HP_ARQOS;
	wire LP_ARVALID;
	wire HP_ARVALID;
	wire LP_ARREADY;
	wire HP_ARREADY;
	wire [AXI4_ID_WIDTH - 1:0] LP_RID;
	wire [AXI4_ID_WIDTH - 1:0] HP_RID;
	wire [AXI4_RDATA_WIDTH - 1:0] LP_RDATA;
	wire [AXI4_RDATA_WIDTH - 1:0] HP_RDATA;
	wire [1:0] LP_RRESP;
	wire [1:0] HP_RRESP;
	wire LP_RLAST;
	wire HP_RLAST;
	wire [AXI4_USER_WIDTH - 1:0] LP_RUSER;
	wire [AXI4_USER_WIDTH - 1:0] HP_RUSER;
	wire LP_RVALID;
	wire HP_RVALID;
	wire LP_RREADY;
	wire HP_RREADY;
	wire valid_R_HP;
	wire valid_W_HP;
	wire valid_R_LP;
	wire valid_W_LP;
	reg grant_R_HP;
	reg grant_W_HP;
	reg grant_R_LP;
	reg grant_W_LP;
	reg RR_FLAG_HP;
	reg RR_FLAG_LP;
	reg main_grant_LP;
	reg main_grant_HP;
	reg destination;
	wire HP_W_cen;
	wire HP_R_cen;
	wire LP_W_cen;
	wire LP_R_cen;
	reg LP_cen;
	reg HP_cen;
	wire HP_W_wen;
	wire HP_R_wen;
	wire LP_W_wen;
	wire LP_R_wen;
	reg LP_wen;
	reg HP_wen;
	wire [MEM_ADDR_WIDTH - 1:0] HP_W_addr;
	wire [MEM_ADDR_WIDTH - 1:0] HP_R_addr;
	wire [MEM_ADDR_WIDTH - 1:0] LP_W_addr;
	wire [MEM_ADDR_WIDTH - 1:0] LP_R_addr;
	reg [MEM_ADDR_WIDTH - 1:0] LP_addr;
	reg [MEM_ADDR_WIDTH - 1:0] HP_addr;
	wire [AXI4_WDATA_WIDTH - 1:0] LP_wdata;
	wire [AXI4_WDATA_WIDTH - 1:0] HP_wdata;
	wire [AXI_NUMBYTES - 1:0] LP_be;
	wire [AXI_NUMBYTES - 1:0] HP_be;
	axi_aw_buffer #(
		.ID_WIDTH(AXI4_ID_WIDTH),
		.ADDR_WIDTH(AXI4_ADDRESS_WIDTH),
		.USER_WIDTH(AXI4_USER_WIDTH),
		.BUFFER_DEPTH(BUFF_DEPTH_SLAVE)
	) Slave_aw_buffer_LP(
		.clk_i(ACLK),
		.rst_ni(ARESETn),
		.test_en_i(test_en_i),
		.slave_valid_i(LP_AWVALID_i),
		.slave_addr_i(LP_AWADDR_i),
		.slave_prot_i(LP_AWPROT_i),
		.slave_region_i(LP_AWREGION_i),
		.slave_len_i(LP_AWLEN_i),
		.slave_size_i(LP_AWSIZE_i),
		.slave_burst_i(LP_AWBURST_i),
		.slave_lock_i(LP_AWLOCK_i),
		.slave_cache_i(LP_AWCACHE_i),
		.slave_qos_i(LP_AWQOS_i),
		.slave_id_i(LP_AWID_i),
		.slave_user_i(LP_AWUSER_i),
		.slave_ready_o(LP_AWREADY_o),
		.master_valid_o(LP_AWVALID),
		.master_addr_o(LP_AWADDR),
		.master_prot_o(LP_AWPROT),
		.master_region_o(LP_AWREGION),
		.master_len_o(LP_AWLEN),
		.master_size_o(LP_AWSIZE),
		.master_burst_o(LP_AWBURST),
		.master_lock_o(LP_AWLOCK),
		.master_cache_o(LP_AWCACHE),
		.master_qos_o(LP_AWQOS),
		.master_id_o(LP_AWID),
		.master_user_o(LP_AWUSER),
		.master_ready_i(LP_AWREADY)
	);
	axi_ar_buffer #(
		.ID_WIDTH(AXI4_ID_WIDTH),
		.ADDR_WIDTH(AXI4_ADDRESS_WIDTH),
		.USER_WIDTH(AXI4_USER_WIDTH),
		.BUFFER_DEPTH(BUFF_DEPTH_SLAVE)
	) Slave_ar_buffer_LP(
		.clk_i(ACLK),
		.rst_ni(ARESETn),
		.test_en_i(test_en_i),
		.slave_valid_i(LP_ARVALID_i),
		.slave_addr_i(LP_ARADDR_i),
		.slave_prot_i(LP_ARPROT_i),
		.slave_region_i(LP_ARREGION_i),
		.slave_len_i(LP_ARLEN_i),
		.slave_size_i(LP_ARSIZE_i),
		.slave_burst_i(LP_ARBURST_i),
		.slave_lock_i(LP_ARLOCK_i),
		.slave_cache_i(LP_ARCACHE_i),
		.slave_qos_i(LP_ARQOS_i),
		.slave_id_i(LP_ARID_i),
		.slave_user_i(LP_ARUSER_i),
		.slave_ready_o(LP_ARREADY_o),
		.master_valid_o(LP_ARVALID),
		.master_addr_o(LP_ARADDR),
		.master_prot_o(LP_ARPROT),
		.master_region_o(LP_ARREGION),
		.master_len_o(LP_ARLEN),
		.master_size_o(LP_ARSIZE),
		.master_burst_o(LP_ARBURST),
		.master_lock_o(LP_ARLOCK),
		.master_cache_o(LP_ARCACHE),
		.master_qos_o(LP_ARQOS),
		.master_id_o(LP_ARID),
		.master_user_o(LP_ARUSER),
		.master_ready_i(LP_ARREADY)
	);
	axi_w_buffer #(
		.DATA_WIDTH(AXI4_WDATA_WIDTH),
		.USER_WIDTH(AXI4_USER_WIDTH),
		.BUFFER_DEPTH(BUFF_DEPTH_SLAVE)
	) Slave_w_buffer_LP(
		.clk_i(ACLK),
		.rst_ni(ARESETn),
		.test_en_i(test_en_i),
		.slave_valid_i(LP_WVALID_i),
		.slave_data_i(LP_WDATA_i),
		.slave_strb_i(LP_WSTRB_i),
		.slave_user_i(LP_WUSER_i),
		.slave_last_i(LP_WLAST_i),
		.slave_ready_o(LP_WREADY_o),
		.master_valid_o(LP_WVALID),
		.master_data_o(LP_WDATA),
		.master_strb_o(LP_WSTRB),
		.master_user_o(LP_WUSER),
		.master_last_o(LP_WLAST),
		.master_ready_i(LP_WREADY)
	);
	axi_r_buffer #(
		.ID_WIDTH(AXI4_ID_WIDTH),
		.DATA_WIDTH(AXI4_RDATA_WIDTH),
		.USER_WIDTH(AXI4_USER_WIDTH),
		.BUFFER_DEPTH(BUFF_DEPTH_SLAVE)
	) Slave_r_buffer_LP(
		.clk_i(ACLK),
		.rst_ni(ARESETn),
		.test_en_i(test_en_i),
		.slave_valid_i(LP_RVALID),
		.slave_data_i(LP_RDATA),
		.slave_resp_i(LP_RRESP),
		.slave_user_i(LP_RUSER),
		.slave_id_i(LP_RID),
		.slave_last_i(LP_RLAST),
		.slave_ready_o(LP_RREADY),
		.master_valid_o(LP_RVALID_o),
		.master_data_o(LP_RDATA_o),
		.master_resp_o(LP_RRESP_o),
		.master_user_o(LP_RUSER_o),
		.master_id_o(LP_RID_o),
		.master_last_o(LP_RLAST_o),
		.master_ready_i(LP_RREADY_i)
	);
	axi_b_buffer #(
		.ID_WIDTH(AXI4_ID_WIDTH),
		.USER_WIDTH(AXI4_USER_WIDTH),
		.BUFFER_DEPTH(BUFF_DEPTH_SLAVE)
	) Slave_b_buffer_LP(
		.clk_i(ACLK),
		.rst_ni(ARESETn),
		.test_en_i(test_en_i),
		.slave_valid_i(LP_BVALID),
		.slave_resp_i(LP_BRESP),
		.slave_id_i(LP_BID),
		.slave_user_i(LP_BUSER),
		.slave_ready_o(LP_BREADY),
		.master_valid_o(LP_BVALID_o),
		.master_resp_o(LP_BRESP_o),
		.master_id_o(LP_BID_o),
		.master_user_o(LP_BUSER_o),
		.master_ready_i(LP_BREADY_i)
	);
	axi_aw_buffer #(
		.ID_WIDTH(AXI4_ID_WIDTH),
		.ADDR_WIDTH(AXI4_ADDRESS_WIDTH),
		.USER_WIDTH(AXI4_USER_WIDTH),
		.BUFFER_DEPTH(BUFF_DEPTH_SLAVE)
	) Slave_aw_buffer_HP(
		.clk_i(ACLK),
		.rst_ni(ARESETn),
		.test_en_i(test_en_i),
		.slave_valid_i(HP_AWVALID_i),
		.slave_addr_i(HP_AWADDR_i),
		.slave_prot_i(HP_AWPROT_i),
		.slave_region_i(HP_AWREGION_i),
		.slave_len_i(HP_AWLEN_i),
		.slave_size_i(HP_AWSIZE_i),
		.slave_burst_i(HP_AWBURST_i),
		.slave_lock_i(HP_AWLOCK_i),
		.slave_cache_i(HP_AWCACHE_i),
		.slave_qos_i(HP_AWQOS_i),
		.slave_id_i(HP_AWID_i),
		.slave_user_i(HP_AWUSER_i),
		.slave_ready_o(HP_AWREADY_o),
		.master_valid_o(HP_AWVALID),
		.master_addr_o(HP_AWADDR),
		.master_prot_o(HP_AWPROT),
		.master_region_o(HP_AWREGION),
		.master_len_o(HP_AWLEN),
		.master_size_o(HP_AWSIZE),
		.master_burst_o(HP_AWBURST),
		.master_lock_o(HP_AWLOCK),
		.master_cache_o(HP_AWCACHE),
		.master_qos_o(HP_AWQOS),
		.master_id_o(HP_AWID),
		.master_user_o(HP_AWUSER),
		.master_ready_i(HP_AWREADY)
	);
	axi_ar_buffer #(
		.ID_WIDTH(AXI4_ID_WIDTH),
		.ADDR_WIDTH(AXI4_ADDRESS_WIDTH),
		.USER_WIDTH(AXI4_USER_WIDTH),
		.BUFFER_DEPTH(BUFF_DEPTH_SLAVE)
	) Slave_ar_buffer_HP(
		.clk_i(ACLK),
		.rst_ni(ARESETn),
		.test_en_i(test_en_i),
		.slave_valid_i(HP_ARVALID_i),
		.slave_addr_i(HP_ARADDR_i),
		.slave_prot_i(HP_ARPROT_i),
		.slave_region_i(HP_ARREGION_i),
		.slave_len_i(HP_ARLEN_i),
		.slave_size_i(HP_ARSIZE_i),
		.slave_burst_i(HP_ARBURST_i),
		.slave_lock_i(HP_ARLOCK_i),
		.slave_cache_i(HP_ARCACHE_i),
		.slave_qos_i(HP_ARQOS_i),
		.slave_id_i(HP_ARID_i),
		.slave_user_i(HP_ARUSER_i),
		.slave_ready_o(HP_ARREADY_o),
		.master_valid_o(HP_ARVALID),
		.master_addr_o(HP_ARADDR),
		.master_prot_o(HP_ARPROT),
		.master_region_o(HP_ARREGION),
		.master_len_o(HP_ARLEN),
		.master_size_o(HP_ARSIZE),
		.master_burst_o(HP_ARBURST),
		.master_lock_o(HP_ARLOCK),
		.master_cache_o(HP_ARCACHE),
		.master_qos_o(HP_ARQOS),
		.master_id_o(HP_ARID),
		.master_user_o(HP_ARUSER),
		.master_ready_i(HP_ARREADY)
	);
	axi_w_buffer #(
		.DATA_WIDTH(AXI4_WDATA_WIDTH),
		.USER_WIDTH(AXI4_USER_WIDTH),
		.BUFFER_DEPTH(BUFF_DEPTH_SLAVE)
	) Slave_w_buffer_HP(
		.clk_i(ACLK),
		.rst_ni(ARESETn),
		.test_en_i(test_en_i),
		.slave_valid_i(HP_WVALID_i),
		.slave_data_i(HP_WDATA_i),
		.slave_strb_i(HP_WSTRB_i),
		.slave_user_i(HP_WUSER_i),
		.slave_last_i(HP_WLAST_i),
		.slave_ready_o(HP_WREADY_o),
		.master_valid_o(HP_WVALID),
		.master_data_o(HP_WDATA),
		.master_strb_o(HP_WSTRB),
		.master_user_o(HP_WUSER),
		.master_last_o(HP_WLAST),
		.master_ready_i(HP_WREADY)
	);
	axi_r_buffer #(
		.ID_WIDTH(AXI4_ID_WIDTH),
		.DATA_WIDTH(AXI4_RDATA_WIDTH),
		.USER_WIDTH(AXI4_USER_WIDTH),
		.BUFFER_DEPTH(BUFF_DEPTH_SLAVE)
	) Slave_r_buffer_HP(
		.clk_i(ACLK),
		.rst_ni(ARESETn),
		.test_en_i(test_en_i),
		.slave_valid_i(HP_RVALID),
		.slave_data_i(HP_RDATA),
		.slave_resp_i(HP_RRESP),
		.slave_user_i(HP_RUSER),
		.slave_id_i(HP_RID),
		.slave_last_i(HP_RLAST),
		.slave_ready_o(HP_RREADY),
		.master_valid_o(HP_RVALID_o),
		.master_data_o(HP_RDATA_o),
		.master_resp_o(HP_RRESP_o),
		.master_user_o(HP_RUSER_o),
		.master_id_o(HP_RID_o),
		.master_last_o(HP_RLAST_o),
		.master_ready_i(HP_RREADY_i)
	);
	axi_b_buffer #(
		.ID_WIDTH(AXI4_ID_WIDTH),
		.USER_WIDTH(AXI4_USER_WIDTH),
		.BUFFER_DEPTH(BUFF_DEPTH_SLAVE)
	) Slave_b_buffer_HP(
		.clk_i(ACLK),
		.rst_ni(ARESETn),
		.test_en_i(test_en_i),
		.slave_valid_i(HP_BVALID),
		.slave_resp_i(HP_BRESP),
		.slave_id_i(HP_BID),
		.slave_user_i(HP_BUSER),
		.slave_ready_o(HP_BREADY),
		.master_valid_o(HP_BVALID_o),
		.master_resp_o(HP_BRESP_o),
		.master_id_o(HP_BID_o),
		.master_user_o(HP_BUSER_o),
		.master_ready_i(HP_BREADY_i)
	);
	axi_write_only_ctrl #(
		.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),
		.AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH),
		.AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH),
		.AXI4_ID_WIDTH(AXI4_ID_WIDTH),
		.AXI4_USER_WIDTH(AXI4_USER_WIDTH),
		.AXI_NUMBYTES(AXI_NUMBYTES),
		.MEM_ADDR_WIDTH(MEM_ADDR_WIDTH)
	) W_CTRL_HP(
		.clk(ACLK),
		.rst_n(ARESETn),
		.AWID_i(HP_AWID),
		.AWADDR_i(HP_AWADDR),
		.AWLEN_i(HP_AWLEN),
		.AWSIZE_i(HP_AWSIZE),
		.AWBURST_i(HP_AWBURST),
		.AWLOCK_i(HP_AWLOCK),
		.AWCACHE_i(HP_AWCACHE),
		.AWPROT_i(HP_AWPROT),
		.AWREGION_i(HP_AWREGION),
		.AWUSER_i(HP_AWUSER),
		.AWQOS_i(HP_AWQOS),
		.AWVALID_i(HP_AWVALID),
		.AWREADY_o(HP_AWREADY),
		.WDATA_i(HP_WDATA),
		.WSTRB_i(HP_WSTRB),
		.WLAST_i(HP_WLAST),
		.WUSER_i(HP_WUSER),
		.WVALID_i(HP_WVALID),
		.WREADY_o(HP_WREADY),
		.BID_o(HP_BID),
		.BRESP_o(HP_BRESP),
		.BVALID_o(HP_BVALID),
		.BUSER_o(HP_BUSER),
		.BREADY_i(HP_BREADY),
		.MEM_CEN_o(HP_W_cen),
		.MEM_WEN_o(HP_W_wen),
		.MEM_A_o(HP_W_addr),
		.MEM_D_o(HP_wdata),
		.MEM_BE_o(HP_be),
		.MEM_Q_i(1'sb0),
		.grant_i(grant_W_HP),
		.valid_o(valid_W_HP)
	);
	axi_read_only_ctrl #(
		.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),
		.AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH),
		.AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH),
		.AXI4_ID_WIDTH(AXI4_ID_WIDTH),
		.AXI4_USER_WIDTH(AXI4_USER_WIDTH),
		.AXI_NUMBYTES(AXI_NUMBYTES),
		.MEM_ADDR_WIDTH(MEM_ADDR_WIDTH)
	) R_CTRL_HP(
		.clk(ACLK),
		.rst_n(ARESETn),
		.ARID_i(HP_ARID),
		.ARADDR_i(HP_ARADDR),
		.ARLEN_i(HP_ARLEN),
		.ARSIZE_i(HP_ARSIZE),
		.ARBURST_i(HP_ARBURST),
		.ARLOCK_i(HP_ARLOCK),
		.ARCACHE_i(HP_ARCACHE),
		.ARPROT_i(HP_ARPROT),
		.ARREGION_i(HP_ARREGION),
		.ARUSER_i(HP_ARUSER),
		.ARQOS_i(HP_ARQOS),
		.ARVALID_i(HP_ARVALID),
		.ARREADY_o(HP_ARREADY),
		.RID_o(HP_RID),
		.RDATA_o(HP_RDATA),
		.RRESP_o(HP_RRESP),
		.RLAST_o(HP_RLAST),
		.RUSER_o(HP_RUSER),
		.RVALID_o(HP_RVALID),
		.RREADY_i(HP_RREADY),
		.MEM_CEN_o(HP_R_cen),
		.MEM_WEN_o(HP_R_wen),
		.MEM_A_o(HP_R_addr),
		.MEM_D_o(),
		.MEM_BE_o(),
		.MEM_Q_i(Q),
		.grant_i(grant_R_HP),
		.valid_o(valid_R_HP)
	);
	axi_write_only_ctrl #(
		.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),
		.AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH),
		.AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH),
		.AXI4_ID_WIDTH(AXI4_ID_WIDTH),
		.AXI4_USER_WIDTH(AXI4_USER_WIDTH),
		.AXI_NUMBYTES(AXI_NUMBYTES),
		.MEM_ADDR_WIDTH(MEM_ADDR_WIDTH)
	) W_CTRL_LP(
		.clk(ACLK),
		.rst_n(ARESETn),
		.AWID_i(LP_AWID),
		.AWADDR_i(LP_AWADDR),
		.AWLEN_i(LP_AWLEN),
		.AWSIZE_i(LP_AWSIZE),
		.AWBURST_i(LP_AWBURST),
		.AWLOCK_i(LP_AWLOCK),
		.AWCACHE_i(LP_AWCACHE),
		.AWPROT_i(LP_AWPROT),
		.AWREGION_i(LP_AWREGION),
		.AWUSER_i(LP_AWUSER),
		.AWQOS_i(LP_AWQOS),
		.AWVALID_i(LP_AWVALID),
		.AWREADY_o(LP_AWREADY),
		.WDATA_i(LP_WDATA),
		.WSTRB_i(LP_WSTRB),
		.WLAST_i(LP_WLAST),
		.WUSER_i(LP_WUSER),
		.WVALID_i(LP_WVALID),
		.WREADY_o(LP_WREADY),
		.BID_o(LP_BID),
		.BRESP_o(LP_BRESP),
		.BVALID_o(LP_BVALID),
		.BUSER_o(LP_BUSER),
		.BREADY_i(LP_BREADY),
		.MEM_CEN_o(LP_W_cen),
		.MEM_WEN_o(LP_W_wen),
		.MEM_A_o(LP_W_addr),
		.MEM_D_o(LP_wdata),
		.MEM_BE_o(LP_be),
		.MEM_Q_i(1'sb0),
		.grant_i(grant_W_LP),
		.valid_o(valid_W_LP)
	);
	axi_read_only_ctrl #(
		.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),
		.AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH),
		.AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH),
		.AXI4_ID_WIDTH(AXI4_ID_WIDTH),
		.AXI4_USER_WIDTH(AXI4_USER_WIDTH),
		.AXI_NUMBYTES(AXI_NUMBYTES),
		.MEM_ADDR_WIDTH(MEM_ADDR_WIDTH)
	) R_CTRL_LP(
		.clk(ACLK),
		.rst_n(ARESETn),
		.ARID_i(LP_ARID),
		.ARADDR_i(LP_ARADDR),
		.ARLEN_i(LP_ARLEN),
		.ARSIZE_i(LP_ARSIZE),
		.ARBURST_i(LP_ARBURST),
		.ARLOCK_i(LP_ARLOCK),
		.ARCACHE_i(LP_ARCACHE),
		.ARPROT_i(LP_ARPROT),
		.ARREGION_i(LP_ARREGION),
		.ARUSER_i(LP_ARUSER),
		.ARQOS_i(LP_ARQOS),
		.ARVALID_i(LP_ARVALID),
		.ARREADY_o(LP_ARREADY),
		.RID_o(LP_RID),
		.RDATA_o(LP_RDATA),
		.RRESP_o(LP_RRESP),
		.RLAST_o(LP_RLAST),
		.RUSER_o(LP_RUSER),
		.RVALID_o(LP_RVALID),
		.RREADY_i(LP_RREADY),
		.MEM_CEN_o(LP_R_cen),
		.MEM_WEN_o(LP_R_wen),
		.MEM_A_o(LP_R_addr),
		.MEM_D_o(),
		.MEM_BE_o(),
		.MEM_Q_i(Q),
		.grant_i(grant_R_LP),
		.valid_o(valid_R_LP)
	);
	always @(*) begin : _MUX_MEM_
		if (valid_R_HP & grant_R_HP) begin
			HP_cen = HP_R_cen;
			HP_wen = 1'b1;
			HP_addr = HP_R_addr;
		end
		else begin
			HP_cen = HP_W_cen;
			HP_wen = 1'b0;
			HP_addr = HP_W_addr;
		end
		if (valid_R_LP & grant_R_LP) begin
			LP_cen = LP_R_cen;
			LP_wen = 1'b1;
			LP_addr = LP_R_addr;
		end
		else begin
			LP_cen = LP_W_cen;
			LP_wen = 1'b0;
			LP_addr = LP_W_addr;
		end
		if ((valid_R_HP | valid_W_HP) & main_grant_HP) begin
			CEN = HP_cen;
			WEN = HP_wen;
			A = HP_addr;
			D = HP_wdata;
			BE = HP_be;
		end
		else begin
			CEN = LP_cen;
			WEN = LP_wen;
			A = LP_addr;
			D = LP_wdata;
			BE = LP_be;
		end
	end
	always @(posedge ACLK or negedge ARESETn) begin : MUX_RDATA_MEM
		if (~ARESETn)
			destination <= 1'sb0;
		else if (valid_R_HP & main_grant_HP)
			destination <= 1'b1;
		else
			destination <= 1'b0;
	end
	always @(posedge ACLK or negedge ARESETn)
		if (~ARESETn)
			RR_FLAG_HP <= 0;
		else
			RR_FLAG_HP <= ~RR_FLAG_HP;
	always @(posedge ACLK or negedge ARESETn)
		if (~ARESETn)
			RR_FLAG_LP <= 0;
		else
			RR_FLAG_LP <= ~RR_FLAG_LP;
	always @(*) begin
		grant_R_HP = 1'b0;
		grant_W_HP = 1'b0;
		case (RR_FLAG_HP)
			1'b0:
				if (valid_W_HP)
					grant_W_HP = main_grant_HP;
				else
					grant_R_HP = main_grant_HP;
			1'b1:
				if (valid_R_HP)
					grant_R_HP = main_grant_HP;
				else
					grant_W_HP = main_grant_HP;
		endcase
	end
	always @(*) begin
		grant_R_LP = 1'b0;
		grant_W_LP = 1'b0;
		case (RR_FLAG_LP)
			1'b0:
				if (valid_W_LP)
					grant_W_LP = main_grant_LP;
				else
					grant_R_LP = main_grant_LP;
			1'b1:
				if (valid_R_LP)
					grant_R_LP = main_grant_LP;
				else
					grant_W_LP = main_grant_LP;
		endcase
	end
	always @(*) begin
		main_grant_LP = 1'b0;
		main_grant_HP = 1'b0;
		if (valid_R_HP | valid_W_HP)
			main_grant_HP = 1'b1;
		else
			main_grant_LP = 1'b1;
	end
endmodule
