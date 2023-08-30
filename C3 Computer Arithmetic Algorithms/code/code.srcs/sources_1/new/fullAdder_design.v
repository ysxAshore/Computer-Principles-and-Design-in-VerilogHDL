`timescale 1ns / 1ps

module fullAdder_designBylogic(
    input a,b,ci,
    output co,s 
);
    wire temp;
    xor xor1(temp,b,ci);
    xor xor2(s,a,temp);//s=a^b^ci
    
    wire a_b1,a_b2,aob;
    and and1(a_b1,a,b);//ab
    or or1(aob,a,b);//a+b
    and and2(a_b2,aob,ci);//(a+b)ci
    or or2(co,a_b1,a_b2);
endmodule

module fullAdder_designBydata(
    input a,b,ci,
    output co,s 
);
    assign s=a^b^ci;
    assign co=a&b|(a|b)&ci;
endmodule

module fullAdder_designBybehav(
    input a,b,ci,
    output co,s 
);
    assign {co,s}=a+b+ci;
endmodule