`timescale 1ns / 1ps

module booths_test();
    reg [3:0]a,b;
    wire [7:0]res;

    initial begin
        a=4'd3;b=4'd5;
        #5;a=-4'd2;b=-4'd7;
        #5;a=-4'd6;b=4'd5;
        #5;$finish;
    end

    booths_multiplier  booths_multiplier_inst (
        .a(a),
        .b(b),
        .res(res)
    );
endmodule
