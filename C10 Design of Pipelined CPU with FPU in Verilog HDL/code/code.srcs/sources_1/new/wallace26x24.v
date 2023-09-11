`timescale 1ns / 1ps

module wallace26x24(
    input [25:0]a,
    input [23:0]b,
    output [49:0]sum,c
);
    reg[49:0]ab[23:0];
    integer i,j;
    always @(*) begin
        for ( i= 0; i<24;i=i+1) begin
            for (j = 0; j<26; j=j+1) begin
                ab[i][j]=b[i]*a[j];
            end
            ab[i][49:26]=32'b0;
        end
    end
    wire [49:0]sum1_1,c1_1,sum1_2,c1_2,sum1_3,c1_3,sum1_4,c1_4,sum1_5,c1_5,sum1_6,c1_6,sum1_7,c1_7,sum1_8,c1_8;
    csa #(.WIDTH(50))csa_1_1(ab[0],ab[1]<<1,ab[2]<<2,sum1_1,c1_1);
    csa #(.WIDTH(50))csa_1_2(ab[3]<<3,ab[4]<<4,ab[5]<<5,sum1_2,c1_2);
    csa #(.WIDTH(50))csa_1_3(ab[6]<<6,ab[7]<<7,ab[8]<<8,sum1_3,c1_3);
    csa #(.WIDTH(50))csa_1_4(ab[9]<<9,ab[10]<<10,ab[11]<<11,sum1_4,c1_4);
    csa #(.WIDTH(50))csa_1_5(ab[12]<<12,ab[13]<<13,ab[14]<<14,sum1_5,c1_5);
    csa #(.WIDTH(50))csa_1_6(ab[15]<<15,ab[16]<<16,ab[17]<<17,sum1_6,c1_6);
    csa #(.WIDTH(50))csa_1_7(ab[18]<<18,ab[19]<<19,ab[20]<<20,sum1_7,c1_7);
    csa #(.WIDTH(50))csa_1_8(ab[21]<<21,ab[22]<<22,ab[23]<<23,sum1_8,c1_8);

    wire [49:0]sum2_1,c2_1,sum2_2,c2_2,sum2_3,c2_3,sum2_4,c2_4,sum2_5,c2_5;
    csa #(.WIDTH(50))csa_2_1(sum1_1,c1_1<<1,sum1_2,sum2_1,c2_1);
    csa #(.WIDTH(50))csa_2_2(c1_2<<1,sum1_3,c1_3<<1,sum2_2,c2_2);
    csa #(.WIDTH(50))csa_2_3(sum1_4,c1_4<<1,sum1_5,sum2_3,c2_3);
    csa #(.WIDTH(50))csa_2_4(c1_5<<1,sum1_6,c1_6<<1,sum2_4,c2_4);
    csa #(.WIDTH(50))csa_2_5(sum1_7,c1_7<<1,sum1_8,sum2_5,c2_5);//c1_8未计算

    wire [49:0]sum3_1,c3_1,sum3_2,c3_2,sum3_3,c3_3;
    csa #(.WIDTH(50))csa_3_1(sum2_1,c2_1<<1,sum2_2,sum3_1,c3_1);
    csa #(.WIDTH(50))csa_3_2(c2_2<<1,sum2_3,c2_3<<1,sum3_2,c3_2);
    csa #(.WIDTH(50))csa_3_3(sum2_4,c2_4<<1,sum2_5,sum3_3,c3_3);//c2_5,c1_8未计算

    wire [49:0]sum4_1,c4_1,sum4_2,c4_2;
    csa #(.WIDTH(50))csa_4_1(sum3_1,c3_1<<1,sum3_2,sum4_1,c4_1);
    csa #(.WIDTH(50))csa_4_2(c3_2<<1,sum3_3,c3_3<<1,sum4_2,c4_2);//c2_5,c1_8未计算

    
    wire [63:0]sum5_1,c5_1,sum5_2,c5_2;
    csa csa_5_1(sum4_1,c4_1<<1,sum4_2,sum5_1,c5_1);
    csa csa_5_2(c4_2<<1,c2_5<<1,c1_8<<1,sum5_2,c5_2);

    wire [63:0]sum6_1,c6_1;
    csa csa_6_1(sum5_1,c5_1<<1,sum5_2,sum6_1,c6_1);//剩c5_2

    wire [63:0]sum7_1,c7_1;
    csa csa_7_1(sum6_1,c6_1<<1,c5_2<<1,sum,c);
endmodule
