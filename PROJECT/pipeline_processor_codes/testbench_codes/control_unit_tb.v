`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.11.2025 23:47:18
// Design Name: 
// Module Name: control_unit_tb
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


`timescale 1ns / 1ps

module control_unit_tb;

    // Inputs
    reg [6:0] op;
    reg [2:0] funct3;
    reg funct7_5;
    
    // Outputs
    wire regwrite_d;
    wire [1:0] resultsrc_d;
    wire memwrite_d;
    wire jump_d;
    wire branch_d;
    wire [2:0] alucontrol_d;
    wire alusrc_d;
    wire [1:0] immsrc_d;

    // Instantiate the Unit Under Test (UUT)
    control_unit uut (
        .op(op),
        .funct3(funct3),
        .funct7_5(funct7_5),
        .regwrite_d(regwrite_d),
        .resultsrc_d(resultsrc_d),
        .memwrite_d(memwrite_d),
        .jump_d(jump_d),
        .branch_d(branch_d),
        .alucontrol_d(alucontrol_d),
        .alusrc_d(alusrc_d),
        .immsrc_d(immsrc_d)
    );

    // Stimulus process
    initial begin
        // Test case 1: ALUOp = "00"
        op = 7'b0000_011;
        funct3 = 3'bxxx;
        funct7_5 = 1'bx;
        #5;
        
        // Test case 2: ALUOp = "00"
        op = 7'b0100_011;
        funct3 = 3'bxxx;
        funct7_5 = 1'bx;
        #5;
        
        // Test case 3: ALUOp = "10"
        op = 7'b0110_011;
        funct3 = 3'b000;
        funct7_5 = 1'b0;
        #5;
        
        // Test case 4: ALUOp = "01"
        op = 7'b1100_011;
        funct3 = 3'bxxx;
        funct7_5 = 1'bx;
        #5;
        
        // End simulation
        $finish;
    end

endmodule