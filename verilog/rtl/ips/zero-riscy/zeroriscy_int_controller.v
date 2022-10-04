module zeroriscy_int_controller (
	clk,
	rst_n,
	irq_req_ctrl_o,
	irq_id_ctrl_o,
	ctrl_ack_i,
	ctrl_kill_i,
	irq_i,
	irq_id_i,
	m_IE_i
);
	input wire clk;
	input wire rst_n;
	output wire irq_req_ctrl_o;
	output wire [4:0] irq_id_ctrl_o;
	input wire ctrl_ack_i;
	input wire ctrl_kill_i;
	input wire irq_i;
	input wire [4:0] irq_id_i;
	input wire m_IE_i;
	reg [1:0] exc_ctrl_cs;
	wire [1:0] exc_ctrl_ns;
	wire irq_enable_ext;
	reg [4:0] irq_id_q;
	assign irq_enable_ext = m_IE_i;
	assign irq_req_ctrl_o = exc_ctrl_cs == 2'd1;
	assign irq_id_ctrl_o = irq_id_q;
	always @(posedge clk or negedge rst_n)
		if (rst_n == 1'b0) begin
			irq_id_q <= 1'sb0;
			exc_ctrl_cs <= 2'd0;
		end
		else
			case (exc_ctrl_cs)
				2'd0:
					if (irq_enable_ext & irq_i) begin
						exc_ctrl_cs <= 2'd1;
						irq_id_q <= irq_id_i;
					end
				2'd1:
					case (1'b1)
						ctrl_ack_i: exc_ctrl_cs <= 2'd2;
						ctrl_kill_i: exc_ctrl_cs <= 2'd0;
						default: exc_ctrl_cs <= 2'd1;
					endcase
				2'd2: exc_ctrl_cs <= 2'd0;
			endcase
endmodule
