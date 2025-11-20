`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.09.2025 15:38:18
// Design Name: 
// Module Name: func1func2
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module func1func2(
    input   a, b, c, d,
    output  F12
);
    // One wire per minterm. KEEP + DONT_TOUCH ask Vivado not to fold/factor them.
    (* KEEP = "TRUE", DONT_TOUCH = "yes" *) wire m0  = (~a & ~c & d); // 0-d
    (* KEEP = "TRUE", DONT_TOUCH = "yes" *) wire m1  = (a & ~c & ~d);
    (* KEEP = "TRUE", DONT_TOUCH = "yes" *) wire m8  = (b & ~c &  d ); // 8-d
    (* KEEP = "TRUE", DONT_TOUCH = "yes" *) wire m9  = (~a & ~b & c & ~d); // 8-d
    (* KEEP = "TRUE", DONT_TOUCH = "yes" *) wire m10  = (a  & c & d);
    (* KEEP = "TRUE", DONT_TOUCH = "yes" *) wire m11  = (a & b & c );
    // Stage the OR into two levels and keep those nets too.
    
    

    (* KEEP = "TRUE", DONT_TOUCH = "yes" *) wire F_hold = m0|m1 | m8 | m9  ;
    assign F12 = F_hold;

endmodule
