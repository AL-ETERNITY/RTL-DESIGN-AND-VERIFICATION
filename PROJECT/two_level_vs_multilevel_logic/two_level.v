`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.11.2025 18:53:34
// Design Name: 
// Module Name: two_level
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
// Two-Level Implementation: STALL_data Logic (No Forwarding)
// No Optimization version (Vivado synthesis attributes applied)
//=============================================================
//(* keep_hierarchy = "yes", dont_touch = "yes" *)
//module two_level(
//    input  wire EX_RW,     // EX stage writes register
//    input  wire EX_MR,     // EX stage performs memory read
//    input  wire MEM_RW,    // MEM stage writes register
//    input  wire D_EX,      // ID.rs1 depends on EX.rd
//    input  wire T_EX,      // ID.rs2 depends on EX.rd
//    input  wire D_MEM,     // ID.rs1 depends on MEM.rd
//    input  wire T_MEM,     // ID.rs2 depends on MEM.rd
//    output wire STALL_data // Stall signal
//);

//    // Prevent optimization on this signal
//    (* keep = "true" *) wire STALL_data_int;

//    // Direct two-level (AND-OR) expression
//    assign STALL_data_int = (EX_RW & D_EX) | (EX_MR & D_EX) |
//                            (EX_RW & T_EX) | (EX_MR & T_EX) |
//                            (MEM_RW & D_MEM) | (MEM_RW & T_MEM);

//    assign STALL_data = STALL_data_int;

//endmodule


//=============================================================
// Two-Level Implementation: Control Hazard Stall & Flush Logic
// No Optimization version (Vivado synthesis attributes applied)
//=============================================================
//(* keep_hierarchy = "yes", dont_touch = "yes" *)
//module two_level(
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

//    //=============================
//    // Stall Logic (Two-Level SOP)
//    //=============================
//    // Stall when branch or jump in ID depends on previous instruction
//    assign STALL_ctrl_int = (ID_isBranch & ID_hasDep) | 
//                            (ID_isJump & ID_hasDep);

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
// Two-Level Implementation: Structural Hazard Stall Logic
// No Optimization version (Vivado synthesis attributes applied)
//=============================================================
(* keep_hierarchy = "yes", dont_touch = "yes" *)
module two_level(
    input  wire IF_MemReq,     // IF stage requests memory
    input  wire MEM_MemReq,    // MEM stage requests memory
    input  wire ALU_Busy,      // ALU currently in use
    input  wire EX_UsesALU,    // EX stage wants to use ALU
    input  wire RF_WriteBusy,  // Register file write in progress
    input  wire ID_UsesRF,     // ID stage wants to read register file
    output wire STALL_struct   // Stall signal for structural hazard
);

    // Preserve internal wire for schematic
    (* keep = "true" *) wire STALL_struct_int;

    // Direct two-level (AND-OR) structure
    assign STALL_struct_int = (IF_MemReq & MEM_MemReq) | 
                              (ALU_Busy & EX_UsesALU)  | 
                              (RF_WriteBusy & ID_UsesRF);

    assign STALL_struct = STALL_struct_int;

endmodule
