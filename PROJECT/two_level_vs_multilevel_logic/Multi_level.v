`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.11.2025 19:03:34
// Design Name: 
// Module Name: Multi_level
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

//=============================================================
// Multilevel Implementation: STALL_data Logic (Factored Form)
//=============================================================
//(* keep_hierarchy = "yes", dont_touch = "yes" *)
//module Multi_level(
//    input  wire EX_RW,
//    input  wire EX_MR,
//    input  wire MEM_RW,
//    input  wire D_EX,
//    input  wire T_EX,
//    input  wire D_MEM,
//    input  wire T_MEM,
//    output wire STALL_data
//);
//    // Preserve internal signals during synthesis
//    (* keep = "true" *) wire A;  // Indicates EX stage writes or reads memory
//    (* keep = "true" *) wire B;  // Indicates ID depends on EX
//    (* keep = "true" *) wire C;  // Indicates ID depends on MEM
//    (* keep = "true" *) wire D;  // Intermediate product term (EX dependency)
//    (* keep = "true" *) wire E;  // Intermediate product term (MEM dependency)
//    (* keep = "true" *) wire STALL_data_int;

//    // Intermediate logic factoring (explicit multilevel structure)
//    assign A = EX_RW | EX_MR;
//    assign B = D_EX | T_EX;
//    assign C = D_MEM | T_MEM;

//    assign D = A & B;
//    assign E = MEM_RW & C;

//    assign STALL_data_int = D | E;

//    // Final output preserved
//    assign STALL_data = STALL_data_int;

//endmodule

//=============================================================
// Multi-Level Implementation: Control Hazard Stall & Flush Logic
// No Optimization version (Vivado synthesis attributes applied)
//=============================================================
//(* keep_hierarchy = "yes", dont_touch = "yes" *)
//module Multi_level(
//    input  wire ID_isBranch,     // ID stage instruction is branch
//    input  wire ID_isJump,       // ID stage instruction is jump
//    input  wire ID_hasDep,       // ID stage instruction has dependency
//    input  wire EX_isBranch,     // EX stage instruction is branch
//    input  wire BranchTaken,     // Branch decision outcome
//    input  wire EX_isJump,       // EX stage instruction is jump
//    output wire STALL_ctrl,      // Control hazard stall signal
//    output wire FLUSH_ctrl       // Control hazard flush signal
//);

//    // Preserve signals from optimization
//    (* keep = "true" *) wire STALL_ctrl_int;
//    (* keep = "true" *) wire FLUSH_ctrl_int;
    
//    (* keep = "true" *) wire A;
    
//    assign A = ID_isBranch | ID_isJump;
//    //=============================
//    // Stall Logic (Two-Level SOP)
//    //=============================
//    // Stall when branch or jump in ID depends on previous instruction
//    assign STALL_ctrl_int = A & ID_hasDep;

//    //=============================
//    // Flush Logic (Two-Level SOP)
//    //=============================
//    // Flush when branch in EX is taken or jump is in EX
//    assign FLUSH_ctrl_int = (EX_isBranch & BranchTaken) | 
//                            (EX_isJump);

//    assign STALL_ctrl = STALL_ctrl_int;
//    assign FLUSH_ctrl = FLUSH_ctrl_int;

//endmodule

//=============================================================
// Multilevel Implementation: Structural Hazard Stall Logic
// No Optimization version (Vivado synthesis attributes applied)
//=============================================================
(* keep_hierarchy = "yes", dont_touch = "yes" *)
module Multi_level (
    input  wire IF_MemReq,
    input  wire MEM_MemReq,
    input  wire ALU_Busy,
    input  wire EX_UsesALU,
    input  wire RF_WriteBusy,
    input  wire ID_UsesRF,
    output wire STALL_struct
);
    // Preserve intermediate terms
    (* keep = "true" *) wire mem_conflict;
    (* keep = "true" *) wire alu_conflict;
    (* keep = "true" *) wire rf_conflict;
    (* keep = "true" *) wire STALL_struct_int;
    (* keep = "true" *) wire A;

    // Factored computation
    assign mem_conflict = IF_MemReq & MEM_MemReq;   // Memory resource conflict
    assign alu_conflict = ALU_Busy & EX_UsesALU;    // ALU busy conflict
    
    assign A = mem_conflict & alu_conflict;
    
    assign rf_conflict  = RF_WriteBusy & ID_UsesRF; // Register file conflict
    
    // Final combined stall signal
    assign STALL_struct_int = A | rf_conflict;

    assign STALL_struct = STALL_struct_int;
    
endmodule
