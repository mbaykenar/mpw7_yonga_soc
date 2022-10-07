module apb_node_wrap 
#(
    parameter NB_MASTER = 8,
    parameter APB_DATA_WIDTH = 32,
    parameter APB_ADDR_WIDTH = 32
    )
(
	clk_i,
	rst_ni,
	apb_slave_paddr,
	apb_slave_pwdata,
	apb_slave_pwrite,
	apb_slave_psel,
	apb_slave_penable,
	apb_slave_prdata,
	apb_slave_pready,
	apb_slave_pslverr,
	apb_masters00_paddr,
	apb_masters00_pwdata,
	apb_masters00_pwrite,
	apb_masters00_psel,
	apb_masters00_penable,
	apb_masters00_prdata,
	apb_masters00_pready,
	apb_masters00_pslverr,
	apb_masters01_paddr,
	apb_masters01_pwdata,
	apb_masters01_pwrite,
	apb_masters01_psel,
	apb_masters01_penable,
	apb_masters01_prdata,
	apb_masters01_pready,
	apb_masters01_pslverr,
	apb_masters02_paddr,
	apb_masters02_pwdata,
	apb_masters02_pwrite,
	apb_masters02_psel,
	apb_masters02_penable,
	apb_masters02_prdata,
	apb_masters02_pready,
	apb_masters02_pslverr,
	apb_masters03_paddr,
	apb_masters03_pwdata,
	apb_masters03_pwrite,
	apb_masters03_psel,
	apb_masters03_penable,
	apb_masters03_prdata,
	apb_masters03_pready,
	apb_masters03_pslverr,
	apb_masters04_paddr,
	apb_masters04_pwdata,
	apb_masters04_pwrite,
	apb_masters04_psel,
	apb_masters04_penable,
	apb_masters04_prdata,
	apb_masters04_pready,
	apb_masters04_pslverr,
	apb_masters05_paddr,
	apb_masters05_pwdata,
	apb_masters05_pwrite,
	apb_masters05_psel,
	apb_masters05_penable,
	apb_masters05_prdata,
	apb_masters05_pready,
	apb_masters05_pslverr,
	apb_masters06_paddr,
	apb_masters06_pwdata,
	apb_masters06_pwrite,
	apb_masters06_psel,
	apb_masters06_penable,
	apb_masters06_prdata,
	apb_masters06_pready,
	apb_masters06_pslverr,
	apb_masters07_paddr,
	apb_masters07_pwdata,
	apb_masters07_pwrite,
	apb_masters07_psel,
	apb_masters07_penable,
	apb_masters07_prdata,
	apb_masters07_pready,
	apb_masters07_pslverr,
	apb_masters08_paddr,
	apb_masters08_pwdata,
	apb_masters08_pwrite,
	apb_masters08_psel,
	apb_masters08_penable,
	apb_masters08_prdata,
	apb_masters08_pready,
	apb_masters08_pslverr,
	start_addr_i,
	end_addr_i
);
	//parameter NB_MASTER = 9;
	//parameter APB_DATA_WIDTH = 32;
	//parameter APB_ADDR_WIDTH = 32;
	input wire clk_i;
	input wire rst_ni;
	input wire [APB_ADDR_WIDTH - 1:0] apb_slave_paddr;
	input wire [APB_DATA_WIDTH - 1:0] apb_slave_pwdata;
	input wire apb_slave_pwrite;
	input wire apb_slave_psel;
	input wire apb_slave_penable;
	output wire [APB_DATA_WIDTH - 1:0] apb_slave_prdata;
	output wire apb_slave_pready;
	output wire apb_slave_pslverr;
	output wire [APB_ADDR_WIDTH - 1:0] apb_masters00_paddr;
	output wire [APB_DATA_WIDTH - 1:0] apb_masters00_pwdata;
	output wire apb_masters00_pwrite;
	output wire apb_masters00_psel;
	output wire apb_masters00_penable;
	input wire [APB_DATA_WIDTH - 1:0] apb_masters00_prdata;
	input wire apb_masters00_pready;
	input wire apb_masters00_pslverr;
	output wire [APB_ADDR_WIDTH - 1:0] apb_masters01_paddr;
	output wire [APB_DATA_WIDTH - 1:0] apb_masters01_pwdata;
	output wire apb_masters01_pwrite;
	output wire apb_masters01_psel;
	output wire apb_masters01_penable;
	input wire [APB_DATA_WIDTH - 1:0] apb_masters01_prdata;
	input wire apb_masters01_pready;
	input wire apb_masters01_pslverr;
	output wire [APB_ADDR_WIDTH - 1:0] apb_masters02_paddr;
	output wire [APB_DATA_WIDTH - 1:0] apb_masters02_pwdata;
	output wire apb_masters02_pwrite;
	output wire apb_masters02_psel;
	output wire apb_masters02_penable;
	input wire [APB_DATA_WIDTH - 1:0] apb_masters02_prdata;
	input wire apb_masters02_pready;
	input wire apb_masters02_pslverr;
	output wire [APB_ADDR_WIDTH - 1:0] apb_masters03_paddr;
	output wire [APB_DATA_WIDTH - 1:0] apb_masters03_pwdata;
	output wire apb_masters03_pwrite;
	output wire apb_masters03_psel;
	output wire apb_masters03_penable;
	input wire [APB_DATA_WIDTH - 1:0] apb_masters03_prdata;
	input wire apb_masters03_pready;
	input wire apb_masters03_pslverr;
	output wire [APB_ADDR_WIDTH - 1:0] apb_masters04_paddr;
	output wire [APB_DATA_WIDTH - 1:0] apb_masters04_pwdata;
	output wire apb_masters04_pwrite;
	output wire apb_masters04_psel;
	output wire apb_masters04_penable;
	input wire [APB_DATA_WIDTH - 1:0] apb_masters04_prdata;
	input wire apb_masters04_pready;
	input wire apb_masters04_pslverr;
	output wire [APB_ADDR_WIDTH - 1:0] apb_masters05_paddr;
	output wire [APB_DATA_WIDTH - 1:0] apb_masters05_pwdata;
	output wire apb_masters05_pwrite;
	output wire apb_masters05_psel;
	output wire apb_masters05_penable;
	input wire [APB_DATA_WIDTH - 1:0] apb_masters05_prdata;
	input wire apb_masters05_pready;
	input wire apb_masters05_pslverr;
	output wire [APB_ADDR_WIDTH - 1:0] apb_masters06_paddr;
	output wire [APB_DATA_WIDTH - 1:0] apb_masters06_pwdata;
	output wire apb_masters06_pwrite;
	output wire apb_masters06_psel;
	output wire apb_masters06_penable;
	input wire [APB_DATA_WIDTH - 1:0] apb_masters06_prdata;
	input wire apb_masters06_pready;
	input wire apb_masters06_pslverr;
	output wire [APB_ADDR_WIDTH - 1:0] apb_masters07_paddr;
	output wire [APB_DATA_WIDTH - 1:0] apb_masters07_pwdata;
	output wire apb_masters07_pwrite;
	output wire apb_masters07_psel;
	output wire apb_masters07_penable;
	input wire [APB_DATA_WIDTH - 1:0] apb_masters07_prdata;
	input wire apb_masters07_pready;
	input wire apb_masters07_pslverr;
	output wire [APB_ADDR_WIDTH - 1:0] apb_masters08_paddr;
	output wire [APB_DATA_WIDTH - 1:0] apb_masters08_pwdata;
	output wire apb_masters08_pwrite;
	output wire apb_masters08_psel;
	output wire apb_masters08_penable;
	input wire [APB_DATA_WIDTH - 1:0] apb_masters08_prdata;
	input wire apb_masters08_pready;
	input wire apb_masters08_pslverr;
	input wire [(NB_MASTER * APB_ADDR_WIDTH) - 1:0] start_addr_i;
	input wire [(NB_MASTER * APB_ADDR_WIDTH) - 1:0] end_addr_i;
	genvar i;
	wire [NB_MASTER - 1:0] penable;
	wire [NB_MASTER - 1:0] pwrite;
	wire [(NB_MASTER * 32) - 1:0] paddr;
	wire [NB_MASTER - 1:0] psel;
	wire [(NB_MASTER * 32) - 1:0] pwdata;
	wire [(NB_MASTER * 32) - 1:0] prdata;
	wire [NB_MASTER - 1:0] pready;
	wire [NB_MASTER - 1:0] pslverr;
	assign apb_masters00_penable = penable[0];
	assign apb_masters00_pwrite = pwrite[0];
	assign apb_masters00_paddr = paddr[0+:32];
	assign apb_masters00_psel = psel[0];
	assign apb_masters00_pwdata = pwdata[0+:32];
	assign prdata[0+:32] = apb_masters00_prdata;
	assign pready[0] = apb_masters00_pready;
	assign pslverr[0] = apb_masters00_pslverr;
	assign apb_masters01_penable = penable[1];
	assign apb_masters01_pwrite = pwrite[1];
	assign apb_masters01_paddr = paddr[32+:32];
	assign apb_masters01_psel = psel[1];
	assign apb_masters01_pwdata = pwdata[32+:32];
	assign prdata[32+:32] = apb_masters01_prdata;
	assign pready[1] = apb_masters01_pready;
	assign pslverr[1] = apb_masters01_pslverr;
	assign apb_masters02_penable = penable[2];
	assign apb_masters02_pwrite = pwrite[2];
	assign apb_masters02_paddr = paddr[64+:32];
	assign apb_masters02_psel = psel[2];
	assign apb_masters02_pwdata = pwdata[64+:32];
	assign prdata[64+:32] = apb_masters02_prdata;
	assign pready[2] = apb_masters02_pready;
	assign pslverr[2] = apb_masters02_pslverr;
	assign apb_masters03_penable = penable[3];
	assign apb_masters03_pwrite = pwrite[3];
	assign apb_masters03_paddr = paddr[96+:32];
	assign apb_masters03_psel = psel[3];
	assign apb_masters03_pwdata = pwdata[96+:32];
	assign prdata[96+:32] = apb_masters03_prdata;
	assign pready[3] = apb_masters03_pready;
	assign pslverr[3] = apb_masters03_pslverr;
	assign apb_masters04_penable = penable[4];
	assign apb_masters04_pwrite = pwrite[4];
	assign apb_masters04_paddr = paddr[128+:32];
	assign apb_masters04_psel = psel[4];
	assign apb_masters04_pwdata = pwdata[128+:32];
	assign prdata[128+:32] = apb_masters04_prdata;
	assign pready[4] = apb_masters04_pready;
	assign pslverr[4] = apb_masters04_pslverr;
	assign apb_masters05_penable = penable[5];
	assign apb_masters05_pwrite = pwrite[5];
	assign apb_masters05_paddr = paddr[160+:32];
	assign apb_masters05_psel = psel[5];
	assign apb_masters05_pwdata = pwdata[160+:32];
	assign prdata[160+:32] = apb_masters05_prdata;
	assign pready[5] = apb_masters05_pready;
	assign pslverr[5] = apb_masters05_pslverr;
	assign apb_masters06_penable = penable[6];
	assign apb_masters06_pwrite = pwrite[6];
	assign apb_masters06_paddr = paddr[192+:32];
	assign apb_masters06_psel = psel[6];
	assign apb_masters06_pwdata = pwdata[192+:32];
	assign prdata[192+:32] = apb_masters06_prdata;
	assign pready[6] = apb_masters06_pready;
	assign pslverr[6] = apb_masters06_pslverr;
	assign apb_masters07_penable = penable[7];
	assign apb_masters07_pwrite = pwrite[7];
	assign apb_masters07_paddr = paddr[224+:32];
	assign apb_masters07_psel = psel[7];
	assign apb_masters07_pwdata = pwdata[224+:32];
	assign prdata[224+:32] = apb_masters07_prdata;
	assign pready[7] = apb_masters07_pready;
	assign pslverr[7] = apb_masters07_pslverr;
	assign apb_masters08_penable = penable[8];
	assign apb_masters08_pwrite = pwrite[8];
	assign apb_masters08_paddr = paddr[256+:32];
	assign apb_masters08_psel = psel[8];
	assign apb_masters08_pwdata = pwdata[256+:32];
	assign prdata[256+:32] = apb_masters08_prdata;
	assign pready[8] = apb_masters08_pready;
	assign pslverr[8] = apb_masters08_pslverr;
	apb_node #(
		.NB_MASTER(NB_MASTER),
		.APB_DATA_WIDTH(APB_DATA_WIDTH),
		.APB_ADDR_WIDTH(APB_ADDR_WIDTH)
	) apb_node_i(
		.penable_i(apb_slave_penable),
		.pwrite_i(apb_slave_pwrite),
		.paddr_i(apb_slave_paddr),
		.pwdata_i(apb_slave_pwdata),
		.prdata_o(apb_slave_prdata),
		.pready_o(apb_slave_pready),
		.pslverr_o(apb_slave_pslverr),
		.penable_o(penable),
		.pwrite_o(pwrite),
		.paddr_o(paddr),
		.psel_o(psel),
		.pwdata_o(pwdata),
		.prdata_i(prdata),
		.pready_i(pready),
		.pslverr_i(pslverr),
		.START_ADDR_i(start_addr_i),
		.END_ADDR_i(end_addr_i)
	);
endmodule
