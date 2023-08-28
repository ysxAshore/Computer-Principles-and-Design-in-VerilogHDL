`timescale 1ns / 1ps

module cmos_andOr_test();
    reg a,b;
    wire A,B;
    initial begin
        a=0;b=0;
        #5 a=1;b=0;
        #5 a=0;b=1;
        #5 a=1;b=1;
    end
    
    cmos_and  cmos_and_inst (
        .a(a),
        .b(b),
        .f(A)
    );
    cmos_or  cmos_or_inst (
        .a(a),
        .b(b),
        .f(B)
    );
    
endmodule