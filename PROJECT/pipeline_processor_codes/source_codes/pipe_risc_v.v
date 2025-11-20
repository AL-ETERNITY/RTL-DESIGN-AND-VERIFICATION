`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2025 02:27:18
// Design Name: 
// Module Name: pipe_risc_v
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
// Pipelined RISC-V Processor - Top Module
// ============================================================================
module pipe_risc_v (
    input wire clk,
    input wire reset,
    
    // Debug outputs to prevent synthesis optimization
    output wire [31:0] debug_aluresult,
    output wire debug_stall_f,
    output wire debug_stall_d,
    output wire debug_flush_d,
    output wire debug_flush_e,
    output wire [1:0] debug_forward_ae,
    output wire [1:0] debug_forward_be,
    output wire debug_pcsrc_e,
    output wire debug_regwrite_w,
    output wire [4:0] debug_rd_w
);

    // Internal signals
    wire [31:0] aluresult_w;
    
    // Control signals from control unit
    wire regwrite_d;
    wire [1:0] resultsrc_d;
    wire memwrite_d;
    wire jump_d;
    wire branch_d;
    wire [2:0] alucontrol_d;
    wire [1:0] alusrc_d;
    wire [1:0] immsrc_d;
    
    // Status and control signals
    wire zero;
    wire jump_e;
    wire branch_e;
    wire pcsrc_e;
    
    // Forwarding signals
    wire [1:0] forward_ae;
    wire [1:0] forward_be;
    
    // Hazard control signals
    wire stall_f;
    wire stall_d;
    wire flush_d;
    wire flush_e;
    
    // Register addresses
    wire [4:0] rd_e;
    wire [4:0] rs1_e;
    wire [4:0] rs2_e;
    wire [4:0] rd_m;
    wire [4:0] rd_w;
    
    // Pipeline stage signals
    wire resultsrc_e0;
    wire regwrite_m;
    wire regwrite_w;
    wire [31:0] instr_d_o;

    // ========================================================================
    // Datapath Instantiation
    // ========================================================================
    datapath inst_datapath (
        // Clock and reset
        .clk(clk),
        .reset(reset),
        
        // Hazard control inputs (inverted stall signals become enable signals)
        .en_pc(~stall_f),
        .en_fd(~stall_d),
        .clr_fd(flush_d),
        .clr_de(flush_e),
        .pcsrc_e(pcsrc_e),
        
        // Control signals from control unit
        .immsrc_d(immsrc_d),
        .regwrite_d(regwrite_d),
        .resultsrc_d(resultsrc_d),
        .memwrite_d(memwrite_d),
        .jump_d(jump_d),
        .branch_d(branch_d),
        .alucontrol_d(alucontrol_d),
        .alusrc_d(alusrc_d),
        
        // Forwarding inputs
        .forward_ae(forward_ae),
        .forward_be(forward_be),
        
        // Outputs to hazard unit
        .rd_w(rd_w),
        .regwrite_w(regwrite_w),
        .rd_e(rd_e),
        .regwrite_m(regwrite_m),
        .rd_m(rd_m),
        .instr_d(instr_d_o),
        .aluresult_w(aluresult_w),
        
        // Status outputs
        .jump_e(jump_e),
        .branch_e(branch_e),
        .zero_e(zero),
        .rs1_e(rs1_e),
        .rs2_e(rs2_e),
        .resultsrc_e0(resultsrc_e0)
    );

    // ========================================================================
    // PC Source Logic (Branch/Jump Control)
    // ========================================================================
    assign pcsrc_e = (branch_e & zero) | jump_e;

    // ========================================================================
    // Control Unit Instantiation
    // ========================================================================
    control_unit inst_control_unit (
        // Instruction fields
        .op(instr_d_o[6:0]),
        .funct3(instr_d_o[14:12]),
        .funct7_5(instr_d_o[30]),
        
        // Control outputs
        .regwrite_d(regwrite_d),
        .resultsrc_d(resultsrc_d),
        .memwrite_d(memwrite_d),
        .jump_d(jump_d),
        .branch_d(branch_d),
        .alucontrol_d(alucontrol_d),
        .alusrc_d(alusrc_d),
        .immsrc_d(immsrc_d)
    );

    // ========================================================================
    // Hazard Unit Instantiation
    // ========================================================================
    hazard_unit inst_hazard_unit (
        // Branch/Jump control
        .pcsrc_e(pcsrc_e),
        
        // Register addresses from decode stage
        .rs1_d(instr_d_o[19:15]),
        .rs2_d(instr_d_o[24:20]),
        
        // Register addresses from execute stage
        .rd_e(rd_e),
        .rs1_e(rs1_e),
        .rs2_e(rs2_e),
        .resultsrc_e0(resultsrc_e0),
        
        // Register addresses and control from later stages
        .rd_m(rd_m),
        .regwrite_m(regwrite_m),
        .rd_w(rd_w),
        .regwrite_w(regwrite_w),
        
        // Forwarding outputs
        .forward_ae(forward_ae),
        .forward_be(forward_be),
        
        // Stall and flush outputs
        .stall_f(stall_f),
        .stall_d(stall_d),
        .flush_d(flush_d),
        .flush_e(flush_e)
    );

    // ========================================================================
    // Debug Output Assignments (to prevent synthesis optimization)
    // ========================================================================
    assign debug_aluresult = aluresult_w;
    assign debug_stall_f = stall_f;
    assign debug_stall_d = stall_d;
    assign debug_flush_d = flush_d;
    assign debug_flush_e = flush_e;
    assign debug_forward_ae = forward_ae;
    assign debug_forward_be = forward_be;
    assign debug_pcsrc_e = pcsrc_e;
    assign debug_regwrite_w = regwrite_w;
    assign debug_rd_w = rd_w;

    // ========================================================================
    // TEMPORAL LOGIC ASSERTIONS FOR MODEL CHECKING
    // ========================================================================
    
    // Critical Property 1: Stall Propagation
    always @(posedge clk) begin
        if (!reset) begin
            // Stall propagates from fetch to decode
            if (stall_f && !stall_d) begin
                $error("ASSERTION FAILED: stall_f=1 but stall_d=0 - stall not propagated");
            end
            
            // PC enable is inverse of stall
            if (inst_datapath.en_pc != !stall_f) begin
                $error("ASSERTION FAILED: PC enable not inverse of stall_f");
            end
        end
    end
    
    // Critical Property 2: Flush Correctness  
    always @(posedge clk) begin
        if (!reset) begin
            // Branch/Jump causes flush
            if (pcsrc_e && !(flush_d && flush_e)) begin
                $error("ASSERTION FAILED: Branch taken but flush not activated");
            end
        end
    end
    
    // Critical Property 3: Load-Use Hazard Detection
    always @(posedge clk) begin
        if (!reset) begin
            // Load-use hazard should cause stall
            if (resultsrc_e0 && 
                ((instr_d_o[19:15] == rd_e) || (instr_d_o[24:20] == rd_e)) && 
                (rd_e != 5'b0) &&
                !(stall_f && stall_d && flush_e)) begin
                $error("ASSERTION FAILED: Load-use hazard not handled correctly");
            end
        end
    end
    
    // Critical Property 4: No Simultaneous Stall and Flush on Same Stage
    always @(posedge clk) begin
        if (!reset) begin
            if (stall_d && flush_d) begin
                $error("ASSERTION FAILED: Simultaneous stall and flush on decode stage");
            end
        end
    end

endmodule

