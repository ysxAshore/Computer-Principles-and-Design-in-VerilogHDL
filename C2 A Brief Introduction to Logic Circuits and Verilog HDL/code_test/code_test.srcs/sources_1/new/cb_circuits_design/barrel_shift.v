`timescale 1ns / 1ps

module barrel_shift_bydataflow(
    input [31:0]d,
    input [4:0]sa,
    input right,
    input arith,
    output [31:0]sh
);
    wire [15:0]sign={16{d[31]}};
    
    wire [31:0]right16=arith?{sign,d[31:16]}:{{16{1'b0}},d[31:16]};
    wire [31:0]left16={d[15:0],{16{1'b0}}};
    wire [31:0]res_16=sa[4]?(right?right16:left16):d;

    wire [31:0]right8=arith?{sign[7:0],res_16[31:8]}:{{8{1'b0}},res_16[31:8]};
    wire [31:0]left8={res_16[23:0],{8{1'b0}}};
    wire [31:0]res_8=sa[3]?(right?right8:left8):res_16;

    wire [31:0]right4=arith?{sign[3:0],res_8[31:4]}:{{4{1'b0}},res_8[31:4]};
    wire [31:0]left4={res_8[27:0],{4{1'b0}}};
    wire [31:0]res_4=sa[2]?(right?right4:left4):res_8;

    wire [31:0]right2=arith?{sign[1:0],res_8[31:2]}:{{2{1'b0}},res_8[31:2]};
    wire [31:0]left2={res_8[29:0],{2{1'b0}}};
    wire [31:0]res_2=sa[1]?(right?right2:left2):res_4;

    wire [31:0]right1=arith?{sign[0],res_8[31:1]}:{{1'b0},res_8[31:1]};
    wire [31:0]left1={res_2[30:0],{1'b0}};
    assign sh=sa[0]?(right?right1:left1):res_2;
endmodule

module barrel_shift_byBehavioral(
    input [31:0]d,
    input [4:0]sa,
    input right,
    input arith,
    output reg[31:0]sh
);
always @(*) begin
    sh=d<<sa;
    if (right) begin
        if (arith) begin
            sh=$signed(d)>>>sa;
        end else begin
            sh=d>>sa;
        end
    end
end  
endmodule