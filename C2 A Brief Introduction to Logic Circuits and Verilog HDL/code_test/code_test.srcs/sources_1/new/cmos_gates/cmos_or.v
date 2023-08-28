`timescale 1ns / 1ps

module cmos_or(
    input a,b,
    output f
);
    wire temp;
    cmos_nor cmos_nor_inst(a,b,temp);
    cmos_inverter cmos_inverter_inst(temp,f);
endmodule