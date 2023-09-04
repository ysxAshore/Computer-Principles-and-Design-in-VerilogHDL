`timescale 1ns / 1ps

module ir(
    input clk,clrn,wir,
    input [31:0]memread,
    output reg [31:0]instr
);
    always @(posedge clk or posedge clrn) begin
        if (clrn) begin
            instr<=32'b0;
        end else if (wir) begin
            instr<=memread;
        end
    end
endmodule
