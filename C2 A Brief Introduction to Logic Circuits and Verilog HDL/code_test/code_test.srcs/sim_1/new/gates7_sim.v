`timescale 1ns / 1ps

module gates7_sim();
    reg a,b;
    wire f_and,f_or,f_not,f_nand,f_nor,f_xor,f_xnor;
    wire f_and1,f_or1,f_not1,f_nand1,f_nor1,f_xor1,f_xnor1;
    initial begin
        a=0;b=0;
        #5 a=0;b=1;
        #5 a=1;b=0;
        #5 a=1;b=1;
        #5 $finish;
    end
    gates7_design_logicGates  gates7_design_logicGates_inst (
        .a(a),
        .b(b),
        .f_and(f_and),
        .f_or(f_or),
        .f_not(f_not),
        .f_nand(f_nand),
        .f_nor(f_nor),
        .f_xor(f_xor),
        .f_xnor(f_xnor)
    );
    gates7_design_dataflow  gates7_design_dataflow_inst (
        .a(a),
        .b(b),
        .f_and(f_and1),
        .f_or(f_or1),
        .f_not(f_not1),
        .f_nand(f_nand1),
        .f_nor(f_nor1),
        .f_xor(f_xor1),
        .f_xnor(f_xnor1)
    );
endmodule
