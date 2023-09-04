`timescale 1ns / 1ps

module pc(
    input clk,clrn,wpc,

    input [31:0]npc,
    
    output reg[31:0]pc
);
    always @(posedge clk or posedge clrn) begin
        if (clrn) begin
            pc<=0;
        end else if (wpc) begin
            pc<=npc;
        end
    end
endmodule
