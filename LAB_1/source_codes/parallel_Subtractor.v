`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2025 04:38:45
// Design Name: 
// Module Name: parallel_Subtractor
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 32-bit Parallel Subtractor using Two's Complement Method
//              Performs A - B by calculating A + (~B + 1)
//              Uses the same adder logic as ripple carry adder
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// Subtraction is implemented as: A - B = A + 2's complement of B
// 2's complement of B = ~B + 1
//////////////////////////////////////////////////////////////////////////////////

// Parallel Subtractor for 32-bit numbers
// Implements A - B using two's complement method: A - B = A + (~B) + 1
// Uses full adders for implementation (full_adder module defined in ripple_carry_adder.v)

module parallel_Subtractor(
    input [31:0] a,         // First operand (minuend)
    input [31:0] b,         // Second operand (subtrahend)
    input bin,              // Borrow input (typically 0 for A - B)
    output [31:0] diff,     // Difference output (A - B)
    output bout             // Borrow output
);

    // Two's complement subtraction: A - B = A + (~B + 1)
    // This is equivalent to A + ~B + 1, where the +1 comes from carry input
    
    wire [31:0] b_complement;   // One's complement of B
    wire carry_out;             // Carry out from addition
    
    // Generate one's complement of B
    assign b_complement = ~b;
    
    // Use a 32-bit adder to compute: A + ~B + ~bin
    // Note: we use ~bin because borrow input works opposite to carry
    wire [31:0] carry;          // Internal carry signals
    wire cin;                   // Carry input for LSB
    
    // For subtraction, cin = ~bin (typically ~bin = ~0 = 1 for A - B)
    assign cin = ~bin;
    
    // Generate 32 full adders for parallel addition
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : fa_gen
            if (i == 0) begin
                // First full adder
                full_adder fa (
                    .a(a[i]),
                    .b(b_complement[i]),
                    .cin(cin),
                    .sum(diff[i]),
                    .cout(carry[i])
                );
            end else if (i == 31) begin
                // Last full adder
                full_adder fa (
                    .a(a[i]),
                    .b(b_complement[i]),
                    .cin(carry[i-1]),
                    .sum(diff[i]),
                    .cout(carry_out)
                );
            end else begin
                // Middle full adders
                full_adder fa (
                    .a(a[i]),
                    .b(b_complement[i]),
                    .cin(carry[i-1]),
                    .sum(diff[i]),
                    .cout(carry[i])
                );
            end
        end
    endgenerate
    
    // Borrow output is complement of carry out
    // If carry_out = 1, then A >= B (no borrow needed)
    // If carry_out = 0, then A < B (borrow needed)
    assign bout = ~carry_out;

endmodule
