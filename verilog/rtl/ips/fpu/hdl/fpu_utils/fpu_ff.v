module fpu_ff 
#(
  parameter LEN = 32
)
(
	in_i,
	first_one_o,
	no_ones_o
);
	//parameter LEN = 32;
	input wire [LEN - 1:0] in_i;
	output wire [$clog2(LEN) - 1:0] first_one_o;
	output wire no_ones_o;
	localparam NUM_LEVELS = $clog2(LEN);
	wire [(LEN * NUM_LEVELS) - 1:0] index_lut;
	wire [(2 ** NUM_LEVELS) - 1:0] sel_nodes;
	wire [((2 ** NUM_LEVELS) * NUM_LEVELS) - 1:0] index_nodes;
	wire [LEN - 1:0] in_flipped;
	genvar j;
	generate
		for (j = 0; j < LEN; j = j + 1) begin : genblk1
			assign index_lut[j * NUM_LEVELS+:NUM_LEVELS] = $unsigned(j);
			assign in_flipped[j] = in_i[(LEN - j) - 1];
		end
	endgenerate
	genvar k;
	genvar l;
	genvar level;
	generate
		for (level = 0; level < NUM_LEVELS; level = level + 1) begin : genblk2
			if (level < (NUM_LEVELS - 1)) begin : genblk1
				for (l = 0; l < (2 ** level); l = l + 1) begin : genblk1
					assign sel_nodes[((2 ** level) - 1) + l] = sel_nodes[((2 ** (level + 1)) - 1) + (l * 2)] | sel_nodes[(((2 ** (level + 1)) - 1) + (l * 2)) + 1];
					assign index_nodes[(((2 ** level) - 1) + l) * NUM_LEVELS+:NUM_LEVELS] = (sel_nodes[((2 ** (level + 1)) - 1) + (l * 2)] == 1'b1 ? index_nodes[(((2 ** (level + 1)) - 1) + (l * 2)) * NUM_LEVELS+:NUM_LEVELS] : index_nodes[((((2 ** (level + 1)) - 1) + (l * 2)) + 1) * NUM_LEVELS+:NUM_LEVELS]);
				end
			end
			if (level == (NUM_LEVELS - 1)) begin : genblk2
				for (k = 0; k < (2 ** level); k = k + 1) begin : genblk1
					if ((k * 2) < (LEN - 1)) begin : genblk1
						assign sel_nodes[((2 ** level) - 1) + k] = in_flipped[k * 2] | in_flipped[(k * 2) + 1];
						assign index_nodes[(((2 ** level) - 1) + k) * NUM_LEVELS+:NUM_LEVELS] = (in_flipped[k * 2] == 1'b1 ? index_lut[(k * 2) * NUM_LEVELS+:NUM_LEVELS] : index_lut[((k * 2) + 1) * NUM_LEVELS+:NUM_LEVELS]);
					end
					if ((k * 2) == (LEN - 1)) begin : genblk2
						assign sel_nodes[((2 ** level) - 1) + k] = in_flipped[k * 2];
						assign index_nodes[(((2 ** level) - 1) + k) * NUM_LEVELS+:NUM_LEVELS] = index_lut[(k * 2) * NUM_LEVELS+:NUM_LEVELS];
					end
					if ((k * 2) > (LEN - 1)) begin : genblk3
						assign sel_nodes[((2 ** level) - 1) + k] = 1'b0;
						assign index_nodes[(((2 ** level) - 1) + k) * NUM_LEVELS+:NUM_LEVELS] = 1'sb0;
					end
				end
			end
		end
	endgenerate
	assign first_one_o = index_nodes[0+:NUM_LEVELS];
	assign no_ones_o = ~sel_nodes[0];
endmodule
