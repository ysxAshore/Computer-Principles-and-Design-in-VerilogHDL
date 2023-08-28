`timescale 1ns / 1ps

module demultiplexer_test();

    reg y;
    reg [2:0]s;
    wire [7:0]a;
    initial begin
        y=0;s=0;
        #5;y=1;
        #5;y=1;
        #5;y=0;
        #5;y=1;
        #5;y=1;
        #5;y=0;
        #5;y=1;
    end
    always #5 s=s+1;
    demultiplexer_design  demultiplexer_design_inst (
        .y(y),
        .s(s),
        .a(a)
    );
endmodule
