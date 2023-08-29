`timescale 1ns/1ps

module fifo_ram_design(
    input clk,//时序控制
    input clrn,//清0 高有效

    input read,
    input write,

    input [31:0]d_in,
    output reg[31:0]d_out,

    output empty,
    output full
);
    reg [31:0]ram[7:0];
    reg [3:0]read_i,write_i;//多设置一个扩展位用于区分 空满时read_i=write_i的情况

    always @(posedge clk or posedge clrn) begin
        if (clrn) begin
            read_i<=4'b0;
            write_i<=4'b0;
        end else begin
            if (write) begin
                if (~full) begin
                    ram[write_i]<=d_in;
                    write_i<=write_i+1;
                end else begin
                    $display("FIFO buffer is full,don't allow write");
                end 
            end else if (read) begin
                if (~empty) begin
                    d_out<=ram[read_i];
                    read_i<=read_i+1;
                end else begin
                    $display("FIFO buffer is empty,don't allow read");
                end
            end 
        end
    end

    assign empty=(read_i==write_i)?1:0;
    assign full=((write_i[3]^read_i[3])&(write_i[2:0]==read_i[2:0]))?1:0;
endmodule