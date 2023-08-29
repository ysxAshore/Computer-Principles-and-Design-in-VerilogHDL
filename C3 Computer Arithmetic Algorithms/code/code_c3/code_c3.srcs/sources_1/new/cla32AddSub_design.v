`timescale 1ns / 1ps

module cla32AddSub_design(
    input [31:0]a,b,
    input c_in,sign,sub,

    output [31:0]s,
    output c_out,
    output overflow,//有符号数溢出，无符号数加法溢出
    output c_take//无符号数减法借位
);
    wire p_out,g_out,data_co;
    //以4位为例，sub^b是b和0001异或，但是b应该和1111异或
    cla_32 cla_32_init(a,{32{sub}}^b,sub^c_in,s,g_out,p_out,data_co);//加法时sub=0，减法时sub=1
    assign c_out=g_out+p_out&c_in;

    assign overflow=sign?c_out^data_co:(~sub&c_out);
    assign c_take=sub&~sign&(a<b);
endmodule
