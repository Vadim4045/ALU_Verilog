/////////////////////////////////////////////
//                                         //
//      Fully parametric expandable        //
//                                         //
//               ALU module                //
//                                         //
//                                         //
//                                         //
//        autor Vadim Natin                //
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
//       [BITS-1:0] A,B - input numbers    //
//       [BITS-1:0] Res - Result           //
//    [BITS-1:0] DivMod - divider Modulo   //
//       Over - one bit overflow           //
//                                         //
/////////////////////////////////////////////
//                                         //
// [2:0]Com:                               //
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


module ALU_LL #(parameter BITS=32)
					(input [BITS-1:0] A,B,
					 input [2:0]Com,
					 output [BITS-1:0] Res, DivMod,
					 output Over);
					 
					 
wire a_zero, b_zero, a_min, b_min,a_one, b_one;
wire adder_over, mult_over, div_over, shift_over;
wire turn, turn_div, turn_mult;	
wire	[BITS-1:0] a_plus, a_minus, b_plus,b_minus, a_map, b_map, b_adder, b_div;
wire	[BITS-1:0] res_adder, res_mult, res_div, res_shift, res_1, res_2;

assign b_adder = B[BITS-1]^Com[0]? b_minus : b_plus;

assign res_1 = Com[0]? res_div : res_mult;
assign Res = Com[2]? res_shift : Com[1]? res_2 : res_adder;

assign turn = Com[0]? turn_div : turn_mult;

assign Over = a_min|b_min? 1'b1 : Com[2]? shift_over : Com[1]? Com[0]? div_over : mult_over : adder_over;




NUM_IN #(.BITS(BITS)) First_Number
			(.IN(A),
			.Plus(a_plus),
			.Minus(a_minus),
			.Min(a_min),
			.Zero(a_zero),
			.Map(a_map));
			
			

NUM_IN #(.BITS(BITS)) Second_Number
			(.IN(B),
			.Plus(b_plus),
			.Minus(b_minus),
			.Min(b_min),
			.Zero(b_zero),
			.Map(b_map));




ADDER_LL_CLA #(.BITS(BITS)) Adder
					(.A(A),
					.B(b_adder),
					.S(res_adder),
					.Over(adder_over));



MULTIPLAYER_LL #(.BITS(BITS)) Multiplayer
					(.A(A), .B(b_plus),
					.a_map(a_map),
					.Sign_b(B[BITS-1]),
					.Sign_a(A[BITS-1]),
					.M(res_mult), 
					.Over(mult_over),
					.Turn(turn_mult)); 
					
					
DIVIDER_LL #(.BITS(BITS)) Divider
				(.A(a_plus),
				.B(b_minus),
				.Zero_b(b_zero), 
				.Zero_a(a_zero), 
				.Modul(DivMod),
				.b_map(b_map),
				.Sign_b(B[BITS-1]), 
				.Sign_a(A[BITS-1]), 
				.D(res_div),
				.Over(div_over), 
				.Turn(turn_div));
				

SHIFT #(.BITS(BITS)) Arithmetic_Logic_Shift
			(.A(A),
			 .B(B),
			.Shift_mode(Com[1]),
			.right(Com[0]),
			.M(res_shift),
			.Over(shift_over));				
			




TURNER_LL #(.BITS(BITS)) Result_Turner
				(.IN(res_1),
				.Com(turn),
				.OUT(res_2));
			

	
endmodule
