module FA_LL_CLA(input A,B,Cin,
				 output S,P,G,Cout);
					
wire w1, w2, w3;

HA_LL (.A(A), .B(B), .Cout(w2), .S(w1));
HA_LL (.A(Cin), .B(w1), .Cout(w3), .S(S));

assign P = w1;
assign G = w2;
assign Cout = w3;
			
endmodule
