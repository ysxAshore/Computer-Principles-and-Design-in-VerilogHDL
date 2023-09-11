`timescale 1ns/1ps

module cu(
    input clk,clrn,
    input [5:0]funct,op,
    input [4:0]rs,rt,ewn,mwn,
    input z,

    //IF
    output  wpcir,
    output [1:0]pcsrc,

    //ID
    output sext,regdst,
    output [1:0]forwardAD,forwardBD,

    //EX
    output ejal,eshift,ealusrc,
    output [3:0]ealuc,

    //MEM
    output mwmem,

    //WB
    output wwreg,wm2reg,

    //浮点相关
    input [4:0]fs,ft,
    output [2:0]fc,
    output wwfpr,wf,fwdf,efwdfe,swfp,
    output wfdla,wfdlb,wfdfa,wfdfb,
    input [4:0]w1n,w2n,w3n,
    input w1e,w2e,w3e,stall_div_sqrt
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

    //浮点指令译码
    wire i_lwc1=op[5]&op[4]&~op[3]&~op[2]&~op[1]&op[0];
    wire i_swc1=op[5]&op[4]&op[3]&~op[2]&~op[1]&op[0];
    wire is_ifal=~op[5]&op[4]&~op[3]&~op[2]&~op[1]&op[0]&rs[4]&~rs[3]&~rs[2]&~rs[1]&~rs[0];
    wire i_adds=is_ifal&~funct[5]&~funct[4]&~funct[3]&~funct[2]&~funct[1]&~funct[0];
    wire i_subs=is_ifal&~funct[5]&~funct[4]&~funct[3]&~funct[2]&~funct[1]&funct[0];
    wire i_muls=is_ifal&~funct[5]&~funct[4]&~funct[3]&~funct[2]&funct[1]&~funct[0];
    wire i_divs=is_ifal&~funct[5]&~funct[4]&~funct[3]&~funct[2]&funct[1]&funct[0];
    wire i_sqrts=is_ifal&~funct[5]&~funct[4]&~funct[3]&funct[2]&~funct[1]&~funct[0];


    wire stall;
    assign regdst=i_addi|i_andi|i_ori|i_xori|i_lw|i_lui|i_lwc1;
    assign sext=i_addi|i_lw|i_sw|i_beq|i_bne;
    assign pcsrc[1]=i_j|i_jal|i_jr;
    assign pcsrc[0]=i_beq&z|i_bne&~z|i_j|i_jal;

    wire jal=i_jal;
    wire m2reg=i_lw;
    wire shift=i_sll|i_srl|i_sra;
    wire alusrc=i_addi|i_andi|i_ori|i_xori|i_lw|i_sw|i_lui|i_lwc1|i_swc1;
    wire [3:0]aluc;
    assign aluc[3]=i_sra;
    assign aluc[2]=i_sub|i_or|i_srl|i_sra|i_ori|i_lui;
    assign aluc[1]=i_xor|i_sll|i_srl|i_sra|i_xori|i_beq|i_bne|i_lui;
    assign aluc[0]=i_and|i_or|i_sll|i_srl|i_sra|i_andi|i_ori;
    

    //ID/EX
    wire wfpr,wreg,wmem,ewreg,em2reg,ewmem,ewfpr,fwdfe;
    regDesign #(.WIDTH(12)) id_ex_cu(clk,1,0,{wreg,jal,m2reg,shift,alusrc,aluc,wmem,wfpr,fwdf},{ewreg,ejal,em2reg,eshift,ealusrc,ealuc,ewmem,ewfpr,fwdfe});
    //EX/MEM
    wire mwreg,mm2reg,mwfpr;
    regDesign #(.WIDTH(4)) ex_mem_cu(clk,1,0,{ewreg,em2reg,ewmem,ewfpr},{mwreg,mm2reg,mwmem,mwfpr});
    //MEM/WB
    regDesign #(.WIDTH(3)) mem_wb_cu(clk,1,0,{mwreg,mm2reg,mwfpr},{wwreg,wm2reg,wwfpr});

    wire i_rs=i_add|i_sub|i_and|i_or|i_xor|i_jr|i_addi|i_andi|i_ori|i_xori|i_beq|i_bne|i_lw|i_sw;
    wire i_rt=i_add|i_sub|i_and|i_or|i_xor|i_sll|i_srl|i_sra|i_sw|i_beq|i_bne;
    harzard hazard_init(i_rs,i_rt,ewreg,em2reg,mwreg,mm2reg,rs,rt,ewn,mwn,forwardAD,forwardBD,stall);

    //运算指令之间的延迟以及数据依赖
    wire is_ft=i_adds|i_subs|i_muls|i_divs;
    wire is_fs=i_adds|i_subs|i_muls|i_divs|i_sqrts;
    wire stall_fp=(w1e&(is_fs&(fs==w1n)|is_ft&(ft==w1n)))|
                  (w2e&(is_fs&(fs==w1n)|is_ft&(ft==w2n)));
    assign wfdfa=w3e&(fs==w3n);
    assign wfdfb=w3e&(ft==w3n);

    //lwc1与运算指令之间的延迟以及数据依赖
    wire stall_lwc1=ewfpr&(is_fs&(ewn==fs)|is_ft&(ewn==ft));
    assign wfdla=mwfpr&(mwn==fs);
    assign wfdlb=mwfpr&(mwn==rt);

    //swc1与运算指令之间的延迟以及数据依赖
    wire stall_swc1=i_swc1&w1e&(w1n==ft);
    assign fwdf=i_swc1&w3e&(w3n==ft);//由E3->ft
    assign fwdfe=i_swc1&w2e&(w2e==ft);//因此也需要一个E3阶段的数据输入到datapath

    wire stall_others=stall_fp|stall_lwc1|stall_swc1;
    assign wpcir=~stall&~stall_others&~stall_div_sqrt;
    assign wreg=(i_add|i_sub|i_and|i_or|i_xor|i_sll|i_srl|i_sra|i_addi|i_andi|i_ori|i_xori|i_lw|i_lui|i_jal)&wpcir;
    assign wmem=(i_sw|i_swc1)&wpcir;

    //浮点控制信号译码
    assign wfpr=i_lwc1&wpcir;
    assign wf=is_fs&wpcir;
    assign fc[2]=i_divs&i_sqrts;
    assign fc[1]=i_muls&i_sqrts;
    assign fc[0]=i_subs;
    assign swfp=i_swc1;
endmodule
