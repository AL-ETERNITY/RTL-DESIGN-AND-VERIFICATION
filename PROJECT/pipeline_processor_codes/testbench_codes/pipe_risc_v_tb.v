`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2025 04:14:00
// Design Name: 
// Module Name: pipe_risc_v_tb
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

// Pipelined RISC-V Processor Testbench
// Converted from VHDL to Verilog


module pipe_risc_v_tb;

    // Testbench signals
    reg clk;
    reg reset;
    
    // Debug output wires to connect to processor debug outputs
    wire [31:0] debug_aluresult;
    wire debug_stall_f;
    wire debug_stall_d;
    wire debug_flush_d;
    wire debug_flush_e;
    wire [1:0] debug_forward_ae;
    wire [1:0] debug_forward_be;
    wire debug_pcsrc_e;
    wire debug_regwrite_w;
    wire [4:0] debug_rd_w;
    
    // Loop variable
    integer i;

    // Instantiate the pipelined RISC-V processor
    pipe_risc_v inst_pipelined_risc_v (
        .clk(clk),
        .reset(reset),
        
        // Connect debug outputs
        .debug_aluresult(debug_aluresult),
        .debug_stall_f(debug_stall_f),
        .debug_stall_d(debug_stall_d),
        .debug_flush_d(debug_flush_d),
        .debug_flush_e(debug_flush_e),
        .debug_forward_ae(debug_forward_ae),
        .debug_forward_be(debug_forward_be),
        .debug_pcsrc_e(debug_pcsrc_e),
        .debug_regwrite_w(debug_regwrite_w),
        .debug_rd_w(debug_rd_w)
    );

    // Test stimulus
    initial begin
        // Initialize signals
        clk = 1'b1;
        reset = 1'b1;
        #1;
        
        clk = 1'b0;
        reset = 1'b0;
        #1;

        // Run for 50 clock cycles (sufficient for hazard test program)
        for (i = 1; i <= 50; i = i + 1) begin
            clk = 1'b1;
            #5;
            clk = 1'b0;
            #5;
        end
        
        $display("Simulation completed after 50 clock cycles");
        $finish;
    end

    // Generate VCD file for waveform viewing
    initial begin
        $dumpfile("pipe_risc_v_tb.vcd");
        $dumpvars(0, pipe_risc_v_tb);
    end

    // Monitor internal processor signals using debug outputs
    initial begin
        $monitor("Time=%0t clk=%b reset=%b PC=%h Instr=%h stall_f=%b pcsrc_e=%b", 
                 $time, clk, reset, 
                 inst_pipelined_risc_v.inst_datapath.pcf_buf,
                 inst_pipelined_risc_v.inst_datapath.instr_d,
                 debug_stall_f,
                 debug_pcsrc_e);
    end
    
    // Debug hazard unit inputs and outputs using debug signals
    always @(posedge clk) begin
        if (!reset) begin
            $display("HAZARD: rs1_d=%h rs2_d=%h rd_e=%h resultsrc_e0=%b stall_f=%b stall_d=%b flush_d=%b flush_e=%b forward_ae=%b forward_be=%b",
                     inst_pipelined_risc_v.inst_datapath.instr_d[19:15],
                     inst_pipelined_risc_v.inst_datapath.instr_d[24:20],
                     debug_rd_w,  // Using debug output
                     inst_pipelined_risc_v.resultsrc_e0,
                     debug_stall_f,
                     debug_stall_d,
                     debug_flush_d,
                     debug_flush_e,
                     debug_forward_ae,
                     debug_forward_be);
            
            // Show when hazards are detected using debug outputs
            if (debug_stall_f || debug_stall_d) begin
                $display("*** STALL DETECTED: Load-use hazard ***");
            end
            if (debug_flush_d || debug_flush_e) begin
                $display("*** FLUSH DETECTED: Control hazard ***");
            end
            if (debug_forward_ae != 2'b00 || debug_forward_be != 2'b00) begin
                $display("*** FORWARDING ACTIVE: Data hazard resolved ***");
            end
            
            // Display ALU result from debug output
            if (debug_regwrite_w) begin
                $display("ALU Result: %h written to register x%d", debug_aluresult, debug_rd_w);
            end
        end
    end

    // Monitor register file contents (first 8 registers)
    always @(posedge clk) begin
        if (!reset) begin
            $display("Cycle %0d: x1=%h x2=%h x3=%h x4=%h x5=%h x6=%h x7=%h x8=%h", 
                     ($time-2)/10,
                     inst_pipelined_risc_v.inst_datapath.inst_reg_file.reg_bank1[1],
                     inst_pipelined_risc_v.inst_datapath.inst_reg_file.reg_bank1[2],
                     inst_pipelined_risc_v.inst_datapath.inst_reg_file.reg_bank1[3],
                     inst_pipelined_risc_v.inst_datapath.inst_reg_file.reg_bank1[4],
                     inst_pipelined_risc_v.inst_datapath.inst_reg_file.reg_bank1[5],
                     inst_pipelined_risc_v.inst_datapath.inst_reg_file.reg_bank1[6],
                     inst_pipelined_risc_v.inst_datapath.inst_reg_file.reg_bank1[7],
                     inst_pipelined_risc_v.inst_datapath.inst_reg_file.reg_bank1[8]);
        end
    end

    // Monitor ALU operations
    always @(posedge clk) begin
        if (!reset && inst_pipelined_risc_v.inst_datapath.inst_alu.aluresult != 32'h0) begin
            $display("ALU: SrcA=%h SrcB=%h Control=%b Result=%h Zero=%b",
                     inst_pipelined_risc_v.inst_datapath.inst_alu.SrcA,
                     inst_pipelined_risc_v.inst_datapath.inst_alu.SrcB,
                     inst_pipelined_risc_v.inst_datapath.inst_alu.ALUControl,
                     inst_pipelined_risc_v.inst_datapath.inst_alu.aluresult,
                     inst_pipelined_risc_v.inst_datapath.inst_alu.Zero);
        end
    end

endmodule
