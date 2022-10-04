module CSA 
#( parameter n=49 )
(
	A_DI,
	B_DI,
	C_DI,
	Sum_DO,
	Carry_DO
);
	//parameter n = 49;
	input wire [n - 1:0] A_DI;
	input wire [n - 1:0] B_DI;
	input wire [n - 1:0] C_DI;
	output reg [n - 1:0] Sum_DO;
	output reg [n - 1:0] Carry_DO;
	genvar i;
	generate
		for (i = 0; i <= (n - 1); i = i + 1) begin : genblk1
			always @(*) begin
				Sum_DO[i] = (A_DI[i] ^ B_DI[i]) ^ C_DI[i];
				Carry_DO[i] = ((A_DI[i] & B_DI[i]) | (A_DI[i] & C_DI[i])) | (B_DI[i] & C_DI[i]);
			end
		end
	endgenerate
endmodule
