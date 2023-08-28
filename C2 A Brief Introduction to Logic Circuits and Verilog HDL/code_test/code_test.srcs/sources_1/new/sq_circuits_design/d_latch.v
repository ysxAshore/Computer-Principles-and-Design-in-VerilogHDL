`timescale 1ns / 1ps

module d_latch(
    input d,c,
    output q,qn
);
    wire s,r,temp;
    not not_init(temp,d);
    nand nand1(s,d,c);
    nand nand2(r,temp,c);

    rs_latch  rs_latch_inst (
        .s(s),
        .r(r),
        .q(q),
        .qn(qn)
    );
endmodule