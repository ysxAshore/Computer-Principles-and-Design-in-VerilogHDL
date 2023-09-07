`timescale 1ns / 1ps


module top(
    input clk,clrn,intr,
    output [31:0]pc,inst,aluoutM,aluoutE,wd,
    output inta
);
    //PC更新
    wire wpcir;
    wire [1:0]pcsrc,selpc;
    //IF/ID
    wire [5:0]op,funct;
    wire [4:0]rs,rt,ewn,mwn,rd;
    wire [31:0]sta,cause;
    wire sext,regdst,wcau,wsta,wepc,exc,mtc0;
    wire [1:0]forwardAD,forwardBD,sepc;
    wire z,irq;
    //ID/EX
    wire eshift,ealusrc,ejal;
    wire [3:0]ealuc;
    wire [1:0]emfc0;
    wire overflow;
    //EX/MEM
    wire mwmem;
    wire [31:0]memWriteData;
    wire [31:0]memreadM;
    //MEM/WB
    wire wm2reg,wwreg;

    datapath  datapath_inst (
        .clk(clk),
        .clrn(clrn),
        .wpcir(wpcir),
        .intr(intr),
        .pcsrc(pcsrc),
        .selpc(selpc),
        .pc(pc),
        .inst(inst),
        .op(op),
        .funct(funct),
        .rs(rs),
        .rt(rt),
        .rd(rd),
        .sta(sta),
        .sext(sext),
        .regdst(regdst),
        .wcau(wcau),
        .wsta(wsta),
        .wepc(wepc),
        .exc(exc),
        .mtc0(mtc0),
        .forwardAD(forwardAD),
        .forwardBD(forwardBD),
        .sepc(sepc),
        .cause(cause),
        .z(z),
        .irq(irq),
        .eshift(eshift),
        .ealusrc(ealusrc),
        .ejal(ejal),
        .ealuc(ealuc),
        .emfc0(emfc0),
        .overflow(overflow),
        .ewn(ewn),
        .mwmem(mwmem),
        .aluoutM(aluoutM),
        .memWriteData(memWriteData),
        .memreadM(memreadM),
        .mwn(mwn),
        .wm2reg(wm2reg),
        .wwreg(wwreg),
        .wd(wd),
        .aluoutE(aluoutE)
      );
      cu  cu_inst (
        .clk(clk),
        .clrn(clrn),
        .funct(funct),
        .op(op),
        .rs(rs),
        .rt(rt),
        .ewn(ewn),
        .mwn(mwn),
        .rd(rd),
        .z(z),
        .overflow(overflow),
        .irq(irq),
        .sta(sta),
        .wpcir(wpcir),
        .pcsrc(pcsrc),
        .selpc(selpc),
        .sext(sext),
        .regdst(regdst),
        .wcau(wcau),
        .wsta(wsta),
        .wepc(wepc),
        .exc(exc),
        .mtc0(mtc0),
        .forwardAD(forwardAD),
        .forwardBD(forwardBD),
        .sepc(sepc),
        .cause(cause),
        .inta(inta),
        .ejal(ejal),
        .eshift(eshift),
        .ealusrc(ealusrc),
        .ealuc(ealuc),
        .emfc0(emfc0),
        .mwmem(mwmem),
        .wwreg(wwreg),
        .wm2reg(wm2reg)
      );
    p1_inst_mem rom(pc,inst);
    p1_data_mem ram(clk,mwmem,aluoutM,memWriteData,memreadM);
endmodule
