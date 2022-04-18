module NUM_IN #(parameter BITS=4)
					(input [BITS-1:0]IN,
					output [BITS-1:0]Plus,Minus,Map,
					output Min, Zero);
					
wire [BITS-1:0] tmp;
wire [BITS-3:0] tmp1, tmp2;

TURNER_LL #(.BITS(BITS)) (.IN(IN), .Com(1'b1), .OUT(tmp));

NUM_MAP #(.BITS(BITS))(.Num(Plus), .Map(Map));

assign Plus = 	IN[BITS-1]? tmp:IN;				
assign Minus = IN[BITS-1]? IN:tmp;					

assign Min = IN[BITS-1]&tmp[BITS-1];
assign Zero = ~(IN[BITS-1]|tmp[BITS-1]);	
					
endmodule
