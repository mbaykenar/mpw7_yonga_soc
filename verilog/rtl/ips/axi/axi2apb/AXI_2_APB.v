`define log2(VALUE) ((VALUE) < ( 1 ) ? 0 : (VALUE) < ( 2 ) ? 1 : (VALUE) < ( 4 ) ? 2 : (VALUE) < ( 8 ) ? 3 : (VALUE) < ( 16 )  ? 4 : (VALUE) < ( 32 )  ? 5 : (VALUE) < ( 64 )  ? 6 : (VALUE) < ( 128 ) ? 7 : (VALUE) < ( 256 ) ? 8 : (VALUE) < ( 512 ) ? 9 : (VALUE) < ( 1024 ) ? 10 : (VALUE) < ( 2048 ) ? 11 : (VALUE) < ( 4096 ) ? 12 : (VALUE) < ( 8192 ) ? 13 : (VALUE) < ( 16384 ) ? 14 : (VALUE) < ( 32768 ) ? 15 : (VALUE) < ( 65536 ) ? 16 : (VALUE) < ( 131072 ) ? 17 : (VALUE) < ( 262144 ) ? 18 : (VALUE) < ( 524288 ) ? 19 : (VALUE) < ( 1048576 ) ? 20 : (VALUE) < ( 1048576 * 2 ) ? 21 : (VALUE) < ( 1048576 * 4 ) ? 22 : (VALUE) < ( 1048576 * 8 ) ? 23 : (VALUE) < ( 1048576 * 16 ) ? 24 : 25)

module AXI_2_APB 
#(
    parameter AXI4_ADDRESS_WIDTH = 32,
    parameter AXI4_RDATA_WIDTH   = 64,
    parameter AXI4_WDATA_WIDTH   = 64,
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
	//parameter AXI4_RDATA_WIDTH = 64;
	//parameter AXI4_WDATA_WIDTH = 64;
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
	input wire [(AXI_NUMBYTES * 8) - 1:0] WDATA_i;
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
	localparam OFFSET_BIT = 2;
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
	wire [63:0] WDATA;
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
	reg [63:0] RDATA;
	reg [1:0] RRESP;
	reg RLAST;
	reg [AXI4_USER_WIDTH - 1:0] RUSER;
	reg RVALID;
	wire RREADY;
	reg [3:0] CS;
	reg [3:0] NS;
	reg W_word_sel;
	reg [(((APB_NUM_SLAVES - 1) < 1 ? 0 : ((APB_NUM_SLAVES - 1) < 2 ? 1 : ((APB_NUM_SLAVES - 1) < 4 ? 2 : ((APB_NUM_SLAVES - 1) < 8 ? 3 : ((APB_NUM_SLAVES - 1) < 16 ? 4 : ((APB_NUM_SLAVES - 1) < 32 ? 5 : ((APB_NUM_SLAVES - 1) < 64 ? 6 : ((APB_NUM_SLAVES - 1) < 128 ? 7 : ((APB_NUM_SLAVES - 1) < 256 ? 8 : ((APB_NUM_SLAVES - 1) < 512 ? 9 : ((APB_NUM_SLAVES - 1) < 1024 ? 10 : ((APB_NUM_SLAVES - 1) < 2048 ? 11 : ((APB_NUM_SLAVES - 1) < 4096 ? 12 : ((APB_NUM_SLAVES - 1) < 8192 ? 13 : ((APB_NUM_SLAVES - 1) < 16384 ? 14 : ((APB_NUM_SLAVES - 1) < 32768 ? 15 : ((APB_NUM_SLAVES - 1) < 65536 ? 16 : ((APB_NUM_SLAVES - 1) < 131072 ? 17 : ((APB_NUM_SLAVES - 1) < 262144 ? 18 : ((APB_NUM_SLAVES - 1) < 524288 ? 19 : ((APB_NUM_SLAVES - 1) < 1048576 ? 20 : ((APB_NUM_SLAVES - 1) < 2097152 ? 21 : ((APB_NUM_SLAVES - 1) < 4194304 ? 22 : ((APB_NUM_SLAVES - 1) < 8388608 ? 23 : ((APB_NUM_SLAVES - 1) < 16777216 ? 24 : 25))))))))))))))))))))))))) + APB_ADDR_WIDTH) - 1:0] address;
	wire [31:0] wdata;
	wire [31:0] rdata;
	reg read_req;
	reg write_req;
	reg sample_AR;
	reg [7:0] ARLEN_Q;
	reg decr_ARLEN;
	reg sample_AW;
	reg [7:0] AWLEN_Q;
	reg decr_AWLEN;
	wire [((APB_NUM_SLAVES - 1) < 1 ? 0 : ((APB_NUM_SLAVES - 1) < 2 ? 1 : ((APB_NUM_SLAVES - 1) < 4 ? 2 : ((APB_NUM_SLAVES - 1) < 8 ? 3 : ((APB_NUM_SLAVES - 1) < 16 ? 4 : ((APB_NUM_SLAVES - 1) < 32 ? 5 : ((APB_NUM_SLAVES - 1) < 64 ? 6 : ((APB_NUM_SLAVES - 1) < 128 ? 7 : ((APB_NUM_SLAVES - 1) < 256 ? 8 : ((APB_NUM_SLAVES - 1) < 512 ? 9 : ((APB_NUM_SLAVES - 1) < 1024 ? 10 : ((APB_NUM_SLAVES - 1) < 2048 ? 11 : ((APB_NUM_SLAVES - 1) < 4096 ? 12 : ((APB_NUM_SLAVES - 1) < 8192 ? 13 : ((APB_NUM_SLAVES - 1) < 16384 ? 14 : ((APB_NUM_SLAVES - 1) < 32768 ? 15 : ((APB_NUM_SLAVES - 1) < 65536 ? 16 : ((APB_NUM_SLAVES - 1) < 131072 ? 17 : ((APB_NUM_SLAVES - 1) < 262144 ? 18 : ((APB_NUM_SLAVES - 1) < 524288 ? 19 : ((APB_NUM_SLAVES - 1) < 1048576 ? 20 : ((APB_NUM_SLAVES - 1) < 2097152 ? 21 : ((APB_NUM_SLAVES - 1) < 4194304 ? 22 : ((APB_NUM_SLAVES - 1) < 8388608 ? 23 : ((APB_NUM_SLAVES - 1) < 16777216 ? 24 : 25))))))))))))))))))))))))) - 1:0] TARGET_SLAVE;
	reg sample_RDATA_0;
	reg sample_RDATA_1;
	reg [31:0] RDATA_Q_0;
	reg [31:0] RDATA_Q_1;
	assign PENABLE = write_req | read_req;
	assign PWRITE = write_req;
	assign PADDR = address[APB_ADDR_WIDTH - 1:0];
	assign PWDATA = WDATA[W_word_sel * 32+:32];
	assign TARGET_SLAVE = address[(APB_ADDR_WIDTH + ((APB_NUM_SLAVES - 1) < 1 ? 0 : ((APB_NUM_SLAVES - 1) < 2 ? 1 : ((APB_NUM_SLAVES - 1) < 4 ? 2 : ((APB_NUM_SLAVES - 1) < 8 ? 3 : ((APB_NUM_SLAVES - 1) < 16 ? 4 : ((APB_NUM_SLAVES - 1) < 32 ? 5 : ((APB_NUM_SLAVES - 1) < 64 ? 6 : ((APB_NUM_SLAVES - 1) < 128 ? 7 : ((APB_NUM_SLAVES - 1) < 256 ? 8 : ((APB_NUM_SLAVES - 1) < 512 ? 9 : ((APB_NUM_SLAVES - 1) < 1024 ? 10 : ((APB_NUM_SLAVES - 1) < 2048 ? 11 : ((APB_NUM_SLAVES - 1) < 4096 ? 12 : ((APB_NUM_SLAVES - 1) < 8192 ? 13 : ((APB_NUM_SLAVES - 1) < 16384 ? 14 : ((APB_NUM_SLAVES - 1) < 32768 ? 15 : ((APB_NUM_SLAVES - 1) < 65536 ? 16 : ((APB_NUM_SLAVES - 1) < 131072 ? 17 : ((APB_NUM_SLAVES - 1) < 262144 ? 18 : ((APB_NUM_SLAVES - 1) < 524288 ? 19 : ((APB_NUM_SLAVES - 1) < 1048576 ? 20 : ((APB_NUM_SLAVES - 1) < 2097152 ? 21 : ((APB_NUM_SLAVES - 1) < 4194304 ? 22 : ((APB_NUM_SLAVES - 1) < 8388608 ? 23 : ((APB_NUM_SLAVES - 1) < 16777216 ? 24 : 25)))))))))))))))))))))))))) - 1:APB_ADDR_WIDTH];
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
			CS <= 4'd0;
			ARLEN_Q <= 1'sb0;
			AWLEN_Q <= 1'sb0;
			RDATA_Q_0 <= 1'sb0;
			RDATA_Q_1 <= 1'sb0;
		end
		else begin
			CS <= NS;
			if (sample_AR)
				ARLEN_Q <= ARLEN + 1;
			else if (decr_ARLEN)
				ARLEN_Q <= ARLEN_Q - 1'b1;
			if (sample_RDATA_0)
				RDATA_Q_0 <= PRDATA[TARGET_SLAVE * 32+:32];
			if (sample_RDATA_1)
				RDATA_Q_1 <= PRDATA[TARGET_SLAVE * 32+:32];
			case ({sample_AW, decr_AWLEN})
				2'b00: AWLEN_Q <= AWLEN_Q;
				2'b01: AWLEN_Q <= AWLEN_Q - 1'b1;
				2'b10: AWLEN_Q <= AWLEN + 1;
				2'b11: AWLEN_Q <= AWLEN;
			endcase
		end
	always @(*) begin
		read_req = 1'b0;
		write_req = 1'b0;
		W_word_sel = 1'b0;
		sample_AW = 1'b0;
		decr_AWLEN = 1'b0;
		sample_AR = 1'b0;
		decr_ARLEN = 1'b0;
		sample_RDATA_0 = 1'b0;
		sample_RDATA_1 = 1'b0;
		ARREADY = 1'b0;
		AWREADY = 1'b0;
		WREADY = 1'b0;
		RDATA = 1'sb0;
		BVALID = 1'b0;
		BRESP = 2'b00;
		BID = AWID;
		BUSER = AWUSER;
		RVALID = 1'b0;
		RLAST = 1'b0;
		RID = ARID;
		RUSER = ARUSER;
		RRESP = 2'b00;
		case (CS)
			4'd11: begin
				sample_AR = 1'b0;
				read_req = 1'b1;
				address = ARADDR[(((APB_NUM_SLAVES - 1) < 1 ? 0 : ((APB_NUM_SLAVES - 1) < 2 ? 1 : ((APB_NUM_SLAVES - 1) < 4 ? 2 : ((APB_NUM_SLAVES - 1) < 8 ? 3 : ((APB_NUM_SLAVES - 1) < 16 ? 4 : ((APB_NUM_SLAVES - 1) < 32 ? 5 : ((APB_NUM_SLAVES - 1) < 64 ? 6 : ((APB_NUM_SLAVES - 1) < 128 ? 7 : ((APB_NUM_SLAVES - 1) < 256 ? 8 : ((APB_NUM_SLAVES - 1) < 512 ? 9 : ((APB_NUM_SLAVES - 1) < 1024 ? 10 : ((APB_NUM_SLAVES - 1) < 2048 ? 11 : ((APB_NUM_SLAVES - 1) < 4096 ? 12 : ((APB_NUM_SLAVES - 1) < 8192 ? 13 : ((APB_NUM_SLAVES - 1) < 16384 ? 14 : ((APB_NUM_SLAVES - 1) < 32768 ? 15 : ((APB_NUM_SLAVES - 1) < 65536 ? 16 : ((APB_NUM_SLAVES - 1) < 131072 ? 17 : ((APB_NUM_SLAVES - 1) < 262144 ? 18 : ((APB_NUM_SLAVES - 1) < 524288 ? 19 : ((APB_NUM_SLAVES - 1) < 1048576 ? 20 : ((APB_NUM_SLAVES - 1) < 2097152 ? 21 : ((APB_NUM_SLAVES - 1) < 4194304 ? 22 : ((APB_NUM_SLAVES - 1) < 8388608 ? 23 : ((APB_NUM_SLAVES - 1) < 16777216 ? 24 : 25))))))))))))))))))))))))) + APB_ADDR_WIDTH) - 1:0];
				if (PREADY[TARGET_SLAVE] == 1'b1) begin
					if (ARLEN == 0)
						case (ARSIZE)
							3: begin
								NS = 4'd2;
								sample_RDATA_0 = 1'b1;
							end
							default: begin
								NS = 4'd1;
								if (ARADDR[2:0] == 4)
									sample_RDATA_1 = 1'b1;
								else
									sample_RDATA_0 = 1'b1;
							end
						endcase
					else begin
						NS = 4'd5;
						sample_RDATA_0 = 1'b1;
					end
				end
				else
					NS = 4'd11;
			end
			4'd12: begin
				address = AWADDR[(((APB_NUM_SLAVES - 1) < 1 ? 0 : ((APB_NUM_SLAVES - 1) < 2 ? 1 : ((APB_NUM_SLAVES - 1) < 4 ? 2 : ((APB_NUM_SLAVES - 1) < 8 ? 3 : ((APB_NUM_SLAVES - 1) < 16 ? 4 : ((APB_NUM_SLAVES - 1) < 32 ? 5 : ((APB_NUM_SLAVES - 1) < 64 ? 6 : ((APB_NUM_SLAVES - 1) < 128 ? 7 : ((APB_NUM_SLAVES - 1) < 256 ? 8 : ((APB_NUM_SLAVES - 1) < 512 ? 9 : ((APB_NUM_SLAVES - 1) < 1024 ? 10 : ((APB_NUM_SLAVES - 1) < 2048 ? 11 : ((APB_NUM_SLAVES - 1) < 4096 ? 12 : ((APB_NUM_SLAVES - 1) < 8192 ? 13 : ((APB_NUM_SLAVES - 1) < 16384 ? 14 : ((APB_NUM_SLAVES - 1) < 32768 ? 15 : ((APB_NUM_SLAVES - 1) < 65536 ? 16 : ((APB_NUM_SLAVES - 1) < 131072 ? 17 : ((APB_NUM_SLAVES - 1) < 262144 ? 18 : ((APB_NUM_SLAVES - 1) < 524288 ? 19 : ((APB_NUM_SLAVES - 1) < 1048576 ? 20 : ((APB_NUM_SLAVES - 1) < 2097152 ? 21 : ((APB_NUM_SLAVES - 1) < 4194304 ? 22 : ((APB_NUM_SLAVES - 1) < 8388608 ? 23 : ((APB_NUM_SLAVES - 1) < 16777216 ? 24 : 25))))))))))))))))))))))))) + APB_ADDR_WIDTH) - 1:0];
				write_req = 1'b1;
				if (AWADDR[2:0] == 4)
					W_word_sel = 1'b1;
				else
					W_word_sel = 1'b0;
				if (PREADY[TARGET_SLAVE] == 1'b1) begin
					if (AWLEN == 0) begin : _SINGLE_WRITE_
						case (AWSIZE)
							3: NS = 4'd10;
							default: NS = 4'd9;
						endcase
					end
					else begin
						sample_AW = 1'b1;
						NS = 4'd7;
					end
				end
				else
					NS = 4'd12;
			end
			4'd0:
				if (ARVALID == 1'b1) begin
					sample_AR = 1'b1;
					read_req = 1'b1;
					address = ARADDR[(((APB_NUM_SLAVES - 1) < 1 ? 0 : ((APB_NUM_SLAVES - 1) < 2 ? 1 : ((APB_NUM_SLAVES - 1) < 4 ? 2 : ((APB_NUM_SLAVES - 1) < 8 ? 3 : ((APB_NUM_SLAVES - 1) < 16 ? 4 : ((APB_NUM_SLAVES - 1) < 32 ? 5 : ((APB_NUM_SLAVES - 1) < 64 ? 6 : ((APB_NUM_SLAVES - 1) < 128 ? 7 : ((APB_NUM_SLAVES - 1) < 256 ? 8 : ((APB_NUM_SLAVES - 1) < 512 ? 9 : ((APB_NUM_SLAVES - 1) < 1024 ? 10 : ((APB_NUM_SLAVES - 1) < 2048 ? 11 : ((APB_NUM_SLAVES - 1) < 4096 ? 12 : ((APB_NUM_SLAVES - 1) < 8192 ? 13 : ((APB_NUM_SLAVES - 1) < 16384 ? 14 : ((APB_NUM_SLAVES - 1) < 32768 ? 15 : ((APB_NUM_SLAVES - 1) < 65536 ? 16 : ((APB_NUM_SLAVES - 1) < 131072 ? 17 : ((APB_NUM_SLAVES - 1) < 262144 ? 18 : ((APB_NUM_SLAVES - 1) < 524288 ? 19 : ((APB_NUM_SLAVES - 1) < 1048576 ? 20 : ((APB_NUM_SLAVES - 1) < 2097152 ? 21 : ((APB_NUM_SLAVES - 1) < 4194304 ? 22 : ((APB_NUM_SLAVES - 1) < 8388608 ? 23 : ((APB_NUM_SLAVES - 1) < 16777216 ? 24 : 25))))))))))))))))))))))))) + APB_ADDR_WIDTH) - 1:0];
					if (PREADY[TARGET_SLAVE] == 1'b1) begin : _RDATA_AVAILABLE
						if (ARLEN == 0)
							case (ARSIZE)
								3: begin
									NS = 4'd2;
									sample_RDATA_0 = 1'b1;
								end
								default: begin
									NS = 4'd1;
									if (ARADDR[2:0] == 4)
										sample_RDATA_1 = 1'b1;
									else
										sample_RDATA_0 = 1'b1;
								end
							endcase
						else begin
							NS = 4'd5;
							sample_RDATA_0 = 1'b1;
						end
					end
					else
						NS = 4'd11;
				end
				else if (AWVALID) begin : _VALID_AW_REQ_
					address = AWADDR[(((APB_NUM_SLAVES - 1) < 1 ? 0 : ((APB_NUM_SLAVES - 1) < 2 ? 1 : ((APB_NUM_SLAVES - 1) < 4 ? 2 : ((APB_NUM_SLAVES - 1) < 8 ? 3 : ((APB_NUM_SLAVES - 1) < 16 ? 4 : ((APB_NUM_SLAVES - 1) < 32 ? 5 : ((APB_NUM_SLAVES - 1) < 64 ? 6 : ((APB_NUM_SLAVES - 1) < 128 ? 7 : ((APB_NUM_SLAVES - 1) < 256 ? 8 : ((APB_NUM_SLAVES - 1) < 512 ? 9 : ((APB_NUM_SLAVES - 1) < 1024 ? 10 : ((APB_NUM_SLAVES - 1) < 2048 ? 11 : ((APB_NUM_SLAVES - 1) < 4096 ? 12 : ((APB_NUM_SLAVES - 1) < 8192 ? 13 : ((APB_NUM_SLAVES - 1) < 16384 ? 14 : ((APB_NUM_SLAVES - 1) < 32768 ? 15 : ((APB_NUM_SLAVES - 1) < 65536 ? 16 : ((APB_NUM_SLAVES - 1) < 131072 ? 17 : ((APB_NUM_SLAVES - 1) < 262144 ? 18 : ((APB_NUM_SLAVES - 1) < 524288 ? 19 : ((APB_NUM_SLAVES - 1) < 1048576 ? 20 : ((APB_NUM_SLAVES - 1) < 2097152 ? 21 : ((APB_NUM_SLAVES - 1) < 4194304 ? 22 : ((APB_NUM_SLAVES - 1) < 8388608 ? 23 : ((APB_NUM_SLAVES - 1) < 16777216 ? 24 : 25))))))))))))))))))))))))) + APB_ADDR_WIDTH) - 1:0];
					if (WVALID) begin : _VALID_W_REQ_
						write_req = 1'b1;
						if (AWADDR[2:0] == 4)
							W_word_sel = 1'b1;
						else
							W_word_sel = 1'b0;
						if (PREADY[TARGET_SLAVE] == 1'b1) begin : _APB_SLAVE_READY_
							if (AWLEN == 0) begin : _SINGLE_WRITE_
								case (AWSIZE)
									3: NS = 4'd10;
									default: NS = 4'd9;
								endcase
							end
							else begin : _B_WRITE_
								sample_AW = 1'b1;
								NS = 4'd7;
							end
						end
						else begin : _APB_SLAVE_NOT_READY_
							NS = 4'd12;
						end
					end
					else begin
						write_req = 1'b0;
						address = 1'sb0;
						NS = 4'd0;
					end
				end
				else begin
					NS = 4'd0;
					address = 1'sb0;
				end
			4'd10: begin
				address = AWADDR[(((APB_NUM_SLAVES - 1) < 1 ? 0 : ((APB_NUM_SLAVES - 1) < 2 ? 1 : ((APB_NUM_SLAVES - 1) < 4 ? 2 : ((APB_NUM_SLAVES - 1) < 8 ? 3 : ((APB_NUM_SLAVES - 1) < 16 ? 4 : ((APB_NUM_SLAVES - 1) < 32 ? 5 : ((APB_NUM_SLAVES - 1) < 64 ? 6 : ((APB_NUM_SLAVES - 1) < 128 ? 7 : ((APB_NUM_SLAVES - 1) < 256 ? 8 : ((APB_NUM_SLAVES - 1) < 512 ? 9 : ((APB_NUM_SLAVES - 1) < 1024 ? 10 : ((APB_NUM_SLAVES - 1) < 2048 ? 11 : ((APB_NUM_SLAVES - 1) < 4096 ? 12 : ((APB_NUM_SLAVES - 1) < 8192 ? 13 : ((APB_NUM_SLAVES - 1) < 16384 ? 14 : ((APB_NUM_SLAVES - 1) < 32768 ? 15 : ((APB_NUM_SLAVES - 1) < 65536 ? 16 : ((APB_NUM_SLAVES - 1) < 131072 ? 17 : ((APB_NUM_SLAVES - 1) < 262144 ? 18 : ((APB_NUM_SLAVES - 1) < 524288 ? 19 : ((APB_NUM_SLAVES - 1) < 1048576 ? 20 : ((APB_NUM_SLAVES - 1) < 2097152 ? 21 : ((APB_NUM_SLAVES - 1) < 4194304 ? 22 : ((APB_NUM_SLAVES - 1) < 8388608 ? 23 : ((APB_NUM_SLAVES - 1) < 16777216 ? 24 : 25))))))))))))))))))))))))) + APB_ADDR_WIDTH) - 1:0] + 4;
				W_word_sel = 1'b1;
				write_req = WVALID;
				if (WVALID) begin
					if (PREADY[TARGET_SLAVE] == 1'b1)
						NS = 4'd9;
					else
						NS = 4'd10;
				end
				else
					NS = 4'd10;
			end
			4'd9: begin
				BVALID = 1'b1;
				address = 1'sb0;
				if (BREADY) begin
					NS = 4'd0;
					AWREADY = 1'b1;
					WREADY = 1'b1;
				end
				else
					NS = 4'd9;
			end
			4'd7: begin
				W_word_sel = 1'b1;
				write_req = WVALID;
				address = AWADDR[(((APB_NUM_SLAVES - 1) < 1 ? 0 : ((APB_NUM_SLAVES - 1) < 2 ? 1 : ((APB_NUM_SLAVES - 1) < 4 ? 2 : ((APB_NUM_SLAVES - 1) < 8 ? 3 : ((APB_NUM_SLAVES - 1) < 16 ? 4 : ((APB_NUM_SLAVES - 1) < 32 ? 5 : ((APB_NUM_SLAVES - 1) < 64 ? 6 : ((APB_NUM_SLAVES - 1) < 128 ? 7 : ((APB_NUM_SLAVES - 1) < 256 ? 8 : ((APB_NUM_SLAVES - 1) < 512 ? 9 : ((APB_NUM_SLAVES - 1) < 1024 ? 10 : ((APB_NUM_SLAVES - 1) < 2048 ? 11 : ((APB_NUM_SLAVES - 1) < 4096 ? 12 : ((APB_NUM_SLAVES - 1) < 8192 ? 13 : ((APB_NUM_SLAVES - 1) < 16384 ? 14 : ((APB_NUM_SLAVES - 1) < 32768 ? 15 : ((APB_NUM_SLAVES - 1) < 65536 ? 16 : ((APB_NUM_SLAVES - 1) < 131072 ? 17 : ((APB_NUM_SLAVES - 1) < 262144 ? 18 : ((APB_NUM_SLAVES - 1) < 524288 ? 19 : ((APB_NUM_SLAVES - 1) < 1048576 ? 20 : ((APB_NUM_SLAVES - 1) < 2097152 ? 21 : ((APB_NUM_SLAVES - 1) < 4194304 ? 22 : ((APB_NUM_SLAVES - 1) < 8388608 ? 23 : ((APB_NUM_SLAVES - 1) < 16777216 ? 24 : 25))))))))))))))))))))))))) + APB_ADDR_WIDTH) - 1:0];
				if (WVALID) begin
					if (PREADY[TARGET_SLAVE] == 1'b1) begin
						NS = 4'd6;
						WREADY = 1'b1;
						decr_AWLEN = 1'b1;
					end
					else
						NS = 4'd7;
				end
				else
					NS = 4'd7;
			end
			4'd6: begin
				address = AWADDR[(((APB_NUM_SLAVES - 1) < 1 ? 0 : ((APB_NUM_SLAVES - 1) < 2 ? 1 : ((APB_NUM_SLAVES - 1) < 4 ? 2 : ((APB_NUM_SLAVES - 1) < 8 ? 3 : ((APB_NUM_SLAVES - 1) < 16 ? 4 : ((APB_NUM_SLAVES - 1) < 32 ? 5 : ((APB_NUM_SLAVES - 1) < 64 ? 6 : ((APB_NUM_SLAVES - 1) < 128 ? 7 : ((APB_NUM_SLAVES - 1) < 256 ? 8 : ((APB_NUM_SLAVES - 1) < 512 ? 9 : ((APB_NUM_SLAVES - 1) < 1024 ? 10 : ((APB_NUM_SLAVES - 1) < 2048 ? 11 : ((APB_NUM_SLAVES - 1) < 4096 ? 12 : ((APB_NUM_SLAVES - 1) < 8192 ? 13 : ((APB_NUM_SLAVES - 1) < 16384 ? 14 : ((APB_NUM_SLAVES - 1) < 32768 ? 15 : ((APB_NUM_SLAVES - 1) < 65536 ? 16 : ((APB_NUM_SLAVES - 1) < 131072 ? 17 : ((APB_NUM_SLAVES - 1) < 262144 ? 18 : ((APB_NUM_SLAVES - 1) < 524288 ? 19 : ((APB_NUM_SLAVES - 1) < 1048576 ? 20 : ((APB_NUM_SLAVES - 1) < 2097152 ? 21 : ((APB_NUM_SLAVES - 1) < 4194304 ? 22 : ((APB_NUM_SLAVES - 1) < 8388608 ? 23 : ((APB_NUM_SLAVES - 1) < 16777216 ? 24 : 25))))))))))))))))))))))))) + APB_ADDR_WIDTH) - 1:0];
				if (AWLEN_Q == 0) begin : _BURST_COMPLETED_
					BVALID = 1'b1;
					if (BREADY) begin
						NS = 4'd0;
						AWREADY = 1'b1;
					end
					else
						NS = 4'd6;
				end
				else begin : _BUSRST_NOT_COMPLETED_
					W_word_sel = 1'b0;
					write_req = WVALID;
					if (WVALID) begin
						if (PREADY[TARGET_SLAVE] == 1'b1)
							NS = 4'd7;
						else
							NS = 4'd6;
					end
					else
						NS = 4'd7;
				end
			end
			4'd5: begin
				read_req = 1'b1;
				address = ARADDR[(((APB_NUM_SLAVES - 1) < 1 ? 0 : ((APB_NUM_SLAVES - 1) < 2 ? 1 : ((APB_NUM_SLAVES - 1) < 4 ? 2 : ((APB_NUM_SLAVES - 1) < 8 ? 3 : ((APB_NUM_SLAVES - 1) < 16 ? 4 : ((APB_NUM_SLAVES - 1) < 32 ? 5 : ((APB_NUM_SLAVES - 1) < 64 ? 6 : ((APB_NUM_SLAVES - 1) < 128 ? 7 : ((APB_NUM_SLAVES - 1) < 256 ? 8 : ((APB_NUM_SLAVES - 1) < 512 ? 9 : ((APB_NUM_SLAVES - 1) < 1024 ? 10 : ((APB_NUM_SLAVES - 1) < 2048 ? 11 : ((APB_NUM_SLAVES - 1) < 4096 ? 12 : ((APB_NUM_SLAVES - 1) < 8192 ? 13 : ((APB_NUM_SLAVES - 1) < 16384 ? 14 : ((APB_NUM_SLAVES - 1) < 32768 ? 15 : ((APB_NUM_SLAVES - 1) < 65536 ? 16 : ((APB_NUM_SLAVES - 1) < 131072 ? 17 : ((APB_NUM_SLAVES - 1) < 262144 ? 18 : ((APB_NUM_SLAVES - 1) < 524288 ? 19 : ((APB_NUM_SLAVES - 1) < 1048576 ? 20 : ((APB_NUM_SLAVES - 1) < 2097152 ? 21 : ((APB_NUM_SLAVES - 1) < 4194304 ? 22 : ((APB_NUM_SLAVES - 1) < 8388608 ? 23 : ((APB_NUM_SLAVES - 1) < 16777216 ? 24 : 25))))))))))))))))))))))))) + APB_ADDR_WIDTH) - 1:0];
				if (PREADY[TARGET_SLAVE] == 1'b1) begin
					decr_ARLEN = 1'b1;
					sample_RDATA_1 = 1'b1;
					NS = 4'd4;
				end
				else
					NS = 4'd5;
			end
			4'd4: begin
				RVALID = 1'b1;
				RDATA[0+:32] = RDATA_Q_0;
				RDATA[32+:32] = RDATA_Q_1;
				RLAST = (ARLEN_Q == 0 ? 1 : 0);
				address = ARADDR[(((APB_NUM_SLAVES - 1) < 1 ? 0 : ((APB_NUM_SLAVES - 1) < 2 ? 1 : ((APB_NUM_SLAVES - 1) < 4 ? 2 : ((APB_NUM_SLAVES - 1) < 8 ? 3 : ((APB_NUM_SLAVES - 1) < 16 ? 4 : ((APB_NUM_SLAVES - 1) < 32 ? 5 : ((APB_NUM_SLAVES - 1) < 64 ? 6 : ((APB_NUM_SLAVES - 1) < 128 ? 7 : ((APB_NUM_SLAVES - 1) < 256 ? 8 : ((APB_NUM_SLAVES - 1) < 512 ? 9 : ((APB_NUM_SLAVES - 1) < 1024 ? 10 : ((APB_NUM_SLAVES - 1) < 2048 ? 11 : ((APB_NUM_SLAVES - 1) < 4096 ? 12 : ((APB_NUM_SLAVES - 1) < 8192 ? 13 : ((APB_NUM_SLAVES - 1) < 16384 ? 14 : ((APB_NUM_SLAVES - 1) < 32768 ? 15 : ((APB_NUM_SLAVES - 1) < 65536 ? 16 : ((APB_NUM_SLAVES - 1) < 131072 ? 17 : ((APB_NUM_SLAVES - 1) < 262144 ? 18 : ((APB_NUM_SLAVES - 1) < 524288 ? 19 : ((APB_NUM_SLAVES - 1) < 1048576 ? 20 : ((APB_NUM_SLAVES - 1) < 2097152 ? 21 : ((APB_NUM_SLAVES - 1) < 4194304 ? 22 : ((APB_NUM_SLAVES - 1) < 8388608 ? 23 : ((APB_NUM_SLAVES - 1) < 16777216 ? 24 : 25))))))))))))))))))))))))) + APB_ADDR_WIDTH) - 1:0];
				if (RREADY) begin
					if (ARLEN_Q == 0) begin : _READ_BURST_COMPLETED_
						NS = 4'd0;
						ARREADY = 1'b1;
					end
					else begin : _READ_BUSRST_NOT_COMPLETED_
						read_req = 1'b1;
						if (PREADY[TARGET_SLAVE] == 1'b1) begin
							sample_RDATA_0 = 1'b1;
							NS = 4'd5;
						end
						else
							NS = 4'd3;
					end
				end
				else
					NS = 4'd4;
			end
			4'd3: begin
				read_req = 1'b1;
				address = ARADDR[(((APB_NUM_SLAVES - 1) < 1 ? 0 : ((APB_NUM_SLAVES - 1) < 2 ? 1 : ((APB_NUM_SLAVES - 1) < 4 ? 2 : ((APB_NUM_SLAVES - 1) < 8 ? 3 : ((APB_NUM_SLAVES - 1) < 16 ? 4 : ((APB_NUM_SLAVES - 1) < 32 ? 5 : ((APB_NUM_SLAVES - 1) < 64 ? 6 : ((APB_NUM_SLAVES - 1) < 128 ? 7 : ((APB_NUM_SLAVES - 1) < 256 ? 8 : ((APB_NUM_SLAVES - 1) < 512 ? 9 : ((APB_NUM_SLAVES - 1) < 1024 ? 10 : ((APB_NUM_SLAVES - 1) < 2048 ? 11 : ((APB_NUM_SLAVES - 1) < 4096 ? 12 : ((APB_NUM_SLAVES - 1) < 8192 ? 13 : ((APB_NUM_SLAVES - 1) < 16384 ? 14 : ((APB_NUM_SLAVES - 1) < 32768 ? 15 : ((APB_NUM_SLAVES - 1) < 65536 ? 16 : ((APB_NUM_SLAVES - 1) < 131072 ? 17 : ((APB_NUM_SLAVES - 1) < 262144 ? 18 : ((APB_NUM_SLAVES - 1) < 524288 ? 19 : ((APB_NUM_SLAVES - 1) < 1048576 ? 20 : ((APB_NUM_SLAVES - 1) < 2097152 ? 21 : ((APB_NUM_SLAVES - 1) < 4194304 ? 22 : ((APB_NUM_SLAVES - 1) < 8388608 ? 23 : ((APB_NUM_SLAVES - 1) < 16777216 ? 24 : 25))))))))))))))))))))))))) + APB_ADDR_WIDTH) - 1:0];
				if (PREADY[TARGET_SLAVE] == 1'b1) begin
					sample_RDATA_0 = 1'b1;
					NS = 4'd5;
				end
				else
					NS = 4'd3;
			end
			4'd1: begin
				RVALID = 1'b1;
				RDATA[0+:32] = RDATA_Q_0;
				RDATA[32+:32] = RDATA_Q_1;
				RLAST = 1;
				address = 1'sb0;
				if (RREADY) begin
					NS = 4'd0;
					ARREADY = 1'b1;
				end
				else
					NS = 4'd1;
			end
			4'd2: begin
				read_req = 1'b1;
				address = ARADDR[(((APB_NUM_SLAVES - 1) < 1 ? 0 : ((APB_NUM_SLAVES - 1) < 2 ? 1 : ((APB_NUM_SLAVES - 1) < 4 ? 2 : ((APB_NUM_SLAVES - 1) < 8 ? 3 : ((APB_NUM_SLAVES - 1) < 16 ? 4 : ((APB_NUM_SLAVES - 1) < 32 ? 5 : ((APB_NUM_SLAVES - 1) < 64 ? 6 : ((APB_NUM_SLAVES - 1) < 128 ? 7 : ((APB_NUM_SLAVES - 1) < 256 ? 8 : ((APB_NUM_SLAVES - 1) < 512 ? 9 : ((APB_NUM_SLAVES - 1) < 1024 ? 10 : ((APB_NUM_SLAVES - 1) < 2048 ? 11 : ((APB_NUM_SLAVES - 1) < 4096 ? 12 : ((APB_NUM_SLAVES - 1) < 8192 ? 13 : ((APB_NUM_SLAVES - 1) < 16384 ? 14 : ((APB_NUM_SLAVES - 1) < 32768 ? 15 : ((APB_NUM_SLAVES - 1) < 65536 ? 16 : ((APB_NUM_SLAVES - 1) < 131072 ? 17 : ((APB_NUM_SLAVES - 1) < 262144 ? 18 : ((APB_NUM_SLAVES - 1) < 524288 ? 19 : ((APB_NUM_SLAVES - 1) < 1048576 ? 20 : ((APB_NUM_SLAVES - 1) < 2097152 ? 21 : ((APB_NUM_SLAVES - 1) < 4194304 ? 22 : ((APB_NUM_SLAVES - 1) < 8388608 ? 23 : ((APB_NUM_SLAVES - 1) < 16777216 ? 24 : 25))))))))))))))))))))))))) + APB_ADDR_WIDTH) - 1:0] + 4;
				if (PREADY[TARGET_SLAVE] == 1'b1) begin
					NS = 4'd1;
					sample_RDATA_1 = 1'b1;
				end
				else
					NS = 4'd2;
			end
			default: begin
				NS = 4'd0;
				address = 0;
			end
		endcase
	end
endmodule
