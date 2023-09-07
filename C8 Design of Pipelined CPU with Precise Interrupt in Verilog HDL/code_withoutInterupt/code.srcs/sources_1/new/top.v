`timescale 1ns / 1ps


module top(
    input clk,clrn,
    output [31:0]pc,inst,aluoutM,aluoutE,wd
);
    //PC更新
    wire wpcir;
    wire [1:0]pcsrc;
    //IF/ID
    wire [5:0]op,funct;
    wire [4:0]rs,rt,ewn,mwn;
    wire sext,regdst;
    wire [1:0]forwardAD,forwardBD;
    wire z;
    //ID/EX
    wire eshift,ealusrc,ejal;
    wire [3:0]ealuc;
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
        .pcsrc(pcsrc),
        .pc(pc),
        .inst(inst),
        .op(op),
        .funct(funct),
        .rs(rs),
        .rt(rt),
        .sext(sext),
        .regdst(regdst),
        .forwardAD(forwardAD),
        .forwardBD(forwardBD),
        .z(z),
        .eshift(eshift),
        .ealusrc(ealusrc),
        .ejal(ejal),
        .ealuc(ealuc),
        .mwmem(mwmem),
        .aluoutM(aluoutM),
        .memreadM(memreadM),
        .memWriteData(memWriteData),
        .wm2reg(wm2reg),
        .wwreg(wwreg),
        .wd(wd),
        .aluoutE(aluoutE),
        .ewn(ewn),
        .mwn(mwn)
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
        .z(z),
        .wpcir(wpcir),
        .pcsrc(pcsrc),
        .sext(sext),
        .regdst(regdst),
        .forwardAD(forwardAD),
        .forwardBD(forwardBD),
        .ejal(ejal),
        .eshift(eshift),
        .ealusrc(ealusrc),
        .ealuc(ealuc),
        .mwmem(mwmem),
        .wwreg(wwreg),
        .wm2reg(wm2reg)
    );
    p1_inst_mem rom(pc,inst);
    p1_data_mem ram(clk,mwmem,aluoutM,memWriteData,memreadM);
endmodule
