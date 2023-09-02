`timescale 1ns / 1ps

module data_ram #(parameter LENGTH = 32)(
    input clk,we,

    input [31:0]addr,wdata,
    output [31:0]readData
);
    reg [31:0]ram[LENGTH-1:0];
    assign readData = ram[addr[6:2]]; // use word address to read ram
    always @(posedge clk) begin
        if (we) begin
            ram[addr[6:2]]<=wdata;
        end
    end

    //RAM初始化
    integer i;
    initial begin // initialize memory
        for (i = 0; i < 32; i = i + 1)
            ram[i] = 0;
        // ram[word_addr] = data // (byte_addr) item in data array
        ram[5'h14] = 32'h000000a3; // (50) data[0] 0 + A3 = A3 80字节处
        ram[5'h15] = 32'h00000027; // (54) data[1] a3 + 27 = ca
        ram[5'h16] = 32'h00000079; // (58) data[2] ca + 79 = 143
        ram[5'h17] = 32'h00000115; // (5c) data[3] 143 + 115 = 258
        // ram[5’h18] should be 0x00000258, the sum stored by sw instruction
    end
endmodule
