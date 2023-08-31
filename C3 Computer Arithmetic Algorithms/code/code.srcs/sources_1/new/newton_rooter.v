`timescale 1ns / 1ps

module newton_rooter(
    input clk,load,
    input [31:0]d,

    output reg busy,ready,
    output reg [31:0]q//xxxxxxxx
);
    reg [31:0] reg_d;//xxxxxxxx
    reg [33:0] reg_x;//xx.xxxxxxxx
    integer i;
    // x_{i+1} = x_i * (3 - x_i * x_i * d) / 2
    wire [67:0] x_2 = reg_x * reg_x; // xxxx.xxxxx...x 34+34
    wire [67:0] x2d = reg_d * x_2[67:32]; // xxxx.xxxxx...x 32 36
    wire [33:0] b34 = 34'h300000000 - x2d[65:32]; // xx.xxxxx...x
    wire [67:0] x68 = reg_x * b34; // xxxx.xxxxx...x 34+34
    wire [65:0] d_x = reg_d * reg_x; // xx.xxxxx...x 24+32
    wire [7:0] x0 = rom(d[31:27]);
    always @ (posedge clk) begin
        if (load) begin
            reg_d <= d; 
            reg_x <= {2'b1,x0,24'b0}; // 01.xxxx0...0
            busy <= 1;
            ready <= 0;
            i <= 0;q<=0;
        end else begin
            reg_x <= x68[65:32]; 
            i=i+1;
            if (i == 2'h2) begin 
                busy <= 0;
                ready <= 1; 
                q<=d_x[63:32] + |d_x[31:0];
            end
        end
    end
    function [7:0] rom; // about 1/d ̂ {1/2}
        input [4:0] d;
        case (d)
            5'h08: rom = 8'hff; 5'h09: rom = 8'he1;
            5'h0a: rom = 8'hc7; 5'h0b: rom = 8'hb1;
            5'h0c: rom = 8'h9e; 5'h0d: rom = 8'h9e;
            5'h0e: rom = 8'h7f; 5'h0f: rom = 8'h72;
            5'h10: rom = 8'h66; 5'h11: rom = 8'h5b;
            5'h12: rom = 8'h51; 5'h13: rom = 8'h48;
            5'h14: rom = 8'h3f; 5'h15: rom = 8'h37;
            5'h16: rom = 8'h30; 5'h17: rom = 8'h29;
            5'h18: rom = 8'h23; 5'h19: rom = 8'h1d;
            5'h1a: rom = 8'h17; 5'h1b: rom = 8'h12;
            5'h1c: rom = 8'h0d; 5'h1d: rom = 8'h08;
            5'h1e: rom = 8'h04; 5'h1f: rom = 8'h00;
            default: rom = 8'hff; 
        endcase
    endfunction
endmodule
