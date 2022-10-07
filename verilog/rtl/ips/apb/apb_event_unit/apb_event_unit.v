module apb_event_unit 
#(
    parameter APB_ADDR_WIDTH = 12  //APB slaves are 4KB by default
)
(
	clk_i,
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
	irq_o,
	fetch_enable_i,
	fetch_enable_o,
	clk_gate_core_o,
	core_busy_i
);
	//parameter APB_ADDR_WIDTH = 12;
	input wire clk_i;
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
	input wire [31:0] irq_i;
	input wire [31:0] event_i;
	output wire [31:0] irq_o;
	input wire fetch_enable_i;
	output wire fetch_enable_o;
	output wire clk_gate_core_o;
	input wire core_busy_i;
	wire [31:0] events;
	reg [2:0] psel_int;
	wire [2:0] pready;
	wire [2:0] pslverr;
	wire [1:0] slave_address_int;
	wire [95:0] prdata;
	reg fetch_enable_ff1;
	reg fetch_enable_ff2;
	wire fetch_enable_int;
	assign fetch_enable_o = fetch_enable_ff2 & fetch_enable_int;
	assign slave_address_int = PADDR[5:4];
	always @(*) begin
		psel_int = 3'b000;
		psel_int[slave_address_int] = PSEL;
	end
	always @(*)
		if (psel_int != 2'b00) begin
			PRDATA = prdata[slave_address_int * 32+:32];
			PREADY = pready[slave_address_int];
			PSLVERR = pslverr[slave_address_int];
		end
		else begin
			PRDATA = 1'sb0;
			PREADY = 1'b1;
			PSLVERR = 1'b0;
		end
	generic_service_unit #(.APB_ADDR_WIDTH(APB_ADDR_WIDTH)) i_interrupt_unit(
		.HCLK(HCLK),
		.HRESETn(HRESETn),
		.PADDR(PADDR),
		.PWDATA(PWDATA),
		.PWRITE(PWRITE),
		.PSEL(psel_int[0]),
		.PENABLE(PENABLE),
		.PRDATA(prdata[0+:32]),
		.PREADY(pready[0]),
		.PSLVERR(pslverr[0]),
		.signal_i(irq_i),
		.irq_o(irq_o)
	);
	generic_service_unit #(.APB_ADDR_WIDTH(APB_ADDR_WIDTH)) i_event_unit(
		.HCLK(HCLK),
		.HRESETn(HRESETn),
		.PADDR(PADDR),
		.PWDATA(PWDATA),
		.PWRITE(PWRITE),
		.PSEL(psel_int[1]),
		.PENABLE(PENABLE),
		.PRDATA(prdata[32+:32]),
		.PREADY(pready[1]),
		.PSLVERR(pslverr[1]),
		.signal_i(event_i),
		.irq_o(events)
	);
	sleep_unit #(.APB_ADDR_WIDTH(APB_ADDR_WIDTH)) i_sleep_unit(
		.HCLK(HCLK),
		.HRESETn(HRESETn),
		.PADDR(PADDR),
		.PWDATA(PWDATA),
		.PWRITE(PWRITE),
		.PSEL(psel_int[2]),
		.PENABLE(PENABLE),
		.PRDATA(prdata[64+:32]),
		.PREADY(pready[2]),
		.PSLVERR(pslverr[2]),
		.irq_i(|irq_o),
		.event_i(|events),
		.core_busy_i(core_busy_i),
		.fetch_en_o(fetch_enable_int),
		.clk_gate_core_o(clk_gate_core_o)
	);
	always @(posedge clk_i or negedge HRESETn)
		if (~HRESETn) begin
			fetch_enable_ff1 <= 1'b0;
			fetch_enable_ff2 <= 1'b0;
		end
		else begin
			fetch_enable_ff1 <= fetch_enable_i;
			fetch_enable_ff2 <= fetch_enable_ff1;
		end
endmodule
