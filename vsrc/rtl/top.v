module top(
    input clk,
    input rst
);


parameter DW = 32;
parameter AW = 32;
parameter IW = 32;



wire [IW-1:0] inst;
wire [DW-1:0] dout;
wire [AW-1:0] iaddr;
wire [AW-1:0] daddr;
wire [DW-1:0] din;

wire irclk;
wire drclk;
wire dwclk;
wire [2:0] dop;
wire dwe;

cpu mycpu(.clk(clk), .rst(rst), .imemdataout(inst), .dmemdataout(dout), 
       .imemaddr(iaddr), .dmemaddr(daddr), .dmemdatain(din), 
       .imemrclk(irclk), .dmemrclk(drclk), .dmemwclk(dwclk), 
       .dmemop(dop), .dmemwe(dwe));

inst_mem instructions(.rclk(irclk), .raddr(iaddr), .inst(inst));

data_mem data(.rclk(drclk), .wclk(dwclk), .raddr(daddr), .waddr(daddr), 
            .din(din), .MemOp(dop), .MemWr(dwe), .dout(dout));

endmodule