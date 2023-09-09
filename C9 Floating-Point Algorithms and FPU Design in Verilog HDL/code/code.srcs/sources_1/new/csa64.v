`timescale 1ns / 1ps

module csa #(parameter WIDTH = 50)(
    input [WIDTH-1:0]a,b,t,
    output reg[WIDTH-1:0]s,c
);
    integer i;
    always @(*) begin
        for ( i= 0; i<WIDTH; i=i+1) begin
            {c[i],s[i]}=a[i]+b[i]+t[i];
        end
    end
endmodule
