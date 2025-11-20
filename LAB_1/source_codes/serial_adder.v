`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2025 02:35:20
// Design Name: 
// Module Name: serial_adder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 32-bit Serial Adder (Bit-by-bit addition)
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// 32-bit Serial Adder
module serial_adder(
    input clk,              // Clock signal
    input reset,            // Reset signal
    input start,            // Start addition signal
    input [31:0] a,         // 32-bit input A
    input [31:0] b,         // 32-bit input B
    input cin,              // Initial carry input
    output reg [31:0] sum,  // 32-bit sum result
    output reg cout,        // Final carry output
    output reg done         // Addition complete flag
);

    // Internal registers
    reg [31:0] reg_a;       // Register to hold input A
    reg [31:0] reg_b;       // Register to hold input B
    reg carry;              // Internal carry register
    reg [5:0] bit_counter;  // Counter for bit position (0 to 31)
    
    // State machine states
    parameter IDLE = 2'b00;
    parameter ADDING = 2'b01;
    parameter COMPLETE = 2'b10;
    
    reg [1:0] state;
    
    // Single bit full adder logic
    wire sum_bit, carry_out;
    assign sum_bit = reg_a[0] ^ reg_b[0] ^ carry;
    assign carry_out = (reg_a[0] & reg_b[0]) | (carry & (reg_a[0] ^ reg_b[0]));
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all registers
            reg_a <= 32'b0;
            reg_b <= 32'b0;
            sum <= 32'b0;
            carry <= 1'b0;
            cout <= 1'b0;
            done <= 1'b0;
            bit_counter <= 6'b0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    cout <= 1'b0;
                    if (start) begin
                        // Load inputs and initialize
                        reg_a <= a;
                        reg_b <= b;
                        carry <= cin;
                        sum <= 32'b0;
                        bit_counter <= 6'b0;
                        state <= ADDING;
                    end
                end
                
                ADDING: begin
                    // Perform single bit addition
                    sum[bit_counter] <= sum_bit;
                    carry <= carry_out;
                    
                    // Increment bit counter
                    bit_counter <= bit_counter + 1;
                    
                    // Check if all 32 bits are processed (counter goes from 0 to 31)
                    if (bit_counter == 31) begin
                        cout <= carry_out;
                        state <= COMPLETE;
                    end else begin
                        // Shift registers for next bit (only if not last bit)
                        reg_a <= reg_a >> 1;
                        reg_b <= reg_b >> 1;
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
