`timescale 1ns / 1ps

module float2int_test();
    reg [31:0]a;
    wire [31:0]d;
    wire p_lost;//精度损失
    wire invalid;//超出整数表示范围
    wire denorm;//非正则数
    initial begin
        a=32'h4eff_ffff;
        #10;a=32'h4f00_0000;
        #10;a=32'h3f80_0000;
        #10;a=32'h0000_0001;
        #10;a=32'h7f80_0000;
        #10;a=32'h3fc0_0000;
        #10;a=32'hcf00_0000;
        #10;a=32'hcf00_0001;
        #10;a=32'hbf80_0000;
    end
    float2int  float2int_inst (
        .a(a),
        .d(d),
        .p_lost(p_lost),
        .invalid(invalid),
        .denorm(denorm)
    );
endmodule
