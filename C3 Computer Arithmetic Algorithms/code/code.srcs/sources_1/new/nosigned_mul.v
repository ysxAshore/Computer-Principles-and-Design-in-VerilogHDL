`timescale 1ns / 1ps

module nosigned_mul #(parameter WIDTH_A=4,WIDTH_B=4)(
    input [WIDTH_A-1:0]a,
    input [WIDTH_B-1:0]b,
    input enable,
    input clk,

    output reg[WIDTH_A+WIDTH_B-1:0]res,
    output reg ready
);
    reg [WIDTH_A+WIDTH_B-1:0]temp_A,res_temp;
    reg [WIDTH_B-1:0]temp_B;
    integer i;
    always @(posedge clk) begin
        if (enable) begin
            temp_A<=a;
            temp_B<=b;
            res_temp<=0;
            i<=0;
            res<=0;
            ready<=0;
        end else begin
            res_temp<=temp_B[0]?res_temp+temp_A:res_temp;
            temp_A<=temp_A<<1;
            temp_B<=temp_B>>1;
            i=i+1;
            if (i==WIDTH_B) begin
                ready<=1;
                res<=res_temp;
            end
        end
    end
endmodule
