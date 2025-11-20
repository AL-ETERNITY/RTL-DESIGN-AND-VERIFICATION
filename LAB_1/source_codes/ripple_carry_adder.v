`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2025 01:47:32
// Design Name: 
// Module Name: ripple_carry_adder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 32-bit Ripple Carry Adder
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// Full Adder module
module full_adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (cin & (a ^ b));
endmodule

// 32-bit Ripple Carry Adder
module ripple_carry_adder(
    input [31:0] a,      // 32-bit input A
    input [31:0] b,      // 32-bit input B
    input cin,           // Carry input
    output [31:0] sum,   // 32-bit sum output
    output cout          // Carry output
);
    
    wire [30:0] carry;   // Internal carry signals (c1 to c31)
    
    // Generate 32 full adders using generate block
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : fa_gen
            if (i == 0) begin
                // First full adder connects to cin
                full_adder fa (.a(a[i]), .b(b[i]), .cin(cin), .sum(sum[i]), .cout(carry[i]));
            end else if (i == 31) begin
                // Last full adder connects to cout
                full_adder fa (.a(a[i]), .b(b[i]), .cin(carry[i-1]), .sum(sum[i]), .cout(cout));
            end else begin
                // Middle full adders connect carry[i-1] to carry[i]
                full_adder fa (.a(a[i]), .b(b[i]), .cin(carry[i-1]), .sum(sum[i]), .cout(carry[i]));
            end
        end
    endgenerate
    
endmodule
