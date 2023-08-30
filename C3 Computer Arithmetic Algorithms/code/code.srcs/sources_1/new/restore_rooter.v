`timescale 1ns / 1ps

module restore_rooter(
    input clk,load,
    input [31:0]d,

    output reg busy,ready,
    output reg [15:0]q,
    output reg [16:0]r
);
    reg [31:0] reg_d;
    reg [15:0] reg_q;
    reg [16:0] reg_r;
    integer i;
    wire [17:0]sub_res={reg_r[15:0],reg_d[31:30]}-{reg_q[15:0],2'b1};
    wire [16:0]temp_r=sub_res[17]?{reg_r[14:0],reg_d[31:30]}:sub_res[16:0];

    always @(posedge clk) begin
        if (load) begin
            reg_d<=d;reg_q<=0;reg_r<=0;
            busy=1;ready=0;
            q<=0;r<=0;i<=0;
        end else begin
            reg_d={reg_d[29:0],2'b0};
            reg_q={reg_q[14:0],~sub_res[17]};
            reg_r=temp_r;
            i=i+1;
            if (i>=16) begin
                q=reg_q;
                r=reg_r;
                ready=1;
                busy=0;
            end
        end
    end
endmodule
