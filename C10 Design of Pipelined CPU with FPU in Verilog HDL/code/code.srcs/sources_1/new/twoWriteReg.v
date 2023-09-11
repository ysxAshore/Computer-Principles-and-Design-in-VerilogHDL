`timescale 1ns / 1ps

module twoWriteReg(
    input clk,clrn,
    input [31:0]wd0,
    input [4:0]wn0,
    input we0,
    input [31:0]wd1,
    input [4:0]wn1,
    input we1,
    input [4:0]rn0,rn1,
    output [31:0]qa,qb
);
    reg [31:0]regs[31:0];
    assign qa=regs[rn0];
    assign qb=regs[rn1];
    integer i;
    always @(posedge clk or posedge clrn) begin
        if (clrn) begin
            for(i=0;i<32;i=i+1) regs[i]<=32'b0;
        end else if(we1) regs[wn1]<=wd1;
        else if(we0&(~we1|(wn1!=wn0)))regs[wn0]<=wd0;
    end
endmodule
