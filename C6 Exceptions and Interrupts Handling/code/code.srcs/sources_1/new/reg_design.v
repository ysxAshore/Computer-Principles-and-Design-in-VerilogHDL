`timescale 1ns / 1ps

module reg_design(
    input clk,enable,
    input [31:0]i_data,
    output [31:0]o_data
);
    reg [31:0]cur_data;
    assign o_data=cur_data;
    always @(posedge clk) begin
        if (enable) begin
            cur_data<=i_data;
        end
    end
endmodule
