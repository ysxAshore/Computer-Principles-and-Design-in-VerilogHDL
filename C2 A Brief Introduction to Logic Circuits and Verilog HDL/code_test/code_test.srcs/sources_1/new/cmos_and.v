`timescale 1ns / 1ps

module cmos_and(
    input a,b,
    output f
);
    wire temp;
    cmos_nand cmos_nand_inst(a,b,temp);
    cmos_not cmos_not_inst(temp,f);
endmodule
