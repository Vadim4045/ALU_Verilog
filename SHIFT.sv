// Fully parametric expandable Shifter for right/left arithmetic/logic shift

module SHIFT #(parameter BITS=8)
					(input [BITS-1:0] A,B,
					input Shift_mode,
					input right,
					output [BITS-1:0] M,
					output Over);
					
					
				
wire [2*BITS-1:0][BITS-1:0] arithmetic_shift, logical_shift;
wire [BITS-1:0]tmp_const, B_minus, right_addr, left_addr;
wire b_less_then;

assign tmp_const = BITS;

LESS_THEN #(.BITS(BITS))
				(.A(B),
				.B(tmp_const),
				.mode(1'b0),
				.res(b_less_then));
				
				
ADDER_LL_CLA #(.BITS(BITS))
					(.A(BITS),
					.B(B),
					.S(right_addr));
					
					
					
TURNER_LL #(.BITS(BITS)) B_Turner
				(.IN(B),
				.Com(1'b1),
				.OUT(B_minus));
				
				
				
					
					
ADDER_LL_CLA #(.BITS(BITS))
					(.A(BITS),
					.B(B_minus),
					.S(left_addr));


always @(*)
begin

	if(b_less_then | B[BITS-1]) begin
	
		Over = 1'b1;
		M='h0;
	
	end else begin

		if(right) begin
		
			if(Shift_mode) M = arithmetic_shift[right_addr];//>>
			
			else  M= logical_shift[right_addr];//>>>
		
		end else begin

			if(Shift_mode) M = arithmetic_shift[left_addr];//<<
			
			else  M= logical_shift[left_addr];//<<<
		
		end
		
		Over = 1'b0;
		
	end
end



genvar i;

generate			

	for(i=1;i<2*BITS;i=i+1) begin: i_loop
	
		if(i<BITS) begin
		
			wire [i-1:0] tmp1, tmp2;
		
			assign tmp1 = {i{A[BITS-1]}};
			
			assign tmp2 = {i{1'b0}};
		
			assign arithmetic_shift[BITS-i] = {tmp1,A[BITS-1:i]};//>>
			
			assign logical_shift[BITS-i] = {tmp2,A[BITS-1:i]};//>>>
		
		end else begin
		
			assign arithmetic_shift[i] = {A[2*BITS-i-1:0],{i-BITS{1'b0}}};//<<
			
			assign logical_shift[i] = {A[2*BITS-i-1:0],{i-BITS{1'b0}}};//<<<
		
		end
	
	end


endgenerate
endmodule	