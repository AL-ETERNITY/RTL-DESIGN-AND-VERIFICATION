`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2025 02:17:06
// Design Name: 
// Module Name: reg_em
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


module reg_em (
    // Inputs
    input wire clk,
    input wire regwrite_e,
    input wire [1:0] resultsrc_e,
    input wire memwrite_e,
    input wire [31:0] aluresult,
    input wire [31:0] writedata_e,
    input wire [4:0] rd_e,           // Changed from [11:7] to [4:0]
    input wire [31:0] pcplus4_e,
    
    // Outputs
    output reg regwrite_m,
    output reg [1:0] resultsrc_m,
    output reg memwrite_m,
    output reg [31:0] aluresult_m,
    output reg [31:0] writedata_m,
    output reg [4:0] rd_m,
    output reg [31:0] pcplus4_m
);

    always @(posedge clk) begin
        aluresult_m <= aluresult;
        writedata_m <= writedata_e;
        pcplus4_m   <= pcplus4_e;
        rd_m        <= rd_e;
        resultsrc_m <= resultsrc_e;
        regwrite_m  <= regwrite_e;
        memwrite_m  <= memwrite_e;
    end

endmodule