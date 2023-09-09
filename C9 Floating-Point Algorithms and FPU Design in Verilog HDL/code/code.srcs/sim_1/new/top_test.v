`timescale 1ns / 1ps

module top_test();
    reg clk;
    reg [31:0] a,b;
    reg [1:0] rm;
    reg sub;
    wire [31:0] s;
    initial begin
        clk=0;rm=2'b0;sub=1'b1;a=32'h3c600011;b=32'hbe820000;
        #10;rm=2'b01;
        #10;rm=2'b10;
        #10;rm=2'b11;
        #10;rm=0;sub=0;
        #10;rm=2'b01;
        #10;rm=2'b10;
        #10;rm=2'b11;
        #20;$finish;
    end
    top_design  top_design_inst (
        .clk(clk),
        .a(a),
        .b(b),
        .rm(rm),
        .sub(sub),
        .s(s)
    );
    always #5 clk=~clk;
endmodule
