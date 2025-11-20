`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2025 05:06:40
// Design Name: 
// Module Name: Subtractor
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Top-level 32-bit Subtractor Module
//              Integrates Parallel and Serial Subtractor implementations
//              Provides selection mechanism between different subtractor types
//              
//              Selection Values:
//              sel = 0: Parallel Subtractor (fast, combinational)
//              sel = 1: Serial Subtractor (area-efficient, sequential)
// 
// Dependencies: parallel_Subtractor.v, Serial_Subtractor.v
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// Unified interface for both subtractor implementations
// Sequential subtractor requires clock and provides done signal
//////////////////////////////////////////////////////////////////////////////////

module Subtractor(
    // Clock and reset (only used by serial subtractor)
    input clk,                  // Clock signal
    input reset,                // Reset signal (active high)
    
    // Control signals
    input sel,                  // Subtractor selection (0=Parallel, 1=Serial)
    input start,                // Start signal (used by serial subtractor)
    
    // Operand inputs
    input [31:0] a,             // First operand (minuend)
    input [31:0] b,             // Second operand (subtrahend)
    input bin,                  // Borrow input
    
    // Outputs
    output [31:0] diff,         // Difference output (A - B)
    output bout,                // Borrow output
    output done                 // Operation complete flag
);

    // Internal signals for parallel subtractor
    wire [31:0] parallel_diff;
    wire parallel_bout;
    
    // Internal signals for serial subtractor
    wire [31:0] serial_diff;
    wire serial_bout;
    wire serial_done;
    
    // Instantiate Parallel Subtractor (combinational)
    parallel_Subtractor ps (
        .a(a),
        .b(b),
        .bin(bin),
        .diff(parallel_diff),
        .bout(parallel_bout)
    );
    
    // Instantiate Serial Subtractor (sequential)
    Serial_Subtractor ss (
        .clk(clk),
        .reset(reset),
        .start(start),
        .a(a),
        .b(b),
        .bin(bin),
        .diff(serial_diff),
        .bout(serial_bout),
        .done(serial_done)
    );
    
    // Output selection based on sel signal
    assign diff = (sel == 1'b0) ? parallel_diff : serial_diff;
    assign bout = (sel == 1'b0) ? parallel_bout : serial_bout;
    
    // Done signal logic
    // For parallel subtractor: always done (combinational)
    // For serial subtractor: use actual done signal
    assign done = (sel == 1'b0) ? 1'b1 : serial_done;

endmodule
