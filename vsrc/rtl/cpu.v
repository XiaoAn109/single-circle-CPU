//////////////////////////////////////////////////////////////////////////////////
// Company: Tongji University
// Engineer: Charry Wang
// Email: charrywang7@gmail.com
// 
// Create Date: 2022/10/25 16:06:38
// Design Name: 
// Module Name: cpu
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
 
 
module cpu #(parameter DW = 32, AW = 32, IW = 32) (
    input clk, 
    input rst,
    input [IW-1:0] imemdataout,
    input [DW-1:0] dmemdataout,
    output [AW-1:0] imemaddr,
    output [AW-1:0] dmemaddr,
    output [DW-1:0] dmemdatain,
    output imemrclk,
    output dmemrclk,
    output dmemwclk,
    output [2:0] dmemop,
    output dmemwe
);
    wire pclk;
    wire [AW-1:0] next_pc;
    wire [AW-1:0] pc;
    wire regclk;
    wire [DW-1:0] regdatain;
    wire RegWr;
    wire [DW-1:0] rs1;
    wire [DW-1:0] rs2;
    wire [2:0] ExtOp;
    wire [DW-1:0] imm_out;
    wire [2:0] Branch;
    wire Mem2Reg;
    wire MemWr;
    wire [2:0] MemOp;
    wire ALUAsrc;
    wire [1:0] ALUBsrc;
    wire [3:0] ALUctrl;
    wire [DW-1:0] opa;
    wire [DW-1:0] opb;
    wire [DW-1:0] ALUout;
    wire less;
    wire zero;
    wire PCAsrc;
    wire PCBsrc;
    wire [DW-1:0] pca;
    wire [DW-1:0] pcb;

    assign pclk = ~clk;
    assign regclk = ~clk;
    assign imemaddr = next_pc;
    assign dmemaddr = ALUout;
    assign imemrclk = ~clk;
    assign dmemrclk = clk;
    assign dmemwclk = ~clk;
    assign dmemop = MemOp;
    assign dmemwe = MemWr;
    assign dmemdatain = rs2;


    ProgramCounter myPC(.clk(pclk), .rst(rst), .next_pc(next_pc), .pc(pc));
    RegisterFile myRegFile(.clk(regclk), .wdata(regdatain), .waddr(imemdataout[11:7]), .wen(RegWr), 
                    .raddr1(imemdataout[19:15]), .raddr2(imemdataout[24:20]), 
                    .rdata1(rs1), .rdata2(rs2));
    imm myImm(.inst_in(imemdataout[31:7]), .ExtOp(ExtOp), .imm_out(imm_out));
    ctrl myCtrl(.opcode(imemdataout[6:0]), .func3(imemdataout[14:12]), .func7(imemdataout[31:25]), 
            .ExtOp(ExtOp), .RegWr(RegWr), .Branch(Branch), .Mem2Reg(Mem2Reg), .MemWr(MemWr), 
            .MemOp(MemOp), .ALUAsrc(ALUAsrc), .ALUBsrc(ALUBsrc), .ALUctrl(ALUctrl));
    alu myALU(.opa(opa), .opb(opb), .ALUctrl(ALUctrl), .ALUout(ALUout), .less(less), .zero(zero));
    branch_cond myBranch(.Branch(Branch), .zero(zero), .less(less), .PCAsrc(PCAsrc), .PCBsrc(PCBsrc));

    MuxKeyWithDefault #(2, 1, DW) opaMux(.out(opa), .key(ALUAsrc), .default_out(0), .lut({
        1'b0, rs1,
        1'b1, pc
    }));

    MuxKeyWithDefault #(3, 2, DW) opbMux(.out(opb), .key(ALUBsrc), .default_out(0), .lut({
        2'b00, rs2,
        2'b01, imm_out,
        2'b10, {{(DW-3){1'b0}}, 3'h4}
    }));

    MuxKeyWithDefault #(2, 1, DW) pcaMux(.out(pca), .key(PCAsrc), .default_out(0), .lut({
        1'b0, {{(DW-3){1'b0}}, 3'h4},
        1'b1, imm_out
    }));

    MuxKeyWithDefault #(2, 1, DW) pcbMux(.out(pcb), .key(PCBsrc), .default_out(0), .lut({
        1'b0, pc,
        1'b1, rs1
    }));

    MuxKeyWithDefault #(2, 1, DW) reginMux(.out(regdatain), .key(Mem2Reg), .default_out(0), .lut({
        1'b0, ALUout,
        1'b1, dmemdataout
    }));

    adder myAdder(.opa(pca), .opb(pcb), .cin(1'b0), .result(next_pc), .carry(), .zero(), .overflow());

endmodule

