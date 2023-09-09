`timescale 1ns / 1ps

module fsqrt_design(
    input clk,clear,
    input [31:0]d,
    input [1:0]rm,
    input ifsqrt,

    output stall,
    output reg busy,
    output reg[4:0]count,
    output reg[31:0]res
);
    //1.判断特殊情况
    wire exp_isZero=~|d[30:23];
    wire exp_isF=&d[30:23];
    wire frac_isZero=~|d[22:0];
    wire isZero=exp_isZero&frac_isZero;
    wire isNeg=d[31];
    wire isInf=exp_isF&frac_isZero;
    wire isNan=exp_isF&~frac_isZero;
    //2.计算暂时的阶码，尾数
    wire [7:0]temp_exp={1'b0,d[30:24]}+8'd63+d[23];
    wire [23:0]tempFrac=exp_isZero?{d[22:0],1'b0}:{1'b1,d[22:0]};
    wire [23:0]temp_frac_=d[23]?{1'b0,tempFrac[23:1]}:tempFrac;//偶数-127为奇数，移1位即可。奇数-127为偶数，移两位
    wire [23:0]d_frac;
    wire [4:0]amount;
    shift_even shift_init(temp_frac_,d_frac,amount);
    wire [7:0]exp=temp_exp-{3'b0,amount};
    //3.迭代
    reg [25:0]reg_x;//xx.xxxxx
    reg [23:0]reg_d;//.xxx
    wire [51:0]x_2,sum1,c1;//xi*xi;//xxx.xx
    wire [51:0]x_2d,sum2,c2;//x_2*d;//xxx.xxx
    wire [51:0]_3subx_2d;//xxx.xxxx
    wire [51:0]x52,sum3,c3;//xi(3-xi^2d)
    wallace26x26 w1(reg_x,reg_x,sum1,c1);
    assign x_2=sum1+(c1<<1);
    wallace24x28 w2(x_2[51:24],reg_d,sum2,c2);
    assign x_2d=sum2+(c2<<1);
    assign _3subx_2d=26'h3000000-x_2d[49:24];
    wallace26x26 w3(reg_x,_3subx_2d,sum3,c3);
    assign x52=sum3+(c3<<1);
    always @(posedge clk or posedge clear) begin
        if (clear) begin
            count<=5'b0;
            busy<=1'b0;
        end else begin
            if (count==5'b0&ifsqrt) begin
                busy<=1'b1;
                count<=5'b1;
            end begin
               if (count==5'b1) begin
                    reg_x<={2'b01,rom(d_frac[23:19]),16'b0};
                    reg_d<=d_frac;
               end 
               if (count!=5'b0) count<=count+1'b1;
               if (count==5'h15) busy<=1'b0;
               if (count==5'h16) count<=5'b0;
               if (count==5'h8|count==5'hf|count==5'h16) reg_x=x52[50:25];
            end
        end
    end
    assign stall=ifsqrt&(count==5'b0|busy);

    //4.求sum、c
    wire [23:0]w_reg_d;//.xxxxx
    wire [25:0]w_reg_x;//xx.xxxxx
    wire wisZero,wisNan,wisInf,wisNeg;
    wire [7:0]wexp;
    wire [1:0]wrm;
    reg_design #(.WIDTH(64))r1(clk,~stall,clear,
    {reg_d,reg_x,isZero,isNan,isInf,isNeg,exp,rm},
    {w_reg_d,w_reg_x,wisZero,wisNan,wisInf,wisNeg,wexp,wrm});
    wire [49:0]sum,c;//x.xxxxx
    wallace26x24 w4(w_reg_x,w_reg_d,sum,c);
    //5.求和
    wire cisZero,cisNan,cisInf,cisNeg;
    wire [7:0]cexp;
    wire [1:0]crm;
    wire [49:0]csum,cc;//xx.xxxxxx
    reg_design #(.WIDTH(114))r2(clk,~stall,clear,{sum,c,wisZero,wisNan,wisInf,wisNeg,wexp,wrm},{csum,cc,cisZero,cisNan,cisInf,cisNeg,cexp,crm});
    wire [49:0]q=sum+(c<<1);//xx.xxxxxxx
    //6.规格化
    wire [49:0]nq;//xx.xxxxxx
    wire nisZero,nisNan,nisInf,nisNeg;
    wire [7:0]nexp;
    wire [1:0]nrm;
    reg_design #(.WIDTH(64))r3(clk,~stall,clear,{q,cisZero,cisNan,cisInf,cisNeg,cexp,crm},{nq,nisZero,nisNan,nisInf,nisNeg,nexp,nrm});
    reg [25:0]temp_frac;//xxxxxxx
    reg [7:0]temp_e;
    //对temp_e是做减法，不会上溢
    always @(*) begin
        temp_frac={nq[47:23],|nq[22:0]};
        temp_e=nexp;
        if (clear) begin
            res=0;
        end else if(~stall)begin//当流水线不阻塞时才允许计算
            if (nisZero) begin
                res={nisNeg,8'h0,23'h0};//0
            end else if (nisNan|nisNeg) begin
                res=32'h7fc00000;//负数开方和Nan开方结果均为Nan
            end else if (nisInf) begin
                res={nisNeg,8'hff,23'b0};
            end else begin
                while (~temp_frac[47]&temp_e>1) begin
                        temp_frac=temp_frac<<1;//不用移阶码
                end
                temp_frac=temp_frac<<1;//不用移阶码
                casex({nrm,temp_frac[3],temp_frac[2:0],nisNeg})
                    7'b00_1_100_x:temp_frac=temp_frac+28'b1000;
                    7'b00_x_1xx_x:begin
                        if (temp_frac[2:0]>3'b100) begin
                            temp_frac=temp_frac+26'b1000;
                        end
                    end
                    7'b01_x_xxx_1:begin
                        if (temp_frac[2:0]>3'b000) begin
                            temp_frac=temp_frac+26'b1000;
                        end
                    end
                    7'b10_x_xxx_0:begin
                        if (temp_frac[2:0]>3'b000) begin
                            temp_frac=temp_frac+26'b1000;
                        end
                    end
                endcase
                res={nisNeg,temp_e[7:0],temp_frac[25:3]};
            end
        end
        
    end
    function [7:0] rom; // a rom table: 1/d ̂ {1/2}
        input [4:0] d;
        case (d)
            5'h08: rom = 8'hff; 5'h09: rom = 8'he1;
            5'h0a: rom = 8'hc7; 5'h0b: rom = 8'hb1;
            5'h0c: rom = 8'h9e; 5'h0d: rom = 8'h9e;
            5'h0e: rom = 8'h7f; 5'h0f: rom = 8'h72;
            5'h10: rom = 8'h66; 5'h11: rom = 8'h5b;
            5'h12: rom = 8'h51; 5'h13: rom = 8'h48;
            5'h14: rom = 8'h3f; 5'h15: rom = 8'h37;
            5'h16: rom = 8'h30; 5'h17: rom = 8'h29;
            5'h18: rom = 8'h23; 5'h19: rom = 8'h1d;
            5'h1a: rom = 8'h17; 5'h1b: rom = 8'h12;
            5'h1c: rom = 8'h0d; 5'h1d: rom = 8'h08;
            5'h1e: rom = 8'h04; 5'h1f: rom = 8'h00;
            default: rom = 8'hff; // 0 - 7: not be accessed
        endcase
    endfunction
endmodule
