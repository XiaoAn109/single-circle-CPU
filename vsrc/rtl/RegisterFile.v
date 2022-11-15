//////////////////////////////////////////////////////////////////////////////////
// Company: Tongji University
// Engineer: Charry Wang
// Email: charrywang7@gmail.com
// 
// Create Date: 2022/10/24 11:55:33
// Design Name: 
// Module Name: RegisterFile
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
 
 
module RegisterFile #(parameter AW = 5, DW = 32) (
	input clk,
	input [DW-1:0] wdata,
	input [AW-1:0] waddr,
	input wen,
	input [AW-1:0] raddr1,
	input [AW-1:0] raddr2,
	output [DW-1:0] rdata1,
	output [DW-1:0] rdata2
);
	reg [DW-1:0] rf [0:2**AW-1];
	// integer i;
	// initial begin
	// 	for(i = 0; i < 2**AW; i = i + 1)
	// 		rf[i] = 0;
	// end

	always @(posedge clk) begin
		if(wen && waddr != 0) rf[waddr] <= wdata;
	end
	

	assign rdata1 = (raddr1 == 0) ? 0 : rf[raddr1];
	assign rdata2 = (raddr2 == 0) ? 0 : rf[raddr2];
endmodule

