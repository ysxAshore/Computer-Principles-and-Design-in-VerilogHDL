`timescale 1ns / 1ps

module cu(
    input [31:0]status_word,
    input [5:0]funct,op,
    input [4:0]decode_cp0,rd,
    input eq,intr,overflow,

    //第一类：选择器信号
    output regdst,alusrc,shift,m2reg,jal,exc,inta,mtc0_sel,
    output [1:0]pcsrc,pcsel,
    //第二类：存储器寄存器写使能
    output wmem,wreg,wcau,wsta,wepc,
    output [1:0]mfc0_sel,
    //第三类：alu
    output [3:0]aluc,
    //第四类
    output sext,
    output [31:0]cause_word
);
    wire rtype=~op[5]&~op[4]&~op[3]&~op[2]&~op[1]&~op[0];//op 000000
    wire i_add=rtype&funct[5]&~funct[4]&~funct[3]&~funct[2]&~funct[1]&~funct[0];//op 0 funct 100000
    wire i_sub=rtype&funct[5]&~funct[4]&~funct[3]&~funct[2]&funct[1]&~funct[0];//op 0 funct 100010
    wire i_and=rtype&funct[5]&~funct[4]&~funct[3]&funct[2]&~funct[1]&~funct[0];//op 0 funct 100100
    wire i_or=rtype&funct[5]&~funct[4]&~funct[3]&funct[2]&~funct[1]&funct[0];//op 0 funct 100101
    wire i_xor=rtype&funct[5]&~funct[4]&~funct[3]&funct[2]&funct[1]&~funct[0];//op 0 funct 100110
    wire i_sll=rtype&~funct[5]&~funct[4]&~funct[3]&~funct[2]&~funct[1]&~funct[0];//op 0 funct 000000
    wire i_srl=rtype&~funct[5]&~funct[4]&~funct[3]&~funct[2]&funct[1]&~funct[0];//op 0  funct 000010
    wire i_sra=rtype&~funct[5]&~funct[4]&~funct[3]&~funct[2]&funct[1]&funct[0];//op 0 funct 000011
    wire i_jr=rtype&~funct[5]&~funct[4]&funct[3]&~funct[2]&~funct[1]&~funct[0];//op 0 funct 001000
    wire i_addi=~op[5]&~op[4]&op[3]&~op[2]&~op[1]&~op[0];//op 001000
    wire i_andi=~op[5]&~op[4]&op[3]&op[2]&~op[1]&~op[0];//op 001100
    wire i_ori=~op[5]&~op[4]&op[3]&op[2]&~op[1]&op[0];//op 001101
    wire i_xori=~op[5]&~op[4]&op[3]&op[2]&op[1]&~op[0];//op 001110
    wire i_lw=op[5]&~op[4]&~op[3]&~op[2]&op[1]&op[0];//op 100011
    wire i_sw=op[5]&~op[4]&op[3]&~op[2]&op[1]&op[0];////op 101011
    wire i_beq=~op[5]&~op[4]&~op[3]&op[2]&~op[1]&~op[0];//op 000100
    wire i_bne=~op[5]&~op[4]&~op[3]&op[2]&~op[1]&op[0];//op 000101
    wire i_lui=~op[5]&~op[4]&op[3]&op[2]&op[1]&op[0];//op 001111
    wire i_j=~op[5]&~op[4]&~op[3]&~op[2]&op[1]&~op[0];//op 000010
    wire i_jal=~op[5]&~op[4]&~op[3]&~op[2]&op[1]&op[0];//op 000011

    //1.译码新增的四条指令，需要多输入一个25:21端数据decode_cp0
    wire cpo_inst=~op[5]&op[4]&~op[3]&~op[2]&~op[1]&~op[0];//op 010000
    wire i_mfc0=cpo_inst&~decode_cp0[4]&~decode_cp0[3]&~decode_cp0[2]&~decode_cp0[1]&~decode_cp0[0];//op 010000 decode_cp0 00000
    wire i_mtc0=cpo_inst&~decode_cp0[4]&~decode_cp0[3]&decode_cp0[2]&~decode_cp0[1]&~decode_cp0[0];//op 010000 decode_cp0 00100
    wire i_eret=cpo_inst&decode_cp0[4]&~decode_cp0[3]&~decode_cp0[2]&~decode_cp0[1]&~decode_cp0[0]&~funct[5]&funct[4]&funct[3]&~funct[2]&~funct[1]&~funct[0];//op 010000 decode_cp0 10000 funct 011000
    wire i_syscall=rtype&~funct[5]&~funct[4]&funct[3]&funct[2]&~funct[1]&~funct[0];//op 000000 funct 001100
   
    //2.判断mfc0/mtc0是对CP0哪个寄存器操作,需要多一个rd输入
    wire is_cau=(rd==5'd12);
    wire is_sta=(rd==5'd13);
    wire is_epc=(rd==5'd14);

    //3.判断是否有中断异常请求发生,需要多一个intr外部的中断请求,overflow溢出的输入
    wire intr_req=intr;
    wire overflow_req=overflow&(i_add|i_sub|i_addi);
    wire syscall_req=i_syscall;
    wire unimplement_inst_req=~(i_add|i_sub|i_and|i_or|i_xor|i_sll|i_srl|i_sra|i_jr|i_addi|i_andi|i_ori|
                            i_xori|i_lw|i_sw|i_beq|i_bne|i_lui|i_j|i_jal|i_mfc0|i_mtc0|i_eret|i_syscall);
    
    //4.判断中断/异常请求能否被响应，需要利用sta判断，因此需要多一个sta的输入
    wire int_intr=intr_req&status_word[0];//00
    wire exc_syscall=syscall_req&status_word[1];//01
    wire exc_unimplement_inst=unimplement_inst_req&status_word[2];//10
    wire exc_overflow=overflow_req&status_word[3];//11

    //5.产生中断响应信号inta,inta需要输出
    assign inta=int_intr;

    //6.中断/异常响应
    //6.1 写Cause寄存器，因此需要产生exccode，并组合成Cause字，输出
    assign cause_word={28'b0,exc_unimplement_inst|exc_overflow,exc_syscall|exc_overflow,2'b0};
    //6.2 产生写sta、epc数据的一级选择信号 exc、inta，需要输出
    assign exc=int_intr|exc_syscall|exc_unimplement_inst|exc_overflow;//表示有中断/异常响应
    //6.3 产生cause写数据的选择信号和sta、epc写数据的二级选择信号,以及寄存器的写信号
    assign mtc0_sel=i_mtc0;
    assign wcau=exc|i_mtc0&is_cau;
    assign wsta=exc|i_mtc0&is_sta|i_eret;
    assign wepc=exc|i_mtc0&is_epc;
    //6.4 产生NPC的选择信号 00 NPC 01 epc 10 BASE
    assign pcsel[0]=i_eret;
    assign pcsel[1]=exc;

    //7 产生写寄存器数据的二级选择信号
    assign mfc0_sel[0]=i_mfc0&(is_sta|is_epc);
    assign mfc0_sel[1]=i_mfc0&(is_cau|is_epc);

    assign wreg=i_add|i_sub|i_add|i_or|i_xor|i_sll|i_srl|i_sra|i_addi|i_andi|i_ori|i_xori|i_lw|i_lui|i_jal|i_mfc0;
    assign regdst=i_addi|i_andi|i_ori|i_xori|i_lw|i_lui|i_mfc0;
    assign jal=i_jal;
    assign m2reg=i_lw;
    assign shift=i_sll|i_srl|i_sra;
    assign alusrc=i_addi|i_andi|i_ori|i_xori|i_lw|i_sw+i_lui;
    assign sext=i_addi|i_lw|i_sw|i_beq|i_bne;
    assign aluc[3]=i_sra;
    assign aluc[2]=i_sub|i_or|i_srl|i_sra|i_ori|i_lui;
    assign aluc[1]=i_xor|i_sll|i_srl|i_sra|i_xori|i_beq|i_bne|i_lui;
    assign aluc[0]=i_and|i_or|i_sll|i_srl|i_sra|i_andi|i_ori;
    assign wmem=i_sw;
    assign pcsrc[1]=i_j|i_jal|i_jr;
    assign pcsrc[0]=i_beq&eq|i_bne&~eq|i_j|i_jal;
endmodule