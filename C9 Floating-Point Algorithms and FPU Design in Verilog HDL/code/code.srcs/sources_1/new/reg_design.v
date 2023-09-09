`timescale 1ns / 1ps

module reg_design #(parameter WIDTH = 32)(
    input clk,we,clear,
    input [WIDTH-1:0]i_data,
    output reg[WIDTH-1:0]o_data
);
    always @(posedge clk or posedge clear) begin
        if (clear) begin
            o_data<=0;
        end else if (we) begin
            o_data<=i_data;
        end
    end
endmodule
