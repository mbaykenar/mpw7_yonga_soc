# Introduction

Yonga-MCU is a 32-bit RISCV-IMC instruction set compatible SoC design with peripherals like UART, SPI and I2C.

The design is based on famous pulp team's pulpino. We (Yongatek Microelectronics from Turkiye) try to tape-out this MCU to gain experience on openlane flow with MPW7 with minor modifications from the original pulpino work. You can get more information about pulp team and pulpino by clicking links below:

PULP Platform
https://pulp-platform.org/index.html

Pulpino SoC
https://github.com/pulp-platform/pulpino


Our main aim is to add our previous MPW submissions such as CAN, MODBUS and Ethernet to YONGA-MCU by modifying and enhancing it and tape-out in MPW8 our final MCU system.

## Details

PULP Platform's Pulpino SoC was coded with SystemVerilog. MPW submissions accept only Verilog due to restrictions in Yosys. We utilized sv2v to convert SystemVerilog files to Verilog. Straightforward conversion could not be achieved and some modifications are made.

For CPU core, we utilized PULP Platform's obsolote CPU core Zero-Riscy in Yonga-MCU. Zero-Riscy is a 2-stage pipelined RISC-V core able to execute IMC instruction set of RISC-V. We hardened CPU core to 1500x1800 um area. You can find implementation details about the CPU core by searching "mba_core_region" in this repo.

We instantiated 2, 2 KB OpenRAM macro blocks for instruction and data ram usage. The macros are default pre-compiled macros from sky130 library.

AXI bus is used for connecting CPU core to peripherals via an AXI to APB bridge and accessing on-chip memories. AXI interface is hardened as axi_node_intf_wrap to an area of 2400x600 um. The area is too big for its size actually but due to high I/O counts we needed to increase area to fit I/O placement. In next submission, we plan to decrease the area and I/O pin counts of this macro block.

Peripheral connection is handled with peripherals macro. It's size is 700x2200 um. Peripherals module is also bigger than expected due to huge I/O count like axi_node_intf_wrap. clk_rst_gen module of pulpino is taken into peripherals macro. First we tried to harden clk_rst_gen module but it was too small to be hardened and we got LVS problems. The soultion was taking it's functionality into another module.

Original SystemVerilog implementation of Yonga-MCU is verified through modelsim environment provided with pulpino repo. We converted SV files to Verilog through sv2v and reverified the MCU.

## GDSII Images
![alt text](https://github.com/mbaykenar/mpw7_yonga_soc/blob/main/images/axi_node_intf_wrap.PNG "axi_node_intf_wrap")