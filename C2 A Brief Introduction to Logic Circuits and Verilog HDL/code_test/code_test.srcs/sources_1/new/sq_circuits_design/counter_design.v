`timescale 1ns / 1ps

module counter_designByState(
    input clk,
    input rst,
    input u,

    output reg[2:0]num,
    output reg[6:0]seg
);

    reg [2:0]cur_state,next_state;
    //第一段 时序逻辑传状态
    always @(posedge clk) begin
        if (rst) begin//同步复位
            cur_state<=0;
        end else begin
            cur_state<=next_state;
        end
    end
    //第二段 组合逻辑决定下一个状态
    always @(*) begin
        next_state[0]=~cur_state[0];
        next_state[1]=~cur_state[2]&~cur_state[1]&cur_state[0]&u|cur_state[1]&~cur_state[0]&u|cur_state[1]&cur_state[0]&~u|cur_state[2]&~cur_state[0]&~u;
        next_state[2]=~cur_state[2]&~cur_state[1]&~cur_state[0]&~u|cur_state[1]&cur_state[0]&u|cur_state[2]&~cur_state[0]&u|cur_state[2]&cur_state[0]&~u;
    end
    //第三段 时序逻辑决定输出
    always @(posedge clk) begin
        if (rst) begin
            num=0;
        end else begin
            num=cur_state;
        end
        //case与if同级，如果设置if是非阻塞赋值，那么case就会用num的旧值
        case (num)//共阳极数码管
            3'b000:seg<=7'b0000001;
            3'b001:seg<=7'b1001111;
            3'b010:seg<=7'b0010010;
            3'b011:seg<=7'b0000110;
            3'b100:seg<=7'b1001100;
            3'b101:seg<=7'b0100100;
        endcase
    end
endmodule

module counter_designByBehaioral(
    input clk,
    input rst,
    input u,
    
    output [2:0]num,
    output reg [6:0]seg
);
    reg [2:0]temp;
    assign num=temp;

    always @(posedge clk) begin
        if (rst) begin
            temp=0;
        end else begin
            if(u) begin
                temp=temp+1;
                if (temp==3'b110) begin
                    temp=3'b000;
                end
            end else begin
                temp=temp-1;
                if (temp==3'b111) begin
                    temp=3'b101;
                end
            end
        end
        //case与if同级，如果设置if是非阻塞赋值，那么case就会用temp的旧值
        case (temp)//共阳极数码管
            3'b000:seg<=7'b0000001;
            3'b001:seg<=7'b1001111;
            3'b010:seg<=7'b0010010;
            3'b011:seg<=7'b0000110;
            3'b100:seg<=7'b1001100;
            3'b101:seg<=7'b0100100;
        endcase
    end
endmodule
