`timescale 1ns / 1ps

module cmos_nandOr_test();

    reg a,b;
    wire A,B;

    initial begin
        a=1;b=0;
        #5 a=0;b=1;
        #5 a=0;b=0;
        #5 a=1;b=1;
        #5 $finish;
    end
    cmos_nand  cmos_nand_inst (
        .a(a),
        .b(b),
        .f(A)
    );
    cmos_nor  cmos_nor_inst (
        .a(a),
        .b(b),
        .f(B)
    );
endmodule
