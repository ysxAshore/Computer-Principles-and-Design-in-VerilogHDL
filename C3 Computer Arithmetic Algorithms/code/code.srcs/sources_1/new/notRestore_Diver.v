`timescale 1ns / 1ps

module notRestore_Diver(
    input clk,start,
    input [3:0]a,
    input [3:0]b,
    
    output reg busy,ready,
    output reg[3:0]q,//q的位宽取决于a
    output reg[3:0]r//r位宽取决于b
);
    reg[3:0]reg_q,reg_r,reg_b;
    integer i;

    wire [4:0]temp_res=reg_r[3]?{reg_r,reg_q[3]}+{1'b0,reg_b}:{reg_r,reg_q[3]}-{1'b0,reg_b};

    always @(posedge clk) begin
        if (start) begin
            reg_q<=a;
            reg_b<=b;
            reg_r<=0;
            i<=0;
            q<=0;r<=0;
            busy<=1;ready=0;
        end else begin
            reg_q={reg_q[2:0],~temp_res[4]};
            reg_r=temp_res[3:0];
            i=i+1;
            if (i>=4) begin
                q=reg_q;
                r=reg_r[3]?reg_r+reg_b:reg_r;
                ready=1;
                busy=0;
            end
        end
    end
endmodule
