// Fully parametric expandable Number storadge

module NUMBER #(parameter BITS=8)
					(input CLK,SET,RESET,
					input [BITS-1:0] NUM_IN,
					output [BITS-1:0] NUM_OUT);
					
reg [BITS-1:0] number;

assign NUM_OUT = number;

always @(posedge CLK or negedge RESET)
	begin
		if(~RESET) number <= 'h0;
		else if(~SET) number <= NUM_IN;
		else number <= number;
	end					
					
endmodule
