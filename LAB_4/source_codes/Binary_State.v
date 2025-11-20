`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.09.2025 14:52:30
// Design Name: 
// Module Name: Binary_State
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


(* DONT_TOUCH = "TRUE" *)
module Binary_State(
    input wire clk,
    input wire reset,
    output wire [3:0] Q   // Counter outputs Q3 Q2 Q1 Q0
);

    // Wires for each flip-flop output
    (* DONT_TOUCH = "TRUE" *) wire Q0, Q1, Q2, Q3;
    (* DONT_TOUCH = "TRUE" *) wire Q0n, Q1n, Q2n, Q3n; // complements if needed

    // === Replace these with your computed excitation values ===
    // Example shown below for clarity, you should put your own logic
    (* DONT_TOUCH = "TRUE" *) wire J0, K0, J1, K1, J2, K2, J3, K3;

    // Example dummy assignments (replace with your computed equations)
    (* DONT_TOUCH = "TRUE" *) assign J0 = 1'b1;       // toggles every clock
    (* DONT_TOUCH = "TRUE" *) assign K0 = 1'b1;

    (* DONT_TOUCH = "TRUE" *) assign J1 = Q2 & Q0n | Q3 & Q0n;         // depends on Q0 (example only)
    (* DONT_TOUCH = "TRUE" *) assign K1 = Q0n;

    (* DONT_TOUCH = "TRUE" *) assign J2 = Q3 & Q0n;    // replace with your derived formula
    (* DONT_TOUCH = "TRUE" *) assign K2 = Q1n & Q0n;

    (* DONT_TOUCH = "TRUE" *) assign J3 = Q2n & Q1n & Q0n; // replace with your derived formula
    (* DONT_TOUCH = "TRUE" *) assign K3 = Q0n;
    // ===========================================================

    // Instantiate JK flip-flops
    (* DONT_TOUCH = "TRUE" *) JK_FlipFlop FF0 (.clk(clk), .reset(reset), .J(J0), .K(K0), .Q(Q0), .Qn(Q0n));
    (* DONT_TOUCH = "TRUE" *) JK_FlipFlop FF1 (.clk(clk), .reset(reset), .J(J1), .K(K1), .Q(Q1), .Qn(Q1n));
    (* DONT_TOUCH = "TRUE" *) JK_FlipFlop FF2 (.clk(clk), .reset(reset), .J(J2), .K(K2), .Q(Q2), .Qn(Q2n));
    (* DONT_TOUCH = "TRUE" *) JK_FlipFlop FF3 (.clk(clk), .reset(reset), .J(J3), .K(K3), .Q(Q3), .Qn(Q3n));

    // Group outputs
    assign Q = {Q3, Q2, Q1, Q0};

endmodule
