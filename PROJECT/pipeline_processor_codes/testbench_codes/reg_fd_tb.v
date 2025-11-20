`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2025 04:55:18
// Design Name: 
// Module Name: reg_fd_tb
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


module reg_fd_tb;

    // Inputs
    reg        clk;
    reg [31:0] rd;
    reg [31:0] pc_f;
    reg [31:0] pcplus4_f;
    reg        clr;
    reg        en;

    // Outputs
    wire [31:0] instr_d;
    wire [31:0] pc_d;
    wire [31:0] pcplus4_d;

    // Loop variable
    integer i;

    // Instantiate reg_fd
    reg_fd inst_reg_fd (
        .clk(clk),
        .rd(rd),
        .pc_f(pc_f),
        .pcplus4_f(pcplus4_f),
        .instr_d(instr_d),
        .pc_d(pc_d),
        .pcplus4_d(pcplus4_d),
        .clr(clr),
        .en(en)
    );

    // Control signals
    initial begin
        en = 1'b0;
        clr = 1'b1;
        #25;
        clr = 1'b0;
    end

    // Clock generation
    initial begin
        // Generate 26 clock cycles
        for (i = 1; i <= 26; i = i + 1) begin
            clk = 1'b1;
            #10;
            clk = 1'b0;
            #10;
        end
        $finish;
    end

    // Test stimulus
    initial begin
        rd = 32'hFFFFFFFF;
        pc_f = 32'h00000001;
        pcplus4_f = 32'h00000005;
        #10;
        rd = 32'hFFFFFFF1;
        pc_f = 32'hFFFFFFF5;
        pcplus4_f = 32'hFFFFFFFA;
        #31;
        rd = 32'h00000004;
        pc_f = 32'h00001004;
        pcplus4_f = 32'h00A00004;
        #41;
    end

    // Generate VCD file
    initial begin
        $dumpfile("reg_fd_tb.vcd");
        $dumpvars(0, reg_fd_tb);
    end

    // Monitor outputs
    initial begin
        $monitor("Time=%0t clk=%b en=%b clr=%b instr_d=%h pc_d=%h", 
                 $time, clk, en, clr, instr_d, pc_d);
    end

endmodule

