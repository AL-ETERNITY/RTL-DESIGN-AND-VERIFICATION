`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2025 04:49:58
// Design Name: 
// Module Name: reg_de_tb
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


// Decode-Execute Pipeline Register Testbench
// Converted from VHDL to Verilog

module reg_de_tb;

    // Inputs
    reg        clk;
    reg        regwrite_d;
    reg [1:0]  resultsrc_d;
    reg        memwrite_d;
    reg        jump_d;
    reg        branch_d;
    reg [2:0]  alucontrol_d;
    reg [1:0]  alusrc_d;
    reg [31:0] rd1;
    reg [31:0] rd2;
    reg [31:0] pc_d;
    reg [4:0]  rd_d;
    reg [31:0] immext_d;
    reg [31:0] pcplus4_d;
    reg        clr_de;
    reg [4:0]  rs1_d;
    reg [4:0]  rs2_d;
    
    // Outputs
    wire        regwrite_e;
    wire [1:0]  resultsrc_e;
    wire        memwrite_e;
    wire        jump_e;
    wire        branch_e;
    wire [2:0]  alucontrol_e;
    wire [1:0]  alusrc_e;
    wire [31:0] rd1_e;
    wire [31:0] rd2_e;
    wire [31:0] pc_e;
    wire [4:0]  rd_e;
    wire [31:0] immext_e;
    wire [31:0] pcplus4_e;
    wire [4:0]  rs1_e;
    wire [4:0]  rs2_e;
    wire [19:0] instr31_12_e;

    // Instantiate reg_de
    reg_de inst_reg_de (
        .clk(clk),
        .regwrite_d(regwrite_d),
        .resultsrc_d(resultsrc_d),
        .memwrite_d(memwrite_d),
        .jump_d(jump_d),
        .branch_d(branch_d),
        .alucontrol_d(alucontrol_d),
        .alusrc_d(alusrc_d),
        .rd1(rd1),
        .rd2(rd2),
        .pc_d(pc_d),
        .rd_d(rd_d),
        .immext_d(immext_d),
        .pcplus4_d(pcplus4_d),
        .clr_de(clr_de),
        .rs1_d(rs1_d),
        .rs2_d(rs2_d),
        .regwrite_e(regwrite_e),
        .resultsrc_e(resultsrc_e),
        .memwrite_e(memwrite_e),
        .jump_e(jump_e),
        .branch_e(branch_e),
        .alucontrol_e(alucontrol_e),
        .alusrc_e(alusrc_e),
        .rd1_e(rd1_e),
        .rd2_e(rd2_e),
        .pc_e(pc_e),
        .rd_e(rd_e),
        .immext_e(immext_e),
        .pcplus4_e(pcplus4_e),
        .rs1_e(rs1_e),
        .rs2_e(rs2_e),
        .instr31_12_e(instr31_12_e)
    );

    // Clock generation
    initial begin
        clr_de = 1'b1;
        clk = 1'b1;
        #5;
        clk = 1'b0;
        #5;
        clk = 1'b1;
        clr_de = 1'b0;
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
        regwrite_d = 1'b0;
        resultsrc_d = 2'b00;
        memwrite_d = 1'b0;
        jump_d = 1'b0;
        branch_d = 1'b0;
        alucontrol_d = 3'b000;
        alusrc_d = 2'b00;
        rd1 = 32'hFFFFFFFF;
        rd2 = 32'h00000000;
        pc_d = 32'h01011010;
        rd_d = 5'b01001;
        immext_d = 32'h10100101;
        pcplus4_d = 32'h01101001;
        rs1_d = 5'b11110;
        rs2_d = 5'b00011;
        
        #12;
        regwrite_d = 1'b1;
        resultsrc_d = 2'b01;
        memwrite_d = 1'b1;
        jump_d = 1'b1;
        branch_d = 1'b1;
        alucontrol_d = 3'b001;
        alusrc_d = 2'b01;
        rd1 = 32'hFFFF1FFF;
        rd2 = 32'h00000100;
        pc_d = 32'h01111010;
        rd_d = 5'b01101;
        immext_d = 32'h11100101;
        pcplus4_d = 32'h11101001;
        
        #25;
        regwrite_d = 1'b0;
        resultsrc_d = 2'b10;
        memwrite_d = 1'b0;
        jump_d = 1'b0;
        branch_d = 1'b0;
        alucontrol_d = 3'b010;
        alusrc_d = 2'b00;
        rd1 = 32'hFFFFFF1F;
        rd2 = 32'h10000000;
        pc_d = 32'h01011011;
        rd_d = 5'b11001;
        immext_d = 32'h11100101;
        pcplus4_d = 32'h01101011;
    end

    // Generate VCD file
    initial begin
        $dumpfile("reg_de_tb.vcd");
        $dumpvars(0, reg_de_tb);
    end

    // Monitor outputs
    initial begin
        $monitor("Time=%0t clk=%b clr_de=%b regwrite_e=%b rd_e=%h", 
                 $time, clk, clr_de, regwrite_e, rd_e);
    end

endmodule

