`timescale 1ns / 1ps

module fdiv_design(
    input clk,enable,clear,
    input [1:0]rm,
    input [31:0]a,b,
    input ifdiv,
    output reg [31:0]res,
    output stall,
    output reg busy,
    output reg[4:0]count
);
    //首先判断特殊情况
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

    //结果的符号，阶码和尾数
    wire sign=a[31]^b[31];
    wire [9:0]exp1={2'b0,a[30:23]}-{2'b0,b[30:23]}+10'd127;
    wire [23:0]a_tempfrac=aexp_zero?{a[22:0],1'b0}:{1'b1,a[22:0]};
    wire [23:0]b_tempfrac=bexp_zero?{b[22:0],1'b0}:{1'b1,b[22:0]};

    //求满足计算的尾数
    wire [23:0]a_frac,b_frac;
    wire [4:0]amount_a,amount_b;
    shift_toMSB1 getaFrac(a_tempfrac,a_frac,amount_a);
    shift_toMSB1 getbFrac(b_tempfrac,b_frac,amount_b);
    wire [9:0]exp2=exp1-amount_a+amount_b;

    reg [25:0]reg_x;//xx.xxxx
    reg [23:0]reg_b;//x.xxxx
    //迭代求xn
    wire [49:0]bxi,sum1,c1;//xx.xxxxxxxx
    wire [51:0]x52,sum2,c2;//xxx.xxxxxxxx
    wallace26x24 wallace26_24(reg_x,reg_b,sum1,c1);
    assign bxi=sum1+(c1<<1);
    wire [25:0]temp=~bxi[48:23]+1'b1;
    wallace26x26 wallace26_26(reg_x,temp,sum2,c2);
    assign x52=sum2+(c2<<1);
    always @(posedge clk or posedge clear) begin
        if (clear) begin
            count<=5'b0;
            busy<=1'b0;
        end else begin
            if (ifdiv&(count==5'b0)) begin
                count<=5'b1;
                busy<=1'b1;
            end else begin
                if (count==5'b1) begin
                    reg_x<={2'b01,rom(b_frac[22:19]),16'b0};//这书上不对
                    reg_b<=b_frac;
                end
                if (count!=0) count<=count+1;
                if (count==5'd15) busy<=5'd0;
                if (count==5'd16) count<=5'd0;
                if (count==5'd6|count==5'd11|count==5'd16) reg_x<=x52[50:25];
            end
        end
    end
    assign stall=ifdiv&(count==5'b0|busy);
    //寄存器
    wire [23:0]wa_frac;
    wire [25:0]wreg_x;
    wire [9:0]wtemp_e; 
    wire [1:0]wrm;
    wire waiszero,waisinf,waisnan,wbisinf,wbisnan,wbiszero,wsign;
    reg_design #(.WIDTH(69))r1(clk,~stall,clear,
    {aiszero,aisinf,aisnan,biszero,bisinf,bisnan,rm,reg_x,a_frac,exp2,sign},
    {waiszero,waisinf,waisnan,wbiszero,wbisinf,wbisnan,wrm,wreg_x,wa_frac,wtemp_e,wsign});
    //wallace求sum、c
    wire [49:0]sum,c;
    wallace26x24 wallace26_24_(wreg_x,wa_frac,sum,c);
    //寄存器
    wire [49:0]csum,cc;
    wire caiszero,caisinf,caisnan,cbiszero,cbisinf,cbisnan,csign;
    wire [1:0]crm;
    wire [9:0]ctemp_e;
    reg_design #(.WIDTH(119))r2(clk,~stall,clear,
    {waiszero,waisinf,waisnan,wbiszero,wbisinf,wbisnan,wrm,wtemp_e,wsign,sum,c},
    {caiszero,caisinf,caisnan,cbiszero,cbisinf,cbisnan,crm,ctemp_e,csign,csum,cc});

    //求和
    wire [49:0]q=csum+(cc<<1);//xx.xxxxx
    //寄存器
    wire [49:0]nq;
    wire naiszero,naisinf,naisnan,nbiszero,nbisinf,nbisnan,nsign;
    wire [1:0]nrm;
    wire [9:0]ntemp_e;
    reg_design #(.WIDTH(69))r3(clk,~stall,clear,
    {caiszero,caisinf,caisnan,cbiszero,cbisinf,cbisnan,crm,ctemp_e,csign,q},
    {naiszero,naisinf,naisnan,nbiszero,nbisinf,nbisnan,nrm,ntemp_e,nsign,nq});

    //规格化
    reg [49:0]temp_frac;//xx.xxxxx
    reg [9:0]temp_e;
    reg [27:0]frac;
    wire [149:0]min={149'b0,1'b1};
    reg [149:0]cmin;
    //规格化
    always @(*) begin
        temp_frac=nq;
        temp_e=ntemp_e;
        cmin=150'b0;
        if (naiszero&nbiszero|naisinf&nbisinf|naisnan) begin
            res=32'h7fc00000;//nan
        end else if (~naisinf&~naisnan&nbisinf) begin
            res={nsign,8'b0,23'b0};
        end else if (~naiszero&~naisnan&nbiszero) begin
            res={nsign,8'hff,23'b0};
        end else begin
            if (temp_frac[49]==1) begin//1x.xxxx
                temp_frac=temp_frac>>1;
                temp_e=temp_e+1;
            end else begin//0x.xxxx
                while (~temp_frac[48]&&temp_e>0) begin
                    temp_frac=temp_frac<<1;
                    temp_e=temp_e-1;
                end
            end
            frac={temp_frac[49:23],|temp_frac[22:0]};
            casex({nrm,frac[3],frac[2:0],nsign})
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
            casex({temp_e[9:0]>=10'h0ff,nrm,nsign})
                4'b0_xx_x:res={sign,temp_e[7:0],frac[25:3]};
                4'b1_00_x:res={sign,8'hff,23'b0};//无穷 
                4'b1_01_0:res={sign,8'hfe,23'h7fffff};//向负无穷
                4'b1_01_1:res={sign,8'hff,23'b0};
                4'b1_10_0:res={sign,8'hff,23'b0};
                4'b1_10_1:res={sign,8'hfe,23'h7fffff};//向正无穷
                4'b1_11_x:res={sign,8'hfe,23'h7fffff};//截断
            endcase

        end
    end
    function [7:0]rom;//隐含位1
        input [3:0]b;   
        case (b)
            4'h0:rom=8'hff;
            4'h1:rom=8'hd4;
            4'h2:rom=8'hc3;
            4'h3:rom=8'haa;
            4'h4:rom=8'h93;
            4'h5:rom=8'h7f;
            4'h6:rom=8'h6d;
            4'h7:rom=8'h5c;
            4'h8:rom=8'h4d;
            4'h9:rom=8'h3f;
            4'ha:rom=8'h33;
            4'hb:rom=8'h27;
            4'hc:rom=8'h1c;
            4'hd:rom=8'h12;
            4'he:rom=8'h08;
            4'hf:rom=8'h00;
        endcase
    endfunction
endmodule
