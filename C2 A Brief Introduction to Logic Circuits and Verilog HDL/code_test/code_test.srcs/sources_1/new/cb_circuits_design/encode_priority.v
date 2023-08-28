`timescale 1ns / 1ps

module encode_priority(
    input ena,
    input [7:0]d,
    output reg[2:0]n,
    output reg g
);

always @(*) begin
    n=3'b0;
    g=0;
    if (ena) begin
        g=|d;
        casex(d) //带有不定态的case用casex
            8'b0000_0001:n=3'b000;
            8'b0000_001x:n=3'b001;
            8'b0000_01xx:n=3'b010;
            8'b0000_1xxx:n=3'b011;
            8'b0001_xxxx:n=3'b100;
            8'b001x_xxxx:n=3'b101;
            8'b01xx_xxxx:n=3'b110;
            8'b1xxx_xxxx:n=3'b111;
        endcase
    end
end

// always @(*) begin:for_loop
//     integer i;
//     n=3'b0;
//     g=0;
//     if (ena) begin
//         g=|d;
//         for (i = 0; i<=7; i=i+1) begin
//             if (d[i]) begin
//                 n=i;
//             end
//         end
//     end
// end
endmodule
