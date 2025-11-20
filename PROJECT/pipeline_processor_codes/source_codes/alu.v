`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.11.2025 23:25:46
// Design Name: 
// Module Name: alu
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


module alu (
    input wire [31:0]  SrcA,
    input wire [31:0]  SrcB,
    input wire [2:0]   ALUControl,
    output wire        Zero,
    output reg [31:0]  aluresult
);

    always @(*) begin
        case (ALUControl)
            // add
            3'b000: aluresult = SrcA + SrcB;
            
            // branch (subtract)
            3'b001: aluresult = SrcA - SrcB;
            
            // and
            3'b010: aluresult = SrcA & SrcB;
            
            // or
            3'b011: aluresult = SrcA | SrcB;
            
            // srl (shift right logical)
            3'b100: aluresult = SrcA >> SrcB[4:0];
            
            // xor
            3'b110: aluresult = SrcA ^ SrcB;
            
            // sll (shift left logical)
            3'b111: aluresult = SrcA << SrcB[4:0];
            
            // slt (set less than)
            3'b101: aluresult = (SrcA < SrcB) ? 32'h00000001 : 32'h00000000;
            
            default: aluresult = 32'hxxxxxxxx;
        endcase
    end

    assign Zero = ((aluresult == 32'h00000000) || (aluresult[31] == 1'b1)) ? 1'b1 : 1'b0;

endmodule