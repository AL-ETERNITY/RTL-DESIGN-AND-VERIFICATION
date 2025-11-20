`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2025 02:18:58
// Design Name: 
// Module Name: reg_mw
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


module reg_mw (
    // Inputs
    input wire clk,
    input wire regwrite_m,
    input wire [1:0] resultsrc_m,
    input wire [31:0] aluresult_m,
    input wire [31:0] rd,
    input wire [4:0] rd_m,           // Changed from [11:7] to [4:0]
    input wire [31:0] pcplus4_m,
    
    // Outputs
    output reg regwrite_w,
    output reg [1:0] resultsrc_w,
    output reg [31:0] aluresult_w,
    output reg [31:0] readdata_w,
    output reg [4:0] rd_w,
    output reg [31:0] pcplus4_w
);

    always @(posedge clk) begin
        aluresult_w <= aluresult_m;
        readdata_w  <= rd;
        pcplus4_w   <= pcplus4_m;
        rd_w        <= rd_m;
        resultsrc_w <= resultsrc_m;
        regwrite_w  <= regwrite_m;
    end

endmodule
