//////////////////////////////////////////////////////////////////////////////////
// Company: Tongji University
// Engineer: Charry Wang
// Email: charrywang7@gmail.com
// 
// Create Date: 2022/10/24 22:06:41
// Design Name: 
// Module Name: barrel_shifter
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
 
 
module barrel_shifter #(parameter DW = 32, SW = 5) (
    input [DW-1:0] din,
    input [SW-1:0] shamt,
    input AL_sel,
    input LR_sel,
    output [DW-1:0] dout
);
    wire AL_mux;
    wire [DW-1:0] dtmp [SW:0];
    assign dtmp[0] = din;

    MuxKey #(2, 1, 1) i0(AL_mux, AL_sel, {
        1'b0, 1'b0,
        1'b1, din[DW-1]
    });

    generate
        genvar i, j;
        for(i = 0; i < SW; i = i + 1) begin: loop1
            for(j = 0; j < 2 ** i; j = j + 1) begin: mov1_loop
                MuxKey #(4, 2, 1) i1(dtmp[i+1][j], {LR_sel, shamt[i]}, {
                    2'b00, dtmp[i][j],
                    2'b01, dtmp[i][j+2 ** i],
                    2'b10, dtmp[i][j],
                    2'b11, 1'b0
                });
            end
            for(j = 2 ** i; j < DW - 2 ** i; j = j + 1) begin: mov2_loop
                MuxKey #(4, 2, 1) i2(dtmp[i+1][j], {LR_sel, shamt[i]}, {
                    2'b00, dtmp[i][j],
                    2'b01, dtmp[i][j+2**i],
                    2'b10, dtmp[i][j],
                    2'b11, dtmp[i][j-2**i]
                });
            end
            for(j = DW - 2 ** i; j < DW; j = j + 1) begin: mov3_loop
                MuxKey #(4, 2, 1) i3(dtmp[i+1][j], {LR_sel, shamt[i]}, {
                    2'b00, dtmp[i][j],
                    2'b01, AL_mux,
                    2'b10, dtmp[i][j],
                    2'b11, dtmp[i][j-2**i]
                });
            end
        end
    endgenerate

    assign dout = dtmp[SW];


endmodule

