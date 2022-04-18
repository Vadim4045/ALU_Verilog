module HA_LL (input A,B,
					output S,Cout);
				
assign Cout=A&B;
assign S=A^B;
				
endmodule
