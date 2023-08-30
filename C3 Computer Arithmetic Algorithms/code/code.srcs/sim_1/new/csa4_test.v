`timescale 1ns / 1ps

module csa4_test();
    reg [3:0]a,b,z;
    wire [3:0]s;
    wire co;

    initial begin
        a=4'd10;b=4'd7;z=4'd12;
        #5;a=4'd7;b=4'd5;z=4'd2;
        #5;$finish;
    end
    csa4_design  csa4_design_inst (
        .a(a),
        .b(b),
        .z(z),
        .s(s),
        .co(co)
    );
endmodule
