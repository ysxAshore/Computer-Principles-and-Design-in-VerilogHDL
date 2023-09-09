`timescale 1ns / 1ps

module partical(
    input [31:0]a,b,
    output aisinf,aiszero,aisnan,bisinf,biszero,bisnan,
    output [23:0]nan_frac,
    output sign,
    output [9:0]temp_e,
    output [47:0]sum,c
);
    //判断特殊情况
    wire aexp_zero=~|a[30:23];
    wire bexp_zero=~|b[30:23];
    wire aexp_f=&a[30:23];
    wire bexp_f=&b[30:23];
    wire a_frac0=~|a[22:0];
    wire b_frac0=~|b[22:0];
    assign aiszero=aexp_zero&a_frac0;
    assign biszero=bexp_zero&b_frac0;
    assign aisinf=aexp_f&a_frac0;
    assign bisinf=bexp_f&b_frac0;
    assign aisnan=aexp_f&~a_frac0;
    assign bisnan=bexp_f&~b_frac0;
    assign nan_frac={1'b0,b[22:0]}>{1'b0,a[22:0]}?{1'b1,b[22:0]}:{1'b1,a[22:0]};
    //计算结果的符号，和结果暂时的指数
    assign sign=a[31]^b[31];
    assign temp_e={2'b0,a[30:23]}+{2'b0,b[30:23]}-10'd127+aexp_zero+bexp_zero;
    //wallace计算结果
    wire [23:0]a_frac={~aexp_zero,a[22:0]};
    wire [23:0]b_frac={~bexp_zero,b[22:0]};
    wallace24 wallace24_inst(a_frac,b_frac,sum,c);
endmodule
