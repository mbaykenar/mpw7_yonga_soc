module apb_pulpino 
#(
    parameter APB_ADDR_WIDTH = 12,  //APB slaves are 4KB by default
    parameter BOOT_ADDR      = 32'h8000
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
	pad_cfg_o,
	clk_gate_o,
	pad_mux_o,
	boot_addr_o
);
	//parameter APB_ADDR_WIDTH = 12;
	//parameter BOOT_ADDR = 32'h00008000;
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
	output wire [191:0] pad_cfg_o;
	output wire [31:0] clk_gate_o;
	output wire [31:0] pad_mux_o;
	output wire [31:0] boot_addr_o;
	reg [31:0] pad_mux_q;
	reg [31:0] pad_mux_n;
	reg [31:0] boot_adr_q;
	reg [31:0] boot_adr_n;
	reg [31:0] clk_gate_q;
	reg [31:0] clk_gate_n;
	reg [191:0] pad_cfg_q;
	reg [191:0] pad_cfg_n;
	wire [3:0] register_adr;
	reg [1:0] status_n;
	reg [1:0] status_q;
	assign register_adr = PADDR[5:2];
	assign pad_mux_o = pad_mux_q;
	assign clk_gate_o = clk_gate_q;
	assign pad_cfg_o = pad_cfg_q;
	assign boot_addr_o = boot_adr_q;
	always @(*) begin
		pad_mux_n = pad_mux_q;
		pad_cfg_n = pad_cfg_q;
		clk_gate_n = clk_gate_q;
		boot_adr_n = boot_adr_q;
		status_n = status_q;
		if ((PSEL && PENABLE) && PWRITE)
			case (register_adr)
				4'b0000: pad_mux_n = PWDATA;
				4'b0001: clk_gate_n = PWDATA;
				4'b0010: boot_adr_n = PWDATA;
				4'b1000: begin
					pad_cfg_n[0+:6] = PWDATA[5:0];
					pad_cfg_n[6+:6] = PWDATA[13:8];
					pad_cfg_n[12+:6] = PWDATA[21:16];
					pad_cfg_n[18+:6] = PWDATA[29:24];
				end
				4'b1001: begin
					pad_cfg_n[24+:6] = PWDATA[5:0];
					pad_cfg_n[30+:6] = PWDATA[13:8];
					pad_cfg_n[36+:6] = PWDATA[21:16];
					pad_cfg_n[42+:6] = PWDATA[29:24];
				end
				4'b1010: begin
					pad_cfg_n[48+:6] = PWDATA[5:0];
					pad_cfg_n[54+:6] = PWDATA[13:8];
					pad_cfg_n[60+:6] = PWDATA[21:16];
					pad_cfg_n[66+:6] = PWDATA[29:24];
				end
				4'b1011: begin
					pad_cfg_n[72+:6] = PWDATA[5:0];
					pad_cfg_n[78+:6] = PWDATA[13:8];
					pad_cfg_n[84+:6] = PWDATA[21:16];
					pad_cfg_n[90+:6] = PWDATA[29:24];
				end
				4'b1100: begin
					pad_cfg_n[96+:6] = PWDATA[5:0];
					pad_cfg_n[102+:6] = PWDATA[13:8];
					pad_cfg_n[108+:6] = PWDATA[21:16];
					pad_cfg_n[114+:6] = PWDATA[29:24];
				end
				4'b1101: begin
					pad_cfg_n[120+:6] = PWDATA[5:0];
					pad_cfg_n[126+:6] = PWDATA[13:8];
					pad_cfg_n[132+:6] = PWDATA[21:16];
					pad_cfg_n[138+:6] = PWDATA[29:24];
				end
				4'b1110: begin
					pad_cfg_n[144+:6] = PWDATA[5:0];
					pad_cfg_n[150+:6] = PWDATA[13:8];
					pad_cfg_n[156+:6] = PWDATA[21:16];
					pad_cfg_n[162+:6] = PWDATA[29:24];
				end
				4'b1111: begin
					pad_cfg_n[168+:6] = PWDATA[5:0];
					pad_cfg_n[174+:6] = PWDATA[13:8];
					pad_cfg_n[180+:6] = PWDATA[21:16];
					pad_cfg_n[186+:6] = PWDATA[29:24];
				end
				4'b0101: status_n = PWDATA[1:0];
			endcase
	end
	always @(*) begin
		PRDATA = 'b0;
		if ((PSEL && PENABLE) && !PWRITE)
			case (register_adr)
				4'b0000: PRDATA = pad_mux_q;
				4'b0010: PRDATA = boot_adr_q;
				4'b0001: PRDATA = clk_gate_q;
				4'b1000: PRDATA = {2'b00, pad_cfg_q[18+:6], 2'b00, pad_cfg_q[12+:6], 2'b00, pad_cfg_q[6+:6], 2'b00, pad_cfg_q[0+:6]};
				4'b1001: PRDATA = {2'b00, pad_cfg_q[42+:6], 2'b00, pad_cfg_q[36+:6], 2'b00, pad_cfg_q[30+:6], 2'b00, pad_cfg_q[24+:6]};
				4'b1010: PRDATA = {2'b00, pad_cfg_q[66+:6], 2'b00, pad_cfg_q[60+:6], 2'b00, pad_cfg_q[54+:6], 2'b00, pad_cfg_q[48+:6]};
				4'b1011: PRDATA = {2'b00, pad_cfg_q[90+:6], 2'b00, pad_cfg_q[84+:6], 2'b00, pad_cfg_q[78+:6], 2'b00, pad_cfg_q[72+:6]};
				4'b1100: PRDATA = {2'b00, pad_cfg_q[114+:6], 2'b00, pad_cfg_q[108+:6], 2'b00, pad_cfg_q[102+:6], 2'b00, pad_cfg_q[96+:6]};
				4'b1101: PRDATA = {2'b00, pad_cfg_q[138+:6], 2'b00, pad_cfg_q[132+:6], 2'b00, pad_cfg_q[126+:6], 2'b00, pad_cfg_q[120+:6]};
				4'b1110: PRDATA = {2'b00, pad_cfg_q[162+:6], 2'b00, pad_cfg_q[156+:6], 2'b00, pad_cfg_q[150+:6], 2'b00, pad_cfg_q[144+:6]};
				4'b1111: PRDATA = {2'b00, pad_cfg_q[186+:6], 2'b00, pad_cfg_q[180+:6], 2'b00, pad_cfg_q[174+:6], 2'b00, pad_cfg_q[168+:6]};
				4'b0100: PRDATA = 32'b00000000000000001000000010000010;
				4'b0101: PRDATA = {30'b000000000000000000000000000000, status_q[1:0]};
				default: PRDATA = 'b0;
			endcase
	end
	always @(posedge HCLK or negedge HRESETn)
		if (~HRESETn) begin
			pad_mux_q <= 32'b00000000000000000000000000000000;
			clk_gate_q <= 1'sb1;
			pad_cfg_q <= {32 {6'b000000}};
			boot_adr_q <= BOOT_ADDR;
			status_q <= 1'sb1;
			pad_cfg_q[0+:6] <= 6'b000000;
			pad_cfg_q[6+:6] <= 6'b000000;
			pad_cfg_q[12+:6] <= 6'b000000;
			pad_cfg_q[18+:6] <= 6'b000000;
			pad_cfg_q[24+:6] <= 6'b000000;
			pad_cfg_q[30+:6] <= 6'b000000;
			pad_cfg_q[36+:6] <= 6'b000000;
			pad_cfg_q[42+:6] <= 6'b000000;
			pad_cfg_q[48+:6] <= 6'b000000;
			pad_cfg_q[54+:6] <= 6'b000000;
			pad_cfg_q[60+:6] <= 6'b000000;
			pad_cfg_q[66+:6] <= 6'b000000;
			pad_cfg_q[72+:6] <= 6'b000000;
			pad_cfg_q[78+:6] <= 6'b000000;
			pad_cfg_q[84+:6] <= 6'b000000;
			pad_cfg_q[90+:6] <= 6'b000000;
			pad_cfg_q[96+:6] <= 6'b000000;
			pad_cfg_q[102+:6] <= 6'b000000;
			pad_cfg_q[108+:6] <= 6'b000000;
			pad_cfg_q[114+:6] <= 6'b000000;
			pad_cfg_q[120+:6] <= 6'b000000;
		end
		else begin
			pad_mux_q <= pad_mux_n;
			clk_gate_q <= clk_gate_n;
			pad_cfg_q <= pad_cfg_n;
			boot_adr_q <= boot_adr_n;
			status_q <= status_n;
		end
	assign PREADY = 1'b1;
	assign PSLVERR = 1'b0;
endmodule
