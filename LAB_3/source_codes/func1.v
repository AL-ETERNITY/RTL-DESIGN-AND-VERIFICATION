`timescale 1ns / 1ps

module func1(
    input   a, b, c, d,
    output  F1
);
    // One wire per minterm. KEEP + DONT_TOUCH ask Vivado not to fold/factor them.
    (* KEEP = "TRUE", DONT_TOUCH = "yes" *) wire m0  = (~a & ~c & d); // 0-d
    (* KEEP = "TRUE", DONT_TOUCH = "yes" *) wire m4  = (~a &  ~b &  c & ~d); // 4-d
    (* KEEP = "TRUE", DONT_TOUCH = "yes" *) wire m8  = (a & ~b &  c & d); // 8-d
    (* KEEP = "TRUE", DONT_TOUCH = "yes" *) wire m9  = (a & ~c & ~d); // 8-d
    (* KEEP = "TRUE", DONT_TOUCH = "yes" *) wire m10  = (b &  ~c & d); // 8-d
    // Stage the OR into two levels and keep those nets too.
    
    

    (* KEEP = "TRUE", DONT_TOUCH = "yes" *) wire F_hold = m0 | m4 | m8 | m9| m10  ;
    assign F1 = F_hold;
endmodule