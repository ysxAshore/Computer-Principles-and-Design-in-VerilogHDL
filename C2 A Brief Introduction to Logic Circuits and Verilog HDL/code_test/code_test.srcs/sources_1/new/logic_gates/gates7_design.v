`timescale 1ns / 1ps

module gates7_design_logicGates(
    input a,b,
    output f_and,f_or,f_not,f_nand,f_nor,f_xor,f_xnor
);
    and and_init(f_and,a,b);
    or or_init(f_or,a,b);
    not not_init(f_not,a);
    nand nand_init(f_nand,a,b);
    nor nor_init(f_nor,a,b);
    xor xor_init(f_xor,a,b);
    xnor xnor_init(f_xnor,a,b);
endmodule
module gates7_design_dataflow(
    input a,b,
    output f_and,f_or,f_not,f_nand,f_nor,f_xor,f_xnor
);
    assign f_and=a&b;
    assign f_or=a|b;
    assign f_not=~a;
    assign f_nand=~(a&b);
    assign f_nor=~(a|b);
    assign f_xor=a^b;
    assign f_xnor=~(a^b);
endmodule
