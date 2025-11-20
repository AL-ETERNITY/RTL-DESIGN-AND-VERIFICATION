`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2025 01:24:18
// Design Name: 
// Module Name: instr_tb
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


module instr_tb;

    // Testbench signals
    reg [31:0] addr_instr;
    wire [31:0] rd_instr;
    
    // Loop variable
    integer i;

    // Instantiate the Unit Under Test (UUT)
    instr_mem inst_instr_mem (
        .addr_instr(addr_instr),
        .rd_instr(rd_instr)
    );

    // Stimulus process
    initial begin
        // Initialize address
        addr_instr = 32'h0000_0000;
        #5;
        
        // Loop through 135 addresses (incrementing by 4 each time)
        for (i = 1; i <= 135; i = i + 1) begin
            addr_instr = addr_instr + 4;
            #5;
        end
        
        // End simulation
        $finish;
    end
    
    // Optional: Monitor for debugging
    initial begin
        $monitor("Time=%0t addr_instr=%h rd_instr=%h", 
                 $time, addr_instr, rd_instr);
    end

endmodule
