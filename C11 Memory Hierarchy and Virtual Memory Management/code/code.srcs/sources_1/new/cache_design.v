`timescale 1ns / 1ps

module cache_design(
    input clk,clrn,
    input [31:0]p_a,p_dout,m_dout,
    input p_rw,p_strobe,uncached,m_ready,
    output [31:0]m_a,p_din,m_din,
    output p_ready,m_rw,m_strobe
);
    reg valid_ram[63:0];
    reg [31:0]data_ram[63:0];
    reg [23:0]tag_ram[63:0];

    wire index=p_a[7:2];
    wire tag=p_a[31:8];

    wire c_write,cache_miss,cache_hit;
    wire [31:0]c_din,c_dout;
    always @(posedge clk or negedge clrn) begin
        if (clrn) begin:cache_desolve
            integer i;
            for (i = 0; i<64; i=i+1) begin
                valid_ram[i]<=0;
            end
        end else if(c_write) begin
            valid_ram[index]<=1'b1;
            tag_ram[index]<=tag;
            data_ram[index]<=c_din;
        end
    end
    assign cache_hit=p_strobe&valid_ram[index]&(tag==tag_ram[index]);
    assign cache_miss=~cache_hit;

    assign m_rw=p_rw;
    assign m_strobe=p_rw|cache_miss;
    assign p_ready=~p_rw&cache_hit|(p_rw|cache_miss)&m_ready;
    assign m_a=p_a;
    assign m_din=p_dout;
    assign p_din=cache_hit?c_dout:m_dout;
    assign c_write=~uncached&(p_rw|cache_miss&m_ready);
    assign c_din=p_rw?p_dout:m_dout;
    assign c_dout=data_ram[index];
endmodule
