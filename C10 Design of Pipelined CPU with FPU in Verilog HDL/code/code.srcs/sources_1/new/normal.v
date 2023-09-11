`timescale 1ns / 1ps

module normal(
    input aisinf,aiszero,aisnan,bisinf,biszero,bisnan,
    input [1:0]rm,
    input [23:0]nan_frac,
    input sign,
    input [9:0]exp,
    input [47:0]res,
    output reg[31:0]s
);
    reg [47:0]temp_frac;//xx.xxxxx
    reg [9:0]temp_e;
    reg [27:0]frac;
    wire [149:0]min={149'b0,1'b1};
    reg [149:0]cmin;
    //规格化
    always @(*) begin
        temp_frac=res;
        temp_e=exp;
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
