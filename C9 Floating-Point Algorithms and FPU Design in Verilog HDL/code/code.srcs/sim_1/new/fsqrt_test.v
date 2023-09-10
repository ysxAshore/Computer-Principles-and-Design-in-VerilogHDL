`timescale 1ns / 1ps

module fsqrt_test();
    reg clk,clear;
    reg [31:0]d;
    reg [1:0]rm;
    reg ifsqrt;

    wire stall;
    wire busy;
    wire [4:0]count;
    wire [31:0]res;
    initial begin
        d=32'h0000_3200;
        clk=0;clear=0;rm=2'b00;
        #3;clear=1;
        #1;clear=0;
        #1;ifsqrt=1;
    end
    always @(*) begin
        if (~busy) begin
            ifsqrt=0;
        end
    end
    fsqrt_design  fsqrt_design_inst (
        .clk(clk),
        .clear(clear),
        .d(d),
        .rm(rm),
        .ifsqrt(ifsqrt),
        .stall(stall),
        .busy(busy),
        .count(count),
        .res(res)
    );
    always #5 clk=~clk;
endmodule
