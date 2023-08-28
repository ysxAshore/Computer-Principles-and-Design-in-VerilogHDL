`timescale 1ns / 1ps

module dff_design(
    input d,
    input clk,
    output q,
    output qn
);
    wire clkn,clknn;
    wire q0,qn0;
    not not1(clkn,clk);
    d_latch  d_latch_1 (
        .d(d),
        .c(clkn),
        .q(q0),
        .qn(qn0)
    );
    not not2(clknn,clkn);//为什么要两个非门，不直接接clk->表示从触发器不是受clk上升沿控制的，只是用它的电平
    d_latch  d_latch_2 (
        .d(q0),
        .c(clknn),
        .q(q),
        .qn(qn)
    );
endmodule



module dff_insDesign(
    input d,
    input clk,
    input prn,
    input clrn,
    output q,
    output qn
);
    wire nand1,nand2,nand3,nand4,nand5,nand6;
    assign nand1=~(clk&clrn&nand2);
    assign nand2=~(nand1&prn&nand4);
    assign nand3=~(nand1&clk&nand4);
    assign nand4=~(nand3&clrn&d);
    assign nand5=~(prn&nand1&nand6);
    assign nand6=~(nand5&nand3&clrn);
    assign q=nand5;
    assign qn=nand6;
endmodule