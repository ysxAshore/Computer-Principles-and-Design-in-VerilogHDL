`timescale 1ns / 1ps

module wallacCA_test();
    reg [7:0]a,b;
    wire [15:0]res1,res2,sum,c;
    initial begin
        a=-8'd5;b=-8'd3;
        #5;a=8'd7;b=-8'd3;
        #5;a=8'd2;b=8'd3;
        #5;$finish;
    end
    wallacCarryAdder8_8  wallacCarryAdder8_8_inst (
        .a(a),
        .b(b),
        .res(res1)
    );
    wallaceSignedMul  wallaceSignedMul_inst (
        .a(a),
        .b(b),
        .sum(sum),
        .c(c),
        .res(res2)
    );
endmodule
