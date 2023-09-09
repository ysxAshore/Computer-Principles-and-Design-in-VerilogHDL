`timescale 1ns / 1ps

module top_design(
    input clk,
    input [31:0]a,b,
    input [1:0]rm,
    input sub,
    output [31:0]s
);
    wire op_sub,isNan,isInf,sign;
    wire [27:0]aligned_large_frac,aligned_small_frac;
    wire [23:0]nan_frac,inf_frac;
    wire [31:0]fp_large,fp_small;
    wire [7:0]temp_e;
    wire [1:0]crm;
    align_design  align_design_inst (
        .a(a),
        .b(b),
        .rm(rm),
        .sub(sub),
        .op_sub(op_sub),
        .isNan(isNan),
        .isInf(isInf),
        .sign(sign),
        .aligned_large_frac(aligned_large_frac),
        .aligned_small_frac(aligned_small_frac),
        .nan_frac(nan_frac),
        .inf_frac(inf_frac),
        .fp_large(fp_large),
        .fp_small(fp_small),
        .temp_e(temp_e),
        .crm(crm)
    );
    wire cop_sub,cisNan,cisInf,csign;
    wire [27:0]caligned_large_frac,caligned_small_frac;
    wire [23:0]cnan_frac,cinf_frac;
    wire [31:0]cfp_large,cfp_small;
    wire [7:0]ctemp_e;
    wire [1:0]ccrm;
    reg_design #(.WIDTH(182))align_cal(clk,1,0,{op_sub,isNan,isInf,sign,aligned_large_frac,aligned_small_frac,nan_frac,inf_frac,
    fp_large,fp_small,temp_e,crm},{cop_sub,cisNan,cisInf,csign,caligned_large_frac,caligned_small_frac,cnan_frac,cinf_frac,
    cfp_large,cfp_small,ctemp_e,ccrm});

    wire [27:0]cal_frac;
    cal_design  cal_design_inst (
        .aligned_large_frac(caligned_large_frac),
        .aligned_small_frac(caligned_small_frac),
        .op_sub(cop_sub),
        .cal_frac(cal_frac)
    );
    wire nisNan,nisInf,nsign;
    wire [23:0]nnan_frac,ninf_frac;
    wire [31:0]nfp_large,nfp_small;
    wire [7:0]ntemp_e;
    wire [1:0]ncrm;
    wire [27:0]ncal_frac;
    reg_design #(.WIDTH(153))cal_normal(clk,1,0,{cisNan,cisInf,csign,cnan_frac,cinf_frac,
    cfp_large,cfp_small,ctemp_e,ccrm,cal_frac},{nisNan,nisInf,nsign,nnan_frac,ninf_frac,
    nfp_large,nfp_small,ntemp_e,ncrm,ncal_frac});
    normal_design  normal_design_inst (
        .cal_frac(ncal_frac),
        .isNan(nisNan),
        .isInf(nisInf),
        .sign(nsign),
        .nan_frac(nnan_frac),
        .inf_frac(ninf_frac),
        .fp_large(nfp_large),
        .fp_small(nfp_small),
        .temp_e(ntemp_e),
        .crm(ncrm),
        .s(s)
    );
endmodule
