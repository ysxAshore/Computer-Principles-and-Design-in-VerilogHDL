`timescale 1ns / 1ps

module shift_even(
    input [23:0]a,
    output reg[23:0]out,
    output reg[4:0]amount
);
    always @(*) begin
        out=a;
        amount=0;
        while(out[23]!=1'd1&out[22]!=1'd1&amount<5'd24) begin
            out=out<<2;
            amount=amount+5'd1;
        end
    end
endmodule
