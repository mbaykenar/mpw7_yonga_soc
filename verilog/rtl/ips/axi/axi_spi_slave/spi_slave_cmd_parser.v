module spi_slave_cmd_parser (
	cmd,
	get_addr,
	get_mode,
	get_data,
	send_data,
	enable_cont,
	enable_regs,
	wait_dummy,
	error,
	reg_sel
);
	input wire [7:0] cmd;
	output reg get_addr;
	output reg get_mode;
	output reg get_data;
	output reg send_data;
	output reg enable_cont;
	output reg enable_regs;
	output reg wait_dummy;
	output reg error;
	output reg [1:0] reg_sel;
	always @(*) begin
		get_addr = 0;
		get_mode = 0;
		get_data = 0;
		send_data = 0;
		enable_cont = 0;
		enable_regs = 1'b0;
		wait_dummy = 0;
		reg_sel = 2'b00;
		error = 1'b1;
		case (cmd)
			8'h01: begin
				get_addr = 0;
				get_mode = 0;
				get_data = 1;
				send_data = 0;
				enable_cont = 0;
				enable_regs = 1'b1;
				error = 1'b0;
				wait_dummy = 0;
				reg_sel = 2'b00;
			end
			8'h02: begin
				get_addr = 1;
				get_mode = 0;
				get_data = 1;
				send_data = 0;
				enable_cont = 1'b1;
				enable_regs = 1'b0;
				error = 1'b0;
				wait_dummy = 0;
				reg_sel = 2'b00;
			end
			8'h05: begin
				get_addr = 0;
				get_mode = 0;
				get_data = 0;
				send_data = 1;
				enable_cont = 0;
				enable_regs = 1'b1;
				error = 1'b0;
				wait_dummy = 0;
				reg_sel = 2'b00;
			end
			8'h07: begin
				get_addr = 0;
				get_mode = 0;
				get_data = 0;
				send_data = 1;
				enable_cont = 0;
				enable_regs = 1'b1;
				error = 1'b0;
				wait_dummy = 0;
				reg_sel = 2'b01;
			end
			8'h0b: begin
				get_addr = 1;
				get_mode = 0;
				get_data = 0;
				send_data = 1;
				enable_cont = 1'b1;
				enable_regs = 1'b0;
				error = 1'b0;
				wait_dummy = 1;
				reg_sel = 2'b00;
			end
			8'h11: begin
				get_addr = 1'b0;
				get_mode = 1'b0;
				get_data = 1'b1;
				send_data = 1'b0;
				enable_cont = 1'b0;
				enable_regs = 1'b1;
				error = 1'b0;
				wait_dummy = 1'b0;
				reg_sel = 2'b01;
			end
			8'h20: begin
				get_addr = 1'b0;
				get_mode = 1'b0;
				get_data = 1'b1;
				send_data = 1'b0;
				enable_cont = 1'b0;
				enable_regs = 1'b1;
				error = 1'b0;
				wait_dummy = 1'b0;
				reg_sel = 2'b10;
			end
			8'h21: begin
				get_addr = 1'b0;
				get_mode = 1'b0;
				get_data = 1'b0;
				send_data = 1'b1;
				enable_cont = 1'b0;
				enable_regs = 1'b1;
				error = 1'b0;
				wait_dummy = 1'b0;
				reg_sel = 2'b10;
			end
			8'h30: begin
				get_addr = 1'b0;
				get_mode = 1'b0;
				get_data = 1'b1;
				send_data = 1'b0;
				enable_cont = 1'b0;
				enable_regs = 1'b1;
				error = 1'b0;
				wait_dummy = 1'b0;
				reg_sel = 2'b11;
			end
			8'h31: begin
				get_addr = 1'b0;
				get_mode = 1'b0;
				get_data = 1'b0;
				send_data = 1'b1;
				enable_cont = 1'b0;
				enable_regs = 1'b1;
				error = 1'b0;
				wait_dummy = 1'b0;
				reg_sel = 2'b11;
			end
		endcase
	end
endmodule
