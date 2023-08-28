`timescale 1ns / 1ps

module fifo_serio_design(
    input [31:0]d,
    input clrn,
    input read,write,

    output [31:0]q,
    output full,
    output empty
);
    wire clk1,clk2,clk3,clk4;
    wire [31:0]d12,d23,d34;
    wire q1,qn1,q2,qn2,q3,qn3,q4,qn4;

    flopr f1(clk1,0,d,d12);
    flopr f2(clk2,0,d12,d23);
    flopr f3(clk3,0,d23,d34);
    flopr f4(clk4,0,d34,q);

    wire temp1;
    floprc_async gen_temp1(write,0,clrn|clk1,~clrn,temp1);
    rs_latch_high gen_q1(clk1,clk2,clrn,q1,qn1);
    //clk1
    assign #1 clk1=temp1&qn1;

    rs_latch_high gen_q2(clk2,clk3,clrn,q2,qn2);
    //clk2
    assign #1 clk2=q1&qn2;

    rs_latch_high gen_q3(clk3,clk4,clrn,q3,qn3);
    //clk3
    assign #1 clk3=q2&qn3;

    rs_latch_high gen_q4(clk4,read,clrn,q4,qn4);
    //clk4
    assign #1 clk4=q3&qn4&~read;

    assign full=q1;
    assign empty=qn4;
endmodule



