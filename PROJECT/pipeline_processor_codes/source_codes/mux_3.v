`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2025 01:32:16
// Design Name: 
// Module Name: mux_3
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


module mux_3 #(
    parameter N = 32
)(
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    input wire [N-1:0] c,
    input wire [1:0] sel,
    output reg [N-1:0] y
);

    always @(*) begin
        case (sel)
            2'b00:   y = a;
            2'b01:   y = b;
            2'b10:   y = c;
            default: y = {N{1'bx}};  // Don't care
        endcase
    end

endmodule