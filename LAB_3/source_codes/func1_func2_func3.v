`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.09.2025 15:46:09
// Design Name: 
// Module Name: func1_func2_func3
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


module func1_func2_func3(
    input   a, b, c, d,
    output  F123
);
    // One wire per minterm. KEEP + DONT_TOUCH ask Vivado not to fold/factor them.
    (* KEEP = "TRUE", DONT_TOUCH = "yes" *) wire m0  = (a & b ); // 0-d
    (* KEEP = "TRUE", DONT_TOUCH = "yes" *) wire m1  = (~a & ~c & d);
    (* KEEP = "TRUE", DONT_TOUCH = "yes" *) wire m8  = (~b & ~d&~c ); // 8-d
    (* KEEP = "TRUE", DONT_TOUCH = "yes" *) wire m9  = (~b & c & ~d); // 8-d
    (* KEEP = "TRUE", DONT_TOUCH = "yes" *) wire m10  = (a & ~b & c);
    // Stage the OR into two levels and keep those nets too.
    
    

    (* KEEP = "TRUE", DONT_TOUCH = "yes" *) wire F_hold = m0|m1 | m8 | m9 | m10 ;
    assign F123 = F_hold;

endmodule
