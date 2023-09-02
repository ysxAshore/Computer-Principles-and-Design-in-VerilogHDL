`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/02 14:37:56
// Design Name: 
// Module Name: alu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps

module alu(
    input [31:0]a,b,//a端多路选择pc(pc的adder可以放在IF),sa,reg_a;b端多路选择reg_b,imm,4(pc_adder),imm<<2;
    input [3:0]aluc,
    //x000 ADD,x100 SUB,x001 AND,x101 OR,x010 XOR,x110 LUI,0011 SLL,0111 SRL,1111 SRA 
    output wire[31:0]res,
    output wire z
);
    reg [31:0]s0,s1,s2,s3;
    
    always @(*) begin
        casex (aluc)//带有x的匹配
            4'bx000:s0=a+b;
            4'bx100:s0=a+~b+1'b1;
            4'bx001:s1=a&b;
            4'bx101:s1=a|b;
            4'bx010:s2=a^b;
            4'bx110:s2={b[15:0],16'b0};
            4'b0011:s3=b<<a[4:0];
            4'b0111:s3=b>>a[4:0];
            4'b1111:s3=$signed(b)>>>a[4:0];
        endcase
    end
    assign z=(a==b)?1:0;
    mux4to1 mux4to1_inst(s0,s1,s2,s3,aluc[1:0],res);
endmodule