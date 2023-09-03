`timescale 1ns / 1ps

module inst_rom #(parameter LENGTH = 64)(
    input [31:0]pc,
    output [31:0]inst
);
    wire [31:0]rom[LENGTH-1:0];
    assign rom[6'h00] = 32'h0800001d;
    assign rom[6'h01] = 32'h00000000;
    assign rom[6'h02] = 32'h401a6000;
    assign rom[6'h03] = 32'h335b000c;
    assign rom[6'h04] = 32'h8f7b0020;
    assign rom[6'h05] = 32'h00000000;
    assign rom[6'h06] = 32'h03600008;
    assign rom[6'h07] = 32'h00000000;
    assign rom[6'h0c] = 32'h00000000;
    assign rom[6'h0d] = 32'h42000018;
    assign rom[6'h0e] = 32'h00000000;
    assign rom[6'h0f] = 32'h00000000;
    assign rom[6'h10] = 32'h401a7000;
    assign rom[6'h11] = 32'h235a0004;
    assign rom[6'h12] = 32'h409a7000;
    assign rom[6'h13] = 32'h42000018;
    assign rom[6'h14] = 32'h00000000;
    assign rom[6'h15] = 32'h00000000;
    assign rom[6'h16] = 32'h08000010;
    assign rom[6'h17] = 32'h00000000;
    assign rom[6'h1a] = 32'h00000000;
    assign rom[6'h1b] = 32'h08000010;
    assign rom[6'h1c] = 32'h00000000;
    assign rom[6'h1d] = 32'h2008000f;
    assign rom[6'h1e] = 32'h40886800;//pdf指令错误
    assign rom[6'h1f] = 32'h8c080048;
    assign rom[6'h20] = 32'h8c09004c;
    assign rom[6'h21] = 32'h01094020;
    assign rom[6'h22] = 32'h00000000;
    assign rom[6'h23] = 32'h0000000c;
    assign rom[6'h24] = 32'h00000000;
    assign rom[6'h25] = 32'h0128001a;
    assign rom[6'h26] = 32'h00000000;
    assign rom[6'h27] = 32'h34040050;
    assign rom[6'h28] = 32'h20050004;
    assign rom[6'h29] = 32'h00004020;
    assign rom[6'h2a] = 32'h8c890000;
    assign rom[6'h2b] = 32'h20840004;
    assign rom[6'h2c] = 32'h01094020;
    assign rom[6'h2d] = 32'h20a5ffff;
    assign rom[6'h2e] = 32'h14a0fffb;
    assign rom[6'h2f] = 32'h00000000;
    assign rom[6'h30] = 32'h08000030;
    assign inst = rom[pc[7:2]]; // use word address to read rom,pc每次+4
endmodule