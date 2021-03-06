// Fully parametric expandable Multiplayer with binary tree addars struture

module MULTIPLAYER_LL #(parameter BITS=16)
							(input [BITS-1:0] A,B,a_map,
							input Sign_b,Sign_a,
							output [BITS-1:0] M,
							output Over, Turn);
				 

wire [2*(BITS-1):0] over_sub;
wire [2*BITS-1:0][BITS-1:0][BITS-1:0]inner;

assign inner[log2(BITS)-1][0] = B[0]? A:'h0;

assign M = inner[0][0];
	
genvar i,j;
	
generate	
	for(i=1;i<BITS;i=i+1) begin: A_assign
		
		wire [BITS-1:0]tmp;
		
		assign tmp = {A[BITS-1-i:0],{i{1'b0}}};
		
		assign over_sub[i] = a_map[BITS-1-i]&B[i];	
		
		assign inner[log2(BITS)-1][i] = B[i]? tmp:{BITS{1'b0}};
		
		
		
	end	
	
	for(i=1;i<log2(BITS);i=i+1) begin: sum_tree
	
		for(j=0;j<pow2(i);j=j+2) begin: sum_layer	
		
			wire over_tmp;
		
			ADDER_LL_CLA #(.BITS(BITS))
								(.A(inner[i][j]),
								.B(inner[i][j+1]),
								.S(inner[i-1][j/2]),
								.Over(over_tmp));
								
			assign over_sub[BITS + over_count(i-1,j/2)] = i<log2(BITS)-1? over_tmp : 1'b0;
								
		end
	end	
endgenerate

assign Over = |over_sub;
assign Turn = Sign_a^Sign_b;
				 
endmodule


function integer log2;
input [31:0] value;	
	for (log2=0; value>0; value = value/2) log2=log2+1;	
endfunction 


function integer pow2;
input [31:0] value;
	for(pow2=1; value>0; pow2=pow2*2) value=value-1;
endfunction

// Calculate place of overflow on adding
function integer over_count;
input [31:0] i;
input [31:0] j;
	for(over_count=0; i>0; i=i-1) over_count=over_count+pow2(i-1);
	over_count = over_count + j;
endfunction
