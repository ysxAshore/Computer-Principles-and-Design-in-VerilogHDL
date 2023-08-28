`timescale 1ns / 1ps

module cmos_nor(
    input a,b,
    output f
    );
    supply1 vdd;
    supply0 gnd;
    wire temp;
    pmos pmos1(temp,vdd,a);
    pmos pmos2(f,temp,b);
    nmos nmos1(f,gnd,a);
    nmos nmos2(f,gnd,b);    
endmodule