`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2025 04:15:28
// Design Name: 
// Module Name: Multiplier
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Top Module for 32-bit Multipliers with Selection Mechanism
//              Supports: School Book Multiplier and Left Shifting Multiplier
// 
// Dependencies: school_book_multiplier.v, left_shifting_multiplier.v
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Multiplier(
    // Common inputs
    input clk,                      // Clock (required for left shifting multiplier)
    input reset,                    // Reset (required for left shifting multiplier)
    input [31:0] multiplicand,      // 32-bit input A
    input [31:0] multiplier,        // 32-bit input B
    
    // Selection and control
    input multiplier_select,        // Multiplier type selection
                                    // 0: School Book Multiplier (Combinational)
                                    // 1: Left Shifting Multiplier (Sequential)
    input start,                    // Start signal (used for left shifting multiplier)
    
    // Outputs
    output reg [63:0] product,      // 64-bit product result
    output reg done,                // Operation complete flag
    output reg active_multiplier    // Shows which multiplier is currently selected
);

    // Internal wires for each multiplier type
    wire [63:0] sbm_product;        // School book multiplier product
    wire [63:0] lsm_product;        // Left shifting multiplier product
    wire lsm_done;                  // Left shifting multiplier done signal
    
    // Instantiate School Book Multiplier (Combinational)
    school_book_multiplier sbm_inst (
        .multiplicand(multiplicand),
        .multiplier(multiplier),
        .product(sbm_product)
    );
    
    // Instantiate Left Shifting Multiplier (Sequential)
    left_shifting_multiplier lsm_inst (
        .clk(clk),
        .reset(reset),
        .start(start && multiplier_select), // Only start if left shifting multiplier selected
        .multiplicand(multiplicand),
        .multiplier(multiplier),
        .product(lsm_product),
        .done(lsm_done)
    );
    
    // Output selection logic
    always @(*) begin
        case (multiplier_select)
            1'b0: begin // School Book Multiplier
                product = sbm_product;
                done = 1'b1;                    // Combinational - always done
                active_multiplier = 1'b0;
            end
            
            1'b1: begin // Left Shifting Multiplier
                product = lsm_product;
                done = lsm_done;                // Sequential - done when LSM completes
                active_multiplier = 1'b1;
            end
            
            default: begin // Default to school book multiplier
                product = sbm_product;
                done = 1'b1;
                active_multiplier = 1'b0;
            end
        endcase
    end
    
endmodule
