`timescale 1ns / 1ps
module fifo_serio_test();
    reg [31:0]d;
    reg clrn;//clrn低有效
    reg read,write;

    wire [31:0]q;
    wire full;
    wire empty;

    initial begin
        clrn=0;write=0;read=0;
        #2;clrn=1;d=32'he1;
        #1;clrn=0;
        #2;write=1;//5ns
        #5;write=0;//10ns
        #3;d=32'he2;
        #2;write=1;//15ns
        #5;write=0;//20ns
        #3;d=32'he3;
        #2;write=1;//25ns
        #5;write=0;//30ns
        #3;d=32'he3;
        #2;write=1;//35ns
        #5;write=0;
        #5;read=1;
        #5;read=0;
        #5;read=1;
        #5;read=0;
        #5;read=1;
        #5;read=0;
        #5;$finish;
    end
    fifo_serio_design  fifo_serio_design_inst (
        .d(d),
        .clrn(clrn),
        .read(read),
        .write(write),
        .q(q),
        .full(full),
        .empty(empty)
    );
endmodule
