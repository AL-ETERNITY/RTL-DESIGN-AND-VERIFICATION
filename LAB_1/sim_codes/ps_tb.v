`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2025 04:50:39
// Design Name: 
// Module Name: ps_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Testbench for 32-bit Parallel Subtractor
//              Tests various subtraction scenarios including edge cases
//              Optimized to complete within Vivado's 1000ns simulation limit
// 
// Dependencies: parallel_Subtractor.v
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// Tests include: basic subtraction, edge cases, overflow conditions
//////////////////////////////////////////////////////////////////////////////////

module ps_tb();

    // Testbench signals
    reg [31:0] a, b;           // Input operands
    reg bin;                   // Borrow input
    wire [31:0] diff;          // Difference output
    wire bout;                 // Borrow output
    
    // Golden reference for verification
    reg [31:0] expected_diff;
    reg expected_bout;
    
    // Test control
    integer test_count;
    integer pass_count;
    integer fail_count;
    
    // Instantiate the parallel subtractor
    parallel_Subtractor uut (
        .a(a),
        .b(b),
        .bin(bin),
        .diff(diff),
        .bout(bout)
    );
    
    // Golden reference calculation
    always @(*) begin
        // Calculate expected result using Verilog subtraction
        {expected_bout, expected_diff} = {1'b0, a} - {1'b0, b} - bin;
        // Note: bout = 1 when borrow is needed (a < b + bin)
        expected_bout = (a < (b + bin));
    end
    
    // Test procedure
    initial begin
        // Initialize
        test_count = 0;
        pass_count = 0;
        fail_count = 0;
        a = 0;
        b = 0;
        bin = 0;
        
        $display("=== Parallel Subtractor Testbench Started ===");
        $display("Time: %0t", $time);
        
        // Wait for initial settling
        #5;
        
        // Test 1: Basic subtraction (15 - 10 = 5)
        test_subtraction(32'd15, 32'd10, 1'b0, "Basic subtraction (15-10)");
        
        // Test 2: Zero difference (25 - 25 = 0)
        test_subtraction(32'd25, 32'd25, 1'b0, "Zero difference (25-25)");
        
        // Test 3: Subtract from zero (0 - 5, requires borrow)
        test_subtraction(32'd0, 32'd5, 1'b0, "Subtract from zero (0-5)");
        
        // Test 4: Large numbers
        test_subtraction(32'h12345678, 32'h87654321, 1'b0, "Large numbers");
        
        // Test 5: Maximum values
        test_subtraction(32'hFFFFFFFF, 32'h00000001, 1'b0, "Max minus 1");
        
        // Test 6: With borrow input
        test_subtraction(32'd100, 32'd50, 1'b1, "With borrow input");
        
        // Test 7: Edge case - subtract larger from smaller
        test_subtraction(32'd10, 32'd20, 1'b0, "Smaller - Larger (10-20)");
        
        // Test 8: Powers of 2
        test_subtraction(32'h10000000, 32'h08000000, 1'b0, "Powers of 2");
        
        // Test 9: All ones minus all zeros
        test_subtraction(32'hFFFFFFFF, 32'h00000000, 1'b0, "All 1s - All 0s");
        
        // Test 10: Random pattern
        test_subtraction(32'hA5A5A5A5, 32'h5A5A5A5A, 1'b0, "Pattern test");
        
        // Final results
        #50;
        $display("\n=== Test Results Summary ===");
        $display("Total Tests: %0d", test_count);
        $display("Passed: %0d", pass_count);
        $display("Failed: %0d", fail_count);
        $display("Success Rate: %0d%%", (pass_count * 100) / test_count);
        
        if (fail_count == 0) begin
            $display("*** ALL TESTS PASSED! ***");
        end else begin
            $display("*** SOME TESTS FAILED! ***");
        end
        
        $display("Simulation completed at time: %0t", $time);
        $finish;
    end
    
    // Task to perform individual test
    task test_subtraction;
        input [31:0] test_a;
        input [31:0] test_b;
        input test_bin;
        input [255:0] test_name;
        
        begin
            test_count = test_count + 1;
            
            // Apply inputs
            a = test_a;
            b = test_b;
            bin = test_bin;
            
            // Wait for propagation (combinational circuit)
            #10;
            
            // Check results
            if (diff == expected_diff && bout == expected_bout) begin
                pass_count = pass_count + 1;
                $display("PASS - %s: %d - %d - %d = %d (bout=%b) at %0t", 
                         test_name, test_a, test_b, test_bin, diff, bout, $time);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL - %s: %d - %d - %d", test_name, test_a, test_b, test_bin);
                $display("      Expected: diff=%d, bout=%b", expected_diff, expected_bout);
                $display("      Got:      diff=%d, bout=%b", diff, bout);
                $display("      Time: %0t", $time);
            end
            
            #5; // Small delay between tests
        end
    endtask
    
    // Monitor for debugging
    initial begin
        $monitor("Time=%0t: a=%h, b=%h, bin=%b -> diff=%h, bout=%b", 
                 $time, a, b, bin, diff, bout);
    end
    
    // Generate VCD file for waveform viewing
    initial begin
        $dumpfile("ps_tb.vcd");
        $dumpvars(0, ps_tb);
    end
    
    // Timeout protection (should complete well within 1000ns)
    initial begin
        #950;
        $display("WARNING: Testbench approaching timeout at %0t", $time);
        #50;
        $display("ERROR: Testbench timed out!");
        $finish;
    end

endmodule
