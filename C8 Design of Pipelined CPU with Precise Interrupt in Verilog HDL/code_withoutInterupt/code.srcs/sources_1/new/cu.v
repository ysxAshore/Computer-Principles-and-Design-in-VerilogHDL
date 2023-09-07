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

    
    wire stall;
    assign wpcir=~stall;
    assign regdst=i_addi|i_andi|i_ori|i_xori|i_lw|i_lui;
    assign sext=i_addi|i_lw|i_sw|i_beq|i_bne;
    assign pcsrc[1]=i_j|i_jal|i_jr;
    assign pcsrc[0]=i_beq&z|i_bne&~z|i_j|i_jal;

    wire wreg=(i_add|i_sub|i_and|i_or|i_xor|i_sll|i_srl|i_sra|i_addi|i_andi|i_ori|i_xori|i_lw|i_lui|i_jal)&~stall;
    wire jal=i_jal;
    wire m2reg=i_lw;
    wire shift=i_sll|i_srl|i_sra;
    wire alusrc=i_addi|i_andi|i_ori|i_xori|i_lw|i_sw+i_lui;
    wire [3:0]aluc;
    assign aluc[3]=i_sra;
    assign aluc[2]=i_sub|i_or|i_srl|i_sra|i_ori|i_lui;
    assign aluc[1]=i_xor|i_sll|i_srl|i_sra|i_xori|i_beq|i_bne|i_lui;
    assign aluc[0]=i_and|i_or|i_sll|i_srl|i_sra|i_andi|i_ori;
    wire wmem=i_sw&~stall;

    //ID/EX
    wire ewreg,em2reg,ewmem;
    regDesign #(.WIDTH(10)) id_ex_cu(clk,1,0,{wreg,jal,m2reg,shift,alusrc,aluc,wmem},{ewreg,ejal,em2reg,eshift,ealusrc,ealuc,ewmem});
    //EX/MEM
    wire mwreg,mm2reg;
    regDesign #(.WIDTH(3)) ex_mem_cu(clk,1,0,{ewreg,em2reg,ewmem},{mwreg,mm2reg,mwmem});
    //MEM/WB
    regDesign #(.WIDTH(2)) mem_wb_cu(clk,1,0,{mwreg,mm2reg},{wwreg,wm2reg});

    wire i_rs=i_add|i_sub|i_and|i_or|i_xor|i_jr|i_addi|i_andi|i_ori|i_xori|i_beq|i_bne|i_lw|i_sw;
    wire i_rt=i_add|i_sub|i_and|i_or|i_xor|i_sll|i_srl|i_sra|i_sw|i_beq|i_bne;
    harzard hazard_init(i_rs,i_rt,ewreg,em2reg,mwreg,mm2reg,rs,rt,ewn,mwn,forwardAD,forwardBD,stall);
endmodule
