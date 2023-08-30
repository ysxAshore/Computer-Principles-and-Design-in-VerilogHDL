`timescale 1ns / 1ps

module signed_mul_test();
    reg [7:0]a,b;
    wire[15:0]res;

    initial begin
        a=8'd1;b=8'd7;
        #5;a=8'd2;b=8'd10;
        #5;a=-8'd5;b=8'd12;
        #5;a=-8'd11;b=-8'd13;
        #5;a=8'd13;b=-8'd14;
        #5;a=8'd17;b=8'd11;
        #5;$finish;
    end
    signed_mul  signed_mul_inst (
        .a(a),
        .b(b),
        .res(res)
    );
endmodule
