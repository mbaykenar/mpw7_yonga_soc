module core2axi 
#(
    parameter AXI4_ADDRESS_WIDTH = 32,
    parameter AXI4_RDATA_WIDTH   = 32,
    parameter AXI4_WDATA_WIDTH   = 32,
    parameter AXI4_ID_WIDTH      = 16,
    parameter AXI4_USER_WIDTH    = 10,
    parameter REGISTERED_GRANT   = "FALSE"           // "TRUE"|"FALSE"
)
(
	clk_i,
	rst_ni,
	data_req_i,
	data_gnt_o,
	data_rvalid_o,
	data_addr_i,
	data_we_i,
	data_be_i,
	data_rdata_o,
	data_wdata_i,
	aw_id_o,
	aw_addr_o,
	aw_len_o,
	aw_size_o,
	aw_burst_o,
	aw_lock_o,
	aw_cache_o,
	aw_prot_o,
	aw_region_o,
	aw_user_o,
	aw_qos_o,
	aw_valid_o,
	aw_ready_i,
	w_data_o,
	w_strb_o,
	w_last_o,
	w_user_o,
	w_valid_o,
	w_ready_i,
	b_id_i,
	b_resp_i,
	b_valid_i,
	b_user_i,
	b_ready_o,
	ar_id_o,
	ar_addr_o,
	ar_len_o,
	ar_size_o,
	ar_burst_o,
	ar_lock_o,
	ar_cache_o,
	ar_prot_o,
	ar_region_o,
	ar_user_o,
	ar_qos_o,
	ar_valid_o,
	ar_ready_i,
	r_id_i,
	r_data_i,
	r_resp_i,
	r_last_i,
	r_user_i,
	r_valid_i,
	r_ready_o
);
	//parameter AXI4_ADDRESS_WIDTH = 32;
	//parameter AXI4_RDATA_WIDTH = 32;
	//parameter AXI4_WDATA_WIDTH = 32;
	//parameter AXI4_ID_WIDTH = 16;
	//parameter AXI4_USER_WIDTH = 10;
	//parameter REGISTERED_GRANT = "FALSE";
	input wire clk_i;
	input wire rst_ni;
	input wire data_req_i;
	output wire data_gnt_o;
	output wire data_rvalid_o;
	input wire [AXI4_ADDRESS_WIDTH - 1:0] data_addr_i;
	input wire data_we_i;
	input wire [3:0] data_be_i;
	output wire [31:0] data_rdata_o;
	input wire [31:0] data_wdata_i;
	output wire [AXI4_ID_WIDTH - 1:0] aw_id_o;
	output wire [AXI4_ADDRESS_WIDTH - 1:0] aw_addr_o;
	output wire [7:0] aw_len_o;
	output wire [2:0] aw_size_o;
	output wire [1:0] aw_burst_o;
	output wire aw_lock_o;
	output wire [3:0] aw_cache_o;
	output wire [2:0] aw_prot_o;
	output wire [3:0] aw_region_o;
	output wire [AXI4_USER_WIDTH - 1:0] aw_user_o;
	output wire [3:0] aw_qos_o;
	output reg aw_valid_o;
	input wire aw_ready_i;
	output wire [AXI4_WDATA_WIDTH - 1:0] w_data_o;
	output wire [(AXI4_WDATA_WIDTH / 8) - 1:0] w_strb_o;
	output wire w_last_o;
	output wire [AXI4_USER_WIDTH - 1:0] w_user_o;
	output reg w_valid_o;
	input wire w_ready_i;
	input wire [AXI4_ID_WIDTH - 1:0] b_id_i;
	input wire [1:0] b_resp_i;
	input wire b_valid_i;
	input wire [AXI4_USER_WIDTH - 1:0] b_user_i;
	output reg b_ready_o;
	output wire [AXI4_ID_WIDTH - 1:0] ar_id_o;
	output wire [AXI4_ADDRESS_WIDTH - 1:0] ar_addr_o;
	output wire [7:0] ar_len_o;
	output wire [2:0] ar_size_o;
	output wire [1:0] ar_burst_o;
	output wire ar_lock_o;
	output wire [3:0] ar_cache_o;
	output wire [2:0] ar_prot_o;
	output wire [3:0] ar_region_o;
	output wire [AXI4_USER_WIDTH - 1:0] ar_user_o;
	output wire [3:0] ar_qos_o;
	output reg ar_valid_o;
	input wire ar_ready_i;
	input wire [AXI4_ID_WIDTH - 1:0] r_id_i;
	input wire [AXI4_RDATA_WIDTH - 1:0] r_data_i;
	input wire [1:0] r_resp_i;
	input wire r_last_i;
	input wire [AXI4_USER_WIDTH - 1:0] r_user_i;
	input wire r_valid_i;
	output reg r_ready_o;
	reg [2:0] CS;
	reg [2:0] NS;
	wire [31:0] rdata;
	reg valid;
	reg granted;
	always @(*) begin
		NS = CS;
		granted = 1'b0;
		valid = 1'b0;
		aw_valid_o = 1'b0;
		ar_valid_o = 1'b0;
		r_ready_o = 1'b0;
		w_valid_o = 1'b0;
		b_ready_o = 1'b0;
		case (CS)
			3'd0:
				if (data_req_i) begin
					if (data_we_i) begin
						aw_valid_o = 1'b1;
						w_valid_o = 1'b1;
						if (aw_ready_i) begin
							if (w_ready_i) begin
								granted = 1'b1;
								NS = 3'd4;
							end
							else
								NS = 3'd2;
						end
						else if (w_ready_i)
							NS = 3'd3;
						else
							NS = 3'd0;
					end
					else begin
						ar_valid_o = 1'b1;
						if (ar_ready_i) begin
							granted = 1'b1;
							NS = 3'd1;
						end
						else
							NS = 3'd0;
					end
				end
				else
					NS = 3'd0;
			3'd2: begin
				w_valid_o = 1'b1;
				if (w_ready_i) begin
					granted = 1'b1;
					NS = 3'd4;
				end
			end
			3'd3: begin
				aw_valid_o = 1'b1;
				if (aw_ready_i) begin
					granted = 1'b1;
					NS = 3'd4;
				end
			end
			3'd4: begin
				b_ready_o = 1'b1;
				if (b_valid_i) begin
					valid = 1'b1;
					NS = 3'd0;
				end
			end
			3'd1:
				if (r_valid_i) begin
					valid = 1'b1;
					r_ready_o = 1'b1;
					NS = 3'd0;
				end
			default: NS = 3'd0;
		endcase
	end
	always @(posedge clk_i or negedge rst_ni)
		if (~rst_ni)
			CS <= 3'd0;
		else
			CS <= NS;
	generate
		if (AXI4_RDATA_WIDTH == 32) begin : genblk1
			assign rdata = r_data_i[31:0];
		end
		else if (AXI4_RDATA_WIDTH == 64) begin : genblk1
			reg [0:0] addr_q;
			always @(posedge clk_i or negedge rst_ni)
				if (~rst_ni)
					addr_q <= 1'sb0;
				else if (data_gnt_o)
					addr_q <= data_addr_i[2:2];
			assign rdata = (addr_q[0] ? r_data_i[63:32] : r_data_i[31:0]);
		end
		else begin : genblk1
			initial $error("AXI4_WDATA_WIDTH has an invalid value");
		end
	endgenerate
	genvar w;
	generate
		for (w = 0; w < (AXI4_WDATA_WIDTH / 32); w = w + 1) begin : genblk2
			assign w_data_o[(w * 32) + 31:w * 32] = data_wdata_i;
		end
		if (AXI4_WDATA_WIDTH == 32) begin : genblk3
			assign w_strb_o = data_be_i;
		end
		else if (AXI4_WDATA_WIDTH == 64) begin : genblk3
			assign w_strb_o = (data_addr_i[2] ? {data_be_i, 4'b0000} : {4'b0000, data_be_i});
		end
		else begin : genblk3
			initial $error("AXI4_WDATA_WIDTH has an invalid value");
		end
	endgenerate
	assign aw_id_o = 1'sb0;
	assign aw_addr_o = data_addr_i;
	assign aw_size_o = 3'b010;
	assign aw_len_o = 1'sb0;
	assign aw_burst_o = 1'sb0;
	assign aw_lock_o = 1'sb0;
	assign aw_cache_o = 1'sb0;
	assign aw_prot_o = 1'sb0;
	assign aw_region_o = 1'sb0;
	assign aw_user_o = 1'sb0;
	assign aw_qos_o = 1'sb0;
	assign ar_id_o = 1'sb0;
	assign ar_addr_o = data_addr_i;
	assign ar_size_o = 3'b010;
	assign ar_len_o = 1'sb0;
	assign ar_burst_o = 1'sb0;
	assign ar_prot_o = 1'sb0;
	assign ar_region_o = 1'sb0;
	assign ar_lock_o = 1'sb0;
	assign ar_cache_o = 1'sb0;
	assign ar_qos_o = 1'sb0;
	assign ar_user_o = 1'sb0;
	assign w_last_o = 1'b1;
	assign w_user_o = 1'sb0;
	generate
		if (REGISTERED_GRANT == "TRUE") begin : genblk4
			reg valid_q;
			reg [31:0] rdata_q;
			always @(posedge clk_i or negedge rst_ni)
				if (~rst_ni) begin
					valid_q <= 1'b0;
					rdata_q <= 1'sb0;
				end
				else begin
					valid_q <= valid;
					if (valid)
						rdata_q <= rdata;
				end
			assign data_rdata_o = rdata_q;
			assign data_rvalid_o = valid_q;
			assign data_gnt_o = valid;
		end
		else begin : genblk4
			assign data_rdata_o = rdata;
			assign data_rvalid_o = valid;
			assign data_gnt_o = granted;
		end
	endgenerate
endmodule
