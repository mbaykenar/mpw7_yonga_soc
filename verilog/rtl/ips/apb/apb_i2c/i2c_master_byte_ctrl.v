module i2c_master_byte_ctrl (
	clk,
	nReset,
	ena,
	clk_cnt,
	start,
	stop,
	read,
	write,
	ack_in,
	din,
	cmd_ack,
	ack_out,
	dout,
	i2c_busy,
	i2c_al,
	scl_i,
	scl_o,
	scl_oen,
	sda_i,
	sda_o,
	sda_oen
);
	input clk;
	input nReset;
	input ena;
	input [15:0] clk_cnt;
	input start;
	input stop;
	input read;
	input write;
	input ack_in;
	input [7:0] din;
	output reg cmd_ack;
	output reg ack_out;
	output wire i2c_busy;
	output wire i2c_al;
	output wire [7:0] dout;
	input scl_i;
	output wire scl_o;
	output wire scl_oen;
	input sda_i;
	output wire sda_o;
	output wire sda_oen;
	parameter [4:0] ST_IDLE = 5'b00000;
	parameter [4:0] ST_START = 5'b00001;
	parameter [4:0] ST_READ = 5'b00010;
	parameter [4:0] ST_WRITE = 5'b00100;
	parameter [4:0] ST_ACK = 5'b01000;
	parameter [4:0] ST_STOP = 5'b10000;
	reg [3:0] core_cmd;
	reg core_txd;
	wire core_ack;
	wire core_rxd;
	reg [7:0] sr;
	reg shift;
	reg ld;
	wire go;
	reg [2:0] dcnt;
	wire cnt_done;
	i2c_master_bit_ctrl bit_controller(
		.clk(clk),
		.nReset(nReset),
		.ena(ena),
		.clk_cnt(clk_cnt),
		.cmd(core_cmd),
		.cmd_ack(core_ack),
		.busy(i2c_busy),
		.al(i2c_al),
		.din(core_txd),
		.dout(core_rxd),
		.scl_i(scl_i),
		.scl_o(scl_o),
		.scl_oen(scl_oen),
		.sda_i(sda_i),
		.sda_o(sda_o),
		.sda_oen(sda_oen)
	);
	assign go = ((read | write) | stop) & ~cmd_ack;
	assign dout = sr;
	always @(posedge clk or negedge nReset)
		if (!nReset)
			sr <= #(1) 8'h00;
		else if (ld)
			sr <= #(1) din;
		else if (shift)
			sr <= #(1) {sr[6:0], core_rxd};
	always @(posedge clk or negedge nReset)
		if (!nReset)
			dcnt <= #(1) 3'h0;
		else if (ld)
			dcnt <= #(1) 3'h7;
		else if (shift)
			dcnt <= #(1) dcnt - 3'h1;
	assign cnt_done = ~(|dcnt);
	reg [4:0] c_state;
	always @(posedge clk or negedge nReset)
		if (!nReset) begin
			core_cmd <= #(1) 4'b0000;
			core_txd <= #(1) 1'b0;
			shift <= #(1) 1'b0;
			ld <= #(1) 1'b0;
			cmd_ack <= #(1) 1'b0;
			c_state <= #(1) ST_IDLE;
			ack_out <= #(1) 1'b0;
		end
		else if (i2c_al) begin
			core_cmd <= #(1) 4'b0000;
			core_txd <= #(1) 1'b0;
			shift <= #(1) 1'b0;
			ld <= #(1) 1'b0;
			cmd_ack <= #(1) 1'b0;
			c_state <= #(1) ST_IDLE;
			ack_out <= #(1) 1'b0;
		end
		else begin
			core_txd <= #(1) sr[7];
			shift <= #(1) 1'b0;
			ld <= #(1) 1'b0;
			cmd_ack <= #(1) 1'b0;
			case (c_state)
				ST_IDLE:
					if (go) begin
						if (start) begin
							c_state <= #(1) ST_START;
							core_cmd <= #(1) 4'b0001;
						end
						else if (read) begin
							c_state <= #(1) ST_READ;
							core_cmd <= #(1) 4'b1000;
						end
						else if (write) begin
							c_state <= #(1) ST_WRITE;
							core_cmd <= #(1) 4'b0100;
						end
						else begin
							c_state <= #(1) ST_STOP;
							core_cmd <= #(1) 4'b0010;
						end
						ld <= #(1) 1'b1;
					end
				ST_START:
					if (core_ack) begin
						if (read) begin
							c_state <= #(1) ST_READ;
							core_cmd <= #(1) 4'b1000;
						end
						else begin
							c_state <= #(1) ST_WRITE;
							core_cmd <= #(1) 4'b0100;
						end
						ld <= #(1) 1'b1;
					end
				ST_WRITE:
					if (core_ack)
						if (cnt_done) begin
							c_state <= #(1) ST_ACK;
							core_cmd <= #(1) 4'b1000;
						end
						else begin
							c_state <= #(1) ST_WRITE;
							core_cmd <= #(1) 4'b0100;
							shift <= #(1) 1'b1;
						end
				ST_READ:
					if (core_ack) begin
						if (cnt_done) begin
							c_state <= #(1) ST_ACK;
							core_cmd <= #(1) 4'b0100;
						end
						else begin
							c_state <= #(1) ST_READ;
							core_cmd <= #(1) 4'b1000;
						end
						shift <= #(1) 1'b1;
						core_txd <= #(1) ack_in;
					end
				ST_ACK:
					if (core_ack) begin
						if (stop) begin
							c_state <= #(1) ST_STOP;
							core_cmd <= #(1) 4'b0010;
						end
						else begin
							c_state <= #(1) ST_IDLE;
							core_cmd <= #(1) 4'b0000;
							cmd_ack <= #(1) 1'b1;
						end
						ack_out <= #(1) core_rxd;
						core_txd <= #(1) 1'b1;
					end
					else
						core_txd <= #(1) ack_in;
				ST_STOP:
					if (core_ack) begin
						c_state <= #(1) ST_IDLE;
						core_cmd <= #(1) 4'b0000;
						cmd_ack <= #(1) 1'b1;
					end
			endcase
		end
endmodule
