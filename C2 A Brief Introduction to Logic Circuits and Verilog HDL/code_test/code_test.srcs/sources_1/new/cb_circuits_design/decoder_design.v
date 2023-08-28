`timescale 1ns / 1ps

//3-8译码器
module decoder_design(
    input ena,
    input [2:0]n,
    output reg[7:0]d
);
always @(*) begin
    d=0;
    d[n]=ena;
end
endmodule
