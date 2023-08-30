`timescale 1ns / 1ps

module cla32_alu_test();
    reg [31:0]a,b;
    reg ci,sign,sub;

    wire [31:0]s;
    wire c_out;
    wire overflow;//有符号数溢出，无符号数加法溢出
    wire c_take;//无符号数减法借位

    initial begin
        sign=0;sub=0;a=32'd5;b=32'd9;ci=0;//5+9+0
        #5; sign=0;sub=0;a=32'd7;b=32'd11;ci=1;//7+11+1
        #5; sign=0;sub=1;a=32'd8;b=32'd3;ci=0;//8-3-0
        #5; sign=0;sub=1;a=32'd9;b=32'd6;ci=1;//9-6-1
        #5; sign=0;sub=1;a=32'd9;b=32'd11;ci=0;//9-11-0
        
        #5; sign=1;sub=0;a=-32'd5;b=-32'd2;ci=0;//-5+(-2)+0
        #5; sign=1;sub=0;a=-32'd8;b=32'd7;ci=1;//-8+7+1

        #5; sign=1;sub=1;a=32'd5;b=-32'd2;ci=1;//5-(-2)-1
        #5; sign=1;sub=1;a=-32'd4;b=-32'd3;ci=1;//-4-(-3)-1
        #5; $finish;
    end

    cla32AddSub_design  cla32AddSub_design_inst (
        .a(a),
        .b(b),
        .c_in(ci),
        .sign(sign),
        .sub(sub),
        .s(s),
        .c_out(c_out),
        .overflow(overflow),
        .c_take(c_take)
    );
endmodule
