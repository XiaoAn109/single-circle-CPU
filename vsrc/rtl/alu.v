//////////////////////////////////////////////////////////////////////////////////
// Company: Tongji University
// Engineer: Charry Wang
// Email: charrywang7@gmail.com
// 
// Create Date: 2022/10/25 09:40:48
// Design Name: 
// Module Name: alu
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
 
 
module alu #(parameter DW = 32) (
    input [DW-1:0] opa,
	input [DW-1:0] opb,
	input [3:0] ALUctrl,
	output [DW-1:0] ALUout,
	output less,
	output zero
);

	wire AL_sel;
	wire LR_sel;
	wire US_sel;
	wire SA_sel;
	wire [2:0] aluctrl;
	wire [DW-1:0] result;
	wire carry;
	wire overflow;
	wire [DW-1:0] shift;
	wire [DW-1:0] a_and_b;
	wire [DW-1:0] a_or_b;
	wire [DW-1:0] a_xor_b;

	
	alu_ctrl i0(ALUctrl, AL_sel, LR_sel, US_sel, SA_sel, aluctrl);
	adder i1(opa, opb, SA_sel, result, carry, zero, overflow);
	barrel_shifter i2(opa, opb[4:0], AL_sel, LR_sel, shift);
	// and i3(a_and_b, opa, opb);
	// or i4(a_or_b, opa, opb);
	// xor i5(a_xor_b, opa, opb);
	assign a_and_b = opa & opb;
	assign a_or_b = opa | opb;
	assign a_xor_b = opa ^ opb;
	
	MuxKey #(2, 1, 1) i6(less, US_sel, {
		1'b0, result[DW-1] ^ overflow,
		1'b1, SA_sel ^ carry
	});
	MuxKey #(8, 3, DW) i7(ALUout, aluctrl, {
		3'b000, result,
		3'b001, shift,
		3'b010, {{(DW-1){1'b0}}, less},
		3'b011, opb,
		3'b100, a_xor_b,
		3'b101, shift,
		3'b110, a_or_b,
		3'b111, a_and_b
	});


endmodule

