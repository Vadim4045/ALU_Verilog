// Fully parametric expandable Binary to BCD converter

module BIN_to_BCD #(parameter BITS=16,DIGITS = 6)
						(input[BITS-1:0] BIN_IN,
						 input IN_SIGN,Over,Com,
						 output [4*DIGITS-1:0]BCD);

 
localparam bcd_last = DIGITS*4-1;
localparam digits = DIGITS-1;

  
wire [2*BITS:0][digits*4-1:0] result;	
	
genvar i,j;

generate
	
	assign result[0] = {{bcd_last{1'b0}}, BIN_IN[BITS-1]};

	for(i=0;i<2*BITS;i=i+2) begin: first_loop	
		
		for(j=0;j<digits;j=j+1) begin:second_loop
		
			if(i>4*j+4) ADD3 (.in(result[i][(j+1)*4-1:j*4]), .out(result[i+1][(j+1)*4-1:j*4]));
			
			else assign result[i+1][(j+1)*4-1:j*4] = result[i][(j+1)*4-1:j*4];
			
		end
		
		assign result[i+2] = {result[i+1][digits*4-2:0], BIN_IN[BITS-1-i/2]};
		
	end
	
	assign BCD[4*DIGITS-1:4*(DIGITS-1)] = Com&Over? 4'hb:IN_SIGN? 4'ha:4'hc;

	assign BCD[4*(DIGITS-1)-1:0] = result[i];
	
endgenerate	
	
endmodule

