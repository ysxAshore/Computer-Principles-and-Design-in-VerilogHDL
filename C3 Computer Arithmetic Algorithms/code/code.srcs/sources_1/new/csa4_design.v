`timescale 1ns / 1ps

module csa4_design(
    input [3:0]a,b,z,
    output [3:0]s,
    output co
);
    wire [4:0]c_temp;
    wire [4:0]s_temp;
    assign c_temp[0]=0;
    assign s_temp[4]=0;
    compressors c1_1(a[0],b[0],z[0],c_temp[1],s_temp[0]);
    compressors c1_2(a[1],b[1],z[1],c_temp[2],s_temp[1]);
    compressors c1_3(a[2],b[2],z[2],c_temp[3],s_temp[2]);
    compressors c1_4(a[3],b[3],z[3],c_temp[4],s_temp[3]);
    
    wire [3:0]co_temp;
    compressors c2_1(s_temp[0],c_temp[0],0,co_temp[0],s[0]);
    compressors c2_2(s_temp[1],c_temp[1],co_temp[0],co_temp[1],s[1]);
    compressors c2_3(s_temp[2],c_temp[2],co_temp[1],co_temp[2],s[2]);
    compressors c2_4(s_temp[3],c_temp[3],co_temp[2],co_temp[3],s[3]);

    wire p;
    compressors c2_5(s_temp[4],c_temp[4],co_temp[3],p,co);
endmodule

module compressors(
    input a,b,z,
    output co,
    output s
);
    assign {co,s}=a+b+z;
endmodule