module ADD3(input [3:0]in, output reg[3:0]out);


always @ (in)
	case (in)
		4'd0: out <= 4'd0;
		4'd1: out <= 4'd1;
		4'd2: out <= 4'd2;
		4'd3: out <= 4'd3;
		4'd4: out <= 4'd4;
		4'd5: out <= 4'd8;
		4'd6: out <= 4'd9;
		4'd7: out <= 4'd10;
		4'd8: out <= 4'd11;
		4'd9: out <= 4'd12;
		default: out <= 4'b0000;
	endcase
	
endmodule
