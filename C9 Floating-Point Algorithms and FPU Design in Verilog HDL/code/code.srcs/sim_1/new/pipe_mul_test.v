`timescale 1ns / 1ps

module pipe_mul_test();
    reg clk;
    reg [31:0] a,b;
    reg [1:0] rm;
    wire [31:0] s;
    initial begin
        clk=0;
        a=32'h3fc0_0000;
        b=32'h3fc0_0000;
        rm=2'b0;
        #10;a=32'h0080_0000;b=32'h0080_0000;
        #10;a=32'h7f7f_ffff;b=32'h7f7f_ffff;
        #10;a=32'h0080_0000;b=32'h3f00_0000;
        #10;a=32'h003f_ffff;b=32'h4000_0000;
        #10;a=32'h7f80_0000;b=32'h00ff_ffff;
        #10;b=32'h0000_0000;
        #10;a=32'h7ff0_00ff;b=32'h3f80_ff00;
    end
    always #5 clk=~clk;
    pipe_fmul_top  pipe_fmul_top_inst (
        .clk(clk),
        .a(a),
        .b(b),
        .rm(rm),
        .s(s)
     );
endmodule
