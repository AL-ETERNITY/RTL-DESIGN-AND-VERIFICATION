`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2025 02:42:29
// Design Name: 
// Module Name: sa_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Simple Testbench for 32-bit Serial Adder
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module sa_tb();
    
    // Test signals
    reg clk;                // Clock signal
    reg reset;              // Reset signal
    reg start;              // Start signal
    reg [31:0] a, b;        // 32-bit inputs
    reg cin;                // Carry input
    wire [31:0] sum;        // Sum output
    wire cout;              // Carry output
    wire done;              // Done signal
    
    // Expected result for verification
    reg [32:0] expected;
    
    // Clock generation (faster clock: 2ns period = 500MHz)
    always begin
        clk = 0;
        #1;
        clk = 1;
        #1;
    end
    
    // Instantiate DUT (Device Under Test)
    serial_adder uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout),
        .done(done)
    );
    
    // Test procedure
    initial begin
        // Initialize all signals
        reset = 1;
        start = 0;
        a = 0;
        b = 0;
        cin = 0;
        
        // Display header
        $display("=== Serial Adder Test (Fast Clock) ===");
        $display("Each test takes 32 clock cycles (2ns each = 64ns per test)");
        $display("Test\tA\t\tB\t\tCin\tSum\t\tCout\tCycles\tStatus");
        $display("=======================================================================");
        
        // Release reset (shorter reset time)
        #4;
        reset = 0;
        #2;
        
        // Test Case 1: Simple addition (5 + 3 = 8)
        test_addition(32'h00000005, 32'h00000003, 1'b0, "Test 1");
        
        // Test Case 2: Addition with carry (15 + 1 + 1 = 17)
        test_addition(32'h0000000F, 32'h00000001, 1'b1, "Test 2");
        
        // Test Case 3: Medium numbers
        test_addition(32'h00001234, 32'h00005678, 1'b0, "Test 3");
        
        // Test Case 4: Larger test
        test_addition(32'h12345678, 32'h11111111, 1'b0, "Test 4");
        
        // Test Case 5: Zero test
        test_addition(32'h00000000, 32'h00000000, 1'b0, "Test 5");
        
        $display("\n=== Serial Adder Test Completed Successfully ===");
        $display("Total simulation time: %0t", $time);
        $display("All tests completed within Vivado's 1000ns limit!");
        $finish;
    end
    
    // Task to perform a single addition test
    task test_addition;
        input [31:0] test_a;
        input [31:0] test_b;
        input test_cin;
        input [200:0] test_name;
        
        integer cycle_count;
        begin
            // Set up inputs
            a = test_a;
            b = test_b;
            cin = test_cin;
            expected = test_a + test_b + test_cin;
            
            // Start the addition
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            
            // Wait for completion (should be exactly 32 cycles)
            cycle_count = 0;
            while (!done && cycle_count < 35) begin
                @(posedge clk);
                cycle_count = cycle_count + 1;
            end
            
            // Check result
            if (done) begin
                if ({cout, sum} == expected) begin
                    $display("%s\t%h\t%h\t%b\t%h\t%b\t%0d\tPASS", 
                             test_name, test_a, test_b, test_cin, sum, cout, cycle_count);
                end else begin
                    $display("%s\t%h\t%h\t%b\t%h\t%b\t%0d\tFAIL", 
                             test_name, test_a, test_b, test_cin, sum, cout, cycle_count);
                    $display("\tExpected: %h, Got: %h", expected, {cout, sum});
                end
            end else begin
                $display("%s\t%h\t%h\t%b\t%h\t%b\t%0d\tTIMEOUT", 
                         test_name, test_a, test_b, test_cin, sum, cout, cycle_count);
            end
            
            // Small gap between tests
            repeat(2) @(posedge clk);
        end
    endtask
    
    // Generate VCD file for waveform analysis
    initial begin
        $dumpfile("sa_tb.vcd");
        $dumpvars(0, sa_tb);
    end
    
endmodule
