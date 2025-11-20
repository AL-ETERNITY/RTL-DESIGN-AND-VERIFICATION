`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2025 00:28:13
// Design Name: 
// Module Name: extend
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


module extend (
    input wire [1:0] ImmSrc,
    input wire [31:7] instruction,
    output reg [31:0] ImmExt
);

    always @(*) begin
        case (ImmSrc)
            // I-Type
            2'b00: begin
                ImmExt = {{20{instruction[31]}}, instruction[31:20]};
            end
            
            // S-Type
            2'b01: begin
                ImmExt = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
            end
            
            // B-Type
            2'b10: begin
                ImmExt = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
            end
            
            // J-Type (jal)
            2'b11: begin
                ImmExt = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};
            end
            
            default: begin
                ImmExt = 32'bx;  // Don't care
            end
        endcase
    end

endmodule
