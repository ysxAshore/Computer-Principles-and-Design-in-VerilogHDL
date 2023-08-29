`timescale 1ns / 1ps

module ripper_adder4_design(
    input [3:0]a,b,
    input ci,sign,

    output [3:0]s,
    output co,
    //溢出判断
    output overflow
);
    wire [3:0]c;
    fullAdder_designBybehav a1(a[0],b[0],ci,c[0],s[0]);
    fullAdder_designBybehav a2(a[1],b[1],c[0],c[1],s[1]);
    fullAdder_designBybehav a3(a[2],b[2],c[1],c[2],s[2]);
    fullAdder_designBybehav a4(a[3],b[3],c[2],c[3],s[3]);
    assign co=c[3];
    //有符号溢出：符号位进位和数值位进位异或
    //无符号溢出：有进位输出则溢出
    assign overflow=sign?(c[3]^c[2]):c[3];
endmodule
