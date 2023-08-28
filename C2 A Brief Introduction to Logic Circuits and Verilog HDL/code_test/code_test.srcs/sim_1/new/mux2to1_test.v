`timescale 1ns / 1ps

module mux2to1_test();
    reg a0,a1,s;
    wire y_cmos,y_bufif,y_logic,y_data,y_be;

    mux2to1_cmos  mux2to1_cmos_inst (
        .a0(a0),
        .a1(a1),
        .s(s),
        .y(y_cmos)
    );
    mux2to1_bybufif mux2to1_bybufif_init(
        .a0(a0),
        .a1(a1),
        .s(s),
        .y(y_bufif)
    );
    mux2to1_bylogic mux2to1_bylogic_init(
        .a0(a0),
        .a1(a1),
        .s(s),
        .y(y_logic)
    );
    mux2to1_dataflow mux2to1_dataflow_init(
        .a0(a0),
        .a1(a1),
        .s(s),
        .y(y_data)
    );
    mux2to1_byBehavioral mux2to1_byBehavioral_init(
        .a0(a0),
        .a1(a1),
        .s(s),
        .y(y_be)
    );
    initial begin
        a0=0;a1=1;s=0;
        #5;s=1;
        #5 $finish;
    end
endmodule
