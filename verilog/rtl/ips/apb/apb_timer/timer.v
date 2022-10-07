module timer 
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
	irq_o
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
	output reg [1:0] irq_o;
	wire [1:0] register_adr;
	assign register_adr = PADDR[4:2];
	assign PREADY = 1'b1;
	assign PSLVERR = 1'b0;
	reg [95:0] regs_q;
	reg [95:0] regs_n;
	reg [31:0] cycle_counter_n;
	reg [31:0] cycle_counter_q;
	wire [2:0] prescaler_int;
	always @(*) begin
		irq_o = 2'b00;
		if (regs_q[64+:32] == 32'hffffffff)
			irq_o[0] = 1'b1;
		if ((regs_q[0+:32] != 'b0) && (regs_q[64+:32] == regs_q[0+:32]))
			irq_o[1] = 1'b1;
	end
	assign prescaler_int = regs_q[37-:3];
	always @(*) begin
		regs_n = regs_q;
		cycle_counter_n = cycle_counter_q + 1;
		if ((irq_o[0] == 1'b1) || (irq_o[1] == 1'b1))
			regs_n[64+:32] = 1'b0;
		else if ((regs_q[32] && (prescaler_int != 'b0)) && (prescaler_int == cycle_counter_q))
			regs_n[64+:32] = regs_q[64+:32] + 1;
		else if (regs_q[32] && (regs_q[37-:3] == 'b0))
			regs_n[64+:32] = regs_q[64+:32] + 1;
		if (cycle_counter_q >= regs_q[32+:32])
			cycle_counter_n = 32'b00000000000000000000000000000000;
		if ((PSEL && PENABLE) && PWRITE)
			case (register_adr)
				2'b00: regs_n[64+:32] = PWDATA;
				2'b01: regs_n[32+:32] = PWDATA;
				2'b10: begin
					regs_n[0+:32] = PWDATA;
					regs_n[64+:32] = 32'b00000000000000000000000000000000;
				end
			endcase
	end
	always @(*) begin
		PRDATA = 'b0;
		if ((PSEL && PENABLE) && !PWRITE)
			case (register_adr)
				2'b00: PRDATA = regs_q[64+:32];
				2'b01: PRDATA = regs_q[32+:32];
				2'b10: PRDATA = regs_q[0+:32];
			endcase
	end
	always @(posedge HCLK or negedge HRESETn)
		if (~HRESETn) begin
			regs_q <= {3 {32'b00000000000000000000000000000000}};
			cycle_counter_q <= 32'b00000000000000000000000000000000;
		end
		else begin
			regs_q <= regs_n;
			cycle_counter_q <= cycle_counter_n;
		end
endmodule
