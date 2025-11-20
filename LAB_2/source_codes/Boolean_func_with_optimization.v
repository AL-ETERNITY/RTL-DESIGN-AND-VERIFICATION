`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.09.2025 15:45:08
// Design Name: 
// Module Name: Boolean_func_with_optimization
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Optimized Boolean Function Implementation
// Function: (x̄5x̄1x̄0) ∨ (x3x̄2x̄0) ∨ (x5x̄4x3x̄0)
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Boolean_func_with_optimization(
    input x5,     // MSB (equivalent to A in previous module)
    input x4,     // (equivalent to B in previous module)
    input x3,     // (equivalent to C in previous module)  
    input x2,     // (equivalent to D in previous module)
    input x1,     // (equivalent to E in previous module)
    input x0,     // LSB (equivalent to F in previous module)
    output Y      // Output function
    );
    
    // Optimized Boolean Function Implementation with anti-optimization attributes
    // Function: (x̄5x̄1x̄0) ∨ (x3x̄2x̄0) ∨ (x5x̄4x3x̄0)
    // This is the simplified/optimized form of the original 16 min terms
    
    (* DONT_TOUCH = "TRUE" *) wire term1, term2, term3;
    (* DONT_TOUCH = "TRUE" *) wire Y_internal;
    
    // Individual product terms with DONT_TOUCH attributes
    (* DONT_TOUCH = "TRUE" *) assign term1 = (~x5 & ~x1 & ~x0);    // x̄5x̄1x̄0
    (* DONT_TOUCH = "TRUE" *) assign term2 = (x3 & ~x2 & ~x0);     // x3x̄2x̄0  
    (* DONT_TOUCH = "TRUE" *) assign term3 = (x5 & ~x4 & x3 & ~x0); // x5x̄4x3x̄0
    
    // Final OR of all terms
    (* DONT_TOUCH = "TRUE" *) assign Y_internal = term1 | term2 | term3;
    
    (* DONT_TOUCH = "TRUE" *) assign Y = Y_internal;
    
endmodule
