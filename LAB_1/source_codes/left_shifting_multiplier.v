`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2025 03:55:12
// Design Name: 
// Module Name: left_shifting_multiplier
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 32-bit Left Shifting Multiplier (Sequential Shift-and-Add)
//              Algorithm: Check each bit of multiplier from LSB to MSB
//              If bit = 1: Add shifted multiplicand to result
//              If bit = 0: Just shift
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// This implements the traditional shift-and-add multiplication algorithm
//////////////////////////////////////////////////////////////////////////////////

module left_shifting_multiplier(
    input clk,                      // Clock signal
    input reset,                    // Reset signal  
    input start,                    // Start multiplication
    input [31:0] multiplicand,      // Number being multiplied (A)
    input [31:0] multiplier,        // Number multiplying by (B)
    output reg [63:0] product,      // Result (A × B)
    output reg done                 // Multiplication complete flag
);

    // Internal registers
    reg [63:0] accumulator;         // Accumulates partial results
    reg [31:0] multiplicand_reg;    // Holds multiplicand
    reg [31:0] multiplier_reg;      // Holds remaining multiplier bits
    reg [5:0] bit_counter;          // Counts processed bits (0 to 31)
    
    // State machine states
    parameter IDLE = 2'b00;
    parameter MULTIPLY = 2'b01;
    parameter COMPLETE = 2'b10;
    
    reg [1:0] state;
    
    // Main control logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all registers
            accumulator <= 64'b0;
            multiplicand_reg <= 32'b0;
            multiplier_reg <= 32'b0;
            product <= 64'b0;
            done <= 1'b0;
            bit_counter <= 6'b0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (start) begin
                        // Load inputs and initialize
                        accumulator <= 64'b0;
                        multiplicand_reg <= multiplicand;
                        multiplier_reg <= multiplier;
                        bit_counter <= 6'b0;
                        state <= MULTIPLY;
                    end
                end
                
                MULTIPLY: begin
                    // Check LSB of multiplier
                    if (multiplier_reg[0] == 1'b1) begin
                        // Add shifted multiplicand to accumulator
                        accumulator <= accumulator + ({32'b0, multiplicand_reg} << bit_counter);
                    end
                    
                    // Shift multiplier right (process next bit)
                    multiplier_reg <= multiplier_reg >> 1;
                    
                    // Increment bit counter
                    bit_counter <= bit_counter + 1;
                    
                    // Check if all 32 bits processed
                    if (bit_counter == 31) begin
                        product <= accumulator + (multiplier_reg[0] ? ({32'b0, multiplicand_reg} << 31) : 64'b0);
                        state <= COMPLETE;
                    end
                end
                
                COMPLETE: begin
                    done <= 1'b1;
                    state <= IDLE;
                end
                
                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule
