`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.09.2025 15:59:16
// Design Name: 
// Module Name: JK_FlipFlop_One_hot
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


module JK_FlipFlop_One_hot(
    input wire clk,     // Clock input
    input wire reset,   // Asynchronous reset (active high)
    input wire preset,  // Asynchronous preset (active high) 
    input wire clear,   // Asynchronous clear (active high)
    input wire J,       // J input
    input wire K,       // K input
    output reg Q,       // Output
    output wire Qn      // Complement of Q
);

    assign Qn = ~Q;

    always @(posedge clk or posedge reset or posedge preset or posedge clear) begin
        if (preset)
            Q <= 1'b1;                 // Preset output to 1
        else if (clear || reset)
            Q <= 1'b0;                 // Clear output to 0
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
