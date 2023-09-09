`timescale 1ns / 1ps

module fmul_design(
    input [31:0]a,b,
    input [1:0]rm,
    output reg[31:0]s
);
    //判断特殊情况
    wire aexp_zero=~|a[30:23];
    wire bexp_zero=~|b[30:23];
    wire aexp_f=&a[30:23];
    wire bexp_f=&b[30:23];
    wire a_frac0=~|a[22:0];
    wire b_frac0=~|b[22:0];
    wire aiszero=aexp_zero&a_frac0;
    wire biszero=bexp_zero&b_frac0;
    wire aisinf=aexp_f&a_frac0;
    wire bisinf=bexp_f&b_frac0;
    wire aisnan=aexp_f&~a_frac0;
    wire bisnan=bexp_f&~b_frac0;
    wire [23:0]nan_frac={1'b0,b[22:0]}>{1'b0,a[22:0]}?{1'b1,b[22:0]}:{1'b1,a[22:0]};
    //计算结果的符号，和结果暂时的指数
    wire sign=a[31]^b[31];
    reg [9:0]temp_e;
    //wallace计算结果
    wire [23:0]a_frac={~aexp_zero,a[22:0]};
    wire [23:0]b_frac={~bexp_zero,b[22:0]};
    wire [47:0]sum,c;
    wallace24 wallace24_inst(a_frac,b_frac,sum,c);
    wire [47:0]temp=sum+(c<<1);
    reg [47:0]temp_frac;//xx.xxxxx
    reg [27:0]frac;
    wire [149:0]min={149'b0,1'b1};
    reg [149:0]cmin;
    //规格化
    always @(*) begin
        temp_frac=temp;
        temp_e={2'b0,a[30:23]}+{2'b0,b[30:23]}-10'd127+aexp_zero+bexp_zero;
        if (aiszero&bisinf|biszero&aisinf) begin
            s={sign,8'hff,nan_frac[22:0]};
        end else if (aisinf|bisinf) begin
            s={sign,8'hff,23'b0};
        end else if (aisnan|bisnan) begin
            s={sign,8'hff,nan_frac[22:0]};
        end else begin
            if (temp_frac[47]==1) begin//1x.xxxx
                temp_frac=temp_frac>>1;
                temp_e=temp_e+1;
            end else begin//0x.xxxx
                while (~temp_frac[46]&&temp_e>0) begin
                    temp_frac=temp_frac<<1;
                    temp_e=temp_e-1;
                end
            end
            frac={temp_frac[47:21],|temp_frac[20:0]};
            casex({rm,frac[3],frac[2:0],sign})
                7'b00_1_100_x:frac=frac+28'b1000;
                7'b00_x_1xx_x:begin
                    if (frac[2:0]>3'b100) begin
                        frac=frac+28'b1000;
                    end
                end
                7'b01_x_xxx_1:begin
                    if (frac[2:0]>3'b000) begin
                        frac=frac+28'b1000;
                    end
                end
                7'b10_x_xxx_0:begin
                    if (frac[2:0]>3'b000) begin
                        frac=frac+28'b1000;
                    end
                end
                default:frac=frac; 
            endcase
            if (frac[27]==1) begin
                frac=frac>>1;                    
                temp_e=temp_e+1;
            end else if (frac[26]==0) begin
                while (~frac[26]&&temp_e>0) begin
                    frac=frac<<1;
                    temp_e=temp_e-1;                    
                end
            end 
            if (temp_e[9]==1|temp_e<1)begin
                cmin[149:122]=frac;
                cmin=cmin>>~(temp_e-127)+1;
                if (cmin>min) begin
                    temp_e=0;
                    frac=frac>>1;
                end else begin
                    temp_e=0;
                    frac=0;
                end

            end
            casex({temp_e[9:0]>=10'h0ff,rm,sign})
                4'b0_xx_x:s={sign,temp_e[7:0],frac[25:3]};
                4'b1_00_x:s={sign,8'hff,23'b0};//无穷 
                4'b1_01_0:s={sign,8'hfe,23'h7fffff};//向负无穷
                4'b1_01_1:s={sign,8'hff,23'b0};
                4'b1_10_0:s={sign,8'hff,23'b0};
                4'b1_10_1:s={sign,8'hfe,23'h7fffff};//向正无穷
                4'b1_11_x:s={sign,8'hfe,23'h7fffff};//截断
            endcase

       end
    end
endmodule
