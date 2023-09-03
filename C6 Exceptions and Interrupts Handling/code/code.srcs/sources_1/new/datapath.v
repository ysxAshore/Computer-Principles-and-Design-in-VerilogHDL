`timescale 1ns / 1ps

module datapath(
    input clk,clrn,
    input regdst,alusrc,shift,m2reg,jal,mtc0_sel,exc,inta,
    input wreg,wcau,wsta,wepc,
    input sext,

    input [1:0]pcsrc,pcsel,mfc0_sel,
    input [3:0]aluc,

    input [31:0]memread,
    input [31:0]inst,
    input [31:0]cause_word,

    output eq,overflow,
    output [5:0]funct,op,
    output [4:0]rs,rd,
    output [31:0]pc,aluout,qb,status_word
);
    //pc赋值
    wire [31:0]npc_temp,pcAdder4,bpc,jpc,rpc,epc_read,npc;
    wire [31:0]base=32'h0000_0008;
    mux4to1 npcTemp_init(pcAdder4,bpc,rpc,jpc,pcsrc,npc_temp);
    mux4to1 npc_init(npc_temp,epc_read,base,32'b0,pcsel,npc);
    pc pc_init(clk,clrn,npc,pc);
    adder pc_adder(pc,32'd4,pcAdder4);
    assign jpc={pcAdder4[31:29],inst[25:0],2'b00};

    //赋值寄存器相关
    wire[4:0]rt;
    assign rs=inst[25:21];
    assign rt=inst[20:16];
    assign rd=inst[15:11];
    assign funct=inst[5:0];
    assign op=inst[31:26];

    //产生写寄存器地址
    wire [31:0]tempA;
    wire [4:0]wn;
    mux2to1 mux2to1_wreg_A({27'b0,rd},{27'b0,rt},regdst,tempA);
    assign wn=tempA[4:0]|{5{jal}};

    //写寄存器数据选择
    wire [31:0]wregData_temp1,wregData_temp2;
    wire [31:0]cause_read;
    mux2to1 generate_wregData_temp1(aluout,memread,m2reg,wregData_temp1);
    mux4to1 generate_wregData_temp2(wregData_temp1,status_word,cause_read,epc_read,mfc0_sel,wregData_temp2);
    wire [31:0]wregData;
    mux2to1 generate_wregData(wregData_temp2,pcAdder4,jal,wregData);
    //寄存器模块
    wire [31:0]qa;
    regfile regfile_init(clk,wreg,clrn,rs,rt,wn,wregData,qa,qb);
    assign rpc=qa;
    assign eq=~|(qa^qb);

    //立即数扩展模块
    wire [15:0]imm=inst[15:0];
    wire [31:0]imm_sext={{16{sext&imm[15]}},imm};
    adder generate_bpc(pcAdder4,imm_sext<<2,bpc);

    //ALU模块
    wire [31:0]a,b;
    wire z;
    mux2to1 generate_alua(qa,{26'b0,imm[10:6]},shift,a);
    mux2to1 generate_alub(qb,imm_sext,alusrc,b);
    alu alu_init(a,b,aluc,aluout,z,overflow);

    //Cause输入数据的选择
    wire [31:0]cause_write;
    mux2to1 generate_causeWriteData(cause_word,qb,mtc0_sel,cause_write);
    //Status输入数据的选择
    wire [31:0]status_temp1,status_write;
    wire [31:0]status_left={status_word[27:0],4'b0};
    wire [31:0]status_right={4'b0,status_word[31:4]};
    mux2to1 generate_statusTemp1(status_right,status_left,exc,status_temp1);
    mux2to1 generate_statusWrite(status_temp1,qb,mtc0_sel,status_write);
    //EPC输入数据的选择
    wire [31:0]epc_temp1,epc_write;
    mux2to1 generate_epcTemp1(pc,npc_temp,inta,epc_temp1);
    mux2to1 generate_epcWrite(epc_temp1,qb,mtc0_sel,epc_write);
    //增加的三个寄存器
    reg_design Cause(clk,wcau,cause_write,cause_read);
    reg_design Status(clk,wsta,status_write,status_word);
    reg_design EPC(clk,wepc,epc_write,epc_read);
endmodule
