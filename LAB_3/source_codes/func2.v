`timescale 1ns / 1ps

module func2(
    input   a, b, c, d,
    output  F2
);
    // One wire per minterm. KEEP + DONT_TOUCH ask Vivado not to fold/factor them.
    (* KEEP = "TRUE", DONT_TOUCH = "yes" *) wire m0  = (a & b & c); // 0-d
    (* KEEP = "TRUE", DONT_TOUCH = "yes" *) wire m4  = (b &  ~c  & d); // 4-d
    (* KEEP = "TRUE", DONT_TOUCH = "yes" *) wire m8  = (a & ~b &  ~c & ~d); // 8-d
    (* KEEP = "TRUE", DONT_TOUCH = "yes" *) wire m9  = (~a & ~b & c & ~d); // 8-d
    
    // Stage the OR into two levels and keep those nets too.
    
    

    (* KEEP = "TRUE", DONT_TOUCH = "yes" *) wire F_hold = m0 | m4 | m8 | m9  ;
    assign F2 = F_hold;
endmodule