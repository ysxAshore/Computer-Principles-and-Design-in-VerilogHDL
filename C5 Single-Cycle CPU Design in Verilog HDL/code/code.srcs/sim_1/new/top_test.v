`timescale 1ns / 1ps

module top_test();
    reg clk,clrn;
    wire [31:0]pc;
    wire [31:0]inst,aluout,memread;

    initial begin
        clk=0;clrn=0;
        #3;clrn=1;
        #4;clrn=0;
    end

    always #5 clk=~clk;
    top top_init(clk,clrn,pc,inst,aluout,memread);
endmodule
