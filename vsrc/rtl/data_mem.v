module data_mem #(parameter AW = 32, DW = 32, DEPTH = 15) (
    input rclk,
    input wclk,
    input [AW-1:0] raddr,
    input [AW-1:0] waddr,
    input [DW-1:0] din,
    input [2:0] MemOp,
    input MemWr,
    output [DW-1:0] dout
);
    reg [DW-1:0] tmpout;
    wire [DW-1:0] tmpin;
    reg [DW-1:0] mem [0:2**DEPTH-1];
    // integer i;

    // initial begin
    //     for(i = 0; i < 2**DEPTH; i = i + 1) mem[i] = 0;
    // end
    
    always @(posedge rclk) begin
        if(MemWr) tmpout <= mem[waddr[DEPTH-1:0]];
        else tmpout <= mem[raddr[DEPTH-1:0]];
    end

    assign tmpin = (MemOp == 3'b000) ? {tmpout[DW-1:8], din[7:0]} : (
                   (MemOp == 3'b001) ? {tmpout[DW-1:16], din[15:0]} : (
                   (MemOp == 3'b010) ? din : tmpout));

    always @(posedge wclk) begin
       if(MemWr) mem[waddr[DEPTH-1:0]] <= tmpin; 
    end

    assign dout = (MemOp == 3'b000) ? {{(DW-8){tmpout[7]}}, tmpout[7:0]} : (
                  (MemOp == 3'b001) ? {{(DW-16){tmpout[15]}}, tmpout[15:0]} : (
                  (MemOp == 3'b010) ? tmpout : (
                  (MemOp == 3'b100) ? {{(DW-8){1'b0}}, tmpout[7:0]} : (
                  (MemOp == 3'b101) ? {{(DW-16){1'b0}}, tmpout[15:0]} : 0))));

endmodule
                   
