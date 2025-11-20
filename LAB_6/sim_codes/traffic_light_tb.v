`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.11.2025 14:19:39
// Design Name: 
// Module Name: traffic_light_tb
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
`timescale 1ns / 1ps
module traffic_light_tb;

    reg clk = 0;
    reg reset_n = 0;
    wire ns_g, ns_y, ns_r;
    wire ew_g, ew_y, ew_r;

    // Instantiate DUT with short cycle times for fast sim
    traffic_light #(.GREEN_CYCLES(5), .YELLOW_CYCLES(2)) dut (
        .clk(clk),
        .reset_n(reset_n),
        .ns_g(ns_g), .ns_y(ns_y), .ns_r(ns_r),
        .ew_g(ew_g), .ew_y(ew_y), .ew_r(ew_r)
    );

    // Clock generation: 10ns period (100 MHz)
    always #5 clk = ~clk;

    // Stimulus
    initial begin
        $display("=== Traffic Light Controller Testbench ===");
        $dumpfile("traffic_wave.vcd");
        $dumpvars(0, traffic_light_tb);

        // Reset
        reset_n = 1;
        #20;
        reset_n = 0;

        // Run simulation for a few state cycles
        #500;
        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("Time=%0t | NS: G=%b Y=%b R=%b || EW: G=%b Y=%b R=%b",
                 $time, ns_g, ns_y, ns_r, ew_g, ew_y, ew_r);
    end

endmodule
