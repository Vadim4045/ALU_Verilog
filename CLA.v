// Fully parametric expandable CLA module for Adder

module CLA #(parameter BITS=4)(input [BITS-1:0]P,G,input Cin,
				output [BITS-1:0]C,output PG,GG,Cout);
				 			
genvar i;

generate

	wire [3:0]Pin,Gin,Out,cin;
	

	if(BITS>4) begin
	
		for(i=0;i<4;i=i+1) begin: in_loop
		
				CLA #(.BITS(BITS/4))(.P(P[(i+1)*BITS/4-1:i*BITS/4]),
											.G(G[(i+1)*BITS/4-1:i*BITS/4]),
											.Cin(cin[i]),
											.C(C[(i+1)*BITS/4-1:i*BITS/4]),
											.PG(Pin[i]),
											.GG(Gin[i]));
				
		end
		

	
		CLA #(.BITS(4))(.P(Pin), .G(Gin), .Cin(Cin), .C(cin), .Cout(Cout));
		
		
	end else begin
	
		wire [BITS:0]in;
	
		for(i=0;i<BITS;i=i+1) begin: cla_generate
		
			assign in[i+1] = G[i]|(P[i]&in[i]);
			
		end
		
		assign in[0] = Cin;
		assign PG = &P;
		assign GG=G[3]|(G[2]&P[3])|(G[1]&P[3]&P[2])|(G[0]&P[3]&P[2]&P[1]);
		assign C = in[BITS-1:0];
		assign Cout = in[BITS];
			
	end
				
endgenerate				
				
endmodule
