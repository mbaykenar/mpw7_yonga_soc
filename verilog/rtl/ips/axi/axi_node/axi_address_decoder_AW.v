module axi_address_decoder_AW 
#(
    parameter  ADDR_WIDTH     = 32,
    parameter  N_INIT_PORT    = 8,
    parameter  N_REGION       = 2
)
(
	clk,
	rst_n,
	awvalid_i,
	awaddr_i,
	awready_o,
	awvalid_o,
	awready_i,
	grant_FIFO_DEST_i,
	DEST_o,
	push_DEST_o,
	START_ADDR_i,
	END_ADDR_i,
	enable_region_i,
	connectivity_map_i,
	incr_req_o,
	full_counter_i,
	outstanding_trans_i,
	error_req_o,
	error_gnt_i,
	handle_error_o,
	wdata_error_completed_i,
	sample_awdata_info_o
);
	//parameter ADDR_WIDTH = 32;
	//parameter N_INIT_PORT = 8;
	//parameter N_REGION = 2;
	input wire clk;
	input wire rst_n;
	input wire awvalid_i;
	input wire [ADDR_WIDTH - 1:0] awaddr_i;
	output reg awready_o;
	output reg [N_INIT_PORT - 1:0] awvalid_o;
	input wire [N_INIT_PORT - 1:0] awready_i;
	input wire grant_FIFO_DEST_i;
	output wire [N_INIT_PORT - 1:0] DEST_o;
	output wire push_DEST_o;
	input wire [((N_REGION * N_INIT_PORT) * ADDR_WIDTH) - 1:0] START_ADDR_i;
	input wire [((N_REGION * N_INIT_PORT) * ADDR_WIDTH) - 1:0] END_ADDR_i;
	input wire [(N_REGION * N_INIT_PORT) - 1:0] enable_region_i;
	input wire [N_INIT_PORT - 1:0] connectivity_map_i;
	output reg incr_req_o;
	input wire full_counter_i;
	input wire outstanding_trans_i;
	output reg error_req_o;
	input wire error_gnt_i;
	output reg handle_error_o;
	input wire wdata_error_completed_i;
	output reg sample_awdata_info_o;
	wire [N_INIT_PORT - 1:0] match_region;
	wire [N_INIT_PORT:0] match_region_masked;
	wire [(N_REGION * N_INIT_PORT) - 1:0] match_region_int;
	wire [(N_INIT_PORT * N_REGION) - 1:0] match_region_rev;
	reg awready_int;
	reg [N_INIT_PORT - 1:0] awvalid_int;
	reg error_detected;
	wire local_increm;
	genvar i;
	genvar j;
	assign DEST_o = match_region[N_INIT_PORT - 1:0];
	assign push_DEST_o = |(awvalid_i & awready_o) & ~error_detected;
	reg [1:0] CS;
	reg [1:0] NS;
	generate
		for (j = 0; j < N_REGION; j = j + 1) begin : genblk1
			for (i = 0; i < N_INIT_PORT; i = i + 1) begin : genblk1
				assign match_region_int[(j * N_INIT_PORT) + i] = (enable_region_i[(j * N_INIT_PORT) + i] == 1'b1 ? (awaddr_i >= START_ADDR_i[((j * N_INIT_PORT) + i) * ADDR_WIDTH+:ADDR_WIDTH]) && (awaddr_i <= END_ADDR_i[((j * N_INIT_PORT) + i) * ADDR_WIDTH+:ADDR_WIDTH]) : 1'b0);
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
	always @(*)
		if (grant_FIFO_DEST_i == 1'b1) begin
			if (awvalid_i)
				{error_detected, awvalid_int} = {N_INIT_PORT + 1 {awvalid_i}} & match_region_masked;
			else begin
				awvalid_int = 1'sb0;
				error_detected = 1'b0;
			end
			awready_int = |({error_gnt_i, awready_i} & match_region_masked);
		end
		else begin
			awvalid_int = 1'sb0;
			awready_int = 1'b0;
			error_detected = 1'b0;
		end
	always @(posedge clk or negedge rst_n)
		if (rst_n == 1'b0)
			CS <= 2'd0;
		else
			CS <= NS;
	assign local_increm = |(awvalid_o & awready_i);
	always @(*) begin
		awready_o = 1'b0;
		handle_error_o = 1'b0;
		sample_awdata_info_o = 1'b0;
		error_req_o = 1'b0;
		incr_req_o = 1'b0;
		awvalid_o = 1'sb0;
		case (CS)
			2'd0: begin
				handle_error_o = 1'b0;
				incr_req_o = local_increm;
				if (error_detected) begin
					NS = 2'd1;
					awready_o = 1'b1;
					sample_awdata_info_o = 1'b1;
					awvalid_o = 1'sb0;
				end
				else begin
					NS = 2'd0;
					awready_o = awready_int;
					awvalid_o = awvalid_int;
				end
			end
			2'd1: begin
				awready_o = 1'b0;
				handle_error_o = 1'b0;
				if (outstanding_trans_i) begin
					NS = 2'd1;
					awready_o = 1'b0;
				end
				else begin
					awready_o = 1'b0;
					NS = 2'd2;
				end
			end
			2'd2: begin
				awready_o = 1'b0;
				handle_error_o = 1'b1;
				if (wdata_error_completed_i)
					NS = 2'd3;
				else
					NS = 2'd2;
			end
			2'd3: begin
				handle_error_o = 1'b0;
				error_req_o = 1'b1;
				if (error_gnt_i)
					NS = 2'd0;
				else
					NS = 2'd3;
			end
			default: begin
				NS = 2'd0;
				awready_o = awready_int;
				handle_error_o = 1'b0;
			end
		endcase
	end
endmodule
