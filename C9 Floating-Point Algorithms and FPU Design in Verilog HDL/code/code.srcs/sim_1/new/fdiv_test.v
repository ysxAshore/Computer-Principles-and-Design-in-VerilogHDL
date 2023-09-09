`timescale 1ns / 1ps

module fdiv_test();
    reg clk,enable,clear;
    reg [1:0]rm;
    reg [31:0]a,b;
    reg ifdiv;
    wire [31:0]res;
    wire stall;
    wire busy;
    wire [4:0]count;
    initial begin
        a=32'h0000_fe01;
        b=32'h0000_00ff;
        clk=0;clear=0;rm=2'b00;enable=1;
        #3;clear=1;
        #1;clear=0;
        #1;ifdiv=1;
    end
    always @(*)begin
        if (~busy) begin
            ifdiv=0;
        end
    end
    always #5 clk=~clk;
    fdiv_design  fdiv_design_inst (
        .clk(clk),
        .enable(enable),
        .clear(clear),
        .rm(rm),
        .a(a),
        .b(b),
        .ifdiv(ifdiv),
        .res(res),
        .stall(stall),
        .busy(busy),
        .count(count)
    );
endmodule
