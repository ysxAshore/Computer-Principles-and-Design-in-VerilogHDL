`timescale 1ns / 1ps

//cmos style
module mux2to1_cmos(
    input a0,a1,s,
    output y
);
    wire temp;
    cmos_inverter cmos_inverter_init(s,temp);
    cmoscmos c0(a0,s,temp,y);
    cmoscmos c1(a1,temp,s,y);
endmodule
module cmoscmos(
    input source,p_gate,n_gate,
    output drain
);
    pmos p1(drain,source,p_gate);
    nmos n1(drain,source,n_gate);
endmodule

//logic gates style
module mux2to1_bybufif(
    input a0,a1,s,
    output y
);
    //bufif0 0使能的三态门 (drain,source,gate)
    //bufif1 1使能的三态门 (drain,source,gate)
    bufif0 bufif0_init(y,a0,s);
    bufif1 bufif1_init(y,a1,s);
endmodule

module mux2to1_bylogic(
    input a0,a1,s,
    output y
);
    wire temp,a0_sn,a1_s;
    not not_init(temp,s);
    and and0(a0_sn,a0,temp);
    and and1(a1_s,a1,s);
    or or_init(y,a0_sn,a1_s);
endmodule

//dataflow style 常用
module mux2to1_dataflow(
    input a0,a1,s,
    output y
);
    assign y=s?a1:a0;//y=~s&a0+s&a1;
endmodule

//behavioral style 常用
module mux2to1_byBehavioral(
    input a0,a1,s,
    output reg y
);  
//块内使用高级语言的形式，always块或者function块
always @(*) begin
    y=a0;
    if (s) begin
        y=a1;
    end
end

// function sel(input a0,input a1,input s);
//     begin
//         case(s)
//             1'b0:sel=a0;
//             1'b1:sel=a1;
//         endcase
//     end
// endfunction
endmodule