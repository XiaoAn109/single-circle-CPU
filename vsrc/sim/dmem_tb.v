`timescale 1ns/10ps
module dmem_tb();

reg clk;
wire rclk;
wire wclk;
// reg [31:0] raddr;
// reg [31:0] waddr;
reg [31:0] addr;
reg [31:0] din;
reg [2:0] MemOp;
reg MemWr;

wire [31:0] dout;

data_mem dmem(rclk, wclk, addr, addr, din, MemOp , MemWr, dout);

initial begin
    $dumpfile("dmem.vcd");
    $dumpvars;
    #1000 $finish;
end

assign rclk = clk;
assign wclk = clk;




initial begin : dmem_test
    integer i;
    randomize_init();
    repeat(5) begin
        i = {$random}%32'hffffffff;
        $display("---------------\nBefore write:");
        read_mem(i, 0, 3'b101);
        write_mem(i, 1, 3'b001, {$random}%32'hffffffff);
        $display("After write:");
        read_mem(i, 0, 3'b101);
    end
end

task randomize_init;
integer i;
    begin
        for(i = 0; i < 2**15; i = i + 1)
            dmem.mem[i] = {$random}%32'hffffffff;
    end
endtask


task read_mem;
input [31:0] raddr;
input wen;
input [2:0] dop;
    begin
        #9 clk = 1'b0;
        MemWr = wen;
        MemOp = dop;
        addr = raddr;
        #10 clk = 1'b1;
        #1;
        $display("read  addr=0x%08x, dop=%b, dout=0x%08x", addr, MemOp, dout);
    end
endtask

task write_mem;
input [31:0] waddr;
input wen;
input [2:0] dop;
input [31:0] wdata;
    begin
        #9 clk = 1'b0;
        MemWr = wen;
        MemOp = dop;
        addr = waddr;
        din = wdata;
        #10 clk = 1'b1;
        #1;
        $display("write addr=0x%08x, dop=%b, din =0x%08x", addr, MemOp, din);
    end
endtask

endmodule
