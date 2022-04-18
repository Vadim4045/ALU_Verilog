module MULT10 #(parameter BITS = 4)
					(input [BITS-1:0] IN,
					output [BITS-1:0] OUT);
					

wire [BITS-1:0] a1,a2;

assign a1 = {IN[BITS-2:0],1'd0};
assign a2 = {IN[BITS-4:0],3'd0};

ADDER_LL_CLA #(.BITS(BITS))(.A(a1), .B(a2), .S(OUT));
					
endmodule
