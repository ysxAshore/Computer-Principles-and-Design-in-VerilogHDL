`timescale 1ns / 1ps

module shift_test();
    reg load, clk, clrn;
    reg [2:0]d;
    reg di;

    wire [2:0]q;
    wire d_o;

    initial begin
        clk=0;
        clrn=1;
        load=0;
        #3;clrn=0;//3ns 同步清0
        #3;clrn=1;//6ns 
        #8;di=1;//14ns 串入并出
        #10;di=0;//24ns
        #10;di=1;//34ns 101

        #30;d=3'b110;load=1;//64ns 并入串出
        #2;load=0;//66ns load加载完
        //3个周期，95 0 105 1 115 1
        #54;$finish;
    end
    shift_design  shift_design_inst (
        .load(load),
        .clk(clk),
        .clrn(clrn),
        .d(d),
        .di(di),
        .q(q),
        .d_o(d_o)
    );
    always #5 clk=~clk;
endmodule
