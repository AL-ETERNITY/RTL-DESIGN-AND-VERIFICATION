`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.11.2025 23:21:04
// Design Name: 
// Module Name: ALU_Decoder_tb
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


module ALU_Decoder_tb;

    reg        op5;
    reg  [2:0] funct3;
    reg        funct7_5;
    reg  [1:0] ALUOp;
    wire [2:0] ALUControl;

    // Instantiate the ALU Decoder
    alu_decoder inst_ALU_Decoder (
        .op5(op5),
        .funct3(funct3),
        .funct7_5(funct7_5),
        .ALUOp(ALUOp),
        .ALUControl(ALUControl)
    );

    initial begin
        // lw, sw
        ALUOp = 2'b00;
        funct3 = 3'bxxx;
        op5 = 1'bx;
        funct7_5 = 1'bx;
        #5;
        $display("lw/sw: ALUOp=%b, funct3=%b, op5=%b, funct7_5=%b -> ALUControl=%b", 
                 ALUOp, funct3, op5, funct7_5, ALUControl);
        
        // beq
        ALUOp = 2'b01;
        funct3 = 3'bxxx;
        op5 = 1'bx;
        funct7_5 = 1'bx;
        #5;
        $display("beq: ALUOp=%b, funct3=%b, op5=%b, funct7_5=%b -> ALUControl=%b", 
                 ALUOp, funct3, op5, funct7_5, ALUControl);
        
        // add
        ALUOp = 2'b10;
        funct3 = 3'b000;
        op5 = 1'b0;
        funct7_5 = 1'b1;
        #5;
        $display("add: ALUOp=%b, funct3=%b, op5=%b, funct7_5=%b -> ALUControl=%b", 
                 ALUOp, funct3, op5, funct7_5, ALUControl);
        
        // sub
        ALUOp = 2'b10;
        funct3 = 3'b000;
        op5 = 1'b1;
        funct7_5 = 1'b1;
        #5;
        $display("sub: ALUOp=%b, funct3=%b, op5=%b, funct7_5=%b -> ALUControl=%b", 
                 ALUOp, funct3, op5, funct7_5, ALUControl);
        
        // slt
        ALUOp = 2'bxx;
        funct3 = 3'b010;
        op5 = 1'bx;
        funct7_5 = 1'bx;
        #5;
        $display("slt: ALUOp=%b, funct3=%b, op5=%b, funct7_5=%b -> ALUControl=%b", 
                 ALUOp, funct3, op5, funct7_5, ALUControl);
        
        // or
        ALUOp = 2'bxx;
        funct3 = 3'b110;
        op5 = 1'bx;
        funct7_5 = 1'bx;
        #5;
        $display("or: ALUOp=%b, funct3=%b, op5=%b, funct7_5=%b -> ALUControl=%b", 
                 ALUOp, funct3, op5, funct7_5, ALUControl);
        
        // and
        ALUOp = 2'bxx;
        funct3 = 3'b111;
        op5 = 1'bx;
        funct7_5 = 1'bx;
        #5;
        $display("and: ALUOp=%b, funct3=%b, op5=%b, funct7_5=%b -> ALUControl=%b", 
                 ALUOp, funct3, op5, funct7_5, ALUControl);
        
        #10;
        $finish;
    end

endmodule