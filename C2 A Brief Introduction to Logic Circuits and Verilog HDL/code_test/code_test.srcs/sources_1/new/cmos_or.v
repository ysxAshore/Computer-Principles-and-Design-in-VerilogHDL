`timescale 1ns / 1ps

module cmos_or(
    input a,b,
    output f
);
    wire temp;
    cmos_nor cmos_nor_inst(a,b,temp);
    cmos_not cmos_not_inst(temp,f);
endmodule
