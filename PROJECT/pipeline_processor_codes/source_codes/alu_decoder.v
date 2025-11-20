`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.11.2025 23:18:30
// Design Name: 
// Module Name: alu_decoder
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

module alu_decoder (
    input wire        op5,
    input wire [2:0]  funct3,
    input wire        funct7_5,
    input wire [1:0]  ALUOp,
    output reg [2:0]  ALUControl
);

    always @(*) begin
        case (ALUOp)
            2'b00: ALUControl = 3'b000;  // add
            2'b01: ALUControl = 3'b001;  // sub
            default: begin
                case (funct3)
                    3'b000: begin
                        if ((op5 & funct7_5) == 1'b1)
                            ALUControl = 3'b001;  // sub
                        else
                            ALUControl = 3'b000;  // add
                    end
                    3'b010: ALUControl = 3'b101;  // slt
                    3'b110: ALUControl = 3'b011;  // or
                    3'b111: ALUControl = 3'b010;  // and
                    3'b101: ALUControl = 3'b100;  // srl
                    3'b100: ALUControl = 3'b110;  // xor
                    3'b001: ALUControl = 3'b111;  // sll
                    default: ALUControl = 3'bxxx; // undefined
                endcase
            end
        endcase
    end

endmodule