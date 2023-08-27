`timescale 1ns / 1ps

module cmos_not_test();
    reg a;
    wire f;
    initial begin
        a=0;
    end
    always #5 a=~a;

    cmos_not  cmos_not_inst (
        .a(a),
        .f(f)
    );

    always @(*) begin
        if ($time>=1000) begin
            $finish;
        end
    end
endmodule
