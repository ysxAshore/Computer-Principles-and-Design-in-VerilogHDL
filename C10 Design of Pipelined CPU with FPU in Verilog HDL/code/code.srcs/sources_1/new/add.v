`timescale 1ns / 1ps

module add(
    input [47:0]sum,
    input [47:0]c,
    output [47:0]res
);
    assign res=sum+(c<<1);
endmodule
