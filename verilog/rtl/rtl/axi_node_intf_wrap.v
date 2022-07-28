module axi_node_intf_wrap 
#(
    parameter NB_MASTER      = 3,
    parameter NB_SLAVE       = 3,
    parameter AXI_ADDR_WIDTH = 32,
    parameter AXI_DATA_WIDTH = 32,
    parameter AXI_ID_WIDTH   = 10,
    parameter AXI_USER_WIDTH = 0
    )
(
	clk,
	rst_n,
	test_en_i,
	s00_aw_addr,
	s00_aw_prot,
	s00_aw_region,
	s00_aw_len,
	s00_aw_size,
	s00_aw_burst,
	s00_aw_lock,
	s00_aw_cache,
	s00_aw_qos,
	s00_aw_id,
	s00_aw_user,
	s00_aw_ready,
	s00_aw_valid,
	s00_ar_addr,
	s00_ar_prot,
	s00_ar_region,
	s00_ar_len,
	s00_ar_size,
	s00_ar_burst,
	s00_ar_lock,
	s00_ar_cache,
	s00_ar_qos,
	s00_ar_id,
	s00_ar_user,
	s00_ar_ready,
	s00_ar_valid,
	s00_w_valid,
	s00_w_data,
	s00_w_strb,
	s00_w_user,
	s00_w_last,
	s00_w_ready,
	s00_r_data,
	s00_r_resp,
	s00_r_last,
	s00_r_id,
	s00_r_user,
	s00_r_ready,
	s00_r_valid,
	s00_b_resp,
	s00_b_id,
	s00_b_user,
	s00_b_ready,
	s00_b_valid,
	s01_aw_addr,
	s01_aw_prot,
	s01_aw_region,
	s01_aw_len,
	s01_aw_size,
	s01_aw_burst,
	s01_aw_lock,
	s01_aw_cache,
	s01_aw_qos,
	s01_aw_id,
	s01_aw_user,
	s01_aw_ready,
	s01_aw_valid,
	s01_ar_addr,
	s01_ar_prot,
	s01_ar_region,
	s01_ar_len,
	s01_ar_size,
	s01_ar_burst,
	s01_ar_lock,
	s01_ar_cache,
	s01_ar_qos,
	s01_ar_id,
	s01_ar_user,
	s01_ar_ready,
	s01_ar_valid,
	s01_w_valid,
	s01_w_data,
	s01_w_strb,
	s01_w_user,
	s01_w_last,
	s01_w_ready,
	s01_r_data,
	s01_r_resp,
	s01_r_last,
	s01_r_id,
	s01_r_user,
	s01_r_ready,
	s01_r_valid,
	s01_b_resp,
	s01_b_id,
	s01_b_user,
	s01_b_ready,
	s01_b_valid,
	s02_aw_addr,
	s02_aw_prot,
	s02_aw_region,
	s02_aw_len,
	s02_aw_size,
	s02_aw_burst,
	s02_aw_lock,
	s02_aw_cache,
	s02_aw_qos,
	s02_aw_id,
	s02_aw_user,
	s02_aw_ready,
	s02_aw_valid,
	s02_ar_addr,
	s02_ar_prot,
	s02_ar_region,
	s02_ar_len,
	s02_ar_size,
	s02_ar_burst,
	s02_ar_lock,
	s02_ar_cache,
	s02_ar_qos,
	s02_ar_id,
	s02_ar_user,
	s02_ar_ready,
	s02_ar_valid,
	s02_w_valid,
	s02_w_data,
	s02_w_strb,
	s02_w_user,
	s02_w_last,
	s02_w_ready,
	s02_r_data,
	s02_r_resp,
	s02_r_last,
	s02_r_id,
	s02_r_user,
	s02_r_ready,
	s02_r_valid,
	s02_b_resp,
	s02_b_id,
	s02_b_user,
	s02_b_ready,
	s02_b_valid,
	m00_aw_addr,
	m00_aw_prot,
	m00_aw_region,
	m00_aw_len,
	m00_aw_size,
	m00_aw_burst,
	m00_aw_lock,
	m00_aw_cache,
	m00_aw_qos,
	m00_aw_id,
	m00_aw_user,
	m00_aw_ready,
	m00_aw_valid,
	m00_ar_addr,
	m00_ar_prot,
	m00_ar_region,
	m00_ar_len,
	m00_ar_size,
	m00_ar_burst,
	m00_ar_lock,
	m00_ar_cache,
	m00_ar_qos,
	m00_ar_id,
	m00_ar_user,
	m00_ar_ready,
	m00_ar_valid,
	m00_w_valid,
	m00_w_data,
	m00_w_strb,
	m00_w_user,
	m00_w_last,
	m00_w_ready,
	m00_r_data,
	m00_r_resp,
	m00_r_last,
	m00_r_id,
	m00_r_user,
	m00_r_ready,
	m00_r_valid,
	m00_b_resp,
	m00_b_id,
	m00_b_user,
	m00_b_ready,
	m00_b_valid,
	m01_aw_addr,
	m01_aw_prot,
	m01_aw_region,
	m01_aw_len,
	m01_aw_size,
	m01_aw_burst,
	m01_aw_lock,
	m01_aw_cache,
	m01_aw_qos,
	m01_aw_id,
	m01_aw_user,
	m01_aw_ready,
	m01_aw_valid,
	m01_ar_addr,
	m01_ar_prot,
	m01_ar_region,
	m01_ar_len,
	m01_ar_size,
	m01_ar_burst,
	m01_ar_lock,
	m01_ar_cache,
	m01_ar_qos,
	m01_ar_id,
	m01_ar_user,
	m01_ar_ready,
	m01_ar_valid,
	m01_w_valid,
	m01_w_data,
	m01_w_strb,
	m01_w_user,
	m01_w_last,
	m01_w_ready,
	m01_r_data,
	m01_r_resp,
	m01_r_last,
	m01_r_id,
	m01_r_user,
	m01_r_ready,
	m01_r_valid,
	m01_b_resp,
	m01_b_id,
	m01_b_user,
	m01_b_ready,
	m01_b_valid,
	m02_aw_addr,
	m02_aw_prot,
	m02_aw_region,
	m02_aw_len,
	m02_aw_size,
	m02_aw_burst,
	m02_aw_lock,
	m02_aw_cache,
	m02_aw_qos,
	m02_aw_id,
	m02_aw_user,
	m02_aw_ready,
	m02_aw_valid,
	m02_ar_addr,
	m02_ar_prot,
	m02_ar_region,
	m02_ar_len,
	m02_ar_size,
	m02_ar_burst,
	m02_ar_lock,
	m02_ar_cache,
	m02_ar_qos,
	m02_ar_id,
	m02_ar_user,
	m02_ar_ready,
	m02_ar_valid,
	m02_w_valid,
	m02_w_data,
	m02_w_strb,
	m02_w_user,
	m02_w_last,
	m02_w_ready,
	m02_r_data,
	m02_r_resp,
	m02_r_last,
	m02_r_id,
	m02_r_user,
	m02_r_ready,
	m02_r_valid,
	m02_b_resp,
	m02_b_id,
	m02_b_user,
	m02_b_ready,
	m02_b_valid,
	start_addr_i,
	end_addr_i
);
	//parameter NB_MASTER = 3;
	//parameter NB_SLAVE = 3;
	//parameter AXI_ADDR_WIDTH = 32;
	//parameter AXI_DATA_WIDTH = 32;
	//parameter AXI_ID_WIDTH = 10;
	//parameter AXI_USER_WIDTH = 0;
localparam AXI_ID_WIDTH_TARG = AXI_ID_WIDTH;
localparam AXI_ID_WIDTH_INIT = AXI_ID_WIDTH_TARG + $clog2(NB_SLAVE);
	parameter AXI_STRB_WIDTH = AXI_DATA_WIDTH / 8;
	input wire clk;
	input wire rst_n;
	input wire test_en_i;
	input wire [AXI_ADDR_WIDTH - 1:0] s00_aw_addr;
	input wire [2:0] s00_aw_prot;
	input wire [3:0] s00_aw_region;
	input wire [7:0] s00_aw_len;
	input wire [2:0] s00_aw_size;
	input wire [1:0] s00_aw_burst;
	input wire s00_aw_lock;
	input wire [3:0] s00_aw_cache;
	input wire [3:0] s00_aw_qos;
	input wire [AXI_ID_WIDTH_TARG - 1:0] s00_aw_id;
	input wire [AXI_USER_WIDTH - 1:0] s00_aw_user;
	output wire s00_aw_ready;
	input wire s00_aw_valid;
	input wire [AXI_ADDR_WIDTH - 1:0] s00_ar_addr;
	input wire [2:0] s00_ar_prot;
	input wire [3:0] s00_ar_region;
	input wire [7:0] s00_ar_len;
	input wire [2:0] s00_ar_size;
	input wire [1:0] s00_ar_burst;
	input wire s00_ar_lock;
	input wire [3:0] s00_ar_cache;
	input wire [3:0] s00_ar_qos;
	input wire [AXI_ID_WIDTH_TARG - 1:0] s00_ar_id;
	input wire [AXI_USER_WIDTH - 1:0] s00_ar_user;
	output wire s00_ar_ready;
	input wire s00_ar_valid;
	input wire s00_w_valid;
	input wire [AXI_DATA_WIDTH - 1:0] s00_w_data;
	input wire [AXI_STRB_WIDTH - 1:0] s00_w_strb;
	input wire [AXI_USER_WIDTH - 1:0] s00_w_user;
	input wire s00_w_last;
	output wire s00_w_ready;
	output wire [AXI_DATA_WIDTH - 1:0] s00_r_data;
	output wire [1:0] s00_r_resp;
	output wire s00_r_last;
	output wire [AXI_ID_WIDTH_TARG - 1:0] s00_r_id;
	output wire [AXI_USER_WIDTH - 1:0] s00_r_user;
	input wire s00_r_ready;
	output wire s00_r_valid;
	output wire [1:0] s00_b_resp;
	output wire [AXI_ID_WIDTH_TARG - 1:0] s00_b_id;
	output wire [AXI_USER_WIDTH - 1:0] s00_b_user;
	input wire s00_b_ready;
	output wire s00_b_valid;
	input wire [AXI_ADDR_WIDTH - 1:0] s01_aw_addr;
	input wire [2:0] s01_aw_prot;
	input wire [3:0] s01_aw_region;
	input wire [7:0] s01_aw_len;
	input wire [2:0] s01_aw_size;
	input wire [1:0] s01_aw_burst;
	input wire s01_aw_lock;
	input wire [3:0] s01_aw_cache;
	input wire [3:0] s01_aw_qos;
	input wire [AXI_ID_WIDTH_TARG - 1:0] s01_aw_id;
	input wire [AXI_USER_WIDTH - 1:0] s01_aw_user;
	output wire s01_aw_ready;
	input wire s01_aw_valid;
	input wire [AXI_ADDR_WIDTH - 1:0] s01_ar_addr;
	input wire [2:0] s01_ar_prot;
	input wire [3:0] s01_ar_region;
	input wire [7:0] s01_ar_len;
	input wire [2:0] s01_ar_size;
	input wire [1:0] s01_ar_burst;
	input wire s01_ar_lock;
	input wire [3:0] s01_ar_cache;
	input wire [3:0] s01_ar_qos;
	input wire [AXI_ID_WIDTH_TARG - 1:0] s01_ar_id;
	input wire [AXI_USER_WIDTH - 1:0] s01_ar_user;
	output wire s01_ar_ready;
	input wire s01_ar_valid;
	input wire s01_w_valid;
	input wire [AXI_DATA_WIDTH - 1:0] s01_w_data;
	input wire [AXI_STRB_WIDTH - 1:0] s01_w_strb;
	input wire [AXI_USER_WIDTH - 1:0] s01_w_user;
	input wire s01_w_last;
	output wire s01_w_ready;
	output wire [AXI_DATA_WIDTH - 1:0] s01_r_data;
	output wire [1:0] s01_r_resp;
	output wire s01_r_last;
	output wire [AXI_ID_WIDTH_TARG - 1:0] s01_r_id;
	output wire [AXI_USER_WIDTH - 1:0] s01_r_user;
	input wire s01_r_ready;
	output wire s01_r_valid;
	output wire [1:0] s01_b_resp;
	output wire [AXI_ID_WIDTH_TARG - 1:0] s01_b_id;
	output wire [AXI_USER_WIDTH - 1:0] s01_b_user;
	input wire s01_b_ready;
	output wire s01_b_valid;
	input wire [AXI_ADDR_WIDTH - 1:0] s02_aw_addr;
	input wire [2:0] s02_aw_prot;
	input wire [3:0] s02_aw_region;
	input wire [7:0] s02_aw_len;
	input wire [2:0] s02_aw_size;
	input wire [1:0] s02_aw_burst;
	input wire s02_aw_lock;
	input wire [3:0] s02_aw_cache;
	input wire [3:0] s02_aw_qos;
	input wire [AXI_ID_WIDTH_TARG - 1:0] s02_aw_id;
	input wire [AXI_USER_WIDTH - 1:0] s02_aw_user;
	output wire s02_aw_ready;
	input wire s02_aw_valid;
	input wire [AXI_ADDR_WIDTH - 1:0] s02_ar_addr;
	input wire [2:0] s02_ar_prot;
	input wire [3:0] s02_ar_region;
	input wire [7:0] s02_ar_len;
	input wire [2:0] s02_ar_size;
	input wire [1:0] s02_ar_burst;
	input wire s02_ar_lock;
	input wire [3:0] s02_ar_cache;
	input wire [3:0] s02_ar_qos;
	input wire [AXI_ID_WIDTH_TARG - 1:0] s02_ar_id;
	input wire [AXI_USER_WIDTH - 1:0] s02_ar_user;
	output wire s02_ar_ready;
	input wire s02_ar_valid;
	input wire s02_w_valid;
	input wire [AXI_DATA_WIDTH - 1:0] s02_w_data;
	input wire [AXI_STRB_WIDTH - 1:0] s02_w_strb;
	input wire [AXI_USER_WIDTH - 1:0] s02_w_user;
	input wire s02_w_last;
	output wire s02_w_ready;
	output wire [AXI_DATA_WIDTH - 1:0] s02_r_data;
	output wire [1:0] s02_r_resp;
	output wire s02_r_last;
	output wire [AXI_ID_WIDTH_TARG - 1:0] s02_r_id;
	output wire [AXI_USER_WIDTH - 1:0] s02_r_user;
	input wire s02_r_ready;
	output wire s02_r_valid;
	output wire [1:0] s02_b_resp;
	output wire [AXI_ID_WIDTH_TARG - 1:0] s02_b_id;
	output wire [AXI_USER_WIDTH - 1:0] s02_b_user;
	input wire s02_b_ready;
	output wire s02_b_valid;
	output wire [AXI_ADDR_WIDTH - 1:0] m00_aw_addr;
	output wire [2:0] m00_aw_prot;
	output wire [3:0] m00_aw_region;
	output wire [7:0] m00_aw_len;
	output wire [2:0] m00_aw_size;
	output wire [1:0] m00_aw_burst;
	output wire m00_aw_lock;
	output wire [3:0] m00_aw_cache;
	output wire [3:0] m00_aw_qos;
	output wire [AXI_ID_WIDTH_INIT - 1:0] m00_aw_id;
	output wire [AXI_USER_WIDTH - 1:0] m00_aw_user;
	input wire m00_aw_ready;
	output wire m00_aw_valid;
	output wire [AXI_ADDR_WIDTH - 1:0] m00_ar_addr;
	output wire [2:0] m00_ar_prot;
	output wire [3:0] m00_ar_region;
	output wire [7:0] m00_ar_len;
	output wire [2:0] m00_ar_size;
	output wire [1:0] m00_ar_burst;
	output wire m00_ar_lock;
	output wire [3:0] m00_ar_cache;
	output wire [3:0] m00_ar_qos;
	output wire [AXI_ID_WIDTH_INIT - 1:0] m00_ar_id;
	output wire [AXI_USER_WIDTH - 1:0] m00_ar_user;
	input wire m00_ar_ready;
	output wire m00_ar_valid;
	output wire m00_w_valid;
	output wire [AXI_DATA_WIDTH - 1:0] m00_w_data;
	output wire [AXI_STRB_WIDTH - 1:0] m00_w_strb;
	output wire [AXI_USER_WIDTH - 1:0] m00_w_user;
	output wire m00_w_last;
	input wire m00_w_ready;
	input wire [AXI_DATA_WIDTH - 1:0] m00_r_data;
	input wire [1:0] m00_r_resp;
	input wire m00_r_last;
	input wire [AXI_ID_WIDTH_INIT - 1:0] m00_r_id;
	input wire [AXI_USER_WIDTH - 1:0] m00_r_user;
	output wire m00_r_ready;
	input wire m00_r_valid;
	input wire [1:0] m00_b_resp;
	input wire [AXI_ID_WIDTH_INIT - 1:0] m00_b_id;
	input wire [AXI_USER_WIDTH - 1:0] m00_b_user;
	output wire m00_b_ready;
	input wire m00_b_valid;
	output wire [AXI_ADDR_WIDTH - 1:0] m01_aw_addr;
	output wire [2:0] m01_aw_prot;
	output wire [3:0] m01_aw_region;
	output wire [7:0] m01_aw_len;
	output wire [2:0] m01_aw_size;
	output wire [1:0] m01_aw_burst;
	output wire m01_aw_lock;
	output wire [3:0] m01_aw_cache;
	output wire [3:0] m01_aw_qos;
	output wire [AXI_ID_WIDTH_INIT - 1:0] m01_aw_id;
	output wire [AXI_USER_WIDTH - 1:0] m01_aw_user;
	input wire m01_aw_ready;
	output wire m01_aw_valid;
	output wire [AXI_ADDR_WIDTH - 1:0] m01_ar_addr;
	output wire [2:0] m01_ar_prot;
	output wire [3:0] m01_ar_region;
	output wire [7:0] m01_ar_len;
	output wire [2:0] m01_ar_size;
	output wire [1:0] m01_ar_burst;
	output wire m01_ar_lock;
	output wire [3:0] m01_ar_cache;
	output wire [3:0] m01_ar_qos;
	output wire [AXI_ID_WIDTH_INIT - 1:0] m01_ar_id;
	output wire [AXI_USER_WIDTH - 1:0] m01_ar_user;
	input wire m01_ar_ready;
	output wire m01_ar_valid;
	output wire m01_w_valid;
	output wire [AXI_DATA_WIDTH - 1:0] m01_w_data;
	output wire [AXI_STRB_WIDTH - 1:0] m01_w_strb;
	output wire [AXI_USER_WIDTH - 1:0] m01_w_user;
	output wire m01_w_last;
	input wire m01_w_ready;
	input wire [AXI_DATA_WIDTH - 1:0] m01_r_data;
	input wire [1:0] m01_r_resp;
	input wire m01_r_last;
	input wire [AXI_ID_WIDTH_INIT - 1:0] m01_r_id;
	input wire [AXI_USER_WIDTH - 1:0] m01_r_user;
	output wire m01_r_ready;
	input wire m01_r_valid;
	input wire [1:0] m01_b_resp;
	input wire [AXI_ID_WIDTH_INIT - 1:0] m01_b_id;
	input wire [AXI_USER_WIDTH - 1:0] m01_b_user;
	output wire m01_b_ready;
	input wire m01_b_valid;
	output wire [AXI_ADDR_WIDTH - 1:0] m02_aw_addr;
	output wire [2:0] m02_aw_prot;
	output wire [3:0] m02_aw_region;
	output wire [7:0] m02_aw_len;
	output wire [2:0] m02_aw_size;
	output wire [1:0] m02_aw_burst;
	output wire m02_aw_lock;
	output wire [3:0] m02_aw_cache;
	output wire [3:0] m02_aw_qos;
	output wire [AXI_ID_WIDTH_INIT - 1:0] m02_aw_id;
	output wire [AXI_USER_WIDTH - 1:0] m02_aw_user;
	input wire m02_aw_ready;
	output wire m02_aw_valid;
	output wire [AXI_ADDR_WIDTH - 1:0] m02_ar_addr;
	output wire [2:0] m02_ar_prot;
	output wire [3:0] m02_ar_region;
	output wire [7:0] m02_ar_len;
	output wire [2:0] m02_ar_size;
	output wire [1:0] m02_ar_burst;
	output wire m02_ar_lock;
	output wire [3:0] m02_ar_cache;
	output wire [3:0] m02_ar_qos;
	output wire [AXI_ID_WIDTH_INIT - 1:0] m02_ar_id;
	output wire [AXI_USER_WIDTH - 1:0] m02_ar_user;
	input wire m02_ar_ready;
	output wire m02_ar_valid;
	output wire m02_w_valid;
	output wire [AXI_DATA_WIDTH - 1:0] m02_w_data;
	output wire [AXI_STRB_WIDTH - 1:0] m02_w_strb;
	output wire [AXI_USER_WIDTH - 1:0] m02_w_user;
	output wire m02_w_last;
	input wire m02_w_ready;
	input wire [AXI_DATA_WIDTH - 1:0] m02_r_data;
	input wire [1:0] m02_r_resp;
	input wire m02_r_last;
	input wire [AXI_ID_WIDTH_INIT - 1:0] m02_r_id;
	input wire [AXI_USER_WIDTH - 1:0] m02_r_user;
	output wire m02_r_ready;
	input wire m02_r_valid;
	input wire [1:0] m02_b_resp;
	input wire [AXI_ID_WIDTH_INIT - 1:0] m02_b_id;
	input wire [AXI_USER_WIDTH - 1:0] m02_b_user;
	output wire m02_b_ready;
	input wire m02_b_valid;
	input wire [(NB_MASTER * AXI_ADDR_WIDTH) - 1:0] start_addr_i;
	input wire [(NB_MASTER * AXI_ADDR_WIDTH) - 1:0] end_addr_i;
	localparam NB_REGION = 1;

	wire [(NB_MASTER * AXI_ID_WIDTH_INIT) - 1:0] s_master_aw_id;
	wire [(NB_MASTER * AXI_ADDR_WIDTH) - 1:0] s_master_aw_addr;
	wire [(NB_MASTER * 8) - 1:0] s_master_aw_len;
	wire [(NB_MASTER * 3) - 1:0] s_master_aw_size;
	wire [(NB_MASTER * 2) - 1:0] s_master_aw_burst;
	wire [NB_MASTER - 1:0] s_master_aw_lock;
	wire [(NB_MASTER * 4) - 1:0] s_master_aw_cache;
	wire [(NB_MASTER * 3) - 1:0] s_master_aw_prot;
	wire [(NB_MASTER * 4) - 1:0] s_master_aw_region;
	wire [(NB_MASTER * AXI_USER_WIDTH) - 1:0] s_master_aw_user;
	wire [(NB_MASTER * 4) - 1:0] s_master_aw_qos;
	wire [NB_MASTER - 1:0] s_master_aw_valid;
	wire [NB_MASTER - 1:0] s_master_aw_ready;
	wire [(NB_MASTER * AXI_ID_WIDTH_INIT) - 1:0] s_master_ar_id;
	wire [(NB_MASTER * AXI_ADDR_WIDTH) - 1:0] s_master_ar_addr;
	wire [(NB_MASTER * 8) - 1:0] s_master_ar_len;
	wire [(NB_MASTER * 3) - 1:0] s_master_ar_size;
	wire [(NB_MASTER * 2) - 1:0] s_master_ar_burst;
	wire [NB_MASTER - 1:0] s_master_ar_lock;
	wire [(NB_MASTER * 4) - 1:0] s_master_ar_cache;
	wire [(NB_MASTER * 3) - 1:0] s_master_ar_prot;
	wire [(NB_MASTER * 4) - 1:0] s_master_ar_region;
	wire [(NB_MASTER * AXI_USER_WIDTH) - 1:0] s_master_ar_user;
	wire [(NB_MASTER * 4) - 1:0] s_master_ar_qos;
	wire [NB_MASTER - 1:0] s_master_ar_valid;
	wire [NB_MASTER - 1:0] s_master_ar_ready;
	wire [(NB_MASTER * AXI_DATA_WIDTH) - 1:0] s_master_w_data;
	wire [(NB_MASTER * AXI_STRB_WIDTH) - 1:0] s_master_w_strb;
	wire [NB_MASTER - 1:0] s_master_w_last;
	wire [(NB_MASTER * AXI_USER_WIDTH) - 1:0] s_master_w_user;
	wire [NB_MASTER - 1:0] s_master_w_valid;
	wire [NB_MASTER - 1:0] s_master_w_ready;
	wire [(NB_MASTER * AXI_ID_WIDTH_INIT) - 1:0] s_master_b_id;
	wire [(NB_MASTER * 2) - 1:0] s_master_b_resp;
	wire [NB_MASTER - 1:0] s_master_b_valid;
	wire [(NB_MASTER * AXI_USER_WIDTH) - 1:0] s_master_b_user;
	wire [NB_MASTER - 1:0] s_master_b_ready;
	wire [(NB_MASTER * AXI_ID_WIDTH_INIT) - 1:0] s_master_r_id;
	wire [(NB_MASTER * AXI_DATA_WIDTH) - 1:0] s_master_r_data;
	wire [(NB_MASTER * 2) - 1:0] s_master_r_resp;
	wire [NB_MASTER - 1:0] s_master_r_last;
	wire [(NB_MASTER * AXI_USER_WIDTH) - 1:0] s_master_r_user;
	wire [NB_MASTER - 1:0] s_master_r_valid;
	wire [NB_MASTER - 1:0] s_master_r_ready;
	wire [(NB_SLAVE * AXI_ID_WIDTH_TARG) - 1:0] s_slave_aw_id;
	wire [(NB_SLAVE * AXI_ADDR_WIDTH) - 1:0] s_slave_aw_addr;
	wire [(NB_SLAVE * 8) - 1:0] s_slave_aw_len;
	wire [(NB_SLAVE * 3) - 1:0] s_slave_aw_size;
	wire [(NB_SLAVE * 2) - 1:0] s_slave_aw_burst;
	wire [NB_SLAVE - 1:0] s_slave_aw_lock;
	wire [(NB_SLAVE * 4) - 1:0] s_slave_aw_cache;
	wire [(NB_SLAVE * 3) - 1:0] s_slave_aw_prot;
	wire [(NB_SLAVE * 4) - 1:0] s_slave_aw_region;
	wire [(NB_SLAVE * AXI_USER_WIDTH) - 1:0] s_slave_aw_user;
	wire [(NB_SLAVE * 4) - 1:0] s_slave_aw_qos;
	wire [NB_SLAVE - 1:0] s_slave_aw_valid;
	wire [NB_SLAVE - 1:0] s_slave_aw_ready;
	wire [(NB_SLAVE * AXI_ID_WIDTH_TARG) - 1:0] s_slave_ar_id;
	wire [(NB_SLAVE * AXI_ADDR_WIDTH) - 1:0] s_slave_ar_addr;
	wire [(NB_SLAVE * 8) - 1:0] s_slave_ar_len;
	wire [(NB_SLAVE * 3) - 1:0] s_slave_ar_size;
	wire [(NB_SLAVE * 2) - 1:0] s_slave_ar_burst;
	wire [NB_SLAVE - 1:0] s_slave_ar_lock;
	wire [(NB_SLAVE * 4) - 1:0] s_slave_ar_cache;
	wire [(NB_SLAVE * 3) - 1:0] s_slave_ar_prot;
	wire [(NB_SLAVE * 4) - 1:0] s_slave_ar_region;
	wire [(NB_SLAVE * AXI_USER_WIDTH) - 1:0] s_slave_ar_user;
	wire [(NB_SLAVE * 4) - 1:0] s_slave_ar_qos;
	wire [NB_SLAVE - 1:0] s_slave_ar_valid;
	wire [NB_SLAVE - 1:0] s_slave_ar_ready;
	wire [(NB_SLAVE * AXI_DATA_WIDTH) - 1:0] s_slave_w_data;
	wire [(NB_SLAVE * AXI_STRB_WIDTH) - 1:0] s_slave_w_strb;
	wire [NB_SLAVE - 1:0] s_slave_w_last;
	wire [(NB_SLAVE * AXI_USER_WIDTH) - 1:0] s_slave_w_user;
	wire [NB_SLAVE - 1:0] s_slave_w_valid;
	wire [NB_SLAVE - 1:0] s_slave_w_ready;
	wire [(NB_SLAVE * AXI_ID_WIDTH_TARG) - 1:0] s_slave_b_id;
	wire [(NB_SLAVE * 2) - 1:0] s_slave_b_resp;
	wire [NB_SLAVE - 1:0] s_slave_b_valid;
	wire [(NB_SLAVE * AXI_USER_WIDTH) - 1:0] s_slave_b_user;
	wire [NB_SLAVE - 1:0] s_slave_b_ready;
	wire [(NB_SLAVE * AXI_ID_WIDTH_TARG) - 1:0] s_slave_r_id;
	wire [(NB_SLAVE * AXI_DATA_WIDTH) - 1:0] s_slave_r_data;
	wire [(NB_SLAVE * 2) - 1:0] s_slave_r_resp;
	wire [NB_SLAVE - 1:0] s_slave_r_last;
	wire [(NB_SLAVE * AXI_USER_WIDTH) - 1:0] s_slave_r_user;
	wire [NB_SLAVE - 1:0] s_slave_r_valid;
	wire [NB_SLAVE - 1:0] s_slave_r_ready;
	wire [(NB_MASTER * AXI_ADDR_WIDTH) - 1:0] s_start_addr;
	wire [(NB_MASTER * AXI_ADDR_WIDTH) - 1:0] s_end_addr;
	wire [NB_MASTER - 1:0] s_valid_rule;
	wire [(NB_SLAVE * NB_MASTER) - 1:0] s_connectivity_map;
	assign m00_aw_id[AXI_ID_WIDTH_INIT - 1:0] = s_master_aw_id[0+:AXI_ID_WIDTH_INIT];
	assign m00_aw_addr = s_master_aw_addr[0+:AXI_ADDR_WIDTH];
	assign m00_aw_len = s_master_aw_len[0+:8];
	assign m00_aw_size = s_master_aw_size[0+:3];
	assign m00_aw_burst = s_master_aw_burst[0+:2];
	assign m00_aw_lock = s_master_aw_lock[0];
	assign m00_aw_cache = s_master_aw_cache[0+:4];
	assign m00_aw_prot = s_master_aw_prot[0+:3];
	assign m00_aw_region = s_master_aw_region[0+:4];
	assign m00_aw_user = s_master_aw_user[0+:AXI_USER_WIDTH];
	assign m00_aw_qos = s_master_aw_qos[0+:4];
	assign m00_aw_valid = s_master_aw_valid[0];
	assign s_master_aw_ready[0] = m00_aw_ready;
	assign m00_ar_id[AXI_ID_WIDTH_INIT - 1:0] = s_master_ar_id[0+:AXI_ID_WIDTH_INIT];
	assign m00_ar_addr = s_master_ar_addr[0+:AXI_ADDR_WIDTH];
	assign m00_ar_len = s_master_ar_len[0+:8];
	assign m00_ar_size = s_master_ar_size[0+:3];
	assign m00_ar_burst = s_master_ar_burst[0+:2];
	assign m00_ar_lock = s_master_ar_lock[0];
	assign m00_ar_cache = s_master_ar_cache[0+:4];
	assign m00_ar_prot = s_master_ar_prot[0+:3];
	assign m00_ar_region = s_master_ar_region[0+:4];
	assign m00_ar_user = s_master_ar_user[0+:AXI_USER_WIDTH];
	assign m00_ar_qos = s_master_ar_qos[0+:4];
	assign m00_ar_valid = s_master_ar_valid[0];
	assign s_master_ar_ready[0] = m00_ar_ready;
	assign m00_w_data = s_master_w_data[0+:AXI_DATA_WIDTH];
	assign m00_w_strb = s_master_w_strb[0+:AXI_STRB_WIDTH];
	assign m00_w_last = s_master_w_last[0];
	assign m00_w_user = s_master_w_user[0+:AXI_USER_WIDTH];
	assign m00_w_valid = s_master_w_valid[0];
	assign s_master_w_ready[0] = m00_w_ready;
	assign s_master_b_id[0+:AXI_ID_WIDTH_INIT] = m00_b_id[AXI_ID_WIDTH_INIT - 1:0];
	assign s_master_b_resp[0+:2] = m00_b_resp;
	assign s_master_b_valid[0] = m00_b_valid;
	assign s_master_b_user[0+:AXI_USER_WIDTH] = m00_b_user;
	assign m00_b_ready = s_master_b_ready[0];
	assign s_master_r_id[0+:AXI_ID_WIDTH_INIT] = m00_r_id[AXI_ID_WIDTH_INIT - 1:0];
	assign s_master_r_data[0+:AXI_DATA_WIDTH] = m00_r_data;
	assign s_master_r_resp[0+:2] = m00_r_resp;
	assign s_master_r_last[0] = m00_r_last;
	assign s_master_r_user[0+:AXI_USER_WIDTH] = m00_r_user;
	assign s_master_r_valid[0] = m00_r_valid;
	assign m00_r_ready = s_master_r_ready[0];
	assign s_start_addr[0+:AXI_ADDR_WIDTH] = start_addr_i[0+:AXI_ADDR_WIDTH];
	assign s_end_addr[0+:AXI_ADDR_WIDTH] = end_addr_i[0+:AXI_ADDR_WIDTH];
	assign m01_aw_id[AXI_ID_WIDTH_INIT - 1:0] = s_master_aw_id[AXI_ID_WIDTH_INIT+:AXI_ID_WIDTH_INIT];
	assign m01_aw_addr = s_master_aw_addr[AXI_ADDR_WIDTH+:AXI_ADDR_WIDTH];
	assign m01_aw_len = s_master_aw_len[8+:8];
	assign m01_aw_size = s_master_aw_size[3+:3];
	assign m01_aw_burst = s_master_aw_burst[2+:2];
	assign m01_aw_lock = s_master_aw_lock[1];
	assign m01_aw_cache = s_master_aw_cache[4+:4];
	assign m01_aw_prot = s_master_aw_prot[3+:3];
	assign m01_aw_region = s_master_aw_region[4+:4];
	assign m01_aw_user = s_master_aw_user[AXI_USER_WIDTH+:AXI_USER_WIDTH];
	assign m01_aw_qos = s_master_aw_qos[4+:4];
	assign m01_aw_valid = s_master_aw_valid[1];
	assign s_master_aw_ready[1] = m01_aw_ready;
	assign m01_ar_id[AXI_ID_WIDTH_INIT - 1:0] = s_master_ar_id[AXI_ID_WIDTH_INIT+:AXI_ID_WIDTH_INIT];
	assign m01_ar_addr = s_master_ar_addr[AXI_ADDR_WIDTH+:AXI_ADDR_WIDTH];
	assign m01_ar_len = s_master_ar_len[8+:8];
	assign m01_ar_size = s_master_ar_size[3+:3];
	assign m01_ar_burst = s_master_ar_burst[2+:2];
	assign m01_ar_lock = s_master_ar_lock[1];
	assign m01_ar_cache = s_master_ar_cache[4+:4];
	assign m01_ar_prot = s_master_ar_prot[3+:3];
	assign m01_ar_region = s_master_ar_region[4+:4];
	assign m01_ar_user = s_master_ar_user[AXI_USER_WIDTH+:AXI_USER_WIDTH];
	assign m01_ar_qos = s_master_ar_qos[4+:4];
	assign m01_ar_valid = s_master_ar_valid[1];
	assign s_master_ar_ready[1] = m01_ar_ready;
	assign m01_w_data = s_master_w_data[AXI_DATA_WIDTH+:AXI_DATA_WIDTH];
	assign m01_w_strb = s_master_w_strb[AXI_STRB_WIDTH+:AXI_STRB_WIDTH];
	assign m01_w_last = s_master_w_last[1];
	assign m01_w_user = s_master_w_user[AXI_USER_WIDTH+:AXI_USER_WIDTH];
	assign m01_w_valid = s_master_w_valid[1];
	assign s_master_w_ready[1] = m01_w_ready;
	assign s_master_b_id[AXI_ID_WIDTH_INIT+:AXI_ID_WIDTH_INIT] = m01_b_id[AXI_ID_WIDTH_INIT - 1:0];
	assign s_master_b_resp[2+:2] = m01_b_resp;
	assign s_master_b_valid[1] = m01_b_valid;
	assign s_master_b_user[AXI_USER_WIDTH+:AXI_USER_WIDTH] = m01_b_user;
	assign m01_b_ready = s_master_b_ready[1];
	assign s_master_r_id[AXI_ID_WIDTH_INIT+:AXI_ID_WIDTH_INIT] = m01_r_id[AXI_ID_WIDTH_INIT - 1:0];
	assign s_master_r_data[AXI_DATA_WIDTH+:AXI_DATA_WIDTH] = m01_r_data;
	assign s_master_r_resp[2+:2] = m01_r_resp;
	assign s_master_r_last[1] = m01_r_last;
	assign s_master_r_user[AXI_USER_WIDTH+:AXI_USER_WIDTH] = m01_r_user;
	assign s_master_r_valid[1] = m01_r_valid;
	assign m01_r_ready = s_master_r_ready[1];
	assign s_start_addr[AXI_ADDR_WIDTH+:AXI_ADDR_WIDTH] = start_addr_i[AXI_ADDR_WIDTH+:AXI_ADDR_WIDTH];
	assign s_end_addr[AXI_ADDR_WIDTH+:AXI_ADDR_WIDTH] = end_addr_i[AXI_ADDR_WIDTH+:AXI_ADDR_WIDTH];
	assign m02_aw_id[AXI_ID_WIDTH_INIT - 1:0] = s_master_aw_id[2 * AXI_ID_WIDTH_INIT+:AXI_ID_WIDTH_INIT];
	assign m02_aw_addr = s_master_aw_addr[2 * AXI_ADDR_WIDTH+:AXI_ADDR_WIDTH];
	assign m02_aw_len = s_master_aw_len[16+:8];
	assign m02_aw_size = s_master_aw_size[6+:3];
	assign m02_aw_burst = s_master_aw_burst[4+:2];
	assign m02_aw_lock = s_master_aw_lock[2];
	assign m02_aw_cache = s_master_aw_cache[8+:4];
	assign m02_aw_prot = s_master_aw_prot[6+:3];
	assign m02_aw_region = s_master_aw_region[8+:4];
	assign m02_aw_user = s_master_aw_user[2 * AXI_USER_WIDTH+:AXI_USER_WIDTH];
	assign m02_aw_qos = s_master_aw_qos[8+:4];
	assign m02_aw_valid = s_master_aw_valid[2];
	assign s_master_aw_ready[2] = m02_aw_ready;
	assign m02_ar_id[AXI_ID_WIDTH_INIT - 1:0] = s_master_ar_id[2 * AXI_ID_WIDTH_INIT+:AXI_ID_WIDTH_INIT];
	assign m02_ar_addr = s_master_ar_addr[2 * AXI_ADDR_WIDTH+:AXI_ADDR_WIDTH];
	assign m02_ar_len = s_master_ar_len[16+:8];
	assign m02_ar_size = s_master_ar_size[6+:3];
	assign m02_ar_burst = s_master_ar_burst[4+:2];
	assign m02_ar_lock = s_master_ar_lock[2];
	assign m02_ar_cache = s_master_ar_cache[8+:4];
	assign m02_ar_prot = s_master_ar_prot[6+:3];
	assign m02_ar_region = s_master_ar_region[8+:4];
	assign m02_ar_user = s_master_ar_user[2 * AXI_USER_WIDTH+:AXI_USER_WIDTH];
	assign m02_ar_qos = s_master_ar_qos[8+:4];
	assign m02_ar_valid = s_master_ar_valid[2];
	assign s_master_ar_ready[2] = m02_ar_ready;
	assign m02_w_data = s_master_w_data[2 * AXI_DATA_WIDTH+:AXI_DATA_WIDTH];
	assign m02_w_strb = s_master_w_strb[2 * AXI_STRB_WIDTH+:AXI_STRB_WIDTH];
	assign m02_w_last = s_master_w_last[2];
	assign m02_w_user = s_master_w_user[2 * AXI_USER_WIDTH+:AXI_USER_WIDTH];
	assign m02_w_valid = s_master_w_valid[2];
	assign s_master_w_ready[2] = m02_w_ready;
	assign s_master_b_id[2 * AXI_ID_WIDTH_INIT+:AXI_ID_WIDTH_INIT] = m02_b_id[AXI_ID_WIDTH_INIT - 1:0];
	assign s_master_b_resp[4+:2] = m02_b_resp;
	assign s_master_b_valid[2] = m02_b_valid;
	assign s_master_b_user[2 * AXI_USER_WIDTH+:AXI_USER_WIDTH] = m02_b_user;
	assign m02_b_ready = s_master_b_ready[2];
	assign s_master_r_id[2 * AXI_ID_WIDTH_INIT+:AXI_ID_WIDTH_INIT] = m02_r_id[AXI_ID_WIDTH_INIT - 1:0];
	assign s_master_r_data[2 * AXI_DATA_WIDTH+:AXI_DATA_WIDTH] = m02_r_data;
	assign s_master_r_resp[4+:2] = m02_r_resp;
	assign s_master_r_last[2] = m02_r_last;
	assign s_master_r_user[2 * AXI_USER_WIDTH+:AXI_USER_WIDTH] = m02_r_user;
	assign s_master_r_valid[2] = m02_r_valid;
	assign m02_r_ready = s_master_r_ready[2];
	assign s_start_addr[2 * AXI_ADDR_WIDTH+:AXI_ADDR_WIDTH] = start_addr_i[2 * AXI_ADDR_WIDTH+:AXI_ADDR_WIDTH];
	assign s_end_addr[2 * AXI_ADDR_WIDTH+:AXI_ADDR_WIDTH] = end_addr_i[2 * AXI_ADDR_WIDTH+:AXI_ADDR_WIDTH];
	assign s_slave_aw_id[0+:AXI_ID_WIDTH_TARG] = s00_aw_id[AXI_ID_WIDTH_TARG - 1:0];
	assign s_slave_aw_addr[0+:AXI_ADDR_WIDTH] = s00_aw_addr;
	assign s_slave_aw_len[0+:8] = s00_aw_len;
	assign s_slave_aw_size[0+:3] = s00_aw_size;
	assign s_slave_aw_burst[0+:2] = s00_aw_burst;
	assign s_slave_aw_lock[0] = s00_aw_lock;
	assign s_slave_aw_cache[0+:4] = s00_aw_cache;
	assign s_slave_aw_prot[0+:3] = s00_aw_prot;
	assign s_slave_aw_region[0+:4] = s00_aw_region;
	assign s_slave_aw_user[0+:AXI_USER_WIDTH] = s00_aw_user;
	assign s_slave_aw_qos[0+:4] = s00_aw_qos;
	assign s_slave_aw_valid[0] = s00_aw_valid;
	assign s00_aw_ready = s_slave_aw_ready[0];
	assign s_slave_ar_id[0+:AXI_ID_WIDTH_TARG] = s00_ar_id[AXI_ID_WIDTH_TARG - 1:0];
	assign s_slave_ar_addr[0+:AXI_ADDR_WIDTH] = s00_ar_addr;
	assign s_slave_ar_len[0+:8] = s00_ar_len;
	assign s_slave_ar_size[0+:3] = s00_ar_size;
	assign s_slave_ar_burst[0+:2] = s00_ar_burst;
	assign s_slave_ar_lock[0] = s00_ar_lock;
	assign s_slave_ar_cache[0+:4] = s00_ar_cache;
	assign s_slave_ar_prot[0+:3] = s00_ar_prot;
	assign s_slave_ar_region[0+:4] = s00_ar_region;
	assign s_slave_ar_user[0+:AXI_USER_WIDTH] = s00_ar_user;
	assign s_slave_ar_qos[0+:4] = s00_ar_qos;
	assign s_slave_ar_valid[0] = s00_ar_valid;
	assign s00_ar_ready = s_slave_ar_ready[0];
	assign s_slave_w_data[0+:AXI_DATA_WIDTH] = s00_w_data;
	assign s_slave_w_strb[0+:AXI_STRB_WIDTH] = s00_w_strb;
	assign s_slave_w_last[0] = s00_w_last;
	assign s_slave_w_user[0+:AXI_USER_WIDTH] = s00_w_user;
	assign s_slave_w_valid[0] = s00_w_valid;
	assign s00_w_ready = s_slave_w_ready[0];
	assign s00_b_id[AXI_ID_WIDTH_TARG - 1:0] = s_slave_b_id[0+:AXI_ID_WIDTH_TARG];
	assign s00_b_resp = s_slave_b_resp[0+:2];
	assign s00_b_valid = s_slave_b_valid[0];
	assign s00_b_user = s_slave_b_user[0+:AXI_USER_WIDTH];
	assign s_slave_b_ready[0] = s00_b_ready;
	assign s00_r_id[AXI_ID_WIDTH_TARG - 1:0] = s_slave_r_id[0+:AXI_ID_WIDTH_TARG];
	assign s00_r_data = s_slave_r_data[0+:AXI_DATA_WIDTH];
	assign s00_r_resp = s_slave_r_resp[0+:2];
	assign s00_r_last = s_slave_r_last[0];
	assign s00_r_user = s_slave_r_user[0+:AXI_USER_WIDTH];
	assign s00_r_valid = s_slave_r_valid[0];
	assign s_slave_r_ready[0] = s00_r_ready;
	assign s_slave_aw_id[AXI_ID_WIDTH_TARG+:AXI_ID_WIDTH_TARG] = s01_aw_id[AXI_ID_WIDTH_TARG - 1:0];
	assign s_slave_aw_addr[AXI_ADDR_WIDTH+:AXI_ADDR_WIDTH] = s01_aw_addr;
	assign s_slave_aw_len[8+:8] = s01_aw_len;
	assign s_slave_aw_size[3+:3] = s01_aw_size;
	assign s_slave_aw_burst[2+:2] = s01_aw_burst;
	assign s_slave_aw_lock[1] = s01_aw_lock;
	assign s_slave_aw_cache[4+:4] = s01_aw_cache;
	assign s_slave_aw_prot[3+:3] = s01_aw_prot;
	assign s_slave_aw_region[4+:4] = s01_aw_region;
	assign s_slave_aw_user[AXI_USER_WIDTH+:AXI_USER_WIDTH] = s01_aw_user;
	assign s_slave_aw_qos[4+:4] = s01_aw_qos;
	assign s_slave_aw_valid[1] = s01_aw_valid;
	assign s01_aw_ready = s_slave_aw_ready[1];
	assign s_slave_ar_id[AXI_ID_WIDTH_TARG+:AXI_ID_WIDTH_TARG] = s01_ar_id[AXI_ID_WIDTH_TARG - 1:0];
	assign s_slave_ar_addr[AXI_ADDR_WIDTH+:AXI_ADDR_WIDTH] = s01_ar_addr;
	assign s_slave_ar_len[8+:8] = s01_ar_len;
	assign s_slave_ar_size[3+:3] = s01_ar_size;
	assign s_slave_ar_burst[2+:2] = s01_ar_burst;
	assign s_slave_ar_lock[1] = s01_ar_lock;
	assign s_slave_ar_cache[4+:4] = s01_ar_cache;
	assign s_slave_ar_prot[3+:3] = s01_ar_prot;
	assign s_slave_ar_region[4+:4] = s01_ar_region;
	assign s_slave_ar_user[AXI_USER_WIDTH+:AXI_USER_WIDTH] = s01_ar_user;
	assign s_slave_ar_qos[4+:4] = s01_ar_qos;
	assign s_slave_ar_valid[1] = s01_ar_valid;
	assign s01_ar_ready = s_slave_ar_ready[1];
	assign s_slave_w_data[AXI_DATA_WIDTH+:AXI_DATA_WIDTH] = s01_w_data;
	assign s_slave_w_strb[AXI_STRB_WIDTH+:AXI_STRB_WIDTH] = s01_w_strb;
	assign s_slave_w_last[1] = s01_w_last;
	assign s_slave_w_user[AXI_USER_WIDTH+:AXI_USER_WIDTH] = s01_w_user;
	assign s_slave_w_valid[1] = s01_w_valid;
	assign s01_w_ready = s_slave_w_ready[1];
	assign s01_b_id[AXI_ID_WIDTH_TARG - 1:0] = s_slave_b_id[AXI_ID_WIDTH_TARG+:AXI_ID_WIDTH_TARG];
	assign s01_b_resp = s_slave_b_resp[2+:2];
	assign s01_b_valid = s_slave_b_valid[1];
	assign s01_b_user = s_slave_b_user[AXI_USER_WIDTH+:AXI_USER_WIDTH];
	assign s_slave_b_ready[1] = s01_b_ready;
	assign s01_r_id[AXI_ID_WIDTH_TARG - 1:0] = s_slave_r_id[AXI_ID_WIDTH_TARG+:AXI_ID_WIDTH_TARG];
	assign s01_r_data = s_slave_r_data[AXI_DATA_WIDTH+:AXI_DATA_WIDTH];
	assign s01_r_resp = s_slave_r_resp[2+:2];
	assign s01_r_last = s_slave_r_last[1];
	assign s01_r_user = s_slave_r_user[AXI_USER_WIDTH+:AXI_USER_WIDTH];
	assign s01_r_valid = s_slave_r_valid[1];
	assign s_slave_r_ready[1] = s01_r_ready;
	assign s_slave_aw_id[2 * AXI_ID_WIDTH_TARG+:AXI_ID_WIDTH_TARG] = s02_aw_id[AXI_ID_WIDTH_TARG - 1:0];
	assign s_slave_aw_addr[2 * AXI_ADDR_WIDTH+:AXI_ADDR_WIDTH] = s02_aw_addr;
	assign s_slave_aw_len[16+:8] = s02_aw_len;
	assign s_slave_aw_size[6+:3] = s02_aw_size;
	assign s_slave_aw_burst[4+:2] = s02_aw_burst;
	assign s_slave_aw_lock[2] = s02_aw_lock;
	assign s_slave_aw_cache[8+:4] = s02_aw_cache;
	assign s_slave_aw_prot[6+:3] = s02_aw_prot;
	assign s_slave_aw_region[8+:4] = s02_aw_region;
	assign s_slave_aw_user[2 * AXI_USER_WIDTH+:AXI_USER_WIDTH] = s02_aw_user;
	assign s_slave_aw_qos[8+:4] = s02_aw_qos;
	assign s_slave_aw_valid[2] = s02_aw_valid;
	assign s02_aw_ready = s_slave_aw_ready[2];
	assign s_slave_ar_id[2 * AXI_ID_WIDTH_TARG+:AXI_ID_WIDTH_TARG] = s02_ar_id[AXI_ID_WIDTH_TARG - 1:0];
	assign s_slave_ar_addr[2 * AXI_ADDR_WIDTH+:AXI_ADDR_WIDTH] = s02_ar_addr;
	assign s_slave_ar_len[16+:8] = s02_ar_len;
	assign s_slave_ar_size[6+:3] = s02_ar_size;
	assign s_slave_ar_burst[4+:2] = s02_ar_burst;
	assign s_slave_ar_lock[2] = s02_ar_lock;
	assign s_slave_ar_cache[8+:4] = s02_ar_cache;
	assign s_slave_ar_prot[6+:3] = s02_ar_prot;
	assign s_slave_ar_region[8+:4] = s02_ar_region;
	assign s_slave_ar_user[2 * AXI_USER_WIDTH+:AXI_USER_WIDTH] = s02_ar_user;
	assign s_slave_ar_qos[8+:4] = s02_ar_qos;
	assign s_slave_ar_valid[2] = s02_ar_valid;
	assign s02_ar_ready = s_slave_ar_ready[2];
	assign s_slave_w_data[2 * AXI_DATA_WIDTH+:AXI_DATA_WIDTH] = s02_w_data;
	assign s_slave_w_strb[2 * AXI_STRB_WIDTH+:AXI_STRB_WIDTH] = s02_w_strb;
	assign s_slave_w_last[2] = s02_w_last;
	assign s_slave_w_user[2 * AXI_USER_WIDTH+:AXI_USER_WIDTH] = s02_w_user;
	assign s_slave_w_valid[2] = s02_w_valid;
	assign s02_w_ready = s_slave_w_ready[2];
	assign s02_b_id[AXI_ID_WIDTH_TARG - 1:0] = s_slave_b_id[2 * AXI_ID_WIDTH_TARG+:AXI_ID_WIDTH_TARG];
	assign s02_b_resp = s_slave_b_resp[4+:2];
	assign s02_b_valid = s_slave_b_valid[2];
	assign s02_b_user = s_slave_b_user[2 * AXI_USER_WIDTH+:AXI_USER_WIDTH];
	assign s_slave_b_ready[2] = s02_b_ready;
	assign s02_r_id[AXI_ID_WIDTH_TARG - 1:0] = s_slave_r_id[2 * AXI_ID_WIDTH_TARG+:AXI_ID_WIDTH_TARG];
	assign s02_r_data = s_slave_r_data[2 * AXI_DATA_WIDTH+:AXI_DATA_WIDTH];
	assign s02_r_resp = s_slave_r_resp[4+:2];
	assign s02_r_last = s_slave_r_last[2];
	assign s02_r_user = s_slave_r_user[2 * AXI_USER_WIDTH+:AXI_USER_WIDTH];
	assign s02_r_valid = s_slave_r_valid[2];
	assign s_slave_r_ready[2] = s02_r_ready;
	axi_node #(
		.AXI_ADDRESS_W(AXI_ADDR_WIDTH),
		.AXI_DATA_W(AXI_DATA_WIDTH),
		.N_MASTER_PORT(NB_MASTER),
		.N_SLAVE_PORT(NB_SLAVE),
		.AXI_ID_IN(AXI_ID_WIDTH_TARG),
		.AXI_USER_W(AXI_USER_WIDTH),
		.N_REGION(NB_REGION)
	) axi_node_i(
		.clk(clk),
		.rst_n(rst_n),
		.test_en_i(test_en_i),
		.slave_awid_i(s_slave_aw_id),
		.slave_awaddr_i(s_slave_aw_addr),
		.slave_awlen_i(s_slave_aw_len),
		.slave_awsize_i(s_slave_aw_size),
		.slave_awburst_i(s_slave_aw_burst),
		.slave_awlock_i(s_slave_aw_lock),
		.slave_awcache_i(s_slave_aw_cache),
		.slave_awprot_i(s_slave_aw_prot),
		.slave_awregion_i(s_slave_aw_region),
		.slave_awqos_i(s_slave_aw_qos),
		.slave_awuser_i(s_slave_aw_user),
		.slave_awvalid_i(s_slave_aw_valid),
		.slave_awready_o(s_slave_aw_ready),
		.slave_wdata_i(s_slave_w_data),
		.slave_wstrb_i(s_slave_w_strb),
		.slave_wlast_i(s_slave_w_last),
		.slave_wuser_i(s_slave_w_user),
		.slave_wvalid_i(s_slave_w_valid),
		.slave_wready_o(s_slave_w_ready),
		.slave_bid_o(s_slave_b_id),
		.slave_bresp_o(s_slave_b_resp),
		.slave_buser_o(s_slave_b_user),
		.slave_bvalid_o(s_slave_b_valid),
		.slave_bready_i(s_slave_b_ready),
		.slave_arid_i(s_slave_ar_id),
		.slave_araddr_i(s_slave_ar_addr),
		.slave_arlen_i(s_slave_ar_len),
		.slave_arsize_i(s_slave_ar_size),
		.slave_arburst_i(s_slave_ar_burst),
		.slave_arlock_i(s_slave_ar_lock),
		.slave_arcache_i(s_slave_ar_cache),
		.slave_arprot_i(s_slave_ar_prot),
		.slave_arregion_i(s_slave_ar_region),
		.slave_aruser_i(s_slave_ar_user),
		.slave_arqos_i(s_slave_ar_qos),
		.slave_arvalid_i(s_slave_ar_valid),
		.slave_arready_o(s_slave_ar_ready),
		.slave_rid_o(s_slave_r_id),
		.slave_rdata_o(s_slave_r_data),
		.slave_rresp_o(s_slave_r_resp),
		.slave_rlast_o(s_slave_r_last),
		.slave_ruser_o(s_slave_r_user),
		.slave_rvalid_o(s_slave_r_valid),
		.slave_rready_i(s_slave_r_ready),
		.master_awid_o(s_master_aw_id),
		.master_awaddr_o(s_master_aw_addr),
		.master_awlen_o(s_master_aw_len),
		.master_awsize_o(s_master_aw_size),
		.master_awburst_o(s_master_aw_burst),
		.master_awlock_o(s_master_aw_lock),
		.master_awcache_o(s_master_aw_cache),
		.master_awprot_o(s_master_aw_prot),
		.master_awregion_o(s_master_aw_region),
		.master_awqos_o(s_master_aw_qos),
		.master_awuser_o(s_master_aw_user),
		.master_awvalid_o(s_master_aw_valid),
		.master_awready_i(s_master_aw_ready),
		.master_wdata_o(s_master_w_data),
		.master_wstrb_o(s_master_w_strb),
		.master_wlast_o(s_master_w_last),
		.master_wuser_o(s_master_w_user),
		.master_wvalid_o(s_master_w_valid),
		.master_wready_i(s_master_w_ready),
		.master_bid_i(s_master_b_id),
		.master_bresp_i(s_master_b_resp),
		.master_buser_i(s_master_b_user),
		.master_bvalid_i(s_master_b_valid),
		.master_bready_o(s_master_b_ready),
		.master_arid_o(s_master_ar_id),
		.master_araddr_o(s_master_ar_addr),
		.master_arlen_o(s_master_ar_len),
		.master_arsize_o(s_master_ar_size),
		.master_arburst_o(s_master_ar_burst),
		.master_arlock_o(s_master_ar_lock),
		.master_arcache_o(s_master_ar_cache),
		.master_arprot_o(s_master_ar_prot),
		.master_arregion_o(s_master_ar_region),
		.master_aruser_o(s_master_ar_user),
		.master_arqos_o(s_master_ar_qos),
		.master_arvalid_o(s_master_ar_valid),
		.master_arready_i(s_master_ar_ready),
		.master_rid_i(s_master_r_id),
		.master_rdata_i(s_master_r_data),
		.master_rresp_i(s_master_r_resp),
		.master_rlast_i(s_master_r_last),
		.master_ruser_i(s_master_r_user),
		.master_rvalid_i(s_master_r_valid),
		.master_rready_o(s_master_r_ready),
		.cfg_START_ADDR_i(s_start_addr),
		.cfg_END_ADDR_i(s_end_addr),
		.cfg_valid_rule_i(s_valid_rule),
		.cfg_connectivity_map_i(s_connectivity_map)
	);
	assign s_valid_rule = 1'sb1;
	assign s_connectivity_map = 1'sb1;
endmodule
