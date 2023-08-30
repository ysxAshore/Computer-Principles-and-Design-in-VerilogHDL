`timescale 1ns / 1ps

module nosigned_mul_test();
    parameter WIDTH_A = 4;
    parameter WIDTH_B = 4;

    reg [WIDTH_A-1:0]a;
    reg [WIDTH_B-1:0]b;
    reg enable;
    reg clk;

    wire[WIDTH_A+WIDTH_B-1:0]res;
    wire ready;
    
    initial begin
        clk=0;
        #3;enable=1;a=4'd1;b=4'd3;
        #3;enable=0;//6ns enable=0 
    end
    always @(*) begin
        if (ready) begin//10s后是上升沿
            #5;
            enable=1;
            a=a+1;
            #6;enable=0;
        end
    end
    always #5 clk=~clk;
    nosigned_mul # (
    .WIDTH_A(WIDTH_A),
    .WIDTH_B(WIDTH_B)
    )
    nosigned_mul_inst (
        .a(a),
        .b(b),
        .enable(enable),
        .clk(clk),
        .res(res),
        .ready(ready)
    );
endmodule
