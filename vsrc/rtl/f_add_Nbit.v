//////////////////////////////////////////////////////////////////////////////////
// Company: Tongji University
// Engineer: Charry Wang
// Email: charrywang7@gmail.com
// 
// Create Date: 2022/10/24 15:02:12
// Design Name: 
// Module Name: f_add_Nbit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision: 
// Revision 0.01 - File Created 
// Additional Comments: 
// 
//////////////////////////////////////////////////////////////////////////////////
 
 
module f_add_Nbit #(parameter DW = 32) (
	input [DW-1:0] a,
	input [DW-1:0] b,
	input cin,
	output [DW-1:0] sum,
	output cout
);
	/* verilator lint_off UNOPTFLAT */
	wire [DW-2:0] c;
	generate
		genvar i;
		f_add_1bit adder1(a[0], b[0], cin, sum[0], c[0]);
		for(i = 1; i < DW -1 ; i = i + 1) begin: add_block
			f_add_1bit adder2(a[i], b[i], c[i-1], sum[i], c[i]);
		end
		f_add_1bit adder3(a[DW-1], b[DW-1], c[DW-2], sum[DW-1], cout);
	endgenerate

endmodule

