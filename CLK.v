module CLK #(parameter PER_SEC = 1)
				(input ADC_CLK,
				output reg CLK);

localparam tmp = 10000000/PER_SEC;			

reg [23:0]counter;
initial counter=tmp;

always @(posedge ADC_CLK)
if(counter==24'h0)
begin
	counter <= tmp;
	CLK <=~CLK;
end else counter = counter-1;
				
endmodule
