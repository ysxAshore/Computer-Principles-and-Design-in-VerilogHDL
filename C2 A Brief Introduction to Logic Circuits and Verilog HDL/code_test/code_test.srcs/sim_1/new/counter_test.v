`timescale 1ns / 1ps

module counter_test();
    reg clk;
    reg rst;
    reg u;

    wire[2:0]num1,num2;
    wire[6:0]seg1,seg2;

    always #5 clk=~clk;

    initial begin
        clk=0;
        #3;rst=1;//3ns
        #3;rst=0;//6ns
        #8;u=1;//14ns
        //15 25 35 45 55 65 
        #60;u=0;
        #60;$finish;
    end

    counter_designByState  counter_designByState_inst (
        .clk(clk),
        .rst(rst),
        .u(u),
        .num(num1),
        .seg(seg1)
    );
    counter_designByBehaioral  counter_designByBehaioral_inst (
        .clk(clk),
        .rst(rst),
        .u(u),
        .num(num2),
        .seg(seg2)
    );
endmodule
