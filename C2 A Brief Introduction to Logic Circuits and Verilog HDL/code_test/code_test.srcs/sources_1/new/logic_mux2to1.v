`timescale 1ns / 1ps

module trigger_mux2to1(
    input s,a0,a1,
    output y
);
    bufif0 bufif0_init(y,a0,s);//低有效的三态门
    bufif1 bufif1_init(y,a1,s);
endmodule

module logic_mux2to1(
    input s,a0,a1,
    output y
);
    wire sn,a0_sn,a1_s;
    not not_init(sn,s);
    and and_init1(a0_sn,a0,sn);
    and and_init2(a1_s,a1,s);
    or or_init(y,a0_sn,a1_s);
endmodule