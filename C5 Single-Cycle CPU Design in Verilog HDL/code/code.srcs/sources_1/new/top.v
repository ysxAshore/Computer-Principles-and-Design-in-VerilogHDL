`timescale 1ns / 1ps

module top(
    input clk,clrn,
    output [31:0]pc,
    output [31:0]inst,
    output [31:0]aluout,memread
);
    wire [5:0]funct,op;
    wire eq;
    wire regdst,alusrc,shift,m2reg,jal;
    wire [1:0]pcsrc;
    wire wmem,wreg;
    wire [3:0]aluc;
    wire sext;
    wire [31:0]qb;
    datapath  datapath_inst (
        .clk(clk),
        .clrn(clrn),
        .regdst(regdst),
        .alusrc(alusrc),
        .shift(shift),
        .m2reg(m2reg),
        .jal(jal),
        .wreg(wreg),
        .sext(sext),
        .pcsrc(pcsrc),
        .aluc(aluc),
        .memread(memread),
        .inst(inst),
        .eq(eq),
        .funct(funct),
        .op(op),
        .pc(pc),
        .aluout(aluout),
        .qb(qb)
      );
      cu  cu_inst (
        .funct(funct),
        .op(op),
        .eq(eq),
        .regdst(regdst),
        .alusrc(alusrc),
        .shift(shift),
        .m2reg(m2reg),
        .jal(jal),
        .pcsrc(pcsrc),
        .wmem(wmem),
        .wreg(wreg),
        .aluc(aluc),
        .sext(sext)
    );
    inst_rom inst_romInst(pc,inst);
    data_ram data_ramInst(clk,wmem,aluout,qb,memread);
endmodule
