`timescale 1ns / 1ps

module datapath(
    input clk,clrn,
    input regdst,alusrc,shift,m2reg,jal,iord,selpc,
    input wreg,wpc,wir,
    input sext,

    input [1:0]pcsrc,alusrcb,
    input [3:0]aluc,

    input [31:0]memread,

    output eq,
    output [5:0]funct,op,
    output [31:0]qb,memaddr
);
    //取指阶段
    //pc赋值
    wire [31:0]npc,aluout,c,jpc,rpc,pc;
    wire [31:0]inst,data;
    mux4to1 npc_init(aluout,c,rpc,jpc,pcsrc,npc);
    pc pc_init(clk,clrn,wpc,npc,pc);
    assign jpc={pc[31:29],inst[25:0],2'b00};
    ir ir_init(clk,clrn,wir,memread,inst);
    reg_design dr_init(clk,1'b1,memread,data);
    
    //译码阶段
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
    mux2to1 generate_wregData_temp(c,data,m2reg,wregData_temp);
    wire [31:0]wregData;
    mux2to1 generate_wregData(wregData_temp,pc,jal,wregData);
    //寄存器模块
    wire [31:0]qa;
    regfile regfile_init(clk,wreg,clrn,rs,rt,wn,wregData,qa,qb);
    assign rpc=qa;
    assign eq=~|(qa^qb);

    //立即数扩展模块
    wire [15:0]imm=inst[15:0];
    wire [31:0]imm_sext={{16{sext&imm[15]}},imm};
    wire [31:0]imm_sext_left={imm_sext[29:0],2'b0};

    //ALU模块
    wire [31:0]a_temp,a,b;
    wire z,overflow;
    mux2to1 generate_aluaTemp(qa,{26'b0,imm[10:6]},shift,a_temp);
    mux2to1 generate_alua(a_temp,pc,selpc,a);
    mux4to1 generate_alub(qb,32'd4,imm_sext,imm_sext_left,alusrcb,b);
    alu alu_init(a,b,aluc,aluout,z,overflow);

    reg_design C(clk,1'b1,aluout,c);
    mux2to1 generate_memaddr(pc,c,iord,memaddr);
    
endmodule
