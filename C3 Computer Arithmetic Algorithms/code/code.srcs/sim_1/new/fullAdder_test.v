`timescale 1ns / 1ps

module fullAdder_test();

    reg a,b,ci;
    wire co1,s1,co2,s2,co3,s3;

    reg [2:0]temp;
    initial begin
        temp=3'b0;
        repeat (8) begin
            {a,b,ci}=temp;
            #5;
            temp=temp+1;
        end 
        $finish;
    end
    fullAdder_designBylogic  fullAdder_designBylogic_inst (
        .a(a),
        .b(b),
        .ci(ci),
        .co(co1),
        .s(s1)
    );
    fullAdder_designBydata  fullAdder_designBydata_inst (
        .a(a),
        .b(b),
        .ci(ci),
        .co(co2),
        .s(s2)
    );
    fullAdder_designBybehav  fullAdder_designBybehav_inst (
        .a(a),
        .b(b),
        .ci(ci),
        .co(co3),
        .s(s3)
    );
endmodule
