`timescale 1ns/10ps
module tb();

parameter DW = 32;
parameter AW = 32;
parameter IW = 32;

integer numcycles;

reg clk;
reg rst;
reg [8*30:1] testcase; //name of testcase

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

integer i;


initial begin
    $dumpfile("wave.vcd");
    $dumpvars;
    #1000 $finish;
end


initial begin:TestBench
    #80
    // output the state of every instruction
    $monitor("cycle=%d, pc=%h, instruct= %h op=%h, rs1=%h,rs2=%h, rd=%h, imm=%h",
              numcycles,  mycpu.pc, inst, mycpu.myCtrl.opcode,
              mycpu.myRegFile.raddr1, mycpu.myRegFile.raddr2, mycpu.myRegFile.waddr, mycpu.imm_out);

    testcase = "add";
    loadtestcase();
    resetcpu();
    step();
    checkreg(6,100); //t1==100
    step();
    checkreg(7,20);  //t2=20
    step();
    checkreg(28,120); //t3=120
    display_reg();
    $finish;
end

task step;
    begin
        #9 clk = 1'b1;
        #10 clk = 1'b0;
        numcycles = numcycles + 1;
        #1;
    end
endtask

task stepn;
input integer n;
integer i;
    begin
        for(i = 0; i < n; i = i + 1)
            step();
    end
endtask

task resetcpu;
    begin
        rst = 1'b1;
        randomize_reg(0);
        // randomize_data();
        step();
        #5 rst = 1'b0;
        numcycles = 0;
        step(); //push the time to the first instruction
    end
endtask

task loadtestcase;  //load intstructions to instruction mem
  begin
    $readmemh({testcase, ".hex"}, instructions.mem);
    $display("---Begin test case %s-----", testcase);
  end
endtask

task randomize_reg;
input integer random;
integer i, j;
    begin
        mycpu.myRegFile.rf[0] = 0;
        if(random == 0) begin
            for(i = 1; i < 32; i = i + 1)
                mycpu.myRegFile.rf[i] = 0;
        end
        else if(random == 1) begin
            for(i = 1; i < 32; i = i + 1)
                mycpu.myRegFile.rf[i] = {$random} % 256;
        end
        $display("After radomization, Regs are:");
        for(i = 0; i < 8; i = i + 1) begin
            for(j = 0; j < 4; j = j + 1) begin
                $write("x%-2d=%d  ", i*4+j, mycpu.myRegFile.rf[i*4+j]);
            end
            $display;
        end
    end
endtask

task display_reg;
integer i, j;
    begin
        $display("After Simulation, Regs are:");
        for(i = 0; i < 8; i = i + 1) begin
            for(j = 0; j < 4; j = j + 1) begin
                $write("x%-2d=0x%x  ", i*4+j, mycpu.myRegFile.rf[i*4+j]);
            end
            $display;
        end
    end
endtask

task randomize_data;
integer i;
    begin
        for(i = 0; i < 2**16; i = i + 1)
            data.mem[i] = {$random} % 1024;
    end
endtask

task checkreg;//check registers
  input [4:0] regid;
  input [31:0] results;
  reg [31:0] debugdata;
  begin
    debugdata=mycpu.myRegFile.rf[regid]; //get register content
    if(debugdata==results)
    begin
        $display("OK: end of cycle %d reg %h need to be %h, get %h",
                  numcycles-1, regid, results, debugdata);
    end
  else
  begin
    $display("!!!Error: end of cycle %d reg %h need to be %h, get %h",
              numcycles-1, regid, results, debugdata);
    end
  end
endtask


endmodule
