`timescale 1ns / 1ps

module int2float_test();
    reg [31:0]a;
    wire[31:0]f;
    wire p_lost;
    initial begin
        a=32'h1fff_ffff;
        #10;a=32'h0000_0001;
        #10;a=32'h7fff_ff80;
        #10;a=32'h7fff_ffc0;
        #10;a=32'h8000_0000;
        #10;a=32'h8000_0040;
        #10;a=32'hffff_ffff;
    end
    int2float  int2float_inst (
        .a(a),
        .f(f),
        .p_lost(p_lost)
    );

endmodule
