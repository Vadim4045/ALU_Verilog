// Fully parametric expandable number Map maker

module NUM_MAP #(parameter BITS=8)(input [BITS-1:0]Num,
					 output [BITS-1:0]Map);

assign Map[BITS-1]=1'b0;
					 
genvar i;

generate

	for(i=BITS-2;i>=0;i=i-1) begin: generation

		assign Map[i] = Num[i]|Map[i+1];
		
	end				  
					  
endgenerate
					  
endmodule
