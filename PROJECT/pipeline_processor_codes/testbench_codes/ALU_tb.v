`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.11.2025 23:26:44
// Design Name: 
// Module Name: ALU_tb
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


module ALU_tb;

    reg  [31:0] SrcA;
    reg  [31:0] SrcB;
    reg  [2:0]  ALUControl;
    wire        Zero;
    wire [31:0] ALUResult;

    // Instantiate the ALU
    alu inst_ALU (
        .SrcA(SrcA),
        .SrcB(SrcB),
        .ALUControl(ALUControl),
        .Zero(Zero),
        .aluresult(ALUResult)
    );

    // Test stimulus
    initial begin
        // add
        ALUControl = 3'b000;
        #5;
        $display("ADD: SrcA=%h, SrcB=%h, ALUControl=%b -> ALUResult=%h, Zero=%b", 
                 SrcA, SrcB, ALUControl, ALUResult, Zero);
        
        // subtract
        ALUControl = 3'b001;
        #5;
        $display("SUB: SrcA=%h, SrcB=%h, ALUControl=%b -> ALUResult=%h, Zero=%b", 
                 SrcA, SrcB, ALUControl, ALUResult, Zero);
        
        // and
        ALUControl = 3'b010;
        #5;
        $display("AND: SrcA=%h, SrcB=%h, ALUControl=%b -> ALUResult=%h, Zero=%b", 
                 SrcA, SrcB, ALUControl, ALUResult, Zero);
        
        // or
        ALUControl = 3'b011;
        #5;
        $display("OR: SrcA=%h, SrcB=%h, ALUControl=%b -> ALUResult=%h, Zero=%b", 
                 SrcA, SrcB, ALUControl, ALUResult, Zero);
        
        // slt
        ALUControl = 3'b101;
        #5;
        $display("SLT: SrcA=%h, SrcB=%h, ALUControl=%b -> ALUResult=%h, Zero=%b", 
                 SrcA, SrcB, ALUControl, ALUResult, Zero);
        
        // sll
        ALUControl = 3'b111;
        #5;
        $display("SLL: SrcA=%h, SrcB=%h, ALUControl=%b -> ALUResult=%h, Zero=%b", 
                 SrcA, SrcB, ALUControl, ALUResult, Zero);
        
        #10;
        $finish;
    end

    // Continuous assignments for input values
    initial begin
        SrcA = 32'h00000001;
        SrcB = 32'h00000010;
    end

endmodule