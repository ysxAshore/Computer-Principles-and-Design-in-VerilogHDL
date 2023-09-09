`timescale 1ns / 1ps

module fadd_test();
    reg [31:0] a,b;
    reg [1:0] rm;
    reg sub;
    wire [31:0] s;
    initial begin
        a=32'h3C60_0011;
        b=32'hBE82_0000;
        rm=2'b0;sub=0;
        #5;rm=2'b01;
        #5;rm=2'b10;
        #5;rm=2'b11;
        #5;rm=2'b00;sub=1;
        #5;rm=2'b01;
        #5;rm=2'b10;
        #5;rm=2'b11;
        #5;rm=2'b00;sub=0;a=32'h3FFF_FFFF;b=32'h33E0_0000;
        #5;rm=2'b01;
        #5;rm=2'b10;
        #5;rm=2'b11;
        #5;rm=2'b00;sub=1;
        #5;rm=2'b01;
        #5;rm=2'b10;
        #5;rm=2'b11;
        #5;$finish;
    end
    fadd_design  fadd_design_inst (
        .a(a),
        .b(b),
        .rm(rm),
        .sub(sub),
        .s(s)
    );
endmodule
