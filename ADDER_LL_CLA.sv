//Fully parametric expandable Addar with CLA

module ADDER_LL_CLA #(parameter BITS=4)
							(input [BITS-1:0]A,B, 
							 input Cin,
							 output [BITS-1:0]S,
							 output Over,Cout);
				
wire [BITS-1:0]C,P,G;

genvar i;
generate

	if(mod4(BITS)==0) begin
		
		CLA #(.BITS(BITS))
				(.P(P),
				.G(G),
				.Cin(Cin),
				.C(C), 
				.Cout(Cout));
				
	end else begin
			
		wire tmp;

		CLA #(.BITS(BITS/2))
				(.P(P[BITS/2-1:0]),
				.G(G[BITS/2-1:0]),
				.Cin(Cin),
				.C(C[BITS/2-1:0]), 
				.Cout(tmp));
				
		CLA #(.BITS(BITS/2))
				(.P(P[BITS-1:BITS/2]), 
				.G(G[BITS-1:BITS/2]), 
				.Cin(tmp), 
				.C(C[BITS-1:BITS/2]), 
				.Cout(Cout));
		
	end
	

	for(i=0;i<BITS;i=i+1) begin : adders_loop
	
		FA_LL_CLA (.A(A[i]),
					  .B(B[i]),
					  .Cin(C[i]), 
					  .S(S[i]),
					  .P(P[i]),
					  .G(G[i]));
	end
	
endgenerate

assign Over = C[BITS-1]^Cout;
		 
endmodule

//Check for bus_width=4^(n>=1);
function integer mod4;
	input [31:0] value;
	
		for (mod4=value%4;value>4;mod4 = value%4) value = value/4;
		
endfunction

