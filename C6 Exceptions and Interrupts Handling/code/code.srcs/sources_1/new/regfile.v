`timescale 1ns / 1ps

module regfile(
    input clk,we,clrn,

    input [4:0]rna,rnb,wn,
    input [31:0]wd,

    output [31:0]qa,qb
);
    reg [31:0]regs[31:0];
    always @(posedge clk or negedge clrn) begin
        if (clrn) begin:reg_clear
            integer i;
            for ( i= 0; i<32; i=i+1) begin
                regs[i]=32'b0;
            end
        end else if (we&&we!=0) begin
            regs[wn]<=wd;
        end
    end
    assign qa=(rna==5'b0)?0:regs[rna];
    assign qb=(rnb==5'b0)?0:regs[rnb];
endmodule
