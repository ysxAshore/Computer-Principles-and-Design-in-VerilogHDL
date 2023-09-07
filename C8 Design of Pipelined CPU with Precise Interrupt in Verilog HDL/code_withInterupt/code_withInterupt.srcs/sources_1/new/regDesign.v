`timescale 1ns / 1ps

module regDesign #(parameter  WIDTH= 32)(
    input clk,enable,clrn,
    input [WIDTH-1:0]i_data,
    output reg[WIDTH-1:0]o_data
);
    always @(posedge clk or posedge clrn) begin
        if (clrn) begin
            o_data<=0;
        end else if (enable) begin
            o_data=i_data;
        end
    end
endmodule
