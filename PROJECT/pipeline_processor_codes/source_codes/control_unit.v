`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.11.2025 23:43:56
// Design Name: 
// Module Name: control_unit
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


module control_unit (
    // inputs
    input wire [6:0]   op,
    input wire [14:12] funct3,
    input wire         funct7_5,
    // outputs
    output wire        regwrite_d,
    output wire [1:0]  resultsrc_d,
    output wire        memwrite_d,
    output wire        jump_d,
    output wire        branch_d,
    output wire [2:0]  alucontrol_d,
    output wire [1:0]  alusrc_d,
    output wire [1:0]  immsrc_d
);

    wire [1:0] ALUOp;

    // Instantiate main decoder
    main_decoder inst_maindecoder (
        .op(op),
        .branch(branch_d),
        .jump(jump_d),
        .MemWrite(memwrite_d),
        .ALUSrc(alusrc_d),
        .ImmSrc(immsrc_d),
        .RegWrite(regwrite_d),
        .ALUOp(ALUOp),
        .ResultSrc(resultsrc_d)
    );

    // Instantiate ALU decoder
    alu_decoder inst_aludecoder (
        .op5(op[5]),
        .funct3(funct3),
        .funct7_5(funct7_5),
        .ALUOp(ALUOp),
        .ALUControl(alucontrol_d)
    );

endmodule