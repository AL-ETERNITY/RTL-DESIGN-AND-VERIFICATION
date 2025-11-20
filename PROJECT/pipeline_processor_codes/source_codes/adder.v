`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.11.2025 23:04:21
// Design Name: 
// Module Name: adder
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


module adder #(
    parameter WIDTH = 32
)(
    // inputs
    input  [31:0]       a_in,
    input  [WIDTH-1:0]  b_in,
    // output
    output [31:0]       c_out
);

    assign c_out = a_in + b_in;

endmodule
