`timescale 1ns / 1ps

//实现8*8的有符号乘法
module signed_mul(
    input [7:0]a,b,

    output reg[15:0]res
);
    reg [7:0]ab[7:0];
    integer i,j;
    always @(*) begin
        for (i=0;i<7;i=i+1) begin
            for (j=0;j<7;j=j+1) begin
                ab[j][i]=a[i]&b[j];
            end
        end
        for (i = 0; i<7; i=i+1) begin
            ab[7][i]=~(a[i]&b[7]);
        end
        for (j=0;j<7;j=j+1)begin
            ab[j][7]=~(a[7]&b[j]);
        end
        ab[7][7]=a[7]&b[7];
        res={8'b1,ab[0][7:0]}+
            {7'b0,ab[1][7:0],1'b0}+
            {6'b0,ab[2][7:0],2'b0}+
            {4'b0,ab[3][7:0],3'b0}+
            {3'b0,ab[4][7:0],4'b0}+
            {2'b0,ab[5][7:0],5'b0}+
            {1'b0,ab[6][7:0],6'b0}+
            {1'b1,ab[7][7:0],7'b0};
    end
endmodule
