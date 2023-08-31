`timescale 1ns/1ps

module noRestore_root(
    input clk,load,
    input [3:0]d,

    output reg busy,ready,
    output reg [1:0]q,
    output reg [3:0]r
);
    integer i;
    reg[3:0]reg_d;
    reg[1:0]reg_q;
    reg[3:0]reg_r;
    reg[1:0]reg_q_old;
    wire [2:0]r_old={1'b1,reg_r}+{reg_q_old[1:0],2'b01};
    wire [3:0]addSub=reg_r[3]?{r_old[1:0],reg_d[3:2]}-{reg_q[1:0],2'b01}
                    :{reg_r[1:0],reg_d[3:2]}-{reg_q[1:0],2'b01};
    reg [2:0]r_n;
    always @(posedge clk) begin
        if (load) begin
            q<=0;r<=0;
            reg_d<=d;reg_q<=0;reg_r<=0;reg_q_old<=0;
            i<=0;busy<=1;ready<=0;
        end else begin
            reg_d={reg_d[1:0],2'b0};
            reg_q_old=reg_q;
            reg_q={reg_q[0],~addSub[3]};
            reg_r=addSub;
            r_n=reg_r+{reg_q_old[1:0],2'b01};
            i=i+1;
            if (i>=2) begin
                q=reg_q;
                r=reg_r[3]?r_n:reg_r;
                ready=1;
                busy=0;
            end
        end
    end
endmodule