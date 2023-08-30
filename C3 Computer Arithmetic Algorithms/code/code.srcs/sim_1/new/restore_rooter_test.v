`timescale 1ns / 1ps

module restore_rooter_test();
    reg clk,load;
    reg [31:0]d;

    wire busy,ready;
    wire [15:0]q,q1;
    wire [16:0]r,r1;

    initial begin
        clk=0;load=0;
        #4; load=1;d=32'd4;//4ns
        #2; load=0;//6ns
    end

    always @(*) begin
        if (ready) begin
            #5;load=1;d=d+1;
        end
        if (busy) begin
            load=0;
        end
    end
    restore_rooter  restore_rooter_inst (
        .clk(clk),
        .load(load),
        .d(d),
        .busy(busy),
        .ready(ready),
        .q(q),
        .r(r)
    );
    noRestore_root  noRestore_root_inst (
        .clk(clk),
        .load(load),
        .d(d),
        .busy(busy),
        .ready(ready),
        .q(q1),
        .r(r1)
    );
    always #5 clk=~clk;
endmodule
