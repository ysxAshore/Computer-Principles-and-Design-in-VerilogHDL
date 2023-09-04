`timescale 1ns / 1ps

module mem(
    input clk,
    input[31:0]addr,idata,
    input we,
    output [31:0]odata
);
    reg [31:0]memory[63:0];
    initial begin
        memory[0] = 32'h3c010000;
        memory[1] = 32'h34240080;
        memory[2] = 32'h20050004;
        memory[3] = 32'h0c000018;
        memory[4] = 32'hac820000;
        memory[5] = 32'h8c890000;
        memory[6] = 32'h01244022;
        memory[7] = 32'h20050003;
        memory[8] = 32'h20a5ffff;
        memory[9] = 32'h34a8ffff;
        memory[10] = 32'h39085555;
        memory[11] = 32'h2009ffff;
        memory[12] = 32'h312affff;
        memory[13] = 32'h01493025;
        memory[14] = 32'h01494026;
        memory[15] = 32'h01463824;
        memory[16] = 32'h10a00001;
        memory[17] = 32'h08000008;
        memory[18] = 32'h2005ffff;
        memory[19] = 32'h000543c0;
        memory[20] = 32'h00084400;
        memory[21] = 32'h00084403;
        memory[22] = 32'h000843c2;
        memory[23] = 32'h08000017;
        memory[24] = 32'h00004020;
        memory[25] = 32'h8c890000;
        memory[26] = 32'h20840004;
        memory[27] = 32'h01094020;
        memory[28] = 32'h20a5ffff;
        memory[29] = 32'h14a0fffb;
        memory[30] = 32'h00081000;
        memory[31] = 32'h03e00008;
        memory[32] = 32'h000000a3;
        memory[33] = 32'h00000027;
        memory[34] = 32'h00000079;
        memory[35] = 32'h00000115;
        memory[36] = 32'h00000000;
    end
    assign odata=memory[addr[7:2]];
    always @(posedge clk) begin
        if (we) begin
            memory[addr[7:2]]<=idata;
        end
    end
endmodule
