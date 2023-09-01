`timescale 1ns / 1ps

module restoreDivder_test();
    reg clk,start;
    reg [3:0]a;
    reg [3:0]b;

    wire  busy,ready;
    wire [3:0]q,q1,q2;//q的位宽取决于a
    wire [3:0]r,r1,r2;//r位宽取决于b

    initial begin
        clk=0;start=0;
        #4; start=1;a=4'd8;b=4'd2;//4ns
        #2; start=0;//6ns
    end
    always @(*) begin
        if (ready) begin
            #5;start=1;a=a+1;b=b+2;
            if (b==0) begin
                b=1;
            end
        end
        if (busy) begin
            start=0;
        end
    end
    always #5 clk=~clk;
    restore_Diver  restore_Diver_inst (
        .clk(clk),
        .start(start),
        .a(a),
        .b(b),
        .busy(busy),
        .ready(ready),
        .q(q),
        .r(r)
    );
    notRestore_Diver  notRestore_Diver_inst (
        .clk(clk),
        .start(start),
        .a(a),
        .b(b),
        .busy(busy),
        .ready(ready),
        .q(q1),
        .r(r1)
    );
    notRestore_comDivider notRestore_comDivider_init(
        .clk(clk),
        .start(start),
        .a(a),
        .b(b),
        .busy(busy),
        .ready(ready),
        .q(q2),
        .r(r2)
    );
endmodule
