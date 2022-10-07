module apb2per 
#(
   parameter PER_ADDR_WIDTH = 32,
   parameter APB_ADDR_WIDTH = 32
)
(
	clk_i,
	rst_ni,
	PADDR,
	PWDATA,
	PWRITE,
	PSEL,
	PENABLE,
	PRDATA,
	PREADY,
	PSLVERR,
	per_master_req_o,
	per_master_add_o,
	per_master_we_o,
	per_master_wdata_o,
	per_master_be_o,
	per_master_gnt_i,
	per_master_r_valid_i,
	per_master_r_opc_i,
	per_master_r_rdata_i
);
	//parameter PER_ADDR_WIDTH = 32;
	//parameter APB_ADDR_WIDTH = 32;
	input wire clk_i;
	input wire rst_ni;
	input wire [APB_ADDR_WIDTH - 1:0] PADDR;
	input wire [31:0] PWDATA;
	input wire PWRITE;
	input wire PSEL;
	input wire PENABLE;
	output wire [31:0] PRDATA;
	output reg PREADY;
	output wire PSLVERR;
	output reg per_master_req_o;
	output wire [PER_ADDR_WIDTH - 1:0] per_master_add_o;
	output reg per_master_we_o;
	output wire [31:0] per_master_wdata_o;
	output wire [3:0] per_master_be_o;
	input wire per_master_gnt_i;
	input wire per_master_r_valid_i;
	input wire per_master_r_opc_i;
	input wire [31:0] per_master_r_rdata_i;
	reg CS;
	reg NS;
	always @(posedge clk_i or negedge rst_ni)
		if (rst_ni == 1'b0)
			CS <= 1'd0;
		else
			CS <= NS;
	always @(*) begin
		per_master_we_o = 0;
		per_master_req_o = 0;
		PREADY = 0;
		case (CS)
			1'd0:
				if ((PSEL == 1) && (PENABLE == 1)) begin
					per_master_req_o = 1;
					if (PWRITE == 1)
						per_master_we_o = 1'b1;
					else
						per_master_we_o = 1'b0;
					if (per_master_gnt_i == 1) begin
						if (PWRITE == 1) begin
							PREADY = 1;
							NS = 1'd0;
						end
						else begin
							PREADY = 0;
							NS = 1'd1;
						end
					end
					else begin
						PREADY = 0;
						NS = 1'd0;
					end
				end
				else begin
					NS = 1'd0;
					PREADY = 0;
				end
			1'd1:
				if (per_master_r_valid_i == 1) begin
					PREADY = 1;
					NS = 1'd0;
				end
				else begin
					PREADY = 0;
					NS = 1'd1;
				end
			default: NS = 1'd0;
		endcase
	end
	assign PRDATA = per_master_r_rdata_i;
	assign PSLVERR = 1'sb0;
	assign per_master_add_o = PADDR;
	assign per_master_wdata_o = PWDATA;
	assign per_master_be_o = 1'sb1;
endmodule
