`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2025 04:20:51
// Design Name: 
// Module Name: Multiplier_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Testbench for Top Multiplier Module (Both Multiplier Types)
//              Optimized to complete within 1000ns Vivado limit
// 
// Dependencies: Multiplier.v (top module)
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Multiplier_tb();
    
    // Test signals
    reg clk;
    reg reset;
    reg [31:0] multiplicand;
    reg [31:0] multiplier;
    reg multiplier_select;
    reg start;
    
    // Outputs
    wire [63:0] product;
    wire done;
    wire active_multiplier;
    
    // Expected result
    reg [63:0] expected;
    
    // Test tracking
    integer test_count;
    
    // Fast clock generation (2ns period = 500MHz)
    always begin
        clk = 0; #1;
        clk = 1; #1;
    end
    
    // Instantiate DUT (Device Under Test)
    Multiplier uut (
        .clk(clk),
        .reset(reset),
        .multiplicand(multiplicand),
        .multiplier(multiplier),
        .multiplier_select(multiplier_select),
        .start(start),
        .product(product),
        .done(done),
        .active_multiplier(active_multiplier)
    );
    
    // Main test procedure
    initial begin
        // Initialize
        reset = 1;
        start = 0;
        multiplicand = 0;
        multiplier = 0;
        multiplier_select = 0;
        test_count = 0;
        
        // Display header
        $display("=== Top Multiplier Module Test (Both Types) ===");
        $display("Time Budget: 1000ns | Fast Clock: 2ns period");
        $display("Test\tType\tMultiplicand\tMultiplier\tProduct\t\tCycles\tStatus");
        $display("================================================================================");
        
        // Release reset
        #4;
        reset = 0;
        #2;
        
        // Test Set 1: Same inputs for both multipliers (comparison test)
        test_both_multipliers(32'd5, 32'd3, "Set1");
        
        // Test Set 2: Medium numbers
        test_both_multipliers(32'd123, 32'd45, "Set2");
        
        // Test Set 3: Powers of 2
        test_both_multipliers(32'd16, 32'd8, "Set3");
        
        // Test Set 4: Zero test
        test_both_multipliers(32'd456, 32'd0, "Set4");
        
        $display("\n=== Summary ===");
        $display("Total Tests: %0d", test_count);
        $display("Total Time: %0t", $time);
        $display("All tests completed within 1000ns limit!");
        $finish;
    end
    
    // Task to test both multipliers with same inputs
    task test_both_multipliers;
        input [31:0] test_multiplicand;
        input [31:0] test_multiplier;
        input [50:0] test_name;
        
        begin
            // Calculate expected result
            expected = test_multiplicand * test_multiplier;
            
            // Test 1: School Book Multiplier (Combinational)
            test_combinational_multiplier(test_multiplicand, test_multiplier, test_name);
            
            // Test 2: Left Shifting Multiplier (Sequential)
            test_sequential_multiplier(test_multiplicand, test_multiplier, test_name);
        end
    endtask
    
    // Task for testing School Book Multiplier (Combinational)
    task test_combinational_multiplier;
        input [31:0] test_multiplicand;
        input [31:0] test_multiplier;
        input [50:0] test_name;
        
        begin
            // Select School Book Multiplier
            multiplier_select = 1'b0;
            multiplicand = test_multiplicand;
            multiplier = test_multiplier;
            
            // Wait for combinational delay
            #4;
            
            // Check result
            test_count = test_count + 1;
            if (product == expected && done == 1'b1 && active_multiplier == 1'b0) begin
                $display("%s\tSBM\t%0d\t\t%0d\t\t%0d\t\t1\tPASS", 
                         test_name, test_multiplicand, test_multiplier, product);
            end else begin
                $display("%s\tSBM\t%0d\t\t%0d\t\t%0d\t\t1\tFAIL", 
                         test_name, test_multiplicand, test_multiplier, product);
                $display("\t\tExpected: %0d, Got: %0d", expected, product);
            end
            
            #2; // Small gap
        end
    endtask
    
    // Task for testing Left Shifting Multiplier (Sequential)
    task test_sequential_multiplier;
        input [31:0] test_multiplicand;
        input [31:0] test_multiplier;
        input [50:0] test_name;
        
        integer cycle_count;
        begin
            // Select Left Shifting Multiplier
            multiplier_select = 1'b1;
            multiplicand = test_multiplicand;
            multiplier = test_multiplier;
            
            // Start multiplication
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            
            // Wait for completion
            cycle_count = 0;
            while (!done && cycle_count < 35) begin
                @(posedge clk);
                cycle_count = cycle_count + 1;
            end
            
            // Check result
            test_count = test_count + 1;
            if (done && product == expected && active_multiplier == 1'b1) begin
                $display("%s\tLSM\t%0d\t\t%0d\t\t%0d\t\t%0d\tPASS", 
                         test_name, test_multiplicand, test_multiplier, product, cycle_count);
            end else if (!done) begin
                $display("%s\tLSM\t%0d\t\t%0d\t\t%0d\t\t%0d\tTIMEOUT", 
                         test_name, test_multiplicand, test_multiplier, product, cycle_count);
            end else begin
                $display("%s\tLSM\t%0d\t\t%0d\t\t%0d\t\t%0d\tFAIL", 
                         test_name, test_multiplicand, test_multiplier, product, cycle_count);
                $display("\t\tExpected: %0d, Got: %0d", expected, product);
            end
            
            #4; // Gap between tests
        end
    endtask
    
    // Generate VCD for waveform analysis
    initial begin
        $dumpfile("multiplier_tb.vcd");
        $dumpvars(0, Multiplier_tb);
    end
    
endmodule
