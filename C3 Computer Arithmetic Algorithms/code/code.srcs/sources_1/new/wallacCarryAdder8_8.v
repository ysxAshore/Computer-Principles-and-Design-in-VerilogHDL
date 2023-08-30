`timescale 1ns / 1ps

module wallacCarryAdder8_8(
    input [7:0]a,b,
    output [15:0]res
);
    wire [15:0]sum,c;
    assign res=sum+(c<<1);
    wallac8_8  wallac8_8_inst (
        a,b,sum,c
    );
endmodule
