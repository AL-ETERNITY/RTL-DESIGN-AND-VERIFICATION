`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2025 05:10:03
// Design Name: 
// Module Name: hazard_unit_tb
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


module hazard_unit_tb;

    // Inputs
    reg        pcsrc_e;
    reg [4:0]  rs1_d;
    reg [4:0]  rs2_d;
    reg [4:0]  rd_e;
    reg        resultsrc_e0;
    reg [4:0]  rs1_e;
    reg [4:0]  rs2_e;
    reg [4:0]  rd_m;
    reg [4:0]  rd_w;
    reg        regwrite_w;
    reg        regwrite_m;

    // Outputs
    wire [1:0] forward_ae;
    wire [1:0] forward_be;
    wire       stall_f;
    wire       stall_d;
    wire       flush_e;
    wire       flush_d;

    // Instantiate hazard_unit
    hazard_unit inst_hazard_unit (
        .pcsrc_e(pcsrc_e),
        .rs1_d(rs1_d),
        .rs2_d(rs2_d),
        .rd_e(rd_e),
        .resultsrc_e0(resultsrc_e0),
        .rs1_e(rs1_e),
        .rs2_e(rs2_e),
        .rd_m(rd_m),
        .rd_w(rd_w),
        .regwrite_w(regwrite_w),
        .regwrite_m(regwrite_m),
        .forward_ae(forward_ae),
        .forward_be(forward_be),
        .stall_f(stall_f),
        .stall_d(stall_d),
        .flush_e(flush_e),
        .flush_d(flush_d)
    );

    // Test stimulus
    initial begin
        // Test case 1: Initial state
        pcsrc_e = 1'b0;
        rs1_d = 5'b00000;
        rs2_d = 5'b00000;
        rd_e = 5'b00000;
        resultsrc_e0 = 1'b0;
        rs1_e = 5'b00000;
        rs2_e = 5'b00000;
        rd_m = 5'b00000;
        rd_w = 5'b00000;
        regwrite_w = 1'b0;
        regwrite_m = 1'b0;
        #5;
        
        // Test case 2: Load hazard and forwarding
        pcsrc_e = 1'b1;
        rs1_d = 5'b00001;
        rs2_d = 5'b01000;
        rd_e = 5'b00100;
        resultsrc_e0 = 1'b1;
        rs1_e = 5'b00100;
        rs2_e = 5'b00001;
        rd_m = 5'b00001;
        rd_w = 5'b00100;
        regwrite_w = 1'b1;
        regwrite_m = 1'b1;
        #5;
        
        // Test case 3: Different forwarding scenario
        pcsrc_e = 1'b0;
        rs1_d = 5'b10000;
        rs2_d = 5'b00001;
        rd_e = 5'b00100;
        resultsrc_e0 = 1'b0;
        rs1_e = 5'b00010;
        rs2_e = 5'b01000;
        rd_m = 5'b00001;
        rd_w = 5'b10000;
        regwrite_w = 1'b1;
        regwrite_m = 1'b1;
        #5;
        
        // Test case 4: Branch flush scenario
        pcsrc_e = 1'b1;
        rs1_d = 5'b00010;
        rs2_d = 5'b00100;
        rd_e = 5'b01000;
        resultsrc_e0 = 1'b1;
        rs1_e = 5'b00000;
        rs2_e = 5'b00010;
        rd_m = 5'b01000;
        rd_w = 5'b00001;
        regwrite_w = 1'b0;
        regwrite_m = 1'b0;
        #5;
        
        $display("Hazard unit testbench completed");
        $finish;
    end

    // Generate VCD file
    initial begin
        $dumpfile("hazard_unit_tb.vcd");
        $dumpvars(0, hazard_unit_tb);
    end

    // Monitor outputs
    initial begin
        $monitor("Time=%0t pcsrc_e=%b forward_ae=%b forward_be=%b stall_f=%b stall_d=%b flush_e=%b flush_d=%b", 
                 $time, pcsrc_e, forward_ae, forward_be, stall_f, stall_d, flush_e, flush_d);
    end

endmodule
