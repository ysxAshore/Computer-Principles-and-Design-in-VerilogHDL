`timescale 1ns / 1ps

module align_design(
    input [31:0]a,b,
    input [1:0]rm,
    input sub,

    output op_sub,isNan,isInf,sign,
    output [27:0]aligned_large_frac,aligned_small_frac,
    output [23:0]nan_frac,inf_frac,
    output [31:0]fp_large,fp_small,
    output [7:0]temp_e,
    output [1:0]crm
);
    //判断是否需要交换
    wire exchange=(a[30:0]<b[30:0])?1:0;
    assign fp_large=exchange?b:a;
    assign fp_small=exchange?a:b;
    //判断隐含位
    wire fp_large_hid=|fp_large[30:23];
    wire fp_small_hid=|fp_small[30:23];
    //得到尾数、判断结果的符号，阶码，实际进行的运算
    wire [23:0]fp_large_frac={fp_large_hid,fp_large[22:0]};
    wire [23:0]fp_small_frac={fp_small_hid,fp_small[22:0]};
    assign sign=exchange?sub^b[31]:a[31];
    assign temp_e=fp_large[30:23];
    assign op_sub=sub^fp_large[31]^fp_small[31];
    //判断是否有inf、nan
    wire fp_large_e1=&fp_large[30:23];
    wire fp_small_e1=&fp_small[30:23];
    wire fp_large_frac0=~|fp_large[22:0];
    wire fp_small_frac0=~|fp_small[22:0];
    wire fp_large_isnan=fp_large_e1&~fp_large_frac0;
    wire fp_small_isnan=fp_small_e1&~fp_small_frac0;
    wire fp_large_isinf=fp_large_e1&fp_large_frac0;
    wire fp_small_isinf=fp_small_e1&fp_small_frac0;
    assign isNan=fp_large_isnan|fp_small_isnan|(fp_large_isinf&fp_small_isinf&op_sub);
    assign isInf=(fp_large_isinf|fp_small_isinf)&~isNan;
    assign nan_frac=(a[22:0]>b[22:0])?{1'b1,a[22:0]}:{1'b1,b[22:0]};
    assign inf_frac=23'b0;

    wire [7:0]exp_diff=fp_large[30:23]-fp_small[30:23];
    wire small_den_only=(fp_large[30:23]!=0)&(fp_small[30:23]==0);
    wire [7:0]shift_amount=small_den_only?exp_diff-8'h1:exp_diff;
    wire [49:0]small_frac50=(shift_amount>26)?{26'h0,fp_small_frac}:{fp_small_frac,26'h0}>>shift_amount;
    wire[26:0]small_frac27={small_frac50[49:24],|small_frac50[23:0]};
    assign aligned_large_frac={1'b0,fp_large_frac,3'b000};
    assign aligned_small_frac={1'b0,small_frac27};
    assign crm=rm;
endmodule
