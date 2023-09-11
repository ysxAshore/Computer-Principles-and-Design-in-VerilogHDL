`timescale 1ns / 1ps

module fpu(
    input clk,clrn,
    input [31:0]dfa,dfb,
    input [4:0]fd,
    input [2:0]fc,
    input [1:0]rm,
    input fw,
    output [31:0]wd,
    output [4:0]wn,
    output we,
    output [4:0]w1n,w2n,w3n,
    output w1e,w2e,w3e,
    output [31:0]e3d,
    output stall_div_sqrt,
    output e
);
    wire [31:0]a,b;
    wire sub;
    assign e=~stall_div_sqrt;
    reg_design #(.WIDTH(65))r1(clk,e,clrn,{dfa,dfb,fc[0]},{a,b,sub});
    wire [31:0]alu_res,mul_res,div_res,sqrt_res;
    pipe_alu alu_init(clk,e,clrn,a,b,rm,sub,alu_res);
    pipe_mul mul_init(clk,e,clrn,a,b,rm,mul_res);
    wire ifsqrt=fc[2]&fc[1];
    wire ifdiv=fc[2]&~fc[1];
    wire busy_div,busy_sqrt,stall_div,stall_sqrt;
    wire [4:0]count_div,count_sqrt;
    pipe_div div_init(clk,e,clrn,rm,dfa,dfb,ifdiv,div_res,stall_div,busy_div,count_div);
    pipe_sqrt sqrt_init(clk,e,clrn,dfa,rm,ifsqrt,stall_sqrt,busy_sqrt,count_sqrt,sqrt_res);

    wire [1:0]e1c,e2c,e3c;
    reg_design #(.WIDTH(8))r2(clk,e,clrn,{fc[2:1],fw,fd},{e1c,w1e,w1n});
    reg_design #(.WIDTH(8))r3(clk,e,clrn,{e1c,w1e,w1n},{e2c,w2e,w2n});
    reg_design #(.WIDTH(8))r4(clk,e,clrn,{e2c,w2e,w2n},{e3c,w3e,w3n});
    reg_design #(.WIDTH(38))r5(clk,e,clrn,{e3d,w3e,w3n},{wd,we,wn});

    mux4to1 gen_e3d(alu_res,mul_res,div_res,sqrt_res,e3c,e3d);
    assign stall_div_sqrt=stall_div|stall_sqrt;

endmodule
