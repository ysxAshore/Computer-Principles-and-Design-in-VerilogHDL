`timescale 1ns / 1ps

module barrel_shift_test();
    reg [31:0]d;
    reg [4:0]sa;
    reg right,arith;
    wire [31:0]sh1,sh2;
    
    initial begin
        d=32'hf247_fdac;
        sa=5'b10000;
        right=0;
        arith=0;
        #5;
        sa=sa>>1;
        right=1;
        arith=0;
        #5;
        sa=sa>>1;
        right=0;
        arith=0;
        #5;
        sa=sa>>1;
        right=1;
        arith=1;
        #5;
        sa=sa>>1;
        right=1;
        right=0;    
        #5;$finish;
    end
    barrel_shift_bydataflow  barrel_shift_bydataflow_inst (
        .d(d),
        .sa(sa),
        .right(right),
        .arith(arith),
        .sh(sh1)
    );
    barrel_shift_byBehavioral  barrel_shift_byBehavioral_inst (
        .d(d),
        .sa(sa),
        .right(right),
        .arith(arith),
        .sh(sh2)
    );
endmodule
