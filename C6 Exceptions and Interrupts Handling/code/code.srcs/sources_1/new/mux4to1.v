`timescale 1ns / 1ps

module mux4to1(
    input [31:0]a,b,c,d,
    input [1:0]sel,

    output reg[31:0]res
);
    always @(*) begin
        case (sel)
            2'b00:res=a;
            2'b01:res=b;
            2'b10:res=c;
            2'b11:res=d;
        endcase
    end
endmodule
