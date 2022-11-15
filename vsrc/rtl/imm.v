//////////////////////////////////////////////////////////////////////////////////
// Company: Tongji University
// Engineer: Charry Wang
// Email: charrywang7@gmail.com
// 
// Create Date: 2022/10/25 05:55:31
// Design Name: 
// Module Name: imm
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
 
 
module imm #(parameter DW = 32) (
	input [31:7] inst_in,
	input [2:0] ExtOp,
	output [DW-1:0] imm_out
);

	wire [DW-1:0] immI;
	wire [DW-1:0] immU;
	wire [DW-1:0] immS;
	wire [DW-1:0] immB;
	wire [DW-1:0] immJ;

	assign immI = {{(DW-12){inst_in[31]}}, inst_in[31:20]};
	assign immU = {inst_in[31:12], 12'b0};
	assign immS = {{(DW-12){inst_in[31]}}, inst_in[31:25], inst_in[11:7]};
	assign immB = {{(DW-12){inst_in[31]}}, inst_in[7], inst_in[30:25], inst_in[11:8], 1'b0};
	assign immJ = {{(DW-20){inst_in[31]}}, inst_in[19:12], inst_in[20], inst_in[30:21], 1'b0};

	MuxKeyWithDefault #(5, 3, DW) i0(imm_out, ExtOp, 0, {
		3'b000, immI,
		3'b001, immU,
		3'b010, immS,
		3'b011, immB,
		3'b100, immJ
	});

endmodule

