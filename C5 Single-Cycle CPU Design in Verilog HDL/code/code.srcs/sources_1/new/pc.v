`timescale 1ns / 1ps

module pc(
    input clk,clrn,

    input [31:0]npc,
    
    output reg[31:0]pc
);
    always @(posedge clk or posedge clrn) begin
        if (clrn) begin
            pc<=0;
        end else begin
            pc<=npc;
        end
    end
endmodule
