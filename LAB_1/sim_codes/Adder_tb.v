`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2025 03:07:20
// Design Name: 
// Module Name: Adder_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Testbench for Top Adder Module (All 3 Adder Types)
//              Optimized to complete within 1000ns Vivado limit
// 
// Dependencies: Adder.v (top module)
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Adder_tb();
    
    // Test signals
    reg clk;
    reg reset;
    reg [31:0] a, b;
    reg cin;
    reg [1:0] adder_select;
    reg start;
    
    // Outputs
    wire [31:0] sum;
    wire cout;
    wire done;
    wire [1:0] active_adder;
    
    // Expected result
    reg [32:0] expected;
    
    // Test tracking
    integer test_count;
    
    // Fast clock generation (2ns period = 500MHz)
    always begin
        clk = 0; #1;
        clk = 1; #1;
    end
    
    // Instantiate DUT (Device Under Test)
    Adder uut (
        .clk(clk),
        .reset(reset),
        .a(a),
        .b(b),
        .cin(cin),
        .adder_select(adder_select),
        .start(start),
        .sum(sum),
        .cout(cout),
        .done(done),
        .active_adder(active_adder)
    );
    
    // Main test procedure
    initial begin
        // Initialize
        reset = 1;
        start = 0;
        a = 0;
        b = 0;
        cin = 0;
        adder_select = 2'b00;
        test_count = 0;
        
        // Display header
        $display("=== Top Adder Module Test (All 3 Types) ===");
        $display("Time Budget: 1000ns | Fast Clock: 2ns period");
        $display("Test\tType\tA\t\tB\t\tCin\tSum\t\tCout\tCycles\tStatus");
        $display("==============================================================================");
        
        // Release reset
        #4;
        reset = 0;
        #2;
        
        // Test Set 1: Same inputs for all adders (comparison test)
        test_all_adders(32'h00000005, 32'h00000003, 1'b0, "Set1");
        
        // Test Set 2: Medium numbers
        test_all_adders(32'h00001234, 32'h00005678, 1'b0, "Set2");
        
        // Test Set 3: With carry
        test_all_adders(32'h0000000F, 32'h00000001, 1'b1, "Set3");
        
        $display("\n=== Summary ===");
        $display("Total Tests: %0d", test_count);
        $display("Total Time: %0t", $time);
        $display("All tests completed within 1000ns limit!");
        $finish;
    end
    
    // Task to test all three adders with same inputs
    task test_all_adders;
        input [31:0] test_a;
        input [31:0] test_b;
        input test_cin;
        input [50:0] test_name;
        
        begin
            // Calculate expected result
            expected = test_a + test_b + test_cin;
            
            // Test 1: Ripple Carry Adder
            test_combinational_adder(2'b00, "RCA", test_a, test_b, test_cin, test_name);
            
            // Test 2: Carry Lookahead Adder  
            test_combinational_adder(2'b01, "CLA", test_a, test_b, test_cin, test_name);
            
            // Test 3: Serial Adder
            test_serial_adder(test_a, test_b, test_cin, test_name);
        end
    endtask
    
    // Task for testing combinational adders (RCA & CLA)
    task test_combinational_adder;
        input [1:0] adder_type;
        input [30:0] type_name;
        input [31:0] test_a;
        input [31:0] test_b;
        input test_cin;
        input [50:0] test_name;
        
        begin
            // Set inputs
            adder_select = adder_type;
            a = test_a;
            b = test_b;
            cin = test_cin;
            
            // Wait for combinational delay
            #4;
            
            // Check result
            test_count = test_count + 1;
            if ({cout, sum} == expected && done == 1'b1) begin
                $display("%s\t%s\t%h\t%h\t%b\t%h\t%b\t1\tPASS", 
                         test_name, type_name, test_a, test_b, test_cin, sum, cout);
            end else begin
                $display("%s\t%s\t%h\t%h\t%b\t%h\t%b\t1\tFAIL", 
                         test_name, type_name, test_a, test_b, test_cin, sum, cout);
                $display("\t\tExpected: %h, Got: %h", expected, {cout, sum});
            end
            
            #2; // Small gap
        end
    endtask
    
    // Task for testing serial adder
    task test_serial_adder;
        input [31:0] test_a;
        input [31:0] test_b;
        input test_cin;
        input [50:0] test_name;
        
        integer cycle_count;
        begin
            // Set inputs
            adder_select = 2'b10;
            a = test_a;
            b = test_b;
            cin = test_cin;
            
            // Start serial addition
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
            if (done && {cout, sum} == expected) begin
                $display("%s\tSA\t%h\t%h\t%b\t%h\t%b\t%0d\tPASS", 
                         test_name, test_a, test_b, test_cin, sum, cout, cycle_count);
            end else if (!done) begin
                $display("%s\tSA\t%h\t%h\t%b\t%h\t%b\t%0d\tTIMEOUT", 
                         test_name, test_a, test_b, test_cin, sum, cout, cycle_count);
            end else begin
                $display("%s\tSA\t%h\t%h\t%b\t%h\t%b\t%0d\tFAIL", 
                         test_name, test_a, test_b, test_cin, sum, cout, cycle_count);
                $display("\t\tExpected: %h, Got: %h", expected, {cout, sum});
            end
            
            #4; // Gap between tests
        end
    endtask
    
    // Generate VCD for waveform analysis
    initial begin
        $dumpfile("adder_tb.vcd");
        $dumpvars(0, Adder_tb);
    end
    
endmodule
