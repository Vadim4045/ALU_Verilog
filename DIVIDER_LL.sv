// Fully parametric expandable Divider with Module output

module DIVIDER_LL #(parameter BITS=32)
							(input [BITS-1:0] A,B,b_map,
							 input Zero_a,Zero_b,Sign_b,Sign_a,
							 output [BITS-1:0] D,Modul,
							 output Over, Turn);
	
wire [BITS-1:0]res;
wire [BITS:0][BITS-1:0]inner;

assign inner[BITS] = A;
assign Over = ~Zero_a&Zero_b;

genvar i;

generate
	for(i=0;i<BITS;i=i+1) begin: generation
		
		wire temp;	
		wire [BITS-1:0]tmp1,tmp2;

		assign tmp1 = {B[i:0], {BITS-1-i{1'b0}}};
		assign temp = (tmp2[BITS-1]^A[BITS-1])|b_map[i];
		 
		ADDER_LL_CLA #(.BITS(BITS))
						(.A(inner[BITS-i]), 
						 .B(tmp1), 
						 .S(tmp2));

		
		assign inner[BITS-1-i] = temp? inner[BITS-i]:tmp2;
		assign res[BITS-1-i] = temp? 1'b0:1'b1;
		
	end
endgenerate


assign Turn = Sign_a^Sign_b;

assign D = res;

// Correct sign of Module
TURNER_LL #(.BITS(BITS)) 
				(.IN(inner[0]), 
				 .Com(Sign_a), 
				 .OUT(Modul));
		
endmodule
