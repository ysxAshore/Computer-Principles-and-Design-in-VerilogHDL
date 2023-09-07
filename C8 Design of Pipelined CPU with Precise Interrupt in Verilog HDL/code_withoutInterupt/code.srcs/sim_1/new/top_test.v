`timescale 1ns / 1ps

module top_test();
    reg clk,clrn;
    wire [31:0]pc,inst,aluoutM,aluoutE,wd;
    initial begin
        clk=0;clrn=0;
        #3;clrn=1;
        #1;clrn=0;
    end
    always #5 clk=~clk;
    top  top_inst (
        .clk(clk),
        .clrn(clrn),
        .pc(pc),
        .inst(inst),
        .aluoutM(aluoutM),
        .aluoutE(aluoutE),
        .wd(wd)
    );
endmodule
