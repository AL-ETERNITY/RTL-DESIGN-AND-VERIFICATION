`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2025 03:48:27
// Design Name: 
// Module Name: sbm_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Simple Testbench for School Book Multiplier
//              Optimized to complete within 1000ns Vivado limit
// 
// Dependencies: school_book_multiplier.v
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module sbm_tb();
    
    // Test signals
    reg [31:0] multiplicand;    // Input A
    reg [31:0] multiplier;      // Input B
    wire [63:0] product;        // Output A × B
    
    // Expected result for verification
    reg [63:0] expected;
    
    // Test counter
    integer test_count;
    
    // Instantiate DUT (Device Under Test)
    school_book_multiplier uut (
        .multiplicand(multiplicand),
        .multiplier(multiplier),
        .product(product)
    );
    
    // Main test procedure
    initial begin
        // Initialize
        multiplicand = 0;
        multiplier = 0;
        test_count = 0;
        
        // Display header
        $display("=== School Book Multiplier Test ===");
        $display("Combinational multiplier - results available immediately");
        $display("Test\tMultiplicand\tMultiplier\tProduct\t\t\tExpected\t\tStatus");
        $display("====================================================================================");
        
        // Wait for initial stabilization
        #10;
        
        // Test Case 1: Simple multiplication
        test_multiply(32'd5, 32'd3, "Test 1");
        
        // Test Case 2: Multiply by zero
        test_multiply(32'd1234, 32'd0, "Test 2");
        
        // Test Case 3: Multiply by one
        test_multiply(32'd5678, 32'd1, "Test 3");
        
        // Test Case 4: Small numbers
        test_multiply(32'd12, 32'd15, "Test 4");
        
        // Test Case 5: Medium numbers
        test_multiply(32'd123, 32'd456, "Test 5");
        
        // Test Case 6: Larger numbers
        test_multiply(32'd1000, 32'd2000, "Test 6");
        
        // Test Case 7: Powers of 2
        test_multiply(32'd16, 32'd32, "Test 7");
        
        // Test Case 8: One large, one small
        test_multiply(32'd65535, 32'd10, "Test 8");
        
        // Test Case 9: Both moderately large
        test_multiply(32'd12345, 32'd6789, "Test 9");
        
        // Test Case 10: Maximum reasonable size (to avoid overflow display issues)
        test_multiply(32'd65535, 32'd65535, "Test10");
        
        // Summary
        $display("\n=== Test Summary ===");
        $display("Total Tests: %0d", test_count);
        $display("Simulation Time: %0t", $time);
        $display("All tests completed within 1000ns limit!");
        $finish;
    end
    
    // Task to perform a multiplication test
    task test_multiply;
        input [31:0] test_multiplicand;
        input [31:0] test_multiplier;
        input [100:0] test_name;
        
        begin
            // Set inputs
            multiplicand = test_multiplicand;
            multiplier = test_multiplier;
            
            // Calculate expected result (Verilog built-in multiplication)
            expected = test_multiplicand * test_multiplier;
            
            // Wait for combinational delay
            #5;
            
            // Check result
            test_count = test_count + 1;
            if (product == expected) begin
                $display("%s\t%0d\t\t%0d\t\t%0d\t\t%0d\t\tPASS", 
                         test_name, test_multiplicand, test_multiplier, product, expected);
            end else begin
                $display("%s\t%0d\t\t%0d\t\t%0d\t\t%0d\t\tFAIL", 
                         test_name, test_multiplicand, test_multiplier, product, expected);
                $display("\t\tMismatch: Expected %0d, Got %0d", expected, product);
            end
            
            // Small gap between tests
            #5;
        end
    endtask
    
    // Generate VCD file for waveform analysis
    initial begin
        $dumpfile("sbm_tb.vcd");
        $dumpvars(0, sbm_tb);
    end
    
    // Optional: Monitor for debugging
    initial begin
        $monitor("Time=%0t: %0d × %0d = %0d", $time, multiplicand, multiplier, product);
    end
    
endmodule
