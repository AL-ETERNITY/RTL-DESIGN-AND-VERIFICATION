`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.09.2025 15:04:01
// Design Name: 
// Module Name: JK_FlipFlop
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module JK_FlipFlop(
    input wire clk,     // Clock input
    input wire reset,   // Asynchronous reset
    input wire J,       // J input
    input wire K,       // K input
    output reg Q,       // Output
    output wire Qn      // Complement of Q
);

    assign Qn = ~Q;

    always @(posedge clk or posedge reset) begin
        if (reset)
            Q <= 1'b0;                 // Reset output to 0
        else begin
            case ({J, K})
                2'b00: Q <= Q;         // No change
                2'b01: Q <= 1'b0;      // Reset
                2'b10: Q <= 1'b1;      // Set
                2'b11: Q <= ~Q;        // Toggle
            endcase
        end
    end

endmodule
