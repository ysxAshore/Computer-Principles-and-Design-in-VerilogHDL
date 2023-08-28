`timescale 1ns / 1ps

module decoder_test();
    reg ena;
    reg [2:0]n;
    wire [7:0]d;
    initial begin
        ena=0;n=3'b0;
        #5;ena=1;
    end
    decoder_design  decoder_design_inst (
        .ena(ena),
        .n(n),
        .d(d)
    );
    always #5 n=n+1;
endmodule
