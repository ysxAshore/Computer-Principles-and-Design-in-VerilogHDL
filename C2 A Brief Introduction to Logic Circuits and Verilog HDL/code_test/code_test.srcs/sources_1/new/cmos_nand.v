`timescale 1ns / 1ps

module cmos_nand(
    input a,b,
    output f
);
    supply1 vdd;
    supply0 gnd;
    wire temp;
    pmos pmos1(f,vdd,a);
    pmos pmos2(f,vdd,b);
    nmos nmos1(f,temp,a);
    nmos nmos2(temp,gnd,b);
endmodule
