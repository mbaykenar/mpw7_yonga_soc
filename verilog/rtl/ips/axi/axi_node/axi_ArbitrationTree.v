module axi_ArbitrationTree 
#(
      parameter AUX_WIDTH       = 64,
      parameter ID_WIDTH        = 20,
      parameter N_MASTER        = 5,
      parameter LOG_MASTER      = $clog2(N_MASTER)
)
(
	clk,
	rst_n,
	data_req_i,
	data_AUX_i,
	data_ID_i,
	data_gnt_o,
	data_req_o,
	data_AUX_o,
	data_ID_o,
	data_gnt_i,
	lock,
	SEL_EXCLUSIVE
);
	//parameter AUX_WIDTH = 64;
	//parameter ID_WIDTH = 20;
	//parameter N_MASTER = 5;
	//parameter LOG_MASTER = $clog2(N_MASTER);
	input wire clk;
	input wire rst_n;
	input wire [N_MASTER - 1:0] data_req_i;
	input wire [(N_MASTER * AUX_WIDTH) - 1:0] data_AUX_i;
	input wire [(N_MASTER * ID_WIDTH) - 1:0] data_ID_i;
	output wire [N_MASTER - 1:0] data_gnt_o;
	output wire data_req_o;
	output wire [AUX_WIDTH - 1:0] data_AUX_o;
	output wire [ID_WIDTH - 1:0] data_ID_o;
	input wire data_gnt_i;
	input wire lock;
	input wire [LOG_MASTER - 1:0] SEL_EXCLUSIVE;
	localparam TOTAL_N_MASTER = 2 ** LOG_MASTER;
	localparam N_WIRE = TOTAL_N_MASTER - 2;
	wire [LOG_MASTER - 1:0] RR_FLAG;
	reg [LOG_MASTER - 1:0] RR_FLAG_FLIPPED;
	wire [TOTAL_N_MASTER - 1:0] data_req_int;
	wire [(TOTAL_N_MASTER * AUX_WIDTH) - 1:0] data_AUX_int;
	wire [(TOTAL_N_MASTER * ID_WIDTH) - 1:0] data_ID_int;
	wire [TOTAL_N_MASTER - 1:0] data_gnt_int;
	genvar j;
	genvar k;
	genvar index;
	integer i;
	always @(*)
		for (i = 0; i < LOG_MASTER; i = i + 1)
			RR_FLAG_FLIPPED[i] = RR_FLAG[(LOG_MASTER - i) - 1];
	generate
		if (N_MASTER != TOTAL_N_MASTER) begin : ARRAY_INT
			wire [TOTAL_N_MASTER - 1:N_MASTER] dummy_req_int;
			wire [((TOTAL_N_MASTER - 1) >= N_MASTER ? ((((TOTAL_N_MASTER - 1) - N_MASTER) + 1) * AUX_WIDTH) + ((N_MASTER * AUX_WIDTH) - 1) : (((N_MASTER - (TOTAL_N_MASTER - 1)) + 1) * AUX_WIDTH) + (((TOTAL_N_MASTER - 1) * AUX_WIDTH) - 1)):((TOTAL_N_MASTER - 1) >= N_MASTER ? N_MASTER * AUX_WIDTH : (TOTAL_N_MASTER - 1) * AUX_WIDTH)] dummy_AUX_int;
			wire [((TOTAL_N_MASTER - 1) >= N_MASTER ? ((((TOTAL_N_MASTER - 1) - N_MASTER) + 1) * ID_WIDTH) + ((N_MASTER * ID_WIDTH) - 1) : (((N_MASTER - (TOTAL_N_MASTER - 1)) + 1) * ID_WIDTH) + (((TOTAL_N_MASTER - 1) * ID_WIDTH) - 1)):((TOTAL_N_MASTER - 1) >= N_MASTER ? N_MASTER * ID_WIDTH : (TOTAL_N_MASTER - 1) * ID_WIDTH)] dummy_ID_int;
			wire [TOTAL_N_MASTER - 1:N_MASTER] dummy_gnt_int;
			for (index = N_MASTER; index < TOTAL_N_MASTER; index = index + 1) begin : ZERO_BINDING
				assign dummy_req_int[index] = 1'b0;
				assign dummy_AUX_int[((TOTAL_N_MASTER - 1) >= N_MASTER ? index : N_MASTER - (index - (TOTAL_N_MASTER - 1))) * AUX_WIDTH+:AUX_WIDTH] = 1'sb0;
				assign dummy_ID_int[((TOTAL_N_MASTER - 1) >= N_MASTER ? index : N_MASTER - (index - (TOTAL_N_MASTER - 1))) * ID_WIDTH+:ID_WIDTH] = 1'sb0;
			end
			for (index = 0; index < N_MASTER; index = index + 1) begin : EXT_PORT
				assign data_req_int[index] = data_req_i[index];
				assign data_AUX_int[index * AUX_WIDTH+:AUX_WIDTH] = data_AUX_i[index * AUX_WIDTH+:AUX_WIDTH];
				assign data_ID_int[index * ID_WIDTH+:ID_WIDTH] = data_ID_i[index * ID_WIDTH+:ID_WIDTH];
				assign data_gnt_o[index] = data_gnt_int[index];
			end
			for (index = N_MASTER; index < TOTAL_N_MASTER; index = index + 1) begin : DUMMY_PORTS
				assign data_req_int[index] = dummy_req_int[index];
				assign data_AUX_int[index * AUX_WIDTH+:AUX_WIDTH] = dummy_AUX_int[((TOTAL_N_MASTER - 1) >= N_MASTER ? index : N_MASTER - (index - (TOTAL_N_MASTER - 1))) * AUX_WIDTH+:AUX_WIDTH];
				assign data_ID_int[index * ID_WIDTH+:ID_WIDTH] = dummy_ID_int[((TOTAL_N_MASTER - 1) >= N_MASTER ? index : N_MASTER - (index - (TOTAL_N_MASTER - 1))) * ID_WIDTH+:ID_WIDTH];
				assign dummy_gnt_int[index] = data_gnt_int[index];
			end
		end
		else begin : genblk1
			for (index = 0; index < N_MASTER; index = index + 1) begin : EXT_PORT
				assign data_req_int[index] = data_req_i[index];
				assign data_AUX_int[index * AUX_WIDTH+:AUX_WIDTH] = data_AUX_i[index * AUX_WIDTH+:AUX_WIDTH];
				assign data_ID_int[index * ID_WIDTH+:ID_WIDTH] = data_ID_i[index * ID_WIDTH+:ID_WIDTH];
				assign data_gnt_o[index] = data_gnt_int[index];
			end
		end
		if (TOTAL_N_MASTER == 2) begin : INCR
			axi_FanInPrimitive_Req #(
				.AUX_WIDTH(AUX_WIDTH),
				.ID_WIDTH(ID_WIDTH)
			) FAN_IN_REQ(
				.RR_FLAG(RR_FLAG_FLIPPED),
				.data_AUX0_i(data_AUX_int[0+:AUX_WIDTH]),
				.data_AUX1_i(data_AUX_int[AUX_WIDTH+:AUX_WIDTH]),
				.data_req0_i(data_req_int[0]),
				.data_req1_i(data_req_int[1]),
				.data_ID0_i(data_ID_int[0+:ID_WIDTH]),
				.data_ID1_i(data_ID_int[ID_WIDTH+:ID_WIDTH]),
				.data_gnt0_o(data_gnt_int[0]),
				.data_gnt1_o(data_gnt_int[1]),
				.data_AUX_o(data_AUX_o),
				.data_req_o(data_req_o),
				.data_ID_o(data_ID_o),
				.data_gnt_i(data_gnt_i),
				.lock_EXCLUSIVE(lock),
				.SEL_EXCLUSIVE(SEL_EXCLUSIVE)
			);
		end
		else begin : BINARY_TREE
			wire [AUX_WIDTH - 1:0] data_AUX_LEVEL [N_WIRE - 1:0];
			wire data_req_LEVEL [N_WIRE - 1:0];
			wire [ID_WIDTH - 1:0] data_ID_LEVEL [N_WIRE - 1:0];
			wire data_gnt_LEVEL [N_WIRE - 1:0];
			for (j = 0; j < LOG_MASTER; j = j + 1) begin : STAGE
				for (k = 0; k < (2 ** j); k = k + 1) begin : INCR_VERT
					if (j == 0) begin : LAST_NODE
						axi_FanInPrimitive_Req #(
							.AUX_WIDTH(AUX_WIDTH),
							.ID_WIDTH(ID_WIDTH)
						) FAN_IN_REQ(
							.RR_FLAG(RR_FLAG_FLIPPED[(LOG_MASTER - j) - 1]),
							.data_AUX0_i(data_AUX_LEVEL[2 * k]),
							.data_AUX1_i(data_AUX_LEVEL[(2 * k) + 1]),
							.data_req0_i(data_req_LEVEL[2 * k]),
							.data_req1_i(data_req_LEVEL[(2 * k) + 1]),
							.data_ID0_i(data_ID_LEVEL[2 * k]),
							.data_ID1_i(data_ID_LEVEL[(2 * k) + 1]),
							.data_gnt0_o(data_gnt_LEVEL[2 * k]),
							.data_gnt1_o(data_gnt_LEVEL[(2 * k) + 1]),
							.data_AUX_o(data_AUX_o),
							.data_req_o(data_req_o),
							.data_ID_o(data_ID_o),
							.data_gnt_i(data_gnt_i),
							.lock_EXCLUSIVE(lock),
							.SEL_EXCLUSIVE(SEL_EXCLUSIVE[(LOG_MASTER - j) - 1])
						);
					end
					else if (j < (LOG_MASTER - 1)) begin : MIDDLE_NODES
						axi_FanInPrimitive_Req #(
							.AUX_WIDTH(AUX_WIDTH),
							.ID_WIDTH(ID_WIDTH)
						) FAN_IN_REQ(
							.RR_FLAG(RR_FLAG_FLIPPED[(LOG_MASTER - j) - 1]),
							.data_AUX0_i(data_AUX_LEVEL[(((2 ** j) * 2) - 2) + (2 * k)]),
							.data_AUX1_i(data_AUX_LEVEL[((((2 ** j) * 2) - 2) + (2 * k)) + 1]),
							.data_req0_i(data_req_LEVEL[(((2 ** j) * 2) - 2) + (2 * k)]),
							.data_req1_i(data_req_LEVEL[((((2 ** j) * 2) - 2) + (2 * k)) + 1]),
							.data_ID0_i(data_ID_LEVEL[(((2 ** j) * 2) - 2) + (2 * k)]),
							.data_ID1_i(data_ID_LEVEL[((((2 ** j) * 2) - 2) + (2 * k)) + 1]),
							.data_gnt0_o(data_gnt_LEVEL[(((2 ** j) * 2) - 2) + (2 * k)]),
							.data_gnt1_o(data_gnt_LEVEL[((((2 ** j) * 2) - 2) + (2 * k)) + 1]),
							.data_AUX_o(data_AUX_LEVEL[(((2 ** (j - 1)) * 2) - 2) + k]),
							.data_req_o(data_req_LEVEL[(((2 ** (j - 1)) * 2) - 2) + k]),
							.data_ID_o(data_ID_LEVEL[(((2 ** (j - 1)) * 2) - 2) + k]),
							.data_gnt_i(data_gnt_LEVEL[(((2 ** (j - 1)) * 2) - 2) + k]),
							.lock_EXCLUSIVE(lock),
							.SEL_EXCLUSIVE(SEL_EXCLUSIVE[(LOG_MASTER - j) - 1])
						);
					end
					else begin : LEAF_NODES
						axi_FanInPrimitive_Req #(
							.AUX_WIDTH(AUX_WIDTH),
							.ID_WIDTH(ID_WIDTH)
						) FAN_IN_REQ(
							.RR_FLAG(RR_FLAG_FLIPPED[(LOG_MASTER - j) - 1]),
							.data_AUX0_i(data_AUX_int[(2 * k) * AUX_WIDTH+:AUX_WIDTH]),
							.data_AUX1_i(data_AUX_int[((2 * k) + 1) * AUX_WIDTH+:AUX_WIDTH]),
							.data_req0_i(data_req_int[2 * k]),
							.data_req1_i(data_req_int[(2 * k) + 1]),
							.data_ID0_i(data_ID_int[(2 * k) * ID_WIDTH+:ID_WIDTH]),
							.data_ID1_i(data_ID_int[((2 * k) + 1) * ID_WIDTH+:ID_WIDTH]),
							.data_gnt0_o(data_gnt_int[2 * k]),
							.data_gnt1_o(data_gnt_int[(2 * k) + 1]),
							.data_AUX_o(data_AUX_LEVEL[(((2 ** (j - 1)) * 2) - 2) + k]),
							.data_req_o(data_req_LEVEL[(((2 ** (j - 1)) * 2) - 2) + k]),
							.data_ID_o(data_ID_LEVEL[(((2 ** (j - 1)) * 2) - 2) + k]),
							.data_gnt_i(data_gnt_LEVEL[(((2 ** (j - 1)) * 2) - 2) + k]),
							.lock_EXCLUSIVE(lock),
							.SEL_EXCLUSIVE(SEL_EXCLUSIVE[(LOG_MASTER - j) - 1])
						);
					end
				end
			end
		end
	endgenerate
	axi_RR_Flag_Req #(
		.WIDTH(LOG_MASTER),
		.MAX_COUNT(N_MASTER)
	) RR_REQ(
		.clk(clk),
		.rst_n(rst_n),
		.RR_FLAG_o(RR_FLAG),
		.data_req_i(data_req_o),
		.data_gnt_i(data_gnt_i)
	);
endmodule
