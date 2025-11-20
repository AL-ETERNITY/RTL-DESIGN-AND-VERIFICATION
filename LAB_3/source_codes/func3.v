`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.09.2025 15:27:06
// Design Name: 
// Module Name: func3
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


module func3(
    input A,
    input B,
    input C,
    output F
);

    // Explicit minterms with dont_touch attributes
    (* dont_touch = "true" *) wire m0, m1, m2;
    (* dont_touch = "true" *) assign m0 = (~A) & (~B) & (~C); // minterm 1
    (* dont_touch = "true" *) assign m1 = A & (~B) & C;       // minterm 2
    (* dont_touch = "true" *) assign m2 = A & B & (~C);       // minterm 3

    // Combine minterms with dont_touch attribute
    (* dont_touch = "true" *) assign F = m0 | m1 | m2;

endmodule
