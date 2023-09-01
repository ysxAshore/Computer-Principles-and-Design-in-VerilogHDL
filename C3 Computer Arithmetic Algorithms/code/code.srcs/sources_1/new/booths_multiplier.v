`timescale 1ns / 1ps


module booths_multiplier(
    input [3:0]a,b,
    output reg[7:0]res
);
    reg [4+4:0]p;
    reg [3:0]temp;
    integer i;
    always @(*) begin
        p[0]=1'b0;
        p[4:1]=b;
        p[8:5]=4'b0;
        for ( i= 0; i<4;i=i+1 ) begin
            case (p[1:0])
                2'b11,
                2'b00:p=$signed(p)>>>1;
                2'b01:begin
                    temp=p[8:5]+a;
                    p[8:5]=temp;
                    p=$signed(p)>>>1;
                end
                2'b10:begin
                    temp=p[8:5]+~a+1;
                    p[8:5]=temp;
                    p=$signed(p)>>>1;
                end 
            endcase
        end      
        res=p[8:1]; 
    end
endmodule
