`timescale 1ns / 1ps

module top(
    input clk,clrn,
    output [31:0]memread,
    output [31:0]memaddr
);
    wire regdst,alusrc,shift,m2reg,jal,iord,selpc;
    wire wreg,wpc,wir;
    wire sext;

    wire [1:0]pcsrc,alusrcb;
    wire [3:0]aluc;

    wire eq;
    wire [5:0]funct,op;
    wire [31:0]qb;
    datapath  datapath_inst (
        .clk(clk),
        .clrn(clrn),
        .regdst(regdst),
        .alusrc(alusrc),
        .shift(shift),
        .m2reg(m2reg),
        .jal(jal),
        .iord(iord),
        .selpc(selpc),
        .wreg(wreg),
        .wpc(wpc),
        .wir(wir),
        .sext(sext),
        .pcsrc(pcsrc),
        .alusrcb(alusrcb),
        .aluc(aluc),
        .memread(memread),
        .eq(eq),
        .funct(funct),
        .op(op),
        .qb(qb),
        .memaddr(memaddr)
    );
    cu  cu_inst (
        .clk(clk),
        .clrn(clrn),
        .funct(funct),
        .op(op),
        .eq(eq),
        .regdst(regdst),
        .alusrc(alusrc),
        .shift(shift),
        .m2reg(m2reg),
        .jal(jal),
        .iord(iord),
        .selpc(selpc),
        .pcsrc(pcsrc),
        .alusrcb(alusrcb),
        .wmem(wmem),
        .wreg(wreg),
        .wpc(wpc),
        .wir(wir),
        .aluc(aluc),
        .sext(sext)
    );
    mem  mem_inst (
        .clk(clk),
        .addr(memaddr),
        .idata(qb),
        .we(wmem),
        .odata(memread)
    );
endmodule
