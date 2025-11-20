`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2025 07:23:43
// Design Name: 
// Module Name: datapath_tb
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


module datapath_tb;

    // Inputs
    reg        clk;
    reg        en_pc;
    reg        en_fd;
    reg        clr_fd;
    reg        clr_de;
    reg        pcsrc_e;
    reg        reset;
    reg [1:0]  immsrc_d;
    reg        regwrite_d;
    reg [1:0]  resultsrc_d;
    reg        memwrite_d;
    reg        jump_d;
    reg        branch_d;
    reg [2:0]  alucontrol_d;
    reg [1:0]  alusrc_d;
    reg [1:0]  forward_ae;
    reg [1:0]  forward_be;

    // Outputs
    wire [4:0]  rd_w;
    wire        regwrite_w;
    wire [4:0]  rd_e;
    wire        regwrite_m;
    wire [4:0]  rd_m;
    wire [31:0] instr_d;
    wire [31:0] aluresult_w;
    wire        jump_e;
    wire        branch_e;
    wire        zero_e;
    wire [4:0]  rs1_e;
    wire [4:0]  rs2_e;
    wire        resultsrc_e0;

    // Loop variable
    integer i;

    // Instantiate datapath
    datapath inst_datapath (
        .clk(clk),
        .en_pc(en_pc),
        .en_fd(en_fd),
        .clr_fd(clr_fd),
        .clr_de(clr_de),
        .pcsrc_e(pcsrc_e),
        .reset(reset),
        .immsrc_d(immsrc_d),
        .regwrite_d(regwrite_d),
        .resultsrc_d(resultsrc_d),
        .memwrite_d(memwrite_d),
        .jump_d(jump_d),
        .branch_d(branch_d),
        .alucontrol_d(alucontrol_d),
        .alusrc_d(alusrc_d),
        .forward_ae(forward_ae),
        .forward_be(forward_be),
        .rd_w(rd_w),
        .regwrite_w(regwrite_w),
        .rd_e(rd_e),
        .regwrite_m(regwrite_m),
        .rd_m(rd_m),
        .instr_d(instr_d),
        .aluresult_w(aluresult_w),
        .jump_e(jump_e),
        .branch_e(branch_e),
        .zero_e(zero_e),
        .rs1_e(rs1_e),
        .rs2_e(rs2_e),
        .resultsrc_e0(resultsrc_e0)
    );

    // Reset and clock generation
    initial begin
        // Reset sequence
        clk = 1'b0;
        reset = 1'b1;
        #10;
        clk = 1'b1;
        reset = 1'b0;
        #10;

        // Generate 26 clock cycles
        for (i = 1; i <= 26; i = i + 1) begin
            clk = 1'b0;
            #10;
            clk = 1'b1;
            #10;
        end
        
        $display("Datapath testbench completed");
        $finish;
    end

    // Control signals
    initial begin
        regwrite_d = 1'b1;
        immsrc_d = 2'b00;
        alusrc_d = 2'b01;
        memwrite_d = 1'b0;
        resultsrc_d = 2'b00;
        branch_d = 1'b0;
        jump_d = 1'b0;
        alucontrol_d = 3'b000;
        pcsrc_e = 1'b0;
        en_pc = 1'b0;
        en_fd = 1'b0;
        clr_fd = 1'b0;
        clr_de = 1'b0;
        forward_ae = 2'b00;
        forward_be = 2'b00;
    end

    // Generate VCD file
    initial begin
        $dumpfile("datapath_tb.vcd");
        $dumpvars(0, datapath_tb);
    end

    // Monitor outputs
    initial begin
        $monitor("Time=%0t clk=%b reset=%b instr_d=%h rd_w=%b regwrite_w=%b", 
                 $time, clk, reset, instr_d, rd_w, regwrite_w);
    end

endmodule
