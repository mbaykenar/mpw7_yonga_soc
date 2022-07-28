module periph_bus_wrap 
#(
    parameter APB_ADDR_WIDTH = 32,
    parameter APB_DATA_WIDTH = 32
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
	uart_master_paddr,
	uart_master_pwdata,
	uart_master_pwrite,
	uart_master_psel,
	uart_master_penable,
	uart_master_prdata,
	uart_master_pready,
	uart_master_pslverr,
	gpio_master_paddr,
	gpio_master_pwdata,
	gpio_master_pwrite,
	gpio_master_psel,
	gpio_master_penable,
	gpio_master_prdata,
	gpio_master_pready,
	gpio_master_pslverr,
	spi_master_paddr,
	spi_master_pwdata,
	spi_master_pwrite,
	spi_master_psel,
	spi_master_penable,
	spi_master_prdata,
	spi_master_pready,
	spi_master_pslverr,
	timer_master_paddr,
	timer_master_pwdata,
	timer_master_pwrite,
	timer_master_psel,
	timer_master_penable,
	timer_master_prdata,
	timer_master_pready,
	timer_master_pslverr,
	event_unit_master_paddr,
	event_unit_master_pwdata,
	event_unit_master_pwrite,
	event_unit_master_psel,
	event_unit_master_penable,
	event_unit_master_prdata,
	event_unit_master_pready,
	event_unit_master_pslverr,
	i2c_unit_master_paddr,
	i2c_unit_master_pwdata,
	i2c_unit_master_pwrite,
	i2c_unit_master_psel,
	i2c_unit_master_penable,
	i2c_unit_master_prdata,
	i2c_unit_master_pready,
	i2c_unit_master_pslverr,
	fll_master_paddr,
	fll_master_pwdata,
	fll_master_pwrite,
	fll_master_psel,
	fll_master_penable,
	fll_master_prdata,
	fll_master_pready,
	fll_master_pslverr,
	soc_ctrl_master_paddr,
	soc_ctrl_master_pwdata,
	soc_ctrl_master_pwrite,
	soc_ctrl_master_psel,
	soc_ctrl_master_penable,
	soc_ctrl_master_prdata,
	soc_ctrl_master_pready,
	soc_ctrl_master_pslverr,
	debug_master_paddr,
	debug_master_pwdata,
	debug_master_pwrite,
	debug_master_psel,
	debug_master_penable,
	debug_master_prdata,
	debug_master_pready,
	debug_master_pslverr
);
	//parameter APB_ADDR_WIDTH = 32;
	//parameter APB_DATA_WIDTH = 32;
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
	output wire [APB_ADDR_WIDTH - 1:0] uart_master_paddr;
	output wire [APB_DATA_WIDTH - 1:0] uart_master_pwdata;
	output wire uart_master_pwrite;
	output wire uart_master_psel;
	output wire uart_master_penable;
	input wire [APB_DATA_WIDTH - 1:0] uart_master_prdata;
	input wire uart_master_pready;
	input wire uart_master_pslverr;
	output wire [APB_ADDR_WIDTH - 1:0] gpio_master_paddr;
	output wire [APB_DATA_WIDTH - 1:0] gpio_master_pwdata;
	output wire gpio_master_pwrite;
	output wire gpio_master_psel;
	output wire gpio_master_penable;
	input wire [APB_DATA_WIDTH - 1:0] gpio_master_prdata;
	input wire gpio_master_pready;
	input wire gpio_master_pslverr;
	output wire [APB_ADDR_WIDTH - 1:0] spi_master_paddr;
	output wire [APB_DATA_WIDTH - 1:0] spi_master_pwdata;
	output wire spi_master_pwrite;
	output wire spi_master_psel;
	output wire spi_master_penable;
	input wire [APB_DATA_WIDTH - 1:0] spi_master_prdata;
	input wire spi_master_pready;
	input wire spi_master_pslverr;
	output wire [APB_ADDR_WIDTH - 1:0] timer_master_paddr;
	output wire [APB_DATA_WIDTH - 1:0] timer_master_pwdata;
	output wire timer_master_pwrite;
	output wire timer_master_psel;
	output wire timer_master_penable;
	input wire [APB_DATA_WIDTH - 1:0] timer_master_prdata;
	input wire timer_master_pready;
	input wire timer_master_pslverr;
	output wire [APB_ADDR_WIDTH - 1:0] event_unit_master_paddr;
	output wire [APB_DATA_WIDTH - 1:0] event_unit_master_pwdata;
	output wire event_unit_master_pwrite;
	output wire event_unit_master_psel;
	output wire event_unit_master_penable;
	input wire [APB_DATA_WIDTH - 1:0] event_unit_master_prdata;
	input wire event_unit_master_pready;
	input wire event_unit_master_pslverr;
	output wire [APB_ADDR_WIDTH - 1:0] i2c_unit_master_paddr;
	output wire [APB_DATA_WIDTH - 1:0] i2c_unit_master_pwdata;
	output wire i2c_unit_master_pwrite;
	output wire i2c_unit_master_psel;
	output wire i2c_unit_master_penable;
	input wire [APB_DATA_WIDTH - 1:0] i2c_unit_master_prdata;
	input wire i2c_unit_master_pready;
	input wire i2c_unit_master_pslverr;
	output wire [APB_ADDR_WIDTH - 1:0] fll_master_paddr;
	output wire [APB_DATA_WIDTH - 1:0] fll_master_pwdata;
	output wire fll_master_pwrite;
	output wire fll_master_psel;
	output wire fll_master_penable;
	input wire [APB_DATA_WIDTH - 1:0] fll_master_prdata;
	input wire fll_master_pready;
	input wire fll_master_pslverr;
	output wire [APB_ADDR_WIDTH - 1:0] soc_ctrl_master_paddr;
	output wire [APB_DATA_WIDTH - 1:0] soc_ctrl_master_pwdata;
	output wire soc_ctrl_master_pwrite;
	output wire soc_ctrl_master_psel;
	output wire soc_ctrl_master_penable;
	input wire [APB_DATA_WIDTH - 1:0] soc_ctrl_master_prdata;
	input wire soc_ctrl_master_pready;
	input wire soc_ctrl_master_pslverr;
	output wire [APB_ADDR_WIDTH - 1:0] debug_master_paddr;
	output wire [APB_DATA_WIDTH - 1:0] debug_master_pwdata;
	output wire debug_master_pwrite;
	output wire debug_master_psel;
	output wire debug_master_penable;
	input wire [APB_DATA_WIDTH - 1:0] debug_master_prdata;
	input wire debug_master_pready;
	input wire debug_master_pslverr;
	localparam NB_MASTER = 9;
	wire [(9 * APB_ADDR_WIDTH) - 1:0] s_start_addr;
	wire [(9 * APB_ADDR_WIDTH) - 1:0] s_end_addr;
	wire [APB_ADDR_WIDTH - 1:0] s_masters00_paddr;
	wire [APB_DATA_WIDTH - 1:0] s_masters00_pwdata;
	wire s_masters00_pwrite;
	wire s_masters00_psel;
	wire s_masters00_penable;
	wire [APB_DATA_WIDTH - 1:0] s_masters00_prdata;
	wire s_masters00_pready;
	wire s_masters00_pslverr;
	wire [APB_ADDR_WIDTH - 1:0] s_masters01_paddr;
	wire [APB_DATA_WIDTH - 1:0] s_masters01_pwdata;
	wire s_masters01_pwrite;
	wire s_masters01_psel;
	wire s_masters01_penable;
	wire [APB_DATA_WIDTH - 1:0] s_masters01_prdata;
	wire s_masters01_pready;
	wire s_masters01_pslverr;
	wire [APB_ADDR_WIDTH - 1:0] s_masters02_paddr;
	wire [APB_DATA_WIDTH - 1:0] s_masters02_pwdata;
	wire s_masters02_pwrite;
	wire s_masters02_psel;
	wire s_masters02_penable;
	wire [APB_DATA_WIDTH - 1:0] s_masters02_prdata;
	wire s_masters02_pready;
	wire s_masters02_pslverr;
	wire [APB_ADDR_WIDTH - 1:0] s_masters03_paddr;
	wire [APB_DATA_WIDTH - 1:0] s_masters03_pwdata;
	wire s_masters03_pwrite;
	wire s_masters03_psel;
	wire s_masters03_penable;
	wire [APB_DATA_WIDTH - 1:0] s_masters03_prdata;
	wire s_masters03_pready;
	wire s_masters03_pslverr;
	wire [APB_ADDR_WIDTH - 1:0] s_masters04_paddr;
	wire [APB_DATA_WIDTH - 1:0] s_masters04_pwdata;
	wire s_masters04_pwrite;
	wire s_masters04_psel;
	wire s_masters04_penable;
	wire [APB_DATA_WIDTH - 1:0] s_masters04_prdata;
	wire s_masters04_pready;
	wire s_masters04_pslverr;
	wire [APB_ADDR_WIDTH - 1:0] s_masters05_paddr;
	wire [APB_DATA_WIDTH - 1:0] s_masters05_pwdata;
	wire s_masters05_pwrite;
	wire s_masters05_psel;
	wire s_masters05_penable;
	wire [APB_DATA_WIDTH - 1:0] s_masters05_prdata;
	wire s_masters05_pready;
	wire s_masters05_pslverr;
	wire [APB_ADDR_WIDTH - 1:0] s_masters06_paddr;
	wire [APB_DATA_WIDTH - 1:0] s_masters06_pwdata;
	wire s_masters06_pwrite;
	wire s_masters06_psel;
	wire s_masters06_penable;
	wire [APB_DATA_WIDTH - 1:0] s_masters06_prdata;
	wire s_masters06_pready;
	wire s_masters06_pslverr;
	wire [APB_ADDR_WIDTH - 1:0] s_masters07_paddr;
	wire [APB_DATA_WIDTH - 1:0] s_masters07_pwdata;
	wire s_masters07_pwrite;
	wire s_masters07_psel;
	wire s_masters07_penable;
	wire [APB_DATA_WIDTH - 1:0] s_masters07_prdata;
	wire s_masters07_pready;
	wire s_masters07_pslverr;
	wire [APB_ADDR_WIDTH - 1:0] s_masters08_paddr;
	wire [APB_DATA_WIDTH - 1:0] s_masters08_pwdata;
	wire s_masters08_pwrite;
	wire s_masters08_psel;
	wire s_masters08_penable;
	wire [APB_DATA_WIDTH - 1:0] s_masters08_prdata;
	wire s_masters08_pready;
	wire s_masters08_pslverr;
	wire [APB_ADDR_WIDTH - 1:0] s_slave_paddr;
	wire [APB_DATA_WIDTH - 1:0] s_slave_pwdata;
	wire s_slave_pwrite;
	wire s_slave_psel;
	wire s_slave_penable;
	wire [APB_DATA_WIDTH - 1:0] s_slave_prdata;
	wire s_slave_pready;
	wire s_slave_pslverr;
	assign s_slave_paddr = apb_slave_paddr;
	assign s_slave_pwdata = apb_slave_pwdata;
	assign s_slave_pwrite = apb_slave_pwrite;
	assign s_slave_psel = apb_slave_psel;
	assign s_slave_penable = apb_slave_penable;
	assign apb_slave_prdata = s_slave_prdata;
	assign apb_slave_pready = s_slave_pready;
	assign apb_slave_pslverr = s_slave_pslverr;
	assign uart_master_paddr = s_masters00_paddr;
	assign uart_master_pwdata = s_masters00_pwdata;
	assign uart_master_pwrite = s_masters00_pwrite;
	assign uart_master_psel = s_masters00_psel;
	assign uart_master_penable = s_masters00_penable;
	assign s_masters00_prdata = uart_master_prdata;
	assign s_masters00_pready = uart_master_pready;
	assign s_masters00_pslverr = uart_master_pslverr;
	assign s_start_addr[0+:APB_ADDR_WIDTH] = 32'h1a100000;
	assign s_end_addr[0+:APB_ADDR_WIDTH] = 32'h1a100fff;
	assign gpio_master_paddr = s_masters01_paddr;
	assign gpio_master_pwdata = s_masters01_pwdata;
	assign gpio_master_pwrite = s_masters01_pwrite;
	assign gpio_master_psel = s_masters01_psel;
	assign gpio_master_penable = s_masters01_penable;
	assign s_masters01_prdata = gpio_master_prdata;
	assign s_masters01_pready = gpio_master_pready;
	assign s_masters01_pslverr = gpio_master_pslverr;
	assign s_start_addr[APB_ADDR_WIDTH+:APB_ADDR_WIDTH] = 32'h1a101000;
	assign s_end_addr[APB_ADDR_WIDTH+:APB_ADDR_WIDTH] = 32'h1a101fff;
	assign spi_master_paddr = s_masters02_paddr;
	assign spi_master_pwdata = s_masters02_pwdata;
	assign spi_master_pwrite = s_masters02_pwrite;
	assign spi_master_psel = s_masters02_psel;
	assign spi_master_penable = s_masters02_penable;
	assign s_masters02_prdata = spi_master_prdata;
	assign s_masters02_pready = spi_master_pready;
	assign s_masters02_pslverr = spi_master_pslverr;
	assign s_start_addr[2 * APB_ADDR_WIDTH+:APB_ADDR_WIDTH] = 32'h1a102000;
	assign s_end_addr[2 * APB_ADDR_WIDTH+:APB_ADDR_WIDTH] = 32'h1a102fff;
	assign timer_master_paddr = s_masters03_paddr;
	assign timer_master_pwdata = s_masters03_pwdata;
	assign timer_master_pwrite = s_masters03_pwrite;
	assign timer_master_psel = s_masters03_psel;
	assign timer_master_penable = s_masters03_penable;
	assign s_masters03_prdata = timer_master_prdata;
	assign s_masters03_pready = timer_master_pready;
	assign s_masters03_pslverr = timer_master_pslverr;
	assign s_start_addr[3 * APB_ADDR_WIDTH+:APB_ADDR_WIDTH] = 32'h1a103000;
	assign s_end_addr[3 * APB_ADDR_WIDTH+:APB_ADDR_WIDTH] = 32'h1a103fff;
	assign event_unit_master_paddr = s_masters04_paddr;
	assign event_unit_master_pwdata = s_masters04_pwdata;
	assign event_unit_master_pwrite = s_masters04_pwrite;
	assign event_unit_master_psel = s_masters04_psel;
	assign event_unit_master_penable = s_masters04_penable;
	assign s_masters04_prdata = event_unit_master_prdata;
	assign s_masters04_pready = event_unit_master_pready;
	assign s_masters04_pslverr = event_unit_master_pslverr;
	assign s_start_addr[4 * APB_ADDR_WIDTH+:APB_ADDR_WIDTH] = 32'h1a104000;
	assign s_end_addr[4 * APB_ADDR_WIDTH+:APB_ADDR_WIDTH] = 32'h1a104fff;
	assign i2c_unit_master_paddr = s_masters05_paddr;
	assign i2c_unit_master_pwdata = s_masters05_pwdata;
	assign i2c_unit_master_pwrite = s_masters05_pwrite;
	assign i2c_unit_master_psel = s_masters05_psel;
	assign i2c_unit_master_penable = s_masters05_penable;
	assign s_masters05_prdata = i2c_unit_master_prdata;
	assign s_masters05_pready = i2c_unit_master_pready;
	assign s_masters05_pslverr = i2c_unit_master_pslverr;
	assign s_start_addr[5 * APB_ADDR_WIDTH+:APB_ADDR_WIDTH] = 32'h1a105000;
	assign s_end_addr[5 * APB_ADDR_WIDTH+:APB_ADDR_WIDTH] = 32'h1a105fff;
	assign fll_master_paddr = s_masters06_paddr;
	assign fll_master_pwdata = s_masters06_pwdata;
	assign fll_master_pwrite = s_masters06_pwrite;
	assign fll_master_psel = s_masters06_psel;
	assign fll_master_penable = s_masters06_penable;
	assign s_masters06_prdata = fll_master_prdata;
	assign s_masters06_pready = fll_master_pready;
	assign s_masters06_pslverr = fll_master_pslverr;
	assign s_start_addr[6 * APB_ADDR_WIDTH+:APB_ADDR_WIDTH] = 32'h1a106000;
	assign s_end_addr[6 * APB_ADDR_WIDTH+:APB_ADDR_WIDTH] = 32'h1a106fff;
	assign soc_ctrl_master_paddr = s_masters07_paddr;
	assign soc_ctrl_master_pwdata = s_masters07_pwdata;
	assign soc_ctrl_master_pwrite = s_masters07_pwrite;
	assign soc_ctrl_master_psel = s_masters07_psel;
	assign soc_ctrl_master_penable = s_masters07_penable;
	assign s_masters07_prdata = soc_ctrl_master_prdata;
	assign s_masters07_pready = soc_ctrl_master_pready;
	assign s_masters07_pslverr = soc_ctrl_master_pslverr;
	assign s_start_addr[7 * APB_ADDR_WIDTH+:APB_ADDR_WIDTH] = 32'h1a107000;
	assign s_end_addr[7 * APB_ADDR_WIDTH+:APB_ADDR_WIDTH] = 32'h1a107fff;
	assign debug_master_paddr = s_masters08_paddr;
	assign debug_master_pwdata = s_masters08_pwdata;
	assign debug_master_pwrite = s_masters08_pwrite;
	assign debug_master_psel = s_masters08_psel;
	assign debug_master_penable = s_masters08_penable;
	assign s_masters08_prdata = debug_master_prdata;
	assign s_masters08_pready = debug_master_pready;
	assign s_masters08_pslverr = debug_master_pslverr;
	assign s_start_addr[8 * APB_ADDR_WIDTH+:APB_ADDR_WIDTH] = 32'h1a110000;
	assign s_end_addr[8 * APB_ADDR_WIDTH+:APB_ADDR_WIDTH] = 32'h1a117fff;
	apb_node_wrap #(
		.NB_MASTER(NB_MASTER),
		.APB_ADDR_WIDTH(APB_ADDR_WIDTH),
		.APB_DATA_WIDTH(APB_DATA_WIDTH)
	) apb_node_wrap_i(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.apb_slave_paddr(s_slave_paddr),
		.apb_slave_pwdata(s_slave_pwdata),
		.apb_slave_pwrite(s_slave_pwrite),
		.apb_slave_psel(s_slave_psel),
		.apb_slave_penable(s_slave_penable),
		.apb_slave_prdata(s_slave_prdata),
		.apb_slave_pready(s_slave_pready),
		.apb_slave_pslverr(s_slave_pslverr),
		.apb_masters00_paddr(s_masters00_paddr),
		.apb_masters00_pwdata(s_masters00_pwdata),
		.apb_masters00_pwrite(s_masters00_pwrite),
		.apb_masters00_psel(s_masters00_psel),
		.apb_masters00_penable(s_masters00_penable),
		.apb_masters00_prdata(s_masters00_prdata),
		.apb_masters00_pready(s_masters00_pready),
		.apb_masters00_pslverr(s_masters00_pslverr),
		.apb_masters01_paddr(s_masters01_paddr),
		.apb_masters01_pwdata(s_masters01_pwdata),
		.apb_masters01_pwrite(s_masters01_pwrite),
		.apb_masters01_psel(s_masters01_psel),
		.apb_masters01_penable(s_masters01_penable),
		.apb_masters01_prdata(s_masters01_prdata),
		.apb_masters01_pready(s_masters01_pready),
		.apb_masters01_pslverr(s_masters01_pslverr),
		.apb_masters02_paddr(s_masters02_paddr),
		.apb_masters02_pwdata(s_masters02_pwdata),
		.apb_masters02_pwrite(s_masters02_pwrite),
		.apb_masters02_psel(s_masters02_psel),
		.apb_masters02_penable(s_masters02_penable),
		.apb_masters02_prdata(s_masters02_prdata),
		.apb_masters02_pready(s_masters02_pready),
		.apb_masters02_pslverr(s_masters02_pslverr),
		.apb_masters03_paddr(s_masters03_paddr),
		.apb_masters03_pwdata(s_masters03_pwdata),
		.apb_masters03_pwrite(s_masters03_pwrite),
		.apb_masters03_psel(s_masters03_psel),
		.apb_masters03_penable(s_masters03_penable),
		.apb_masters03_prdata(s_masters03_prdata),
		.apb_masters03_pready(s_masters03_pready),
		.apb_masters03_pslverr(s_masters03_pslverr),
		.apb_masters04_paddr(s_masters04_paddr),
		.apb_masters04_pwdata(s_masters04_pwdata),
		.apb_masters04_pwrite(s_masters04_pwrite),
		.apb_masters04_psel(s_masters04_psel),
		.apb_masters04_penable(s_masters04_penable),
		.apb_masters04_prdata(s_masters04_prdata),
		.apb_masters04_pready(s_masters04_pready),
		.apb_masters04_pslverr(s_masters04_pslverr),
		.apb_masters05_paddr(s_masters05_paddr),
		.apb_masters05_pwdata(s_masters05_pwdata),
		.apb_masters05_pwrite(s_masters05_pwrite),
		.apb_masters05_psel(s_masters05_psel),
		.apb_masters05_penable(s_masters05_penable),
		.apb_masters05_prdata(s_masters05_prdata),
		.apb_masters05_pready(s_masters05_pready),
		.apb_masters05_pslverr(s_masters05_pslverr),
		.apb_masters06_paddr(s_masters06_paddr),
		.apb_masters06_pwdata(s_masters06_pwdata),
		.apb_masters06_pwrite(s_masters06_pwrite),
		.apb_masters06_psel(s_masters06_psel),
		.apb_masters06_penable(s_masters06_penable),
		.apb_masters06_prdata(s_masters06_prdata),
		.apb_masters06_pready(s_masters06_pready),
		.apb_masters06_pslverr(s_masters06_pslverr),
		.apb_masters07_paddr(s_masters07_paddr),
		.apb_masters07_pwdata(s_masters07_pwdata),
		.apb_masters07_pwrite(s_masters07_pwrite),
		.apb_masters07_psel(s_masters07_psel),
		.apb_masters07_penable(s_masters07_penable),
		.apb_masters07_prdata(s_masters07_prdata),
		.apb_masters07_pready(s_masters07_pready),
		.apb_masters07_pslverr(s_masters07_pslverr),
		.apb_masters08_paddr(s_masters08_paddr),
		.apb_masters08_pwdata(s_masters08_pwdata),
		.apb_masters08_pwrite(s_masters08_pwrite),
		.apb_masters08_psel(s_masters08_psel),
		.apb_masters08_penable(s_masters08_penable),
		.apb_masters08_prdata(s_masters08_prdata),
		.apb_masters08_pready(s_masters08_pready),
		.apb_masters08_pslverr(s_masters08_pslverr),
		.start_addr_i(s_start_addr),
		.end_addr_i(s_end_addr)
	);
endmodule
