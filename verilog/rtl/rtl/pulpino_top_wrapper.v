`define USE_POWER_PINS 

module pulpino_top_wrapper
(
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // IRQ
    output [2:0] irq
);

    wire [`MPRJ_IO_PADS-1:0] io_in;
    wire [`MPRJ_IO_PADS-1:0] io_out;
    wire [`MPRJ_IO_PADS-1:0] io_oeb;

    wire clk;
    wire rst_n;
    assign rst_n = ~wb_rst_i;
    assign clk = wb_clk_i;

    // IO
    assign io_oeb[19:10] = 10'b0000000000;  // drive low to enable
    assign io_oeb[24] = 1'b0;
    assign io_oeb[30] = 1'b0;
    assign io_oeb[37:31] = 7'b0000000;
    assign la_data_out[127:109] = 19'b1111111110000000000;

    reg [6:0] leds;
    reg [19:0] counter;

    always @ (posedge clk) begin
        if (rst_n == 1'b0) begin
            counter <= 20'h00000;
            leds    <= 7'b0000000;
        end
        else begin
            counter <= counter + 1;
            if (counter == 20'hFFFFF) begin
                counter <= 0;
                leds <= leds + 1;
            end
        end
    end

    assign io_out[37:37] = leds;
    assign irq[2:0] = 3'b000;
    assign wbs_ack_o = 1'b0;
    assign wbs_dat_o = 32'h00000000;

    pulpino_top 
    #(
        .USE_ZERO_RISCY (1),
        .RISCY_RV32F    (0),
        .ZERO_RV32M     (1),
        .ZERO_RV32E     (0)
    )
    pulpino_top
    (
    `ifdef USE_POWER_PINS
        .vccd1(vccd1),	// User area 1 1.8V supply
        .vssd1(vssd1),	// User area 1 digital ground
    `endif
        .clk                (clk),
        .rst_n              (rst_n),
        .clk_sel_i          (1'b0),
        .clk_standalone_i   (1'b0),
        .testmode_i         (1'b0),
        .fetch_enable_i     (io_in[8]),
        .scan_enable_i      (io_in[9]),
        .spi_clk_i          (la_data_in[0]),
        .spi_cs_i           (la_data_in[1]),
        .spi_mode_o         (la_data_out[6]),
        .spi_sdo0_o         (la_data_out[7]),
        .spi_sdo1_o         (la_data_out[8]),
        .spi_sdo2_o         (la_data_out[9]),
        .spi_sdo3_o         (la_data_out[10]),
        .spi_sdi0_i         (la_data_in[2]),
        .spi_sdi1_i         (la_data_in[3]),
        .spi_sdi2_i         (la_data_in[4]),
        .spi_sdi3_i         (la_data_in[5]),
        .spi_master_clk_o   (io_out[10]),
        .spi_master_csn0_o  (io_out[11]),
        .spi_master_csn1_o  (io_out[12]),
        .spi_master_csn2_o  (io_out[13]),
        .spi_master_csn3_o  (io_out[14]),
        .spi_master_mode_o  (io_out[15]),
        .spi_master_sdo0_o  (io_out[16]),
        .spi_master_sdo1_o  (io_out[17]),
        .spi_master_sdo2_o  (io_out[18]),
        .spi_master_sdo3_o  (io_out[19]),
        .spi_master_sdi0_i  (io_in[20]),
        .spi_master_sdi1_i  (io_in[21]),
        .spi_master_sdi2_i  (io_in[22]),
        .spi_master_sdi3_i  (io_in[23]),
        .scl_pad_i          (la_data_in[11]),
        .scl_pad_o          (),
        .scl_padoen_o       (),
        .sda_pad_i          (la_data_in[12]),
        .sda_pad_o          (),
        .sda_padoen_o       (),
        .uart_tx            (io_out[24]),
        .uart_rx            (io_in[25]),
        .uart_rts           (),
        .uart_dtr           (),
        .uart_cts           (1'b0),
        .uart_dsr           (1'b0),
        .gpio_in            (la_data_in[44:13]),
        .gpio_out           (la_data_out[76:45]),
        .gpio_dir           (la_data_out[108:77]),
        .gpio_padcfg        (),
        .tck_i              (io_in[26]),
        .trstn_i            (io_in[27]),
        .tms_i              (io_in[28]),
        .tdi_i              (io_in[29]),
        .tdo_o              (io_out[30]),
        .pad_cfg_o          (),
        .pad_mux_o          ()
    );    

endmodule