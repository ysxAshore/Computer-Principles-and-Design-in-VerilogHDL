`timescale 1ns / 1ps

module int2float(
    input [31:0]a,
    output reg[31:0]f,
    output reg p_lost
);
    integer i;
    reg [31:0]temp;
    reg sign;
    always @(a) begin
        temp=a;sign=0;i=31;//注意i每次都要设初值
        if (a[31]==1) begin
            sign=1;
            temp=~a+1;//负数处理换成绝对值
        end
        while (~temp[31]) begin
            temp=temp<<1;
            i=i-1;
        end
        f[31]=sign;
        f[30:23]=i+127;
        f[22:0]=temp[30:8];
        p_lost=|temp[7:0];
    end
endmodule
