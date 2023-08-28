`timescale 1ns / 1ps

module t_latch(
    input t,c,
    output q,qn
);
    wire s_temp=~(t^c^qn);
    wire t_temp=~(t^c^q);

    rs_latch  rs_latch_inst (
        .s(s_temp),
        .r(t_temp),
        .q(q),
        .qn(qn)
      );
endmodule
