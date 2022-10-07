module axi_write_only_ctrl 
#(
    parameter AXI4_ADDRESS_WIDTH = 32,
    parameter AXI4_RDATA_WIDTH   = 64,
    parameter AXI4_WDATA_WIDTH   = 64,
    parameter AXI4_ID_WIDTH      = 16,
    parameter AXI4_USER_WIDTH    = 10,
    parameter AXI_NUMBYTES       = AXI4_WDATA_WIDTH/8,
    parameter MEM_ADDR_WIDTH     = 13
)
(
	clk,
	rst_n,
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
	MEM_CEN_o,
	MEM_WEN_o,
	MEM_A_o,
	MEM_D_o,
	MEM_BE_o,
	MEM_Q_i,
	grant_i,
	valid_o
);
	//parameter AXI4_ADDRESS_WIDTH = 32;
	//parameter AXI4_RDATA_WIDTH = 64;
	//parameter AXI4_WDATA_WIDTH = 64;
	//parameter AXI4_ID_WIDTH = 16;
	//parameter AXI4_USER_WIDTH = 10;
	//parameter AXI_NUMBYTES = AXI4_WDATA_WIDTH / 8;
	//parameter MEM_ADDR_WIDTH = 13;
	input wire clk;
	input wire rst_n;
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
	output reg AWREADY_o;
	input wire [AXI4_WDATA_WIDTH - 1:0] WDATA_i;
	input wire [AXI_NUMBYTES - 1:0] WSTRB_i;
	input wire WLAST_i;
	input wire [AXI4_USER_WIDTH - 1:0] WUSER_i;
	input wire WVALID_i;
	output reg WREADY_o;
	output wire [AXI4_ID_WIDTH - 1:0] BID_o;
	output reg [1:0] BRESP_o;
	output reg BVALID_o;
	output wire [AXI4_USER_WIDTH - 1:0] BUSER_o;
	input wire BREADY_i;
	output reg MEM_CEN_o;
	output reg MEM_WEN_o;
	output reg [MEM_ADDR_WIDTH - 1:0] MEM_A_o;
	output reg [AXI4_RDATA_WIDTH - 1:0] MEM_D_o;
	output reg [AXI_NUMBYTES - 1:0] MEM_BE_o;
	input wire [AXI4_RDATA_WIDTH - 1:0] MEM_Q_i;
	input wire grant_i;
	output reg valid_o;
	localparam OFFSET_BIT = $clog2(AXI4_WDATA_WIDTH) - 3;
	reg [2:0] CS;
	reg [2:0] NS;
	reg [8:0] CountBurst_CS;
	reg [8:0] CountBurst_NS;
	reg sample_ctrl;
	wire sample_backward;
	reg [AXI4_USER_WIDTH - 1:0] AWUSER_REG;
	reg [AXI4_ID_WIDTH - 1:0] AWID_REG;
	reg [MEM_ADDR_WIDTH - 1:0] AWADDR_REG;
	reg [MEM_ADDR_WIDTH - 1:0] AWADDR_REG_incr;
	reg [7:0] AWLEN_REG;
	always @(posedge clk or negedge rst_n) begin : _UPDATE_CS_
		if (~rst_n) begin
			CS <= 3'd0;
			CountBurst_CS <= 1'sb0;
			AWADDR_REG_incr <= 1'sb0;
			AWID_REG <= 1'sb0;
			AWUSER_REG <= 1'sb0;
			AWADDR_REG <= 1'sb0;
			AWLEN_REG <= 1'sb0;
		end
		else begin
			CS <= NS;
			CountBurst_CS <= CountBurst_NS;
			if (sample_ctrl) begin
				AWUSER_REG <= AWUSER_i;
				AWID_REG <= AWID_i;
				AWADDR_REG <= AWADDR_i[(MEM_ADDR_WIDTH + OFFSET_BIT) - 1:OFFSET_BIT];
				AWLEN_REG <= AWLEN_i;
			end
		end
	end
	assign BUSER_o = AWUSER_REG;
	assign BID_o = AWID_REG;
	always @(*) begin : COMPUTE_NS
		sample_ctrl = 1'b0;
		valid_o = 1'b0;
		AWREADY_o = 1'b0;
		WREADY_o = 1'b0;
		BRESP_o = 2'b00;
		BVALID_o = 1'b0;
		MEM_CEN_o = 1'b1;
		MEM_WEN_o = 1'b0;
		MEM_A_o = AWADDR_i[(MEM_ADDR_WIDTH + OFFSET_BIT) - 1:OFFSET_BIT];
		MEM_D_o = WDATA_i;
		MEM_BE_o = WSTRB_i;
		NS = CS;
		CountBurst_NS = CountBurst_CS;
		case (CS)
			3'd0: begin
				AWREADY_o = 1'b1;
				sample_ctrl = AWVALID_i;
				MEM_A_o = AWADDR_i[(MEM_ADDR_WIDTH + OFFSET_BIT) - 1:OFFSET_BIT];
				if (AWVALID_i) begin
					valid_o = WVALID_i;
					MEM_CEN_o = ~WVALID_i;
					WREADY_o = grant_i;
					if (WVALID_i & grant_i) begin
						if (AWLEN_i == 0) begin
							NS = 3'd1;
							CountBurst_NS = 1'sb0;
						end
						else begin
							NS = 3'd2;
							CountBurst_NS = 1;
						end
					end
					else begin
						NS = 3'd3;
						CountBurst_NS = 1'sb0;
					end
				end
				else
					NS = 3'd0;
			end
			3'd3: begin
				WREADY_o = grant_i;
				valid_o = WVALID_i;
				MEM_CEN_o = ~(WVALID_i & grant_i);
				MEM_A_o = AWADDR_REG + CountBurst_CS;
				if (grant_i & WVALID_i) begin
					if (AWLEN_REG == CountBurst_CS) begin
						NS = 3'd1;
						CountBurst_NS = 1'sb0;
					end
					else begin
						NS = 3'd2;
						CountBurst_NS = CountBurst_CS + 1;
					end
				end
				else
					NS = 3'd3;
			end
			3'd1: begin
				BRESP_o = 2'b00;
				BVALID_o = 1'b1;
				MEM_A_o = AWADDR_i[(MEM_ADDR_WIDTH + OFFSET_BIT) - 1:OFFSET_BIT];
				if (BREADY_i) begin
					AWREADY_o = 1'b1;
					sample_ctrl = AWVALID_i;
					if (AWVALID_i) begin
						valid_o = WVALID_i;
						MEM_CEN_o = ~WVALID_i;
						WREADY_o = grant_i;
						if (WVALID_i & grant_i) begin
							if (AWLEN_i == 0) begin
								CountBurst_NS = 1'sb0;
								if (WLAST_i == 1'b1)
									NS = 3'd1;
								else
									NS = 3'd4;
							end
							else begin
								NS = 3'd2;
								CountBurst_NS = 1;
							end
						end
						else begin
							NS = 3'd3;
							CountBurst_NS = 1'sb0;
						end
					end
					else
						NS = 3'd0;
				end
				else
					NS = 3'd1;
			end
			3'd2: begin
				WREADY_o = grant_i;
				MEM_CEN_o = ~WVALID_i;
				valid_o = WVALID_i;
				MEM_A_o = AWADDR_REG + CountBurst_CS;
				if (WVALID_i & grant_i) begin
					if (AWLEN_REG == CountBurst_CS) begin
						if (WLAST_i == 1'b1) begin
							NS = 3'd1;
							CountBurst_NS = 1'sb0;
						end
						else begin
							NS = 3'd4;
							CountBurst_NS = 1'sb0;
						end
					end
					else begin
						NS = 3'd2;
						CountBurst_NS = CountBurst_CS + 1;
					end
				end
				else
					NS = 3'd3;
			end
			3'd4: NS = 3'd4;
			default: NS = 3'd0;
		endcase
	end
endmodule
