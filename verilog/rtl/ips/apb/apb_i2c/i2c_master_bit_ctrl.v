module i2c_master_bit_ctrl (
	clk,
	nReset,
	ena,
	clk_cnt,
	cmd,
	cmd_ack,
	busy,
	al,
	din,
	dout,
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
	input [3:0] cmd;
	output reg cmd_ack;
	output reg busy;
	output reg al;
	input din;
	output reg dout;
	input scl_i;
	output wire scl_o;
	output reg scl_oen;
	input sda_i;
	output wire sda_o;
	output reg sda_oen;
	reg [1:0] cSCL;
	reg [1:0] cSDA;
	reg [2:0] fSCL;
	reg [2:0] fSDA;
	reg sSCL;
	reg sSDA;
	reg dSCL;
	reg dSDA;
	reg dscl_oen;
	reg sda_chk;
	reg clk_en;
	reg slave_wait;
	reg [15:0] cnt;
	reg [13:0] filter_cnt;
	reg [17:0] c_state;
	always @(posedge clk) dscl_oen <= scl_oen;
	always @(posedge clk or negedge nReset)
		if (!nReset)
			slave_wait <= 1'b0;
		else
			slave_wait <= ((scl_oen & ~dscl_oen) & ~sSCL) | (slave_wait & ~sSCL);
	wire scl_sync = (dSCL & ~sSCL) & scl_oen;
	always @(posedge clk or negedge nReset)
		if (~nReset) begin
			cnt <= 16'h0000;
			clk_en <= 1'b1;
		end
		else if ((~|cnt || !ena) || scl_sync) begin
			cnt <= clk_cnt;
			clk_en <= 1'b1;
		end
		else if (slave_wait) begin
			cnt <= cnt;
			clk_en <= 1'b0;
		end
		else begin
			cnt <= cnt - 16'h0001;
			clk_en <= 1'b0;
		end
	always @(posedge clk or negedge nReset)
		if (!nReset) begin
			cSCL <= 2'b00;
			cSDA <= 2'b00;
		end
		else begin
			cSCL <= {cSCL[0], scl_i};
			cSDA <= {cSDA[0], sda_i};
		end
	always @(posedge clk or negedge nReset)
		if (!nReset)
			filter_cnt <= 14'h0000;
		else if (!ena)
			filter_cnt <= 14'h0000;
		else if (~|filter_cnt)
			filter_cnt <= clk_cnt >> 2;
		else
			filter_cnt <= filter_cnt - 1;
	always @(posedge clk or negedge nReset)
		if (!nReset) begin
			fSCL <= 3'b111;
			fSDA <= 3'b111;
		end
		else if (~|filter_cnt) begin
			fSCL <= {fSCL[1:0], cSCL[1]};
			fSDA <= {fSDA[1:0], cSDA[1]};
		end
	always @(posedge clk or negedge nReset)
		if (~nReset) begin
			sSCL <= 1'b1;
			sSDA <= 1'b1;
			dSCL <= 1'b1;
			dSDA <= 1'b1;
		end
		else begin
			sSCL <= (&fSCL[2:1] | &fSCL[1:0]) | (fSCL[2] & fSCL[0]);
			sSDA <= (&fSDA[2:1] | &fSDA[1:0]) | (fSDA[2] & fSDA[0]);
			dSCL <= sSCL;
			dSDA <= sSDA;
		end
	reg sta_condition;
	reg sto_condition;
	always @(posedge clk or negedge nReset)
		if (~nReset) begin
			sta_condition <= 1'b0;
			sto_condition <= 1'b0;
		end
		else begin
			sta_condition <= (~sSDA & dSDA) & sSCL;
			sto_condition <= (sSDA & ~dSDA) & sSCL;
		end
	always @(posedge clk or negedge nReset)
		if (!nReset)
			busy <= 1'b0;
		else
			busy <= (sta_condition | busy) & ~sto_condition;
	reg cmd_stop;
	always @(posedge clk or negedge nReset)
		if (~nReset)
			cmd_stop <= 1'b0;
		else if (clk_en)
			cmd_stop <= cmd == 4'b0010;
	always @(posedge clk or negedge nReset)
		if (~nReset)
			al <= 1'b0;
		else
			al <= ((sda_chk & ~sSDA) & sda_oen) | ((|c_state & sto_condition) & ~cmd_stop);
	always @(posedge clk)
		if (sSCL & ~dSCL)
			dout <= sSDA;
	parameter [17:0] idle = 18'b000000000000000000;
	parameter [17:0] start_a = 18'b000000000000000001;
	parameter [17:0] start_b = 18'b000000000000000010;
	parameter [17:0] start_c = 18'b000000000000000100;
	parameter [17:0] start_d = 18'b000000000000001000;
	parameter [17:0] start_e = 18'b000000000000010000;
	parameter [17:0] stop_a = 18'b000000000000100000;
	parameter [17:0] stop_b = 18'b000000000001000000;
	parameter [17:0] stop_c = 18'b000000000010000000;
	parameter [17:0] stop_d = 18'b000000000100000000;
	parameter [17:0] rd_a = 18'b000000001000000000;
	parameter [17:0] rd_b = 18'b000000010000000000;
	parameter [17:0] rd_c = 18'b000000100000000000;
	parameter [17:0] rd_d = 18'b000001000000000000;
	parameter [17:0] wr_a = 18'b000010000000000000;
	parameter [17:0] wr_b = 18'b000100000000000000;
	parameter [17:0] wr_c = 18'b001000000000000000;
	parameter [17:0] wr_d = 18'b010000000000000000;
	always @(posedge clk or negedge nReset)
		if (!nReset) begin
			c_state <= idle;
			cmd_ack <= 1'b0;
			scl_oen <= 1'b1;
			sda_oen <= 1'b1;
			sda_chk <= 1'b0;
		end
		else if (al) begin
			c_state <= idle;
			cmd_ack <= 1'b0;
			scl_oen <= 1'b1;
			sda_oen <= 1'b1;
			sda_chk <= 1'b0;
		end
		else begin
			cmd_ack <= 1'b0;
			if (clk_en)
				case (c_state)
					idle: begin
						case (cmd)
							4'b0001: c_state <= start_a;
							4'b0010: c_state <= stop_a;
							4'b0100: c_state <= wr_a;
							4'b1000: c_state <= rd_a;
							default: c_state <= idle;
						endcase
						scl_oen <= scl_oen;
						sda_oen <= sda_oen;
						sda_chk <= 1'b0;
					end
					start_a: begin
						c_state <= start_b;
						scl_oen <= scl_oen;
						sda_oen <= 1'b1;
						sda_chk <= 1'b0;
					end
					start_b: begin
						c_state <= start_c;
						scl_oen <= 1'b1;
						sda_oen <= 1'b1;
						sda_chk <= 1'b0;
					end
					start_c: begin
						c_state <= start_d;
						scl_oen <= 1'b1;
						sda_oen <= 1'b0;
						sda_chk <= 1'b0;
					end
					start_d: begin
						c_state <= start_e;
						scl_oen <= 1'b1;
						sda_oen <= 1'b0;
						sda_chk <= 1'b0;
					end
					start_e: begin
						c_state <= idle;
						cmd_ack <= 1'b1;
						scl_oen <= 1'b0;
						sda_oen <= 1'b0;
						sda_chk <= 1'b0;
					end
					stop_a: begin
						c_state <= stop_b;
						scl_oen <= 1'b0;
						sda_oen <= 1'b0;
						sda_chk <= 1'b0;
					end
					stop_b: begin
						c_state <= stop_c;
						scl_oen <= 1'b1;
						sda_oen <= 1'b0;
						sda_chk <= 1'b0;
					end
					stop_c: begin
						c_state <= stop_d;
						scl_oen <= 1'b1;
						sda_oen <= 1'b0;
						sda_chk <= 1'b0;
					end
					stop_d: begin
						c_state <= idle;
						cmd_ack <= 1'b1;
						scl_oen <= 1'b1;
						sda_oen <= 1'b1;
						sda_chk <= 1'b0;
					end
					rd_a: begin
						c_state <= rd_b;
						scl_oen <= 1'b0;
						sda_oen <= 1'b1;
						sda_chk <= 1'b0;
					end
					rd_b: begin
						c_state <= rd_c;
						scl_oen <= 1'b1;
						sda_oen <= 1'b1;
						sda_chk <= 1'b0;
					end
					rd_c: begin
						c_state <= rd_d;
						scl_oen <= 1'b1;
						sda_oen <= 1'b1;
						sda_chk <= 1'b0;
					end
					rd_d: begin
						c_state <= idle;
						cmd_ack <= 1'b1;
						scl_oen <= 1'b0;
						sda_oen <= 1'b1;
						sda_chk <= 1'b0;
					end
					wr_a: begin
						c_state <= wr_b;
						scl_oen <= 1'b0;
						sda_oen <= din;
						sda_chk <= 1'b0;
					end
					wr_b: begin
						c_state <= wr_c;
						scl_oen <= 1'b1;
						sda_oen <= din;
						sda_chk <= 1'b0;
					end
					wr_c: begin
						c_state <= wr_d;
						scl_oen <= 1'b1;
						sda_oen <= din;
						sda_chk <= 1'b1;
					end
					wr_d: begin
						c_state <= idle;
						cmd_ack <= 1'b1;
						scl_oen <= 1'b0;
						sda_oen <= din;
						sda_chk <= 1'b0;
					end
				endcase
		end
	assign scl_o = 1'b0;
	assign sda_o = 1'b0;
endmodule
