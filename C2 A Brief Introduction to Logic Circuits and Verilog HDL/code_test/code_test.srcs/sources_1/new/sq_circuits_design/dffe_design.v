`timescale 1ns / 1ps


//坏的设计——en和clk与接clk->改变了时钟
module dffe_design(
    input d,e,clk,clrn,prn,
    output q,qn
);
    wire temp=e?d:q;
    dff_insDesign dffe(
        temp,clk,prn,clrn,q,qn
    );
endmodule
