`timescale 1ns / 1ps

module flopr(
    input clk,rst,
    input [31:0]d,
    output reg [31:0]q
);
    always @(posedge clk) begin
        if (rst) begin
            q<=0;
        end else begin
            q<=d;
        end
    end
endmodule

module flopenr(
    input clk,rst,enable,
    input [31:0]d,
    output reg [31:0]q
);
    always @(posedge clk) begin
        if (rst) begin
            q<=0;
        end else if (enable) begin
            q<=d;
        end
    end
endmodule

module floprc_sync(
    input clk,rst,clear,//clear高有效
    input [31:0]d,
    output reg [31:0]q
);
    always @(posedge clk) begin
        if (rst) begin
            q<=0;
        end else if (clear) begin
            q<=0;
        end else begin
            q<=d;
        end
    end
endmodule

module floprc_async(
    input clk,rst,clear,
    input [31:0]d,
    output reg [31:0]q
);
    always @(posedge clk or posedge clear) begin
        if (rst) begin
            q<=0;
        end else if (clear) begin
            q<=0;
        end else begin
            q<=d;
        end
    end

endmodule

module flopenrc_async(
    input clk,rst,enable,clear,
    input [31:0]d,
    output reg [31:0]q
);
    always @(posedge clk or posedge clear) begin
        if (rst) begin
            q<=0;
        end else if (clear) begin
            q<=0;
        end else if (enable) begin
            q<=d;
        end
    end

endmodule