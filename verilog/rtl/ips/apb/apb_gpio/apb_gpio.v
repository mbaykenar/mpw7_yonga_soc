module apb_gpio 
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
	gpio_in,
	gpio_in_sync,
	gpio_out,
	gpio_dir,
	gpio_padcfg,
	power_event,
	interrupt
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
	input wire [31:0] gpio_in;
	output wire [31:0] gpio_in_sync;
	output wire [31:0] gpio_out;
	output wire [31:0] gpio_dir;
	output reg [191:0] gpio_padcfg;
	output reg power_event;
	output reg interrupt;
	reg [31:0] r_gpio_inten;
	reg [31:0] r_gpio_inttype0;
	reg [31:0] r_gpio_inttype1;
	reg [31:0] r_gpio_out;
	reg [31:0] r_gpio_dir;
	reg [31:0] r_gpio_sync0;
	reg [31:0] r_gpio_sync1;
	reg [31:0] r_gpio_in;
	reg [31:0] r_powerevent;
	wire [31:0] s_gpio_rise;
	wire [31:0] s_gpio_fall;
	wire [31:0] s_is_int_rise;
	wire [31:0] s_is_int_fall;
	wire [31:0] s_is_int_lev0;
	wire [31:0] s_is_int_lev1;
	wire [31:0] s_is_int_all;
	wire s_rise_int;
	wire [3:0] s_apb_addr;
	reg [31:0] r_status;
	assign s_apb_addr = PADDR[5:2];
	assign gpio_in_sync = r_gpio_sync1;
	assign s_gpio_rise = r_gpio_sync1 & ~r_gpio_in;
	assign s_gpio_fall = ~r_gpio_sync1 & r_gpio_in;
	assign s_is_int_rise = (r_gpio_inttype1 & ~r_gpio_inttype0) & s_gpio_rise;
	assign s_is_int_fall = (r_gpio_inttype1 & r_gpio_inttype0) & s_gpio_fall;
	assign s_is_int_lev0 = (~r_gpio_inttype1 & r_gpio_inttype0) & ~r_gpio_in;
	assign s_is_int_lev1 = (~r_gpio_inttype1 & ~r_gpio_inttype0) & r_gpio_in;
	assign s_is_int_all = r_gpio_inten & (((s_is_int_rise | s_is_int_fall) | s_is_int_lev0) | s_is_int_lev1);
	assign s_rise_int = |s_is_int_all;
	always @(posedge HCLK or negedge HRESETn)
		if (~HRESETn) begin
			interrupt <= 1'b0;
			r_status <= 'h0;
		end
		else if (!interrupt && s_rise_int) begin
			interrupt <= 1'b1;
			r_status <= s_is_int_all;
		end
		else if ((((interrupt && PSEL) && PENABLE) && !PWRITE) && (s_apb_addr == 4'b0110)) begin
			interrupt <= 1'b0;
			r_status <= 'h0;
		end
	always @(posedge HCLK or negedge HRESETn)
		if (~HRESETn) begin
			r_gpio_sync0 <= 'h0;
			r_gpio_sync1 <= 'h0;
			r_gpio_in <= 'h0;
		end
		else begin
			r_gpio_sync0 <= gpio_in;
			r_gpio_sync1 <= r_gpio_sync0;
			r_gpio_in <= r_gpio_sync1;
		end
	always @(posedge HCLK or negedge HRESETn)
		if (~HRESETn) begin
			r_gpio_inten <= 1'sb0;
			r_gpio_inttype0 <= 1'sb0;
			r_gpio_inttype1 <= 1'sb0;
			r_gpio_out <= 1'sb0;
			r_gpio_dir <= 1'sb0;
			r_powerevent <= 1'sb0;
			begin : sv2v_autoblock_1
				reg signed [31:0] i;
				for (i = 0; i < 32; i = i + 1)
					gpio_padcfg[i * 6+:6] <= 6'b000010;
			end
		end
		else if ((PSEL && PENABLE) && PWRITE)
			case (s_apb_addr)
				4'b0000: r_gpio_dir <= PWDATA;
				4'b0010: r_gpio_out <= PWDATA;
				4'b0011: r_gpio_inten <= PWDATA;
				4'b0100: r_gpio_inttype0 <= PWDATA;
				4'b0101: r_gpio_inttype1 <= PWDATA;
				4'b0111: r_powerevent <= PWDATA;
				4'b1000: begin
					gpio_padcfg[0+:6] <= PWDATA[5:0];
					gpio_padcfg[6+:6] <= PWDATA[13:8];
					gpio_padcfg[12+:6] <= PWDATA[21:16];
					gpio_padcfg[18+:6] <= PWDATA[29:24];
				end
				4'b1001: begin
					gpio_padcfg[24+:6] <= PWDATA[5:0];
					gpio_padcfg[30+:6] <= PWDATA[13:8];
					gpio_padcfg[36+:6] <= PWDATA[21:16];
					gpio_padcfg[42+:6] <= PWDATA[29:24];
				end
				4'b1010: begin
					gpio_padcfg[48+:6] <= PWDATA[5:0];
					gpio_padcfg[54+:6] <= PWDATA[13:8];
					gpio_padcfg[60+:6] <= PWDATA[21:16];
					gpio_padcfg[66+:6] <= PWDATA[29:24];
				end
				4'b1011: begin
					gpio_padcfg[72+:6] <= PWDATA[5:0];
					gpio_padcfg[78+:6] <= PWDATA[13:8];
					gpio_padcfg[84+:6] <= PWDATA[21:16];
					gpio_padcfg[90+:6] <= PWDATA[29:24];
				end
				4'b1100: begin
					gpio_padcfg[96+:6] <= PWDATA[5:0];
					gpio_padcfg[102+:6] <= PWDATA[13:8];
					gpio_padcfg[108+:6] <= PWDATA[21:16];
					gpio_padcfg[114+:6] <= PWDATA[29:24];
				end
				4'b1101: begin
					gpio_padcfg[120+:6] <= PWDATA[5:0];
					gpio_padcfg[126+:6] <= PWDATA[13:8];
					gpio_padcfg[132+:6] <= PWDATA[21:16];
					gpio_padcfg[138+:6] <= PWDATA[29:24];
				end
				4'b1110: begin
					gpio_padcfg[144+:6] <= PWDATA[5:0];
					gpio_padcfg[150+:6] <= PWDATA[13:8];
					gpio_padcfg[156+:6] <= PWDATA[21:16];
					gpio_padcfg[162+:6] <= PWDATA[29:24];
				end
				4'b1111: begin
					gpio_padcfg[168+:6] <= PWDATA[5:0];
					gpio_padcfg[174+:6] <= PWDATA[13:8];
					gpio_padcfg[180+:6] <= PWDATA[21:16];
					gpio_padcfg[186+:6] <= PWDATA[29:24];
				end
			endcase
	always @(*)
		case (s_apb_addr)
			4'b0000: PRDATA = r_gpio_dir;
			4'b0001: PRDATA = r_gpio_in;
			4'b0010: PRDATA = r_gpio_out;
			4'b0011: PRDATA = r_gpio_inten;
			4'b0100: PRDATA = r_gpio_inttype0;
			4'b0101: PRDATA = r_gpio_inttype1;
			4'b0110: PRDATA = r_status;
			4'b0111: PRDATA = r_powerevent;
			4'b1000: PRDATA = {2'b00, gpio_padcfg[18+:6], 2'b00, gpio_padcfg[12+:6], 2'b00, gpio_padcfg[6+:6], 2'b00, gpio_padcfg[0+:6]};
			4'b1001: PRDATA = {2'b00, gpio_padcfg[42+:6], 2'b00, gpio_padcfg[36+:6], 2'b00, gpio_padcfg[30+:6], 2'b00, gpio_padcfg[24+:6]};
			4'b1010: PRDATA = {2'b00, gpio_padcfg[66+:6], 2'b00, gpio_padcfg[60+:6], 2'b00, gpio_padcfg[54+:6], 2'b00, gpio_padcfg[48+:6]};
			4'b1011: PRDATA = {2'b00, gpio_padcfg[90+:6], 2'b00, gpio_padcfg[84+:6], 2'b00, gpio_padcfg[78+:6], 2'b00, gpio_padcfg[72+:6]};
			4'b1100: PRDATA = {2'b00, gpio_padcfg[114+:6], 2'b00, gpio_padcfg[108+:6], 2'b00, gpio_padcfg[102+:6], 2'b00, gpio_padcfg[96+:6]};
			4'b1101: PRDATA = {2'b00, gpio_padcfg[138+:6], 2'b00, gpio_padcfg[132+:6], 2'b00, gpio_padcfg[126+:6], 2'b00, gpio_padcfg[120+:6]};
			4'b1110: PRDATA = {2'b00, gpio_padcfg[162+:6], 2'b00, gpio_padcfg[156+:6], 2'b00, gpio_padcfg[150+:6], 2'b00, gpio_padcfg[144+:6]};
			4'b1111: PRDATA = {2'b00, gpio_padcfg[186+:6], 2'b00, gpio_padcfg[180+:6], 2'b00, gpio_padcfg[174+:6], 2'b00, gpio_padcfg[168+:6]};
			default: PRDATA = 'h0;
		endcase
	always @(*) begin
		power_event = 1'b0;
		begin : sv2v_autoblock_2
			reg signed [31:0] e;
			for (e = 0; e < 32; e = e + 1)
				if (r_powerevent[e] == 1'b1)
					power_event = gpio_in[e];
		end
	end
	assign gpio_out = r_gpio_out;
	assign gpio_dir = r_gpio_dir;
	assign PREADY = 1'b1;
	assign PSLVERR = 1'b0;
endmodule
