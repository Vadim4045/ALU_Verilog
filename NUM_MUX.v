module NUM_MUX #(parameter BITS = 16)
					 (input [1:0]SW,
					  input SET,RESET,
					  input [BITS-1:0] A,B,FROM_SET,
					  output[9:0]LEDS,
					  output [BITS-1:0] TO_A,TO_B,TO_SET,
					  output SET_A,SET_B,RESET_A,RESET_B);

assign TO_SET = SW[1]? 'h0:SW[0]? B:A;
assign TO_A = SW[1]? A:SW[0]? A:FROM_SET;
assign TO_B = SW[1]? B:SW[0]? FROM_SET:B;
assign SET_A = SW[1]? 1'b1:SW[0]? 1'b1:SET;
assign SET_B = SW[1]? 1'b1:SW[0]? SET:1'b1;
assign RESET_A = SW[1]? 1'b1:SW[0]? 1'b1:RESET;
assign RESET_B = SW[1]? 1'b1:SW[0]? RESET:1'b1;
assign LEDS = SW[0]? B[9:0]:A[9:0];				  
					  
endmodule

					  
					  
					  
