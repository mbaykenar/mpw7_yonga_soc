`define log2(VALUE) ((VALUE) < ( 1 ) ? 0 : (VALUE) < ( 2 ) ? 1 : (VALUE) < ( 4 ) ? 2 : (VALUE) < ( 8 ) ? 3 : (VALUE) < ( 16 )  ? 4 : (VALUE) < ( 32 )  ? 5 : (VALUE) < ( 64 )  ? 6 : (VALUE) < ( 128 ) ? 7 : (VALUE) < ( 256 ) ? 8 : (VALUE) < ( 512 ) ? 9 : (VALUE) < ( 1024 ) ? 10 : (VALUE) < ( 2048 ) ? 11 : (VALUE) < ( 4096 ) ? 12 : (VALUE) < ( 8192 ) ? 13 : (VALUE) < ( 16384 ) ? 14 : (VALUE) < ( 32768 ) ? 15 : (VALUE) < ( 65536 ) ? 16 : (VALUE) < ( 131072 ) ? 17 : (VALUE) < ( 262144 ) ? 18 : (VALUE) < ( 524288 ) ? 19 : (VALUE) < ( 1048576 ) ? 20 : (VALUE) < ( 1048576 * 2 ) ? 21 : (VALUE) < ( 1048576 * 4 ) ? 22 : (VALUE) < ( 1048576 * 8 ) ? 23 : (VALUE) < ( 1048576 * 16 ) ? 24 : 25)

module spi_master_axi_if 
#(
      parameter AXI4_ADDRESS_WIDTH = 32,
      parameter AXI4_RDATA_WIDTH   = 32,
      parameter AXI4_WDATA_WIDTH   = 32,
      parameter AXI4_USER_WIDTH    = 4,
      parameter AXI4_ID_WIDTH      = 16
  )
(
	s_axi_aclk,
	s_axi_aresetn,
	s_axi_awvalid,
	s_axi_awid,
	s_axi_awlen,
	s_axi_awaddr,
	s_axi_awuser,
	s_axi_awready,
	s_axi_wvalid,
	s_axi_wdata,
	s_axi_wstrb,
	s_axi_wlast,
	s_axi_wuser,
	s_axi_wready,
	s_axi_bvalid,
	s_axi_bid,
	s_axi_bresp,
	s_axi_buser,
	s_axi_bready,
	s_axi_arvalid,
	s_axi_arid,
	s_axi_arlen,
	s_axi_araddr,
	s_axi_aruser,
	s_axi_arready,
	s_axi_rvalid,
	s_axi_rid,
	s_axi_rdata,
	s_axi_rresp,
	s_axi_rlast,
	s_axi_ruser,
	s_axi_rready,
	spi_clk_div,
	spi_clk_div_valid,
	spi_status,
	spi_addr,
	spi_addr_len,
	spi_cmd,
	spi_cmd_len,
	spi_csreg,
	spi_data_len,
	spi_dummy_rd,
	spi_dummy_wr,
	spi_swrst,
	spi_rd,
	spi_wr,
	spi_qrd,
	spi_qwr,
	spi_data_tx,
	spi_data_tx_valid,
	spi_data_tx_ready,
	spi_data_rx,
	spi_data_rx_valid,
	spi_data_rx_ready
);
	//parameter AXI4_ADDRESS_WIDTH = 32;
	//parameter AXI4_RDATA_WIDTH = 32;
	//parameter AXI4_WDATA_WIDTH = 32;
	//parameter AXI4_USER_WIDTH = 4;
	//parameter AXI4_ID_WIDTH = 16;
	input wire s_axi_aclk;
	input wire s_axi_aresetn;
	input wire s_axi_awvalid;
	input wire [AXI4_ID_WIDTH - 1:0] s_axi_awid;
	input wire [7:0] s_axi_awlen;
	input wire [AXI4_ADDRESS_WIDTH - 1:0] s_axi_awaddr;
	input wire [AXI4_USER_WIDTH - 1:0] s_axi_awuser;
	output reg s_axi_awready;
	input wire s_axi_wvalid;
	input wire [AXI4_WDATA_WIDTH - 1:0] s_axi_wdata;
	input wire [(AXI4_WDATA_WIDTH / 8) - 1:0] s_axi_wstrb;
	input wire s_axi_wlast;
	input wire [AXI4_USER_WIDTH - 1:0] s_axi_wuser;
	output reg s_axi_wready;
	output reg s_axi_bvalid;
	output reg [AXI4_ID_WIDTH - 1:0] s_axi_bid;
	output reg [1:0] s_axi_bresp;
	output reg [AXI4_USER_WIDTH - 1:0] s_axi_buser;
	input wire s_axi_bready;
	input wire s_axi_arvalid;
	input wire [AXI4_ID_WIDTH - 1:0] s_axi_arid;
	input wire [7:0] s_axi_arlen;
	input wire [AXI4_ADDRESS_WIDTH - 1:0] s_axi_araddr;
	input wire [AXI4_USER_WIDTH - 1:0] s_axi_aruser;
	output reg s_axi_arready;
	output reg s_axi_rvalid;
	output reg [AXI4_ID_WIDTH - 1:0] s_axi_rid;
	output reg [AXI4_RDATA_WIDTH - 1:0] s_axi_rdata;
	output reg [1:0] s_axi_rresp;
	output reg s_axi_rlast;
	output reg [AXI4_USER_WIDTH - 1:0] s_axi_ruser;
	input wire s_axi_rready;
	output reg [7:0] spi_clk_div;
	output reg spi_clk_div_valid;
	input wire [31:0] spi_status;
	output reg [31:0] spi_addr;
	output reg [5:0] spi_addr_len;
	output reg [31:0] spi_cmd;
	output reg [5:0] spi_cmd_len;
	output reg [3:0] spi_csreg;
	output reg [15:0] spi_data_len;
	output reg [15:0] spi_dummy_rd;
	output reg [15:0] spi_dummy_wr;
	output reg spi_swrst;
	output reg spi_rd;
	output reg spi_wr;
	output reg spi_qrd;
	output reg spi_qwr;
	output wire [31:0] spi_data_tx;
	output wire spi_data_tx_valid;
	input wire spi_data_tx_ready;
	input wire [31:0] spi_data_rx;
	input wire spi_data_rx_valid;
	output reg spi_data_rx_ready;
	localparam WR_ADDR_CMP = ((AXI4_WDATA_WIDTH / 8) < 1 ? 0 : ((AXI4_WDATA_WIDTH / 8) < 2 ? 1 : ((AXI4_WDATA_WIDTH / 8) < 4 ? 2 : ((AXI4_WDATA_WIDTH / 8) < 8 ? 3 : ((AXI4_WDATA_WIDTH / 8) < 16 ? 4 : ((AXI4_WDATA_WIDTH / 8) < 32 ? 5 : ((AXI4_WDATA_WIDTH / 8) < 64 ? 6 : ((AXI4_WDATA_WIDTH / 8) < 128 ? 7 : ((AXI4_WDATA_WIDTH / 8) < 256 ? 8 : ((AXI4_WDATA_WIDTH / 8) < 512 ? 9 : ((AXI4_WDATA_WIDTH / 8) < 1024 ? 10 : ((AXI4_WDATA_WIDTH / 8) < 2048 ? 11 : ((AXI4_WDATA_WIDTH / 8) < 4096 ? 12 : ((AXI4_WDATA_WIDTH / 8) < 8192 ? 13 : ((AXI4_WDATA_WIDTH / 8) < 16384 ? 14 : ((AXI4_WDATA_WIDTH / 8) < 32768 ? 15 : ((AXI4_WDATA_WIDTH / 8) < 65536 ? 16 : ((AXI4_WDATA_WIDTH / 8) < 131072 ? 17 : ((AXI4_WDATA_WIDTH / 8) < 262144 ? 18 : ((AXI4_WDATA_WIDTH / 8) < 524288 ? 19 : ((AXI4_WDATA_WIDTH / 8) < 1048576 ? 20 : ((AXI4_WDATA_WIDTH / 8) < 2097152 ? 21 : ((AXI4_WDATA_WIDTH / 8) < 4194304 ? 22 : ((AXI4_WDATA_WIDTH / 8) < 8388608 ? 23 : ((AXI4_WDATA_WIDTH / 8) < 16777216 ? 24 : 25))))))))))))))))))))))))) - 1;
	localparam RD_ADDR_CMP = ((AXI4_RDATA_WIDTH / 8) < 1 ? 0 : ((AXI4_RDATA_WIDTH / 8) < 2 ? 1 : ((AXI4_RDATA_WIDTH / 8) < 4 ? 2 : ((AXI4_RDATA_WIDTH / 8) < 8 ? 3 : ((AXI4_RDATA_WIDTH / 8) < 16 ? 4 : ((AXI4_RDATA_WIDTH / 8) < 32 ? 5 : ((AXI4_RDATA_WIDTH / 8) < 64 ? 6 : ((AXI4_RDATA_WIDTH / 8) < 128 ? 7 : ((AXI4_RDATA_WIDTH / 8) < 256 ? 8 : ((AXI4_RDATA_WIDTH / 8) < 512 ? 9 : ((AXI4_RDATA_WIDTH / 8) < 1024 ? 10 : ((AXI4_RDATA_WIDTH / 8) < 2048 ? 11 : ((AXI4_RDATA_WIDTH / 8) < 4096 ? 12 : ((AXI4_RDATA_WIDTH / 8) < 8192 ? 13 : ((AXI4_RDATA_WIDTH / 8) < 16384 ? 14 : ((AXI4_RDATA_WIDTH / 8) < 32768 ? 15 : ((AXI4_RDATA_WIDTH / 8) < 65536 ? 16 : ((AXI4_RDATA_WIDTH / 8) < 131072 ? 17 : ((AXI4_RDATA_WIDTH / 8) < 262144 ? 18 : ((AXI4_RDATA_WIDTH / 8) < 524288 ? 19 : ((AXI4_RDATA_WIDTH / 8) < 1048576 ? 20 : ((AXI4_RDATA_WIDTH / 8) < 2097152 ? 21 : ((AXI4_RDATA_WIDTH / 8) < 4194304 ? 22 : ((AXI4_RDATA_WIDTH / 8) < 8388608 ? 23 : ((AXI4_RDATA_WIDTH / 8) < 16777216 ? 24 : 25))))))))))))))))))))))))) - 1;
	localparam OFFSET_BIT = ((AXI4_WDATA_WIDTH - 1) < 1 ? 0 : ((AXI4_WDATA_WIDTH - 1) < 2 ? 1 : ((AXI4_WDATA_WIDTH - 1) < 4 ? 2 : ((AXI4_WDATA_WIDTH - 1) < 8 ? 3 : ((AXI4_WDATA_WIDTH - 1) < 16 ? 4 : ((AXI4_WDATA_WIDTH - 1) < 32 ? 5 : ((AXI4_WDATA_WIDTH - 1) < 64 ? 6 : ((AXI4_WDATA_WIDTH - 1) < 128 ? 7 : ((AXI4_WDATA_WIDTH - 1) < 256 ? 8 : ((AXI4_WDATA_WIDTH - 1) < 512 ? 9 : ((AXI4_WDATA_WIDTH - 1) < 1024 ? 10 : ((AXI4_WDATA_WIDTH - 1) < 2048 ? 11 : ((AXI4_WDATA_WIDTH - 1) < 4096 ? 12 : ((AXI4_WDATA_WIDTH - 1) < 8192 ? 13 : ((AXI4_WDATA_WIDTH - 1) < 16384 ? 14 : ((AXI4_WDATA_WIDTH - 1) < 32768 ? 15 : ((AXI4_WDATA_WIDTH - 1) < 65536 ? 16 : ((AXI4_WDATA_WIDTH - 1) < 131072 ? 17 : ((AXI4_WDATA_WIDTH - 1) < 262144 ? 18 : ((AXI4_WDATA_WIDTH - 1) < 524288 ? 19 : ((AXI4_WDATA_WIDTH - 1) < 1048576 ? 20 : ((AXI4_WDATA_WIDTH - 1) < 2097152 ? 21 : ((AXI4_WDATA_WIDTH - 1) < 4194304 ? 22 : ((AXI4_WDATA_WIDTH - 1) < 8388608 ? 23 : ((AXI4_WDATA_WIDTH - 1) < 16777216 ? 24 : 25))))))))))))))))))))))))) - 3;
	wire [4:0] wr_addr;
	wire [4:0] rd_addr;
	wire is_tx_fifo_sel;
	wire is_rx_fifo_sel;
	reg is_tx_fifo_sel_q;
	reg is_rx_fifo_sel_q;
	reg read_req;
	reg [4:0] read_address;
	reg sample_AR;
	reg [4:0] ARADDR_Q;
	reg [7:0] ARLEN_Q;
	reg decr_ARLEN;
	reg [7:0] CountBurstCS;
	reg [7:0] CountBurstNS;
	reg [AXI4_ID_WIDTH - 1:0] ARID_Q;
	reg [AXI4_USER_WIDTH - 1:0] ARUSER_Q;
	reg write_req;
	reg [4:0] write_address;
	reg sample_AW;
	reg [4:0] AWADDR_Q;
	reg [7:0] AWLEN_Q;
	reg decr_AWLEN;
	reg [7:0] CountBurst_AW_CS;
	reg [7:0] CountBurst_AW_NS;
	reg [AXI4_ID_WIDTH - 1:0] AWID_Q;
	reg [AXI4_USER_WIDTH - 1:0] AWUSER_Q;
	reg [2:0] AR_CS;
	reg [2:0] AR_NS;
	reg [2:0] AW_CS;
	reg [2:0] AW_NS;
	assign wr_addr = s_axi_awaddr[WR_ADDR_CMP + 4:WR_ADDR_CMP];
	assign rd_addr = s_axi_araddr[RD_ADDR_CMP + 4:RD_ADDR_CMP];
	assign is_tx_fifo_sel = wr_addr[3] == 1'b1;
	assign is_rx_fifo_sel = rd_addr[4] == 1'b1;
	assign spi_data_tx = s_axi_wdata[31:0];
	always @(posedge s_axi_aclk or negedge s_axi_aresetn)
		if (s_axi_aresetn == 1'b0) begin
			AR_CS <= 3'd0;
			ARADDR_Q <= 1'sb0;
			CountBurstCS <= 1'sb0;
			ARID_Q <= 1'sb0;
			ARUSER_Q <= 1'sb0;
			is_tx_fifo_sel_q <= 1'sb0;
			is_rx_fifo_sel_q <= 1'sb0;
		end
		else begin
			AR_CS <= AR_NS;
			CountBurstCS <= CountBurstNS;
			is_tx_fifo_sel_q <= is_tx_fifo_sel;
			is_rx_fifo_sel_q <= is_rx_fifo_sel;
			if (sample_AR)
				ARLEN_Q <= s_axi_arlen;
			else if (decr_ARLEN)
				ARLEN_Q <= ARLEN_Q - 1'b1;
			if (sample_AR) begin
				ARID_Q <= s_axi_arid;
				ARADDR_Q <= read_address;
				ARUSER_Q <= s_axi_aruser;
			end
		end
	always @(*) begin
		s_axi_arready = 1'b0;
		read_address = 1'sb0;
		read_req = 1'b0;
		sample_AR = 1'b0;
		decr_ARLEN = 1'b0;
		CountBurstNS = CountBurstCS;
		spi_data_rx_ready = 1'b0;
		s_axi_rvalid = 1'b0;
		s_axi_rresp = 2'b00;
		s_axi_ruser = 1'sb0;
		s_axi_rlast = 1'b0;
		s_axi_rid = 1'sb0;
		AR_NS = AR_CS;
		case (AR_CS)
			3'd0: begin
				s_axi_arready = 1'b1;
				if (s_axi_arvalid) begin
					sample_AR = 1'b1;
					read_req = 1'b1;
					read_address = rd_addr;
					if (s_axi_arlen == 0) begin
						AR_NS = 3'd1;
						CountBurstNS = 1'sb0;
					end
					else begin
						AR_NS = 3'd2;
						CountBurstNS = CountBurstCS + 1'b1;
					end
				end
				else begin
					AR_NS = 3'd0;
					CountBurstNS = 1'sb0;
				end
			end
			3'd1: begin
				s_axi_rresp = 2'b00;
				s_axi_rid = ARID_Q;
				s_axi_ruser = ARUSER_Q;
				s_axi_rlast = 1'b1;
				read_address = ARADDR_Q;
				if (is_rx_fifo_sel_q)
					s_axi_rvalid = spi_data_rx_valid;
				else
					s_axi_rvalid = 1'b1;
				if ((s_axi_rready && !is_rx_fifo_sel_q) | ((s_axi_rready && is_rx_fifo_sel_q) && spi_data_rx_valid)) begin
					if (is_rx_fifo_sel_q)
						spi_data_rx_ready = 1'b1;
					s_axi_arready = 1'b1;
					if (s_axi_arvalid) begin
						sample_AR = 1'b1;
						read_req = 1'b1;
						read_address = rd_addr;
						if (s_axi_arlen == 0) begin
							AR_NS = 3'd1;
							CountBurstNS = 1'sb0;
						end
						else begin
							AR_NS = 3'd2;
							CountBurstNS = CountBurstCS + 1'b1;
						end
					end
					else begin
						AR_NS = 3'd0;
						CountBurstNS = 1'sb0;
					end
				end
				else begin
					AR_NS = 3'd1;
					read_req = 1'b1;
					read_address = ARADDR_Q;
					CountBurstNS = 1'sb0;
				end
			end
			3'd2: begin
				s_axi_rresp = 2'b00;
				s_axi_rid = ARID_Q;
				s_axi_ruser = ARUSER_Q;
				read_address = ARADDR_Q;
				if (is_rx_fifo_sel_q)
					s_axi_rvalid = spi_data_rx_valid;
				else
					s_axi_rvalid = 1'b1;
				if ((s_axi_rready && !is_rx_fifo_sel_q) | ((s_axi_rready && is_rx_fifo_sel_q) && spi_data_rx_valid)) begin
					if (is_rx_fifo_sel_q)
						spi_data_rx_ready = 1'b1;
					if (ARLEN_Q > 0) begin
						AR_NS = 3'd2;
						read_req = 1'b1;
						decr_ARLEN = 1'b1;
						read_address = ARADDR_Q + CountBurstCS;
						s_axi_rlast = 1'b0;
						s_axi_arready = 1'b0;
					end
					else begin
						s_axi_rlast = 1'b1;
						s_axi_arready = 1'b1;
						if (s_axi_arvalid) begin
							sample_AR = 1'b1;
							read_req = 1'b1;
							read_address = rd_addr;
							if (s_axi_arlen == 0) begin
								AR_NS = 3'd1;
								CountBurstNS = 0;
							end
							else begin
								AR_NS = 3'd2;
								CountBurstNS = 1;
							end
						end
						else begin
							AR_NS = 3'd0;
							CountBurstNS = 0;
						end
					end
				end
				else begin
					AR_NS = 3'd2;
					read_req = 1'b1;
					decr_ARLEN = 1'b0;
					read_address = ARADDR_Q + CountBurstCS;
					s_axi_arready = 1'b0;
				end
			end
			default:
				;
		endcase
	end
	always @(posedge s_axi_aclk or negedge s_axi_aresetn)
		if (s_axi_aresetn == 1'b0) begin
			AW_CS <= 3'd0;
			AWADDR_Q <= 1'sb0;
			CountBurst_AW_CS <= 1'sb0;
			AWID_Q <= 1'sb0;
			AWUSER_Q <= 1'sb0;
		end
		else begin
			AW_CS <= AW_NS;
			CountBurst_AW_CS <= CountBurst_AW_NS;
			if (sample_AW) begin
				AWLEN_Q <= s_axi_awlen;
				AWADDR_Q <= wr_addr;
				AWID_Q <= s_axi_awid;
				AWUSER_Q <= s_axi_awuser;
			end
			else if (decr_AWLEN)
				AWLEN_Q <= AWLEN_Q - 1'b1;
		end
	always @(*) begin
		s_axi_awready = 1'b0;
		s_axi_wready = 1'b0;
		write_address = 1'sb0;
		write_req = 1'b0;
		sample_AW = 1'b0;
		decr_AWLEN = 1'b0;
		CountBurst_AW_NS = CountBurst_AW_CS;
		s_axi_bid = 1'sb0;
		s_axi_bresp = 2'b00;
		s_axi_buser = 1'sb0;
		s_axi_bvalid = 1'b0;
		AW_NS = AW_CS;
		case (AW_CS)
			3'd0: begin
				s_axi_awready = 1'b1;
				if (s_axi_awvalid) begin
					sample_AW = 1'b1;
					if (s_axi_wvalid) begin
						s_axi_wready = 1'b1;
						write_req = 1'b1;
						write_address = wr_addr;
						if (s_axi_awlen == 0) begin
							AW_NS = 3'd1;
							CountBurst_AW_NS = 0;
						end
						else begin
							AW_NS = 3'd2;
							CountBurst_AW_NS = 1;
						end
					end
					else begin
						s_axi_wready = 1'b1;
						write_req = 1'b0;
						write_address = 1'sb0;
						if (s_axi_awlen == 0) begin
							AW_NS = 3'd4;
							CountBurst_AW_NS = 0;
						end
						else begin
							AW_NS = 3'd3;
							CountBurst_AW_NS = 0;
						end
					end
				end
				else begin
					s_axi_wready = 1'b1;
					AW_NS = 3'd0;
					CountBurst_AW_NS = 1'sb0;
				end
			end
			3'd3: begin
				s_axi_awready = 1'b0;
				if (s_axi_wvalid) begin
					s_axi_wready = 1'b1;
					write_req = 1'b1;
					write_address = AWADDR_Q;
					AW_NS = 3'd2;
					CountBurst_AW_NS = 1;
					decr_AWLEN = 1'b1;
				end
				else begin
					s_axi_wready = 1'b1;
					write_req = 1'b0;
					AW_NS = 3'd3;
					CountBurst_AW_NS = 1'sb0;
				end
			end
			3'd4: begin
				s_axi_awready = 1'b0;
				CountBurst_AW_NS = 1'sb0;
				if (s_axi_wvalid) begin
					s_axi_wready = 1'b1;
					write_req = 1'b1;
					write_address = AWADDR_Q;
					AW_NS = 3'd1;
				end
				else begin
					s_axi_wready = 1'b1;
					write_req = 1'b0;
					AW_NS = 3'd4;
				end
			end
			3'd1: begin
				s_axi_bid = AWID_Q;
				s_axi_bresp = 2'b00;
				s_axi_buser = AWUSER_Q;
				s_axi_bvalid = 1'b1;
				if (s_axi_bready) begin
					s_axi_awready = 1'b1;
					if (s_axi_awvalid) begin
						sample_AW = 1'b1;
						write_req = 1'b1;
						write_address = wr_addr;
						if (s_axi_awlen == 0) begin
							AW_NS = 3'd1;
							CountBurst_AW_NS = 1'sb0;
						end
						else begin
							AW_NS = 3'd2;
							CountBurst_AW_NS = CountBurst_AW_CS + 1'b1;
						end
					end
					else begin
						AW_NS = 3'd0;
						CountBurst_AW_NS = 1'sb0;
					end
				end
				else begin
					AW_NS = 3'd1;
					CountBurst_AW_NS = 1'sb0;
					s_axi_awready = 1'b0;
				end
			end
			3'd2: begin
				CountBurst_AW_NS = CountBurst_AW_CS;
				s_axi_awready = 1'b0;
				write_address = AWADDR_Q;
				if (s_axi_wvalid) begin
					s_axi_wready = 1'b1;
					write_req = 1'b1;
					decr_AWLEN = 1'b1;
					CountBurst_AW_NS = CountBurst_AW_CS + 1'b1;
				end
				else begin
					s_axi_wready = 1'b1;
					write_req = 1'b0;
					decr_AWLEN = 1'b0;
				end
				if (AWLEN_Q > 0)
					AW_NS = 3'd2;
				else
					AW_NS = 3'd5;
			end
			3'd5: begin
				s_axi_bvalid = 1'b1;
				s_axi_bid = AWID_Q;
				s_axi_bresp = 2'b00;
				s_axi_buser = AWUSER_Q;
				if (s_axi_bready) begin
					s_axi_awready = 1'b1;
					if (s_axi_awvalid) begin
						sample_AW = 1'b1;
						if (s_axi_wvalid) begin
							s_axi_wready = 1'b1;
							write_req = 1'b1;
							write_address = wr_addr;
							if (s_axi_awlen == 0) begin
								AW_NS = 3'd1;
								CountBurst_AW_NS = 0;
							end
							else begin
								AW_NS = 3'd2;
								CountBurst_AW_NS = 1;
							end
						end
						else begin
							s_axi_wready = 1'b1;
							write_req = 1'b0;
							write_address = 1'sb0;
							if (s_axi_awlen == 0) begin
								AW_NS = 3'd4;
								CountBurst_AW_NS = 0;
							end
							else begin
								AW_NS = 3'd3;
								CountBurst_AW_NS = 0;
							end
						end
					end
					else begin
						s_axi_wready = 1'b1;
						AW_NS = 3'd0;
						CountBurst_AW_NS = 1'sb0;
					end
				end
				else begin
					AW_NS = 3'd5;
					s_axi_awready = 1'b0;
					s_axi_wready = 1'b0;
				end
			end
		endcase
	end
	always @(posedge s_axi_aclk or negedge s_axi_aresetn)
		if (s_axi_aresetn == 1'b0) begin
			spi_swrst = 1'b0;
			spi_rd = 1'b0;
			spi_wr = 1'b0;
			spi_qrd = 1'b0;
			spi_qwr = 1'b0;
			spi_clk_div_valid = 1'b0;
			spi_clk_div = 'h0;
			spi_cmd = 'h0;
			spi_addr = 'h0;
			spi_cmd_len = 'h0;
			spi_addr_len = 'h0;
			spi_data_len = 'h0;
			spi_dummy_rd = 'h0;
			spi_dummy_wr = 'h0;
			spi_csreg = 'h0;
		end
		else if (write_req) begin
			spi_swrst = 1'b0;
			spi_rd = 1'b0;
			spi_wr = 1'b0;
			spi_qrd = 1'b0;
			spi_qwr = 1'b0;
			spi_clk_div_valid = 1'b0;
			case (write_address)
				3'b000: begin
					if (s_axi_wstrb[0] == 1) begin
						spi_rd = s_axi_wdata[0];
						spi_wr = s_axi_wdata[1];
						spi_qrd = s_axi_wdata[2];
						spi_qwr = s_axi_wdata[3];
						spi_swrst = s_axi_wdata[4];
					end
					if (s_axi_wstrb[1] == 1)
						spi_csreg = s_axi_wdata[11:8];
				end
				3'b001:
					if (s_axi_wstrb[0] == 1) begin
						spi_clk_div = s_axi_wdata[7:0];
						spi_clk_div_valid = 1'b1;
					end
				3'b010: begin : sv2v_autoblock_1
					reg signed [31:0] byte_index;
					for (byte_index = 0; byte_index < 4; byte_index = byte_index + 1)
						if (s_axi_wstrb[byte_index] == 1)
							spi_cmd[byte_index * 8+:8] = s_axi_wdata[byte_index * 8+:8];
				end
				3'b011: begin : sv2v_autoblock_2
					reg signed [31:0] byte_index;
					for (byte_index = 0; byte_index < 4; byte_index = byte_index + 1)
						if (s_axi_wstrb[byte_index] == 1)
							spi_addr[byte_index * 8+:8] = s_axi_wdata[byte_index * 8+:8];
				end
				3'b100: begin
					if (s_axi_wstrb[0] == 1)
						spi_cmd_len = s_axi_wdata[7:0];
					if (s_axi_wstrb[1] == 1)
						spi_addr_len = s_axi_wdata[15:8];
					if (s_axi_wstrb[2] == 1)
						spi_data_len[7:0] = s_axi_wdata[23:16];
					if (s_axi_wstrb[3] == 1)
						spi_data_len[15:8] = s_axi_wdata[31:24];
				end
				3'b101: begin
					if (s_axi_wstrb[0] == 1)
						spi_dummy_rd[7:0] = s_axi_wdata[7:0];
					if (s_axi_wstrb[1] == 1)
						spi_dummy_rd[15:8] = s_axi_wdata[15:8];
					if (s_axi_wstrb[2] == 1)
						spi_dummy_wr[7:0] = s_axi_wdata[23:16];
					if (s_axi_wstrb[3] == 1)
						spi_dummy_wr[15:8] = s_axi_wdata[31:24];
				end
			endcase
		end
		else begin
			spi_swrst = 1'b0;
			spi_rd = 1'b0;
			spi_wr = 1'b0;
			spi_qrd = 1'b0;
			spi_qwr = 1'b0;
			spi_clk_div_valid = 1'b0;
		end
	always @(*) begin
		s_axi_rdata = {32'h00000000, spi_data_rx};
		case (read_address)
			3'b000: s_axi_rdata[31:0] = spi_status;
			3'b001: s_axi_rdata[31:0] = {24'h000000, spi_clk_div};
			3'b010: s_axi_rdata[31:0] = spi_cmd;
			3'b011: s_axi_rdata[31:0] = spi_addr;
			3'b100: s_axi_rdata[31:0] = {spi_data_len, 2'b00, spi_addr_len, 2'b00, spi_cmd_len};
			3'b101: s_axi_rdata[31:0] = {spi_dummy_wr, spi_dummy_rd};
		endcase
	end
	assign spi_data_tx_valid = write_req & (write_address[3] == 1'b1);
endmodule
