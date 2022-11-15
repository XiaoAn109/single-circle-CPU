//////////////////////////////////////////////////////////////////////////////////
// Company: Tongji University
// Engineer: Charry Wang
// Email: charrywang7@gmail.com
//
// Create Date: 2022/10/24 21:46:49
// Design Name:
// Module Name: alu_ctrl
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


module alu_ctrl(
    input [3:0] ALUctrl,
    output AL_sel, //arithmetic/logic
    output LR_sel, //left/right
    output US_sel, //unsigned/signed
    output SA_sel, //sub/add
    output [2:0] aluctrl
  );
    //sel default:0
    assign SA_sel = (ALUctrl == 4'b1000 || ALUctrl[2:0] == 3'b010);
    assign AL_sel = (ALUctrl == 4'b1101);
    assign LR_sel = (ALUctrl[2:0] == 3'b001);
    assign US_sel = (ALUctrl == 4'b1010);
    assign aluctrl = ALUctrl[2:0];

endmodule

