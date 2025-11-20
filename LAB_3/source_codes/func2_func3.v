`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.09.2025 15:44:10
// Design Name: 
// Module Name: func2_func3
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


module func2_func3(
    input   a, b, c, d,
    output  F23
);
    // One wire per minterm. KEEP + DONT_TOUCH ask Vivado not to fold/factor them.
    (* KEEP = "TRUE", DONT_TOUCH = "yes" *) wire m0  = (a & b ); // 0-d
    (* KEEP = "TRUE", DONT_TOUCH = "yes" *) wire m1  = (a & c );
    (* KEEP = "TRUE", DONT_TOUCH = "yes" *) wire m8  = (~b & ~d ); // 8-d
    (* KEEP = "TRUE", DONT_TOUCH = "yes" *) wire m9  = (~a & ~c & d); // 8-d
    
    // Stage the OR into two levels and keep those nets too.
    
    

    (* KEEP = "TRUE", DONT_TOUCH = "yes" *) wire F_hold = m0|m1 | m8 | m9  ;
    assign F23 = F_hold;
endmodule
