module branch_cond(
    input [2:0] Branch,
    input zero,
    input less,
    output PCAsrc,
    output PCBsrc
);

    assign PCAsrc = (Branch == 3'b000) ? 1'b0 : (
                    (Branch == 3'b001 || 
                     Branch == 3'b010) ? 1'b1 : (
                    (Branch == 3'b100) ? zero : (
                    (Branch == 3'b101) ? ~zero : (
                    (Branch == 3'b110) ? less : (
                    (Branch == 3'b111) ? ~less : 1'b0)))));

    assign PCBsrc = (Branch == 3'b010) ? 1'b1 : 1'b0;
    
endmodule