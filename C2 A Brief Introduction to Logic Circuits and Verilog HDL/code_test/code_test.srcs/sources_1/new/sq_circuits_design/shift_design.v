`timescale 1ns / 1ps

module shift_design(
    input load,
    input clk,
    input clrn,

    input [2:0]d,
    input di,

    output [2:0]q,
    output d_o
);
    wire q1,q2;
    wire d1=load?d[2]:di;
    wire d2=load?d[1]:q1;
    wire d3=load?d[0]:q2;

    floprc_sync fl(clk,0,clrn,d1,q1);
    floprc_sync f2(clk,0,clrn,d2,q2);
    floprc_sync f3(clk,0,clrn,d3,d_o);
    assign q[2]=q1;
    assign q[1]=q2;
    assign q[2]=d_o;
endmodule
