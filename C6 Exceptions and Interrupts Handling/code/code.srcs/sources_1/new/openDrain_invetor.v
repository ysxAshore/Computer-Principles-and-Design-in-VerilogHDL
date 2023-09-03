`timescale 1ns / 1ps

module openDrain_invetorByopenDrain(
    input a,b,c,
    output r
);
    wire temp1,temp2,temp3;
    not not_1(temp1,a);
    not not_2(temp2,b);
    not not_3(temp3,c);

    opndrn o1(.in(temp1),.out(r));
    opndrn o2(.in(temp2),.out(r));
    opndrn o3(.in(temp3),.out(r));
endmodule

module openDrain_invetorBytrigate(
    input a,b,c,
    output r
);
    bufif1 o1(r,0,a);
    bufif1 o2(r,0,b);
    bufif1 o3(r,0,c);
endmodule

module openDrain_invertorByBehav(
    input a,b,c,
    output tri r
);
    assign r=a?0:1'bz;
    assign r=b?0:1'bz;
    assign r=c?0:1'bz;
    //也可以声明r为wire型，assign r=(a|b|c)?0:1'bz;
endmodule

