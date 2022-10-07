module apb_fll_if 
#(
    parameter APB_ADDR_WIDTH = 12
)
(
	HCLK,
	HRESETn,
	PADDR,
	PWDATA,
	PWRITE,
	PSEL,
	PENABLE,
	PRDATA,
	PREADY,
	PSLVERR,
	fll1_req,
	fll1_wrn,
	fll1_add,
	fll1_data,
	fll1_ack,
	fll1_r_data,
	fll1_lock,
	fll2_req,
	fll2_wrn,
	fll2_add,
	fll2_data,
	fll2_ack,
	fll2_r_data,
	fll2_lock
);
	//parameter APB_ADDR_WIDTH = 12;
	input wire HCLK;
	input wire HRESETn;
	input wire [APB_ADDR_WIDTH - 1:0] PADDR;
	input wire [31:0] PWDATA;
	input wire PWRITE;
	input wire PSEL;
	input wire PENABLE;
	output wire [31:0] PRDATA;
	output wire PREADY;
	output wire PSLVERR;
	output reg fll1_req;
	output wire fll1_wrn;
	output wire [1:0] fll1_add;
	output wire [31:0] fll1_data;
	input wire fll1_ack;
	input wire [31:0] fll1_r_data;
	input wire fll1_lock;
	output reg fll2_req;
	output wire fll2_wrn;
	output wire [1:0] fll2_add;
	output wire [31:0] fll2_data;
	input wire fll2_ack;
	input wire [31:0] fll2_r_data;
	input wire fll2_lock;
	reg fll1_rd_access;
	reg fll1_wr_access;
	reg fll2_rd_access;
	reg fll2_wr_access;
	reg read_ready;
	reg write_ready;
	reg [31:0] read_data;
	reg rvalid;
	reg fll1_ack_sync0;
	reg fll1_ack_sync;
	reg fll2_ack_sync0;
	reg fll2_ack_sync;
	reg fll1_lock_sync0;
	reg fll1_lock_sync;
	reg fll2_lock_sync0;
	reg fll2_lock_sync;
	reg fll1_valid;
	reg fll2_valid;
	reg [2:0] state;
	reg [2:0] state_next;
	always @(posedge HCLK or negedge HRESETn)
		if (!HRESETn) begin
			fll1_ack_sync0 <= 1'b0;
			fll1_ack_sync <= 1'b0;
			fll2_ack_sync0 <= 1'b0;
			fll2_ack_sync <= 1'b0;
			fll1_lock_sync0 <= 1'b0;
			fll1_lock_sync <= 1'b0;
			fll2_lock_sync0 <= 1'b0;
			fll2_lock_sync <= 1'b0;
			state <= 3'd0;
		end
		else begin
			fll1_ack_sync0 <= fll1_ack;
			fll1_ack_sync <= fll1_ack_sync0;
			fll2_ack_sync0 <= fll2_ack;
			fll2_ack_sync <= fll2_ack_sync0;
			fll1_lock_sync0 <= fll1_lock;
			fll1_lock_sync <= fll1_lock_sync0;
			fll2_lock_sync0 <= fll2_lock;
			fll2_lock_sync <= fll2_lock_sync0;
			state <= state_next;
		end
	always @(*) begin
		state_next = 3'd0;
		rvalid = 1'b0;
		fll1_req = 1'b0;
		fll2_req = 1'b0;
		fll1_valid = 1'b0;
		fll2_valid = 1'b0;
		case (state)
			3'd0:
				if (fll2_rd_access || fll2_wr_access) begin
					fll2_valid = 1'b1;
					state_next = 3'd3;
				end
				else if (fll1_rd_access || fll1_wr_access) begin
					fll1_valid = 1'b1;
					state_next = 3'd1;
				end
			3'd1:
				if (fll1_ack_sync) begin
					fll1_req = 1'b0;
					fll1_valid = 1'b0;
					state_next = 3'd2;
					rvalid = 1'b1;
				end
				else begin
					fll1_req = 1'b1;
					fll1_valid = 1'b1;
					state_next = 3'd1;
				end
			3'd2:
				if (!fll1_ack_sync)
					state_next = 3'd0;
				else
					state_next = 3'd2;
			3'd3:
				if (fll2_ack_sync) begin
					fll2_req = 1'b0;
					fll2_valid = 1'b0;
					state_next = 3'd4;
					rvalid = 1'b1;
				end
				else begin
					fll2_req = 1'b1;
					fll2_valid = 1'b1;
					state_next = 3'd3;
				end
			3'd4:
				if (!fll2_ack_sync)
					state_next = 3'd0;
				else
					state_next = 3'd4;
		endcase
	end
	always @(*) begin
		fll1_wr_access = 1'b0;
		fll2_wr_access = 1'b0;
		write_ready = 1'b0;
		if ((PSEL && PENABLE) && PWRITE)
			case (PADDR[5:2])
				4'b0000, 4'b0001, 4'b0010, 4'b0011: begin
					fll1_wr_access = 1'b1;
					write_ready = rvalid;
				end
				4'b0100, 4'b0101, 4'b0110, 4'b0111: begin
					fll2_wr_access = 1'b1;
					write_ready = rvalid;
				end
				default: write_ready = 1'b1;
			endcase
	end
	always @(*) begin
		fll1_rd_access = 1'b0;
		fll2_rd_access = 1'b0;
		read_ready = 1'b0;
		read_data = 1'sb0;
		if ((PSEL && PENABLE) && ~PWRITE)
			case (PADDR[5:2])
				4'b0000, 4'b0001, 4'b0010, 4'b0011: begin
					fll1_rd_access = 1'b1;
					read_data = fll1_r_data;
					read_ready = rvalid;
				end
				4'b0100, 4'b0101, 4'b0110, 4'b0111: begin
					fll2_rd_access = 1'b1;
					read_data = fll2_r_data;
					read_ready = rvalid;
				end
				4'b1000: begin
					read_data[1:0] = {fll2_lock_sync, fll1_lock_sync};
					read_ready = 1'b1;
				end
				default: read_ready = 1'b1;
			endcase
	end
	assign fll1_wrn = (fll1_valid ? ~PWRITE : 1'b0);
	assign fll1_add = (fll1_valid ? PADDR[3:2] : {2 {1'sb0}});
	assign fll1_data = (fll1_valid ? PWDATA : {32 {1'sb0}});
	assign fll2_wrn = (fll2_valid ? ~PWRITE : 1'b0);
	assign fll2_add = (fll2_valid ? PADDR[3:2] : {2 {1'sb0}});
	assign fll2_data = (fll2_valid ? PWDATA : {32 {1'sb0}});
	assign PREADY = (PWRITE ? write_ready : read_ready);
	assign PRDATA = read_data;
	assign PSLVERR = 1'b0;
endmodule
