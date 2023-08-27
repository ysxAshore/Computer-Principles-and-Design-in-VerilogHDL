`timescale 1ns / 1ps

module dataflow_mux2to1(
    input s,a0,a1,
    output y
);
    assign y=~s&a0+s&a1;
    //assign y=s?a1:a0;
endmodule
