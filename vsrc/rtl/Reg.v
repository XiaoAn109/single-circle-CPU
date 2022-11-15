//////////////////////////////////////////////////////////////////////////////////
// Company: Tongji University
// Engineer: Charry Wang
// Email: charrywang7@gmail.com
// 
// Create Date: 2022/10/24 13:51:22
// Design Name: 
// Module Name: Reg
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
 
 
module Reg #(parameter WIDTH = 1, RESET_VAL = 0) (
	input clk,
	input rst,
	input [WIDTH-1:0] din,
	output reg [WIDTH-1:0] dout,
	input wen
);
	always @(posedge clk) begin
		if(rst) dout <= RESET_VAL;
		else if (wen) dout <= din;
	end

endmodule

