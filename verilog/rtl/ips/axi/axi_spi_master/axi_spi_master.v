`define log2(VALUE) ((VALUE) < ( 1 ) ? 0 : (VALUE) < ( 2 ) ? 1 : (VALUE) < ( 4 ) ? 2 : (VALUE) < ( 8 ) ? 3 : (VALUE) < ( 16 )  ? 4 : (VALUE) < ( 32 )  ? 5 : (VALUE) < ( 64 )  ? 6 : (VALUE) < ( 128 ) ? 7 : (VALUE) < ( 256 ) ? 8 : (VALUE) < ( 512 ) ? 9 : (VALUE) < ( 1024 ) ? 10 : (VALUE) < ( 2048 ) ? 11 : (VALUE) < ( 4096 ) ? 12 : (VALUE) < ( 8192 ) ? 13 : (VALUE) < ( 16384 ) ? 14 : (VALUE) < ( 32768 ) ? 15 : (VALUE) < ( 65536 ) ? 16 : (VALUE) < ( 131072 ) ? 17 : (VALUE) < ( 262144 ) ? 18 : (VALUE) < ( 524288 ) ? 19 : (VALUE) < ( 1048576 ) ? 20 : (VALUE) < ( 1048576 * 2 ) ? 21 : (VALUE) < ( 1048576 * 4 ) ? 22 : (VALUE) < ( 1048576 * 8 ) ? 23 : (VALUE) < ( 1048576 * 16 ) ? 24 : 25)

module axi_spi_master 
#(
    parameter AXI4_ADDRESS_WIDTH = 32,
    parameter AXI4_RDATA_WIDTH   = 32,
    parameter AXI4_WDATA_WIDTH   = 32,
    parameter AXI4_USER_WIDTH    = 4,
    parameter AXI4_ID_WIDTH      = 16,
    parameter BUFFER_DEPTH       = 8
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
	events_o,
	spi_clk,
	spi_csn0,
	spi_csn1,
	spi_csn2,
	spi_csn3,
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
	//parameter AXI4_ADDRESS_WIDTH = 32;
	//parameter AXI4_RDATA_WIDTH = 32;
	//parameter AXI4_WDATA_WIDTH = 32;
	//parameter AXI4_USER_WIDTH = 4;
	//parameter AXI4_ID_WIDTH = 16;
	//parameter BUFFER_DEPTH = 8;
	input wire s_axi_aclk;
	input wire s_axi_aresetn;
	input wire s_axi_awvalid;
	input wire [AXI4_ID_WIDTH - 1:0] s_axi_awid;
	input wire [7:0] s_axi_awlen;
	input wire [AXI4_ADDRESS_WIDTH - 1:0] s_axi_awaddr;
	input wire [AXI4_USER_WIDTH - 1:0] s_axi_awuser;
	output wire s_axi_awready;
	input wire s_axi_wvalid;
	input wire [AXI4_WDATA_WIDTH - 1:0] s_axi_wdata;
	input wire [(AXI4_WDATA_WIDTH / 8) - 1:0] s_axi_wstrb;
	input wire s_axi_wlast;
	input wire [AXI4_USER_WIDTH - 1:0] s_axi_wuser;
	output wire s_axi_wready;
	output wire s_axi_bvalid;
	output wire [AXI4_ID_WIDTH - 1:0] s_axi_bid;
	output wire [1:0] s_axi_bresp;
	output wire [AXI4_USER_WIDTH - 1:0] s_axi_buser;
	input wire s_axi_bready;
	input wire s_axi_arvalid;
	input wire [AXI4_ID_WIDTH - 1:0] s_axi_arid;
	input wire [7:0] s_axi_arlen;
	input wire [AXI4_ADDRESS_WIDTH - 1:0] s_axi_araddr;
	input wire [AXI4_USER_WIDTH - 1:0] s_axi_aruser;
	output wire s_axi_arready;
	output wire s_axi_rvalid;
	output wire [AXI4_ID_WIDTH - 1:0] s_axi_rid;
	output wire [AXI4_RDATA_WIDTH - 1:0] s_axi_rdata;
	output wire [1:0] s_axi_rresp;
	output wire s_axi_rlast;
	output wire [AXI4_USER_WIDTH - 1:0] s_axi_ruser;
	input wire s_axi_rready;
	output wire [1:0] events_o;
	output wire spi_clk;
	output wire spi_csn0;
	output wire spi_csn1;
	output wire spi_csn2;
	output wire spi_csn3;
	output wire [1:0] spi_mode;
	output wire spi_sdo0;
	output wire spi_sdo1;
	output wire spi_sdo2;
	output wire spi_sdo3;
	input wire spi_sdi0;
	input wire spi_sdi1;
	input wire spi_sdi2;
	input wire spi_sdi3;
	localparam LOG_BUFFER_DEPTH = (BUFFER_DEPTH < 1 ? 0 : (BUFFER_DEPTH < 2 ? 1 : (BUFFER_DEPTH < 4 ? 2 : (BUFFER_DEPTH < 8 ? 3 : (BUFFER_DEPTH < 16 ? 4 : (BUFFER_DEPTH < 32 ? 5 : (BUFFER_DEPTH < 64 ? 6 : (BUFFER_DEPTH < 128 ? 7 : (BUFFER_DEPTH < 256 ? 8 : (BUFFER_DEPTH < 512 ? 9 : (BUFFER_DEPTH < 1024 ? 10 : (BUFFER_DEPTH < 2048 ? 11 : (BUFFER_DEPTH < 4096 ? 12 : (BUFFER_DEPTH < 8192 ? 13 : (BUFFER_DEPTH < 16384 ? 14 : (BUFFER_DEPTH < 32768 ? 15 : (BUFFER_DEPTH < 65536 ? 16 : (BUFFER_DEPTH < 131072 ? 17 : (BUFFER_DEPTH < 262144 ? 18 : (BUFFER_DEPTH < 524288 ? 19 : (BUFFER_DEPTH < 1048576 ? 20 : (BUFFER_DEPTH < 2097152 ? 21 : (BUFFER_DEPTH < 4194304 ? 22 : (BUFFER_DEPTH < 8388608 ? 23 : (BUFFER_DEPTH < 16777216 ? 24 : 25)))))))))))))))))))))))));
	wire [7:0] spi_clk_div;
	wire spi_clk_div_valid;
	wire [31:0] spi_status;
	wire [31:0] spi_addr;
	wire [5:0] spi_addr_len;
	wire [31:0] spi_cmd;
	wire [5:0] spi_cmd_len;
	wire [15:0] spi_data_len;
	wire [15:0] spi_dummy_rd;
	wire [15:0] spi_dummy_wr;
	wire spi_swrst;
	wire spi_rd;
	wire spi_wr;
	wire spi_qrd;
	wire spi_qwr;
	wire [3:0] spi_csreg;
	wire [31:0] spi_data_tx;
	wire spi_data_tx_valid;
	wire spi_data_tx_ready;
	wire [31:0] spi_data_rx;
	wire spi_data_rx_valid;
	wire spi_data_rx_ready;
	wire [6:0] spi_ctrl_status;
	wire [31:0] spi_ctrl_data_tx;
	wire spi_ctrl_data_tx_valid;
	wire spi_ctrl_data_tx_ready;
	wire [31:0] spi_ctrl_data_rx;
	wire spi_ctrl_data_rx_valid;
	wire spi_ctrl_data_rx_ready;
	wire s_eot;
	wire [LOG_BUFFER_DEPTH:0] elements_tx;
	wire [LOG_BUFFER_DEPTH:0] elements_rx;
	reg [LOG_BUFFER_DEPTH:0] elements_tx_old;
	reg [LOG_BUFFER_DEPTH:0] elements_rx_old;
	localparam FILL_BITS = 7 - LOG_BUFFER_DEPTH;
	assign spi_status = {{FILL_BITS {1'b0}}, elements_tx, {FILL_BITS {1'b0}}, elements_rx, 9'h000, spi_ctrl_status};
	assign events_o[0] = ((elements_rx == 4'b0100) && (elements_rx_old == 4'b0101)) || ((elements_tx == 4'b0101) && (elements_tx_old == 4'b0100));
	assign events_o[1] = s_eot;
	always @(posedge s_axi_aclk or negedge s_axi_aresetn)
		if (s_axi_aresetn == 1'b0) begin
			elements_rx_old <= 'h0;
			elements_tx_old <= 'h0;
		end
		else begin
			elements_rx_old <= elements_rx;
			elements_tx_old <= elements_tx;
		end
	spi_master_axi_if #(
		.AXI4_ADDRESS_WIDTH(AXI4_ADDRESS_WIDTH),
		.AXI4_RDATA_WIDTH(AXI4_RDATA_WIDTH),
		.AXI4_WDATA_WIDTH(AXI4_WDATA_WIDTH),
		.AXI4_USER_WIDTH(AXI4_USER_WIDTH),
		.AXI4_ID_WIDTH(AXI4_ID_WIDTH)
	) u_axiregs(
		.s_axi_aclk(s_axi_aclk),
		.s_axi_aresetn(s_axi_aresetn),
		.s_axi_awvalid(s_axi_awvalid),
		.s_axi_awid(s_axi_awid),
		.s_axi_awlen(s_axi_awlen),
		.s_axi_awaddr(s_axi_awaddr),
		.s_axi_awuser(s_axi_awuser),
		.s_axi_awready(s_axi_awready),
		.s_axi_wvalid(s_axi_wvalid),
		.s_axi_wdata(s_axi_wdata),
		.s_axi_wstrb(s_axi_wstrb),
		.s_axi_wlast(s_axi_wlast),
		.s_axi_wuser(s_axi_wuser),
		.s_axi_wready(s_axi_wready),
		.s_axi_bvalid(s_axi_bvalid),
		.s_axi_bid(s_axi_bid),
		.s_axi_bresp(s_axi_bresp),
		.s_axi_buser(s_axi_buser),
		.s_axi_bready(s_axi_bready),
		.s_axi_arvalid(s_axi_arvalid),
		.s_axi_arid(s_axi_arid),
		.s_axi_arlen(s_axi_arlen),
		.s_axi_araddr(s_axi_araddr),
		.s_axi_aruser(s_axi_aruser),
		.s_axi_arready(s_axi_arready),
		.s_axi_rvalid(s_axi_rvalid),
		.s_axi_rid(s_axi_rid),
		.s_axi_rdata(s_axi_rdata),
		.s_axi_rresp(s_axi_rresp),
		.s_axi_rlast(s_axi_rlast),
		.s_axi_ruser(s_axi_ruser),
		.s_axi_rready(s_axi_rready),
		.spi_clk_div(spi_clk_div),
		.spi_clk_div_valid(spi_clk_div_valid),
		.spi_status(spi_status),
		.spi_addr(spi_addr),
		.spi_addr_len(spi_addr_len),
		.spi_cmd(spi_cmd),
		.spi_cmd_len(spi_cmd_len),
		.spi_data_len(spi_data_len),
		.spi_dummy_rd(spi_dummy_rd),
		.spi_dummy_wr(spi_dummy_wr),
		.spi_swrst(spi_swrst),
		.spi_rd(spi_rd),
		.spi_wr(spi_wr),
		.spi_qrd(spi_qrd),
		.spi_qwr(spi_qwr),
		.spi_csreg(spi_csreg),
		.spi_data_tx(spi_data_tx),
		.spi_data_tx_valid(spi_data_tx_valid),
		.spi_data_tx_ready(spi_data_tx_ready),
		.spi_data_rx(spi_data_rx),
		.spi_data_rx_valid(spi_data_rx_valid),
		.spi_data_rx_ready(spi_data_rx_ready)
	);
	spi_master_fifo #(
		.DATA_WIDTH(32),
		.BUFFER_DEPTH(BUFFER_DEPTH)
	) u_txfifo(
		.clk_i(s_axi_aclk),
		.rst_ni(s_axi_aresetn),
		.clr_i(spi_swrst),
		.elements_o(elements_tx),
		.data_o(spi_ctrl_data_tx),
		.valid_o(spi_ctrl_data_tx_valid),
		.ready_i(spi_ctrl_data_tx_ready),
		.valid_i(spi_data_tx_valid),
		.data_i(spi_data_tx),
		.ready_o(spi_data_tx_ready)
	);
	spi_master_fifo #(
		.DATA_WIDTH(32),
		.BUFFER_DEPTH(BUFFER_DEPTH)
	) u_rxfifo(
		.clk_i(s_axi_aclk),
		.rst_ni(s_axi_aresetn),
		.clr_i(spi_swrst),
		.elements_o(elements_rx),
		.data_o(spi_data_rx),
		.valid_o(spi_data_rx_valid),
		.ready_i(spi_data_rx_ready),
		.valid_i(spi_ctrl_data_rx_valid),
		.data_i(spi_ctrl_data_rx),
		.ready_o(spi_ctrl_data_rx_ready)
	);
	spi_master_controller u_spictrl(
		.clk(s_axi_aclk),
		.rstn(s_axi_aresetn),
		.eot(s_eot),
		.spi_clk_div(spi_clk_div),
		.spi_clk_div_valid(spi_clk_div_valid),
		.spi_status(spi_ctrl_status),
		.spi_addr(spi_addr),
		.spi_addr_len(spi_addr_len),
		.spi_cmd(spi_cmd),
		.spi_cmd_len(spi_cmd_len),
		.spi_data_len(spi_data_len),
		.spi_dummy_rd(spi_dummy_rd),
		.spi_dummy_wr(spi_dummy_wr),
		.spi_swrst(spi_swrst),
		.spi_rd(spi_rd),
		.spi_wr(spi_wr),
		.spi_qrd(spi_qrd),
		.spi_qwr(spi_qwr),
		.spi_csreg(spi_csreg),
		.spi_ctrl_data_tx(spi_ctrl_data_tx),
		.spi_ctrl_data_tx_valid(spi_ctrl_data_tx_valid),
		.spi_ctrl_data_tx_ready(spi_ctrl_data_tx_ready),
		.spi_ctrl_data_rx(spi_ctrl_data_rx),
		.spi_ctrl_data_rx_valid(spi_ctrl_data_rx_valid),
		.spi_ctrl_data_rx_ready(spi_ctrl_data_rx_ready),
		.spi_clk(spi_clk),
		.spi_csn0(spi_csn0),
		.spi_csn1(spi_csn1),
		.spi_csn2(spi_csn2),
		.spi_csn3(spi_csn3),
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
