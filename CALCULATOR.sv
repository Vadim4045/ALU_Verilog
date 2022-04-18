/////////////////////////////////////////////
//                                         //
//      Fully parametric expandable        //
//                                         //
//              Calculator                 //
//                                         //
//                                         //
//       autor Vadim Natin                 //
//                                         //
//       focusdigit@gmail.com              //
//                                         //
//      https://github.com/Vadim4045       //
//                                         //
/////////////////////////////////////////////
//                                         //
//       parameter BITS - bus width        //
//                                         //
//           BITS = 2^n (n>1);             //
//                                         //
/////////////////////////////////////////////
//                                         //
//       [9:0] SW - 10 switches            //
//       [1:0]KEY - 2 keys                 //
//       ADC_CLK_10 - 10000Hz clock        //
//       [7:0] HEX0: HEX5 - seven segment  //
//       [9:0] LEDR - 10 leds              //
//                                         //
/////////////////////////////////////////////
//  [9:8]SW:                               //
//          2'b00: set A                   //
//          2'b01: set B                   //
//          2'b10: result                  //
//          2'b11: divide modul            //
//                                         //
/////////////////////////////////////////////
//                                         //
// [7:5]SW:                                //
//          3'b000: A+B;                   //
//          3'b001: A-B;                   //
//          3'b010: A*B;                   //
//          3'b011: A/B;                   //
//          3'b100: A<<B;                  //
//          3'b101: A>>B;                  //
//          3'b110: A<<<B;                 //
//          3'b111: A>>>B;                 //
//                                         //
/////////////////////////////////////////////
//                                         //
// [4:0]SW:                                //
//       5'b00000: nothing                 //
//       5'b00001 + KEY[0]: add 1;         //
//       5'b00010 + KEY[0]: add 10;        //
//       5'b00100 + KEY[0]: add 100;       //
//       5'b01000 + KEY[0]: add 1000       //
//       5'b10000 + KEY[0]: NUM x(-1);     //
//       5'b00000 + KEY[0]: add 1;         //
//                                         //
/////////////////////////////////////////////

module CALCULATOR #(parameter BITS=16, DIGITS=6)
						(input [9:0] SW,
						 input [1:0]KEY,
						 input ADC_CLK_10,
						 output[7:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,				
						 output [9:0] LEDR);
						 //output [BITS-1:0]  from_A, from_B, to_seg, mod, res);// for simulatiomn only
						 
						 

wire over,clk,set_A,set_B,reset_A,reset_B,out_sign;
wire [BITS-1:0] to_A, to_B, to_set, from_set, from_A, from_B, to_seg, mod, res;
wire [8*DIGITS-1:0]seg_hex0,seg_hex1;						
wire [4*DIGITS-1:0] from_bin;


assign HEX0 = seg_hex1[7:0];
assign HEX1 = seg_hex1[15:8];
assign HEX2 = seg_hex1[23:16];
assign HEX3 = seg_hex1[31:24];
assign HEX4 = seg_hex1[39:32];
assign HEX5 = seg_hex1[47:40];

SEVEN_SEG (.in(from_bin[3:0]), .seg(seg_hex0[7:0]));
SEVEN_SEG (.in(from_bin[7:4]), .seg(seg_hex0[15:8]));
SEVEN_SEG (.in(from_bin[11:8]), .seg(seg_hex0[23:16]));
SEVEN_SEG (.in(from_bin[15:12]), .seg(seg_hex0[31:24]));
SEVEN_SEG (.in(from_bin[19:16]), .seg(seg_hex0[39:32]));
SEVEN_SEG (.in(from_bin[23:20]), .seg(seg_hex0[47:40]));

// First number storadge
NUMBER #(.BITS(BITS))
			(.CLK(ADC_CLK_10),
			.SET(set_A),
			.RESET(reset_A),
			.NUM_IN(to_A),
			.NUM_OUT(from_A));
			

// Second number storadge			
NUMBER #(.BITS(BITS))
			(.CLK(ADC_CLK_10),
			.SET(set_B),
			.RESET(reset_B),
			.NUM_IN(to_B),
			.NUM_OUT(from_B));


			
// Module for make number by add 1/10/100/1000 and change sign
NUM_MAKER #(.BITS(BITS), .DIGITS(DIGITS))
				(.SW(SW[4:0]),
				.NUM(to_set),
				.OUT(from_set));


//First muxing
NUM_MUX #(.BITS(BITS))
			(.SW(SW[9:8]),
			.SET(KEY[0]),
			.RESET(KEY[1]),
			.A(from_A),
			.B(from_B),
			.FROM_SET(from_set),
			.TO_A(to_A),
			.TO_B(to_B), 
			.TO_SET(to_set), 
			.SET_A(set_A),
			.SET_B(set_B), 
			.RESET_A(reset_A),
			.RESET_B(reset_B), 
			.LEDS(LEDR));
				
				
// Main ALU
ALU_LL #(.BITS(BITS))
			(.A(from_A),
			.B(from_B), 
			.Com(SW[7:5]), 
			.Res(res),
			.DivMod(mod),
			.Over(over));


//Out muxing
MUX_OUT #(.BITS(BITS))
			(.A(from_A),
			.B(from_B),
			.RES(res),
			.MOD(mod), 
			.SW(SW[9:8]), 
			.TO_BCD(to_seg), 
			.OUT_SIGN(out_sign));


// 0.5 sec clock
CLK #(.PER_SEC(2))
		(.ADC_CLK(ADC_CLK_10),
		.CLK(clk));

		
//Binary to BCD parametric converter
BIN_to_BCD #(.BITS(BITS), .DIGITS(DIGITS))
				(.BIN_IN(to_seg),
				.Over(over),
				.IN_SIGN(out_sign),
				.Com(SW[9]), 
				.BCD(from_bin));
				

//Module for flashing selected digit
CLK_on_DIGITS #(.DIGITS(DIGITS))
					(.CLK(clk), 
					.SW(SW[DIGITS-1:0]),
					.COM(SW[9]), 
					.IN(seg_hex0),
					.OUT(seg_hex1));


endmodule
