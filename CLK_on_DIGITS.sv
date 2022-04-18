module CLK_on_DIGITS #(parameter DIGITS=6)
							(input CLK,COM,
							input [DIGITS-1:0]SW,
							input [8*DIGITS-1:0]IN,
							output [8*DIGITS-1:0]OUT);
							
genvar i;
generate
	for(i=0;i<(DIGITS-2);i=i+1) begin: clk_loop
		assign OUT[8*(i+1)-1:8*i] = ~SW[i]|COM? IN[8*(i+1)-1:8*i]: CLK? IN[8*(i+1)-1:8*i]:8'b11111111;
	end
	
	assign OUT[8*(DIGITS-2+1)-1:8*(DIGITS-2)] = IN[8*(DIGITS-2+1)-1:8*(DIGITS-2)];
	assign OUT[8*DIGITS-1:8*(DIGITS-1)] = ~SW[5]|COM? IN[8*DIGITS-1:8*(DIGITS-1)]:
															CLK? IN[8*DIGITS-1:8*(DIGITS-1)]:8'b11111111;
endgenerate							
endmodule
