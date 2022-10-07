module spi_slave_axi_plug 
#(
    parameter AXI_ADDR_WIDTH = 32,
    parameter AXI_DATA_WIDTH = 64,
    parameter AXI_USER_WIDTH = 6,
    parameter AXI_ID_WIDTH   = 3
)
(
	axi_aclk,
	axi_aresetn,
	axi_master_aw_valid,
	axi_master_aw_addr,
	axi_master_aw_prot,
	axi_master_aw_region,
	axi_master_aw_len,
	axi_master_aw_size,
	axi_master_aw_burst,
	axi_master_aw_lock,
	axi_master_aw_cache,
	axi_master_aw_qos,
	axi_master_aw_id,
	axi_master_aw_user,
	axi_master_aw_ready,
	axi_master_ar_valid,
	axi_master_ar_addr,
	axi_master_ar_prot,
	axi_master_ar_region,
	axi_master_ar_len,
	axi_master_ar_size,
	axi_master_ar_burst,
	axi_master_ar_lock,
	axi_master_ar_cache,
	axi_master_ar_qos,
	axi_master_ar_id,
	axi_master_ar_user,
	axi_master_ar_ready,
	axi_master_w_valid,
	axi_master_w_data,
	axi_master_w_strb,
	axi_master_w_user,
	axi_master_w_last,
	axi_master_w_ready,
	axi_master_r_valid,
	axi_master_r_data,
	axi_master_r_resp,
	axi_master_r_last,
	axi_master_r_id,
	axi_master_r_user,
	axi_master_r_ready,
	axi_master_b_valid,
	axi_master_b_resp,
	axi_master_b_id,
	axi_master_b_user,
	axi_master_b_ready,
	rxtx_addr,
	rxtx_addr_valid,
	start_tx,
	cs,
	tx_data,
	tx_valid,
	tx_ready,
	rx_data,
	rx_valid,
	rx_ready,
	wrap_length
);
	//parameter AXI_ADDR_WIDTH = 32;
	//parameter AXI_DATA_WIDTH = 64;
	//parameter AXI_USER_WIDTH = 6;
	//parameter AXI_ID_WIDTH = 3;
	input wire axi_aclk;
	input wire axi_aresetn;
	output reg axi_master_aw_valid;
	output wire [AXI_ADDR_WIDTH - 1:0] axi_master_aw_addr;
	output wire [2:0] axi_master_aw_prot;
	output wire [3:0] axi_master_aw_region;
	output wire [7:0] axi_master_aw_len;
	output wire [2:0] axi_master_aw_size;
	output wire [1:0] axi_master_aw_burst;
	output wire axi_master_aw_lock;
	output wire [3:0] axi_master_aw_cache;
	output wire [3:0] axi_master_aw_qos;
	output wire [AXI_ID_WIDTH - 1:0] axi_master_aw_id;
	output wire [AXI_USER_WIDTH - 1:0] axi_master_aw_user;
	input wire axi_master_aw_ready;
	output reg axi_master_ar_valid;
	output wire [AXI_ADDR_WIDTH - 1:0] axi_master_ar_addr;
	output wire [2:0] axi_master_ar_prot;
	output wire [3:0] axi_master_ar_region;
	output wire [7:0] axi_master_ar_len;
	output wire [2:0] axi_master_ar_size;
	output wire [1:0] axi_master_ar_burst;
	output wire axi_master_ar_lock;
	output wire [3:0] axi_master_ar_cache;
	output wire [3:0] axi_master_ar_qos;
	output wire [AXI_ID_WIDTH - 1:0] axi_master_ar_id;
	output wire [AXI_USER_WIDTH - 1:0] axi_master_ar_user;
	input wire axi_master_ar_ready;
	output reg axi_master_w_valid;
	output wire [AXI_DATA_WIDTH - 1:0] axi_master_w_data;
	output wire [(AXI_DATA_WIDTH / 8) - 1:0] axi_master_w_strb;
	output wire [AXI_USER_WIDTH - 1:0] axi_master_w_user;
	output wire axi_master_w_last;
	input wire axi_master_w_ready;
	input wire axi_master_r_valid;
	input wire [AXI_DATA_WIDTH - 1:0] axi_master_r_data;
	input wire [1:0] axi_master_r_resp;
	input wire axi_master_r_last;
	input wire [AXI_ID_WIDTH - 1:0] axi_master_r_id;
	input wire [AXI_USER_WIDTH - 1:0] axi_master_r_user;
	output reg axi_master_r_ready;
	input wire axi_master_b_valid;
	input wire [1:0] axi_master_b_resp;
	input wire [AXI_ID_WIDTH - 1:0] axi_master_b_id;
	input wire [AXI_USER_WIDTH - 1:0] axi_master_b_user;
	output reg axi_master_b_ready;
	input wire [AXI_ADDR_WIDTH - 1:0] rxtx_addr;
	input wire rxtx_addr_valid;
	input wire start_tx;
	input wire cs;
	output wire [31:0] tx_data;
	output reg tx_valid;
	input wire tx_ready;
	input wire [31:0] rx_data;
	input wire rx_valid;
	output reg rx_ready;
	input wire [15:0] wrap_length;
	reg [AXI_ADDR_WIDTH - 1:0] curr_addr;
	reg [AXI_ADDR_WIDTH - 1:0] next_addr;
	reg [31:0] curr_data_rx;
	reg [AXI_DATA_WIDTH - 1:0] curr_data_tx;
	reg incr_addr_w;
	reg incr_addr_r;
	reg sample_fifo;
	reg sample_axidata;
	reg [15:0] tx_counter;
	reg [2:0] AR_CS;
	reg [2:0] AR_NS;
	reg [2:0] AW_CS;
	reg [2:0] AW_NS;
	always @(posedge axi_aclk or negedge axi_aresetn)
		if (axi_aresetn == 0) begin
			AW_CS <= 3'd0;
			AR_CS <= 3'd0;
			curr_data_rx <= 'h0;
			curr_data_tx <= 'h0;
			curr_addr <= 'h0;
		end
		else begin
			AW_CS <= AW_NS;
			AR_CS <= AR_NS;
			if (sample_fifo)
				curr_data_rx <= rx_data;
			if (sample_axidata)
				curr_data_tx <= axi_master_r_data;
			if (rxtx_addr_valid)
				curr_addr <= rxtx_addr;
			else if (incr_addr_w | incr_addr_r)
				curr_addr <= next_addr;
		end
	always @(posedge axi_aclk or negedge axi_aresetn)
		if (axi_aresetn == 1'b0)
			tx_counter <= 16'h0000;
		else if (start_tx)
			tx_counter <= 16'h0000;
		else if (incr_addr_w | incr_addr_r)
			if (tx_counter == (wrap_length - 1))
				tx_counter <= 16'h0000;
			else
				tx_counter <= tx_counter + 16'h0001;
	always @(*) begin
		next_addr = 32'b00000000000000000000000000000000;
		if (rxtx_addr_valid)
			next_addr = rxtx_addr;
		else if (tx_counter == (wrap_length - 1))
			next_addr = rxtx_addr;
		else
			next_addr = curr_addr + 32'h00000004;
	end
	always @(*) begin
		AW_NS = 3'd0;
		sample_fifo = 1'b0;
		rx_ready = 1'b0;
		axi_master_aw_valid = 1'b0;
		axi_master_w_valid = 1'b0;
		axi_master_b_ready = 1'b0;
		incr_addr_w = 1'b0;
		case (AW_CS)
			3'd0:
				if (rx_valid) begin
					sample_fifo = 1'b1;
					rx_ready = 1'b1;
					AW_NS = 3'd2;
				end
				else
					AW_NS = 3'd0;
			3'd2: begin
				axi_master_aw_valid = 1'b1;
				if (axi_master_aw_ready)
					AW_NS = 3'd3;
				else
					AW_NS = 3'd2;
			end
			3'd3: begin
				axi_master_w_valid = 1'b1;
				if (axi_master_w_ready) begin
					incr_addr_w = 1'b1;
					AW_NS = 3'd4;
				end
				else
					AW_NS = 3'd3;
			end
			3'd4: begin
				axi_master_b_ready = 1'b1;
				if (axi_master_b_valid)
					AW_NS = 3'd0;
				else
					AW_NS = 3'd4;
			end
		endcase
	end
	always @(*) begin
		AR_NS = 3'd0;
		tx_valid = 1'b0;
		axi_master_ar_valid = 1'b0;
		axi_master_r_ready = 1'b0;
		incr_addr_r = 1'b0;
		sample_axidata = 1'b0;
		case (AR_CS)
			3'd0:
				if (start_tx && !cs)
					AR_NS = 3'd2;
				else
					AR_NS = 3'd0;
			3'd1: begin
				tx_valid = 1'b1;
				if (cs)
					AR_NS = 3'd0;
				else if (tx_ready) begin
					incr_addr_r = 1'b1;
					AR_NS = 3'd2;
				end
				else
					AR_NS = 3'd1;
			end
			3'd2: begin
				axi_master_ar_valid = 1'b1;
				if (axi_master_ar_ready)
					AR_NS = 3'd4;
				else
					AR_NS = 3'd2;
			end
			3'd4: begin
				axi_master_r_ready = 1'b1;
				if (axi_master_r_valid) begin
					sample_axidata = 1'b1;
					AR_NS = 3'd1;
				end
				else
					AR_NS = 3'd4;
			end
		endcase
	end
	generate
		if (AXI_DATA_WIDTH == 32) begin : genblk1
			assign tx_data = curr_data_tx[31:0];
		end
		else begin : genblk1
			assign tx_data = (curr_addr[2] ? curr_data_tx[63:32] : curr_data_tx[31:0]);
		end
	endgenerate
	assign axi_master_aw_addr = curr_addr;
	assign axi_master_aw_prot = 'h0;
	assign axi_master_aw_region = 'h0;
	assign axi_master_aw_len = 'h0;
	assign axi_master_aw_size = 3'b010;
	assign axi_master_aw_burst = 'h0;
	assign axi_master_aw_lock = 'h0;
	assign axi_master_aw_cache = 'h0;
	assign axi_master_aw_qos = 'h0;
	assign axi_master_aw_id = 'h1;
	assign axi_master_aw_user = 'h0;
	assign axi_master_w_data = {AXI_DATA_WIDTH / 32 {curr_data_rx}};
	generate
		if (AXI_DATA_WIDTH == 32) begin : genblk2
			assign axi_master_w_strb = 4'hf;
		end
		else begin : genblk2
			assign axi_master_w_strb = (curr_addr[2] ? 8'hf0 : 8'h0f);
		end
	endgenerate
	assign axi_master_w_user = 'h0;
	assign axi_master_w_last = 1'b1;
	assign axi_master_ar_addr = curr_addr;
	assign axi_master_ar_prot = 'h0;
	assign axi_master_ar_region = 'h0;
	assign axi_master_ar_len = 'h0;
	assign axi_master_ar_size = 3'b010;
	assign axi_master_ar_burst = 'h0;
	assign axi_master_ar_lock = 'h0;
	assign axi_master_ar_cache = 'h0;
	assign axi_master_ar_qos = 'h0;
	assign axi_master_ar_id = 'h1;
	assign axi_master_ar_user = 'h0;
endmodule
