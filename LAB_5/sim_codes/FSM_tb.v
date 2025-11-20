`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.10.2025 10:00:59
// Design Name: 
// Module Name: FSM_tb
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


module FSM_tb ;
    reg clk;
    reg reset;
    reg x;
    wire y;

    // Instantiate the DUT (Device Under Test)
    FSM dut (
        .clk(clk),
        .reset(reset),
        .x(x),
        .y(y)
    );

    // Clock generation: 10ns period (100 MHz)
    always #5 clk = ~clk;

    // Apply stimulus
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        x = 0;

        // Hold reset for a few cycles
        #10;
        reset = 0;

        // Input sequence: 111001110011100
        // Expect y = 1 after each "11100" detected
        #10 x = 1;  // 1
        #10 x = 1;  // 11
        #10 x = 1;  // 111
        #10 x = 0;  // 1110
        #10 x = 0;  // 11100 -> DETECTED (y=1)
        #10 x = 1;  // restart
        #10 x = 1;
        #10 x = 1;
        #10 x = 0;
        #10 x = 0;  // DETECTED again
        #10 x = 1;
        #10 x = 1;
        #10 x = 1;
        #10 x = 0;
        #10 x = 0;  // DETECTED again

        // Finish simulation
        #20;
        $finish;
    end

    // Monitor output on console
    initial begin
        $display("Time\tclk\treset\tx\ty\tstate");
        $monitor("%0dns\t%b\t%b\t%b\t%b\t%d", $time, clk, reset, x, y, dut.state);
    end

endmodule
