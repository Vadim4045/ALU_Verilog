//Fully parametric expandable Less then checker

module LESS_THEN #(parameter BITS=8)
						(input [BITS-1:0] A,B,
						 input mode,
						 output res,equal);

wire [BITS-1:0] a_plus,b_plus;
wire tmp_res;

assign tmp_res = A[BITS-1]^B[BITS-1]? B[BITS-1] : res_bus[0][1]^A[BITS-1];
assign res = tmp_res^mode;

assign equal = ~|res_bus[0];

genvar i;

generate

	wire [BITS-1:0][1:0]res_bus;

	for(i=BITS-1;i>0;i=i-1) begin: i_loop
		
		assign res_bus[i-1] = |res_bus[i]? res_bus[i] : A[i-1]^B[i-1]? {A[i-1],B[i-1]} : res_bus[i] ; 
	
	end

endgenerate						 
endmodule
