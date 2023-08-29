`timescale 1ns / 1ps

module ripper_adder4_test();
    reg [3:0]a,b;
    reg ci,sign;

    wire [3:0]s;
    wire co,overflow;

    initial begin
        a=4'b0010;b=4'b0011;ci=0;sign=0;
        #5; a=4'b0101;b=4'b1011;ci=1;sign=1;
        #5; a=4'b0110;b=4'b0110;ci=0;sign=1;
    end

    ripper_adder4_design  ripper_adder4_design_inst (
        .a(a),
        .b(b),
        .ci(ci),
        .sign(sign),
        .s(s),
        .co(co),
        .overflow(overflow)
    );
endmodule
