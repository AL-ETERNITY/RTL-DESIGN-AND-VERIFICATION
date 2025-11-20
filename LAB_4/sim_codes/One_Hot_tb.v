`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.09.2025 15:53:49
// Design Name: 
// Module Name: One_Hot_tb
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


module One_Hot_tb();

    // Testbench signals
    reg clk;
    reg reset;
    wire [9:0] Q;
    
    // Instantiate the counter
    One_Hot uut (
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
            $display("Time: %0t, Q: %b", $time, Q);
        end
        
        $finish;
    end
    
endmodule
