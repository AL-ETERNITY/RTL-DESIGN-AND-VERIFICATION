`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2025 04:53:20
// Design Name: 
// Module Name: reg_em_tb
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


module reg_em_tb;

    // Inputs
    reg        clk;
    reg        regwrite_e;
    reg [1:0]  resultsrc_e;
    reg        memwrite_e;
    reg [31:0] aluresult;
    reg [31:0] writedata_e;
    reg [4:0]  rd_e;
    reg [31:0] pcplus4_e;

    // Outputs
    wire        regwrite_m;
    wire [1:0]  resultsrc_m;
    wire        memwrite_m;
    wire [31:0] aluresult_m;
    wire [31:0] writedata_m;
    wire [4:0]  rd_m;
    wire [31:0] pcplus4_m;

    // Instantiate reg_em
    reg_em inst_reg_em (
        .clk(clk),
        .regwrite_e(regwrite_e),
        .resultsrc_e(resultsrc_e),
        .memwrite_e(memwrite_e),
        .aluresult(aluresult),
        .writedata_e(writedata_e),
        .rd_e(rd_e),
        .pcplus4_e(pcplus4_e),
        .regwrite_m(regwrite_m),
        .resultsrc_m(resultsrc_m),
        .memwrite_m(memwrite_m),
        .aluresult_m(aluresult_m),
        .writedata_m(writedata_m),
        .rd_m(rd_m),
        .pcplus4_m(pcplus4_m)
    );

    // Clock generation
    initial begin
        clk = 1'b1;
        #5;
        clk = 1'b0;
        #5;
        clk = 1'b1;
        #5;
        clk = 1'b0;
        #5;
        clk = 1'b1;
        #5;
        clk = 1'b0;
        #5;
        clk = 1'b1;
        #5;
        clk = 1'b0;
        #5;
        clk = 1'b1;
        #5;
        clk = 1'b0;
        #5;
        clk = 1'b1;
        #5;
        clk = 1'b0;
        $finish;
    end

    // Test stimulus
    initial begin
        regwrite_e = 1'b0;
        resultsrc_e = 2'b00;
        memwrite_e = 1'b0;
        aluresult = 32'hFFFF0000;
        writedata_e = 32'h0000FFFF;
        rd_e = 5'b00011;
        pcplus4_e = 32'hF0F0F0F0;
        
        #12;
        regwrite_e = 1'b1;
        resultsrc_e = 2'b01;
        memwrite_e = 1'b1;
        aluresult = 32'hFFFF0001;
        writedata_e = 32'h1000FFFF;
        rd_e = 5'b10001;
        pcplus4_e = 32'hF1F0F0F0;
        
        #25;
        regwrite_e = 1'b0;
        resultsrc_e = 2'b10;
        memwrite_e = 1'b0;
        aluresult = 32'hFFFF0100;
        writedata_e = 32'h0100FFFF;
        rd_e = 5'b01001;
        pcplus4_e = 32'hF0F0F1F0;
    end

    // Generate VCD file
    initial begin
        $dumpfile("reg_em_tb.vcd");
        $dumpvars(0, reg_em_tb);
    end

    // Monitor outputs
    initial begin
        $monitor("Time=%0t clk=%b regwrite_m=%b aluresult_m=%h rd_m=%b", 
                 $time, clk, regwrite_m, aluresult_m, rd_m);
    end

endmodule
