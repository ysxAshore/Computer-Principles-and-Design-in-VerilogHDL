`timescale 1ns / 1ps

module restore_Diver(
    input clk,start,
    input [3:0]a,
    input [3:0]b,
    
    output reg busy,ready,
    output reg[3:0]q,//q的位宽取决于a
    output reg[3:0]r//r位宽取决于b
);
    reg [3:0]reg_b,reg_q,reg_r;

    wire [4:0]sub_res={reg_r[3:0],reg_q[3]}-{1'b0,reg_b};
    wire [3:0]temp_r=sub_res[4]?{reg_r[2:0],reg_q[3]}:sub_res[3:0];

    integer count=0;

    always @(posedge clk) begin
        if (start) begin
            reg_q<=a;
            reg_b<=b;
            reg_r<=0;
            q<=0;
            r<=0;
            busy<=1;
            count<=0;
            ready<=0;
        end else begin
            reg_q={reg_q[2:0],~sub_res[4]};
            reg_r=temp_r;
            count=count+1;
            if (count>=4) begin
                busy<=0;
                ready<=1;
                q=reg_q;
                r=reg_r;
            end
        end
    end
endmodule
