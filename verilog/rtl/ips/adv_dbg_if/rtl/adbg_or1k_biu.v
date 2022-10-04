module adbg_or1k_biu 
#( 
		parameter NB_CORES = 4
    )
(
	tck_i,
	trstn_i,
	cpu_select_i,
	data_i,
	data_o,
	addr_i,
	strobe_i,
	rd_wrn_i,
	rdy_o,
	cpu_clk_i,
	cpu_rstn_i,
	cpu_addr_o,
	cpu_data_i,
	cpu_data_o,
	cpu_stb_o,
	cpu_we_o,
	cpu_ack_i
);
	//parameter NB_CORES = 4;
	input wire tck_i;
	input wire trstn_i;
	input wire [3:0] cpu_select_i;
	input wire [31:0] data_i;
	output wire [31:0] data_o;
	input wire [31:0] addr_i;
	input wire strobe_i;
	input wire rd_wrn_i;
	output reg rdy_o;
	input wire cpu_clk_i;
	input wire cpu_rstn_i;
	output reg [(NB_CORES * 16) - 1:0] cpu_addr_o;
	input wire [(NB_CORES * 32) - 1:0] cpu_data_i;
	output reg [(NB_CORES * 32) - 1:0] cpu_data_o;
	output reg [NB_CORES - 1:0] cpu_stb_o;
	output reg [NB_CORES - 1:0] cpu_we_o;
	input wire [NB_CORES - 1:0] cpu_ack_i;
	reg [31:0] cpu_data_int;
	reg cpu_ack_int;
	reg cpu_stb_int;
	reg [31:0] addr_reg;
	reg [31:0] data_in_reg;
	reg [31:0] data_out_reg;
	reg wr_reg;
	reg str_sync;
	reg rdy_sync;
	reg rdy_sync_tff1;
	reg rdy_sync_tff2;
	reg rdy_sync_tff2q;
	reg str_sync_wbff1;
	reg str_sync_wbff2;
	reg str_sync_wbff2q;
	reg data_o_en;
	reg rdy_sync_en;
	wire start_toggle;
	wire valid_selection;
	assign valid_selection = (cpu_select_i < NB_CORES ? 1'b1 : 1'b0);
	always @(posedge tck_i or negedge trstn_i)
		if (~trstn_i) begin
			addr_reg <= 32'h00000000;
			data_in_reg <= 32'h00000000;
			wr_reg <= 1'b0;
		end
		else if (strobe_i && rdy_o) begin
			addr_reg <= addr_i;
			if (!rd_wrn_i)
				data_in_reg <= data_i;
			wr_reg <= ~rd_wrn_i;
		end
	always @(posedge tck_i or negedge trstn_i)
		if (~trstn_i)
			str_sync <= 1'b0;
		else if (strobe_i && rdy_o)
			str_sync <= ~str_sync;
	always @(posedge tck_i or negedge trstn_i)
		if (~trstn_i) begin
			rdy_sync_tff1 <= 1'b0;
			rdy_sync_tff2 <= 1'b0;
			rdy_sync_tff2q <= 1'b0;
			rdy_o <= 1'b1;
		end
		else begin
			rdy_sync_tff1 <= rdy_sync;
			rdy_sync_tff2 <= rdy_sync_tff1;
			rdy_sync_tff2q <= rdy_sync_tff2;
			if (strobe_i && rdy_o)
				rdy_o <= 1'b0;
			else if (rdy_sync_tff2 != rdy_sync_tff2q)
				rdy_o <= 1'b1;
		end
	assign data_o = data_out_reg;
	always @(*) begin : sv2v_autoblock_1
		reg signed [31:0] i;
		for (i = 0; i < NB_CORES; i = i + 1)
			if (cpu_select_i == i) begin
				cpu_data_o[i * 32+:32] = data_in_reg;
				cpu_we_o[i] = wr_reg;
				cpu_addr_o[i * 16+:16] = addr_reg;
				cpu_stb_o[i] = cpu_stb_int;
			end
			else begin
				cpu_data_o[i * 32+:32] = 'h0;
				cpu_we_o[i] = 1'b0;
				cpu_addr_o[i * 16+:16] = 'h0;
				cpu_stb_o[i] = 1'b0;
			end
	end
	always @(*) begin
		cpu_data_int = 'h0;
		cpu_ack_int = 1'b0;
		begin : sv2v_autoblock_2
			reg signed [31:0] i;
			for (i = 0; i < NB_CORES; i = i + 1)
				if (cpu_select_i == i) begin
					cpu_data_int = cpu_data_i[i * 32+:32];
					cpu_ack_int = cpu_ack_i[i];
				end
		end
	end
	always @(posedge cpu_clk_i or negedge cpu_rstn_i)
		if (~cpu_rstn_i) begin
			str_sync_wbff1 <= 1'b0;
			str_sync_wbff2 <= 1'b0;
			str_sync_wbff2q <= 1'b0;
		end
		else begin
			str_sync_wbff1 <= str_sync;
			str_sync_wbff2 <= str_sync_wbff1;
			str_sync_wbff2q <= str_sync_wbff2;
		end
	assign start_toggle = str_sync_wbff2 != str_sync_wbff2q;
	always @(posedge cpu_clk_i or negedge cpu_rstn_i)
		if (~cpu_rstn_i)
			data_out_reg <= 32'h00000000;
		else if (data_o_en)
			data_out_reg <= cpu_data_int;
	always @(posedge cpu_clk_i or negedge cpu_rstn_i)
		if (~cpu_rstn_i)
			rdy_sync <= 1'b0;
		else if (rdy_sync_en)
			rdy_sync <= ~rdy_sync;
	reg cpu_fsm_state;
	reg next_fsm_state;
	always @(posedge cpu_clk_i or negedge cpu_rstn_i)
		if (~cpu_rstn_i)
			cpu_fsm_state <= 1'h0;
		else
			cpu_fsm_state <= next_fsm_state;
	always @(cpu_fsm_state or start_toggle or cpu_ack_int)
		case (cpu_fsm_state)
			1'h0:
				if (start_toggle && !cpu_ack_int)
					next_fsm_state <= 1'h1;
				else
					next_fsm_state <= 1'h0;
			1'h1:
				if (cpu_ack_int)
					next_fsm_state <= 1'h0;
				else
					next_fsm_state <= 1'h1;
		endcase
	always @(cpu_fsm_state or start_toggle or cpu_ack_int or wr_reg) begin
		rdy_sync_en = 1'b0;
		data_o_en = 1'b0;
		cpu_stb_int = 1'b0;
		case (cpu_fsm_state)
			1'h0:
				if (start_toggle) begin
					cpu_stb_int = 1'b1;
					if (cpu_ack_int)
						rdy_sync_en = 1'b1;
					if (cpu_ack_int && !wr_reg)
						data_o_en = 1'b1;
				end
			1'h1: begin
				cpu_stb_int = 1'b1;
				if (cpu_ack_int) begin
					data_o_en = 1'b1;
					rdy_sync_en = 1'b1;
				end
			end
		endcase
	end
endmodule
