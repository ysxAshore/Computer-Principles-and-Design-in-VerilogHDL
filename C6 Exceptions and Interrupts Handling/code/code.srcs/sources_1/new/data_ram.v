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
        ram[5'h08] = 32'h00000030; //08是基址，0是int的处理程序
        ram[5'h09] = 32'h0000003c; //08+1是系统调用的处理程序
        ram[5'h0a] = 32'h00000054; //08+2是没有实现的指令的处理程序
        ram[5'h0b] = 32'h00000068; //08+3是溢出的处理程序
        ram[5'h12] = 32'h00000002; //12，13单元上的字是为了实现溢出测试 2+7fffffff
        ram[5'h13] = 32'h7fffffff; 
        ram[5'h14] = 32'h000000a3; //之前用到的计算
        ram[5'h15] = 32'h00000027;
        ram[5'h16] = 32'h00000079; 
        ram[5'h17] = 32'h00000115; 
    end
endmodule
