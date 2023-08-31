`timescale 1ns / 1ps

module alu_test();
    reg [31:0]a,b;//a端多路选择pc(pc的adder可以放在IF),sa,reg_a;b端多路选择reg_b,imm,4(pc_adder),imm<<2;
    reg [3:0]aluc;
    //x000 ADD,x100 SUB,x001 AND,x101 OR,x010 XOR,x110 LUI,0011 SLL,0111 SRL,1111 SRA 
    wire[31:0]res;
    wire z;

    initial begin
        //ADD
        aluc=4'b0000;a=32'd4;b=32'd7;
        #5;aluc=4'b0000;a=-32'd5;b=-32'd10;
        #5;aluc=4'b0000;a=-32'd5;b=32'd6;
        //sub
        #5;aluc=4'b0100;a=32'd5;b=32'd7;
        #5;aluc=4'b0100;a=-32'd5;b=-32'd10;
        #5;aluc=4'b0100;a=-32'd5;b=32'd6;
        //AND
        #5;aluc=4'b0001;a=32'd5;b=32'd7;
        //OR
        #5;aluc=4'b0101;a=32'd5;b=32'd7;
        //XOR
        #5;aluc=4'b0010;a=32'd5;b=32'd7;
        //LUI
  
        #5;aluc=4'b0110;a=32'd7;b=32'd25;
        //SLL
        #5;aluc=4'b0011;a=32'd3;b=32'd13;
        //SRL
        #5;aluc=4'b0111;a=32'd5;b=32'd37;
        //SRA
        #5;aluc=4'b1111;a=32'd5;b=32'd37;
        #5;aluc=4'b1111;a=32'd7;b=-32'd26;
        #5;$finish;

    end
    alu  alu_inst (
        .a(a),
        .b(b),
        .aluc(aluc),
        .res(res),
        .z(z)
    );
endmodule
