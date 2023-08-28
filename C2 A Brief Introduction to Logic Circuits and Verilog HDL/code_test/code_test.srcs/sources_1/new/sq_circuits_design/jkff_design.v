`timescale 1ns / 1ps

//采用Behavioral风格
module jkff_design(
    input prn,clrn,//低有效
    input j,k,clk,
    output reg q,qn
);
    always @(posedge clk or negedge clrn) begin
        if (~clrn) begin
            q<=0;
            qn<=1;
        end else if (prn) begin
            q<=1;
            qn<=0;
        end else begin
            q<=j&qn+~k&q;
            qn<=~q;
        end
    end
endmodule
