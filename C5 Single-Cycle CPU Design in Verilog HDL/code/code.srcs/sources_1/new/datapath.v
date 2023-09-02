`timescale 1ns / 1ps

module datapath(
    input clk,clrn,
    input regdst,alusrc,shift,m2reg,jal,
    input wreg,
    input sext,

    input [1:0]pcsrc,
    input [3:0]aluc,

    input [31:0]memread,
    input [31:0]inst,

    output eq,
    output [5:0]funct,op,
    output [31:0]pc,aluout,qb
);
    //pc赋值
    wire [31:0]npc,pcAdder4,bpc,jpc,rpc;
    mux4to1 npc_init(pcAdder4,bpc,rpc,jpc,pcsrc,npc);
    pc pc_init(clk,clrn,npc,pc);
    adder pc_adder(pc,32'd4,pcAdder4);
    assign jpc={pcAdder4[31:29],inst[25:0],2'b00};

    //赋值寄存器相关
    wire[4:0]rs,rt,rd;
    assign rs=inst[25:21];
    assign rt=inst[20:16];
    assign rd=inst[15:11];
    assign funct=inst[5:0];
    assign op=inst[31:26];

    //产生写寄存器地址
    wire [4:0]tempA,wn;
    mux2to1 mux2to1_wreg_A(rd,rt,regdst,tempA);
    assign wn=tempA|{5{jal}};

    //写寄存器数据选择
    wire [31:0]wregData_temp;
    mux2to1 generate_wregData_temp(aluout,memread,m2reg,wregData_temp);
    wire [31:0]wregData;
    mux2to1 generate_wregData(wregData_temp,pcAdder4,jal,wregData);
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
    alu alu_init(a,b,aluc,aluout,z);
endmodule
