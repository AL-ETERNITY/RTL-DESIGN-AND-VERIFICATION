`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2025 03:01:28
// Design Name: 
// Module Name: Adder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Top Module for 32-bit Adders with Selection Mechanism
//              Supports: Ripple Carry, Carry Lookahead, and Serial Adders
// 
// Dependencies: ripple_carry_adder.v, carry_lookahead_adder.v, serial_adder.v
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Adder(
    // Common inputs
    input clk,                  // Clock (required for serial adder)
    input reset,                // Reset (required for serial adder)
    input [31:0] a,             // 32-bit input A
    input [31:0] b,             // 32-bit input B
    input cin,                  // Carry input
    
    // Selection and control
    input [1:0] adder_select,   // Adder type selection
                                // 00: Ripple Carry Adder
                                // 01: Carry Lookahead Adder  
                                // 10: Serial Adder
                                // 11: Reserved/Invalid
    input start,                // Start signal (used for serial adder)
    
    // Outputs
    output reg [31:0] sum,      // 32-bit sum result
    output reg cout,            // Carry output
    output reg done,            // Operation complete flag
    output reg [1:0] active_adder // Shows which adder is currently selected
);

    // Internal wires for each adder type
    wire [31:0] rca_sum, cla_sum, sa_sum;
    wire rca_cout, cla_cout, sa_cout;
    wire sa_done;
    
    // Instantiate Ripple Carry Adder
    ripple_carry_adder rca_inst (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(rca_sum),
        .cout(rca_cout)
    );
    
    // Instantiate Carry Lookahead Adder
    carry_lookahead_adder cla_inst (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(cla_sum),
        .cout(cla_cout)
    );
    
    // Instantiate Serial Adder
    serial_adder sa_inst (
        .clk(clk),
        .reset(reset),
        .start(start && (adder_select == 2'b10)), // Only start if serial adder selected
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sa_sum),
        .cout(sa_cout),
        .done(sa_done)
    );
    
    // Output selection logic
    always @(*) begin
        case (adder_select)
            2'b00: begin // Ripple Carry Adder
                sum = rca_sum;
                cout = rca_cout;
                done = 1'b1;           // Combinational - always done
                active_adder = 2'b00;
            end
            
            2'b01: begin // Carry Lookahead Adder
                sum = cla_sum;
                cout = cla_cout;
                done = 1'b1;           // Combinational - always done
                active_adder = 2'b01;
            end
            
            2'b10: begin // Serial Adder
                sum = sa_sum;
                cout = sa_cout;
                done = sa_done;        // Sequential - done when SA completes
                active_adder = 2'b10;
            end
            
            default: begin // Invalid selection
                sum = 32'h00000000;
                cout = 1'b0;
                done = 1'b0;
                active_adder = 2'b11; // Invalid indicator
            end
        endcase
    end
    
endmodule
