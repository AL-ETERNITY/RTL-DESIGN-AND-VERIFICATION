`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2025 02:02:22
// Design Name: 
// Module Name: pc_tb
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


module pc_tb;

    reg clk;
    reg reset;
    reg en;
    reg [31:0] PCNext;
    wire [31:0] PC_cur;

    // Instantiate UUT
    pc inst_pc (
        .PCNext(PCNext),
        .clk(clk),
        .reset(reset),
        .en(en),
        .PC_cur(PC_cur)
    );

    // Clock and control signals
    initial begin
        reset = 1'b1;
        en = 1'b0;
        clk = 1'b1;
        #5 en = 1'b1;
        reset = 1'b0;
        clk = 1'b0;
        #5 clk = 1'b1;
        #5 clk = 1'b0;
        #5 clk = 1'b1;
        #5 clk = 1'b0;
        #5 clk = 1'b1;
        #5 clk = 1'b0;
        #5 clk = 1'b1;
        #5 clk = 1'b0;
        #5 clk = 1'b1;
        #5 clk = 1'b0;
        #5 clk = 1'b1;
        #5 clk = 1'b0;
        #5 $finish;
    end
    
    // PCNext values
    initial begin
        PCNext = 32'b00001111010110101111000000111100;
        #5 PCNext = 32'b00001111010110101111000000111000;
        #5 PCNext = 32'b00001111010110101111000000111100;
        #5 PCNext = 32'b00001111010110101111000000111001;
    end
    
    initial begin
        $monitor("Time=%0t clk=%b reset=%b en=%b PCNext=%h PC_cur=%h", 
                 $time, clk, reset, en, PCNext, PC_cur);
    end
endmodule