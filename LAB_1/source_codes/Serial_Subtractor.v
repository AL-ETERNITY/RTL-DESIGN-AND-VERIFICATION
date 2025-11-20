`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2025 04:54:47
// Design Name: 
// Module Name: Serial_Subtractor
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 32-bit Serial Subtractor using Two's Complement Method
//              Processes one bit at a time using A - B = A + (~B) + 1
//              Uses state machine for sequential operation
//              Takes 32 clock cycles to complete subtraction
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// Serial subtraction implemented as sequential addition with two's complement
// State machine controls bit-by-bit processing
//////////////////////////////////////////////////////////////////////////////////

module Serial_Subtractor(
    input clk,                  // Clock signal
    input reset,                // Reset signal (active high)
    input start,                // Start subtraction signal
    input [31:0] a,             // First operand (minuend)
    input [31:0] b,             // Second operand (subtrahend)
    input bin,                  // Borrow input (typically 0)
    output reg [31:0] diff,     // Difference output (A - B)
    output reg bout,            // Borrow output
    output reg done             // Operation complete flag
);

    // State definitions
    parameter IDLE = 2'b00;
    parameter SUBTRACTING = 2'b01;
    parameter COMPLETE = 2'b10;
    
    // Internal registers
    reg [1:0] state;            // Current state
    reg [4:0] bit_counter;      // Bit position counter (0 to 31)
    reg [31:0] a_reg;           // Register to hold operand A
    reg [31:0] b_reg;           // Register to hold operand B
    reg [31:0] b_complement;    // One's complement of B
    reg carry;                  // Carry for addition chain
    reg cin;                    // Carry input for current bit
    
    // Full adder logic for current bit
    wire sum_bit;
    wire carry_out;
    
    assign sum_bit = a_reg[0] ^ b_complement[0] ^ cin;
    assign carry_out = (a_reg[0] & b_complement[0]) | (cin & (a_reg[0] ^ b_complement[0]));
    
    // State machine and bit-by-bit processing
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all registers
            state <= IDLE;
            bit_counter <= 5'b0;
            a_reg <= 32'b0;
            b_reg <= 32'b0;
            b_complement <= 32'b0;
            diff <= 32'b0;
            bout <= 1'b0;
            done <= 1'b0;
            carry <= 1'b0;
            cin <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    bout <= 1'b0;
                    if (start) begin
                        // Load operands and prepare for subtraction
                        a_reg <= a;
                        b_reg <= b;
                        b_complement <= ~b;  // One's complement of B
                        diff <= 32'b0;
                        bit_counter <= 5'b0;
                        cin <= ~bin;         // Initial carry = ~bin (typically 1 for A-B)
                        carry <= 1'b0;
                        state <= SUBTRACTING;
                    end
                end
                
                SUBTRACTING: begin
                    // Process current bit
                    diff[bit_counter] <= sum_bit;
                    carry <= carry_out;
                    
                    // Shift operands right for next bit
                    a_reg <= {1'b0, a_reg[31:1]};
                    b_complement <= {1'b0, b_complement[31:1]};
                    
                    // Update carry input for next bit
                    cin <= carry_out;
                    
                    // Increment bit counter
                    bit_counter <= bit_counter + 1;
                    
                    // Check if all bits processed
                    if (bit_counter == 5'd31) begin
                        state <= COMPLETE;
                        // Borrow output is complement of final carry
                        bout <= ~carry_out;
                    end
                end
                
                COMPLETE: begin
                    done <= 1'b1;
                    // Stay in complete state until new start
                    if (start) begin
                        // Prepare for new operation
                        a_reg <= a;
                        b_reg <= b;
                        b_complement <= ~b;
                        diff <= 32'b0;
                        bit_counter <= 5'b0;
                        cin <= ~bin;
                        carry <= 1'b0;
                        done <= 1'b0;
                        bout <= 1'b0;
                        state <= SUBTRACTING;
                    end
                end
                
                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end
    
endmodule
