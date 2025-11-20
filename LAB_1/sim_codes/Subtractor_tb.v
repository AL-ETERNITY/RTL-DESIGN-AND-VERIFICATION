`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2025 05:09:11
// Design Name: 
// Module Name: Subtractor_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Testbench for Top-level 32-bit Subtractor Module
//              Tests both Parallel (sel=0) and Serial (sel=1) modes
//              Verifies selection mechanism and unified interface
//              Optimized to complete within Vivado's 1000ns simulation limit
// 
// Dependencies: Subtractor.v, parallel_Subtractor.v, Serial_Subtractor.v
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// Tests both combinational (parallel) and sequential (serial) operations
// Fast clock (4ns period) for efficient serial testing
//////////////////////////////////////////////////////////////////////////////////

module Subtractor_tb();

    // Testbench signals
    reg clk;                    // Clock signal
    reg reset;                  // Reset signal
    reg sel;                    // Subtractor selection
    reg start;                  // Start signal
    reg [31:0] a, b;           // Input operands
    reg bin;                   // Borrow input
    wire [31:0] diff;          // Difference output
    wire bout;                 // Borrow output
    wire done;                 // Operation complete flag
    
    // Golden reference for verification
    reg [31:0] expected_diff;
    reg expected_bout;
    
    // Test control
    integer test_count;
    integer pass_count;
    integer fail_count;
    integer parallel_tests;
    integer serial_tests;
    
    // Clock generation (4ns period for fast serial operation)
    initial begin
        clk = 0;
        forever #2 clk = ~clk;  // 4ns period, 250MHz
    end
    
    // Instantiate the top-level Subtractor
    Subtractor uut (
        .clk(clk),
        .reset(reset),
        .sel(sel),
        .start(start),
        .a(a),
        .b(b),
        .bin(bin),
        .diff(diff),
        .bout(bout),
        .done(done)
    );
    
    // Golden reference calculation
    task calculate_expected;
        input [31:0] test_a;
        input [31:0] test_b;
        input test_bin;
        begin
            // Calculate expected result using Verilog subtraction
            {expected_bout, expected_diff} = {1'b0, test_a} - {1'b0, test_b} - test_bin;
            // Note: bout = 1 when borrow is needed (a < b + bin)
            expected_bout = (test_a < (test_b + test_bin));
        end
    endtask
    
    // Test procedure
    initial begin
        // Initialize
        test_count = 0;
        pass_count = 0;
        fail_count = 0;
        parallel_tests = 0;
        serial_tests = 0;
        reset = 1;
        sel = 0;
        start = 0;
        a = 0;
        b = 0;
        bin = 0;
        
        $display("=== Top-level Subtractor Testbench Started ===");
        $display("Testing both Parallel (sel=0) and Serial (sel=1) modes");
        $display("Clock Period: 4ns, Target: Complete within 1000ns");
        $display("Time: %0t", $time);
        
        // Reset sequence
        #10;
        reset = 0;
        #10;
        
        $display("\n=== PARALLEL SUBTRACTOR TESTS (sel=0) ===");
        
        // Parallel Mode Tests
        sel = 0;  // Select parallel subtractor
        
        // Test 1: Basic subtraction (parallel)
        test_parallel_subtraction(32'd100, 32'd25, 1'b0, "Parallel Basic (100-25)");
        
        // Test 2: Zero difference (parallel)
        test_parallel_subtraction(32'd50, 32'd50, 1'b0, "Parallel Zero diff (50-50)");
        
        // Test 3: Negative result (parallel)
        test_parallel_subtraction(32'd10, 32'd30, 1'b0, "Parallel Negative (10-30)");
        
        // Test 4: Large numbers (parallel)
        test_parallel_subtraction(32'hFFFFFFFF, 32'h12345678, 1'b0, "Parallel Large numbers");
        
        // Test 5: With borrow input (parallel)
        test_parallel_subtraction(32'd200, 32'd100, 1'b1, "Parallel With borrow");
        
        $display("\n=== SERIAL SUBTRACTOR TESTS (sel=1) ===");
        
        // Serial Mode Tests
        sel = 1;  // Select serial subtractor
        
        // Test 6: Basic subtraction (serial)
        test_serial_subtraction(32'd100, 32'd25, 1'b0, "Serial Basic (100-25)");
        
        // Test 7: Zero difference (serial)
        test_serial_subtraction(32'd50, 32'd50, 1'b0, "Serial Zero diff (50-50)");
        
        // Test 8: With borrow input (serial)
        test_serial_subtraction(32'd150, 32'd75, 1'b1, "Serial With borrow");
        
        $display("\n=== SELECTION MECHANISM TEST ===");
        
        // Test 9: Compare parallel vs serial results (should be identical)
        test_comparison(32'd1000, 32'd333, 1'b0, "Selection Comparison");
        
        // Final results
        #20;
        $display("\n=== Test Results Summary ===");
        $display("Total Tests: %0d", test_count);
        $display("  Parallel Tests: %0d", parallel_tests);
        $display("  Serial Tests: %0d", serial_tests);
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
    
    // Task to test parallel subtractor mode
    task test_parallel_subtraction;
        input [31:0] test_a;
        input [31:0] test_b;
        input test_bin;
        input [255:0] test_name;
        
        begin
            test_count = test_count + 1;
            parallel_tests = parallel_tests + 1;
            
            $display("\nTesting %s at time %0t", test_name, $time);
            
            // Calculate expected result
            calculate_expected(test_a, test_b, test_bin);
            
            // Apply inputs
            sel = 0;  // Parallel mode
            a = test_a;
            b = test_b;
            bin = test_bin;
            
            // Wait for combinational delay
            #5;
            
            // Check results (should be ready immediately)
            if (done && diff == expected_diff && bout == expected_bout) begin
                pass_count = pass_count + 1;
                $display("PASS - %s: %d - %d - %d = %d (bout=%b)", 
                         test_name, test_a, test_b, test_bin, diff, bout);
                $display("      Mode: Parallel (Combinational)");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL - %s: %d - %d - %d", test_name, test_a, test_b, test_bin);
                $display("      Expected: diff=%d, bout=%b, done=%b", expected_diff, expected_bout, 1'b1);
                $display("      Got:      diff=%d, bout=%b, done=%b", diff, bout, done);
            end
            
            #5; // Small delay between tests
        end
    endtask
    
    // Task to test serial subtractor mode
    task test_serial_subtraction;
        input [31:0] test_a;
        input [31:0] test_b;
        input test_bin;
        input [255:0] test_name;
        
        integer start_time;
        integer end_time;
        integer local_cycles;
        
        begin
            test_count = test_count + 1;
            serial_tests = serial_tests + 1;
            start_time = $time;
            local_cycles = 0;
            
            $display("\nTesting %s at time %0t", test_name, $time);
            
            // Calculate expected result
            calculate_expected(test_a, test_b, test_bin);
            
            // Apply inputs
            sel = 1;  // Serial mode
            a = test_a;
            b = test_b;
            bin = test_bin;
            
            // Wait for stable inputs
            @(posedge clk);
            
            // Start the operation
            start = 1;
            @(posedge clk);
            start = 0;
            
            // Wait for completion (with timeout protection)
            while (!done && local_cycles < 40) begin
                @(posedge clk);
                local_cycles = local_cycles + 1;
            end
            
            end_time = $time;
            
            // Check results
            if (done && diff == expected_diff && bout == expected_bout) begin
                pass_count = pass_count + 1;
                $display("PASS - %s: %d - %d - %d = %d (bout=%b)", 
                         test_name, test_a, test_b, test_bin, diff, bout);
                $display("      Mode: Serial, Cycles: %0d, Time: %0d ns", local_cycles, end_time - start_time);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL - %s: %d - %d - %d", test_name, test_a, test_b, test_bin);
                if (!done) begin
                    $display("      ERROR: Serial operation did not complete (timeout)");
                end else begin
                    $display("      Expected: diff=%d, bout=%b", expected_diff, expected_bout);
                    $display("      Got:      diff=%d, bout=%b", diff, bout);
                end
                $display("      Cycles: %0d, Time: %0d ns", local_cycles, end_time - start_time);
            end
            
            // Clear start and wait
            start = 0;
            repeat(2) @(posedge clk);
        end
    endtask
    
    // Task to compare parallel vs serial results
    task test_comparison;
        input [31:0] test_a;
        input [31:0] test_b;
        input test_bin;
        input [255:0] test_name;
        
        reg [31:0] parallel_result_diff, serial_result_diff;
        reg parallel_result_bout, serial_result_bout;
        integer local_cycles;
        
        begin
            test_count = test_count + 1;
            
            $display("\nTesting %s at time %0t", test_name, $time);
            
            // Test parallel mode first
            sel = 0;
            a = test_a;
            b = test_b;
            bin = test_bin;
            #5;
            parallel_result_diff = diff;
            parallel_result_bout = bout;
            
            // Test serial mode
            sel = 1;
            a = test_a;
            b = test_b;
            bin = test_bin;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            
            local_cycles = 0;
            while (!done && local_cycles < 40) begin
                @(posedge clk);
                local_cycles = local_cycles + 1;
            end
            
            serial_result_diff = diff;
            serial_result_bout = bout;
            
            // Compare results
            if (parallel_result_diff == serial_result_diff && 
                parallel_result_bout == serial_result_bout) begin
                pass_count = pass_count + 1;
                $display("PASS - %s: Both modes produce identical results", test_name);
                $display("      Result: %d - %d - %d = %d (bout=%b)", 
                         test_a, test_b, test_bin, parallel_result_diff, parallel_result_bout);
                $display("      Parallel: Instant, Serial: %0d cycles", local_cycles);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL - %s: Results differ between modes", test_name);
                $display("      Parallel: diff=%d, bout=%b", parallel_result_diff, parallel_result_bout);
                $display("      Serial:   diff=%d, bout=%b", serial_result_diff, serial_result_bout);
            end
            
            #10;
        end
    endtask
    
    // Monitor for debugging
    initial begin
        $monitor("Time=%0t: sel=%b, a=%h, b=%h, bin=%b, start=%b, done=%b -> diff=%h, bout=%b", 
                 $time, sel, a, b, bin, start, done, diff, bout);
    end
    
    // Generate VCD file for waveform viewing
    initial begin
        $dumpfile("Subtractor_tb.vcd");
        $dumpvars(0, Subtractor_tb);
    end
    
    // Timeout protection (Vivado 1000ns limit)
    initial begin
        #950;
        $display("WARNING: Testbench approaching timeout at %0t", $time);
        #50;
        $display("ERROR: Testbench timed out!");
        $display("Completed %0d out of %0d tests", pass_count + fail_count, test_count);
        $finish;
    end

endmodule
