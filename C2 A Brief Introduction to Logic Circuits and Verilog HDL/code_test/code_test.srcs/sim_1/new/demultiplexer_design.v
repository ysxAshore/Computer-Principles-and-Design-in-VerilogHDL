`timescale 1ns / 1ps

module demultiplexer_design(
    input y,
    input [2:0]s,
    output reg[7:0]a
);
    always @(*) begin
        a=8'b0;
        a[s]=y;
    end
endmodule
