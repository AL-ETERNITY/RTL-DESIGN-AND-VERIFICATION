`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2025 00:42:05
// Design Name: 
// Module Name: extend_tb
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


module extend_tb;

    // Testbench signals
    reg [1:0] ImmSrc;
    reg [31:7] instruction;
    wire [31:0] ImmExt;

    // Instantiate the Unit Under Test (UUT)
    extend inst_extend (
        .ImmSrc(ImmSrc),
        .instruction(instruction),
        .ImmExt(ImmExt)
    );

    // Stimulus process for ImmSrc
    initial begin
        ImmSrc = 2'b00;
        #5 ImmSrc = 2'b01;
        #5 ImmSrc = 2'b10;
        #5 ImmSrc = 2'b11;
        #5 ImmSrc = 2'b00;
        #5 ImmSrc = 2'b01;
        #5 ImmSrc = 2'b10;
        #5 ImmSrc = 2'b11;
        #5 $finish;
    end

    // Stimulus process for instruction
    initial begin
        instruction = 25'b0000_1100_0111_0000_1111_0010_0;
        #20 instruction = 25'b0000_1100_0111_0000_1111_0010_1;
    end
    
    // Optional: Monitor for debugging
    initial begin
        $monitor("Time=%0t ImmSrc=%b instruction=%b ImmExt=%h", 
                 $time, ImmSrc, instruction, ImmExt);
    end

endmodule
