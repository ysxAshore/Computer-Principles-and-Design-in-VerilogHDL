`timescale 1ns / 1ps

module harzard(
    input is_rs,is_rt,
    input ewreg,em2reg,mwreg,mm2reg,
    input [4:0]rs,rt,ewn,mwn,

    output reg[1:0]forwardAD,forwardBD,
    output stall
);
    assign stall=ewreg&em2reg&(ewn!=5'b0)&(is_rs&(rs==ewn)|is_rt&(rt==ewn));
    always @(*) begin
        forwardAD=2'b00;
        if (ewreg&(ewn!=5'b0)&(ewn==rs)) begin
            forwardAD=2'b01;
        end else begin
            if (mwreg&~mm2reg&(mwn!=5'b0)&(mwn==rs)) begin
                forwardAD=2'b10;
            end else if (mwreg&mm2reg&(mwn!=5'b0)&(mwn==rs)) begin
                forwardAD=2'b11;
            end
        end
    end
    always @(*) begin
        forwardBD=2'b00;
        if (ewreg&(ewn!=5'b0)&(ewn==rt)) begin
            forwardBD=2'b01;
        end else begin
            if (mwreg&~mm2reg&(mwn!=5'b0)&(mwn==rt)) begin
                forwardBD=2'b10;
            end else if (mwreg&mm2reg&(mwn!=5'b0)&(mwn==rt)) begin
                forwardBD=2'b11;
            end
        end
    end
endmodule