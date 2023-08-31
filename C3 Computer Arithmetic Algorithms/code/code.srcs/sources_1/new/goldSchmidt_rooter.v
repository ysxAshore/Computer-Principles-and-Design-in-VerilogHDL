`timescale 1ns / 1ps

module goldSchmidt_rooter(
    input clk,load,
    input [31:0]d,

    output reg busy,ready,
    output reg [31:0]q,
    output reg [31:0]x//分母0.111111111时
);
    reg [63:0]reg_d,reg_x;//reg_d中存储分子，reg_x存储分母
    reg [63:0]reg_r;
    wire [63:0]r=64'hc000_0000-{1'b0,reg_x[62:0]};//1.1-0.xxx
    wire [127:0]di=reg_d*reg_r;
    wire [127:0]temp_i=reg_x*reg_r*reg_r;
    wire [63:0]xi={1'b0,temp_i[126:64]+|temp_i[63:0]};

    integer i;
    always @(posedge clk) begin
        if (load) begin
            reg_d<={1'b0,d,31'b0};reg_x<={1'b0,d,31'b0};//最高位是符号位
            i<=0;busy<=1;ready<=0;
        end else begin
            reg_r=r;
            reg_x=xi;
            reg_d=di[126:63]+|di[62:0];
            i=i+1;
            if (i>=5) begin
                q=reg_d[62:31]+|reg_d[31:29];
                x=reg_x[62:31];
                ready=1;
                busy=0;
            end
        end
    end
endmodule
