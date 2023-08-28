`timescale 1ns / 1ps

module jk_latch(
    input c,
    input j,k,
    output q,qn
);
    wire temp_s=~(j&qn&c);
    wire temp_r=~(c&k&q);
    rs_latch rs_latch_init(temp_s,temp_r,q,qn);
endmodule
