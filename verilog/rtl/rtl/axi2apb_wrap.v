module axi2apb_wrap 
#(
    parameter AXI_ADDR_WIDTH   = 32,
    parameter AXI_DATA_WIDTH   = 32,
    parameter AXI_USER_WIDTH   = 6,
    parameter AXI_ID_WIDTH     = 6,
    parameter APB_ADDR_WIDTH   = 32
)
(
	clk_i,
	rst_ni,
	test_en_i,
	s00_aw_addr,
	s00_aw_prot,
	s00_aw_region,
	s00_aw_len,
	s00_aw_size,
	s00_aw_burst,
	s00_aw_lock,
	s00_aw_cache,
	s00_aw_qos,
	s00_aw_id,
	s00_aw_user,
	s00_aw_ready,
	s00_aw_valid,
	s00_ar_addr,
	s00_ar_prot,
	s00_ar_region,
	s00_ar_len,
	s00_ar_size,
	s00_ar_burst,
	s00_ar_lock,
	s00_ar_cache,
	s00_ar_qos,
	s00_ar_id,
	s00_ar_user,
	s00_ar_ready,
	s00_ar_valid,
	s00_w_valid,
	s00_w_data,
	s00_w_strb,
	s00_w_user,
	s00_w_last,
	s00_w_ready,
	s00_r_data,
	s00_r_resp,
	s00_r_last,
	s00_r_id,
	s00_r_user,
	s00_r_ready,
	s00_r_valid,
	s00_b_resp,
	s00_b_id,
	s00_b_user,
	s00_b_ready,
	s00_b_valid,
	m00_paddr,
	m00_pwdata,
	m00_pwrite,
	m00_psel,
	m00_penable,
	m00_prdata,
	m00_pready,
	m00_pslverr
);
	//parameter AXI_ADDR_WIDTH = 32;
	//parameter AXI_DATA_WIDTH = 32;
	//parameter AXI_USER_WIDTH = 6;
	//parameter AXI_ID_WIDTH = 6;
	//parameter APB_ADDR_WIDTH = 32;
	parameter AXI_STRB_WIDTH = AXI_DATA_WIDTH / 8;
	parameter APB_DATA_WIDTH = 32;
	input wire clk_i;
	input wire rst_ni;
	input wire test_en_i;
	input wire [AXI_ADDR_WIDTH - 1:0] s00_aw_addr;
	input wire [2:0] s00_aw_prot;
	input wire [3:0] s00_aw_region;
	input wire [7:0] s00_aw_len;
	input wire [2:0] s00_aw_size;
	input wire [1:0] s00_aw_burst;
	input wire s00_aw_lock;
	input wire [3:0] s00_aw_cache;
	input wire [3:0] s00_aw_qos;
	input wire [AXI_ID_WIDTH - 1:0] s00_aw_id;
	input wire [AXI_USER_WIDTH - 1:0] s00_aw_user;
	output wire s00_aw_ready;
	input wire s00_aw_valid;
	input wire [AXI_ADDR_WIDTH - 1:0] s00_ar_addr;
	input wire [2:0] s00_ar_prot;
	input wire [3:0] s00_ar_region;
	input wire [7:0] s00_ar_len;
	input wire [2:0] s00_ar_size;
	input wire [1:0] s00_ar_burst;
	input wire s00_ar_lock;
	input wire [3:0] s00_ar_cache;
	input wire [3:0] s00_ar_qos;
	input wire [AXI_ID_WIDTH - 1:0] s00_ar_id;
	input wire [AXI_USER_WIDTH - 1:0] s00_ar_user;
	output wire s00_ar_ready;
	input wire s00_ar_valid;
	input wire s00_w_valid;
	input wire [AXI_DATA_WIDTH - 1:0] s00_w_data;
	input wire [AXI_STRB_WIDTH - 1:0] s00_w_strb;
	input wire [AXI_USER_WIDTH - 1:0] s00_w_user;
	input wire s00_w_last;
	output wire s00_w_ready;
	output wire [AXI_DATA_WIDTH - 1:0] s00_r_data;
	output wire [1:0] s00_r_resp;
	output wire s00_r_last;
	output wire [AXI_ID_WIDTH - 1:0] s00_r_id;
	output wire [AXI_USER_WIDTH - 1:0] s00_r_user;
	input wire s00_r_ready;
	output wire s00_r_valid;
	output wire [1:0] s00_b_resp;
	output wire [AXI_ID_WIDTH - 1:0] s00_b_id;
	output wire [AXI_USER_WIDTH - 1:0] s00_b_user;
	input wire s00_b_ready;
	output wire s00_b_valid;
	output wire [APB_ADDR_WIDTH - 1:0] m00_paddr;
	output wire [APB_DATA_WIDTH - 1:0] m00_pwdata;
	output wire m00_pwrite;
	output wire m00_psel;
	output wire m00_penable;
	input wire [APB_DATA_WIDTH - 1:0] m00_prdata;
	input wire m00_pready;
	input wire m00_pslverr;
	generate
		if (AXI_DATA_WIDTH == 32) begin : genblk1
			axi2apb32 #(
				.AXI4_ADDRESS_WIDTH(AXI_ADDR_WIDTH),
				.AXI4_RDATA_WIDTH(AXI_DATA_WIDTH),
				.AXI4_WDATA_WIDTH(AXI_DATA_WIDTH),
				.AXI4_ID_WIDTH(AXI_ID_WIDTH),
				.AXI4_USER_WIDTH(1),
				.BUFF_DEPTH_SLAVE(2),
				.APB_ADDR_WIDTH(APB_ADDR_WIDTH)
			) axi2apb_i(
				.ACLK(clk_i),
				.ARESETn(rst_ni),
				.test_en_i(test_en_i),
				.AWID_i(s00_aw_id),
				.AWADDR_i(s00_aw_addr),
				.AWLEN_i(s00_aw_len),
				.AWSIZE_i(s00_aw_size),
				.AWBURST_i(s00_aw_burst),
				.AWLOCK_i(s00_aw_lock),
				.AWCACHE_i(s00_aw_cache),
				.AWPROT_i(s00_aw_prot),
				.AWREGION_i(s00_aw_region),
				.AWUSER_i(s00_aw_user),
				.AWQOS_i(s00_aw_qos),
				.AWVALID_i(s00_aw_valid),
				.AWREADY_o(s00_aw_ready),
				.WDATA_i(s00_w_data),
				.WSTRB_i(s00_w_strb),
				.WLAST_i(s00_w_last),
				.WUSER_i(s00_w_user),
				.WVALID_i(s00_w_valid),
				.WREADY_o(s00_w_ready),
				.BID_o(s00_b_id),
				.BRESP_o(s00_b_resp),
				.BVALID_o(s00_b_valid),
				.BUSER_o(s00_b_user),
				.BREADY_i(s00_b_ready),
				.ARID_i(s00_ar_id),
				.ARADDR_i(s00_ar_addr),
				.ARLEN_i(s00_ar_len),
				.ARSIZE_i(s00_ar_size),
				.ARBURST_i(s00_ar_burst),
				.ARLOCK_i(s00_ar_lock),
				.ARCACHE_i(s00_ar_cache),
				.ARPROT_i(s00_ar_prot),
				.ARREGION_i(s00_ar_region),
				.ARUSER_i(s00_ar_user),
				.ARQOS_i(s00_ar_qos),
				.ARVALID_i(s00_ar_valid),
				.ARREADY_o(s00_ar_ready),
				.RID_o(s00_r_id),
				.RDATA_o(s00_r_data),
				.RRESP_o(s00_r_resp),
				.RLAST_o(s00_r_last),
				.RUSER_o(s00_r_user),
				.RVALID_o(s00_r_valid),
				.RREADY_i(s00_r_ready),
				.PENABLE(m00_penable),
				.PWRITE(m00_pwrite),
				.PADDR(m00_paddr),
				.PSEL(m00_psel),
				.PWDATA(m00_pwdata),
				.PRDATA(m00_prdata),
				.PREADY(m00_pready),
				.PSLVERR(m00_pslverr)
			);
		end
		else if (AXI_DATA_WIDTH == 64) begin : genblk1
			axi2apb #(
				.AXI4_ADDRESS_WIDTH(AXI_ADDR_WIDTH),
				.AXI4_RDATA_WIDTH(AXI_DATA_WIDTH),
				.AXI4_WDATA_WIDTH(AXI_DATA_WIDTH),
				.AXI4_ID_WIDTH(AXI_ID_WIDTH),
				.AXI4_USER_WIDTH(1),
				.BUFF_DEPTH_SLAVE(2),
				.APB_ADDR_WIDTH(APB_ADDR_WIDTH)
			) axi2apb_i(
				.ACLK(clk_i),
				.ARESETn(rst_ni),
				.test_en_i(test_en_i),
				.AWID_i(s00_aw_id),
				.AWADDR_i(s00_aw_addr),
				.AWLEN_i(s00_aw_len),
				.AWSIZE_i(s00_aw_size),
				.AWBURST_i(s00_aw_burst),
				.AWLOCK_i(s00_aw_lock),
				.AWCACHE_i(s00_aw_cache),
				.AWPROT_i(s00_aw_prot),
				.AWREGION_i(s00_aw_region),
				.AWUSER_i(s00_aw_user),
				.AWQOS_i(s00_aw_qos),
				.AWVALID_i(s00_aw_valid),
				.AWREADY_o(s00_aw_ready),
				.WDATA_i(s00_w_data),
				.WSTRB_i(s00_w_strb),
				.WLAST_i(s00_w_last),
				.WUSER_i(s00_w_user),
				.WVALID_i(s00_w_valid),
				.WREADY_o(s00_w_ready),
				.BID_o(s00_b_id),
				.BRESP_o(s00_b_resp),
				.BVALID_o(s00_b_valid),
				.BUSER_o(s00_b_user),
				.BREADY_i(s00_b_ready),
				.ARID_i(s00_ar_id),
				.ARADDR_i(s00_ar_addr),
				.ARLEN_i(s00_ar_len),
				.ARSIZE_i(s00_ar_size),
				.ARBURST_i(s00_ar_burst),
				.ARLOCK_i(s00_ar_lock),
				.ARCACHE_i(s00_ar_cache),
				.ARPROT_i(s00_ar_prot),
				.ARREGION_i(s00_ar_region),
				.ARUSER_i(s00_ar_user),
				.ARQOS_i(s00_ar_qos),
				.ARVALID_i(s00_ar_valid),
				.ARREADY_o(s00_ar_ready),
				.RID_o(s00_r_id),
				.RDATA_o(s00_r_data),
				.RRESP_o(s00_r_resp),
				.RLAST_o(s00_r_last),
				.RUSER_o(s00_r_user),
				.RVALID_o(s00_r_valid),
				.RREADY_i(s00_r_ready),
				.PENABLE(m00_penable),
				.PWRITE(m00_pwrite),
				.PADDR(m00_paddr),
				.PSEL(m00_psel),
				.PWDATA(m00_pwdata),
				.PRDATA(m00_prdata),
				.PREADY(m00_pready),
				.PSLVERR(m00_pslverr)
			);
		end
	endgenerate
endmodule
