`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2025 04:30:28
// Design Name: 
// Module Name: Comparator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 32-bit Comparator for comparing two 32-bit numbers
//              Supports both signed and unsigned comparisons
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// Provides all standard comparison operations: ==, !=, <, <=, >, >=
//////////////////////////////////////////////////////////////////////////////////

module Comparator(
    input [31:0] a,             // First 32-bit number
    input [31:0] b,             // Second 32-bit number
    input signed_mode,          // 0: Unsigned comparison, 1: Signed comparison
    
    // Comparison outputs
    output equal,               // a == b
    output not_equal,           // a != b
    output less_than,           // a < b
    output less_equal,          // a <= b
    output greater_than,        // a > b
    output greater_equal        // a >= b
);

    // Internal signals for signed comparison
    wire signed [31:0] a_signed = a;
    wire signed [31:0] b_signed = b;
    
    // Equality comparison (same for signed and unsigned)
    assign equal = (a == b);
    assign not_equal = (a != b);
    
    // Conditional comparison based on signed_mode
    assign less_than = signed_mode ? (a_signed < b_signed) : (a < b);
    assign less_equal = signed_mode ? (a_signed <= b_signed) : (a <= b);
    assign greater_than = signed_mode ? (a_signed > b_signed) : (a > b);
    assign greater_equal = signed_mode ? (a_signed >= b_signed) : (a >= b);

endmodule
