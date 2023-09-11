`timescale 1ns / 1ps

module top_cpu(
    input clk,clrn,
    input [1:0]rm
);
    wire [31:0]dfa;
    wire fw;
    wire [31:0]wd;
    wire [4:0]wn;
    wire we;
    wire e;
    wire [4:0]fs,ft,fd,wwn;
    wire [4:0]w1n,w2n,w3n;
    wire w1e,w2e,w3e,stall_div_sqrt;
    wire [31:0]e3d,dfb,memreadW,memreadM;
    wire [2:0]fc;
    wire wwfpr;
    wire wfdla,wfdlb,wfdfa,wfdfb;

    wire [31:0]qa,qb,fa,fb;
    fpu fpu_init(clk,clrn,dfa,dfb,fd,fc,rm,fw,wd,wn,we,w1n,w2n,w3n,w1e,w2e,w3e,e3d,stall_div_sqrt,e);
    iu iu_init(clk,clrn,fs,ft,fd,wwn,w1n,w2n,w3n,w1e,w2e,w3e,stall_div_sqrt,e3d,dfb,memreadW,memreadM,fc,wwfpr,fw,wfdla,wfdlb,wfdfa,wfdfb);
    twoWriteReg reg_init(~clk,clrn,wd,wn,we,memreadW,wwn,wwfpr,fs,ft,qa,qb);

    mux2to1 gen_fa(qa,memreadM,wfdla,fa);
    mux2to1 gen_fb(qb,memreadM,wfdlb,fb);
    mux2to1 gen_dfa(fa,e3d,wfdfa,dfa);
    mux2to1 gen_dfb(fb,e3d,wfdfb,dfb);
endmodule
