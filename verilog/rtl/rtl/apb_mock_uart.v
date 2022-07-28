module apb_mock_uart 
#(
    parameter APB_ADDR_WIDTH = 12  //APB slaves are 4KB by default
)
(
	CLK,
	RSTN,
	PADDR,
	PWDATA,
	PWRITE,
	PSEL,
	PENABLE,
	PRDATA,
	PREADY,
	PSLVERR,
	INT,
	OUT1N,
	OUT2N,
	RTSN,
	DTRN,
	CTSN,
	DSRN,
	DCDN,
	RIN,
	SIN,
	SOUT
);
	//parameter APB_ADDR_WIDTH = 12;
	input wire CLK;
	input wire RSTN;
	input wire [APB_ADDR_WIDTH - 1:0] PADDR;
	input wire [31:0] PWDATA;
	input wire PWRITE;
	input wire PSEL;
	input wire PENABLE;
	output reg [31:0] PRDATA;
	output wire PREADY;
	output wire PSLVERR;
	output wire INT;
	output wire OUT1N;
	output wire OUT2N;
	output wire RTSN;
	output wire DTRN;
	input wire CTSN;
	input wire DSRN;
	input wire DCDN;
	input wire RIN;
	input wire SIN;
	output wire SOUT;
	wire [3:0] register_adr;
	reg [63:0] regs_q;
	reg [63:0] regs_n;
	assign register_adr = PADDR[2:0];
	always @(*) begin
		regs_n = regs_q;
		if ((PSEL && PENABLE) && PWRITE)
			regs_n[$unsigned(register_adr) * 8+:8] = PWDATA[7:0];
		regs_n[40+:8] = 32'h00000060;
	end
	always @(*) begin
		PRDATA = 'b0;
		if ((PSEL && PENABLE) && !PWRITE)
			PRDATA = {24'b000000000000000000000000, regs_q[$unsigned(register_adr) * 8+:8]};
	end
	always @(posedge CLK or negedge RSTN)
		if (~RSTN)
			regs_q <= {8 {8'b00000000}};
		else begin
			regs_q <= regs_n;
			if ((PSEL && PENABLE) && PWRITE)
				if ($unsigned(register_adr) == 0)
					$write("%C", PWDATA[7:0]);
		end
	assign PREADY = 1'b1;
	assign PSLVERR = 1'b0;
endmodule
