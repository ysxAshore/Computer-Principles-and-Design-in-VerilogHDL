`timescale 1ns / 1ps

module normal_design(
    input [27:0]cal_frac,
    input isNan,isInf,sign,
    input [23:0]nan_frac,inf_frac,
    input [31:0]fp_large,fp_small,
    input [7:0]temp_e,
    input [1:0]crm,

    output reg[31:0]s
);
    reg [27:0]temp_frac;
    integer  i;
    //规格化
    always @(*) begin
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
            casex({crm,temp_frac[3],temp_frac[2:0],sign})
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
                while (~temp_frac[26]&i>0) begin
                    temp_frac=temp_frac<<1;
                    i=i-1;
                end
            end
            casex({i[7:0]==8'hff,crm,sign})
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
