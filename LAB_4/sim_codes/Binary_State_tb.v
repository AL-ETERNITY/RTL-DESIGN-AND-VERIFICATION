`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.09.2025 15:25:56
// Design Name: 
// Module Name: Binary_State_tb
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


module Binary_State_tb();

    // Testbench signals
    reg clk;
    reg reset;
    wire [3:0] Q;
    
    // Instantiate the counter
    Binary_State uut (
        .clk(clk),
        .reset(reset),
        .Q(Q)
    );
    
    // Clock generation - 10ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Test sequence
    initial begin
        // Initialize
        reset = 1;
        #20;
        
        // Release reset and observe counter
        reset = 0;
        
        // Monitor for 15 clock cycles
        repeat(15) begin
            #10;
            $display("Time: %0t, Count: %d, Binary: %b", $time, Q, Q);
        end
        
        $finish;
    end
    
endmodule
