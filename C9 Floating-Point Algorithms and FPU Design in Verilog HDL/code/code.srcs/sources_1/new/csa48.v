`timescale 1ns / 1ps

module csa48(
    input [47:0]a,b,t,
    output reg[47:0]s,c
);
    integer i;
    always @(*) begin
        for ( i= 0; i<48; i=i+1) begin
            {c[i],s[i]}=a[i]+b[i]+t[i];
        end
    end
endmodule
