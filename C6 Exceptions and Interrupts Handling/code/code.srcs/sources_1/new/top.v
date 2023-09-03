`timescale 1ns / 1ps

module top(
    input clk,clrn,intr,
    output inta,
    output [31:0]pc,
    output [31:0]inst,
    output [31:0]aluout,memread
);
    wire [5:0]funct,op;
    wire eq,overflow;
    wire regdst,alusrc,shift,m2reg,jal,exc,mtc0_sel;
    wire [1:0]pcsrc,pcsel;
    wire wmem,wreg,wcau,wsta,wepc;
    wire [1:0]mfc0_sel;
    wire [3:0]aluc;
    wire sext;
    wire [31:0]qb,status_word,cause_word;
    wire [4:0]rd,decode_cp0;

    datapath  datapath_inst (
        .clk(clk),
        .clrn(clrn),
        .regdst(regdst),
        .alusrc(alusrc),
        .shift(shift),
        .m2reg(m2reg),
        .jal(jal),
        .mtc0_sel(mtc0_sel),
        .exc(exc),
        .inta(inta),
        .wreg(wreg),
        .wcau(wcau),
        .wsta(wsta),
        .wepc(wepc),
        .sext(sext),
        .pcsrc(pcsrc),
        .pcsel(pcsel),
        .mfc0_sel(mfc0_sel),
        .aluc(aluc),
        .memread(memread),
        .inst(inst),
        .cause_word(cause_word),
        .eq(eq),
        .overflow(overflow),
        .funct(funct),
        .op(op),
        .rs(decode_cp0),
        .rd(rd),
        .pc(pc),
        .aluout(aluout),
        .qb(qb),
        .status_word(status_word)
      );
      cu  cu_inst (
        .status_word(status_word),
        .funct(funct),
        .op(op),
        .eq(eq),
        .overflow(overflow),
        .intr(intr),
        .decode_cp0(decode_cp0),
        .rd(rd),
        .regdst(regdst),
        .alusrc(alusrc),
        .shift(shift),
        .m2reg(m2reg),
        .jal(jal),
        .exc(exc),
        .inta(inta),
        .mtc0_sel(mtc0_sel),
        .pcsrc(pcsrc),
        .pcsel(pcsel),
        .mfc0_sel(mfc0_sel),
        .wmem(wmem),
        .wreg(wreg),
        .wcau(wcau),
        .wsta(wsta),
        .wepc(wepc),
        .aluc(aluc),
        .sext(sext),
        .cause_word(cause_word)
    );
    inst_rom inst_romInst(pc,inst);
    data_ram data_ramInst(clk,wmem,aluout,qb,memread);
endmodule
