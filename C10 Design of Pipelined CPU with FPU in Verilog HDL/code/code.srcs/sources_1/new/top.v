`timescale 1ns / 1ps


module iu(
    input clk,clrn,
    output [4:0]fs,ft,fd,wwn,
    input [4:0]w1n,w2n,w3n,
    input w1e,w2e,w3e,stall_div_sqrt,
    input [31:0]e3d,dfb,memreadW,memreadM,
    output [2:0]fc,
    output wwfpr,wf,
    output wfdla,wfdlb,wfdfa,wfdfb
);
    //PC更新
    wire wpcir;
    wire [1:0]pcsrc;
    wire [31:0]pc;
    //IF/ID
    wire [5:0]op,funct;
    wire [4:0]rs,rt,ewn,mwn;
    wire sext,regdst,fwdf;
    wire [1:0]forwardAD,forwardBD;
    wire z;
    wire [31:0]inst;
    //ID/EX
    wire eshift,ealusrc,ejal,swfp,efwdfe;
    wire [3:0]ealuc;
    wire [31:0]aluoutE;
    //EX/MEM
    wire mwmem;
    wire [31:0]memWriteData;
    wire [31:0]aluoutM;
    //MEM/WB
    wire wm2reg,wwreg;
    wire [31:0]wd;

    datapath  datapath_inst (
        clk,clrn,wpcir,pcsrc,pc,inst,op,funct,rs,rt,fs,ft,fd,
        sext,regdst,fwdf,forwardAD,forwardBD,z,eshift,ealusrc,ejal,
        swfp,efwdfe,ealuc,e3d,dfb,ewn,mwmem,aluoutM,memWriteData,
        memreadM,mwn,wm2reg,wwreg,wwn,wd,aluoutE,memreadW
    );
    cu  cu_inst (
        clk,clrn,funct,op,rs,rt,ewn,mwn,z,wpcir,pcsrc,sext,regdst,forwardAD,forwardBD,
        ejal,eshift,ealusrc,ealuc,mwmem,wwreg,wm2reg,fs,ft,fc,wwfpr,wf,fwdf,efwdfe,swfp,
        wfdla,wfdlb,wfdfa,wfdfb,w1n,w2n,w3n,w1e,w2e,w3e,stall_div_sqrt
    );
    p1_inst_mem rom(pc,inst);
    p1_data_mem ram(clk,mwmem,aluoutM,memWriteData,memreadM);
endmodule
