`timescale 1ns / 1ps

module encode_custom(
    input ena,
    input [7:0]d,
    output reg[2:0]n,
    output reg g
);

//求逻辑表达式是一种方法
always @(*) begin
    n=3'b0;
    g=0;
    if (ena) begin
        g=|d;
        case(d) 
            8'b00000001:n=3'b000;
            8'b00000010:n=3'b001;
            8'b00000100:n=3'b010;
            8'b00001000:n=3'b011;
            8'b00010000:n=3'b100;
            8'b00100000:n=3'b101;
            8'b01000000:n=3'b110;
            8'b10000000:n=3'b111;
        endcase
    end
end
endmodule
