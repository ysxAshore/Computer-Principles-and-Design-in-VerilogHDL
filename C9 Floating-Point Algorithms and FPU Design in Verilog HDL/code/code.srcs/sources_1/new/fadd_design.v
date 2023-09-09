`timescale 1ns / 1ps

module fadd_design(
    input [31:0]a,b,
    input [1:0]rm,
    input sub,
    output reg [31:0]s
);
    //判断是否需要交换
    wire exchange=(a[30:0]<b[30:0])?1:0;
    wire [31:0]fp_large=exchange?b:a;
    wire [31:0]fp_small=exchange?a:b;
    //判断隐含位
    wire fp_large_hid=|fp_large[30:23];
    wire fp_small_hid=|fp_small[30:23];
    //得到尾数、判断结果的符号，阶码，实际进行的运算
    wire [23:0]fp_large_frac={fp_large_hid,fp_large[22:0]};
    wire [23:0]fp_small_frac={fp_small_hid,fp_small[22:0]};
    wire sign=exchange?sub^b[31]:a[31];
    wire [7:0]temp_e=fp_large[30:23];
    wire op_sub=sub^fp_large[31]^fp_small[31];
    //判断是否有inf、nan
    wire fp_large_e1=&fp_large[30:23];
    wire fp_small_e1=&fp_small[30:23];
    wire fp_large_frac0=~|fp_large[22:0];
    wire fp_small_frac0=~|fp_small[22:0];
    wire fp_large_isnan=fp_large_e1&~fp_large_frac0;
    wire fp_small_isnan=fp_small_e1&~fp_small_frac0;
    wire fp_large_isinf=fp_large_e1&fp_large_frac0;
    wire fp_small_isinf=fp_small_e1&fp_small_frac0;
    wire isNan=fp_large_isnan|fp_small_isnan|(fp_large_isinf&fp_small_isinf&op_sub);
    wire isInf=(fp_large_isinf|fp_small_isinf)&~isNan;
    wire nan_frac=(a[22:0]>b[22:0])?{1'b1,a[22:0]}:{1'b1,b[22:0]};
    wire inf_frac=23'b0;

    wire [7:0]exp_diff=fp_large[30:23]-fp_small[30:23];
    wire small_den_only=(fp_large[30:23]!=0)&(fp_small[30:23]==0);
    wire [7:0]shift_amount=small_den_only?exp_diff-8'h1:exp_diff;
    wire [49:0]small_frac50=(shift_amount>26)?{26'h0,fp_small_frac}:{fp_small_frac,26'h0}>>shift_amount;
    wire[26:0]small_frac27={small_frac50[49:24],|small_frac50[23:0]};
    wire [27:0]aligned_large_frac={1'b0,fp_large_frac,3'b000};
    wire [27:0]aligned_small_frac={1'b0,small_frac27};

    //计算
    wire [27:0]cal_frac=op_sub?aligned_large_frac-aligned_small_frac:aligned_large_frac+aligned_small_frac;
    reg [27:0]temp_frac;
    integer  i;
    //规格化
    always @(a,b,rm,sub) begin
        i=0;
        if (isInf) begin
            s={fp_large[31],8'hff,inf_frac};
        end else if (isNan) begin
            s={fp_large[31],8'hff,nan_frac};
        end else begin
            if (cal_frac[27]==1) begin
                temp_frac=cal_frac>>1;
                i=i+1;
                i=temp_e+i;
            end else if (cal_frac[26]==0) begin
                temp_frac=cal_frac<<1;//左移1位
                i=i+1;
                while (~temp_frac[26]&&i<27) begin
                    temp_frac=temp_frac<<1;
                    i=i+1;
                end
                i=(temp_e<i)?0:temp_e-i;
            end else begin
                temp_frac=cal_frac;
                i=temp_e;
            end
            casex({rm,temp_frac[3],temp_frac[2:0],sign})
                7'b00_1_100_x:temp_frac=temp_frac+28'b1000;
                7'b00_x_1xx_x:begin
                    if (temp_frac[2:0]>3'b100) begin
                        temp_frac=temp_frac+28'b1000;
                    end
                end
                7'b01_x_xxx_1:begin
                    if (temp_frac[2:0]>3'b000) begin
                        temp_frac=temp_frac+28'b1000;
                    end
                end
                7'b10_x_xxx_0:begin
                    if (temp_frac[2:0]>3'b000) begin
                        temp_frac=temp_frac+28'b1000;
                    end
                end
                default :   temp_frac=temp_frac; 
            endcase
            if (temp_frac[27]==1) begin
                temp_frac=temp_frac>>1;
                i=i+1;
            end else if (temp_frac[26]==0) begin
                while (~temp_frac[26]) begin
                    temp_frac=temp_frac<<1;
                    i=i-1;
                end
            end
            casex({i[7:0]==8'hff,rm,sign})
                4'b0_xx_x:s={sign,i[7:0],temp_frac[25:3]};
                4'b1_00_x:s={sign,i[7:0],23'b0};
                4'b1_01_0:s={sign,8'hfe,23'h7fffff};//向负无穷
                4'b1_01_1:s={sign,8'hff,23'b0};
                4'b1_10_0:s={sign,8'hff,23'b0};
                4'b1_10_1:s={sign,8'hfe,23'h7fffff};//向正无穷
                4'b1_11_x:s={sign,8'hfe,23'h7fffff};//截断
            endcase
        end
    end
endmodule
