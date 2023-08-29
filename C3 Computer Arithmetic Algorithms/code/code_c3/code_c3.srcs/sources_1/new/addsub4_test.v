`timescale 1ns / 1ps

module addsub4_test();
    reg [3:0]a,b;
    reg ci,sign,sub;

    wire [3:0]s;
    wire co;
    //溢出判断
    wire overflow,cf_take;

    initial begin
        sign=0;sub=0;a=4'd5;b=4'd9;ci=0;//5+9+0
        #5; sign=0;sub=0;a=4'd7;b=4'd11;ci=1;//7+11+1
        #5; sign=0;sub=1;a=4'd8;b=4'd3;ci=0;//8-3-0
        #5; sign=0;sub=1;a=4'd9;b=4'd6;ci=1;//9-6-1
        #5; sign=0;sub=1;a=4'd9;b=4'd11;ci=0;//9-11-0
        
        #5; sign=1;sub=0;a=-4'd5;b=-4'd2;ci=0;//-5+(-2)+0
        #5; sign=1;sub=0;a=-4'd8;b=4'd7;ci=1;//-8+7+1

        #5; sign=1;sub=1;a=4'd5;b=-4'd2;ci=1;//5-(-2)-1
        #5; sign=1;sub=1;a=-4'd4;b=-4'd3;ci=1;//-4-(-3)-1
        #5; $finish;
    end
    addsub4_design  addsub4_design_inst (
        .a(a),
        .b(b),
        .ci(ci),
        .sign(sign),
        .sub(sub),
        .s(s),
        .co(co),
        .overflow(overflow),
        .cf_take(cf_take)
    );
endmodule
