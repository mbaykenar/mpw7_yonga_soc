module ram_mux 
#(
    parameter ADDR_WIDTH = 32,
    parameter OUT_WIDTH = 32,
    parameter IN0_WIDTH = 32, // in widths cannot be bigger than out width
    parameter IN1_WIDTH = 32
  )
(
	clk,
	rst_n,
	port0_req_i,
	port0_gnt_o,
	port0_rvalid_o,
	port0_addr_i,
	port0_we_i,
	port0_be_i,
	port0_rdata_o,
	port0_wdata_i,
	port1_req_i,
	port1_gnt_o,
	port1_rvalid_o,
	port1_addr_i,
	port1_we_i,
	port1_be_i,
	port1_rdata_o,
	port1_wdata_i,
	ram_en_o,
	ram_addr_o,
	ram_we_o,
	ram_be_o,
	ram_rdata_i,
	ram_wdata_o
);
	//parameter ADDR_WIDTH = 32;
	//parameter OUT_WIDTH = 32;
	//parameter IN0_WIDTH = 32;
	//parameter IN1_WIDTH = 32;
	input wire clk;
	input wire rst_n;
	input wire port0_req_i;
	output reg port0_gnt_o;
	output reg port0_rvalid_o;
	input wire [ADDR_WIDTH - 1:0] port0_addr_i;
	input wire port0_we_i;
	input wire [(IN0_WIDTH / 8) - 1:0] port0_be_i;
	output wire [IN0_WIDTH - 1:0] port0_rdata_o;
	input wire [IN0_WIDTH - 1:0] port0_wdata_i;
	input wire port1_req_i;
	output reg port1_gnt_o;
	output reg port1_rvalid_o;
	input wire [ADDR_WIDTH - 1:0] port1_addr_i;
	input wire port1_we_i;
	input wire [(IN1_WIDTH / 8) - 1:0] port1_be_i;
	output wire [IN1_WIDTH - 1:0] port1_rdata_o;
	input wire [IN1_WIDTH - 1:0] port1_wdata_i;
	output wire ram_en_o;
	output wire [ADDR_WIDTH - 1:0] ram_addr_o;
	output wire ram_we_o;
	output wire [(OUT_WIDTH / 8) - 1:0] ram_be_o;
	input wire [OUT_WIDTH - 1:0] ram_rdata_i;
	output wire [OUT_WIDTH - 1:0] ram_wdata_o;
	localparam IN0_ADDR_HIGH = $clog2(OUT_WIDTH / 8) - 1;
	localparam IN0_ADDR_LOW = $clog2(IN0_WIDTH / 8);
	localparam IN0_RATIO = OUT_WIDTH / IN0_WIDTH;
	wire [(OUT_WIDTH / 8) - 1:0] port0_be;
	genvar i0;
	generate
		if (IN0_ADDR_HIGH >= IN0_ADDR_LOW) begin : genblk1
			reg port0_addr_q;
			wire [(IN0_RATIO * IN0_WIDTH) - 1:0] port0_rdata;
			always @(posedge clk or negedge rst_n)
				if (~rst_n)
					port0_addr_q <= 1'sb0;
				else if (port0_gnt_o)
					port0_addr_q <= port0_addr_i[IN0_ADDR_HIGH:IN0_ADDR_LOW];
			for (i0 = 0; i0 < IN0_RATIO; i0 = i0 + 1) begin : genblk1
				assign port0_be[(((i0 + 1) * IN0_WIDTH) / 8) - 1:(i0 * IN0_WIDTH) / 8] = (i0 == port0_addr_i[IN0_ADDR_HIGH:IN0_ADDR_LOW] ? port0_be_i : {(((((i0 + 1) * IN0_WIDTH) / 8) - 1) >= ((i0 * IN0_WIDTH) / 8) ? (((((i0 + 1) * IN0_WIDTH) / 8) - 1) - ((i0 * IN0_WIDTH) / 8)) + 1 : (((i0 * IN0_WIDTH) / 8) - ((((i0 + 1) * IN0_WIDTH) / 8) - 1)) + 1) {1'sb0}});
				assign port0_rdata[i0 * IN0_WIDTH+:IN0_WIDTH] = ram_rdata_i[((i0 + 1) * IN0_WIDTH) - 1:i0 * IN0_WIDTH];
			end
			assign port0_rdata_o = port0_rdata[port0_addr_q * IN0_WIDTH+:IN0_WIDTH];
		end
		else begin : genblk1
			assign port0_be = port0_be_i;
			assign port0_rdata_o = ram_rdata_i;
		end
	endgenerate
	localparam IN1_ADDR_HIGH = $clog2(OUT_WIDTH / 8) - 1;
	localparam IN1_ADDR_LOW = $clog2(IN1_WIDTH / 8);
	localparam IN1_RATIO = OUT_WIDTH / IN1_WIDTH;
	wire [(OUT_WIDTH / 8) - 1:0] port1_be;
	genvar i1;
	generate
		if (IN1_ADDR_HIGH >= IN1_ADDR_LOW) begin : genblk2
			reg port1_addr_q;
			wire [(IN1_RATIO * IN1_WIDTH) - 1:0] port1_rdata;
			always @(posedge clk or negedge rst_n)
				if (~rst_n)
					port1_addr_q <= 1'sb0;
				else if (port1_gnt_o)
					port1_addr_q <= port1_addr_i[IN1_ADDR_HIGH:IN1_ADDR_LOW];
			for (i1 = 0; i1 < (OUT_WIDTH / IN1_WIDTH); i1 = i1 + 1) begin : genblk1
				assign port1_be[(((i1 + 1) * IN1_WIDTH) / 8) - 1:(i1 * IN1_WIDTH) / 8] = (i1 == port1_addr_i[IN1_ADDR_HIGH:IN1_ADDR_LOW] ? port1_be_i : {(((((i1 + 1) * IN1_WIDTH) / 8) - 1) >= ((i1 * IN1_WIDTH) / 8) ? (((((i1 + 1) * IN1_WIDTH) / 8) - 1) - ((i1 * IN1_WIDTH) / 8)) + 1 : (((i1 * IN1_WIDTH) / 8) - ((((i1 + 1) * IN1_WIDTH) / 8) - 1)) + 1) {1'sb0}});
				assign port1_rdata[i1 * IN1_WIDTH+:IN1_WIDTH] = ram_rdata_i[((i1 + 1) * IN1_WIDTH) - 1:i1 * IN1_WIDTH];
			end
			assign port1_rdata_o = port1_rdata[port1_addr_q * IN1_WIDTH+:IN1_WIDTH];
		end
		else begin : genblk2
			assign port1_be = port1_be_i;
			assign port1_rdata_o = ram_rdata_i;
		end
	endgenerate
	always @(*) begin
		port0_gnt_o = 1'b0;
		port1_gnt_o = 1'b0;
		if (port0_req_i)
			port0_gnt_o = 1'b1;
		else if (port1_req_i)
			port1_gnt_o = 1'b1;
	end
	assign ram_en_o = port0_req_i | port1_req_i;
	assign ram_addr_o = (port0_req_i ? port0_addr_i : port1_addr_i);
	assign ram_wdata_o = (port0_req_i ? {OUT_WIDTH / IN0_WIDTH {port0_wdata_i}} : {OUT_WIDTH / IN1_WIDTH {port1_wdata_i}});
	assign ram_we_o = (port0_req_i ? port0_we_i : port1_we_i);
	assign ram_be_o = (port0_req_i ? port0_be : port1_be);
	always @(posedge clk or negedge rst_n)
		if (rst_n == 1'b0) begin
			port0_rvalid_o <= 1'b0;
			port1_rvalid_o <= 1'b0;
		end
		else begin
			port0_rvalid_o <= port0_gnt_o;
			port1_rvalid_o <= port1_gnt_o;
		end
endmodule
