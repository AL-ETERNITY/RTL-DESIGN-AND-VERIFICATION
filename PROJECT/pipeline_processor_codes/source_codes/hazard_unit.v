`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2025 02:23:36
// Design Name: 
// Module Name: hazard_unit
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


`timescale 1ns / 1ps

// ============================================================================
// Hazard Unit - Handles Data Hazards and Control Hazards
// ============================================================================
module hazard_unit (
    // Inputs
    input wire [4:0] rs1_d,         // Source register 1 in Decode stage
    input wire [4:0] rs2_d,         // Source register 2 in Decode stage
    input wire [4:0] rd_e,          // Destination register in Execute stage
    input wire [4:0] rs2_e,         // Source register 2 in Execute stage
    input wire [4:0] rs1_e,         // Source register 1 in Execute stage
    input wire pcsrc_e,             // PC source control (branch taken)
    input wire resultsrc_e0,        // Result source bit 0 (load instruction)
    input wire [4:0] rd_m,          // Destination register in Memory stage
    input wire regwrite_m,          // Register write enable in Memory stage
    input wire [4:0] rd_w,          // Destination register in Writeback stage
    input wire regwrite_w,          // Register write enable in Writeback stage
    
    // Outputs
    output reg stall_f,             // Stall Fetch stage
    output reg stall_d,             // Stall Decode stage
    output reg flush_d,             // Flush Decode stage
    output reg flush_e,             // Flush Execute stage
    output reg [1:0] forward_ae,    // Forward control for ALU input A
    output reg [1:0] forward_be     // Forward control for ALU input B
);

    // Internal signal for load-word stall
    reg lwStall;
    
    // Initialize outputs to known values
    initial begin
        stall_f = 1'b0;
        stall_d = 1'b0;
        flush_d = 1'b0;
        flush_e = 1'b0;
        forward_ae = 2'b00;
        forward_be = 2'b00;
        lwStall = 1'b0;
    end

    // ========================================================================
    // Forwarding Logic for SrcAE (ALU Input A)
    // ========================================================================
    always @(*) begin
        // Forward from Memory stage (highest priority)
        if (((rs1_e == rd_m) && (regwrite_m == 1'b1)) && (rs1_e != 5'b00000)) begin
            forward_ae = 2'b10;
        end
        // Forward from Writeback stage
        else if (((rs1_e == rd_w) && (regwrite_w == 1'b1)) && (rs1_e != 5'b00000)) begin
            forward_ae = 2'b01;
        end
        // No forwarding (use register file output)
        else begin
            forward_ae = 2'b00;
        end
    end

    // ========================================================================
    // Forwarding Logic for SrcBE (ALU Input B)
    // ========================================================================
    always @(*) begin
        // Forward from Memory stage (highest priority)
        if (((rs2_e == rd_m) && (regwrite_m == 1'b1)) && (rs2_e != 5'b00000)) begin
            forward_be = 2'b10;
        end
        // Forward from Writeback stage
        else if (((rs2_e == rd_w) && (regwrite_w == 1'b1)) && (rs2_e != 5'b00000)) begin
            forward_be = 2'b01;
        end
        // No forwarding (use register file output)
        else begin
            forward_be = 2'b00;
        end
    end

    // ========================================================================
    // Load-Word Stall Detection
    // Stall when a load hazard occurs (load instruction followed by dependent instruction)
    // ========================================================================
    always @(*) begin
        if (((rs1_d == rd_e) || (rs2_d == rd_e)) && (resultsrc_e0 == 1'b1)) begin
            lwStall = 1'b1;
        end
        else begin
            lwStall = 1'b0;
        end
        
        // Propagate stall to Fetch and Decode stages
        stall_f = lwStall;
        stall_d = lwStall;
    end

    // ========================================================================
    // Flush Logic
    // Flush when a branch is taken or a load introduces a bubble
    // ========================================================================
    always @(*) begin
        // Flush Decode stage when branch is taken
        flush_d = pcsrc_e;
        
        // Flush Execute stage when branch is taken or load stall occurs
        flush_e = lwStall || pcsrc_e;
    end

endmodule
