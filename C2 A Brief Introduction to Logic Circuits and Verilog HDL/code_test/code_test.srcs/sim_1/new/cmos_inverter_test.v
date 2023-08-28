`timescale 1ns / 1ps

module cmos_inverter_test();
    reg a;
    wire f;
    initial begin
        a=0;
    end
    always #5 a=~a;

    cmos_inverter  cmos_inverter_inst (
        .a(a),
        .f(f)
    );

    always @(*) begin
        if ($time>=1000) begin
            $finish;
        end
    end
endmodule
