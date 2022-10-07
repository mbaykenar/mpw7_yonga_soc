module axi_node_wrap_with_slices 
#(

    parameter                   AXI_ADDRESS_W      = 32,
    parameter                   AXI_DATA_W         = 64,
    parameter                   AXI_NUMBYTES       = AXI_DATA_W/8,
    parameter                   AXI_USER_W         = 6,
`ifdef USE_CFG_BLOCK
  `ifdef USE_AXI_LITE
    parameter                   AXI_LITE_ADDRESS_W = 32,
    parameter                   AXI_LITE_DATA_W    = 32,
    parameter                   AXI_LITE_BE_W      = AXI_LITE_DATA_W/8,
  `else
    parameter                   APB_ADDR_WIDTH     = 12,  //APB slaves are 4KB by default
    parameter                   APB_DATA_WIDTH     = 32,
  `endif
`endif
    parameter                   N_MASTER_PORT      = 3, // 3 in pulpino
    parameter                   N_SLAVE_PORT       = 3, // 3 in pulpino
    parameter                   AXI_ID_IN          = 4,
    parameter                   AXI_ID_OUT         = AXI_ID_IN + $clog2(N_SLAVE_PORT),
    parameter                   FIFO_DEPTH_DW      = 4,
    parameter                   N_REGION           = 4,
    parameter                   MASTER_SLICE_DEPTH = 2,
    parameter                   SLAVE_SLICE_DEPTH  = 2
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
	//parameter AXI_DATA_W = 64;
	//parameter AXI_NUMBYTES = AXI_DATA_W / 8;
	//parameter AXI_USER_W = 6;
	//parameter N_MASTER_PORT = 3;
	//parameter N_SLAVE_PORT = 3;
	//parameter AXI_ID_IN = 4;
	//parameter AXI_ID_OUT = AXI_ID_IN + $clog2(N_SLAVE_PORT);
	//parameter FIFO_DEPTH_DW = 4;
	//parameter N_REGION = 4;
	//parameter MASTER_SLICE_DEPTH = 2;
	//parameter SLAVE_SLICE_DEPTH = 2;
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
	genvar i;
	wire [AXI_ADDR_WIDTH - 1:0] axi_slave_00_aw_addr;
	wire [2:0] axi_slave_00_aw_prot;
	wire [3:0] axi_slave_00_aw_region;
	wire [7:0] axi_slave_00_aw_len;
	wire [2:0] axi_slave_00_aw_size;
	wire [1:0] axi_slave_00_aw_burst;
	wire axi_slave_00_aw_lock;
	wire [3:0] axi_slave_00_aw_cache;
	wire [3:0] axi_slave_00_aw_qos;
	wire [AXI_ID_WIDTH - 1:0] axi_slave_00_aw_id;
	wire [AXI_USER_WIDTH - 1:0] axi_slave_00_aw_user;
	wire axi_slave_00_aw_ready;
	wire axi_slave_00_aw_valid;
	wire [AXI_ADDR_WIDTH - 1:0] axi_slave_00_ar_addr;
	wire [2:0] axi_slave_00_ar_prot;
	wire [3:0] axi_slave_00_ar_region;
	wire [7:0] axi_slave_00_ar_len;
	wire [2:0] axi_slave_00_ar_size;
	wire [1:0] axi_slave_00_ar_burst;
	wire axi_slave_00_ar_lock;
	wire [3:0] axi_slave_00_ar_cache;
	wire [3:0] axi_slave_00_ar_qos;
	wire [AXI_ID_WIDTH - 1:0] axi_slave_00_ar_id;
	wire [AXI_USER_WIDTH - 1:0] axi_slave_00_ar_user;
	wire axi_slave_00_ar_ready;
	wire axi_slave_00_ar_valid;
	wire axi_slave_00_w_valid;
	wire [AXI_DATA_WIDTH - 1:0] axi_slave_00_w_data;
	wire [AXI_STRB_WIDTH - 1:0] axi_slave_00_w_strb;
	wire [AXI_USER_WIDTH - 1:0] axi_slave_00_w_user;
	wire axi_slave_00_w_last;
	wire axi_slave_00_w_ready;
	wire [AXI_DATA_WIDTH - 1:0] axi_slave_00_r_data;
	wire [1:0] axi_slave_00_r_resp;
	wire axi_slave_00_r_last;
	wire [AXI_ID_WIDTH - 1:0] axi_slave_00_r_id;
	wire [AXI_USER_WIDTH - 1:0] axi_slave_00_r_user;
	wire axi_slave_00_r_ready;
	wire axi_slave_00_r_valid;
	wire [1:0] axi_slave_00_b_resp;
	wire [AXI_ID_WIDTH - 1:0] axi_slave_00_b_id;
	wire [AXI_USER_WIDTH - 1:0] axi_slave_00_b_user;
	wire axi_slave_00_b_ready;
	wire axi_slave_00_b_valid;
	wire [AXI_ADDR_WIDTH - 1:0] axi_slave_01_aw_addr;
	wire [2:0] axi_slave_01_aw_prot;
	wire [3:0] axi_slave_01_aw_region;
	wire [7:0] axi_slave_01_aw_len;
	wire [2:0] axi_slave_01_aw_size;
	wire [1:0] axi_slave_01_aw_burst;
	wire axi_slave_01_aw_lock;
	wire [3:0] axi_slave_01_aw_cache;
	wire [3:0] axi_slave_01_aw_qos;
	wire [AXI_ID_WIDTH - 1:0] axi_slave_01_aw_id;
	wire [AXI_USER_WIDTH - 1:0] axi_slave_01_aw_user;
	wire axi_slave_01_aw_ready;
	wire axi_slave_01_aw_valid;
	wire [AXI_ADDR_WIDTH - 1:0] axi_slave_01_ar_addr;
	wire [2:0] axi_slave_01_ar_prot;
	wire [3:0] axi_slave_01_ar_region;
	wire [7:0] axi_slave_01_ar_len;
	wire [2:0] axi_slave_01_ar_size;
	wire [1:0] axi_slave_01_ar_burst;
	wire axi_slave_01_ar_lock;
	wire [3:0] axi_slave_01_ar_cache;
	wire [3:0] axi_slave_01_ar_qos;
	wire [AXI_ID_WIDTH - 1:0] axi_slave_01_ar_id;
	wire [AXI_USER_WIDTH - 1:0] axi_slave_01_ar_user;
	wire axi_slave_01_ar_ready;
	wire axi_slave_01_ar_valid;
	wire axi_slave_01_w_valid;
	wire [AXI_DATA_WIDTH - 1:0] axi_slave_01_w_data;
	wire [AXI_STRB_WIDTH - 1:0] axi_slave_01_w_strb;
	wire [AXI_USER_WIDTH - 1:0] axi_slave_01_w_user;
	wire axi_slave_01_w_last;
	wire axi_slave_01_w_ready;
	wire [AXI_DATA_WIDTH - 1:0] axi_slave_01_r_data;
	wire [1:0] axi_slave_01_r_resp;
	wire axi_slave_01_r_last;
	wire [AXI_ID_WIDTH - 1:0] axi_slave_01_r_id;
	wire [AXI_USER_WIDTH - 1:0] axi_slave_01_r_user;
	wire axi_slave_01_r_ready;
	wire axi_slave_01_r_valid;
	wire [1:0] axi_slave_01_b_resp;
	wire [AXI_ID_WIDTH - 1:0] axi_slave_01_b_id;
	wire [AXI_USER_WIDTH - 1:0] axi_slave_01_b_user;
	wire axi_slave_01_b_ready;
	wire axi_slave_01_b_valid;
	wire [AXI_ADDR_WIDTH - 1:0] axi_slave_02_aw_addr;
	wire [2:0] axi_slave_02_aw_prot;
	wire [3:0] axi_slave_02_aw_region;
	wire [7:0] axi_slave_02_aw_len;
	wire [2:0] axi_slave_02_aw_size;
	wire [1:0] axi_slave_02_aw_burst;
	wire axi_slave_02_aw_lock;
	wire [3:0] axi_slave_02_aw_cache;
	wire [3:0] axi_slave_02_aw_qos;
	wire [AXI_ID_WIDTH - 1:0] axi_slave_02_aw_id;
	wire [AXI_USER_WIDTH - 1:0] axi_slave_02_aw_user;
	wire axi_slave_02_aw_ready;
	wire axi_slave_02_aw_valid;
	wire [AXI_ADDR_WIDTH - 1:0] axi_slave_02_ar_addr;
	wire [2:0] axi_slave_02_ar_prot;
	wire [3:0] axi_slave_02_ar_region;
	wire [7:0] axi_slave_02_ar_len;
	wire [2:0] axi_slave_02_ar_size;
	wire [1:0] axi_slave_02_ar_burst;
	wire axi_slave_02_ar_lock;
	wire [3:0] axi_slave_02_ar_cache;
	wire [3:0] axi_slave_02_ar_qos;
	wire [AXI_ID_WIDTH - 1:0] axi_slave_02_ar_id;
	wire [AXI_USER_WIDTH - 1:0] axi_slave_02_ar_user;
	wire axi_slave_02_ar_ready;
	wire axi_slave_02_ar_valid;
	wire axi_slave_02_w_valid;
	wire [AXI_DATA_WIDTH - 1:0] axi_slave_02_w_data;
	wire [AXI_STRB_WIDTH - 1:0] axi_slave_02_w_strb;
	wire [AXI_USER_WIDTH - 1:0] axi_slave_02_w_user;
	wire axi_slave_02_w_last;
	wire axi_slave_02_w_ready;
	wire [AXI_DATA_WIDTH - 1:0] axi_slave_02_r_data;
	wire [1:0] axi_slave_02_r_resp;
	wire axi_slave_02_r_last;
	wire [AXI_ID_WIDTH - 1:0] axi_slave_02_r_id;
	wire [AXI_USER_WIDTH - 1:0] axi_slave_02_r_user;
	wire axi_slave_02_r_ready;
	wire axi_slave_02_r_valid;
	wire [1:0] axi_slave_02_b_resp;
	wire [AXI_ID_WIDTH - 1:0] axi_slave_02_b_id;
	wire [AXI_USER_WIDTH - 1:0] axi_slave_02_b_user;
	wire axi_slave_02_b_ready;
	wire axi_slave_02_b_valid;
	wire [AXI_ADDR_WIDTH - 1:0] axi_master_00_aw_addr;
	wire [2:0] axi_master_00_aw_prot;
	wire [3:0] axi_master_00_aw_region;
	wire [7:0] axi_master_00_aw_len;
	wire [2:0] axi_master_00_aw_size;
	wire [1:0] axi_master_00_aw_burst;
	wire axi_master_00_aw_lock;
	wire [3:0] axi_master_00_aw_cache;
	wire [3:0] axi_master_00_aw_qos;
	wire [AXI_ID_WIDTH - 1:0] axi_master_00_aw_id;
	wire [AXI_USER_WIDTH - 1:0] axi_master_00_aw_user;
	wire axi_master_00_aw_ready;
	wire axi_master_00_aw_valid;
	wire [AXI_ADDR_WIDTH - 1:0] axi_master_00_ar_addr;
	wire [2:0] axi_master_00_ar_prot;
	wire [3:0] axi_master_00_ar_region;
	wire [7:0] axi_master_00_ar_len;
	wire [2:0] axi_master_00_ar_size;
	wire [1:0] axi_master_00_ar_burst;
	wire axi_master_00_ar_lock;
	wire [3:0] axi_master_00_ar_cache;
	wire [3:0] axi_master_00_ar_qos;
	wire [AXI_ID_WIDTH - 1:0] axi_master_00_ar_id;
	wire [AXI_USER_WIDTH - 1:0] axi_master_00_ar_user;
	wire axi_master_00_ar_ready;
	wire axi_master_00_ar_valid;
	wire axi_master_00_w_valid;
	wire [AXI_DATA_WIDTH - 1:0] axi_master_00_w_data;
	wire [AXI_STRB_WIDTH - 1:0] axi_master_00_w_strb;
	wire [AXI_USER_WIDTH - 1:0] axi_master_00_w_user;
	wire axi_master_00_w_last;
	wire axi_master_00_w_ready;
	wire [AXI_DATA_WIDTH - 1:0] axi_master_00_r_data;
	wire [1:0] axi_master_00_r_resp;
	wire axi_master_00_r_last;
	wire [AXI_ID_WIDTH - 1:0] axi_master_00_r_id;
	wire [AXI_USER_WIDTH - 1:0] axi_master_00_r_user;
	wire axi_master_00_r_ready;
	wire axi_master_00_r_valid;
	wire [1:0] axi_master_00_b_resp;
	wire [AXI_ID_WIDTH - 1:0] axi_master_00_b_id;
	wire [AXI_USER_WIDTH - 1:0] axi_master_00_b_user;
	wire axi_master_00_b_ready;
	wire axi_master_00_b_valid;
	wire [AXI_ADDR_WIDTH - 1:0] axi_master_01_aw_addr;
	wire [2:0] axi_master_01_aw_prot;
	wire [3:0] axi_master_01_aw_region;
	wire [7:0] axi_master_01_aw_len;
	wire [2:0] axi_master_01_aw_size;
	wire [1:0] axi_master_01_aw_burst;
	wire axi_master_01_aw_lock;
	wire [3:0] axi_master_01_aw_cache;
	wire [3:0] axi_master_01_aw_qos;
	wire [AXI_ID_WIDTH - 1:0] axi_master_01_aw_id;
	wire [AXI_USER_WIDTH - 1:0] axi_master_01_aw_user;
	wire axi_master_01_aw_ready;
	wire axi_master_01_aw_valid;
	wire [AXI_ADDR_WIDTH - 1:0] axi_master_01_ar_addr;
	wire [2:0] axi_master_01_ar_prot;
	wire [3:0] axi_master_01_ar_region;
	wire [7:0] axi_master_01_ar_len;
	wire [2:0] axi_master_01_ar_size;
	wire [1:0] axi_master_01_ar_burst;
	wire axi_master_01_ar_lock;
	wire [3:0] axi_master_01_ar_cache;
	wire [3:0] axi_master_01_ar_qos;
	wire [AXI_ID_WIDTH - 1:0] axi_master_01_ar_id;
	wire [AXI_USER_WIDTH - 1:0] axi_master_01_ar_user;
	wire axi_master_01_ar_ready;
	wire axi_master_01_ar_valid;
	wire axi_master_01_w_valid;
	wire [AXI_DATA_WIDTH - 1:0] axi_master_01_w_data;
	wire [AXI_STRB_WIDTH - 1:0] axi_master_01_w_strb;
	wire [AXI_USER_WIDTH - 1:0] axi_master_01_w_user;
	wire axi_master_01_w_last;
	wire axi_master_01_w_ready;
	wire [AXI_DATA_WIDTH - 1:0] axi_master_01_r_data;
	wire [1:0] axi_master_01_r_resp;
	wire axi_master_01_r_last;
	wire [AXI_ID_WIDTH - 1:0] axi_master_01_r_id;
	wire [AXI_USER_WIDTH - 1:0] axi_master_01_r_user;
	wire axi_master_01_r_ready;
	wire axi_master_01_r_valid;
	wire [1:0] axi_master_01_b_resp;
	wire [AXI_ID_WIDTH - 1:0] axi_master_01_b_id;
	wire [AXI_USER_WIDTH - 1:0] axi_master_01_b_user;
	wire axi_master_01_b_ready;
	wire axi_master_01_b_valid;
	wire [AXI_ADDR_WIDTH - 1:0] axi_master_02_aw_addr;
	wire [2:0] axi_master_02_aw_prot;
	wire [3:0] axi_master_02_aw_region;
	wire [7:0] axi_master_02_aw_len;
	wire [2:0] axi_master_02_aw_size;
	wire [1:0] axi_master_02_aw_burst;
	wire axi_master_02_aw_lock;
	wire [3:0] axi_master_02_aw_cache;
	wire [3:0] axi_master_02_aw_qos;
	wire [AXI_ID_WIDTH - 1:0] axi_master_02_aw_id;
	wire [AXI_USER_WIDTH - 1:0] axi_master_02_aw_user;
	wire axi_master_02_aw_ready;
	wire axi_master_02_aw_valid;
	wire [AXI_ADDR_WIDTH - 1:0] axi_master_02_ar_addr;
	wire [2:0] axi_master_02_ar_prot;
	wire [3:0] axi_master_02_ar_region;
	wire [7:0] axi_master_02_ar_len;
	wire [2:0] axi_master_02_ar_size;
	wire [1:0] axi_master_02_ar_burst;
	wire axi_master_02_ar_lock;
	wire [3:0] axi_master_02_ar_cache;
	wire [3:0] axi_master_02_ar_qos;
	wire [AXI_ID_WIDTH - 1:0] axi_master_02_ar_id;
	wire [AXI_USER_WIDTH - 1:0] axi_master_02_ar_user;
	wire axi_master_02_ar_ready;
	wire axi_master_02_ar_valid;
	wire axi_master_02_w_valid;
	wire [AXI_DATA_WIDTH - 1:0] axi_master_02_w_data;
	wire [AXI_STRB_WIDTH - 1:0] axi_master_02_w_strb;
	wire [AXI_USER_WIDTH - 1:0] axi_master_02_w_user;
	wire axi_master_02_w_last;
	wire axi_master_02_w_ready;
	wire [AXI_DATA_WIDTH - 1:0] axi_master_02_r_data;
	wire [1:0] axi_master_02_r_resp;
	wire axi_master_02_r_last;
	wire [AXI_ID_WIDTH - 1:0] axi_master_02_r_id;
	wire [AXI_USER_WIDTH - 1:0] axi_master_02_r_user;
	wire axi_master_02_r_ready;
	wire axi_master_02_r_valid;
	wire [1:0] axi_master_02_b_resp;
	wire [AXI_ID_WIDTH - 1:0] axi_master_02_b_id;
	wire [AXI_USER_WIDTH - 1:0] axi_master_02_b_user;
	wire axi_master_02_b_ready;
	wire axi_master_02_b_valid;
	wire axi_slave;
	wire axi_master;
	axi_node_wrap #(
		.AXI_ADDRESS_W(AXI_ADDRESS_W),
		.AXI_DATA_W(AXI_DATA_W),
		.AXI_USER_W(AXI_USER_W),
		.N_MASTER_PORT(N_MASTER_PORT),
		.N_SLAVE_PORT(N_SLAVE_PORT),
		.AXI_ID_IN(AXI_ID_IN),
		.AXI_ID_OUT(AXI_ID_OUT),
		.FIFO_DEPTH_DW(FIFO_DEPTH_DW),
		.N_REGION(N_REGION)
	) i_axi_node_wrap(
		.clk(clk),
		.rst_n(rst_n),
		.test_en_i(test_en_i),
		.axi_port_slave(axi_slave),
		.axi_port_master(axi_master),
		.cfg_END_ADDR_i(cfg_END_ADDR_i),
		.cfg_START_ADDR_i(cfg_START_ADDR_i),
		.cfg_valid_rule_i(cfg_valid_rule_i),
		.cfg_connectivity_map_i(cfg_connectivity_map_i)
	);
	axi_slice_wrap i_axi_slice_wrap_master_00(
		.clk_i(clk),
		.rst_ni(rst_n),
		.test_en_i(test_en_i),
		.s00_aw_addr(axi_master_00_aw_addr),
		.s00_aw_prot(axi_master_00_aw_prot),
		.s00_aw_region(axi_master_00_aw_region),
		.s00_aw_len(axi_master_00_aw_len),
		.s00_aw_size(axi_master_00_aw_size),
		.s00_aw_burst(axi_master_00_aw_burst),
		.s00_aw_lock(axi_master_00_aw_lock),
		.s00_aw_cache(axi_master_00_aw_cache),
		.s00_aw_qos(axi_master_00_aw_qos),
		.s00_aw_id(axi_master_00_aw_id),
		.s00_aw_user(axi_master_00_aw_user),
		.s00_aw_ready(axi_master_00_aw_ready),
		.s00_aw_valid(axi_master_00_aw_valid),
		.s00_ar_addr(axi_master_00_ar_addr),
		.s00_ar_prot(axi_master_00_ar_prot),
		.s00_ar_region(axi_master_00_ar_region),
		.s00_ar_len(axi_master_00_ar_len),
		.s00_ar_size(axi_master_00_ar_size),
		.s00_ar_burst(axi_master_00_ar_burst),
		.s00_ar_lock(axi_master_00_ar_lock),
		.s00_ar_cache(axi_master_00_ar_cache),
		.s00_ar_qos(axi_master_00_ar_qos),
		.s00_ar_id(axi_master_00_ar_id),
		.s00_ar_user(axi_master_00_ar_user),
		.s00_ar_ready(axi_master_00_ar_ready),
		.s00_ar_valid(axi_master_00_ar_valid),
		.s00_w_valid(axi_master_00_w_valid),
		.s00_w_data(axi_master_00_w_data),
		.s00_w_strb(axi_master_00_w_strb),
		.s00_w_user(axi_master_00_w_user),
		.s00_w_last(axi_master_00_w_last),
		.s00_w_ready(axi_master_00_w_ready),
		.s00_r_data(axi_master_00_r_data),
		.s00_r_resp(axi_master_00_r_resp),
		.s00_r_last(axi_master_00_r_last),
		.s00_r_id(axi_master_00_r_id),
		.s00_r_user(axi_master_00_r_user),
		.s00_r_ready(axi_master_00_r_ready),
		.s00_r_valid(axi_master_00_r_valid),
		.s00_b_resp(axi_master_00_b_resp),
		.s00_b_id(axi_master_00_b_id),
		.s00_b_user(axi_master_00_b_user),
		.s00_b_ready(axi_master_00_b_ready),
		.s00_b_valid(axi_master_00_b_valid),
		.m00_aw_addr(master_00_aw_addr),
		.m00_aw_prot(master_00_aw_prot),
		.m00_aw_region(master_00_aw_region),
		.m00_aw_len(master_00_aw_len),
		.m00_aw_size(master_00_aw_size),
		.m00_aw_burst(master_00_aw_burst),
		.m00_aw_lock(master_00_aw_lock),
		.m00_aw_cache(master_00_aw_cache),
		.m00_aw_qos(master_00_aw_qos),
		.m00_aw_id(master_00_aw_id),
		.m00_aw_user(master_00_aw_user),
		.m00_aw_ready(master_00_aw_ready),
		.m00_aw_valid(master_00_aw_valid),
		.m00_ar_addr(master_00_ar_addr),
		.m00_ar_prot(master_00_ar_prot),
		.m00_ar_region(master_00_ar_region),
		.m00_ar_len(master_00_ar_len),
		.m00_ar_size(master_00_ar_size),
		.m00_ar_burst(master_00_ar_burst),
		.m00_ar_lock(master_00_ar_lock),
		.m00_ar_cache(master_00_ar_cache),
		.m00_ar_qos(master_00_ar_qos),
		.m00_ar_id(master_00_ar_id),
		.m00_ar_user(master_00_ar_user),
		.m00_ar_ready(master_00_ar_ready),
		.m00_ar_valid(master_00_ar_valid),
		.m00_w_valid(master_00_w_valid),
		.m00_w_data(master_00_w_data),
		.m00_w_strb(master_00_w_strb),
		.m00_w_user(master_00_w_user),
		.m00_w_last(master_00_w_last),
		.m00_w_ready(master_00_w_ready),
		.m00_r_data(master_00_r_data),
		.m00_r_resp(master_00_r_resp),
		.m00_r_last(master_00_r_last),
		.m00_r_id(master_00_r_id),
		.m00_r_user(master_00_r_user),
		.m00_r_ready(master_00_r_ready),
		.m00_r_valid(master_00_r_valid),
		.m00_b_resp(master_00_b_resp),
		.m00_b_id(master_00_b_id),
		.m00_b_user(master_00_b_user),
		.m00_b_ready(master_00_b_ready),
		.m00_b_valid(master_00_b_valid)
	);
	axi_slice_wrap i_axi_slice_wrap_master_01(
		.clk_i(clk),
		.rst_ni(rst_n),
		.test_en_i(test_en_i),
		.s00_aw_addr(axi_master_01_aw_addr),
		.s00_aw_prot(axi_master_01_aw_prot),
		.s00_aw_region(axi_master_01_aw_region),
		.s00_aw_len(axi_master_01_aw_len),
		.s00_aw_size(axi_master_01_aw_size),
		.s00_aw_burst(axi_master_01_aw_burst),
		.s00_aw_lock(axi_master_01_aw_lock),
		.s00_aw_cache(axi_master_01_aw_cache),
		.s00_aw_qos(axi_master_01_aw_qos),
		.s00_aw_id(axi_master_01_aw_id),
		.s00_aw_user(axi_master_01_aw_user),
		.s00_aw_ready(axi_master_01_aw_ready),
		.s00_aw_valid(axi_master_01_aw_valid),
		.s00_ar_addr(axi_master_01_ar_addr),
		.s00_ar_prot(axi_master_01_ar_prot),
		.s00_ar_region(axi_master_01_ar_region),
		.s00_ar_len(axi_master_01_ar_len),
		.s00_ar_size(axi_master_01_ar_size),
		.s00_ar_burst(axi_master_01_ar_burst),
		.s00_ar_lock(axi_master_01_ar_lock),
		.s00_ar_cache(axi_master_01_ar_cache),
		.s00_ar_qos(axi_master_01_ar_qos),
		.s00_ar_id(axi_master_01_ar_id),
		.s00_ar_user(axi_master_01_ar_user),
		.s00_ar_ready(axi_master_01_ar_ready),
		.s00_ar_valid(axi_master_01_ar_valid),
		.s00_w_valid(axi_master_01_w_valid),
		.s00_w_data(axi_master_01_w_data),
		.s00_w_strb(axi_master_01_w_strb),
		.s00_w_user(axi_master_01_w_user),
		.s00_w_last(axi_master_01_w_last),
		.s00_w_ready(axi_master_01_w_ready),
		.s00_r_data(axi_master_01_r_data),
		.s00_r_resp(axi_master_01_r_resp),
		.s00_r_last(axi_master_01_r_last),
		.s00_r_id(axi_master_01_r_id),
		.s00_r_user(axi_master_01_r_user),
		.s00_r_ready(axi_master_01_r_ready),
		.s00_r_valid(axi_master_01_r_valid),
		.s00_b_resp(axi_master_01_b_resp),
		.s00_b_id(axi_master_01_b_id),
		.s00_b_user(axi_master_01_b_user),
		.s00_b_ready(axi_master_01_b_ready),
		.s00_b_valid(axi_master_01_b_valid),
		.m00_aw_addr(master_01_aw_addr),
		.m00_aw_prot(master_01_aw_prot),
		.m00_aw_region(master_01_aw_region),
		.m00_aw_len(master_01_aw_len),
		.m00_aw_size(master_01_aw_size),
		.m00_aw_burst(master_01_aw_burst),
		.m00_aw_lock(master_01_aw_lock),
		.m00_aw_cache(master_01_aw_cache),
		.m00_aw_qos(master_01_aw_qos),
		.m00_aw_id(master_01_aw_id),
		.m00_aw_user(master_01_aw_user),
		.m00_aw_ready(master_01_aw_ready),
		.m00_aw_valid(master_01_aw_valid),
		.m00_ar_addr(master_01_ar_addr),
		.m00_ar_prot(master_01_ar_prot),
		.m00_ar_region(master_01_ar_region),
		.m00_ar_len(master_01_ar_len),
		.m00_ar_size(master_01_ar_size),
		.m00_ar_burst(master_01_ar_burst),
		.m00_ar_lock(master_01_ar_lock),
		.m00_ar_cache(master_01_ar_cache),
		.m00_ar_qos(master_01_ar_qos),
		.m00_ar_id(master_01_ar_id),
		.m00_ar_user(master_01_ar_user),
		.m00_ar_ready(master_01_ar_ready),
		.m00_ar_valid(master_01_ar_valid),
		.m00_w_valid(master_01_w_valid),
		.m00_w_data(master_01_w_data),
		.m00_w_strb(master_01_w_strb),
		.m00_w_user(master_01_w_user),
		.m00_w_last(master_01_w_last),
		.m00_w_ready(master_01_w_ready),
		.m00_r_data(master_01_r_data),
		.m00_r_resp(master_01_r_resp),
		.m00_r_last(master_01_r_last),
		.m00_r_id(master_01_r_id),
		.m00_r_user(master_01_r_user),
		.m00_r_ready(master_01_r_ready),
		.m00_r_valid(master_01_r_valid),
		.m00_b_resp(master_01_b_resp),
		.m00_b_id(master_01_b_id),
		.m00_b_user(master_01_b_user),
		.m00_b_ready(master_01_b_ready),
		.m00_b_valid(master_01_b_valid)
	);
	axi_slice_wrap i_axi_slice_wrap_master_02(
		.clk_i(clk),
		.rst_ni(rst_n),
		.test_en_i(test_en_i),
		.s00_aw_addr(axi_master_02_aw_addr),
		.s00_aw_prot(axi_master_02_aw_prot),
		.s00_aw_region(axi_master_02_aw_region),
		.s00_aw_len(axi_master_02_aw_len),
		.s00_aw_size(axi_master_02_aw_size),
		.s00_aw_burst(axi_master_02_aw_burst),
		.s00_aw_lock(axi_master_02_aw_lock),
		.s00_aw_cache(axi_master_02_aw_cache),
		.s00_aw_qos(axi_master_02_aw_qos),
		.s00_aw_id(axi_master_02_aw_id),
		.s00_aw_user(axi_master_02_aw_user),
		.s00_aw_ready(axi_master_02_aw_ready),
		.s00_aw_valid(axi_master_02_aw_valid),
		.s00_ar_addr(axi_master_02_ar_addr),
		.s00_ar_prot(axi_master_02_ar_prot),
		.s00_ar_region(axi_master_02_ar_region),
		.s00_ar_len(axi_master_02_ar_len),
		.s00_ar_size(axi_master_02_ar_size),
		.s00_ar_burst(axi_master_02_ar_burst),
		.s00_ar_lock(axi_master_02_ar_lock),
		.s00_ar_cache(axi_master_02_ar_cache),
		.s00_ar_qos(axi_master_02_ar_qos),
		.s00_ar_id(axi_master_02_ar_id),
		.s00_ar_user(axi_master_02_ar_user),
		.s00_ar_ready(axi_master_02_ar_ready),
		.s00_ar_valid(axi_master_02_ar_valid),
		.s00_w_valid(axi_master_02_w_valid),
		.s00_w_data(axi_master_02_w_data),
		.s00_w_strb(axi_master_02_w_strb),
		.s00_w_user(axi_master_02_w_user),
		.s00_w_last(axi_master_02_w_last),
		.s00_w_ready(axi_master_02_w_ready),
		.s00_r_data(axi_master_02_r_data),
		.s00_r_resp(axi_master_02_r_resp),
		.s00_r_last(axi_master_02_r_last),
		.s00_r_id(axi_master_02_r_id),
		.s00_r_user(axi_master_02_r_user),
		.s00_r_ready(axi_master_02_r_ready),
		.s00_r_valid(axi_master_02_r_valid),
		.s00_b_resp(axi_master_02_b_resp),
		.s00_b_id(axi_master_02_b_id),
		.s00_b_user(axi_master_02_b_user),
		.s00_b_ready(axi_master_02_b_ready),
		.s00_b_valid(axi_master_02_b_valid),
		.m00_aw_addr(master_02_aw_addr),
		.m00_aw_prot(master_02_aw_prot),
		.m00_aw_region(master_02_aw_region),
		.m00_aw_len(master_02_aw_len),
		.m00_aw_size(master_02_aw_size),
		.m00_aw_burst(master_02_aw_burst),
		.m00_aw_lock(master_02_aw_lock),
		.m00_aw_cache(master_02_aw_cache),
		.m00_aw_qos(master_02_aw_qos),
		.m00_aw_id(master_02_aw_id),
		.m00_aw_user(master_02_aw_user),
		.m00_aw_ready(master_02_aw_ready),
		.m00_aw_valid(master_02_aw_valid),
		.m00_ar_addr(master_02_ar_addr),
		.m00_ar_prot(master_02_ar_prot),
		.m00_ar_region(master_02_ar_region),
		.m00_ar_len(master_02_ar_len),
		.m00_ar_size(master_02_ar_size),
		.m00_ar_burst(master_02_ar_burst),
		.m00_ar_lock(master_02_ar_lock),
		.m00_ar_cache(master_02_ar_cache),
		.m00_ar_qos(master_02_ar_qos),
		.m00_ar_id(master_02_ar_id),
		.m00_ar_user(master_02_ar_user),
		.m00_ar_ready(master_02_ar_ready),
		.m00_ar_valid(master_02_ar_valid),
		.m00_w_valid(master_02_w_valid),
		.m00_w_data(master_02_w_data),
		.m00_w_strb(master_02_w_strb),
		.m00_w_user(master_02_w_user),
		.m00_w_last(master_02_w_last),
		.m00_w_ready(master_02_w_ready),
		.m00_r_data(master_02_r_data),
		.m00_r_resp(master_02_r_resp),
		.m00_r_last(master_02_r_last),
		.m00_r_id(master_02_r_id),
		.m00_r_user(master_02_r_user),
		.m00_r_ready(master_02_r_ready),
		.m00_r_valid(master_02_r_valid),
		.m00_b_resp(master_02_b_resp),
		.m00_b_id(master_02_b_id),
		.m00_b_user(master_02_b_user),
		.m00_b_ready(master_02_b_ready),
		.m00_b_valid(master_02_b_valid)
	);
	axi_slice_wrap i_axi_slice_wrap_slave_00(
		.clk_i(clk),
		.rst_ni(rst_n),
		.test_en_i(test_en_i),
		.s00_aw_addr(slave_00_aw_addr),
		.s00_aw_prot(slave_00_aw_prot),
		.s00_aw_region(slave_00_aw_region),
		.s00_aw_len(slave_00_aw_len),
		.s00_aw_size(slave_00_aw_size),
		.s00_aw_burst(slave_00_aw_burst),
		.s00_aw_lock(slave_00_aw_lock),
		.s00_aw_cache(slave_00_aw_cache),
		.s00_aw_qos(slave_00_aw_qos),
		.s00_aw_id(slave_00_aw_id),
		.s00_aw_user(slave_00_aw_user),
		.s00_aw_ready(slave_00_aw_ready),
		.s00_aw_valid(slave_00_aw_valid),
		.s00_ar_addr(slave_00_ar_addr),
		.s00_ar_prot(slave_00_ar_prot),
		.s00_ar_region(slave_00_ar_region),
		.s00_ar_len(slave_00_ar_len),
		.s00_ar_size(slave_00_ar_size),
		.s00_ar_burst(slave_00_ar_burst),
		.s00_ar_lock(slave_00_ar_lock),
		.s00_ar_cache(slave_00_ar_cache),
		.s00_ar_qos(slave_00_ar_qos),
		.s00_ar_id(slave_00_ar_id),
		.s00_ar_user(slave_00_ar_user),
		.s00_ar_ready(slave_00_ar_ready),
		.s00_ar_valid(slave_00_ar_valid),
		.s00_w_valid(slave_00_w_valid),
		.s00_w_data(slave_00_w_data),
		.s00_w_strb(slave_00_w_strb),
		.s00_w_user(slave_00_w_user),
		.s00_w_last(slave_00_w_last),
		.s00_w_ready(slave_00_w_ready),
		.s00_r_data(slave_00_r_data),
		.s00_r_resp(slave_00_r_resp),
		.s00_r_last(slave_00_r_last),
		.s00_r_id(slave_00_r_id),
		.s00_r_user(slave_00_r_user),
		.s00_r_ready(slave_00_r_ready),
		.s00_r_valid(slave_00_r_valid),
		.s00_b_resp(slave_00_b_resp),
		.s00_b_id(slave_00_b_id),
		.s00_b_user(slave_00_b_user),
		.s00_b_ready(slave_00_b_ready),
		.s00_b_valid(slave_00_b_valid),
		.m00_aw_addr(axi_slave_00_aw_addr),
		.m00_aw_prot(axi_slave_00_aw_prot),
		.m00_aw_region(axi_slave_00_aw_region),
		.m00_aw_len(axi_slave_00_aw_len),
		.m00_aw_size(axi_slave_00_aw_size),
		.m00_aw_burst(axi_slave_00_aw_burst),
		.m00_aw_lock(axi_slave_00_aw_lock),
		.m00_aw_cache(axi_slave_00_aw_cache),
		.m00_aw_qos(axi_slave_00_aw_qos),
		.m00_aw_id(axi_slave_00_aw_id),
		.m00_aw_user(axi_slave_00_aw_user),
		.m00_aw_ready(axi_slave_00_aw_ready),
		.m00_aw_valid(axi_slave_00_aw_valid),
		.m00_ar_addr(axi_slave_00_ar_addr),
		.m00_ar_prot(axi_slave_00_ar_prot),
		.m00_ar_region(axi_slave_00_ar_region),
		.m00_ar_len(axi_slave_00_ar_len),
		.m00_ar_size(axi_slave_00_ar_size),
		.m00_ar_burst(axi_slave_00_ar_burst),
		.m00_ar_lock(axi_slave_00_ar_lock),
		.m00_ar_cache(axi_slave_00_ar_cache),
		.m00_ar_qos(axi_slave_00_ar_qos),
		.m00_ar_id(axi_slave_00_ar_id),
		.m00_ar_user(axi_slave_00_ar_user),
		.m00_ar_ready(axi_slave_00_ar_ready),
		.m00_ar_valid(axi_slave_00_ar_valid),
		.m00_w_valid(axi_slave_00_w_valid),
		.m00_w_data(axi_slave_00_w_data),
		.m00_w_strb(axi_slave_00_w_strb),
		.m00_w_user(axi_slave_00_w_user),
		.m00_w_last(axi_slave_00_w_last),
		.m00_w_ready(axi_slave_00_w_ready),
		.m00_r_data(axi_slave_00_r_data),
		.m00_r_resp(axi_slave_00_r_resp),
		.m00_r_last(axi_slave_00_r_last),
		.m00_r_id(axi_slave_00_r_id),
		.m00_r_user(axi_slave_00_r_user),
		.m00_r_ready(axi_slave_00_r_ready),
		.m00_r_valid(axi_slave_00_r_valid),
		.m00_b_resp(axi_slave_00_b_resp),
		.m00_b_id(axi_slave_00_b_id),
		.m00_b_user(axi_slave_00_b_user),
		.m00_b_ready(axi_slave_00_b_ready),
		.m00_b_valid(axi_slave_00_b_valid)
	);
	axi_slice_wrap i_axi_slice_wrap_slave_01(
		.clk_i(clk),
		.rst_ni(rst_n),
		.test_en_i(test_en_i),
		.s00_aw_addr(slave_01_aw_addr),
		.s00_aw_prot(slave_01_aw_prot),
		.s00_aw_region(slave_01_aw_region),
		.s00_aw_len(slave_01_aw_len),
		.s00_aw_size(slave_01_aw_size),
		.s00_aw_burst(slave_01_aw_burst),
		.s00_aw_lock(slave_01_aw_lock),
		.s00_aw_cache(slave_01_aw_cache),
		.s00_aw_qos(slave_01_aw_qos),
		.s00_aw_id(slave_01_aw_id),
		.s00_aw_user(slave_01_aw_user),
		.s00_aw_ready(slave_01_aw_ready),
		.s00_aw_valid(slave_01_aw_valid),
		.s00_ar_addr(slave_01_ar_addr),
		.s00_ar_prot(slave_01_ar_prot),
		.s00_ar_region(slave_01_ar_region),
		.s00_ar_len(slave_01_ar_len),
		.s00_ar_size(slave_01_ar_size),
		.s00_ar_burst(slave_01_ar_burst),
		.s00_ar_lock(slave_01_ar_lock),
		.s00_ar_cache(slave_01_ar_cache),
		.s00_ar_qos(slave_01_ar_qos),
		.s00_ar_id(slave_01_ar_id),
		.s00_ar_user(slave_01_ar_user),
		.s00_ar_ready(slave_01_ar_ready),
		.s00_ar_valid(slave_01_ar_valid),
		.s00_w_valid(slave_01_w_valid),
		.s00_w_data(slave_01_w_data),
		.s00_w_strb(slave_01_w_strb),
		.s00_w_user(slave_01_w_user),
		.s00_w_last(slave_01_w_last),
		.s00_w_ready(slave_01_w_ready),
		.s00_r_data(slave_01_r_data),
		.s00_r_resp(slave_01_r_resp),
		.s00_r_last(slave_01_r_last),
		.s00_r_id(slave_01_r_id),
		.s00_r_user(slave_01_r_user),
		.s00_r_ready(slave_01_r_ready),
		.s00_r_valid(slave_01_r_valid),
		.s00_b_resp(slave_01_b_resp),
		.s00_b_id(slave_01_b_id),
		.s00_b_user(slave_01_b_user),
		.s00_b_ready(slave_01_b_ready),
		.s00_b_valid(slave_01_b_valid),
		.m00_aw_addr(axi_slave_01_aw_addr),
		.m00_aw_prot(axi_slave_01_aw_prot),
		.m00_aw_region(axi_slave_01_aw_region),
		.m00_aw_len(axi_slave_01_aw_len),
		.m00_aw_size(axi_slave_01_aw_size),
		.m00_aw_burst(axi_slave_01_aw_burst),
		.m00_aw_lock(axi_slave_01_aw_lock),
		.m00_aw_cache(axi_slave_01_aw_cache),
		.m00_aw_qos(axi_slave_01_aw_qos),
		.m00_aw_id(axi_slave_01_aw_id),
		.m00_aw_user(axi_slave_01_aw_user),
		.m00_aw_ready(axi_slave_01_aw_ready),
		.m00_aw_valid(axi_slave_01_aw_valid),
		.m00_ar_addr(axi_slave_01_ar_addr),
		.m00_ar_prot(axi_slave_01_ar_prot),
		.m00_ar_region(axi_slave_01_ar_region),
		.m00_ar_len(axi_slave_01_ar_len),
		.m00_ar_size(axi_slave_01_ar_size),
		.m00_ar_burst(axi_slave_01_ar_burst),
		.m00_ar_lock(axi_slave_01_ar_lock),
		.m00_ar_cache(axi_slave_01_ar_cache),
		.m00_ar_qos(axi_slave_01_ar_qos),
		.m00_ar_id(axi_slave_01_ar_id),
		.m00_ar_user(axi_slave_01_ar_user),
		.m00_ar_ready(axi_slave_01_ar_ready),
		.m00_ar_valid(axi_slave_01_ar_valid),
		.m00_w_valid(axi_slave_01_w_valid),
		.m00_w_data(axi_slave_01_w_data),
		.m00_w_strb(axi_slave_01_w_strb),
		.m00_w_user(axi_slave_01_w_user),
		.m00_w_last(axi_slave_01_w_last),
		.m00_w_ready(axi_slave_01_w_ready),
		.m00_r_data(axi_slave_01_r_data),
		.m00_r_resp(axi_slave_01_r_resp),
		.m00_r_last(axi_slave_01_r_last),
		.m00_r_id(axi_slave_01_r_id),
		.m00_r_user(axi_slave_01_r_user),
		.m00_r_ready(axi_slave_01_r_ready),
		.m00_r_valid(axi_slave_01_r_valid),
		.m00_b_resp(axi_slave_01_b_resp),
		.m00_b_id(axi_slave_01_b_id),
		.m00_b_user(axi_slave_01_b_user),
		.m00_b_ready(axi_slave_01_b_ready),
		.m00_b_valid(axi_slave_01_b_valid)
	);
	axi_slice_wrap i_axi_slice_wrap_slave_02(
		.clk_i(clk),
		.rst_ni(rst_n),
		.test_en_i(test_en_i),
		.s00_aw_addr(slave_02_aw_addr),
		.s00_aw_prot(slave_02_aw_prot),
		.s00_aw_region(slave_02_aw_region),
		.s00_aw_len(slave_02_aw_len),
		.s00_aw_size(slave_02_aw_size),
		.s00_aw_burst(slave_02_aw_burst),
		.s00_aw_lock(slave_02_aw_lock),
		.s00_aw_cache(slave_02_aw_cache),
		.s00_aw_qos(slave_02_aw_qos),
		.s00_aw_id(slave_02_aw_id),
		.s00_aw_user(slave_02_aw_user),
		.s00_aw_ready(slave_02_aw_ready),
		.s00_aw_valid(slave_02_aw_valid),
		.s00_ar_addr(slave_02_ar_addr),
		.s00_ar_prot(slave_02_ar_prot),
		.s00_ar_region(slave_02_ar_region),
		.s00_ar_len(slave_02_ar_len),
		.s00_ar_size(slave_02_ar_size),
		.s00_ar_burst(slave_02_ar_burst),
		.s00_ar_lock(slave_02_ar_lock),
		.s00_ar_cache(slave_02_ar_cache),
		.s00_ar_qos(slave_02_ar_qos),
		.s00_ar_id(slave_02_ar_id),
		.s00_ar_user(slave_02_ar_user),
		.s00_ar_ready(slave_02_ar_ready),
		.s00_ar_valid(slave_02_ar_valid),
		.s00_w_valid(slave_02_w_valid),
		.s00_w_data(slave_02_w_data),
		.s00_w_strb(slave_02_w_strb),
		.s00_w_user(slave_02_w_user),
		.s00_w_last(slave_02_w_last),
		.s00_w_ready(slave_02_w_ready),
		.s00_r_data(slave_02_r_data),
		.s00_r_resp(slave_02_r_resp),
		.s00_r_last(slave_02_r_last),
		.s00_r_id(slave_02_r_id),
		.s00_r_user(slave_02_r_user),
		.s00_r_ready(slave_02_r_ready),
		.s00_r_valid(slave_02_r_valid),
		.s00_b_resp(slave_02_b_resp),
		.s00_b_id(slave_02_b_id),
		.s00_b_user(slave_02_b_user),
		.s00_b_ready(slave_02_b_ready),
		.s00_b_valid(slave_02_b_valid),
		.m00_aw_addr(axi_slave_02_aw_addr),
		.m00_aw_prot(axi_slave_02_aw_prot),
		.m00_aw_region(axi_slave_02_aw_region),
		.m00_aw_len(axi_slave_02_aw_len),
		.m00_aw_size(axi_slave_02_aw_size),
		.m00_aw_burst(axi_slave_02_aw_burst),
		.m00_aw_lock(axi_slave_02_aw_lock),
		.m00_aw_cache(axi_slave_02_aw_cache),
		.m00_aw_qos(axi_slave_02_aw_qos),
		.m00_aw_id(axi_slave_02_aw_id),
		.m00_aw_user(axi_slave_02_aw_user),
		.m00_aw_ready(axi_slave_02_aw_ready),
		.m00_aw_valid(axi_slave_02_aw_valid),
		.m00_ar_addr(axi_slave_02_ar_addr),
		.m00_ar_prot(axi_slave_02_ar_prot),
		.m00_ar_region(axi_slave_02_ar_region),
		.m00_ar_len(axi_slave_02_ar_len),
		.m00_ar_size(axi_slave_02_ar_size),
		.m00_ar_burst(axi_slave_02_ar_burst),
		.m00_ar_lock(axi_slave_02_ar_lock),
		.m00_ar_cache(axi_slave_02_ar_cache),
		.m00_ar_qos(axi_slave_02_ar_qos),
		.m00_ar_id(axi_slave_02_ar_id),
		.m00_ar_user(axi_slave_02_ar_user),
		.m00_ar_ready(axi_slave_02_ar_ready),
		.m00_ar_valid(axi_slave_02_ar_valid),
		.m00_w_valid(axi_slave_02_w_valid),
		.m00_w_data(axi_slave_02_w_data),
		.m00_w_strb(axi_slave_02_w_strb),
		.m00_w_user(axi_slave_02_w_user),
		.m00_w_last(axi_slave_02_w_last),
		.m00_w_ready(axi_slave_02_w_ready),
		.m00_r_data(axi_slave_02_r_data),
		.m00_r_resp(axi_slave_02_r_resp),
		.m00_r_last(axi_slave_02_r_last),
		.m00_r_id(axi_slave_02_r_id),
		.m00_r_user(axi_slave_02_r_user),
		.m00_r_ready(axi_slave_02_r_ready),
		.m00_r_valid(axi_slave_02_r_valid),
		.m00_b_resp(axi_slave_02_b_resp),
		.m00_b_id(axi_slave_02_b_id),
		.m00_b_user(axi_slave_02_b_user),
		.m00_b_ready(axi_slave_02_b_ready),
		.m00_b_valid(axi_slave_02_b_valid)
	);
endmodule
