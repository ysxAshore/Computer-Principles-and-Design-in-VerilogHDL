`timescale 1ns / 1ps

module cal_design(
    input [27:0]aligned_large_frac,aligned_small_frac,
    input op_sub,
    output [27:0]cal_frac
);
    assign cal_frac=op_sub?aligned_large_frac-aligned_small_frac:aligned_large_frac+aligned_small_frac;

endmodule
