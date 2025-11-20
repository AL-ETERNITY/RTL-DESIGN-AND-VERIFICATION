`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2025 02:13:23
// Design Name: 
// Module Name: reg_de
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


module reg_de (
    // Inputs
    input wire clr_de,
    input wire clk,
    input wire regwrite_d,
    input wire [1:0] resultsrc_d,
    input wire memwrite_d,
    input wire jump_d,
    input wire branch_d,
    input wire [2:0] alucontrol_d,
    input wire [1:0] alusrc_d,
    input wire [4:0] rs1_d,           // Changed from [19:15] to [4:0]
    input wire [4:0] rs2_d,           // Changed from [24:20] to [4:0]
    input wire [31:0] rd1,
    input wire [31:0] rd2,
    input wire [31:0] pc_d,
    input wire [4:0] rd_d,            // Changed from [11:7] to [4:0]
    input wire [31:0] immext_d,
    input wire [31:0] pcplus4_d,
    input wire [19:0] instr31_12_d,   // Changed from [31:12] to [19:0]
    
    // Outputs
    output reg regwrite_e,
    output reg [1:0] resultsrc_e,
    output reg memwrite_e,
    output reg jump_e,
    output reg branch_e,
    output reg [2:0] alucontrol_e,
    output reg [1:0] alusrc_e,
    output reg [31:0] rd1_e,
    output reg [31:0] rd2_e,
    output reg [4:0] rs1_e,
    output reg [4:0] rs2_e,
    output reg [31:0] pc_e,
    output reg [4:0] rd_e,
    output reg [31:0] immext_e,
    output reg [19:0] instr31_12_e,
    output reg [31:0] pcplus4_e
);

    // Initialize outputs
    initial begin
        rd1_e        = 32'b0;
        rd2_e        = 32'b0;
        pc_e         = 32'b0;
        immext_e     = 32'b0;
        pcplus4_e    = 32'b0;
        instr31_12_e = 20'b0;
        rs1_e        = 5'b0;
        rs2_e        = 5'b0;
        rd_e         = 5'b0;
        alucontrol_e = 3'b0;
        resultsrc_e  = 2'b0;
        alusrc_e     = 2'b0;
        regwrite_e   = 1'b0;
        memwrite_e   = 1'b0;
        jump_e       = 1'b0;
        branch_e     = 1'b0;
    end

    always @(posedge clk) begin
        if (clr_de == 1'b1) begin
            rd1_e        <= 32'b0;
            rd2_e        <= 32'b0;
            pc_e         <= 32'b0;
            immext_e     <= 32'b0;
            pcplus4_e    <= 32'b0;
            instr31_12_e <= 20'b0;
            rs1_e        <= 5'b0;
            rs2_e        <= 5'b0;
            rd_e         <= 5'b0;
            alucontrol_e <= 3'b0;
            resultsrc_e  <= 2'b0;
            alusrc_e     <= 2'b0;
            regwrite_e   <= 1'b0;
            memwrite_e   <= 1'b0;
            jump_e       <= 1'b0;
            branch_e     <= 1'b0;
        end
        else begin
            rd1_e        <= rd1;
            rd2_e        <= rd2;
            pc_e         <= pc_d;
            immext_e     <= immext_d;
            pcplus4_e    <= pcplus4_d;
            instr31_12_e <= instr31_12_d;
            rs1_e        <= rs1_d;
            rs2_e        <= rs2_d;
            rd_e         <= rd_d;
            alucontrol_e <= alucontrol_d;
            resultsrc_e  <= resultsrc_d;
            alusrc_e     <= alusrc_d;
            regwrite_e   <= regwrite_d;
            memwrite_e   <= memwrite_d;
            jump_e       <= jump_d;
            branch_e     <= branch_d;
        end
    end

endmodule
