`timescale 1ns / 1ps

module behavioral_mux2to1(
    input s,a0,a1,
    output reg y
);
    always @(*) begin
        if (s) begin
            y=a1;
        end
        else begin
            y=a0;
        end
    end
    
    // function sel(input s,input a0,input a1);
    //     begin
    //         if (s) begin
    //             sel=a1;
    //         end
    //         else begin
    //             sel=a0;
    //         end
    //     end
    // endfunction
    // assign y=sel(s,a0,a1);

endmodule
