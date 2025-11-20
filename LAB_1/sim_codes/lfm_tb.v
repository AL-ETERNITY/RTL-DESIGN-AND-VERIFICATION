`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2025 04:04:29
// Design Name: 
// Module Name: lfm_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Simple Testbench for Left Shifting Multiplier
//              Optimized to complete within 1000ns Vivado limit
// 
// Dependencies: left_shifting_multiplier.v
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module lfm_tb();
    
    // Test signals
    reg clk;
    reg reset;
    reg start;
    reg [31:0] multiplicand;
    reg [31:0] multiplier;
    wire [63:0] product;
    wire done;
    
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
    left_shifting_multiplier uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .multiplicand(multiplicand),
        .multiplier(multiplier),
        .product(product),
        .done(done)
    );
    
    // Main test procedure
    initial begin
        // Initialize
        reset = 1;
        start = 0;
        multiplicand = 0;
        multiplier = 0;
        test_count = 0;
        
        // Display header
        $display("=== Left Shifting Multiplier Test ===");
        $display("Each test takes 32 clock cycles (2ns each = 64ns per test)");
        $display("Test\tMultiplicand\tMultiplier\tProduct\t\t\tCycles\tStatus");
        $display("==============================================================================");
        
        // Release reset
        #4;
        reset = 0;
        #2;
        
        // Test Case 1: Simple multiplication
        test_multiply(32'd5, 32'd3, "Test 1");
        
        // Test Case 2: Multiply by zero
        test_multiply(32'd123, 32'd0, "Test 2");
        
        // Test Case 3: Multiply by one
        test_multiply(32'd456, 32'd1, "Test 3");
        
        // Test Case 4: Small numbers
        test_multiply(32'd12, 32'd15, "Test 4");
        
        // Test Case 5: Powers of 2
        test_multiply(32'd8, 32'd16, "Test 5");
        
        $display("\n=== Test Summary ===");
        $display("Total Tests: %0d", test_count);
        $display("Total Time: %0t", $time);
        $display("All tests completed within 1000ns limit!");
        $finish;
    end
    
    // Task to perform a multiplication test
    task test_multiply;
        input [31:0] test_multiplicand;
        input [31:0] test_multiplier;
        input [100:0] test_name;
        
        integer cycle_count;
        begin
            // Set inputs
            multiplicand = test_multiplicand;
            multiplier = test_multiplier;
            expected = test_multiplicand * test_multiplier;
            
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
            if (done && product == expected) begin
                $display("%s\t%0d\t\t%0d\t\t%0d\t\t%0d\tPASS", 
                         test_name, test_multiplicand, test_multiplier, product, cycle_count);
            end else if (!done) begin
                $display("%s\t%0d\t\t%0d\t\t%0d\t\t%0d\tTIMEOUT", 
                         test_name, test_multiplicand, test_multiplier, product, cycle_count);
            end else begin
                $display("%s\t%0d\t\t%0d\t\t%0d\t\t%0d\tFAIL", 
                         test_name, test_multiplicand, test_multiplier, product, cycle_count);
                $display("\t\tExpected: %0d, Got: %0d", expected, product);
            end
            
            // Small gap between tests
            repeat(2) @(posedge clk);
        end
    endtask
    
    // Generate VCD file for waveform analysis
    initial begin
        $dumpfile("lfm_tb.vcd");
        $dumpvars(0, lfm_tb);
    end
    
endmodule
