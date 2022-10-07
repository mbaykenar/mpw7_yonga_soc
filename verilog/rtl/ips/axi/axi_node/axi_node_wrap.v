`include "defines.v"

module axi_node_wrap 
#(

    parameter                   AXI_ADDRESS_W      = 32,
    parameter                   AXI_DATA_W         = 64,
    parameter                   AXI_NUMBYTES       = AXI_DATA_W/8,
    parameter                   AXI_USER_W         = 6,
`ifdef USE_CFG_BLOCK
  `ifdef USE_AXI_LITE
    parameter                   AXI_LITE_ADDRESS_W = 32,
    parameter                   AXI_LITE_DATA_W    = 32,
  `else
    parameter                   APB_ADDR_WIDTH     = 12,  //APB slaves are 4KB by default
    parameter                   APB_DATA_WIDTH     = 32,
  `endif
`endif
    parameter                   N_MASTER_PORT      = 8,
    parameter                   N_SLAVE_PORT       = 4,
    parameter                   AXI_ID_IN          = 10,
    parameter                   AXI_ID_OUT         = AXI_ID_IN + $clog2(N_SLAVE_PORT),
    parameter                   FIFO_DEPTH_DW      = 8,
    parameter                   N_REGION           = 2
)
(
	clk,
	rst_n,
	test_en_i,
	slave_00_aw_addr,
	slave_00_aw_prot,
	slave_00_aw_region,
	slave_00_aw_len,
	slave_00_aw_size,
	slave_00_aw_burst,
	slave_00_aw_lock,
	slave_00_aw_cache,
	slave_00_aw_qos,
	slave_00_aw_id,
	slave_00_aw_user,
	slave_00_aw_ready,
	slave_00_aw_valid,
	slave_00_ar_addr,
	slave_00_ar_prot,
	slave_00_ar_region,
	slave_00_ar_len,
	slave_00_ar_size,
	slave_00_ar_burst,
	slave_00_ar_lock,
	slave_00_ar_cache,
	slave_00_ar_qos,
	slave_00_ar_id,
	slave_00_ar_user,
	slave_00_ar_ready,
	slave_00_ar_valid,
	slave_00_w_valid,
	slave_00_w_data,
	slave_00_w_strb,
	slave_00_w_user,
	slave_00_w_last,
	slave_00_w_ready,
	slave_00_r_data,
	slave_00_r_resp,
	slave_00_r_last,
	slave_00_r_id,
	slave_00_r_user,
	slave_00_r_ready,
	slave_00_r_valid,
	slave_00_b_resp,
	slave_00_b_id,
	slave_00_b_user,
	slave_00_b_ready,
	slave_00_b_valid,
	slave_01_aw_addr,
	slave_01_aw_prot,
	slave_01_aw_region,
	slave_01_aw_len,
	slave_01_aw_size,
	slave_01_aw_burst,
	slave_01_aw_lock,
	slave_01_aw_cache,
	slave_01_aw_qos,
	slave_01_aw_id,
	slave_01_aw_user,
	slave_01_aw_ready,
	slave_01_aw_valid,
	slave_01_ar_addr,
	slave_01_ar_prot,
	slave_01_ar_region,
	slave_01_ar_len,
	slave_01_ar_size,
	slave_01_ar_burst,
	slave_01_ar_lock,
	slave_01_ar_cache,
	slave_01_ar_qos,
	slave_01_ar_id,
	slave_01_ar_user,
	slave_01_ar_ready,
	slave_01_ar_valid,
	slave_01_w_valid,
	slave_01_w_data,
	slave_01_w_strb,
	slave_01_w_user,
	slave_01_w_last,
	slave_01_w_ready,
	slave_01_r_data,
	slave_01_r_resp,
	slave_01_r_last,
	slave_01_r_id,
	slave_01_r_user,
	slave_01_r_ready,
	slave_01_r_valid,
	slave_01_b_resp,
	slave_01_b_id,
	slave_01_b_user,
	slave_01_b_ready,
	slave_01_b_valid,
	slave_02_aw_addr,
	slave_02_aw_prot,
	slave_02_aw_region,
	slave_02_aw_len,
	slave_02_aw_size,
	slave_02_aw_burst,
	slave_02_aw_lock,
	slave_02_aw_cache,
	slave_02_aw_qos,
	slave_02_aw_id,
	slave_02_aw_user,
	slave_02_aw_ready,
	slave_02_aw_valid,
	slave_02_ar_addr,
	slave_02_ar_prot,
	slave_02_ar_region,
	slave_02_ar_len,
	slave_02_ar_size,
	slave_02_ar_burst,
	slave_02_ar_lock,
	slave_02_ar_cache,
	slave_02_ar_qos,
	slave_02_ar_id,
	slave_02_ar_user,
	slave_02_ar_ready,
	slave_02_ar_valid,
	slave_02_w_valid,
	slave_02_w_data,
	slave_02_w_strb,
	slave_02_w_user,
	slave_02_w_last,
	slave_02_w_ready,
	slave_02_r_data,
	slave_02_r_resp,
	slave_02_r_last,
	slave_02_r_id,
	slave_02_r_user,
	slave_02_r_ready,
	slave_02_r_valid,
	slave_02_b_resp,
	slave_02_b_id,
	slave_02_b_user,
	slave_02_b_ready,
	slave_02_b_valid,
	master_00_aw_addr,
	master_00_aw_prot,
	master_00_aw_region,
	master_00_aw_len,
	master_00_aw_size,
	master_00_aw_burst,
	master_00_aw_lock,
	master_00_aw_cache,
	master_00_aw_qos,
	master_00_aw_id,
	master_00_aw_user,
	master_00_aw_ready,
	master_00_aw_valid,
	master_00_ar_addr,
	master_00_ar_prot,
	master_00_ar_region,
	master_00_ar_len,
	master_00_ar_size,
	master_00_ar_burst,
	master_00_ar_lock,
	master_00_ar_cache,
	master_00_ar_qos,
	master_00_ar_id,
	master_00_ar_user,
	master_00_ar_ready,
	master_00_ar_valid,
	master_00_w_valid,
	master_00_w_data,
	master_00_w_strb,
	master_00_w_user,
	master_00_w_last,
	master_00_w_ready,
	master_00_r_data,
	master_00_r_resp,
	master_00_r_last,
	master_00_r_id,
	master_00_r_user,
	master_00_r_ready,
	master_00_r_valid,
	master_00_b_resp,
	master_00_b_id,
	master_00_b_user,
	master_00_b_ready,
	master_00_b_valid,
	master_01_aw_addr,
	master_01_aw_prot,
	master_01_aw_region,
	master_01_aw_len,
	master_01_aw_size,
	master_01_aw_burst,
	master_01_aw_lock,
	master_01_aw_cache,
	master_01_aw_qos,
	master_01_aw_id,
	master_01_aw_user,
	master_01_aw_ready,
	master_01_aw_valid,
	master_01_ar_addr,
	master_01_ar_prot,
	master_01_ar_region,
	master_01_ar_len,
	master_01_ar_size,
	master_01_ar_burst,
	master_01_ar_lock,
	master_01_ar_cache,
	master_01_ar_qos,
	master_01_ar_id,
	master_01_ar_user,
	master_01_ar_ready,
	master_01_ar_valid,
	master_01_w_valid,
	master_01_w_data,
	master_01_w_strb,
	master_01_w_user,
	master_01_w_last,
	master_01_w_ready,
	master_01_r_data,
	master_01_r_resp,
	master_01_r_last,
	master_01_r_id,
	master_01_r_user,
	master_01_r_ready,
	master_01_r_valid,
	master_01_b_resp,
	master_01_b_id,
	master_01_b_user,
	master_01_b_ready,
	master_01_b_valid,
	master_02_aw_addr,
	master_02_aw_prot,
	master_02_aw_region,
	master_02_aw_len,
	master_02_aw_size,
	master_02_aw_burst,
	master_02_aw_lock,
	master_02_aw_cache,
	master_02_aw_qos,
	master_02_aw_id,
	master_02_aw_user,
	master_02_aw_ready,
	master_02_aw_valid,
	master_02_ar_addr,
	master_02_ar_prot,
	master_02_ar_region,
	master_02_ar_len,
	master_02_ar_size,
	master_02_ar_burst,
	master_02_ar_lock,
	master_02_ar_cache,
	master_02_ar_qos,
	master_02_ar_id,
	master_02_ar_user,
	master_02_ar_ready,
	master_02_ar_valid,
	master_02_w_valid,
	master_02_w_data,
	master_02_w_strb,
	master_02_w_user,
	master_02_w_last,
	master_02_w_ready,
	master_02_r_data,
	master_02_r_resp,
	master_02_r_last,
	master_02_r_id,
	master_02_r_user,
	master_02_r_ready,
	master_02_r_valid,
	master_02_b_resp,
	master_02_b_id,
	master_02_b_user,
	master_02_b_ready,
	master_02_b_valid,
	cfg_START_ADDR_i,
	cfg_END_ADDR_i,
	cfg_valid_rule_i,
	cfg_connectivity_map_i
);
	//parameter AXI_ADDRESS_W = 32;
	//parameter AXI_ADDR_WIDTH = 32;
	//parameter AXI_DATA_W = 64;
	//parameter AXI_NUMBYTES = AXI_DATA_W / 8;
	//parameter AXI_USER_W = 6;
	//parameter N_MASTER_PORT = 8;
	//parameter N_SLAVE_PORT = 4;
	//parameter AXI_ID_IN = 10;
	//parameter AXI_ID_OUT = AXI_ID_IN + $clog2(N_SLAVE_PORT);
	//parameter FIFO_DEPTH_DW = 8;
	//parameter N_REGION = 2;
	parameter AXI_ADDR_WIDTH = AXI_ADDRESS_W;
    parameter AXI_DATA_WIDTH = AXI_DATA_W;
    parameter AXI_ID_WIDTH   = 10;
    parameter AXI_USER_WIDTH = 6;
    parameter AXI_STRB_WIDTH = AXI_DATA_WIDTH/8;
	input wire clk;
	input wire rst_n;
	input wire test_en_i;
	input wire [AXI_ADDR_WIDTH - 1:0] slave_00_aw_addr;
	input wire [2:0] slave_00_aw_prot;
	input wire [3:0] slave_00_aw_region;
	input wire [7:0] slave_00_aw_len;
	input wire [2:0] slave_00_aw_size;
	input wire [1:0] slave_00_aw_burst;
	input wire slave_00_aw_lock;
	input wire [3:0] slave_00_aw_cache;
	input wire [3:0] slave_00_aw_qos;
	input wire [AXI_ID_WIDTH - 1:0] slave_00_aw_id;
	input wire [AXI_USER_WIDTH - 1:0] slave_00_aw_user;
	output wire slave_00_aw_ready;
	input wire slave_00_aw_valid;
	input wire [AXI_ADDR_WIDTH - 1:0] slave_00_ar_addr;
	input wire [2:0] slave_00_ar_prot;
	input wire [3:0] slave_00_ar_region;
	input wire [7:0] slave_00_ar_len;
	input wire [2:0] slave_00_ar_size;
	input wire [1:0] slave_00_ar_burst;
	input wire slave_00_ar_lock;
	input wire [3:0] slave_00_ar_cache;
	input wire [3:0] slave_00_ar_qos;
	input wire [AXI_ID_WIDTH - 1:0] slave_00_ar_id;
	input wire [AXI_USER_WIDTH - 1:0] slave_00_ar_user;
	output wire slave_00_ar_ready;
	input wire slave_00_ar_valid;
	input wire slave_00_w_valid;
	input wire [AXI_DATA_WIDTH - 1:0] slave_00_w_data;
	input wire [AXI_STRB_WIDTH - 1:0] slave_00_w_strb;
	input wire [AXI_USER_WIDTH - 1:0] slave_00_w_user;
	input wire slave_00_w_last;
	output wire slave_00_w_ready;
	output wire [AXI_DATA_WIDTH - 1:0] slave_00_r_data;
	output wire [1:0] slave_00_r_resp;
	output wire slave_00_r_last;
	output wire [AXI_ID_WIDTH - 1:0] slave_00_r_id;
	output wire [AXI_USER_WIDTH - 1:0] slave_00_r_user;
	input wire slave_00_r_ready;
	output wire slave_00_r_valid;
	output wire [1:0] slave_00_b_resp;
	output wire [AXI_ID_WIDTH - 1:0] slave_00_b_id;
	output wire [AXI_USER_WIDTH - 1:0] slave_00_b_user;
	input wire slave_00_b_ready;
	output wire slave_00_b_valid;
	input wire [AXI_ADDR_WIDTH - 1:0] slave_01_aw_addr;
	input wire [2:0] slave_01_aw_prot;
	input wire [3:0] slave_01_aw_region;
	input wire [7:0] slave_01_aw_len;
	input wire [2:0] slave_01_aw_size;
	input wire [1:0] slave_01_aw_burst;
	input wire slave_01_aw_lock;
	input wire [3:0] slave_01_aw_cache;
	input wire [3:0] slave_01_aw_qos;
	input wire [AXI_ID_WIDTH - 1:0] slave_01_aw_id;
	input wire [AXI_USER_WIDTH - 1:0] slave_01_aw_user;
	output wire slave_01_aw_ready;
	input wire slave_01_aw_valid;
	input wire [AXI_ADDR_WIDTH - 1:0] slave_01_ar_addr;
	input wire [2:0] slave_01_ar_prot;
	input wire [3:0] slave_01_ar_region;
	input wire [7:0] slave_01_ar_len;
	input wire [2:0] slave_01_ar_size;
	input wire [1:0] slave_01_ar_burst;
	input wire slave_01_ar_lock;
	input wire [3:0] slave_01_ar_cache;
	input wire [3:0] slave_01_ar_qos;
	input wire [AXI_ID_WIDTH - 1:0] slave_01_ar_id;
	input wire [AXI_USER_WIDTH - 1:0] slave_01_ar_user;
	output wire slave_01_ar_ready;
	input wire slave_01_ar_valid;
	input wire slave_01_w_valid;
	input wire [AXI_DATA_WIDTH - 1:0] slave_01_w_data;
	input wire [AXI_STRB_WIDTH - 1:0] slave_01_w_strb;
	input wire [AXI_USER_WIDTH - 1:0] slave_01_w_user;
	input wire slave_01_w_last;
	output wire slave_01_w_ready;
	output wire [AXI_DATA_WIDTH - 1:0] slave_01_r_data;
	output wire [1:0] slave_01_r_resp;
	output wire slave_01_r_last;
	output wire [AXI_ID_WIDTH - 1:0] slave_01_r_id;
	output wire [AXI_USER_WIDTH - 1:0] slave_01_r_user;
	input wire slave_01_r_ready;
	output wire slave_01_r_valid;
	output wire [1:0] slave_01_b_resp;
	output wire [AXI_ID_WIDTH - 1:0] slave_01_b_id;
	output wire [AXI_USER_WIDTH - 1:0] slave_01_b_user;
	input wire slave_01_b_ready;
	output wire slave_01_b_valid;
	input wire [AXI_ADDR_WIDTH - 1:0] slave_02_aw_addr;
	input wire [2:0] slave_02_aw_prot;
	input wire [3:0] slave_02_aw_region;
	input wire [7:0] slave_02_aw_len;
	input wire [2:0] slave_02_aw_size;
	input wire [1:0] slave_02_aw_burst;
	input wire slave_02_aw_lock;
	input wire [3:0] slave_02_aw_cache;
	input wire [3:0] slave_02_aw_qos;
	input wire [AXI_ID_WIDTH - 1:0] slave_02_aw_id;
	input wire [AXI_USER_WIDTH - 1:0] slave_02_aw_user;
	output wire slave_02_aw_ready;
	input wire slave_02_aw_valid;
	input wire [AXI_ADDR_WIDTH - 1:0] slave_02_ar_addr;
	input wire [2:0] slave_02_ar_prot;
	input wire [3:0] slave_02_ar_region;
	input wire [7:0] slave_02_ar_len;
	input wire [2:0] slave_02_ar_size;
	input wire [1:0] slave_02_ar_burst;
	input wire slave_02_ar_lock;
	input wire [3:0] slave_02_ar_cache;
	input wire [3:0] slave_02_ar_qos;
	input wire [AXI_ID_WIDTH - 1:0] slave_02_ar_id;
	input wire [AXI_USER_WIDTH - 1:0] slave_02_ar_user;
	output wire slave_02_ar_ready;
	input wire slave_02_ar_valid;
	input wire slave_02_w_valid;
	input wire [AXI_DATA_WIDTH - 1:0] slave_02_w_data;
	input wire [AXI_STRB_WIDTH - 1:0] slave_02_w_strb;
	input wire [AXI_USER_WIDTH - 1:0] slave_02_w_user;
	input wire slave_02_w_last;
	output wire slave_02_w_ready;
	output wire [AXI_DATA_WIDTH - 1:0] slave_02_r_data;
	output wire [1:0] slave_02_r_resp;
	output wire slave_02_r_last;
	output wire [AXI_ID_WIDTH - 1:0] slave_02_r_id;
	output wire [AXI_USER_WIDTH - 1:0] slave_02_r_user;
	input wire slave_02_r_ready;
	output wire slave_02_r_valid;
	output wire [1:0] slave_02_b_resp;
	output wire [AXI_ID_WIDTH - 1:0] slave_02_b_id;
	output wire [AXI_USER_WIDTH - 1:0] slave_02_b_user;
	input wire slave_02_b_ready;
	output wire slave_02_b_valid;
	output wire [AXI_ADDR_WIDTH - 1:0] master_00_aw_addr;
	output wire [2:0] master_00_aw_prot;
	output wire [3:0] master_00_aw_region;
	output wire [7:0] master_00_aw_len;
	output wire [2:0] master_00_aw_size;
	output wire [1:0] master_00_aw_burst;
	output wire master_00_aw_lock;
	output wire [3:0] master_00_aw_cache;
	output wire [3:0] master_00_aw_qos;
	output wire [AXI_ID_WIDTH - 1:0] master_00_aw_id;
	output wire [AXI_USER_WIDTH - 1:0] master_00_aw_user;
	input wire master_00_aw_ready;
	output wire master_00_aw_valid;
	output wire [AXI_ADDR_WIDTH - 1:0] master_00_ar_addr;
	output wire [2:0] master_00_ar_prot;
	output wire [3:0] master_00_ar_region;
	output wire [7:0] master_00_ar_len;
	output wire [2:0] master_00_ar_size;
	output wire [1:0] master_00_ar_burst;
	output wire master_00_ar_lock;
	output wire [3:0] master_00_ar_cache;
	output wire [3:0] master_00_ar_qos;
	output wire [AXI_ID_WIDTH - 1:0] master_00_ar_id;
	output wire [AXI_USER_WIDTH - 1:0] master_00_ar_user;
	input wire master_00_ar_ready;
	output wire master_00_ar_valid;
	output wire master_00_w_valid;
	output wire [AXI_DATA_WIDTH - 1:0] master_00_w_data;
	output wire [AXI_STRB_WIDTH - 1:0] master_00_w_strb;
	output wire [AXI_USER_WIDTH - 1:0] master_00_w_user;
	output wire master_00_w_last;
	input wire master_00_w_ready;
	input wire [AXI_DATA_WIDTH - 1:0] master_00_r_data;
	input wire [1:0] master_00_r_resp;
	input wire master_00_r_last;
	input wire [AXI_ID_WIDTH - 1:0] master_00_r_id;
	input wire [AXI_USER_WIDTH - 1:0] master_00_r_user;
	output wire master_00_r_ready;
	input wire master_00_r_valid;
	input wire [1:0] master_00_b_resp;
	input wire [AXI_ID_WIDTH - 1:0] master_00_b_id;
	input wire [AXI_USER_WIDTH - 1:0] master_00_b_user;
	output wire master_00_b_ready;
	input wire master_00_b_valid;
	output wire [AXI_ADDR_WIDTH - 1:0] master_01_aw_addr;
	output wire [2:0] master_01_aw_prot;
	output wire [3:0] master_01_aw_region;
	output wire [7:0] master_01_aw_len;
	output wire [2:0] master_01_aw_size;
	output wire [1:0] master_01_aw_burst;
	output wire master_01_aw_lock;
	output wire [3:0] master_01_aw_cache;
	output wire [3:0] master_01_aw_qos;
	output wire [AXI_ID_WIDTH - 1:0] master_01_aw_id;
	output wire [AXI_USER_WIDTH - 1:0] master_01_aw_user;
	input wire master_01_aw_ready;
	output wire master_01_aw_valid;
	output wire [AXI_ADDR_WIDTH - 1:0] master_01_ar_addr;
	output wire [2:0] master_01_ar_prot;
	output wire [3:0] master_01_ar_region;
	output wire [7:0] master_01_ar_len;
	output wire [2:0] master_01_ar_size;
	output wire [1:0] master_01_ar_burst;
	output wire master_01_ar_lock;
	output wire [3:0] master_01_ar_cache;
	output wire [3:0] master_01_ar_qos;
	output wire [AXI_ID_WIDTH - 1:0] master_01_ar_id;
	output wire [AXI_USER_WIDTH - 1:0] master_01_ar_user;
	input wire master_01_ar_ready;
	output wire master_01_ar_valid;
	output wire master_01_w_valid;
	output wire [AXI_DATA_WIDTH - 1:0] master_01_w_data;
	output wire [AXI_STRB_WIDTH - 1:0] master_01_w_strb;
	output wire [AXI_USER_WIDTH - 1:0] master_01_w_user;
	output wire master_01_w_last;
	input wire master_01_w_ready;
	input wire [AXI_DATA_WIDTH - 1:0] master_01_r_data;
	input wire [1:0] master_01_r_resp;
	input wire master_01_r_last;
	input wire [AXI_ID_WIDTH - 1:0] master_01_r_id;
	input wire [AXI_USER_WIDTH - 1:0] master_01_r_user;
	output wire master_01_r_ready;
	input wire master_01_r_valid;
	input wire [1:0] master_01_b_resp;
	input wire [AXI_ID_WIDTH - 1:0] master_01_b_id;
	input wire [AXI_USER_WIDTH - 1:0] master_01_b_user;
	output wire master_01_b_ready;
	input wire master_01_b_valid;
	output wire [AXI_ADDR_WIDTH - 1:0] master_02_aw_addr;
	output wire [2:0] master_02_aw_prot;
	output wire [3:0] master_02_aw_region;
	output wire [7:0] master_02_aw_len;
	output wire [2:0] master_02_aw_size;
	output wire [1:0] master_02_aw_burst;
	output wire master_02_aw_lock;
	output wire [3:0] master_02_aw_cache;
	output wire [3:0] master_02_aw_qos;
	output wire [AXI_ID_WIDTH - 1:0] master_02_aw_id;
	output wire [AXI_USER_WIDTH - 1:0] master_02_aw_user;
	input wire master_02_aw_ready;
	output wire master_02_aw_valid;
	output wire [AXI_ADDR_WIDTH - 1:0] master_02_ar_addr;
	output wire [2:0] master_02_ar_prot;
	output wire [3:0] master_02_ar_region;
	output wire [7:0] master_02_ar_len;
	output wire [2:0] master_02_ar_size;
	output wire [1:0] master_02_ar_burst;
	output wire master_02_ar_lock;
	output wire [3:0] master_02_ar_cache;
	output wire [3:0] master_02_ar_qos;
	output wire [AXI_ID_WIDTH - 1:0] master_02_ar_id;
	output wire [AXI_USER_WIDTH - 1:0] master_02_ar_user;
	input wire master_02_ar_ready;
	output wire master_02_ar_valid;
	output wire master_02_w_valid;
	output wire [AXI_DATA_WIDTH - 1:0] master_02_w_data;
	output wire [AXI_STRB_WIDTH - 1:0] master_02_w_strb;
	output wire [AXI_USER_WIDTH - 1:0] master_02_w_user;
	output wire master_02_w_last;
	input wire master_02_w_ready;
	input wire [AXI_DATA_WIDTH - 1:0] master_02_r_data;
	input wire [1:0] master_02_r_resp;
	input wire master_02_r_last;
	input wire [AXI_ID_WIDTH - 1:0] master_02_r_id;
	input wire [AXI_USER_WIDTH - 1:0] master_02_r_user;
	output wire master_02_r_ready;
	input wire master_02_r_valid;
	input wire [1:0] master_02_b_resp;
	input wire [AXI_ID_WIDTH - 1:0] master_02_b_id;
	input wire [AXI_USER_WIDTH - 1:0] master_02_b_user;
	output wire master_02_b_ready;
	input wire master_02_b_valid;
	input wire [((N_REGION * N_MASTER_PORT) * 32) - 1:0] cfg_START_ADDR_i;
	input wire [((N_REGION * N_MASTER_PORT) * 32) - 1:0] cfg_END_ADDR_i;
	input wire [(N_REGION * N_MASTER_PORT) - 1:0] cfg_valid_rule_i;
	input wire [(N_SLAVE_PORT * N_MASTER_PORT) - 1:0] cfg_connectivity_map_i;
	wire [(N_SLAVE_PORT * AXI_ID_IN) - 1:0] slave_awid;
	wire [(N_SLAVE_PORT * AXI_ADDRESS_W) - 1:0] slave_awaddr;
	wire [(N_SLAVE_PORT * 8) - 1:0] slave_awlen;
	wire [(N_SLAVE_PORT * 3) - 1:0] slave_awsize;
	wire [(N_SLAVE_PORT * 2) - 1:0] slave_awburst;
	wire [N_SLAVE_PORT - 1:0] slave_awlock;
	wire [(N_SLAVE_PORT * 4) - 1:0] slave_awcache;
	wire [(N_SLAVE_PORT * 3) - 1:0] slave_awprot;
	wire [(N_SLAVE_PORT * 4) - 1:0] slave_awregion;
	wire [(N_SLAVE_PORT * AXI_USER_W) - 1:0] slave_awuser;
	wire [(N_SLAVE_PORT * 4) - 1:0] slave_awqos;
	wire [N_SLAVE_PORT - 1:0] slave_awvalid;
	wire [N_SLAVE_PORT - 1:0] slave_awready;
	wire [(N_SLAVE_PORT * AXI_DATA_W) - 1:0] slave_wdata;
	wire [(N_SLAVE_PORT * AXI_NUMBYTES) - 1:0] slave_wstrb;
	wire [N_SLAVE_PORT - 1:0] slave_wlast;
	wire [(N_SLAVE_PORT * AXI_USER_W) - 1:0] slave_wuser;
	wire [N_SLAVE_PORT - 1:0] slave_wvalid;
	wire [N_SLAVE_PORT - 1:0] slave_wready;
	wire [(N_SLAVE_PORT * AXI_ID_IN) - 1:0] slave_bid;
	wire [(N_SLAVE_PORT * 2) - 1:0] slave_bresp;
	wire [N_SLAVE_PORT - 1:0] slave_bvalid;
	wire [(N_SLAVE_PORT * AXI_USER_W) - 1:0] slave_buser;
	wire [N_SLAVE_PORT - 1:0] slave_bready;
	wire [(N_SLAVE_PORT * AXI_ID_IN) - 1:0] slave_arid;
	wire [(N_SLAVE_PORT * AXI_ADDRESS_W) - 1:0] slave_araddr;
	wire [(N_SLAVE_PORT * 8) - 1:0] slave_arlen;
	wire [(N_SLAVE_PORT * 3) - 1:0] slave_arsize;
	wire [(N_SLAVE_PORT * 2) - 1:0] slave_arburst;
	wire [N_SLAVE_PORT - 1:0] slave_arlock;
	wire [(N_SLAVE_PORT * 4) - 1:0] slave_arcache;
	wire [(N_SLAVE_PORT * 3) - 1:0] slave_arprot;
	wire [(N_SLAVE_PORT * 4) - 1:0] slave_arregion;
	wire [(N_SLAVE_PORT * AXI_USER_W) - 1:0] slave_aruser;
	wire [(N_SLAVE_PORT * 4) - 1:0] slave_arqos;
	wire [N_SLAVE_PORT - 1:0] slave_arvalid;
	wire [N_SLAVE_PORT - 1:0] slave_arready;
	wire [(N_SLAVE_PORT * AXI_ID_IN) - 1:0] slave_rid;
	wire [(N_SLAVE_PORT * AXI_DATA_W) - 1:0] slave_rdata;
	wire [(N_SLAVE_PORT * 2) - 1:0] slave_rresp;
	wire [N_SLAVE_PORT - 1:0] slave_rlast;
	wire [(N_SLAVE_PORT * AXI_USER_W) - 1:0] slave_ruser;
	wire [N_SLAVE_PORT - 1:0] slave_rvalid;
	wire [N_SLAVE_PORT - 1:0] slave_rready;
	wire [(N_MASTER_PORT * AXI_ID_OUT) - 1:0] master_awid;
	wire [(N_MASTER_PORT * AXI_ADDRESS_W) - 1:0] master_awaddr;
	wire [(N_MASTER_PORT * 8) - 1:0] master_awlen;
	wire [(N_MASTER_PORT * 3) - 1:0] master_awsize;
	wire [(N_MASTER_PORT * 2) - 1:0] master_awburst;
	wire [N_MASTER_PORT - 1:0] master_awlock;
	wire [(N_MASTER_PORT * 4) - 1:0] master_awcache;
	wire [(N_MASTER_PORT * 3) - 1:0] master_awprot;
	wire [(N_MASTER_PORT * 4) - 1:0] master_awregion;
	wire [(N_MASTER_PORT * AXI_USER_W) - 1:0] master_awuser;
	wire [(N_MASTER_PORT * 4) - 1:0] master_awqos;
	wire [N_MASTER_PORT - 1:0] master_awvalid;
	wire [N_MASTER_PORT - 1:0] master_awready;
	wire [(N_MASTER_PORT * AXI_DATA_W) - 1:0] master_wdata;
	wire [(N_MASTER_PORT * AXI_NUMBYTES) - 1:0] master_wstrb;
	wire [N_MASTER_PORT - 1:0] master_wlast;
	wire [(N_MASTER_PORT * AXI_USER_W) - 1:0] master_wuser;
	wire [N_MASTER_PORT - 1:0] master_wvalid;
	wire [N_MASTER_PORT - 1:0] master_wready;
	wire [(N_MASTER_PORT * AXI_ID_OUT) - 1:0] master_bid;
	wire [(N_MASTER_PORT * 2) - 1:0] master_bresp;
	wire [(N_MASTER_PORT * AXI_USER_W) - 1:0] master_buser;
	wire [N_MASTER_PORT - 1:0] master_bvalid;
	wire [N_MASTER_PORT - 1:0] master_bready;
	wire [(N_MASTER_PORT * AXI_ID_OUT) - 1:0] master_arid;
	wire [(N_MASTER_PORT * AXI_ADDRESS_W) - 1:0] master_araddr;
	wire [(N_MASTER_PORT * 8) - 1:0] master_arlen;
	wire [(N_MASTER_PORT * 3) - 1:0] master_arsize;
	wire [(N_MASTER_PORT * 2) - 1:0] master_arburst;
	wire [N_MASTER_PORT - 1:0] master_arlock;
	wire [(N_MASTER_PORT * 4) - 1:0] master_arcache;
	wire [(N_MASTER_PORT * 3) - 1:0] master_arprot;
	wire [(N_MASTER_PORT * 4) - 1:0] master_arregion;
	wire [(N_MASTER_PORT * AXI_USER_W) - 1:0] master_aruser;
	wire [(N_MASTER_PORT * 4) - 1:0] master_arqos;
	wire [N_MASTER_PORT - 1:0] master_arvalid;
	wire [N_MASTER_PORT - 1:0] master_arready;
	wire [(N_MASTER_PORT * AXI_ID_OUT) - 1:0] master_rid;
	wire [(N_MASTER_PORT * AXI_DATA_W) - 1:0] master_rdata;
	wire [(N_MASTER_PORT * 2) - 1:0] master_rresp;
	wire [N_MASTER_PORT - 1:0] master_rlast;
	wire [(N_MASTER_PORT * AXI_USER_W) - 1:0] master_ruser;
	wire [N_MASTER_PORT - 1:0] master_rvalid;
	wire [N_MASTER_PORT - 1:0] master_rready;
	genvar i;
	assign slave_awaddr[0+:AXI_ADDRESS_W] = slave_00_aw_addr;
	assign slave_awprot[0+:3] = slave_00_aw_prot;
	assign slave_awregion[0+:4] = slave_00_aw_region;
	assign slave_awlen[0+:8] = slave_00_aw_len;
	assign slave_awsize[0+:3] = slave_00_aw_size;
	assign slave_awburst[0+:2] = slave_00_aw_burst;
	assign slave_awlock[0] = slave_00_aw_lock;
	assign slave_awcache[0+:4] = slave_00_aw_cache;
	assign slave_awqos[0+:4] = slave_00_aw_qos;
	assign slave_awid[0+:AXI_ID_IN] = slave_00_aw_id[AXI_ID_IN - 1:0];
	assign slave_awuser[0+:AXI_USER_W] = slave_00_aw_user;
	assign slave_awvalid[0] = slave_00_aw_valid;
	assign slave_00_aw_ready = slave_awready[0];
	assign slave_araddr[0+:AXI_ADDRESS_W] = slave_00_ar_addr;
	assign slave_arprot[0+:3] = slave_00_ar_prot;
	assign slave_arregion[0+:4] = slave_00_ar_region;
	assign slave_arlen[0+:8] = slave_00_ar_len;
	assign slave_arsize[0+:3] = slave_00_ar_size;
	assign slave_arburst[0+:2] = slave_00_ar_burst;
	assign slave_arlock[0] = slave_00_ar_lock;
	assign slave_arcache[0+:4] = slave_00_ar_cache;
	assign slave_arqos[0+:4] = slave_00_ar_qos;
	assign slave_arid[0+:AXI_ID_IN] = slave_00_ar_id[AXI_ID_IN - 1:0];
	assign slave_aruser[0+:AXI_USER_W] = slave_00_ar_user;
	assign slave_arvalid[0] = slave_00_ar_valid;
	assign slave_00_ar_ready = slave_arready[0];
	assign slave_wvalid[0] = slave_00_w_valid;
	assign slave_wdata[0+:AXI_DATA_W] = slave_00_w_data;
	assign slave_wstrb[0+:AXI_NUMBYTES] = slave_00_w_strb;
	assign slave_wuser[0+:AXI_USER_W] = slave_00_w_user;
	assign slave_wlast[0] = slave_00_w_last;
	assign slave_00_w_ready = slave_wready[0];
	assign slave_00_b_id[AXI_ID_IN - 1:0] = slave_bid[0+:AXI_ID_IN];
	assign slave_00_b_resp = slave_bresp[0+:2];
	assign slave_00_b_valid = slave_bvalid[0];
	assign slave_00_b_user = slave_buser[0+:AXI_USER_W];
	assign slave_bready[0] = slave_00_b_ready;
	assign slave_00_r_data = slave_rdata[0+:AXI_DATA_W];
	assign slave_00_r_resp = slave_rresp[0+:2];
	assign slave_00_r_last = slave_rlast[0];
	assign slave_00_r_id[AXI_ID_IN - 1:0] = slave_rid[0+:AXI_ID_IN];
	assign slave_00_r_user = slave_ruser[0+:AXI_USER_W];
	assign slave_00_r_valid = slave_rvalid[0];
	assign slave_rready[0] = slave_00_r_ready;
	assign slave_awaddr[AXI_ADDRESS_W+:AXI_ADDRESS_W] = slave_01_aw_addr;
	assign slave_awprot[3+:3] = slave_01_aw_prot;
	assign slave_awregion[4+:4] = slave_01_aw_region;
	assign slave_awlen[8+:8] = slave_01_aw_len;
	assign slave_awsize[3+:3] = slave_01_aw_size;
	assign slave_awburst[2+:2] = slave_01_aw_burst;
	assign slave_awlock[1] = slave_01_aw_lock;
	assign slave_awcache[4+:4] = slave_01_aw_cache;
	assign slave_awqos[4+:4] = slave_01_aw_qos;
	assign slave_awid[AXI_ID_IN+:AXI_ID_IN] = slave_01_aw_id[AXI_ID_IN - 1:0];
	assign slave_awuser[AXI_USER_W+:AXI_USER_W] = slave_01_aw_user;
	assign slave_awvalid[1] = slave_01_aw_valid;
	assign slave_01_aw_ready = slave_awready[1];
	assign slave_araddr[AXI_ADDRESS_W+:AXI_ADDRESS_W] = slave_01_ar_addr;
	assign slave_arprot[3+:3] = slave_01_ar_prot;
	assign slave_arregion[4+:4] = slave_01_ar_region;
	assign slave_arlen[8+:8] = slave_01_ar_len;
	assign slave_arsize[3+:3] = slave_01_ar_size;
	assign slave_arburst[2+:2] = slave_01_ar_burst;
	assign slave_arlock[1] = slave_01_ar_lock;
	assign slave_arcache[4+:4] = slave_01_ar_cache;
	assign slave_arqos[4+:4] = slave_01_ar_qos;
	assign slave_arid[AXI_ID_IN+:AXI_ID_IN] = slave_01_ar_id[AXI_ID_IN - 1:0];
	assign slave_aruser[AXI_USER_W+:AXI_USER_W] = slave_01_ar_user;
	assign slave_arvalid[1] = slave_01_ar_valid;
	assign slave_01_ar_ready = slave_arready[1];
	assign slave_wvalid[1] = slave_01_w_valid;
	assign slave_wdata[AXI_DATA_W+:AXI_DATA_W] = slave_01_w_data;
	assign slave_wstrb[AXI_NUMBYTES+:AXI_NUMBYTES] = slave_01_w_strb;
	assign slave_wuser[AXI_USER_W+:AXI_USER_W] = slave_01_w_user;
	assign slave_wlast[1] = slave_01_w_last;
	assign slave_01_w_ready = slave_wready[1];
	assign slave_01_b_id[AXI_ID_IN - 1:0] = slave_bid[AXI_ID_IN+:AXI_ID_IN];
	assign slave_01_b_resp = slave_bresp[2+:2];
	assign slave_01_b_valid = slave_bvalid[1];
	assign slave_01_b_user = slave_buser[AXI_USER_W+:AXI_USER_W];
	assign slave_bready[1] = slave_01_b_ready;
	assign slave_01_r_data = slave_rdata[AXI_DATA_W+:AXI_DATA_W];
	assign slave_01_r_resp = slave_rresp[2+:2];
	assign slave_01_r_last = slave_rlast[1];
	assign slave_01_r_id[AXI_ID_IN - 1:0] = slave_rid[AXI_ID_IN+:AXI_ID_IN];
	assign slave_01_r_user = slave_ruser[AXI_USER_W+:AXI_USER_W];
	assign slave_01_r_valid = slave_rvalid[1];
	assign slave_rready[1] = slave_01_r_ready;
	assign slave_awaddr[2 * AXI_ADDRESS_W+:AXI_ADDRESS_W] = slave_02_aw_addr;
	assign slave_awprot[6+:3] = slave_02_aw_prot;
	assign slave_awregion[8+:4] = slave_02_aw_region;
	assign slave_awlen[16+:8] = slave_02_aw_len;
	assign slave_awsize[6+:3] = slave_02_aw_size;
	assign slave_awburst[4+:2] = slave_02_aw_burst;
	assign slave_awlock[2] = slave_02_aw_lock;
	assign slave_awcache[8+:4] = slave_02_aw_cache;
	assign slave_awqos[8+:4] = slave_02_aw_qos;
	assign slave_awid[2 * AXI_ID_IN+:AXI_ID_IN] = slave_02_aw_id[AXI_ID_IN - 1:0];
	assign slave_awuser[2 * AXI_USER_W+:AXI_USER_W] = slave_02_aw_user;
	assign slave_awvalid[2] = slave_02_aw_valid;
	assign slave_02_aw_ready = slave_awready[2];
	assign slave_araddr[2 * AXI_ADDRESS_W+:AXI_ADDRESS_W] = slave_02_ar_addr;
	assign slave_arprot[6+:3] = slave_02_ar_prot;
	assign slave_arregion[8+:4] = slave_02_ar_region;
	assign slave_arlen[16+:8] = slave_02_ar_len;
	assign slave_arsize[6+:3] = slave_02_ar_size;
	assign slave_arburst[4+:2] = slave_02_ar_burst;
	assign slave_arlock[2] = slave_02_ar_lock;
	assign slave_arcache[8+:4] = slave_02_ar_cache;
	assign slave_arqos[8+:4] = slave_02_ar_qos;
	assign slave_arid[2 * AXI_ID_IN+:AXI_ID_IN] = slave_02_ar_id[AXI_ID_IN - 1:0];
	assign slave_aruser[2 * AXI_USER_W+:AXI_USER_W] = slave_02_ar_user;
	assign slave_arvalid[2] = slave_02_ar_valid;
	assign slave_02_ar_ready = slave_arready[2];
	assign slave_wvalid[2] = slave_02_w_valid;
	assign slave_wdata[2 * AXI_DATA_W+:AXI_DATA_W] = slave_02_w_data;
	assign slave_wstrb[2 * AXI_NUMBYTES+:AXI_NUMBYTES] = slave_02_w_strb;
	assign slave_wuser[2 * AXI_USER_W+:AXI_USER_W] = slave_02_w_user;
	assign slave_wlast[2] = slave_02_w_last;
	assign slave_02_w_ready = slave_wready[2];
	assign slave_02_b_id[AXI_ID_IN - 1:0] = slave_bid[2 * AXI_ID_IN+:AXI_ID_IN];
	assign slave_02_b_resp = slave_bresp[4+:2];
	assign slave_02_b_valid = slave_bvalid[2];
	assign slave_02_b_user = slave_buser[2 * AXI_USER_W+:AXI_USER_W];
	assign slave_bready[2] = slave_02_b_ready;
	assign slave_02_r_data = slave_rdata[2 * AXI_DATA_W+:AXI_DATA_W];
	assign slave_02_r_resp = slave_rresp[4+:2];
	assign slave_02_r_last = slave_rlast[2];
	assign slave_02_r_id[AXI_ID_IN - 1:0] = slave_rid[2 * AXI_ID_IN+:AXI_ID_IN];
	assign slave_02_r_user = slave_ruser[2 * AXI_USER_W+:AXI_USER_W];
	assign slave_02_r_valid = slave_rvalid[2];
	assign slave_rready[2] = slave_02_r_ready;
	assign master_00_aw_addr = master_awaddr[0+:AXI_ADDRESS_W];
	assign master_00_aw_prot = master_awprot[0+:3];
	assign master_00_aw_region = master_awregion[0+:4];
	assign master_00_aw_len = master_awlen[0+:8];
	assign master_00_aw_size = master_awsize[0+:3];
	assign master_00_aw_burst = master_awburst[0+:2];
	assign master_00_aw_lock = master_awlock[0];
	assign master_00_aw_cache = master_awcache[0+:4];
	assign master_00_aw_qos = master_awqos[0+:4];
	assign master_00_aw_id[AXI_ID_OUT - 1:0] = master_awid[0+:AXI_ID_OUT];
	assign master_00_aw_user = master_awuser[0+:AXI_USER_W];
	assign master_00_aw_valid = master_awvalid[0];
	assign master_awready[0] = master_00_aw_ready;
	assign master_00_ar_addr = master_araddr[0+:AXI_ADDRESS_W];
	assign master_00_ar_prot = master_arprot[0+:3];
	assign master_00_ar_region = master_arregion[0+:4];
	assign master_00_ar_len = master_arlen[0+:8];
	assign master_00_ar_size = master_arsize[0+:3];
	assign master_00_ar_burst = master_arburst[0+:2];
	assign master_00_ar_lock = master_arlock[0];
	assign master_00_ar_cache = master_arcache[0+:4];
	assign master_00_ar_qos = master_arqos[0+:4];
	assign master_00_ar_id[AXI_ID_OUT - 1:0] = master_arid[0+:AXI_ID_OUT];
	assign master_00_ar_user = master_aruser[0+:AXI_USER_W];
	assign master_00_ar_valid = master_arvalid[0];
	assign master_arready[0] = master_00_ar_ready;
	assign master_00_w_valid = master_wvalid[0];
	assign master_00_w_data = master_wdata[0+:AXI_DATA_W];
	assign master_00_w_strb = master_wstrb[0+:AXI_NUMBYTES];
	assign master_00_w_user = master_wuser[0+:AXI_USER_W];
	assign master_00_w_last = master_wlast[0];
	assign master_wready[0] = master_00_w_ready;
	assign master_bid[0+:AXI_ID_OUT] = master_00_b_id[AXI_ID_OUT - 1:0];
	assign master_bresp[0+:2] = master_00_b_resp;
	assign master_bvalid[0] = master_00_b_valid;
	assign master_buser[0+:AXI_USER_W] = master_00_b_user;
	assign master_00_b_ready = master_bready[0];
	assign master_rdata[0+:AXI_DATA_W] = master_00_r_data;
	assign master_rresp[0+:2] = master_00_r_resp;
	assign master_rlast[0] = master_00_r_last;
	assign master_rid[0+:AXI_ID_OUT] = master_00_r_id[AXI_ID_OUT - 1:0];
	assign master_ruser[0+:AXI_USER_W] = master_00_r_user;
	assign master_rvalid[0] = master_00_r_valid;
	assign master_00_r_ready = master_rready[0];
	assign master_01_aw_addr = master_awaddr[AXI_ADDRESS_W+:AXI_ADDRESS_W];
	assign master_01_aw_prot = master_awprot[3+:3];
	assign master_01_aw_region = master_awregion[4+:4];
	assign master_01_aw_len = master_awlen[8+:8];
	assign master_01_aw_size = master_awsize[3+:3];
	assign master_01_aw_burst = master_awburst[2+:2];
	assign master_01_aw_lock = master_awlock[1];
	assign master_01_aw_cache = master_awcache[4+:4];
	assign master_01_aw_qos = master_awqos[4+:4];
	assign master_01_aw_id[AXI_ID_OUT - 1:0] = master_awid[AXI_ID_OUT+:AXI_ID_OUT];
	assign master_01_aw_user = master_awuser[AXI_USER_W+:AXI_USER_W];
	assign master_01_aw_valid = master_awvalid[1];
	assign master_awready[1] = master_01_aw_ready;
	assign master_01_ar_addr = master_araddr[AXI_ADDRESS_W+:AXI_ADDRESS_W];
	assign master_01_ar_prot = master_arprot[3+:3];
	assign master_01_ar_region = master_arregion[4+:4];
	assign master_01_ar_len = master_arlen[8+:8];
	assign master_01_ar_size = master_arsize[3+:3];
	assign master_01_ar_burst = master_arburst[2+:2];
	assign master_01_ar_lock = master_arlock[1];
	assign master_01_ar_cache = master_arcache[4+:4];
	assign master_01_ar_qos = master_arqos[4+:4];
	assign master_01_ar_id[AXI_ID_OUT - 1:0] = master_arid[AXI_ID_OUT+:AXI_ID_OUT];
	assign master_01_ar_user = master_aruser[AXI_USER_W+:AXI_USER_W];
	assign master_01_ar_valid = master_arvalid[1];
	assign master_arready[1] = master_01_ar_ready;
	assign master_01_w_valid = master_wvalid[1];
	assign master_01_w_data = master_wdata[AXI_DATA_W+:AXI_DATA_W];
	assign master_01_w_strb = master_wstrb[AXI_NUMBYTES+:AXI_NUMBYTES];
	assign master_01_w_user = master_wuser[AXI_USER_W+:AXI_USER_W];
	assign master_01_w_last = master_wlast[1];
	assign master_wready[1] = master_01_w_ready;
	assign master_bid[AXI_ID_OUT+:AXI_ID_OUT] = master_01_b_id[AXI_ID_OUT - 1:0];
	assign master_bresp[2+:2] = master_01_b_resp;
	assign master_bvalid[1] = master_01_b_valid;
	assign master_buser[AXI_USER_W+:AXI_USER_W] = master_01_b_user;
	assign master_01_b_ready = master_bready[1];
	assign master_rdata[AXI_DATA_W+:AXI_DATA_W] = master_01_r_data;
	assign master_rresp[2+:2] = master_01_r_resp;
	assign master_rlast[1] = master_01_r_last;
	assign master_rid[AXI_ID_OUT+:AXI_ID_OUT] = master_01_r_id[AXI_ID_OUT - 1:0];
	assign master_ruser[AXI_USER_W+:AXI_USER_W] = master_01_r_user;
	assign master_rvalid[1] = master_01_r_valid;
	assign master_01_r_ready = master_rready[1];
	assign master_02_aw_addr = master_awaddr[2 * AXI_ADDRESS_W+:AXI_ADDRESS_W];
	assign master_02_aw_prot = master_awprot[6+:3];
	assign master_02_aw_region = master_awregion[8+:4];
	assign master_02_aw_len = master_awlen[16+:8];
	assign master_02_aw_size = master_awsize[6+:3];
	assign master_02_aw_burst = master_awburst[4+:2];
	assign master_02_aw_lock = master_awlock[2];
	assign master_02_aw_cache = master_awcache[8+:4];
	assign master_02_aw_qos = master_awqos[8+:4];
	assign master_02_aw_id[AXI_ID_OUT - 1:0] = master_awid[2 * AXI_ID_OUT+:AXI_ID_OUT];
	assign master_02_aw_user = master_awuser[2 * AXI_USER_W+:AXI_USER_W];
	assign master_02_aw_valid = master_awvalid[2];
	assign master_awready[2] = master_02_aw_ready;
	assign master_02_ar_addr = master_araddr[2 * AXI_ADDRESS_W+:AXI_ADDRESS_W];
	assign master_02_ar_prot = master_arprot[6+:3];
	assign master_02_ar_region = master_arregion[8+:4];
	assign master_02_ar_len = master_arlen[16+:8];
	assign master_02_ar_size = master_arsize[6+:3];
	assign master_02_ar_burst = master_arburst[4+:2];
	assign master_02_ar_lock = master_arlock[2];
	assign master_02_ar_cache = master_arcache[8+:4];
	assign master_02_ar_qos = master_arqos[8+:4];
	assign master_02_ar_id[AXI_ID_OUT - 1:0] = master_arid[2 * AXI_ID_OUT+:AXI_ID_OUT];
	assign master_02_ar_user = master_aruser[2 * AXI_USER_W+:AXI_USER_W];
	assign master_02_ar_valid = master_arvalid[2];
	assign master_arready[2] = master_02_ar_ready;
	assign master_02_w_valid = master_wvalid[2];
	assign master_02_w_data = master_wdata[2 * AXI_DATA_W+:AXI_DATA_W];
	assign master_02_w_strb = master_wstrb[2 * AXI_NUMBYTES+:AXI_NUMBYTES];
	assign master_02_w_user = master_wuser[2 * AXI_USER_W+:AXI_USER_W];
	assign master_02_w_last = master_wlast[2];
	assign master_wready[2] = master_02_w_ready;
	assign master_bid[2 * AXI_ID_OUT+:AXI_ID_OUT] = master_02_b_id[AXI_ID_OUT - 1:0];
	assign master_bresp[4+:2] = master_02_b_resp;
	assign master_bvalid[2] = master_02_b_valid;
	assign master_buser[2 * AXI_USER_W+:AXI_USER_W] = master_02_b_user;
	assign master_02_b_ready = master_bready[2];
	assign master_rdata[2 * AXI_DATA_W+:AXI_DATA_W] = master_02_r_data;
	assign master_rresp[4+:2] = master_02_r_resp;
	assign master_rlast[2] = master_02_r_last;
	assign master_rid[2 * AXI_ID_OUT+:AXI_ID_OUT] = master_02_r_id[AXI_ID_OUT - 1:0];
	assign master_ruser[2 * AXI_USER_W+:AXI_USER_W] = master_02_r_user;
	assign master_rvalid[2] = master_02_r_valid;
	assign master_02_r_ready = master_rready[2];
	axi_node #(
		.AXI_ADDRESS_W(AXI_ADDRESS_W),
		.AXI_DATA_W(AXI_DATA_W),
		.AXI_ID_IN(AXI_ID_IN),
		.AXI_USER_W(AXI_USER_W),
		.N_MASTER_PORT(N_MASTER_PORT),
		.N_SLAVE_PORT(N_SLAVE_PORT),
		.N_REGION(N_REGION)
	) AXI4_NODE(
		.clk(clk),
		.rst_n(rst_n),
		.test_en_i(test_en_i),
		.slave_awid_i(slave_awid),
		.slave_awaddr_i(slave_awaddr),
		.slave_awlen_i(slave_awlen),
		.slave_awsize_i(slave_awsize),
		.slave_awburst_i(slave_awburst),
		.slave_awlock_i(slave_awlock),
		.slave_awcache_i(slave_awcache),
		.slave_awprot_i(slave_awprot),
		.slave_awregion_i(slave_awregion),
		.slave_awqos_i(slave_awqos),
		.slave_awuser_i(slave_awuser),
		.slave_awvalid_i(slave_awvalid),
		.slave_awready_o(slave_awready),
		.slave_wdata_i(slave_wdata),
		.slave_wstrb_i(slave_wstrb),
		.slave_wlast_i(slave_wlast),
		.slave_wuser_i(slave_wuser),
		.slave_wvalid_i(slave_wvalid),
		.slave_wready_o(slave_wready),
		.slave_bid_o(slave_bid),
		.slave_bresp_o(slave_bresp),
		.slave_buser_o(slave_buser),
		.slave_bvalid_o(slave_bvalid),
		.slave_bready_i(slave_bready),
		.slave_arid_i(slave_arid),
		.slave_araddr_i(slave_araddr),
		.slave_arlen_i(slave_arlen),
		.slave_arsize_i(slave_arsize),
		.slave_arburst_i(slave_arburst),
		.slave_arlock_i(slave_arlock),
		.slave_arcache_i(slave_arcache),
		.slave_arprot_i(slave_arprot),
		.slave_arregion_i(slave_arregion),
		.slave_aruser_i(slave_aruser),
		.slave_arqos_i(slave_arqos),
		.slave_arvalid_i(slave_arvalid),
		.slave_arready_o(slave_arready),
		.slave_rid_o(slave_rid),
		.slave_rdata_o(slave_rdata),
		.slave_rresp_o(slave_rresp),
		.slave_rlast_o(slave_rlast),
		.slave_ruser_o(slave_ruser),
		.slave_rvalid_o(slave_rvalid),
		.slave_rready_i(slave_rready),
		.master_awid_o(master_awid),
		.master_awaddr_o(master_awaddr),
		.master_awlen_o(master_awlen),
		.master_awsize_o(master_awsize),
		.master_awburst_o(master_awburst),
		.master_awlock_o(master_awlock),
		.master_awcache_o(master_awcache),
		.master_awprot_o(master_awprot),
		.master_awregion_o(master_awregion),
		.master_awuser_o(master_awuser),
		.master_awqos_o(master_awqos),
		.master_awvalid_o(master_awvalid),
		.master_awready_i(master_awready),
		.master_wdata_o(master_wdata),
		.master_wstrb_o(master_wstrb),
		.master_wlast_o(master_wlast),
		.master_wuser_o(master_wuser),
		.master_wvalid_o(master_wvalid),
		.master_wready_i(master_wready),
		.master_bid_i(master_bid),
		.master_bresp_i(master_bresp),
		.master_buser_i(master_buser),
		.master_bvalid_i(master_bvalid),
		.master_bready_o(master_bready),
		.master_arid_o(master_arid),
		.master_araddr_o(master_araddr),
		.master_arlen_o(master_arlen),
		.master_arsize_o(master_arsize),
		.master_arburst_o(master_arburst),
		.master_arlock_o(master_arlock),
		.master_arcache_o(master_arcache),
		.master_arprot_o(master_arprot),
		.master_arregion_o(master_arregion),
		.master_aruser_o(master_aruser),
		.master_arqos_o(master_arqos),
		.master_arvalid_o(master_arvalid),
		.master_arready_i(master_arready),
		.master_rid_i(master_rid),
		.master_rdata_i(master_rdata),
		.master_rresp_i(master_rresp),
		.master_rlast_i(master_rlast),
		.master_ruser_i(master_ruser),
		.master_rvalid_i(master_rvalid),
		.master_rready_o(master_rready),
		.cfg_START_ADDR_i(cfg_START_ADDR_i),
		.cfg_END_ADDR_i(cfg_END_ADDR_i),
		.cfg_valid_rule_i(cfg_valid_rule_i),
		.cfg_connectivity_map_i(cfg_connectivity_map_i)
	);
endmodule
