`timescale 1ns / 1ps

module shift_toMSB1(
    input [23:0]a,
    output reg[23:0]b,
    output reg[4:0]amount
);
    always @(*) begin
        amount=5'b0;
        b=a;
        while (~b[23]&amount<24) begin
            b=b<<1;
            amount=amount+1;
        end
    end
endmodule
