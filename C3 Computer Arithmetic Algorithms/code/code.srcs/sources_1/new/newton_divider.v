`timescale 1ns / 1ps

module newton_divider(
    input clk,start,
    input [31:0]a,b,

    output reg busy,ready,
    output reg[31:0]q//q的位宽取决于a
);

    reg [33:0]reg_a,reg_x,reg_b;
    wire [65:0]mul_res=reg_a*reg_x;
    wire [65:0]temp=reg_b*reg_x;
    wire [33:0]two_minus_x=~temp[64:31]+1;
    wire [67:0]x_n=reg_x*two_minus_x;
    integer i;
    always @(posedge clk) begin
        if (start) begin
            reg_a<=a;
            reg_b<=b;
            reg_x<={2'b1,rom(b[30:27]),24'b0};//小数点后4位
            busy<=1;
            ready<=0;
            i<=0;
        end else begin
            reg_x=x_n[66:33];
            i=i+1;
            if (i>=2) begin
                q=mul_res[64:33]+|mul_res[32:30];
                busy=0;
                ready=1;
            end
        end
    end
    function [7:0] rom; // a rom table
        input [3:0] b;
        case (b)
            4'h0: rom = 8'hff; 4'h1: rom = 8'hdf;
            4'h2: rom = 8'hc3; 4'h3: rom = 8'haa;
            4'h4: rom = 8'h93; 4'h5: rom = 8'h7f;
            4'h6: rom = 8'h6d; 4'h7: rom = 8'h5c;
            4'h8: rom = 8'h4d; 4'h9: rom = 8'h3f;
            4'ha: rom = 8'h33; 4'hb: rom = 8'h27;
            4'hc: rom = 8'h1c; 4'hd: rom = 8'h12;
            4'he: rom = 8'h08; 4'hf: rom = 8'h00;
        endcase
    endfunction
endmodule
