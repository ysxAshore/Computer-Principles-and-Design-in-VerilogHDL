`timescale 1ns / 1ps
module cla_2(//用于级联的cla2
    input [1:0]a,b,
    input c_in,

    output [1:0]s,
    output g_out,
    output p_out,
    output data_co//判断溢出的数值最高位进位
);
    wire [1:0]g,p;
    wire c1;
    gp gp_init(g,p,c_in,g_out,p_out,c1);
    add add1(a[0],b[0],c_in,s[0],g[0],p[0]);//低位add
    add add2(a[1],b[1],c1,s[1],g[1],p[1]);//高位add
    
    assign data_co=c1;
endmodule

module cla_4(
    input [3:0]a,b,
    input c_in,
    output [3:0]s,
    output g_out,p_out,
    output data_co
);//用于级联的cla4

    wire c1,co1,co2;
    wire [1:0]g,p;
    cla_2 cla_2_inst1(a[1:0],b[1:0],c_in,s[1:0],g[0],p[0],co1);//低位
    cla_2 cla_2_inst2(a[3:2],b[3:2],c1,s[3:2],g[1],p[1],co2);//高位
    gp gp_init(g,p,c_in,g_out,p_out,c1);
    
    assign data_co=c1;
endmodule

module cla_8(
    input [7:0]a,b,
    input c_in,
    output [7:0]s,
    output g_out,p_out,
    output data_co
);//用于级联的cla8

    wire c1,co1,co2;
    wire [1:0]g,p;
    cla_4 cla_4_inst1(a[3:0],b[3:0],c_in,s[3:0],g[0],p[0],co1);//低位
    cla_4 cla_4_inst2(a[7:4],b[7:4],c1,s[7:4],g[1],p[1],co2);//高位
    gp gp_init(g,p,c_in,g_out,p_out,c1);

    assign data_co=c1;
endmodule

module cla_16(
    input [15:0]a,b,
    input c_in,
    output [15:0]s,
    output g_out,p_out,
    output data_co
);//用于级联的cla8

    wire c1,co1,co2;
    wire [1:0]g,p;
    cla_8 cla_8_inst1(a[7:0],b[7:0],c_in,s[7:0],g[0],p[0],co1);//低位
    cla_8 cla_8_inst2(a[15:8],b[15:8],c1,s[15:8],g[1],p[1],co2);//高位
    gp gp_init(g,p,c_in,g_out,p_out,c1);
    assign data_co=c1;
endmodule

module cla_32(
    input [32:0]a,b,
    input c_in,
    output [32:0]s,
    output g_out,p_out,
    output data_co
);//用于级联的cla8

    wire c1,co1,co2;
    wire [1:0]g,p;
    cla_16 cla_16_inst1(a[15:0],b[15:0],c_in,s[15:0],g[0],p[0],co1);//低位
    cla_16 cla_16_inst2(a[31:16],b[31:16],c1,s[31:16],g[1],p[1],co2);//高位
    gp gp_init(g,p,c_in,g_out,p_out,c1);
    assign data_co=c1;
endmodule

module add (
    input a,b,c,
    output s,g,p
);
    assign s=a^b^c;
    assign g=a&b;
    assign p=a|b;    
endmodule

module gp(
    input [1:0]g,p,
    input c_in,
    output g_out,p_out,
    output c_out
);  
    assign p_out=p[1]&p[0];
    assign g_out=g[1]|p[1]&g[0];
    assign c_out=g[0]|p[0]&c_in;
endmodule
