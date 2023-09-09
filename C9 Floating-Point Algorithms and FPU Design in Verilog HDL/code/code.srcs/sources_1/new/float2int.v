`timescale 1ns / 1ps

module float2int(
    input [31:0]a,
    output reg [31:0]d,
    output reg p_lost,//精度损失
    output reg invalid,//超出整数表示范围
    output reg denorm//非正则数
);
    wire sign=a[31];
    wire [7:0]e=a[30:23];
    wire [54:0]s={|e,a[22:0],31'b0};
    reg [54:0]t;
    integer i;
    always @(a) begin//注意这里是跟a变
        i=158;//注意i的初始化
        if (e>=8'd158) begin
            p_lost=0;denorm=0;invalid=1;
            d=32'h8000_0000;
            if ((e==8'd158)&(sign==1)&(s[53:31]==23'b0)) begin
                invalid=0;
            end
        end else if (e<8'd127) begin
            d=32'b0;
            p_lost=|s;denorm=0;invalid=0;
            if (e==8'd0) begin//非正则、0
                if (s[54:31]==32'b0) begin
                    p_lost=0;
                end  else begin
                    denorm=1;
                end              
            end
        end else begin
            i=i-e;
            t=s>>i;
            d=sign?~t[54:23]+32'b1:t[54:23];//负数的处理
            p_lost=|t[22:0];invalid=0;denorm=0;
        end
    end
endmodule
