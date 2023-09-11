`timescale 1ns / 1ps

module cpu_test();
    reg clk,clrn;
    reg [1:0]rm;
    initial begin
        rm=2'b00;
        clk=0;clrn=0;
        #3;clrn=1;
        #1;clrn=0;
    end
    always #5 clk=~clk;
    top_cpu init(clk,clrn,rm);
endmodule
