module generic_service_unit 
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
	signal_i,
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
	input wire [31:0] signal_i;
	output reg [31:0] irq_o;
	reg [127:0] regs_q;
	reg [127:0] regs_n;
	reg [4:0] highest_pending_int;
	wire [1:0] register_adr;
	reg [31:0] irq_n;
	assign register_adr = PADDR[3:2];
	always @(*) begin : sv2v_autoblock_1
		reg [0:1] _sv2v_jump;
		_sv2v_jump = 2'b00;
		highest_pending_int = 'b0;
		irq_n = 32'b00000000000000000000000000000000;
		begin : sv2v_autoblock_2
			reg signed [31:0] i;
			for (i = 0; i < 32; i = i + 1)
				if (_sv2v_jump < 2'b10) begin
					_sv2v_jump = 2'b00;
					if (regs_q[64 + i]) begin
						highest_pending_int = i;
						_sv2v_jump = 2'b10;
					end
				end
			if (_sv2v_jump != 2'b11)
				_sv2v_jump = 2'b00;
		end
		if (_sv2v_jump == 2'b00)
			if (regs_q[64+:32] != 'b0)
				irq_n[highest_pending_int] = 1'b1;
	end
	assign PREADY = 1'b1;
	assign PSLVERR = 1'b0;
	reg [31:0] pending_int;
	always @(*) begin
		regs_n = regs_q;
		regs_n[32+:32] = 32'b00000000000000000000000000000000;
		regs_n[0+:32] = 32'b00000000000000000000000000000000;
		pending_int = (regs_q[96+:32] & signal_i) | regs_q[64+:32];
		pending_int = pending_int | regs_q[32+:32];
		begin : sv2v_autoblock_3
			reg signed [31:0] i;
			for (i = 0; i < 32; i = i + 1)
				if (regs_q[i])
					pending_int[i] = 1'b0;
		end
		if ((PSEL && PENABLE) && PWRITE)
			case (register_adr)
				2'b00: regs_n[96+:32] = PWDATA;
				2'b01: pending_int = PWDATA;
				2'b10: regs_n[32+:32] = PWDATA;
				2'b11: regs_n[0+:32] = PWDATA;
			endcase
		regs_n[64+:32] = pending_int;
	end
	always @(*) begin
		PRDATA = 'b0;
		if ((PSEL && PENABLE) && !PWRITE)
			case (register_adr)
				2'b00: PRDATA = regs_q[96+:32];
				2'b01: PRDATA = regs_q[64+:32];
				default: PRDATA = 'b0;
			endcase
	end
	always @(posedge HCLK or negedge HRESETn)
		if (~HRESETn) begin
			regs_q <= {4 {32'b00000000000000000000000000000000}};
			irq_o <= 32'b00000000000000000000000000000000;
		end
		else begin
			regs_q <= regs_n;
			irq_o <= irq_n;
		end
endmodule
