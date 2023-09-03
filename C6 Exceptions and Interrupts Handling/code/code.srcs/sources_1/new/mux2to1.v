`timescale 1ns / 1ps

module mux2to1(
    input [31:0]a,b,
    input sel,

    output [31:0]res
);
    assign res=sel?b:a;
endmodule
