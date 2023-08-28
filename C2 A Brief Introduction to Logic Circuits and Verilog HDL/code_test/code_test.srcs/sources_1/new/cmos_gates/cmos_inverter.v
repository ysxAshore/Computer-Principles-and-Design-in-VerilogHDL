`timescale 1ns/1ps

module cmos_inverter(
    input a,
    output f
);
    supply1 vdd;//高电平
    supply0 gnd;//接地端

    // Verilog已实现pmos(drain,source,gate);
    pmos pmos_1(f,vdd,a);
    // Verilog已实现nmos(drain,source,gate);
    nmos nmos_1(f,gnd,a);

endmodule