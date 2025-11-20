`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2025 05:07:13
// Design Name: 
// Module Name: reg_mw_tb
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


module reg_mw_tb;

    // Inputs
    reg        clk;
    reg        regwrite_m;
    reg [1:0]  resultsrc_m;
    reg [31:0] aluresult_m;
    reg [31:0] rd;
    reg [4:0]  rd_m;
    reg [31:0] pcplus4_m;

    // Outputs
    wire        regwrite_w;
    wire [1:0]  resultsrc_w;
    wire [31:0] aluresult_w;
    wire [31:0] readdata_w;
    wire [4:0]  rd_w;
    wire [31:0] pcplus4_w;

    // Instantiate reg_mw
    reg_mw inst_reg_mw (
        .clk(clk),
        .regwrite_m(regwrite_m),
        .resultsrc_m(resultsrc_m),
        .aluresult_m(aluresult_m),
        .rd(rd),
        .rd_m(rd_m),
        .pcplus4_m(pcplus4_m),
        .regwrite_w(regwrite_w),
        .resultsrc_w(resultsrc_w),
        .aluresult_w(aluresult_w),
        .readdata_w(readdata_w),
        .rd_w(rd_w),
        .pcplus4_w(pcplus4_w)
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
        regwrite_m = 1'b0;
        resultsrc_m = 2'b00;
        aluresult_m = 32'h12345678;
        rd = 32'h87654321;
        rd_m = 5'b00110;
        pcplus4_m = 32'hFFF0F0FF;
        
        #12;
        regwrite_m = 1'b1;
        resultsrc_m = 2'b01;
        aluresult_m = 32'h12305678;
        rd = 32'h87654320;
        rd_m = 5'b01110;
        pcplus4_m = 32'hFFF1F0FF;
        
        #25;
        regwrite_m = 1'b0;
        resultsrc_m = 2'b10;
        aluresult_m = 32'h12315678;
        rd = 32'h87653321;
        rd_m = 5'b00111;
        pcplus4_m = 32'hFF90F0FF;
    end

    // Generate VCD file
    initial begin
        $dumpfile("reg_mw_tb.vcd");
        $dumpvars(0, reg_mw_tb);
    end

    // Monitor outputs
    initial begin
        $monitor("Time=%0t clk=%b regwrite_w=%b aluresult_w=%h readdata_w=%h rd_w=%b", 
                 $time, clk, regwrite_w, aluresult_w, readdata_w, rd_w);
    end

endmodule

