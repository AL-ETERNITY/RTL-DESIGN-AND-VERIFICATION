`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2025 04:59:14
// Design Name: 
// Module Name: ss_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Testbench for 32-bit Serial Subtractor
//              Tests sequential subtraction with various input combinations
//              Optimized to complete within Vivado's 1000ns simulation limit
//              Uses fast clock (4ns period) to fit 32-cycle operations
// 
// Dependencies: Serial_Subtractor.v
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// Sequential design requires careful timing management
// Each test takes ~130ns (32 cycles × 4ns + overhead)
//////////////////////////////////////////////////////////////////////////////////

module ss_tb();

    // Testbench signals
    reg clk;                    // Clock signal
    reg reset;                  // Reset signal
    reg start;                  // Start operation signal
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
    integer cycle_count;
    
    // Clock generation (4ns period for fast operation)
    initial begin
        clk = 0;
        forever #2 clk = ~clk;  // 4ns period, 250MHz
    end
    
    // Instantiate the serial subtractor
    Serial_Subtractor uut (
        .clk(clk),
        .reset(reset),
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
        cycle_count = 0;
        reset = 1;
        start = 0;
        a = 0;
        b = 0;
        bin = 0;
        
        $display("=== Serial Subtractor Testbench Started ===");
        $display("Clock Period: 4ns, Target: Complete within 1000ns");
        $display("Time: %0t", $time);
        
        // Reset sequence
        #10;
        reset = 0;
        #10;
        
        // Test 1: Basic subtraction (50 - 20 = 30)
        test_serial_subtraction(32'd50, 32'd20, 1'b0, "Basic subtraction (50-20)");
        
        // Test 2: Zero difference (100 - 100 = 0)
        test_serial_subtraction(32'd100, 32'd100, 1'b0, "Zero difference (100-100)");
        
        // Test 3: Subtract from zero (0 - 15, requires borrow)
        test_serial_subtraction(32'd0, 32'd15, 1'b0, "Subtract from zero (0-15)");
        
        // Test 4: Large numbers
        test_serial_subtraction(32'h12345678, 32'h11111111, 1'b0, "Large numbers");
        
        // Test 5: With borrow input
        test_serial_subtraction(32'd200, 32'd100, 1'b1, "With borrow input");
        
        // Test 6: Maximum minus minimum
        test_serial_subtraction(32'hFFFFFFFF, 32'h00000001, 1'b0, "Max - 1");
        
        // Final results
        #20;
        $display("\n=== Test Results Summary ===");
        $display("Total Tests: %0d", test_count);
        $display("Passed: %0d", pass_count);
        $display("Failed: %0d", fail_count);
        $display("Total Clock Cycles: %0d", cycle_count);
        $display("Success Rate: %0d%%", (pass_count * 100) / test_count);
        
        if (fail_count == 0) begin
            $display("*** ALL TESTS PASSED! ***");
        end else begin
            $display("*** SOME TESTS FAILED! ***");
        end
        
        $display("Simulation completed at time: %0t", $time);
        $finish;
    end
    
    // Task to perform individual serial subtraction test
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
            start_time = $time;
            local_cycles = 0;
            
            $display("\nStarting %s at time %0t", test_name, $time);
            
            // Calculate expected result
            calculate_expected(test_a, test_b, test_bin);
            
            // Apply inputs
            a = test_a;
            b = test_b;
            bin = test_bin;
            
            // Wait for stable inputs
            @(posedge clk);
            
            // Pulse start signal
            start = 1;
            @(posedge clk);
            start = 0;
            
            // Wait for completion (with timeout protection)
            while (!done && local_cycles < 40) begin
                @(posedge clk);
                local_cycles = local_cycles + 1;
            end
            
            end_time = $time;
            cycle_count = cycle_count + local_cycles;
            
            // Check results
            if (done && diff == expected_diff && bout == expected_bout) begin
                pass_count = pass_count + 1;
                $display("PASS - %s: %d - %d - %d = %d (bout=%b)", 
                         test_name, test_a, test_b, test_bin, diff, bout);
                $display("      Cycles: %0d, Time: %0d ns", local_cycles, end_time - start_time);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL - %s: %d - %d - %d", test_name, test_a, test_b, test_bin);
                if (!done) begin
                    $display("      ERROR: Operation did not complete (timeout)");
                    $display("      Current state: %b, bit_counter: %d", uut.state, uut.bit_counter);
                end else begin
                    $display("      Expected: diff=%d, bout=%b", expected_diff, expected_bout);
                    $display("      Got:      diff=%d, bout=%b", diff, bout);
                end
                $display("      Cycles: %0d, Time: %0d ns", local_cycles, end_time - start_time);
            end
            
            // Clear start and wait for module to be ready for next test
            start = 0;
            repeat(3) @(posedge clk);
        end
    endtask
    
    // Monitor for debugging
    initial begin
        $monitor("Time=%0t: a=%h, b=%h, bin=%b, start=%b, done=%b -> diff=%h, bout=%b", 
                 $time, a, b, bin, start, done, diff, bout);
    end
    
    // Generate VCD file for waveform viewing
    initial begin
        $dumpfile("ss_tb.vcd");
        $dumpvars(0, ss_tb);
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
    
    // Debug: State monitoring
    always @(posedge clk) begin
        if (uut.state == 2'b01) begin  // SUBTRACTING state
            $display("  Processing bit %0d: a_bit=%b, b_comp=%b, cin=%b -> sum=%b, cout=%b", 
                     uut.bit_counter, uut.a_reg[0], uut.b_complement[0], uut.cin, 
                     uut.sum_bit, uut.carry_out);
        end
        
        // Monitor state transitions
        if (uut.state != 2'b01) begin
            case (uut.state)
                2'b00: if (start) $display("  State: IDLE -> Start detected");
                2'b10: $display("  State: COMPLETE -> done=%b", done);
            endcase
        end
    end

endmodule
