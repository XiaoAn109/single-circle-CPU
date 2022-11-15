//////////////////////////////////////////////////////////////////////////////////
// Company: Tongji University
// Engineer: Charry Wang
// Email: charrywang7@gmail.com
// 
// Create Date: 2022/10/24 13:46:44
// Design Name: 
// Module Name: ProgramCounter
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
 
 
module ProgramCounter #(parameter AW = 32) (
	input clk,
	input rst,
	input [AW-1:0] next_pc,
	output reg [AW-1:0] pc
);


	always @(posedge clk) begin
		if(rst) pc <= -4;
		else pc <= next_pc;
	end


endmodule

