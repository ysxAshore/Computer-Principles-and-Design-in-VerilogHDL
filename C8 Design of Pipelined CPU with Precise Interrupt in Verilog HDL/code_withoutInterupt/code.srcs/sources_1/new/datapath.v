`timescale 1ns / 1ps

module datapath(
    input clk,clrn,

    //PC更新
    input wpcir,
    input [1:0]pcsrc,
    output [31:0]pc,
    input [31:0]inst,

    //IF/ID
    output [5:0]op,funct,
    output [4:0]rs,rt,
    input sext,regdst,
    input [1:0]forwardAD,forwardBD,
    output z,

    //ID/EX
    input eshift,ealusrc,ejal,
    input [3:0]ealuc,
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
    wire [31:0]pcAdder4,bpc,jpc,rpc,npc;
    mux4to1 generate_npc(pcAdder4,bpc,rpc,jpc,pcsrc,npc);
    regDesign #(.WIDTH(32))pc_init(clk,wpcir,clrn,npc,pc);
    adder generate_pcAdder4(pc,32'd4,pcAdder4);

    //IF/ID
    wire [31:0]pcAdder4D,instrD;
    regDesign #(.WIDTH(64))if_id_inst(clk,wpcir,clrn,{pcAdder4,inst},{pcAdder4D,instrD});//当要先清0
    wire [4:0]rd;
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

    //ID/EXE
    wire [31:0]pcAdder4E,eA,eB,eimmSext;
    wire [4:0]ewn_temp;
    regDesign #(.WIDTH(133))id_ex_init(clk,1'b1,clrn,{pcAdder4D,A,B,imm_sext,wn_temp},{pcAdder4E,eA,eB,eimmSext,ewn_temp});//位宽刚开始数错了，也要清0
    wire [31:0]pcAdder8,aluA,aluB;
    adder generate_pcAdder8(pcAdder4E,32'd4,pcAdder8);
    mux2to1 generate_ALUa(eA,{27'b0,eimmSext[10:6]},eshift,aluA);
    mux2to1 generate_ALUb(eB,eimmSext,ealusrc,aluB);
    wire zero,overflow;
    wire [31:0]alures;
    alu alu_init(aluA,aluB,ealuc,alures,zero,overflow);
    mux2to1 generate_aluout(alures,pcAdder8,ejal,aluoutE);
    assign ewn=ewn_temp|{5{ejal}};
    //EX/MEM
    regDesign #(.WIDTH(69)) ex_mem_init(clk,1'b1,clrn,{aluoutE,eB,ewn},{aluoutM,memWriteData,mwn});//也要清0
    //MEM/WB
    wire [31:0]aluoutW,memreadW;
    regDesign #(.WIDTH(69))mem_wb_init(clk,1'b1,clrn,{aluoutM,memreadM,mwn},{aluoutW,memreadW,wwn});//也要清0
    mux2to1 generate_wd(aluoutW,memreadW,wm2reg,wd);

endmodule
