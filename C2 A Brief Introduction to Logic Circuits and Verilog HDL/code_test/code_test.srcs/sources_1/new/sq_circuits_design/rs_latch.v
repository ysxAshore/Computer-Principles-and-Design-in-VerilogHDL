`timescale 1ns / 1ps

module rs_latch(
    input s,r,
    output q,qn
);
    nand nand1(q,s,qn);
    nand nand2(qn,r,q);
endmodule

module rs_latch_high(
    input s,r,
    input clear,

    output q,qn
);
    assign q=clear?0:s|~r&q;
    assign qn=~q;
endmodule