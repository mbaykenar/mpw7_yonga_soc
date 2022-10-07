module axi_mem_if_DP_hybr 
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
	HP_cen_i,
	HP_wen_i,
	HP_addr_i,
	HP_wdata_i,
	HP_be_i,
	HP_Q_o,
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
	input wire HP_cen_i;
	input wire HP_wen_i;
	input wire [MEM_ADDR_WIDTH - 1:0] HP_addr_i;
	input wire [AXI4_WDATA_WIDTH - 1:0] HP_wdata_i;
	input wire [AXI_NUMBYTES - 1:0] HP_be_i;
	output wire [AXI4_RDATA_WIDTH - 1:0] HP_Q_o;
	output reg CEN;
	output reg WEN;
	output reg [MEM_ADDR_WIDTH - 1:0] A;
	output reg [AXI4_WDATA_WIDTH - 1:0] D;
	output reg [AXI_NUMBYTES - 1:0] BE;
	input wire [AXI4_RDATA_WIDTH - 1:0] Q;
	localparam OFFSET_BIT = $clog2(AXI4_WDATA_WIDTH) - 3;
	wire [AXI4_ID_WIDTH - 1:0] LP_AWID;
	wire [AXI4_ADDRESS_WIDTH - 1:0] LP_AWADDR;
	wire [7:0] LP_AWLEN;
	wire [2:0] LP_AWSIZE;
	wire [1:0] LP_AWBURST;
	wire LP_AWLOCK;
	wire [3:0] LP_AWCACHE;
	wire [2:0] LP_AWPROT;
	wire [3:0] LP_AWREGION;
	wire [AXI4_USER_WIDTH - 1:0] LP_AWUSER;
	wire [3:0] LP_AWQOS;
	wire LP_AWVALID;
	wire LP_AWREADY;
	wire [(AXI_NUMBYTES * 8) - 1:0] LP_WDATA;
	wire [AXI_NUMBYTES - 1:0] LP_WSTRB;
	wire LP_WLAST;
	wire [AXI4_USER_WIDTH - 1:0] LP_WUSER;
	wire LP_WVALID;
	wire LP_WREADY;
	wire [AXI4_ID_WIDTH - 1:0] LP_BID;
	wire [1:0] LP_BRESP;
	wire LP_BVALID;
	wire [AXI4_USER_WIDTH - 1:0] LP_BUSER;
	wire LP_BREADY;
	wire [AXI4_ID_WIDTH - 1:0] LP_ARID;
	wire [AXI4_ADDRESS_WIDTH - 1:0] LP_ARADDR;
	wire [7:0] LP_ARLEN;
	wire [2:0] LP_ARSIZE;
	wire [1:0] LP_ARBURST;
	wire LP_ARLOCK;
	wire [3:0] LP_ARCACHE;
	wire [2:0] LP_ARPROT;
	wire [3:0] LP_ARREGION;
	wire [AXI4_USER_WIDTH - 1:0] LP_ARUSER;
	wire [3:0] LP_ARQOS;
	wire LP_ARVALID;
	wire LP_ARREADY;
	wire [AXI4_ID_WIDTH - 1:0] LP_RID;
	wire [AXI4_RDATA_WIDTH - 1:0] LP_RDATA;
	wire [1:0] LP_RRESP;
	wire LP_RLAST;
	wire [AXI4_USER_WIDTH - 1:0] LP_RUSER;
	wire LP_RVALID;
	wire LP_RREADY;
	wire valid_R_LP;
	wire valid_W_LP;
	reg grant_R_LP;
	reg grant_W_LP;
	reg RR_FLAG_LP;
	reg main_grant_LP;
	wire LP_W_cen;
	wire LP_R_cen;
	reg LP_cen;
	wire LP_W_wen;
	wire LP_R_wen;
	reg LP_wen;
	wire [MEM_ADDR_WIDTH - 1:0] LP_W_addr;
	wire [MEM_ADDR_WIDTH - 1:0] LP_R_addr;
	reg [MEM_ADDR_WIDTH - 1:0] LP_addr;
	wire [AXI4_WDATA_WIDTH - 1:0] LP_W_wdata;
	wire [AXI4_WDATA_WIDTH - 1:0] LP_R_wdata;
	wire [AXI4_WDATA_WIDTH - 1:0] LP_wdata;
	wire [AXI_NUMBYTES - 1:0] LP_W_be;
	wire [AXI_NUMBYTES - 1:0] LP_R_be;
	wire [AXI_NUMBYTES - 1:0] LP_be;
	wire [AXI_NUMBYTES - 1:0] LP_W_rdata;
	wire [AXI_NUMBYTES - 1:0] LP_R_rdata;
	wire [AXI_NUMBYTES - 1:0] LP_rdata;
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
		.MEM_D_o(LP_W_wdata),
		.MEM_BE_o(LP_W_be),
		.MEM_Q_i(1'sb0),
		.grant_i(grant_W_LP & HP_cen_i),
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
		.grant_i(grant_R_LP & HP_cen_i),
		.valid_o(valid_R_LP)
	);
	assign LP_wdata = LP_W_wdata;
	assign LP_be = LP_W_be;
	always @(*) begin : _MUX_MEM_
		if (HP_cen_i == 1'b0) begin
			CEN = HP_cen_i;
			WEN = HP_wen_i;
			A = HP_addr_i;
			D = HP_wdata_i;
			BE = HP_be_i;
		end
		else begin
			if (grant_R_LP) begin
				LP_cen = LP_R_cen;
				LP_wen = 1'b1;
				LP_addr = LP_R_addr;
			end
			else begin
				LP_cen = LP_W_cen;
				LP_wen = ~grant_W_LP;
				LP_addr = LP_W_addr;
			end
			CEN = LP_cen;
			WEN = LP_wen;
			A = LP_addr;
			D = LP_W_wdata;
			BE = LP_W_be;
		end
	end
	always @(posedge ACLK or negedge ARESETn)
		if (~ARESETn)
			RR_FLAG_LP <= 0;
		else
			RR_FLAG_LP <= ~RR_FLAG_LP;
	always @(*) begin
		grant_R_LP = 1'b0;
		grant_W_LP = 1'b0;
		case (RR_FLAG_LP)
			1'b0:
				if (valid_W_LP)
					grant_W_LP = 1'b1;
				else
					grant_R_LP = 1'b1;
			1'b1:
				if (valid_R_LP)
					grant_R_LP = 1'b1;
				else
					grant_W_LP = 1'b1;
		endcase
	end
	always @(*) begin
		main_grant_LP = 1'b0;
		if (HP_cen_i == 1'b1)
			main_grant_LP = 1'b1;
	end
	assign HP_Q_o = Q;
endmodule
