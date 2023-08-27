`timescale 1ns / 1ps

module cmos_mux2to1(
    input a0,a1,s,
    output y
);
    
    wire temp;
    cmos_not(s,temp);
    cmos_cmos cmos0(s,temp,a0,y);
    cmos_cmos cmos1(temp,s,a1,y);
endmodule

module cmos_cmos(
    input p_gate,n_gate,
    input source,
    output drain
);
    pmos p1(drain,source,p_gate);
    nmos n1(drain,source,n_gate);
endmodule