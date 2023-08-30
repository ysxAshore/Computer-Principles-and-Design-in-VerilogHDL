`timescale 1ns / 1ps

module wallaceSignedMul(
    input [7:0]a,b,

    output [15:0]sum,c,res
);
    reg [15:0]ab[7:0];
    integer i,j;
    //第一部分 与/与非阵列
    always @(*) begin
        for (i=0;i<7;i=i+1) begin
            ab[i][15:0]=16'b0;
            for (j=0;j<7;j=j+1) begin
                ab[i][j]=a[j]&b[i];
            end
        end
        ab[7]=16'b0;
        for (i = 0; i<7; i=i+1) begin
            ab[7][i]=~(a[i]&b[7]);
        end
        for (j=0;j<7;j=j+1)begin
            ab[j][7]=~(a[7]&b[j]);
        end
        ab[7][7]=a[7]&b[7];
        ab[0][8]=1;
        ab[7][8]=1;
    end

    //level1
    wire [15:0]sumLevel1_1,coLevel1_1,sumLevel1_2,coLevel1_2;
    csa csa_level1_1(ab[0],ab[1]<<1,ab[2]<<2,sumLevel1_1,coLevel1_1);
    csa csa_level1_2(ab[3]<<3,ab[4]<<4,ab[5]<<5,sumLevel1_2,coLevel1_2);

    //level2
    wire [15:0]sumLevel2_1,coLevel2_1,sumLevel2_2,coLevel2_2;
    csa csa_level2_1(sumLevel1_1,coLevel1_1<<1,sumLevel1_2,sumLevel2_1,coLevel2_1);
    csa csa_level2_2(coLevel1_2<<1,ab[6]<<6,ab[7]<<7,sumLevel2_2,coLevel2_2);

    //level3
    wire [15:0]sumLevel3_1,coLevel3_1;
    csa csa_level3_1(sumLevel2_1,coLevel2_1<<1,sumLevel2_2,sumLevel3_1,coLevel3_1);

    //level4
    csa csa_level4_1(sumLevel3_1,coLevel3_1<<1,coLevel2_2<<1,sum,c);
    assign res=sum+(c<<1);
endmodule
