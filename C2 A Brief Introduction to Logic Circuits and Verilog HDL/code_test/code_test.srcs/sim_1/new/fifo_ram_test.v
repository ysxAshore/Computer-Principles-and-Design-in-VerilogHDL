`timescale 1ns / 1ps

module fifo_ram_test();
    reg clk;//时序控制
    reg clrn;//清0 高有效

    reg read;
    reg write;

    reg [31:0]d_in;
    wire [31:0]d_out;

    wire empty;
    wire full;

    always #5 clk=~clk;
    initial begin
        clk=0;clrn=0;
        #3;clrn=1;
        #1;clrn=0;//3~4ns 上升沿clrn清0

        #1;read=1;write=0;//5ns 空时读
        #10;read=0;write=1;d_in=32'habe1;//15ns 写第一个数据
        #10;d_in=d_in<<2;
        #10;d_in=d_in<<2;
        #10;d_in=d_in<<2;
        #10;d_in=d_in<<2;
        #10;d_in=d_in<<2;
        #10;d_in=d_in<<2;
        #10;d_in=d_in<<2;//写8个数据
        #10;d_in=d_in<<2;//写满写

        #10;read=1;write=0;//开始读
        #80;$finish;//0 10 20 30 40 50 60 70 80
    end

    fifo_ram_design  fifo_ram_design_inst (
        .clk(clk),
        .clrn(clrn),
        .read(read),
        .write(write),
        .d_in(d_in),
        .d_out(d_out),
        .empty(empty),
        .full(full)
    );
endmodule
