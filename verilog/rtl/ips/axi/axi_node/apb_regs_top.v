module apb_regs_top 
#(
    parameter APB_ADDR_WIDTH     = 12,  //APB slaves are 4KB by default
    parameter APB_DATA_WIDTH     = 32,
    parameter N_REGION_MAX       = 4,
    parameter N_MASTER_PORT      = 16,
    parameter N_SLAVE_PORT       = 16
)
(
	HCLK,
	HRESETn,
	PADDR_i,
	PWDATA_i,
	PWRITE_i,
	PSEL_i,
	PENABLE_i,
	PRDATA_o,
	PREADY_o,
	PSLVERR_o,
	init_START_ADDR_i,
	init_END_ADDR_i,
	init_valid_rule_i,
	init_connectivity_map_i,
	START_ADDR_o,
	END_ADDR_o,
	valid_rule_o,
	connectivity_map_o
);
	//parameter APB_ADDR_WIDTH = 12;
	//parameter APB_DATA_WIDTH = 32;
	//parameter N_REGION_MAX = 4;
	//parameter N_MASTER_PORT = 16;
	//parameter N_SLAVE_PORT = 16;
	input wire HCLK;
	input wire HRESETn;
	input wire [APB_ADDR_WIDTH - 1:0] PADDR_i;
	input wire [APB_DATA_WIDTH - 1:0] PWDATA_i;
	input wire PWRITE_i;
	input wire PSEL_i;
	input wire PENABLE_i;
	output reg [APB_DATA_WIDTH - 1:0] PRDATA_o;
	output wire PREADY_o;
	output wire PSLVERR_o;
	input wire [((N_REGION_MAX * N_MASTER_PORT) * 32) - 1:0] init_START_ADDR_i;
	input wire [((N_REGION_MAX * N_MASTER_PORT) * 32) - 1:0] init_END_ADDR_i;
	input wire [(N_REGION_MAX * N_MASTER_PORT) - 1:0] init_valid_rule_i;
	input wire [(N_SLAVE_PORT * N_MASTER_PORT) - 1:0] init_connectivity_map_i;
	output wire [((N_REGION_MAX * N_MASTER_PORT) * 32) - 1:0] START_ADDR_o;
	output wire [((N_REGION_MAX * N_MASTER_PORT) * 32) - 1:0] END_ADDR_o;
	output wire [(N_REGION_MAX * N_MASTER_PORT) - 1:0] valid_rule_o;
	output wire [(N_SLAVE_PORT * N_MASTER_PORT) - 1:0] connectivity_map_o;
	reg [((N_REGION_MAX * N_MASTER_PORT) * 32) - 1:0] cfg_req_START_ADDR;
	reg [((N_REGION_MAX * N_MASTER_PORT) * 32) - 1:0] cfg_req_END_ADDR;
	reg [(N_REGION_MAX * N_MASTER_PORT) - 1:0] cfg_req_valid_rule;
	reg [(N_SLAVE_PORT * N_MASTER_PORT) - 1:0] cfg_req_connectivity_map;
	always @(posedge HCLK)
		if (~HRESETn) begin
			cfg_req_START_ADDR <= init_START_ADDR_i;
			cfg_req_END_ADDR <= init_END_ADDR_i;
			cfg_req_valid_rule <= init_valid_rule_i;
			cfg_req_connectivity_map <= init_connectivity_map_i;
		end
		else if ((PSEL_i && PENABLE_i) && PWRITE_i)
			case (PADDR_i[9:8])
				2'b00: cfg_req_START_ADDR[PADDR_i[7:2] * 32+:32] <= PWDATA_i[31:0];
				2'b01: cfg_req_END_ADDR[PADDR_i[7:2] * 32+:32] <= PWDATA_i[31:0];
				2'b10: cfg_req_valid_rule[PADDR_i[7:2] * N_MASTER_PORT+:N_MASTER_PORT] <= PWDATA_i[N_MASTER_PORT - 1:0];
				2'b11: cfg_req_END_ADDR[PADDR_i[7:2] * 32+:32] <= PWDATA_i[N_MASTER_PORT - 1:0];
			endcase
	always @(*)
		if ((PSEL_i && PENABLE_i) && ~PWRITE_i)
			case (PADDR_i[9:8])
				2'b00: PRDATA_o[31:0] = cfg_req_START_ADDR[PADDR_i[7:2] * 32+:32];
				2'b01: PRDATA_o[31:0] = cfg_req_END_ADDR[PADDR_i[7:2] * 32+:32];
				2'b10: PRDATA_o[31:0] = cfg_req_valid_rule[PADDR_i[7:2] * N_MASTER_PORT+:N_MASTER_PORT];
				2'b11: PRDATA_o[31:0] = cfg_req_END_ADDR[PADDR_i[7:2] * 32+:32];
			endcase
		else
			PRDATA_o = 1'sb0;
	assign PREADY_o = 1'b1;
	assign PSLVERR_o = 1'b0;
endmodule
