module apb_timer 
#(
    parameter APB_ADDR_WIDTH = 12,  //APB slaves are 4KB by default
    parameter TIMER_CNT = 2 // how many timers should be instantiated
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
	//parameter TIMER_CNT = 2;
	input wire HCLK;
	input wire HRESETn;
	input wire [APB_ADDR_WIDTH - 1:0] PADDR;
	input wire [31:0] PWDATA;
	input wire PWRITE;
	input wire PSEL;
	input wire PENABLE;
	output reg [31:0] PRDATA;
	output reg PREADY;
	output reg PSLVERR;
	output wire [(TIMER_CNT * 2) - 1:0] irq_o;
	reg [TIMER_CNT - 1:0] psel_int;
	wire [TIMER_CNT - 1:0] pready;
	wire [TIMER_CNT - 1:0] pslverr;
	wire [$clog2(TIMER_CNT) - 1:0] slave_address_int;
	wire [(TIMER_CNT * 32) - 1:0] prdata;
	assign slave_address_int = PADDR[$clog2(TIMER_CNT) + (2'd2 + 1):2'd2 + 2];
	always @(*) begin
		psel_int = 1'sb0;
		psel_int[slave_address_int] = PSEL;
	end
	always @(*)
		if (psel_int != {TIMER_CNT {1'sb0}}) begin
			PRDATA = prdata[slave_address_int * 32+:32];
			PREADY = pready[slave_address_int];
			PSLVERR = pslverr[slave_address_int];
		end
		else begin
			PRDATA = 1'sb0;
			PREADY = 1'b1;
			PSLVERR = 1'b0;
		end
	genvar k;
	generate
		for (k = 0; k < TIMER_CNT; k = k + 1) begin : TIMER_GEN
			timer timer_i(
				.HCLK(HCLK),
				.HRESETn(HRESETn),
				.PADDR(PADDR),
				.PWDATA(PWDATA),
				.PWRITE(PWRITE),
				.PSEL(psel_int[k]),
				.PENABLE(PENABLE),
				.PRDATA(prdata[k * 32+:32]),
				.PREADY(pready[k]),
				.PSLVERR(pslverr[k]),
				.irq_o(irq_o[(2 * k) + 1:2 * k])
			);
		end
	endgenerate
endmodule
