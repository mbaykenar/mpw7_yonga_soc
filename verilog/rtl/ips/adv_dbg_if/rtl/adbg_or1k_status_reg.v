module adbg_or1k_status_reg 
#( 
        parameter NB_CORES = 4
    )
(
	tck_i,
	trstn_i,
	we_i,
	cpu_clk_i,
	cpu_rstn_i,
	data_i,
	bp_i,
	ctrl_reg_o,
	cpu_stall_o
);
	//parameter NB_CORES = 4;
	input tck_i;
	input trstn_i;
	input we_i;
	input cpu_clk_i;
	input cpu_rstn_i;
	input wire [15:0] data_i;
	input wire [NB_CORES - 1:0] bp_i;
	output wire [NB_CORES - 1:0] ctrl_reg_o;
	output wire [NB_CORES - 1:0] cpu_stall_o;
	reg [NB_CORES - 1:0] stall_bp;
	reg [NB_CORES - 1:0] stall_bp_csff;
	reg [NB_CORES - 1:0] stall_bp_tck;
	reg [NB_CORES - 1:0] stall_reg;
	reg [NB_CORES - 1:0] stall_reg_csff;
	reg [NB_CORES - 1:0] stall_reg_cpu;
	always @(posedge cpu_clk_i or negedge cpu_rstn_i)
		if (~cpu_rstn_i)
			stall_bp <= 1'sb0;
		else begin : sv2v_autoblock_1
			reg signed [31:0] i;
			for (i = 0; i < NB_CORES; i = i + 1)
				if (bp_i[i])
					stall_bp[i] <= 1'b1;
				else if (stall_reg_cpu[i])
					stall_bp[i] <= 1'b0;
		end
	always @(posedge tck_i or negedge trstn_i)
		if (~trstn_i) begin
			stall_bp_csff <= 1'sb0;
			stall_bp_tck <= 1'sb0;
		end
		else begin
			stall_bp_csff <= stall_bp;
			stall_bp_tck <= stall_bp_csff;
		end
	always @(posedge cpu_clk_i or negedge cpu_rstn_i)
		if (~cpu_rstn_i) begin
			stall_reg_csff <= 1'sb0;
			stall_reg_cpu <= 1'sb0;
		end
		else begin
			stall_reg_csff <= stall_reg;
			stall_reg_cpu <= stall_reg_csff;
		end
	assign cpu_stall_o = (bp_i | stall_bp) | stall_reg_cpu;
	always @(posedge tck_i or negedge trstn_i)
		if (~trstn_i)
			stall_reg <= 1'sb0;
		else begin : sv2v_autoblock_2
			reg signed [31:0] i;
			for (i = 0; i < NB_CORES; i = i + 1)
				if (stall_bp_tck[i])
					stall_reg[i] <= 1'b1;
				else if (we_i)
					stall_reg[i] <= data_i[i];
		end
	assign ctrl_reg_o = {stall_reg};
endmodule
