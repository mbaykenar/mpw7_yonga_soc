module AXI_2_APB_32 
#(
    parameter AXI4_ADDRESS_WIDTH = 32,
    parameter AXI4_RDATA_WIDTH   = 32,
    parameter AXI4_WDATA_WIDTH   = 32,
    parameter AXI4_ID_WIDTH      = 16,
    parameter AXI4_USER_WIDTH    = 10,
    parameter AXI_NUMBYTES       = AXI4_WDATA_WIDTH/8,

    parameter BUFF_DEPTH_SLAVE   = 4,
    parameter APB_NUM_SLAVES     = 8,
    parameter APB_ADDR_WIDTH     = 12  //APB slaves are 4KB by default
)
(
	ACLK,
	ARESETn,
	test_en_i,
	AWID_i,
	AWADDR_i,
	AWLEN_i,
	AWSIZE_i,
	AWBURST_i,
	AWLOCK_i,
	AWCACHE_i,
	AWPROT_i,
	AWREGION_i,
	AWUSER_i,
	AWQOS_i,
	AWVALID_i,
	AWREADY_o,
	WDATA_i,
	WSTRB_i,
	WLAST_i,
	WUSER_i,
	WVALID_i,
	WREADY_o,
	BID_o,
	BRESP_o,
	BVALID_o,
	BUSER_o,
	BREADY_i,
	ARID_i,
	ARADDR_i,
	ARLEN_i,
	ARSIZE_i,
	ARBURST_i,
	ARLOCK_i,
	ARCACHE_i,
	ARPROT_i,
	ARREGION_i,
	ARUSER_i,
	ARQOS_i,
	ARVALID_i,
	ARREADY_o,
	RID_o,
	RDATA_o,
	RRESP_o,
	RLAST_o,
	RUSER_o,
	RVALID_o,
	RREADY_i,
	PENABLE,
	PWRITE,
	PADDR,
	PSEL,
	PWDATA,
	PRDATA,
	PREADY,
	PSLVERR
);
	//parameter AXI4_ADDRESS_WIDTH = 32;
	//parameter AXI4_RDATA_WIDTH = 32;
	//parameter AXI4_WDATA_WIDTH = 32;
	//parameter AXI4_ID_WIDTH = 16;
	//parameter AXI4_USER_WIDTH = 10;
	//parameter AXI_NUMBYTES = AXI4_WDATA_WIDTH / 8;
	//parameter BUFF_DEPTH_SLAVE = 4;
	//parameter APB_NUM_SLAVES = 8;
	//parameter APB_ADDR_WIDTH = 12;
	input wire ACLK;
	input wire ARESETn;
	input wire test_en_i;
	input wire [AXI4_ID_WIDTH - 1:0] AWID_i;
	input wire [AXI4_ADDRESS_WIDTH - 1:0] AWADDR_i;
	input wire [7:0] AWLEN_i;
	input wire [2:0] AWSIZE_i;
	input wire [1:0] AWBURST_i;
	input wire AWLOCK_i;
	input wire [3:0] AWCACHE_i;
	input wire [2:0] AWPROT_i;
	input wire [3:0] AWREGION_i;
	input wire [AXI4_USER_WIDTH - 1:0] AWUSER_i;
	input wire [3:0] AWQOS_i;
	input wire AWVALID_i;
	output wire AWREADY_o;
	input wire [AXI4_WDATA_WIDTH - 1:0] WDATA_i;
	input wire [AXI_NUMBYTES - 1:0] WSTRB_i;
	input wire WLAST_i;
	input wire [AXI4_USER_WIDTH - 1:0] WUSER_i;
	input wire WVALID_i;
	output wire WREADY_o;
	output wire [AXI4_ID_WIDTH - 1:0] BID_o;
	output wire [1:0] BRESP_o;
	output wire BVALID_o;
	output wire [AXI4_USER_WIDTH - 1:0] BUSER_o;
	input wire BREADY_i;
	input wire [AXI4_ID_WIDTH - 1:0] ARID_i;
	input wire [AXI4_ADDRESS_WIDTH - 1:0] ARADDR_i;
	input wire [7:0] ARLEN_i;
	input wire [2:0] ARSIZE_i;
	input wire [1:0] ARBURST_i;
	input wire ARLOCK_i;
	input wire [3:0] ARCACHE_i;
	input wire [2:0] ARPROT_i;
	input wire [3:0] ARREGION_i;
	input wire [AXI4_USER_WIDTH - 1:0] ARUSER_i;
	input wire [3:0] ARQOS_i;
	input wire ARVALID_i;
	output wire ARREADY_o;
	output wire [AXI4_ID_WIDTH - 1:0] RID_o;
	output wire [AXI4_RDATA_WIDTH - 1:0] RDATA_o;
	output wire [1:0] RRESP_o;
	output wire RLAST_o;
	output wire [AXI4_USER_WIDTH - 1:0] RUSER_o;
	output wire RVALID_o;
	input wire RREADY_i;
	output wire PENABLE;
	output wire PWRITE;
	output wire [APB_ADDR_WIDTH - 1:0] PADDR;
	output reg [APB_NUM_SLAVES - 1:0] PSEL;
	output wire [31:0] PWDATA;
	input wire [(APB_NUM_SLAVES * 32) - 1:0] PRDATA;
	input wire [APB_NUM_SLAVES - 1:0] PREADY;
	input wire [APB_NUM_SLAVES - 1:0] PSLVERR;
	wire [AXI4_ID_WIDTH - 1:0] AWID;
	wire [AXI4_ADDRESS_WIDTH - 1:0] AWADDR;
	wire [7:0] AWLEN;
	wire [2:0] AWSIZE;
	wire [1:0] AWBURST;
	wire AWLOCK;
	wire [3:0] AWCACHE;
	wire [2:0] AWPROT;
	wire [3:0] AWREGION;
	wire [AXI4_USER_WIDTH - 1:0] AWUSER;
	wire [3:0] AWQOS;
	wire AWVALID;
	reg AWREADY;
	wire [AXI4_WDATA_WIDTH - 1:0] WDATA;
	wire [AXI_NUMBYTES - 1:0] WSTRB;
	wire WLAST;
	wire [AXI4_USER_WIDTH - 1:0] WUSER;
	wire WVALID;
	reg WREADY;
	reg [AXI4_ID_WIDTH - 1:0] BID;
	reg [1:0] BRESP;
	reg BVALID;
	reg [AXI4_USER_WIDTH - 1:0] BUSER;
	wire BREADY;
	wire [AXI4_ID_WIDTH - 1:0] ARID;
	wire [AXI4_ADDRESS_WIDTH - 1:0] ARADDR;
	wire [7:0] ARLEN;
	wire [2:0] ARSIZE;
	wire [1:0] ARBURST;
	wire ARLOCK;
	wire [3:0] ARCACHE;
	wire [2:0] ARPROT;
	wire [3:0] ARREGION;
	wire [AXI4_USER_WIDTH - 1:0] ARUSER;
	wire [3:0] ARQOS;
	wire ARVALID;
	reg ARREADY;
	reg [AXI4_ID_WIDTH - 1:0] RID;
	reg [AXI4_RDATA_WIDTH - 1:0] RDATA;
	reg [1:0] RRESP;
	reg RLAST;
	reg [AXI4_USER_WIDTH - 1:0] RUSER;
	reg RVALID;
	wire RREADY;
	reg [2:0] CS;
	reg [2:0] NS;
	reg [($clog2(APB_NUM_SLAVES) + APB_ADDR_WIDTH) - 1:0] address;
	reg sample_RDATA;
	reg [31:0] RDATA_Q;
	reg read_req;
	reg write_req;
	wire [$clog2(APB_NUM_SLAVES) - 1:0] TARGET_SLAVE;
	assign PENABLE = write_req | read_req;
	assign PWRITE = write_req;
	assign PADDR = address[APB_ADDR_WIDTH - 1:0];
	assign PWDATA = WDATA;
	assign TARGET_SLAVE = address[(APB_ADDR_WIDTH + $clog2(APB_NUM_SLAVES)) - 1:APB_ADDR_WIDTH];
	always @(*) begin
		PSEL = 1'sb0;
		PSEL[TARGET_SLAVE] = 1'b1;
	end
	axi_aw_buffer #(
		.ID_WIDTH(AXI4_ID_WIDTH),
		.ADDR_WIDTH(AXI4_ADDRESS_WIDTH),
		.USER_WIDTH(AXI4_USER_WIDTH),
		.BUFFER_DEPTH(BUFF_DEPTH_SLAVE)
	) Slave_aw_buffer(
		.clk_i(ACLK),
		.rst_ni(ARESETn),
		.test_en_i(test_en_i),
		.slave_valid_i(AWVALID_i),
		.slave_addr_i(AWADDR_i),
		.slave_prot_i(AWPROT_i),
		.slave_region_i(AWREGION_i),
		.slave_len_i(AWLEN_i),
		.slave_size_i(AWSIZE_i),
		.slave_burst_i(AWBURST_i),
		.slave_lock_i(AWLOCK_i),
		.slave_cache_i(AWCACHE_i),
		.slave_qos_i(AWQOS_i),
		.slave_id_i(AWID_i),
		.slave_user_i(AWUSER_i),
		.slave_ready_o(AWREADY_o),
		.master_valid_o(AWVALID),
		.master_addr_o(AWADDR),
		.master_prot_o(AWPROT),
		.master_region_o(AWREGION),
		.master_len_o(AWLEN),
		.master_size_o(AWSIZE),
		.master_burst_o(AWBURST),
		.master_lock_o(AWLOCK),
		.master_cache_o(AWCACHE),
		.master_qos_o(AWQOS),
		.master_id_o(AWID),
		.master_user_o(AWUSER),
		.master_ready_i(AWREADY)
	);
	axi_ar_buffer #(
		.ID_WIDTH(AXI4_ID_WIDTH),
		.ADDR_WIDTH(AXI4_ADDRESS_WIDTH),
		.USER_WIDTH(AXI4_USER_WIDTH),
		.BUFFER_DEPTH(BUFF_DEPTH_SLAVE)
	) Slave_ar_buffer(
		.clk_i(ACLK),
		.rst_ni(ARESETn),
		.test_en_i(test_en_i),
		.slave_valid_i(ARVALID_i),
		.slave_addr_i(ARADDR_i),
		.slave_prot_i(ARPROT_i),
		.slave_region_i(ARREGION_i),
		.slave_len_i(ARLEN_i),
		.slave_size_i(ARSIZE_i),
		.slave_burst_i(ARBURST_i),
		.slave_lock_i(ARLOCK_i),
		.slave_cache_i(ARCACHE_i),
		.slave_qos_i(ARQOS_i),
		.slave_id_i(ARID_i),
		.slave_user_i(ARUSER_i),
		.slave_ready_o(ARREADY_o),
		.master_valid_o(ARVALID),
		.master_addr_o(ARADDR),
		.master_prot_o(ARPROT),
		.master_region_o(ARREGION),
		.master_len_o(ARLEN),
		.master_size_o(ARSIZE),
		.master_burst_o(ARBURST),
		.master_lock_o(ARLOCK),
		.master_cache_o(ARCACHE),
		.master_qos_o(ARQOS),
		.master_id_o(ARID),
		.master_user_o(ARUSER),
		.master_ready_i(ARREADY)
	);
	axi_w_buffer #(
		.DATA_WIDTH(AXI4_WDATA_WIDTH),
		.USER_WIDTH(AXI4_USER_WIDTH),
		.BUFFER_DEPTH(BUFF_DEPTH_SLAVE)
	) Slave_w_buffer(
		.clk_i(ACLK),
		.rst_ni(ARESETn),
		.test_en_i(test_en_i),
		.slave_valid_i(WVALID_i),
		.slave_data_i(WDATA_i),
		.slave_strb_i(WSTRB_i),
		.slave_user_i(WUSER_i),
		.slave_last_i(WLAST_i),
		.slave_ready_o(WREADY_o),
		.master_valid_o(WVALID),
		.master_data_o(WDATA),
		.master_strb_o(WSTRB),
		.master_user_o(WUSER),
		.master_last_o(WLAST),
		.master_ready_i(WREADY)
	);
	axi_r_buffer #(
		.ID_WIDTH(AXI4_ID_WIDTH),
		.DATA_WIDTH(AXI4_RDATA_WIDTH),
		.USER_WIDTH(AXI4_USER_WIDTH),
		.BUFFER_DEPTH(BUFF_DEPTH_SLAVE)
	) Slave_r_buffer(
		.clk_i(ACLK),
		.rst_ni(ARESETn),
		.test_en_i(test_en_i),
		.slave_valid_i(RVALID),
		.slave_data_i(RDATA),
		.slave_resp_i(RRESP),
		.slave_user_i(RUSER),
		.slave_id_i(RID),
		.slave_last_i(RLAST),
		.slave_ready_o(RREADY),
		.master_valid_o(RVALID_o),
		.master_data_o(RDATA_o),
		.master_resp_o(RRESP_o),
		.master_user_o(RUSER_o),
		.master_id_o(RID_o),
		.master_last_o(RLAST_o),
		.master_ready_i(RREADY_i)
	);
	axi_b_buffer #(
		.ID_WIDTH(AXI4_ID_WIDTH),
		.USER_WIDTH(AXI4_USER_WIDTH),
		.BUFFER_DEPTH(BUFF_DEPTH_SLAVE)
	) Slave_b_buffer(
		.clk_i(ACLK),
		.rst_ni(ARESETn),
		.test_en_i(test_en_i),
		.slave_valid_i(BVALID),
		.slave_resp_i(BRESP),
		.slave_id_i(BID),
		.slave_user_i(BUSER),
		.slave_ready_o(BREADY),
		.master_valid_o(BVALID_o),
		.master_resp_o(BRESP_o),
		.master_id_o(BID_o),
		.master_user_o(BUSER_o),
		.master_ready_i(BREADY_i)
	);
	always @(posedge ACLK or negedge ARESETn)
		if (ARESETn == 1'b0) begin
			CS <= 3'd0;
			RDATA_Q <= 1'sb0;
		end
		else begin
			CS <= NS;
			if (sample_RDATA)
				RDATA_Q <= PRDATA[TARGET_SLAVE * 32+:32];
		end
	always @(*) begin
		read_req = 1'b0;
		write_req = 1'b0;
		address = 1'sbx;
		sample_RDATA = 1'b0;
		ARREADY = 1'b0;
		AWREADY = 1'b0;
		WREADY = 1'b0;
		BVALID = 1'b0;
		BRESP = 2'b00;
		BID = AWID;
		BUSER = AWUSER;
		RVALID = 1'b0;
		RLAST = 1'b0;
		RID = ARID;
		RUSER = ARUSER;
		RRESP = 2'b00;
		RDATA = RDATA_Q;
		case (CS)
			3'd3: begin
				read_req = 1'b1;
				address = ARADDR[($clog2(APB_NUM_SLAVES) + APB_ADDR_WIDTH) - 1:0];
				sample_RDATA = PREADY[TARGET_SLAVE];
				if (PREADY[TARGET_SLAVE] == 1'b1)
					NS = 3'd1;
				else
					NS = 3'd3;
			end
			3'd2: begin
				write_req = 1'b1;
				address = AWADDR[($clog2(APB_NUM_SLAVES) + APB_ADDR_WIDTH) - 1:0];
				if (PREADY[TARGET_SLAVE] == 1'b1)
					NS = 3'd4;
				else
					NS = 3'd2;
			end
			3'd0:
				if (ARVALID == 1'b1) begin
					read_req = 1'b1;
					address = ARADDR[($clog2(APB_NUM_SLAVES) + APB_ADDR_WIDTH) - 1:0];
					sample_RDATA = PREADY[TARGET_SLAVE];
					if (PREADY[TARGET_SLAVE] == 1'b1)
						NS = 3'd1;
					else
						NS = 3'd3;
				end
				else if (AWVALID) begin
					address = AWADDR[($clog2(APB_NUM_SLAVES) + APB_ADDR_WIDTH) - 1:0];
					if (WVALID) begin
						write_req = 1'b1;
						if (PREADY[TARGET_SLAVE] == 1'b1)
							NS = 3'd4;
						else
							NS = 3'd2;
					end
					else begin
						write_req = 1'b0;
						address = 1'sb0;
						NS = 3'd0;
					end
				end
				else begin
					NS = 3'd0;
					address = 1'sb0;
				end
			3'd4: begin
				BVALID = 1'b1;
				address = 1'sb0;
				if (BREADY) begin
					NS = 3'd0;
					AWREADY = 1'b1;
					WREADY = 1'b1;
				end
				else
					NS = 3'd4;
			end
			3'd1: begin
				RVALID = 1'b1;
				RLAST = 1;
				address = 1'sb0;
				if (RREADY) begin
					NS = 3'd0;
					ARREADY = 1'b1;
				end
				else
					NS = 3'd1;
			end
			default: NS = 3'd0;
		endcase
	end
endmodule
