`timescale 1ns / 1ps

module addsub4_design(
    input [3:0]a,b,
    input ci,sign,sub,

    output [3:0]s,
    output co,
    //溢出判断
    output overflow,
    output cf_take
);
    wire [3:0]c;

    //从整体的角度来看a-b-ci,在级联过程中，后一个的进位输出到前一个的进位输入并不需要与sub异或
    fullAdder_designBybehav a1(a[0],b[0]^sub,ci^sub,c[0],s[0]);
    fullAdder_designBybehav a2(a[1],b[1]^sub,c[0],c[1],s[1]);
    fullAdder_designBybehav a3(a[2],b[2]^sub,c[1],c[2],s[2]);
    fullAdder_designBybehav a4(a[3],b[3]^sub,c[2],c[3],s[3]);
    
    assign co=c[3];
    //有符号只有溢出概念：符号位进位和数值位进位异或
    //无符号：加法时有进位输出则溢出，减法时小于则借位
    assign overflow=sign?(c[3]^c[2]):~sub&c[3];
    assign cf_take=~sign&sub&(a<b);//无符号数减法的借位
endmodule
