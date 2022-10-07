module axi_regs_top 
#(
    parameter C_S_AXI_ADDR_WIDTH = 32,
    parameter C_S_AXI_DATA_WIDTH = 32,

    parameter N_REGION_MAX       = 4,
    parameter N_MASTER_PORT      = 16,
    parameter N_SLAVE_PORT       = 16
)
(
	s_axi_aclk,
	s_axi_aresetn,
	s_axi_awaddr,
	s_axi_awvalid,
	s_axi_awready,
	s_axi_araddr,
	s_axi_arvalid,
	s_axi_arready,
	s_axi_wdata,
	s_axi_wstrb,
	s_axi_wvalid,
	s_axi_wready,
	s_axi_bready,
	s_axi_bresp,
	s_axi_bvalid,
	s_axi_rdata,
	s_axi_rvalid,
	s_axi_rready,
	s_axi_rresp,
	init_START_ADDR_i,
	init_END_ADDR_i,
	init_valid_rule_i,
	init_connectivity_map_i,
	START_ADDR_o,
	END_ADDR_o,
	valid_rule_o,
	connectivity_map_o
);
	//parameter C_S_AXI_ADDR_WIDTH = 32;
	//parameter C_S_AXI_DATA_WIDTH = 32;
	//parameter N_REGION_MAX = 4;
	//parameter N_MASTER_PORT = 16;
	//parameter N_SLAVE_PORT = 16;
	input wire s_axi_aclk;
	input wire s_axi_aresetn;
	input wire [C_S_AXI_ADDR_WIDTH - 1:0] s_axi_awaddr;
	input wire s_axi_awvalid;
	output wire s_axi_awready;
	input wire [C_S_AXI_ADDR_WIDTH - 1:0] s_axi_araddr;
	input wire s_axi_arvalid;
	output wire s_axi_arready;
	input wire [C_S_AXI_DATA_WIDTH - 1:0] s_axi_wdata;
	input wire [(C_S_AXI_DATA_WIDTH / 8) - 1:0] s_axi_wstrb;
	input wire s_axi_wvalid;
	output wire s_axi_wready;
	input wire s_axi_bready;
	output wire [1:0] s_axi_bresp;
	output wire s_axi_bvalid;
	output wire [C_S_AXI_DATA_WIDTH - 1:0] s_axi_rdata;
	output wire s_axi_rvalid;
	input wire s_axi_rready;
	output wire [1:0] s_axi_rresp;
	input wire [((N_REGION_MAX * N_MASTER_PORT) * C_S_AXI_DATA_WIDTH) - 1:0] init_START_ADDR_i;
	input wire [((N_REGION_MAX * N_MASTER_PORT) * C_S_AXI_DATA_WIDTH) - 1:0] init_END_ADDR_i;
	input wire [(N_REGION_MAX * N_MASTER_PORT) - 1:0] init_valid_rule_i;
	input wire [(N_SLAVE_PORT * N_MASTER_PORT) - 1:0] init_connectivity_map_i;
	output wire [((N_REGION_MAX * N_MASTER_PORT) * C_S_AXI_DATA_WIDTH) - 1:0] START_ADDR_o;
	output wire [((N_REGION_MAX * N_MASTER_PORT) * C_S_AXI_DATA_WIDTH) - 1:0] END_ADDR_o;
	output wire [(N_REGION_MAX * N_MASTER_PORT) - 1:0] valid_rule_o;
	output wire [(N_SLAVE_PORT * N_MASTER_PORT) - 1:0] connectivity_map_o;
	localparam NUM_REGS = ((N_MASTER_PORT * 4) * N_REGION_MAX) + N_SLAVE_PORT;
	wire [(N_SLAVE_PORT * C_S_AXI_DATA_WIDTH) - 1:0] temp_reg;
	reg awaddr_done_reg;
	reg awaddr_done_reg_dly;
	reg wdata_done_reg;
	reg wdata_done_reg_dly;
	reg wresp_done_reg;
	reg wresp_running_reg;
	reg araddr_done_reg;
	reg rresp_done_reg;
	reg rresp_running_reg;
	reg awready;
	reg wready;
	reg bvalid;
	reg arready;
	reg rvalid;
	reg [C_S_AXI_ADDR_WIDTH - 1:0] waddr_reg;
	reg [C_S_AXI_DATA_WIDTH - 1:0] wdata_reg;
	reg [3:0] wstrb_reg;
	reg [C_S_AXI_ADDR_WIDTH - 1:0] raddr_reg;
	reg [C_S_AXI_DATA_WIDTH - 1:0] data_out_reg;
	wire write_en;
	integer byte_index;
	integer k;
	integer y;
	integer w;
	genvar i;
	genvar j;
	wire wdata_done_rise;
	wire awaddr_done_rise;
	reg [((NUM_REGS * (C_S_AXI_DATA_WIDTH / 8)) * 8) - 1:0] cfg_reg;
	reg [(N_SLAVE_PORT * C_S_AXI_DATA_WIDTH) - 1:0] init_connectivity_map_s;
	assign write_en = (wdata_done_rise & awaddr_done_reg) | (awaddr_done_rise & wdata_done_reg);
	assign wdata_done_rise = wdata_done_reg & ~wdata_done_reg_dly;
	assign awaddr_done_rise = awaddr_done_reg & ~awaddr_done_reg_dly;
	always @(posedge s_axi_aclk or negedge s_axi_aresetn)
		if (!s_axi_aresetn) begin
			wdata_done_reg_dly <= 0;
			awaddr_done_reg_dly <= 0;
		end
		else begin
			wdata_done_reg_dly <= wdata_done_reg;
			awaddr_done_reg_dly <= awaddr_done_reg;
		end
	always @(posedge s_axi_aclk or negedge s_axi_aresetn)
		if (!s_axi_aresetn) begin
			awaddr_done_reg <= 0;
			waddr_reg <= 0;
			awready <= 1;
		end
		else if (awready && s_axi_awvalid) begin
			awready <= 0;
			awaddr_done_reg <= 1;
			waddr_reg <= {2'b00, s_axi_awaddr[31:2]};
		end
		else if (awaddr_done_reg && wresp_done_reg) begin
			awready <= 1;
			awaddr_done_reg <= 0;
		end
	always @(posedge s_axi_aclk or negedge s_axi_aresetn)
		if (!s_axi_aresetn) begin
			wdata_done_reg <= 0;
			wready <= 1;
			wdata_reg <= 0;
			wstrb_reg <= 0;
		end
		else if (wready && s_axi_wvalid) begin
			wready <= 0;
			wdata_done_reg <= 1;
			wdata_reg <= s_axi_wdata;
			wstrb_reg <= s_axi_wstrb;
		end
		else if (wdata_done_reg && wresp_done_reg) begin
			wready <= 1;
			wdata_done_reg <= 0;
		end
	always @(posedge s_axi_aclk or negedge s_axi_aresetn)
		if (!s_axi_aresetn) begin
			bvalid <= 0;
			wresp_done_reg <= 0;
			wresp_running_reg <= 0;
		end
		else if ((awaddr_done_reg && wdata_done_reg) && !wresp_done_reg) begin
			if (!wresp_running_reg) begin
				bvalid <= 1;
				wresp_running_reg <= 1;
			end
			else if (s_axi_bready) begin
				bvalid <= 0;
				wresp_done_reg <= 1;
				wresp_running_reg <= 0;
			end
		end
		else begin
			bvalid <= 0;
			wresp_done_reg <= 0;
			wresp_running_reg <= 0;
		end
	always @(posedge s_axi_aclk or negedge s_axi_aresetn)
		if (!s_axi_aresetn) begin
			araddr_done_reg <= 0;
			arready <= 1;
			raddr_reg <= 0;
		end
		else if (arready && s_axi_arvalid) begin
			arready <= 0;
			araddr_done_reg <= 1;
			raddr_reg <= s_axi_araddr;
		end
		else if (araddr_done_reg && rresp_done_reg) begin
			arready <= 1;
			araddr_done_reg <= 0;
		end
	always @(posedge s_axi_aclk or negedge s_axi_aresetn)
		if (!s_axi_aresetn) begin
			rresp_done_reg <= 0;
			rvalid <= 0;
			rresp_running_reg <= 0;
		end
		else if (araddr_done_reg && !rresp_done_reg) begin
			if (!rresp_running_reg) begin
				rvalid <= 1;
				rresp_running_reg <= 1;
			end
			else if (s_axi_rready) begin
				rvalid <= 0;
				rresp_done_reg <= 1;
				rresp_running_reg <= 0;
			end
		end
		else begin
			rvalid <= 0;
			rresp_done_reg <= 0;
			rresp_running_reg <= 0;
		end
	generate
		if (N_MASTER_PORT < 32) begin : genblk1
			always @(*)
				for (w = 0; w < N_SLAVE_PORT; w = w + 1)
					begin
						init_connectivity_map_s[(w * C_S_AXI_DATA_WIDTH) + (N_MASTER_PORT - 1)-:N_MASTER_PORT] = init_connectivity_map_i[w * N_MASTER_PORT+:N_MASTER_PORT];
						init_connectivity_map_s[(w * C_S_AXI_DATA_WIDTH) + ((C_S_AXI_DATA_WIDTH - 1) >= N_MASTER_PORT ? C_S_AXI_DATA_WIDTH - 1 : ((C_S_AXI_DATA_WIDTH - 1) + ((C_S_AXI_DATA_WIDTH - 1) >= N_MASTER_PORT ? ((C_S_AXI_DATA_WIDTH - 1) - N_MASTER_PORT) + 1 : (N_MASTER_PORT - (C_S_AXI_DATA_WIDTH - 1)) + 1)) - 1)-:((C_S_AXI_DATA_WIDTH - 1) >= N_MASTER_PORT ? ((C_S_AXI_DATA_WIDTH - 1) - N_MASTER_PORT) + 1 : (N_MASTER_PORT - (C_S_AXI_DATA_WIDTH - 1)) + 1)] = 1'sb0;
					end
		end
		else begin : genblk1
			always @(*)
				for (w = 0; w < N_SLAVE_PORT; w = w + 1)
					init_connectivity_map_s[w * C_S_AXI_DATA_WIDTH+:C_S_AXI_DATA_WIDTH] = init_connectivity_map_i[w * N_MASTER_PORT+:N_MASTER_PORT];
		end
	endgenerate
	always @(posedge s_axi_aclk or negedge s_axi_aresetn)
		if (s_axi_aresetn == 1'b0) begin
			for (y = 0; y < N_REGION_MAX; y = y + 1)
				for (k = 0; k < N_MASTER_PORT; k = k + 1)
					begin
						cfg_reg[8 * (((y * 4) + ((k * 4) * N_REGION_MAX)) * (C_S_AXI_DATA_WIDTH / 8))+:8 * (C_S_AXI_DATA_WIDTH / 8)] <= init_START_ADDR_i[((y * N_MASTER_PORT) + k) * C_S_AXI_DATA_WIDTH+:C_S_AXI_DATA_WIDTH];
						cfg_reg[8 * ((((y * 4) + ((k * 4) * N_REGION_MAX)) + 1) * (C_S_AXI_DATA_WIDTH / 8))+:8 * (C_S_AXI_DATA_WIDTH / 8)] <= init_END_ADDR_i[((y * N_MASTER_PORT) + k) * C_S_AXI_DATA_WIDTH+:C_S_AXI_DATA_WIDTH];
						cfg_reg[8 * ((((y * 4) + ((k * 4) * N_REGION_MAX)) + 2) * (C_S_AXI_DATA_WIDTH / 8))+:8 * (C_S_AXI_DATA_WIDTH / 8)] <= {{C_S_AXI_DATA_WIDTH - 1 {1'b0}}, init_valid_rule_i[(y * N_MASTER_PORT) + k]};
						cfg_reg[8 * ((((y * 4) + ((k * 4) * N_REGION_MAX)) + 3) * (C_S_AXI_DATA_WIDTH / 8))+:8 * (C_S_AXI_DATA_WIDTH / 8)] <= 32'hdeadbeef;
					end
			for (y = 0; y < N_SLAVE_PORT; y = y + 1)
				cfg_reg[8 * ((((N_MASTER_PORT * 4) * N_REGION_MAX) + y) * (C_S_AXI_DATA_WIDTH / 8))+:8 * (C_S_AXI_DATA_WIDTH / 8)] <= init_connectivity_map_s[y * C_S_AXI_DATA_WIDTH+:C_S_AXI_DATA_WIDTH];
		end
		else if (write_en)
			for (byte_index = 0; byte_index <= ((C_S_AXI_DATA_WIDTH / 8) - 1); byte_index = byte_index + 1)
				if (wstrb_reg[byte_index] == 1)
					cfg_reg[((waddr_reg[7:0] * (C_S_AXI_DATA_WIDTH / 8)) + byte_index) * 8+:8] <= wdata_reg[byte_index * 8+:8];
	generate
		for (i = 0; i < N_REGION_MAX; i = i + 1) begin : genblk2
			for (j = 0; j < N_MASTER_PORT; j = j + 1) begin : genblk1
				assign START_ADDR_o[((i * N_MASTER_PORT) + j) * C_S_AXI_DATA_WIDTH+:C_S_AXI_DATA_WIDTH] = cfg_reg[8 * (((i * 4) + ((j * 4) * N_REGION_MAX)) * (C_S_AXI_DATA_WIDTH / 8))+:8 * (C_S_AXI_DATA_WIDTH / 8)];
				assign END_ADDR_o[((i * N_MASTER_PORT) + j) * C_S_AXI_DATA_WIDTH+:C_S_AXI_DATA_WIDTH] = cfg_reg[8 * ((((i * 4) + ((j * 4) * N_REGION_MAX)) + 1) * (C_S_AXI_DATA_WIDTH / 8))+:8 * (C_S_AXI_DATA_WIDTH / 8)];
				assign valid_rule_o[(i * N_MASTER_PORT) + j] = cfg_reg[((((i * 4) + ((j * 4) * N_REGION_MAX)) + 2) * (C_S_AXI_DATA_WIDTH / 8)) * 8];
			end
		end
		for (i = 0; i < N_SLAVE_PORT; i = i + 1) begin : genblk3
			assign temp_reg[i * C_S_AXI_DATA_WIDTH+:C_S_AXI_DATA_WIDTH] = cfg_reg[8 * ((((N_MASTER_PORT * 4) * N_REGION_MAX) + i) * (C_S_AXI_DATA_WIDTH / 8))+:8 * (C_S_AXI_DATA_WIDTH / 8)];
			assign connectivity_map_o[i * N_MASTER_PORT+:N_MASTER_PORT] = temp_reg[(i * C_S_AXI_DATA_WIDTH) + (N_MASTER_PORT - 1)-:N_MASTER_PORT];
		end
	endgenerate
	always @(*) data_out_reg = cfg_reg[8 * (raddr_reg[7:0] * (C_S_AXI_DATA_WIDTH / 8))+:8 * (C_S_AXI_DATA_WIDTH / 8)];
	assign s_axi_awready = awready;
	assign s_axi_wready = wready;
	assign s_axi_bresp = 2'b00;
	assign s_axi_bvalid = bvalid;
	assign s_axi_arready = arready;
	assign s_axi_rresp = 2'b00;
	assign s_axi_rvalid = rvalid;
	assign s_axi_rdata = data_out_reg;
endmodule
