`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2025 01:14:41
// Design Name: 
// Module Name: instr_mem
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


module instr_mem (
    input wire [31:0] addr_instr,
    output reg [31:0] rd_instr
);

    // ROM array - 1024 words (0 to 1023) = 4KB
    reg [31:0] mem [0:1023];
    

    initial begin
        $readmemh("c:/Users/Siddhant/Desktop/RTL_DESIGN_AND_VERIFICATION/pipelined_riscv_processor/pipelined_riscv_processor.srcs/sim_1/new/hazard_test.mem", mem);  // Load hazard test program
        $display("Hazard Test: First instruction at address 0: %h", mem[0]);
        $display("Hazard Test: Second instruction at address 1: %h", mem[1]);
        $display("Hazard Test: Load instruction at address 3: %h", mem[3]);
    end

    // Combinational read process
    always @(addr_instr) begin
        rd_instr = mem[addr_instr[31:2]];
    end

endmodule
