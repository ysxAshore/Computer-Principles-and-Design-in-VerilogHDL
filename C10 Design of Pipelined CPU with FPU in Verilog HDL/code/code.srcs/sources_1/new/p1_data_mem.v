`timescale 1ns / 1ps

module p1_data_mem(
    input clk,we,
    input [31:0]addr,datain,
    output [31:0]dataout
);
    reg [31:0] ram [0:31]; // ram cells: 32 words * 32 bits
    assign dataout = ram[addr[6:2]]; // use 5-bit word address
    always @ (posedge clk) begin
        if (we) 
            ram[addr[6:2]] = datain; // write ram
    end
    integer i;
    initial begin // ram initialization
        for (i = 0; i < 32; i = i + 1)
            ram[i] = 0;
        // ram[word_addr] = data // (byte_addr) item in data array
        ram[5'h0]=32'hbf800000;
        ram[5'h1]=32'h40800000;
        ram[5'h2]=32'h40000000;
        ram[5'h3]=32'h41100000;

        ram[5'h14] = 32'h40c00000; 
        ram[5'h15] = 32'h41c00000; 
        ram[5'h16] = 32'h43c00000; 
        ram[5'h17] = 32'h47c00000; 
       
    end
endmodule
