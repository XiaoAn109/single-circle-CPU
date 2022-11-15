//////////////////////////////////////////////////////////////////////////////////
// Company: Tongji University
// Engineer: Charry Wang
// Email: charrywang7@gmail.com
// 
// Create Date: 2022/10/24 14:54:29
// Design Name: 
// Module Name: f_add_1bit
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
 
 
module f_add_1bit(
	input a,
	input b,
	input cin,
	output sum,
	output cout
);
	wire [2:0] tmp;
	xor i0(sum, a, b, cin);
	and i1(tmp[0], a, cin);
	and i2(tmp[1], b, cin);
	and i3(tmp[2], a, b);
	or  i4(cout, tmp[0], tmp[1], tmp[2]);


endmodule

