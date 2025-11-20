`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.09.2025 15:45:00
// Design Name: 
// Module Name: mod10_down_counter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Mod-10 down counter using one-hot encoding and JK flip-flops
// 
// Dependencies: JK_FlipFlop.v
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

(* dont_touch = "true" *)   // 🔒 Prevents Vivado optimization
module One_Hot(
    input  wire clk,
    input  wire reset,
    output wire [9:0] Q   // One-hot counter outputs
);

    // Internal wires for J and K inputs
    wire [9:0] J;
    wire [9:0] K;

    // ===========================================================
    // Combinational Logic for JK Inputs
    // ===========================================================
    assign J[9] = Q[0];
    assign K[9] = Q[9];

    assign J[8] = Q[9];
    assign K[8] = Q[8];

    assign J[7] = Q[8];
    assign K[7] = Q[7];

    assign J[6] = Q[7];
    assign K[6] = Q[6];

    assign J[5] = Q[6];
    assign K[5] = Q[5];

    assign J[4] = Q[5];
    assign K[4] = Q[4];

    assign J[3] = Q[4];
    assign K[3] = Q[3];

    assign J[2] = Q[3];
    assign K[2] = Q[2];

    assign J[1] = Q[2];
    assign K[1] = Q[1];

    assign J[0] = Q[1];
    assign K[0] = Q[0];

    // ===========================================================
    // Structural Instantiation of 10 JK Flip-Flops
    // Reset forces state = 10'b1000000000 (decimal 9)
    // ===========================================================

    (* dont_touch = "true" *) JK_FlipFlop_One_hot FF9 (
        .clk(clk), .reset(1'b0), .J(J[9]), .K(K[9]), .Q(Q[9]), .Qn(),
        .preset(reset), .clear(1'b0)
    );

    (* dont_touch = "true" *) JK_FlipFlop_One_hot FF8 (
        .clk(clk), .reset(1'b0), .J(J[8]), .K(K[8]), .Q(Q[8]), .Qn(),
        .preset(1'b0), .clear(reset)
    );

    (* dont_touch = "true" *) JK_FlipFlop_One_hot FF7 (
        .clk(clk), .reset(1'b0), .J(J[7]), .K(K[7]), .Q(Q[7]), .Qn(),
        .preset(1'b0), .clear(reset)
    );

    (* dont_touch = "true" *) JK_FlipFlop_One_hot FF6 (
        .clk(clk), .reset(1'b0), .J(J[6]), .K(K[6]), .Q(Q[6]), .Qn(),
        .preset(1'b0), .clear(reset)
    );

    (* dont_touch = "true" *) JK_FlipFlop_One_hot FF5 (
        .clk(clk), .reset(1'b0), .J(J[5]), .K(K[5]), .Q(Q[5]), .Qn(),
        .preset(1'b0), .clear(reset)
    );

    (* dont_touch = "true" *) JK_FlipFlop_One_hot FF4 (
        .clk(clk), .reset(1'b0), .J(J[4]), .K(K[4]), .Q(Q[4]), .Qn(),
        .preset(1'b0), .clear(reset)
    );

    (* dont_touch = "true" *) JK_FlipFlop_One_hot FF3 (
        .clk(clk), .reset(1'b0), .J(J[3]), .K(K[3]), .Q(Q[3]), .Qn(),
        .preset(1'b0), .clear(reset)
    );

    (* dont_touch = "true" *) JK_FlipFlop_One_hot FF2 (
        .clk(clk), .reset(1'b0), .J(J[2]), .K(K[2]), .Q(Q[2]), .Qn(),
        .preset(1'b0), .clear(reset)
    );

    (* dont_touch = "true" *) JK_FlipFlop_One_hot FF1 (
        .clk(clk), .reset(1'b0), .J(J[1]), .K(K[1]), .Q(Q[1]), .Qn(),
        .preset(1'b0), .clear(reset)
    );

    (* dont_touch = "true" *) JK_FlipFlop_One_hot FF0 (
        .clk(clk), .reset(1'b0), .J(J[0]), .K(K[0]), .Q(Q[0]), .Qn(),
        .preset(1'b0), .clear(reset)
    );

endmodule
