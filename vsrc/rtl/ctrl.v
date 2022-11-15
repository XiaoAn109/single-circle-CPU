//////////////////////////////////////////////////////////////////////////////////
// Company: Tongji University
// Engineer: Charry Wang
// Email: charrywang7@gmail.com
// 
// Create Date: 2022/10/25 10:13:30
// Design Name: 
// Module Name: ctrl
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
 
 
module ctrl(
    input [6:0] opcode,
    input [2:0] func3,
    input [6:0] func7,
    output [2:0] ExtOp,
    output RegWr,
    output [2:0] Branch,
    output Mem2Reg,
    output MemWr,
    output [2:0] MemOp,
    output ALUAsrc,
    output [1:0] ALUBsrc,
    output [3:0] ALUctrl
);

    MuxKeyWithDefault #(8, 5, 3) i0(ExtOp, opcode[6:2], 3'b0, {
        5'b01101, 3'b001, //lui U type
        5'b00101, 3'b001, //auipc U type
        5'b00100, 3'b000, //I type
        5'b11011, 3'b100, //jal J type
        5'b11001, 3'b000, //jalr I type
        5'b11000, 3'b011, //B type
        5'b00000, 3'b000, //load I type
        5'b01000, 3'b010  //S type
    });

    MuxKeyWithDefault #(9, 5, 1) i1(RegWr, opcode[6:2], 1'b0, {
        5'b01101, 1'b1, //lui U type
        5'b00101, 1'b1, //auipc U type
        5'b00100, 1'b1, //I type
        5'b01100, 1'b1, //R type
        5'b11011, 1'b1, //jal J type
        5'b11001, 1'b1, //jalr I type
        5'b11000, 1'b0, //B type
        5'b00000, 1'b1, //load I type
        5'b01000, 1'b0  //S type
    });

    assign Branch = (opcode[6:2] == 5'b11011) ? 3'b001 : ( 
                    (opcode[6:2] == 5'b11001) ? 3'b010 : (
                    (opcode[6:2] != 5'b11000) ? 3'b000 : (
                    (func3 == 3'b000) ? 3'b100 : (
                    (func3 == 3'b001) ? 3'b101 : (
                    (func3 == 3'b100) ? 3'b110 : (
                    (func3 == 3'b101) ? 3'b111 : (
                    (func3 == 3'b110) ? 3'b110 : (
                    (func3 == 3'b111) ? 3'b111 : 3'b000    
                    ))))))));

    assign Mem2Reg = (opcode[6:2] == 5'b00000);

    assign MemWr = (opcode[6:2] == 5'b01000);

    assign MemOp = (opcode[6:2] == 5'b00000 || opcode[6:2] == 5'b01000) ? func3 : 3'b000;

    assign ALUAsrc = (opcode[6:2] == 5'b00101 || opcode[6:2] == 5'b11011 || opcode[6:2] == 5'b11001);

    MuxKeyWithDefault #(9, 5, 2) i2(ALUBsrc, opcode[6:2], 2'b0, {
        5'b01101, 2'b01, //lui U type
        5'b00101, 2'b01, //auipc U type
        5'b00100, 2'b01, //I type
        5'b01100, 2'b00, //R type
        5'b11011, 2'b10, //jal J type
        5'b11001, 2'b10, //jalr I type
        5'b11000, 2'b00, //B type
        5'b00000, 2'b01, //load I type
        5'b01000, 2'b01  //S type
    });

    assign ALUctrl = (opcode[6:2] == 5'b01101) ? 4'b0011 : ( //lui
                     (opcode[6:2] == 5'b00101 || //auipc 
                      opcode[6:2] == 5'b11011 || //jal
                      opcode[6:2] == 5'b11001 || //jalr
                      opcode[6:2] == 5'b00000 || //load I type
                      opcode[6:2] == 5'b01000) ? 4'b0000 : ( //S type
                    ((opcode[6:2] == 5'b00100 || //sltiu
                      opcode[6:2] == 5'b01100) && func3 == 3'b011) ? 4'b1010 : ( //sltu
                     (opcode[6:2] == 5'b11000 && (func3 == 3'b000 || //beq
                      func3 == 3'b001 || //bne
                      func3 == 3'b100 || //blt
                      func3 == 3'b101)) ? 4'b0010 : ( //bge
                     (opcode[6:2] == 5'b11000 && (func3 == 3'b110 || //bltu
                      func3 == 3'b111)) ? 4'b1010 : ( //bgeu
                     (opcode[6:2] == 5'b00100 && func3 != 3'b001 && //slli
                      func3 != 3'b101) ? {1'b0, func3} : {func7[5], func3} //other I and R type
                      )))));



endmodule

