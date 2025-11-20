`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2025 04:33:25
// Design Name: 
// Module Name: Comparator_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Simple Testbench for 32-bit Comparator
//              Tests both signed and unsigned comparison modes
// 
// Dependencies: Comparator.v
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Comparator_tb();
    
    // Test signals
    reg [31:0] a, b;
    reg signed_mode;
    
    // Outputs
    wire equal;
    wire not_equal;
    wire less_than;
    wire less_equal;
    wire greater_than;
    wire greater_equal;
    
    // Test tracking
    integer test_count;
    
    // Instantiate DUT (Device Under Test)
    Comparator uut (
        .a(a),
        .b(b),
        .signed_mode(signed_mode),
        .equal(equal),
        .not_equal(not_equal),
        .less_than(less_than),
        .less_equal(less_equal),
        .greater_than(greater_than),
        .greater_equal(greater_equal)
    );
    
    // Main test procedure
    initial begin
        // Initialize
        a = 0;
        b = 0;
        signed_mode = 0;
        test_count = 0;
        
        // Display header
        $display("=== 32-bit Comparator Test ===");
        $display("Testing both signed and unsigned modes");
        $display("Test\tA\t\tB\t\tMode\tEQ\tNE\tLT\tLE\tGT\tGE\tStatus");
        $display("==============================================================================");
        
        // Wait for initial stabilization
        #5;
        
        // UNSIGNED TESTS
        $display("\n--- UNSIGNED COMPARISON TESTS ---");
        
        // Test 1: Equal numbers
        test_compare(32'd100, 32'd100, 1'b0, "Test 1");
        
        // Test 2: A < B
        test_compare(32'd50, 32'd100, 1'b0, "Test 2");
        
        // Test 3: A > B
        test_compare(32'd200, 32'd100, 1'b0, "Test 3");
        
        // Test 4: Large unsigned numbers
        test_compare(32'hFFFFFFFF, 32'h7FFFFFFF, 1'b0, "Test 4");
        
        // Test 5: Zero comparison
        test_compare(32'd0, 32'd1, 1'b0, "Test 5");
        
        // SIGNED TESTS
        $display("\n--- SIGNED COMPARISON TESTS ---");
        
        // Test 6: Equal signed numbers
        test_compare(32'd100, 32'd100, 1'b1, "Test 6");
        
        // Test 7: Positive vs Negative
        test_compare(32'd100, 32'hFFFFFFFF, 1'b1, "Test 7"); // 100 vs -1
        
        // Test 8: Both negative
        test_compare(32'hFFFFFFFE, 32'hFFFFFFFF, 1'b1, "Test 8"); // -2 vs -1
        
        // Test 9: Large signed comparison
        test_compare(32'hFFFFFFFF, 32'h7FFFFFFF, 1'b1, "Test 9"); // -1 vs max_positive
        
        // Test 10: Zero vs negative
        test_compare(32'd0, 32'hFFFFFFFF, 1'b1, "Test10"); // 0 vs -1
        
        // Summary
        $display("\n=== Test Summary ===");
        $display("Total Tests: %0d", test_count);
        $display("Simulation Time: %0t", $time);
        $display("All tests completed!");
        $finish;
    end
    
    // Task to perform a comparison test
    task test_compare;
        input [31:0] test_a;
        input [31:0] test_b;
        input test_signed_mode;
        input [100:0] test_name;
        
        reg expected_eq, expected_ne, expected_lt, expected_le, expected_gt, expected_ge;
        reg test_pass;
        
        begin
            // Set inputs
            a = test_a;
            b = test_b;
            signed_mode = test_signed_mode;
            
            // Wait for combinational delay
            #2;
            
            // Calculate expected results
            if (test_signed_mode) begin
                // Signed comparison
                expected_eq = ($signed(test_a) == $signed(test_b));
                expected_ne = ($signed(test_a) != $signed(test_b));
                expected_lt = ($signed(test_a) < $signed(test_b));
                expected_le = ($signed(test_a) <= $signed(test_b));
                expected_gt = ($signed(test_a) > $signed(test_b));
                expected_ge = ($signed(test_a) >= $signed(test_b));
            end else begin
                // Unsigned comparison
                expected_eq = (test_a == test_b);
                expected_ne = (test_a != test_b);
                expected_lt = (test_a < test_b);
                expected_le = (test_a <= test_b);
                expected_gt = (test_a > test_b);
                expected_ge = (test_a >= test_b);
            end
            
            // Check all outputs
            test_pass = (equal == expected_eq) && 
                       (not_equal == expected_ne) &&
                       (less_than == expected_lt) &&
                       (less_equal == expected_le) &&
                       (greater_than == expected_gt) &&
                       (greater_equal == expected_ge);
            
            // Display results
            test_count = test_count + 1;
            $display("%s\t%0d\t\t%0d\t\t%s\t%b\t%b\t%b\t%b\t%b\t%b\t%s", 
                     test_name, 
                     test_a, test_b, 
                     test_signed_mode ? "SGN" : "UNS",
                     equal, not_equal, less_than, less_equal, greater_than, greater_equal,
                     test_pass ? "PASS" : "FAIL");
            
            if (!test_pass) begin
                $display("\t\tExpected: EQ=%b NE=%b LT=%b LE=%b GT=%b GE=%b", 
                         expected_eq, expected_ne, expected_lt, expected_le, expected_gt, expected_ge);
                $display("\t\tGot:      EQ=%b NE=%b LT=%b LE=%b GT=%b GE=%b", 
                         equal, not_equal, less_than, less_equal, greater_than, greater_equal);
            end
            
            #3; // Small gap between tests
        end
    endtask
    
    // Generate VCD file for waveform analysis
    initial begin
        $dumpfile("comparator_tb.vcd");
        $dumpvars(0, Comparator_tb);
    end
    
    // Monitor for debugging
    initial begin
        $monitor("Time=%0t: %0d %s %0d | EQ=%b NE=%b LT=%b LE=%b GT=%b GE=%b", 
                 $time, a, signed_mode ? "vs(signed)" : "vs(unsigned)", b,
                 equal, not_equal, less_than, less_equal, greater_than, greater_equal);
    end
    
endmodule
