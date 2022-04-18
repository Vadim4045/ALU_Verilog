module MUX_OUT #(parameter BITS = 16)
						(input [BITS-1:0] A,B,RES,MOD,
						 input [1:0]SW,
						 output OUT_SIGN,
						 output [BITS-1:0] TO_BCD);
	
reg [BITS-1:0]tmp;

assign OUT_SIGN = tmp[BITS-1];

TURNER_LL #(.BITS(BITS)) (.IN(tmp), .Com(tmp[BITS-1]), .OUT(TO_BCD));

always @(SW)					 
case (SW)
	2'b00: tmp = A;
	2'b01: tmp = B;
	2'b10: tmp = RES;
	2'b11: tmp = MOD;
endcase
						 
endmodule
						 