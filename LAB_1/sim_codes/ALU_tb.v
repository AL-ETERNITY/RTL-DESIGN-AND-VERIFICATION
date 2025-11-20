`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2025 05:17:28
// Design Name: 
// Module Name: ALU_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Simple Testbench for 32-bit ALU Module
//              Tests all four operations: Addition, Subtraction, Multiplication, Comparison
//              Uses basic test cases optimized for Vivado's 1000ns simulation limit
// 
// Dependencies: ALU.v and all sub-modules
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// Simple test approach with one test per operation type
//////////////////////////////////////////////////////////////////////////////////

module ALU_tb();

    // Testbench signals
    reg clk;
    reg reset;
    reg [1:0] op_sel;
    reg [1:0] adder_sel;
    reg sub_sel;
    reg mult_sel;
    reg comp_mode;
    reg start;
    reg [31:0] a, b;
    reg cin, bin;
    
    wire [63:0] result;
    wire carry_out;
    wire borrow_out;
    wire [5:0] comp_result;
    wire done;
    wire overflow;
    
    // Test control
    integer test_count = 0;
    integer pass_count = 0;
    integer fail_count = 0;
    
    // Clock generation (fast 4ns period)
    initial begin
        clk = 0;
        forever #2 clk = ~clk;
    end
    
    // Instantiate ALU
    ALU uut (
        .clk(clk),
        .reset(reset),
        .op_sel(op_sel),
        .adder_sel(adder_sel),
        .sub_sel(sub_sel),
        .mult_sel(mult_sel),
        .comp_mode(comp_mode),
        .start(start),
        .a(a),
        .b(b),
        .cin(cin),
        .bin(bin),
        .result(result),
        .carry_out(carry_out),
        .borrow_out(borrow_out),
        .comp_result(comp_result),
        .done(done),
        .overflow(overflow)
    );
    
    // Test procedure
    initial begin
        $display("=== Simple ALU Testbench Started ===");
        $display("Time: %0t", $time);
        
        // Initialize signals
        reset = 1;
        start = 0;
        op_sel = 0;
        adder_sel = 0;
        sub_sel = 0;
        mult_sel = 0;
        comp_mode = 0;
        a = 0;
        b = 0;
        cin = 0;
        bin = 0;
        
        // Reset sequence
        #10;
        reset = 0;
        #10;
        
        // Test 1: Addition (100 + 50 = 150)
        $display("\n--- Test 1: Addition ---");
        test_addition(32'd100, 32'd50, 1'b0, 32'd150);
        
        // Test 2: Subtraction (100 - 30 = 70) 
        $display("\n--- Test 2: Subtraction ---");
        test_subtraction(32'd100, 32'd30, 1'b0, 32'd70);
        
        // Test 3: Multiplication (20 × 15 = 300)
        $display("\n--- Test 3: Multiplication ---");
        test_multiplication(32'd20, 32'd15, 64'd300);
        
        // Test 4: Comparison (100 vs 50)
        $display("\n--- Test 4: Comparison ---");
        test_comparison(32'd100, 32'd50, 6'b010011); // !=, >, >=
        
        // Results summary
        #20;
        $display("\n=== Test Results ===");
        $display("Total Tests: %0d", test_count);
        $display("Passed: %0d", pass_count);
        $display("Failed: %0d", fail_count);
        
        if (fail_count == 0) begin
            $display("*** ALL TESTS PASSED! ***");
        end else begin
            $display("*** SOME TESTS FAILED! ***");
        end
        
        $display("Simulation completed at time: %0t", $time);
        $finish;
    end
    
    // Task for testing addition
    task test_addition;
        input [31:0] test_a, test_b;
        input test_cin;
        input [31:0] expected;
        
        begin
            test_count = test_count + 1;
            
            // Set operation and inputs
            op_sel = 2'b00;        // Addition
            adder_sel = 2'b00;     // Use ripple carry adder
            a = test_a;
            b = test_b;
            cin = test_cin;
            
            // Wait for result (combinational for RCA)
            #10;
            
            // Check result
            if (done && result[31:0] == expected) begin
                pass_count = pass_count + 1;
                $display("PASS: %0d + %0d = %0d (carry=%b)", test_a, test_b, result[31:0], carry_out);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: %0d + %0d = %0d, expected %0d", test_a, test_b, result[31:0], expected);
            end
        end
    endtask
    
    // Task for testing subtraction
    task test_subtraction;
        input [31:0] test_a, test_b;
        input test_bin;
        input [31:0] expected;
        
        begin
            test_count = test_count + 1;
            
            // Set operation and inputs
            op_sel = 2'b01;        // Subtraction
            sub_sel = 1'b0;        // Use parallel subtractor
            a = test_a;
            b = test_b;
            bin = test_bin;
            
            // Wait for result (combinational for parallel)
            #10;
            
            // Check result
            if (done && result[31:0] == expected) begin
                pass_count = pass_count + 1;
                $display("PASS: %0d - %0d = %0d (borrow=%b)", test_a, test_b, result[31:0], borrow_out);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: %0d - %0d = %0d, expected %0d", test_a, test_b, result[31:0], expected);
            end
        end
    endtask
    
    // Task for testing multiplication
    task test_multiplication;
        input [31:0] test_a, test_b;
        input [63:0] expected;
        
        integer wait_cycles;
        
        begin
            test_count = test_count + 1;
            wait_cycles = 0;
            
            // Set operation and inputs
            op_sel = 2'b10;        // Multiplication
            mult_sel = 1'b0;       // Use school-book multiplier
            a = test_a;
            b = test_b;
            
            // Wait for stable inputs
            @(posedge clk);
            
            // Start operation
            start = 1;
            @(posedge clk);
            start = 0;
            
            // Wait for completion (combinational for school-book)
            while (!done && wait_cycles < 10) begin
                @(posedge clk);
                wait_cycles = wait_cycles + 1;
            end
            
            // Check result
            if (done && result == expected) begin
                pass_count = pass_count + 1;
                $display("PASS: %0d × %0d = %0d", test_a, test_b, result);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: %0d × %0d = %0d, expected %0d", test_a, test_b, result, expected);
            end
        end
    endtask
    
    // Task for testing comparison
    task test_comparison;
        input [31:0] test_a, test_b;
        input [5:0] expected;
        
        begin
            test_count = test_count + 1;
            
            // Set operation and inputs
            op_sel = 2'b11;        // Comparison
            comp_mode = 1'b0;      // Unsigned mode
            a = test_a;
            b = test_b;
            
            // Wait for result (combinational)
            #10;
            
            // Check result
            if (done && comp_result == expected) begin
                pass_count = pass_count + 1;
                $display("PASS: %0d vs %0d -> flags=%b (!=:%b, >:%b, >=:%b)", 
                         test_a, test_b, comp_result, comp_result[4], comp_result[1], comp_result[0]);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: %0d vs %0d -> flags=%b, expected %b", 
                         test_a, test_b, comp_result, expected);
            end
        end
    endtask
    
    // Simple monitor
    initial begin
        $monitor("Time=%0t: op=%b, a=%0d, b=%0d, done=%b, result=%0d", 
                 $time, op_sel, a, b, done, result[31:0]);
    end
    
    // Generate VCD file
    initial begin
        $dumpfile("ALU_tb.vcd");
        $dumpvars(0, ALU_tb);
    end
    
    // Timeout protection
    initial begin
        #950;
        $display("WARNING: Approaching timeout at %0t", $time);
        #50;
        $display("ERROR: Testbench timed out!");
        $finish;
    end

endmodule
