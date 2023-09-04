`timescale 1ns / 1ps

module cu(
    input clk,clrn,
    input [5:0]funct,op,
    input eq,

    //第一类：选择器信号
    output reg regdst,alusrc,shift,m2reg,jal,iord,selpc,
    output reg [1:0]pcsrc,alusrcb,
    //第二类：存储器寄存器写使能
    output reg wmem,wreg,wpc,wir,
    //第三类：alu
    output reg [3:0]aluc,
    //第四类
    output reg sext
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

    reg [2:0]cur_state,next_state;

    //时序逻辑传递状态
    always @(posedge clk or posedge clrn) begin
        if (clrn) begin
            cur_state<=3'b000;
        end else begin
            cur_state<=next_state;
        end
    end
    //组合逻辑确定状态
    always @(*) begin
        case(cur_state)
            3'b000:next_state=3'b001;
            3'b001:begin
                if (i_j|i_jal|i_jr) begin
                    next_state=3'b000;
                end else begin
                    next_state=3'b010;
                end
            end
            3'b010:begin
                if (i_beq|i_bne) begin
                    next_state=3'b000;
                end else if (i_lw|i_sw) begin
                    next_state=3'b011;
                end else begin
                    next_state=3'b100;
                end
            end
            3'b011:begin
                if (i_sw) begin
                    next_state=3'b000;
                end else begin
                    next_state=3'b100;
                end
            end
            3'b100:next_state=3'b000;
        endcase
    end
    //组合逻辑确定输出
    always @(*) begin
        wpc=0;pcsrc=2'b0;wir=0;iord=0;wmem=0;aluc=4'b0;
        selpc=0;shift=0;alusrcb=2'b0;sext=0;wreg=0;m2reg=0;regdst=0;jal=0;
        case (cur_state)
            3'b000:begin
                wpc=1;wir=1;
                selpc=1;alusrcb=2'b1;
            end
            3'b001:begin
                if (i_j) begin
                    wpc=1;pcsrc=2'b11;
                end else if (i_jal) begin
                    wpc=1;pcsrc=2'b11;wreg=1;jal=1;
                end else if (i_jr) begin
                    wpc=1;pcsrc=2'b10;
                end else begin
                    aluc=4'b0000;selpc=1;alusrcb=2'b11;sext=1;
                end
            end
            3'b010:begin
                aluc[3] = i_sra;
                aluc[2] = i_sub | i_or | i_srl | i_sra | i_ori | i_lui;
                aluc[1] = i_xor | i_sll | i_srl | i_sra | i_xori | i_beq | i_bne | i_lui;
                aluc[0] = i_and | i_or | i_sll | i_srl | i_sra | i_andi | i_ori;
                if (i_sll|i_srl|i_sra) begin
                    shift=1;
                end
                if (i_addi|i_andi|i_ori|i_xori|i_lw|i_sw|i_lui) begin
                    alusrcb=2'b10;
                end
                if (i_addi|i_lw|i_sw) begin
                    sext=1;
                end
                if (i_beq&eq|i_bne&~eq) begin
                    wpc=1;pcsrc=2'b1;
                end
            end
            3'b011:begin
                if (i_lw) begin
                    iord=1;
                end else if (i_sw) begin
                    wmem=1;
                    iord=1;
                end
            end
            3'b100:begin
                wreg=1;
                if (~rtype) begin
                    regdst=1;
                end
                if (i_lw) begin
                    m2reg=1;
                end
            end
        endcase
    end
endmodule
