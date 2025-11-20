`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.11.2025 23:36:21
// Design Name: 
// Module Name: main_decoder_tb
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


module main_decoder_tb;

    reg  [6:0] op;
    wire       branch;
    wire       jump;
    wire       MemWrite;
    wire [1:0] ALUSrc;
    wire [1:0] ImmSrc;
    wire       RegWrite;
    wire [1:0] ALUOp;
    wire [1:0] ResultSrc;

    // Instantiate the main decoder
    main_decoder inst_main_decoder (
        .op(op),
        .branch(branch),
        .jump(jump),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .ALUOp(ALUOp),
        .ResultSrc(ResultSrc)
    );

    initial begin
        // load
        op = 7'b0000011;
        #5;
        $display("LOAD: op=%b -> RegWrite=%b, ImmSrc=%b, ALUSrc=%b, MemWrite=%b, ResultSrc=%b, branch=%b, ALUOp=%b, jump=%b",
                 op, RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, branch, ALUOp, jump);
        
        // store
        op = 7'b0100011;
        #5;
        $display("STORE: op=%b -> RegWrite=%b, ImmSrc=%b, ALUSrc=%b, MemWrite=%b, ResultSrc=%b, branch=%b, ALUOp=%b, jump=%b",
                 op, RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, branch, ALUOp, jump);
        
        // R-type
        op = 7'b0110011;
        #5;
        $display("R-TYPE: op=%b -> RegWrite=%b, ImmSrc=%b, ALUSrc=%b, MemWrite=%b, ResultSrc=%b, branch=%b, ALUOp=%b, jump=%b",
                 op, RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, branch, ALUOp, jump);
        
        // branch
        op = 7'b1100011;
        #5;
        $display("BRANCH: op=%b -> RegWrite=%b, ImmSrc=%b, ALUSrc=%b, MemWrite=%b, ResultSrc=%b, branch=%b, ALUOp=%b, jump=%b",
                 op, RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, branch, ALUOp, jump);
        
        // I-type ALU
        op = 7'b0010011;
        #5;
        $display("I-TYPE: op=%b -> RegWrite=%b, ImmSrc=%b, ALUSrc=%b, MemWrite=%b, ResultSrc=%b, branch=%b, ALUOp=%b, jump=%b",
                 op, RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, branch, ALUOp, jump);
                 
        // J-type ALU
        op = 7'b1101111;
        #5;
        $display("J-TYPE: op=%b -> RegWrite=%b, ImmSrc=%b, ALUSrc=%b, MemWrite=%b, ResultSrc=%b, branch=%b, ALUOp=%b, jump=%b",
                 op, RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, branch, ALUOp, jump);
                 
        
        #10;
        $finish;
    end

endmodule
