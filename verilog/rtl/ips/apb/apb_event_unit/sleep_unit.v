module sleep_unit 
#(
    parameter APB_ADDR_WIDTH = 12  //APB slaves are 4KB by default
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
	irq_i,
	event_i,
	core_busy_i,
	fetch_en_o,
	clk_gate_core_o
);
	//parameter APB_ADDR_WIDTH = 12;
	input wire HCLK;
	input wire HRESETn;
	input wire [APB_ADDR_WIDTH - 1:0] PADDR;
	input wire [31:0] PWDATA;
	input wire PWRITE;
	input wire PSEL;
	input wire PENABLE;
	output reg [31:0] PRDATA;
	output wire PREADY;
	output wire PSLVERR;
	input wire irq_i;
	input wire event_i;
	input wire core_busy_i;
	output reg fetch_en_o;
	output reg clk_gate_core_o;
	reg [1:0] SLEEP_STATE_N;
	reg [1:0] SLEEP_STATE_Q;
	reg [63:0] regs_q;
	reg [63:0] regs_n;
	reg core_sleeping_int;
	always @(*) begin
		SLEEP_STATE_N = SLEEP_STATE_Q;
		case (SLEEP_STATE_Q)
			2'd0:
				if (regs_q[32])
					if (~event_i)
						SLEEP_STATE_N = 2'd1;
			2'd1:
				if (event_i)
					SLEEP_STATE_N = 2'd0;
				else if (~core_busy_i && ~irq_i)
					SLEEP_STATE_N = 2'd2;
			2'd2:
				if (event_i)
					SLEEP_STATE_N = 2'd0;
				else if (irq_i)
					SLEEP_STATE_N = 2'd1;
			default: SLEEP_STATE_N = 2'd0;
		endcase
	end
	always @(*) begin
		fetch_en_o = 1'b1;
		clk_gate_core_o = 1'b1;
		core_sleeping_int = 1'b0;
		case (SLEEP_STATE_Q)
			2'd0:
				if (regs_q[32] && ~event_i)
					fetch_en_o = 1'b0;
				else
					fetch_en_o = 1'b1;
			2'd1: fetch_en_o = 1'b0;
			2'd2: begin
				clk_gate_core_o = (event_i ? 1'b1 : 1'b0);
				core_sleeping_int = 1'b1;
				fetch_en_o = 1'b0;
			end
			default: begin
				fetch_en_o = 1'b1;
				clk_gate_core_o = 1'b1;
				core_sleeping_int = 1'b0;
			end
		endcase
	end
	wire [0:0] register_adr;
	assign register_adr = PADDR[3:2];
	assign PREADY = 1'b1;
	assign PSLVERR = 1'b0;
	always @(*) begin
		regs_n = regs_q;
		regs_n[1'b0] = core_sleeping_int;
		if (core_sleeping_int || event_i)
			regs_n[32] = 1'b0;
		if ((PSEL && PENABLE) && PWRITE)
			case (register_adr)
				2'b00: regs_n[32+:32] = PWDATA;
			endcase
	end
	always @(*) begin
		PRDATA = 'b0;
		if ((PSEL && PENABLE) && !PWRITE)
			case (register_adr)
				2'b00: PRDATA = regs_q[32+:32];
				2'b01: PRDATA = regs_q[0+:32];
				default: PRDATA = 'b0;
			endcase
	end
	always @(posedge HCLK or negedge HRESETn)
		if (~HRESETn) begin
			SLEEP_STATE_Q <= 2'd0;
			regs_q <= {2 {32'b00000000000000000000000000000000}};
		end
		else begin
			SLEEP_STATE_Q <= SLEEP_STATE_N;
			regs_q <= regs_n;
		end
endmodule
