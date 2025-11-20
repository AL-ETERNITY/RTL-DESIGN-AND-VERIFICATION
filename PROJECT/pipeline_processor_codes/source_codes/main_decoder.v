`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.11.2025 23:33:52
// Design Name: 
// Module Name: main_decoder
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


module main_decoder (
    input wire [6:0]  op,
    output wire       branch,
    output wire       jump,
    output wire       MemWrite,
    output wire [1:0] ALUSrc,
    output wire [1:0] ImmSrc,
    output wire       RegWrite,
    output wire [1:0] ALUOp,
    output wire [1:0] ResultSrc
);

    reg [11:0] controls;

    always @(*) begin
        case (op)
            7'b0000011: controls = 12'b100010010000; // load
            7'b0100011: controls = 12'b001011xx0000; // store
            7'b0110011: controls = 12'b1xx000000100; // R-type
            7'b1100011: controls = 12'b010000xx1010; // branch
            7'b0010011: controls = 12'b100010000100; // I-type ALU
            7'b1101111: controls = 12'b111xx0100xx1; // jal
            7'b0110111: controls = 12'b1xx100000000; // U-type
            default:    controls = 12'bxxxxxxxxxxxx; // undefined for other cases
        endcase
    end

    assign RegWrite   = controls[11];
    assign ImmSrc     = controls[10:9];
    assign ALUSrc     = controls[8:7];
    assign MemWrite   = controls[6];
    assign ResultSrc  = controls[5:4];
    assign branch     = controls[3];
    assign ALUOp      = controls[2:1];
    assign jump       = controls[0];

endmodule
