//Fully parametric expandable Number making module

module NUM_MAKER #(parameter BITS = 16, DIGITS = 6)
						(input [DIGITS-2:0] SW,
						input [BITS-1:0]NUM,
						output [BITS-1:0] OUT);
						

wire [BITS-1:0]to_add,from_add,from_turn;
wire [DIGITS-2:0][BITS-1:0] ranges;

assign ranges[0] = 'h1;
assign ranges[1] = 'ha;

genvar i;
generate	
					
	for(i=2;i<DIGITS-2;i=i+1) begin: first_loop
		
		MULT10 #(.BITS(BITS))(.IN(ranges[i-1]), .OUT(ranges[i]));
		
	end
	
	ADDER_LL_CLA #(.BITS(BITS))(.A(NUM), .B(to_add), .S(from_add));
	
	TURNER_LL #(.BITS(BITS)) (.IN(NUM), .Com(1'b1), .OUT(from_turn));
	
	
	assign to_add = SW[0]? ranges[0]:SW[1]? ranges[1]:SW[2]? ranges[2]:SW[3]? ranges[3]:'h0;
	
	assign OUT = SW[4]? from_turn:from_add;

	
endgenerate			
endmodule
