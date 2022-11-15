//////////////////////////////////////////////////////////////////////////////////
// Company: Tongji University
// Engineer: Charry Wang
// Email: charrywang7@gmail.com
// 
// Create Date: 2022/10/25 08:57:15
// Design Name: 
// Module Name: inst_mem
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
 
 
module inst_mem#(parameter AW = 32, IW = 32, DEPTH = 16) (
    input rclk,
    input [AW-1:0] raddr,
    output reg [IW-1:0] inst
);

    reg [IW-1:0] mem [0:2**DEPTH-1]; //Default: 64K Instructions
    // integer i;

    // initial begin
    //     for(i = 0; i < 2**DEPTH; i = i + 1) mem[i] = 0;
    // end

    // initial begin
    //     $readmemh("inst_mem.txt", mem);
    // end

    always @(posedge rclk) begin
        if(raddr[AW-1:DEPTH] == 0 && raddr[1:0] == 0) inst = mem[raddr[DEPTH-1:2]];
        else inst = 0;
    end


endmodule

