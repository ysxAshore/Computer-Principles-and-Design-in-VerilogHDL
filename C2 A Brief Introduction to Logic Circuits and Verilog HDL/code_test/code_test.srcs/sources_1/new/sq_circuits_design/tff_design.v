`timescale 1ns / 1ps

module tff_design(
    input prn,t,
    input clk,clrn,

    output reg p,pn
);
always @(posedge clk or negedge clrn) begin
    if (~clrn) begin
        p<=0;
        pn<=1;
    end else if (prn) begin
        p<=1;
        pn<=0;
    end else begin
        p<=t&pn|~t&p;
        pn<=~p;
    end
end
endmodule
