`timescale 1ns / 1ps

module top_test();
    reg clk,clrn;
    wire [31:0]memread;
    wire [31:0]memaddr;

    initial begin
        clk=0;clrn=0;
        #3;clrn=1;
        #1;clrn=0;
    end
    always #5 clk=~clk;
    top  top_inst (
        .clk(clk),
        .clrn(clrn),
        .memread(memread),
        .memaddr(memaddr)
    );
endmodule
