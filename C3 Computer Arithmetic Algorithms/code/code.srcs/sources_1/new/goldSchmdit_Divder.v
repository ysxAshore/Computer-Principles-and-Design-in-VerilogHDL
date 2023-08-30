`timescale 1ns / 1ps

module goldSchmdit_Divder(
    input clk,start,
    input [31:0]a,b,

    output reg busy,ready,
    output reg[31:0]q,//q的位宽取决于a
    output reg [31:0]y //看小数点后的位
);
    reg [63:0]reg_a,reg_b;//存储x，y,初值是a,b
    wire [63:0]r_iter=~reg_b+1;//迭代r
    wire [127:0]temp_x=r_iter*reg_a;//最高位是0. /1.
    wire [127:0]temp_y=r_iter*reg_b;//最高位是0. /1.

    integer i;
    always @(posedge clk) begin
        if (start) begin
            reg_a<={1'b0,a,31'b0};//0.1xxxxxx
            reg_b<={1'b0,b,31'b0};//0.1xxxxxx
            busy<=1;ready<=0;
            i<=0;
            q<=0;y<=0;
        end else begin
            reg_a=temp_x[126:63];//取除去小数点后的64位
            reg_b=temp_y[126:63];//取除去小数点后的64位
            i=i+1;
            if (i>=5) begin
                q=reg_a[63:32]+|reg_a[31:29];
                y=reg_b[62:31];
                ready=1;
                busy=0;
            end
        end
    end
endmodule
