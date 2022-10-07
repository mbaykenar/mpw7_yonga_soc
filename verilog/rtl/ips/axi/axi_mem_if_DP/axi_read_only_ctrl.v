module axi_read_only_ctrl 
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
	output reg ARREADY_o;
	output reg [AXI4_ID_WIDTH - 1:0] RID_o;
	output reg [AXI4_RDATA_WIDTH - 1:0] RDATA_o;
	output reg [1:0] RRESP_o;
	output reg RLAST_o;
	output reg [AXI4_USER_WIDTH - 1:0] RUSER_o;
	output reg RVALID_o;
	input wire RREADY_i;
	output reg MEM_CEN_o;
	output reg MEM_WEN_o;
	output reg [MEM_ADDR_WIDTH - 1:0] MEM_A_o;
	output wire [AXI4_RDATA_WIDTH - 1:0] MEM_D_o;
	output wire [AXI_NUMBYTES - 1:0] MEM_BE_o;
	input wire [AXI4_RDATA_WIDTH - 1:0] MEM_Q_i;
	input wire grant_i;
	output reg valid_o;
	localparam OFFSET_BIT = $clog2(AXI4_RDATA_WIDTH) - 3;
	reg [2:0] CS;
	reg [2:0] NS;
	reg [8:0] CountBurst_CS;
	reg [8:0] CountBurst_NS;
	reg sample_rdata;
	reg sample_ctrl;
	reg [AXI4_RDATA_WIDTH - 1:0] RDATA_REG;
	reg [AXI4_USER_WIDTH - 1:0] RUSER_REG;
	reg [AXI4_ID_WIDTH - 1:0] RID_REG;
	reg [MEM_ADDR_WIDTH - 1:0] ARADDR_REG;
	reg [7:0] ARLEN_REG;
	assign MEM_D_o = 1'sb0;
	assign MEM_BE_o = 1'sb0;
	always @(posedge clk or negedge rst_n) begin : _UPDATE_CS_
		if (~rst_n) begin
			CS <= 3'd0;
			CountBurst_CS <= 1'sb0;
			RDATA_REG <= 1'sb0;
			RID_REG <= 1'sb0;
			RUSER_REG <= 1'sb0;
			ARADDR_REG <= 1'sb0;
			ARLEN_REG <= 1'sb0;
		end
		else begin
			CS <= NS;
			CountBurst_CS <= CountBurst_NS;
			if (sample_ctrl) begin
				RUSER_REG <= ARUSER_i;
				RID_REG <= ARID_i;
				ARADDR_REG <= ARADDR_i[(MEM_ADDR_WIDTH + OFFSET_BIT) - 1:OFFSET_BIT];
				ARLEN_REG <= ARLEN_i;
			end
			if (sample_rdata)
				RDATA_REG <= MEM_Q_i;
		end
	end
	always @(*) begin : COMPUTE_NS
		ARREADY_o = 1'b0;
		RDATA_o = MEM_Q_i;
		RUSER_o = RUSER_REG;
		RID_o = RID_REG;
		RVALID_o = 1'b0;
		RLAST_o = 1'b0;
		RRESP_o = 2'b00;
		MEM_CEN_o = 1'b1;
		MEM_WEN_o = 1'b1;
		MEM_A_o = ARADDR_i[(MEM_ADDR_WIDTH + OFFSET_BIT) - 1:OFFSET_BIT];
		valid_o = 1'b0;
		sample_rdata = 1'b0;
		sample_ctrl = 1'b0;
		CountBurst_NS = CountBurst_CS;
		case (CS)
			3'd0: begin
				valid_o = ARVALID_i;
				MEM_CEN_o = ~ARVALID_i;
				ARREADY_o = grant_i;
				if (ARVALID_i) begin
					sample_ctrl = 1'b1;
					if (grant_i) begin
						ARREADY_o = 1'b1;
						if (ARLEN_i == 0) begin
							NS = 3'd1;
							CountBurst_NS = 1'sb0;
						end
						else begin
							NS = 3'd2;
							CountBurst_NS = 1'b1;
						end
					end
					else
						NS = 3'd0;
				end
				else
					NS = 3'd0;
			end
			3'd1: begin
				sample_rdata = 1'b1;
				RDATA_o = MEM_Q_i;
				RVALID_o = 1'b1;
				RLAST_o = 1'b1;
				RRESP_o = 2'b00;
				if (RREADY_i) begin
					ARREADY_o = grant_i;
					valid_o = ARVALID_i;
					MEM_CEN_o = ~ARVALID_i;
					if (ARVALID_i) begin
						sample_ctrl = 1'b1;
						if (grant_i) begin
							ARREADY_o = 1'b1;
							if (ARLEN_i == 0) begin
								NS = 3'd1;
								CountBurst_NS = 1'sb0;
							end
							else begin
								NS = 3'd2;
								CountBurst_NS = 1'b1;
							end
						end
						else
							NS = 3'd0;
					end
					else
						NS = 3'd0;
				end
				else
					NS = 3'd3;
			end
			3'd3: begin
				RDATA_o = RDATA_REG;
				RVALID_o = 1'b1;
				RLAST_o = 1'b1;
				RRESP_o = 2'b00;
				if (RREADY_i) begin
					ARREADY_o = grant_i;
					valid_o = ARVALID_i;
					MEM_CEN_o = ~ARVALID_i;
					if (ARVALID_i) begin
						sample_ctrl = 1'b1;
						if (grant_i) begin
							ARREADY_o = 1'b1;
							if (ARLEN_i == 0) begin
								NS = 3'd1;
								CountBurst_NS = 1'sb0;
							end
							else begin
								NS = 3'd2;
								CountBurst_NS = 1'b1;
							end
						end
						else
							NS = 3'd0;
					end
					else
						NS = 3'd0;
				end
				else
					NS = 3'd3;
			end
			3'd2: begin
				sample_rdata = 1'b1;
				RDATA_o = MEM_Q_i;
				RVALID_o = 1'b1;
				RLAST_o = 1'b0;
				RRESP_o = 2'b00;
				MEM_A_o = ARADDR_REG + CountBurst_CS;
				if (RREADY_i) begin
					sample_ctrl = 1'b0;
					MEM_CEN_o = 1'b0;
					valid_o = 1'b1;
					if (grant_i) begin
						NS = 3'd2;
						if (CountBurst_CS == ARLEN_REG) begin
							CountBurst_NS = 1'sb0;
							NS = 3'd4;
						end
						else begin
							NS = 3'd2;
							CountBurst_NS = CountBurst_CS + 1'b1;
						end
					end
					else
						NS = 3'd5;
				end
				else
					NS = 3'd6;
			end
			3'd5: begin
				MEM_CEN_o = 1'b0;
				MEM_A_o = ARADDR_REG + CountBurst_CS;
				valid_o = 1'b1;
				if (grant_i) begin
					if (CountBurst_CS == ARLEN_REG) begin
						NS = 3'd4;
						CountBurst_NS = 1'sb0;
					end
					else begin
						NS = 3'd2;
						CountBurst_NS = CountBurst_CS + 1;
					end
				end
				else
					NS = 3'd5;
			end
			3'd6: begin
				RDATA_o = RDATA_REG;
				RVALID_o = 1'b1;
				RLAST_o = 1'b0;
				RRESP_o = 2'b00;
				MEM_A_o = ARADDR_REG + CountBurst_CS;
				if (RREADY_i) begin
					valid_o = 1'b1;
					MEM_CEN_o = 1'b0;
					if (grant_i) begin
						CountBurst_NS = CountBurst_CS + 1;
						if (CountBurst_CS == ARLEN_REG)
							NS = 3'd4;
						else
							NS = 3'd2;
					end
					else
						NS = 3'd5;
				end
				else
					NS = 3'd6;
			end
			3'd4: begin
				RVALID_o = 1'b1;
				RLAST_o = 1'b1;
				RDATA_o = MEM_Q_i;
				sample_rdata = 1'b1;
				if (RREADY_i) begin
					valid_o = ARVALID_i;
					MEM_CEN_o = ~ARVALID_i;
					ARREADY_o = grant_i;
					if (ARVALID_i) begin
						sample_ctrl = 1'b1;
						if (grant_i) begin
							ARREADY_o = 1'b1;
							if (ARLEN_i == 0) begin
								NS = 3'd1;
								CountBurst_NS = 1'sb0;
							end
							else begin
								NS = 3'd2;
								CountBurst_NS = 1'b1;
							end
						end
						else
							NS = 3'd0;
					end
					else
						NS = 3'd0;
				end
				else
					NS = 3'd7;
			end
			3'd7: begin
				RVALID_o = 1'b1;
				RLAST_o = 1'b1;
				RDATA_o = RDATA_REG;
				sample_rdata = 1'b0;
				if (RREADY_i) begin
					valid_o = ARVALID_i;
					MEM_CEN_o = ~ARVALID_i;
					ARREADY_o = grant_i;
					if (ARVALID_i) begin
						sample_ctrl = 1'b1;
						if (grant_i) begin
							ARREADY_o = 1'b1;
							if (ARLEN_i == 0) begin
								NS = 3'd1;
								CountBurst_NS = 1'sb0;
							end
							else begin
								NS = 3'd2;
								CountBurst_NS = 1'b1;
							end
						end
						else
							NS = 3'd0;
					end
					else
						NS = 3'd0;
				end
				else
					NS = 3'd7;
			end
			default: NS = 3'd0;
		endcase
	end
endmodule
