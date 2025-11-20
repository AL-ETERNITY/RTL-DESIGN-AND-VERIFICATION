`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2025 02:24:29
// Design Name: 
// Module Name: datapath
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



// ============================================================================
// RISC-V Pipelined Datapath
// ============================================================================
module datapath (
    // Inputs
    input wire clk,
    input wire reset,
    input wire en_pc,
    input wire en_fd,
    input wire clr_fd,
    input wire clr_de,
    input wire pcsrc_e,
    input wire [1:0] immsrc_d,
    input wire regwrite_d,
    input wire [1:0] resultsrc_d,
    input wire memwrite_d,
    input wire jump_d,
    input wire branch_d,
    input wire [2:0] alucontrol_d,
    input wire [1:0] alusrc_d,
    input wire [1:0] forward_ae,
    input wire [1:0] forward_be,
    
    // Buffers (inout equivalents)
    output wire [4:0] rd_w,
    output wire regwrite_w,
    output wire [4:0] rd_e,
    output wire regwrite_m,
    output wire [4:0] rd_m,
    output wire [31:0] instr_d,
    output wire [31:0] aluresult_w,
    
    // Outputs
    output wire jump_e,
    output wire branch_e,
    output wire zero_e,
    output wire [4:0] rs1_e,
    output wire [4:0] rs2_e,
    output wire resultsrc_e0
);

    // Internal signals
    wire not_clk;
    wire [31:0] pcplus4_f;
    wire [31:0] pctarget_e;
    wire [31:0] pcf_in;
    wire [31:0] pcf_buf;
    wire [31:0] rd_instr;
    wire [31:0] pc_d;
    wire [31:0] pcplus4_d;
    wire [31:0] result_w;
    wire [31:0] rd1;
    wire [31:0] rd2;
    wire [31:0] immext_d;
    wire [31:0] rd1_e;
    wire [31:0] rd2_e;
    wire regwrite_e_internal;
    wire memwrite_e;
    wire [2:0] alucontrol_e;
    wire [1:0] alusrc_e;
    wire [31:0] pcplus4_e;
    wire [31:0] aluresult_m;
    wire [31:0] forward_ae_mux_o;
    wire [31:0] forward_be_mux_o;
    wire [31:0] aluresult_e;
    wire [1:0] resultsrc_m;
    wire memwrite_m_internal;
    wire [31:0] writedata_m;
    wire [31:0] pcplus4_m;
    wire [1:0] resultsrc_w;
    wire [31:0] readdata_w;
    wire [31:0] pcplus4_w;
    wire [31:0] rd_memr;
    wire [31:0] immext_e;
    wire [31:0] pc_e;
    wire [31:0] srcb_e;
    wire [31:0] writedata_e;
    wire [1:0] resultsrc_e;
    wire [19:0] instr31_12_e;
    wire [31:0] instr31_12_0;

    // ========================================================================
    // FETCH STAGE
    // ========================================================================
    
    // PC Source Multiplexer
    mux_2 #(.number(32)) inst_mux (
        .a(pcplus4_f),
        .b(pctarget_e),
        .sel(pcsrc_e),
        .y(pcf_in)
    );

    // Program Counter
    pc inst_pc (
        .clk(clk),
        .reset(reset),
        .PCNext(pcf_in),
        .PC_cur(pcf_buf),
        .en(en_pc)
    );

    // Instruction Memory
    instr_mem inst_instr_mem (
        .addr_instr(pcf_buf),
        .rd_instr(rd_instr)
    );

    // PC + 4 Adder
    adder inst_pcplus4 (
        .a_in(pcf_buf),
        .b_in(32'h00000004),
        .c_out(pcplus4_f)
    );

    // ========================================================================
    // FETCH/DECODE PIPELINE REGISTER
    // ========================================================================
    
    reg_fd inst_reg_fd (
        .clk(clk),
        .en(en_fd),
        .clr(clr_fd),
        .rd(rd_instr),
        .pc_f(pcf_buf),
        .pcplus4_f(pcplus4_f),
        .instr_d(instr_d),
        .pc_d(pc_d),
        .pcplus4_d(pcplus4_d)
    );

    // ========================================================================
    // DECODE STAGE
    // ========================================================================
    
    // Register File (inverted clock for write)
    assign not_clk = ~clk;
    reg_file inst_reg_file (
        .read_port_addr1(instr_d[19:15]),
        .read_port_addr2(instr_d[24:20]),
        .write_port_addr(rd_w),
        .write_data(result_w),
        .write_en(regwrite_w),
        .clk(not_clk),
        .read_data1(rd1),
        .read_data2(rd2)
    );

    // Immediate Extension
    extend inst_extend (
        .ImmSrc(immsrc_d),
        .instruction(instr_d[31:7]),
        .ImmExt(immext_d)
    );

    // ========================================================================
    // DECODE/EXECUTE PIPELINE REGISTER
    // ========================================================================
    
    reg_de inst_reg_de (
        .clk(clk),
        .clr_de(clr_de),
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
        .rs1_d(instr_d[19:15]),
        .rs2_d(instr_d[24:20]),
        .rd_d(instr_d[11:7]),
        .instr31_12_d(instr_d[31:12]),
        .immext_d(immext_d),
        .pcplus4_d(pcplus4_d),
        .regwrite_e(regwrite_e_internal),
        .resultsrc_e(resultsrc_e),
        .memwrite_e(memwrite_e),
        .jump_e(jump_e),
        .branch_e(branch_e),
        .alucontrol_e(alucontrol_e),
        .alusrc_e(alusrc_e),
        .rd1_e(rd1_e),
        .rd2_e(rd2_e),
        .pc_e(pc_e),
        .instr31_12_e(instr31_12_e),
        .rs1_e(rs1_e),
        .rs2_e(rs2_e),
        .rd_e(rd_e),
        .immext_e(immext_e),
        .pcplus4_e(pcplus4_e)
    );

    // Extract resultsrc_e[0]
    assign resultsrc_e0 = resultsrc_e[0];

    // ========================================================================
    // EXECUTE STAGE
    // ========================================================================
    
    // Forwarding Multiplexer for SrcA
    mux_3 #(.N(32)) inst_mux_3_src_ae (
        .a(rd1_e),
        .b(result_w),
        .c(aluresult_m),
        .sel(forward_ae),
        .y(forward_ae_mux_o)
    );

    // Forwarding Multiplexer for SrcB
    mux_3 #(.N(32)) inst_mux_3_src_be (
        .a(rd2_e),
        .b(result_w),
        .c(aluresult_m),
        .sel(forward_be),
        .y(forward_be_mux_o)
    );

    // Prepare upper immediate (instr[31:12] concatenated with 12 zeros)
    assign instr31_12_0 = {instr31_12_e, 12'b0};

    // ALU Source B Multiplexer
    mux_3 #(.N(32)) inst_mux_3_alu_src (
        .a(forward_be_mux_o),
        .b(immext_e),
        .c(instr31_12_0),
        .sel(alusrc_e),
        .y(srcb_e)
    );

    // PC Target Adder (PC + Immediate)
    adder inst_adder (
        .a_in(pc_e),
        .b_in(immext_e),
        .c_out(pctarget_e)
    );

    // ALU
    alu inst_alu (
        .SrcA(forward_ae_mux_o),
        .SrcB(srcb_e),
        .ALUControl(alucontrol_e),
        .Zero(zero_e),
        .aluresult(aluresult_e)
    );

    // ========================================================================
    // EXECUTE/MEMORY PIPELINE REGISTER
    // ========================================================================
    
    assign writedata_e = forward_be_mux_o;
    reg_em inst_reg_em (
        .clk(clk),
        .regwrite_e(regwrite_e_internal),
        .resultsrc_e(resultsrc_e),
        .memwrite_e(memwrite_e),
        .aluresult(aluresult_e),
        .writedata_e(writedata_e),
        .rd_e(rd_e),
        .pcplus4_e(pcplus4_e),
        .regwrite_m(regwrite_m),
        .resultsrc_m(resultsrc_m),
        .memwrite_m(memwrite_m_internal),
        .aluresult_m(aluresult_m),
        .writedata_m(writedata_m),
        .rd_m(rd_m),
        .pcplus4_m(pcplus4_m)
    );

    // ========================================================================
    // MEMORY STAGE
    // ========================================================================
    
    // Data Memory
    data_memr inst_data_memr (
        .clk(clk),
        .memwrite_m(memwrite_m_internal),
        .rw_addr(aluresult_m),
        .w_data(writedata_m),
        .read_data_m(rd_memr)
    );

    // ========================================================================
    // MEMORY/WRITEBACK PIPELINE REGISTER
    // ========================================================================
    
    reg_mw inst_reg_mw (
        .clk(clk),
        .regwrite_m(regwrite_m),
        .resultsrc_m(resultsrc_m),
        .aluresult_m(aluresult_m),
        .rd(rd_memr),
        .rd_m(rd_m),
        .pcplus4_m(pcplus4_m),
        .regwrite_w(regwrite_w),
        .resultsrc_w(resultsrc_w),
        .aluresult_w(aluresult_w),
        .readdata_w(readdata_w),
        .rd_w(rd_w),
        .pcplus4_w(pcplus4_w)
    );

    // ========================================================================
    // WRITEBACK STAGE
    // ========================================================================
    
    // Result Multiplexer
    mux_3 #(.N(32)) inst_mux_3 (
        .a(aluresult_w),
        .b(readdata_w),
        .c(pcplus4_w),
        .sel(resultsrc_w),
        .y(result_w)
    );

endmodule

