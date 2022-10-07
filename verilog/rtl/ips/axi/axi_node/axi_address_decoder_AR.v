module axi_address_decoder_AR 
#(
    parameter  ADDR_WIDTH     = 32,
    parameter  N_INIT_PORT    = 8,
    parameter  N_REGION       = 4
)
(
	clk,
	rst_n,
	arvalid_i,
	araddr_i,
	arready_o,
	arvalid_o,
	arready_i,
	START_ADDR_i,
	END_ADDR_i,
	enable_region_i,
	connectivity_map_i,
	incr_req_o,
	full_counter_i,
	outstanding_trans_i,
	error_req_o,
	error_gnt_i,
	sample_ardata_info_o
);
	//parameter ADDR_WIDTH = 32;
	//parameter N_INIT_PORT = 8;
	//parameter N_REGION = 4;
	input wire clk;
	input wire rst_n;
	input wire arvalid_i;
	input wire [ADDR_WIDTH - 1:0] araddr_i;
	output reg arready_o;
	output reg [N_INIT_PORT - 1:0] arvalid_o;
	input wire [N_INIT_PORT - 1:0] arready_i;
	input wire [((N_REGION * N_INIT_PORT) * ADDR_WIDTH) - 1:0] START_ADDR_i;
	input wire [((N_REGION * N_INIT_PORT) * ADDR_WIDTH) - 1:0] END_ADDR_i;
	input wire [(N_REGION * N_INIT_PORT) - 1:0] enable_region_i;
	input wire [N_INIT_PORT - 1:0] connectivity_map_i;
	output reg incr_req_o;
	input wire full_counter_i;
	input wire outstanding_trans_i;
	output reg error_req_o;
	input wire error_gnt_i;
	output reg sample_ardata_info_o;
	wire [N_INIT_PORT - 1:0] match_region;
	wire [N_INIT_PORT:0] match_region_masked;
	wire [(N_REGION * N_INIT_PORT) - 1:0] match_region_int;
	wire [(N_INIT_PORT * N_REGION) - 1:0] match_region_rev;
	reg arready_int;
	reg [N_INIT_PORT - 1:0] arvalid_int;
	genvar i;
	genvar j;
	reg CS;
	reg NS;
	generate
		for (j = 0; j < N_REGION; j = j + 1) begin : genblk1
			for (i = 0; i < N_INIT_PORT; i = i + 1) begin : genblk1
				assign match_region_int[(j * N_INIT_PORT) + i] = (enable_region_i[(j * N_INIT_PORT) + i] == 1'b1 ? (araddr_i >= START_ADDR_i[((j * N_INIT_PORT) + i) * ADDR_WIDTH+:ADDR_WIDTH]) && (araddr_i <= END_ADDR_i[((j * N_INIT_PORT) + i) * ADDR_WIDTH+:ADDR_WIDTH]) : 1'b0);
			end
		end
		for (j = 0; j < N_INIT_PORT; j = j + 1) begin : genblk2
			for (i = 0; i < N_REGION; i = i + 1) begin : genblk1
				assign match_region_rev[(j * N_REGION) + i] = match_region_int[(i * N_INIT_PORT) + j];
			end
		end
		for (i = 0; i < N_INIT_PORT; i = i + 1) begin : genblk3
			assign match_region[i] = |match_region_rev[i * N_REGION+:N_REGION];
		end
	endgenerate
	assign match_region_masked[N_INIT_PORT - 1:0] = match_region & connectivity_map_i;
	assign match_region_masked[N_INIT_PORT] = ~(|match_region_masked[N_INIT_PORT - 1:0]);
	always @(*) begin
		if (arvalid_i)
			{error_req_o, arvalid_int} = {N_INIT_PORT + 1 {arvalid_i}} & match_region_masked;
		else begin
			arvalid_int = 1'sb0;
			error_req_o = 1'b0;
		end
		arready_int = |({error_gnt_i, arready_i} & match_region_masked);
	end
	always @(posedge clk or negedge rst_n)
		if (rst_n == 1'b0)
			CS <= 1'd0;
		else
			CS <= NS;
	always @(*) begin
		arready_o = 1'b0;
		arvalid_o = arvalid_int;
		sample_ardata_info_o = 1'b0;
		incr_req_o = 1'b0;
		case (CS)
			1'd0:
				if (error_req_o) begin
					NS = 1'd1;
					arready_o = 1'b1;
					sample_ardata_info_o = 1'b1;
					arvalid_o = 1'sb0;
				end
				else begin
					NS = 1'd0;
					arready_o = arready_int;
					sample_ardata_info_o = 1'b0;
					incr_req_o = |(arvalid_o & arready_i);
					arvalid_o = arvalid_int;
				end
			1'd1: begin
				arready_o = 1'b0;
				arvalid_o = 1'sb0;
				if (outstanding_trans_i)
					NS = 1'd1;
				else if (error_gnt_i)
					NS = 1'd0;
				else
					NS = 1'd1;
			end
			default: begin
				NS = 1'd0;
				arready_o = arready_int;
			end
		endcase
	end
endmodule
