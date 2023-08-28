`timescale 1ns / 1ps

module encoder_test();
    reg ena;
    reg [7:0]d;
    wire [2:0]n1,n2;
    wire g1,g2;

    initial begin
        ena=0;
        d=0;
        #5;
        ena=1;
    end
    
    always #5 d=d+1;
    encode_custom  encode_custom_inst (
        .ena(ena),
        .d(d),
        .n(n1),
        .g(g1)
    );
    encode_priority  encode_priority_inst (
        .ena(ena),
        .d(d),
        .n(n2),
        .g(g2)
    );
endmodule
