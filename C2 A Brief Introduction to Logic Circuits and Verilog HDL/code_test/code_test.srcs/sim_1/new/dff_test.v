`timescale 1ns / 1ps

module dff_test();
reg d,clk,prn,clrn;
wire q1,qn1,q2,qn2;
    initial begin
        d=0;clk=0;prn=1;clrn=1;//prn、qrn低有效
        #2;prn=0;//2ns
        #1;clrn=0;prn=1;//3ns
        #1;d=1;clrn=1;//4ns
        #7;d=0;//12ns
        #8;d=1;//21ns
    end
    
    always #5 clk=~clk;
    dff_design dff1(d,clk,q1,qn1);
    dff_insDesign dff2(d,clk,prn,clrn,q2,qn2);
endmodule
