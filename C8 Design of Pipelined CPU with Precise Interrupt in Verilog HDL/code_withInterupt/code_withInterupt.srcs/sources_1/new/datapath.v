`timescale 1ns / 1ps

module datapath(
    input clk,clrn,

    //PC更新
    input wpcir,intr,//多intr表示中断请求
    input [1:0]pcsrc,selpc,//多selpc去在npc、base、epc中选择
    output [31:0]pc,
    input [31:0]inst,

    //IF/ID
    output [5:0]op,funct,
    output [4:0]rs,rt,rd,
    output [31:0]sta,//多了给CU的状态字
    input sext,regdst,wcau,wsta,wepc,exc,mtc0,//多了写CP0寄存器的信号,还有选择信号
    input [1:0]forwardAD,forwardBD,sepc,
    input [31:0]cause,//写Cause寄存器的字
    output z,irq,

    //ID/EX
    input eshift,ealusrc,ejal,
    input [3:0]ealuc,
    input [1:0]emfc0,//选择CP0寄存器的读出数据
    output overflow,
    output [4:0]ewn,

    //EX/MEM
    output mwmem,
    output [31:0]aluoutM,memWriteData,
    input [31:0]memreadM,
    output [4:0]mwn,

    //MEM/WB
    input wm2reg,wwreg,

    output [31:0]wd,aluoutE
);

    //PC寄存器的更新
    wire [31:0]pcAdder4,bpc,jpc,rpc,npc,next_pc,epc;
    mux4to1 generate_npc(pcAdder4,bpc,rpc,jpc,pcsrc,npc);
    mux4to1 generate_nextPC(npc,epc,32'd8,32'd0,selpc,next_pc);
    regDesign #(.WIDTH(32))pc_init(clk,wpcir,clrn,next_pc,pc);
    adder generate_pcAdder4(pc,32'd4,pcAdder4);

    //IF/ID
    wire [31:0]pcAdder4D,instrD,pcD;
    regDesign #(.WIDTH(97))if_id_inst(clk,wpcir,clrn,{pcAdder4,inst,pc,intr},{pcAdder4D,instrD,pcD,irq});//当要先清0
    wire [15:0]imm=instrD[15:0];
    wire [31:0]imm_sext={{16{imm[15]&sext}},imm[15:0]};
    assign op=instrD[31:26];
    assign funct=instrD[5:0];//写的时候忘记标注了
    assign rs=instrD[25:21];
    assign rt=instrD[20:16];
    assign rd=instrD[15:11];
    adder generate_bpc(pcAdder4D,imm_sext<<2,bpc);
    assign jpc={pcAdder4D[31:28],instrD[25:0],2'b0};
    wire [31:0]qa,qb;
    wire [4:0]wn_temp,wwn;

    //用WB阶段的信号写回
    regfile regfile_init(~clk,wwreg,clrn,rs,rt,wwn,wd,qa,qb);
    mux2to1 generate_wn_temp(rd,rt,regdst,wn_temp);

    wire [31:0]A,B;
    mux4to1 generateA(qa,aluoutE,aluoutM,memreadM,forwardAD,A);
    mux4to1 generateB(qb,aluoutE,aluoutM,memreadM,forwardBD,B);
    assign rpc=A;
    assign z=~|(A^B);//判断0时，刚开始写成了~(A^B)是对A^B所有位取反,需要先连续|得到的结果再取反~|

    wire [31:0]sta_left={sta[27:0],4'b0};
    wire [31:0]sta_right={4'b0,sta[31:4]};
    wire [31:0]pcE,pcM,writeEPCtemp,writeStatemp;
    mux4to1 generate_writeEPCtemp(pc,pcD,pcE,pcM,sepc,writeEPCtemp);
    mux2to1 generate_writeStatemp(sta_right,sta_left,exc,writeStatemp);
    wire [31:0]epcD,staD,cauD;
    
    //会有数据冒险
    wire [31:0]cau;
    mux2to1 gstaD(writeStatemp,B,mtc0,staD);
    mux2to1 gepcD(writeEPCtemp,B,mtc0,epcD);
    mux2to1 gcauD(cause,B,mtc0,cauD);
    regDesign #(.WIDTH(32))sta_reg(clk,wsta,clrn,staD,sta);
    regDesign #(.WIDTH(32))epc_reg(clk,wepc,clrn,epcD,epc);
    regDesign #(.WIDTH(32))cau_reg(clk,wcau,clrn,cauD,cau);
    
    //ID/EXE
    wire [31:0]pcAdder4E,eA,eB,eimmSext;
    wire [4:0]ewn_temp;
    regDesign #(.WIDTH(165))id_ex_init(clk,1'b1,clrn,{pcAdder4D,A,B,imm_sext,wn_temp,pcD},{pcAdder4E,eA,eB,eimmSext,ewn_temp,pcE});//位宽刚开始数错了，也要清0
    wire [31:0]pcAdder8,aluA,aluB;
    adder generate_pcAdder8(pcAdder4E,32'd4,pcAdder8);
    mux2to1 generate_ALUa(eA,{27'b0,eimmSext[10:6]},eshift,aluA);
    mux2to1 generate_ALUb(eB,eimmSext,ealusrc,aluB);
    wire zero;
    wire [31:0]alures,pc8c0r;
    alu alu_init(aluA,aluB,ealuc,alures,zero,overflow);

    mux4to1 generate_pc8c0r(pcAdder8,sta,cau,epc,emfc0,pc8c0r);
    mux2to1 generate_aluout(alures,pc8c0r,ejal|(|emfc0),aluoutE);
    assign ewn=ewn_temp|{5{ejal}};


    //EX/MEM
    regDesign #(.WIDTH(101)) ex_mem_init(clk,1'b1,clrn,{aluoutE,eB,ewn,pcE},{aluoutM,memWriteData,mwn,pcM});//也要清0
    //MEM/WB
    wire [31:0]aluoutW,memreadW;
    regDesign #(.WIDTH(69))mem_wb_init(clk,1'b1,clrn,{aluoutM,memreadM,mwn},{aluoutW,memreadW,wwn});//也要清0
    mux2to1 generate_wd(aluoutW,memreadW,wm2reg,wd);

endmodule
