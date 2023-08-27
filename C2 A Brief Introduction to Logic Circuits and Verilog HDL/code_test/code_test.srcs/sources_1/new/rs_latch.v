`timescale 1ns / 1ps

module rs_latch(
    input s,r,
    output q,qn
);
    nand nand1(q,s,qn);
    nand nand2(qn,r,q);
endmodule
