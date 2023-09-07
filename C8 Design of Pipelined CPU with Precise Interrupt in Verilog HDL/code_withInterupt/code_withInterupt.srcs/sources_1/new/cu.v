`timescale 1ns/1ps

module cu(
    input clk,clrn,
    input [5:0]funct,op,
    input [4:0]rs,rt,ewn,mwn,rd,
    input z,overflow,irq,
    input [31:0]sta,


    //IF
    output  wpcir,
    output [1:0]pcsrc,selpc,

    //ID
    output sext,regdst,wcau,wsta,wepc,exc,mtc0,
    output [1:0]forwardAD,forwardBD,sepc,
    output [31:0]cause,
    output inta,

    //EX
    output ejal,eshift,ealusrc,
    output [3:0]ealuc,
    output [1:0]emfc0,

    //MEM
    output mwmem,

    //WB
    output wwreg,wm2reg

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
    
    //1.对eret,mfc0,mtc0,syscall译码
    wire cpo_inst=~op[5]&op[4]&~op[3]&~op[2]&~op[1]&~op[0];//op 010000
    wire i_mfc0=cpo_inst&~rs[4]&~rs[3]&~rs[2]&~rs[1]&~rs[0];//op 010000 rs 00000
    wire i_mtc0=cpo_inst&~rs[4]&~rs[3]&rs[2]&~rs[1]&~rs[0];//op 010000 rs 00100
    wire i_eret=cpo_inst&rs[4]&~rs[3]&~rs[2]&~rs[1]&~rs[0]&~funct[5]&funct[4]&funct[3]&~funct[2]&~funct[1]&~funct[0];//op 010000 rs 10000 funct 011000
    wire i_syscall=rtype&~funct[5]&~funct[4]&funct[3]&funct[2]&~funct[1]&~funct[0];//op 000000 funct 001100
    //2.检查是对哪个寄存器操作
    wire is_cau=(rd==5'd12);
    wire is_sta=(rd==5'd13);
    wire is_epc=(rd==5'd14);
    //3.判断是否有中断/异常发生
    wire intr_req=irq;
    wire ove=sta[1]&(i_add|i_sub|i_addi);//溢出的判断放在EX,这里只写出使能
    wire syscall_req=i_syscall;
    wire unimplement_inst_req=~(i_add|i_sub|i_and|i_or|i_xor|i_sll|i_srl|i_sra|i_jr|i_addi|i_andi|i_ori|
               i_xori|i_lw|i_sw|i_beq|i_bne|i_lui|i_j|i_jal|i_mfc0|i_mtc0|i_eret|i_syscall);
    
    //4.对ID阶段信号做处理,可以用cancel立即清除，可以用ecancel清除
    //普通中断是用ecancel清除下一条进入ID的
    //分支、跳转中断是用cancel立刻清除现在的，并用ecancel清除下一条
    //延迟槽是用ecancel清除下一条
    //系统调用异常、未实现的指令是用ecancel清除下一条
    //普通的算术溢出、延迟槽的算术溢出是用exc_ovr清除执行和ID的，mexc_ovr是清除下一个ID的
    wire cancel,ecancel,exc_ovr,mexc_ovr;
    wire stall;
    wire isbj=(i_beq|i_bne|i_j|i_jal|i_jr);
    wire eisbj,misbj;
    
    assign wpcir=~stall;
    assign regdst=i_addi|i_andi|i_ori|i_xori|i_lw|i_lui|i_mfc0;
    assign sext=i_addi|i_lw|i_sw|i_beq|i_bne;
    assign pcsrc[1]=i_j|i_jal|i_jr;
    assign pcsrc[0]=i_beq&z|i_bne&~z|i_j|i_jal;
    wire wreg=(i_add|i_sub|i_and|i_or|i_xor|i_sll|i_srl|i_sra|i_addi|i_andi|i_ori|i_xori|i_lw|i_lui|i_jal|i_mfc0)&~stall&~(isbj&inta&cancel)&~ecancel&~exc_ovr&~mexc_ovr;
    wire jal=i_jal;
    wire m2reg=i_lw;
    wire shift=i_sll|i_srl|i_sra;
    wire alusrc=i_addi|i_andi|i_ori|i_xori|i_lw|i_sw+i_lui;
    wire [3:0]aluc;
    assign aluc[3]=i_sra;
    assign aluc[2]=i_sub|i_or|i_srl|i_sra|i_ori|i_lui;
    assign aluc[1]=i_xor|i_sll|i_srl|i_sra|i_xori|i_beq|i_bne|i_lui;
    assign aluc[0]=i_and|i_or|i_sll|i_srl|i_sra|i_andi|i_ori;
    wire wmem=i_sw&~stall&~(isbj&inta&cancel)&~ecancel&~exc_ovr&~mexc_ovr;

    //5.ID阶段检查是否能够响应中断、以及除溢出外的异常
    wire exc_unimplement_inst=unimplement_inst_req&sta[2]&~exc_ovr&~stall;
    wire exc_syscall=syscall_req&~exc_unimplement_inst&~exc_ovr&sta[1]&~stall;
    assign inta=intr_req&sta[0]&~exc_ovr&~exc_unimplement_inst&~exc_syscall&~stall;//
    //6.1产生cause字
    assign cause={eisbj,27'b0,exc_unimplement_inst|exc_ovr,exc_syscall|exc_ovr,2'b0};
    //6.2产生selpc、exc、cancel
    assign exc=inta|exc_syscall|exc_unimplement_inst|exc_ovr;//表示有中断/异常响应
    assign cancel=exc|i_eret;//eret没有延迟槽，那么也需要取消下一条指令的执行
    // sel epc: id is_branch eis_branch mis_branch others
    // exc_int PCD (01) PC (00) PC (00) PC (00)
    // exc_sys x x PCD (01) PCD (01)
    // exc_uni x x PCD (01) PCD (01)
    // exc_ovr x x PCM (11) PCE (10)
    assign sepc[0]=exc_ovr&misbj|exc_unimplement_inst|exc_syscall|inta&isbj;
    assign sepc[1]=exc_ovr;
    //6.3产生写信号mfc0、mtc0
    wire mfc0[1:0];
    assign mfc0[0]=i_mfc0&(is_sta|is_epc);
    assign mfc0[1]=i_mfc0&(is_cau|is_epc);
    assign mtc0=i_mtc0;
    //6.4产生寄存器的写信号wcau、wsta、wepc
    assign wcau=exc|i_mtc0&is_cau;
    assign wsta=exc|i_mtc0&is_sta|i_eret;
    assign wepc=exc|i_mtc0&is_epc;
    //6.6产生pcsel 01 epc 10 base
    assign selpc[1]=exc;
    assign selpc[0]=i_eret;

    //ID/EXE信号传递
    wire ewregTemp,em2reg,ewmemTemp,eove;
    regDesign #(.WIDTH(15)) id_ex_cu(clk,1,clrn,{wreg,jal,m2reg,shift,alusrc,aluc,wmem,cancel,isbj,ove,mfc0[1],mfc0[0]},{ewregTemp,ejal,em2reg,eshift,ealusrc,ealuc,ewmemTemp,ecancel,eisbj,eove,emfc0});
    assign exc_ovr=eove&overflow;
    assign ewreg=~exc_ovr&ewregTemp;
    assign ewmem=~exc_ovr&ewmemTemp;

    //EX/MEM
    wire mwreg,mm2reg;
    regDesign #(.WIDTH(5)) ex_mem_cu(clk,1,clrn,{ewreg,em2reg,ewmem,eisbj,exc_ovr},{mwreg,mm2reg,mwmem,misbj,mexc_ovr});
    //MEM/WB
    regDesign #(.WIDTH(2)) mem_wb_cu(clk,1,clrn,{mwreg,mm2reg},{wwreg,wm2reg});

    wire i_rs=i_add|i_sub|i_and|i_or|i_xor|i_jr|i_addi|i_andi|i_ori|i_xori|i_beq|i_bne|i_lw|i_sw;
    wire i_rt=i_add|i_sub|i_and|i_or|i_xor|i_sll|i_srl|i_sra|i_sw|i_beq|i_bne;
    harzard hazard_init(i_rs,i_rt,ewreg,em2reg,mwreg,mm2reg,rs,rt,ewn,mwn,forwardAD,forwardBD,stall);
endmodule
