`timescale 1ns / 1ps

module pipe_mul(
    input clk,e,clrn,
    input [31:0]a,b,
    input [1:0]rm,
    output [31:0]s
);
    wire aisinf,aiszero,aisnan,bisinf,biszero,bisnan;
    wire [23:0]nan_frac;
    wire sign;
    wire [9:0]temp_e;
    wire [47:0]sum,c;
    partical  partical_inst (
        .a(a),
        .b(b),
        .aisinf(aisinf),
        .aiszero(aiszero),
        .aisnan(aisnan),
        .bisinf(bisinf),
        .biszero(biszero),
        .bisnan(bisnan),
        .nan_frac(nan_frac),
        .sign(sign),
        .temp_e(temp_e),
        .sum(sum),
        .c(c)
    );
    
    wire aaisinf,aaiszero,aaisnan,abisinf,abiszero,abisnan;
    wire [23:0]anan_frac;
    wire asign;
    wire [9:0]atemp_e;
    wire [47:0]asum,ac;
    wire [1:0]arm;
    reg_design #(.WIDTH(139)) partical_add(clk,e,clrn,{aisinf,aiszero,aisnan,bisinf,biszero,bisnan,nan_frac,sign,temp_e,sum,c,rm},
    {aaisinf,aaiszero,aaisnan,abisinf,abiszero,abisnan,anan_frac,asign,atemp_e,asum,ac,arm});
    wire [47:0]res;
    add  add_inst (
        .sum(asum),
        .c(ac),
        .res(res)
    );
    wire naisinf,naiszero,naisnan,nbisinf,nbiszero,nbisnan;
    wire [23:0]nnan_frac;
    wire nsign;
    wire [9:0]ntemp_e;
    wire [47:0]nres;
    wire [1:0]nrm;
    reg_design #(.WIDTH(91)) add_normal(clk,e,clrn,{aaisinf,aaiszero,aaisnan,abisinf,abiszero,abisnan,anan_frac,asign,atemp_e,res,arm},
    {naisinf,naiszero,naisnan,nbisinf,nbiszero,nbisnan,nnan_frac,nsign,ntemp_e,nres,nrm});

    normal  normal_inst (
        .aisinf(naisinf),
        .aiszero(naiszero),
        .aisnan(naisnan),
        .bisinf(nbisinf),
        .biszero(nbiszero),
        .bisnan(nbisnan),
        .rm(nrm),
        .nan_frac(nnan_frac),
        .sign(nsign),
        .exp(ntemp_e),
        .res(nres),
        .s(s)
    );
endmodule
