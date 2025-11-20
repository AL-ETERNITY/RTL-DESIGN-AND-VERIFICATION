`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2025 02:11:22
// Design Name: 
// Module Name: cla_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Simple Testbench for 32-bit Carry Lookahead Adder
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module cla_tb();
    
    // Test signals
    reg [31:0] a, b;        // 32-bit inputs
    reg cin;                // Carry input
    wire [31:0] sum;        // Sum output
    wire cout;              // Carry output
    
    // Expected result
    reg [32:0] expected;
    
    // Instantiate DUT (Device Under Test)
    carry_lookahead_adder uut (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );
    
    // Test stimulus
    initial begin
        // Display header
        $display("=== Carry Lookahead Adder Test ===");
        $display("Time\tA\t\tB\t\tCin\tSum\t\tCout\tStatus");
        $display("================================================================");
        
        // Test Case 1: Simple addition
        a = 32'h00000005;   // 5
        b = 32'h00000003;   // 3
        cin = 0;
        #5;
        expected = a + b + cin;
        check_result("Test 1: 5 + 3");
        
        // Test Case 2: Addition with carry
        a = 32'h0000000F;   // 15
        b = 32'h00000001;   // 1
        cin = 1;
        #5;
        expected = a + b + cin;
        check_result("Test 2: 15 + 1 + 1");
        
        // Test Case 3: Large numbers
        a = 32'h12345678;
        b = 32'h87654321;
        cin = 0;
        #5;
        expected = a + b + cin;
        check_result("Test 3: Large numbers");
        
        // Test Case 4: Maximum values (overflow)
        a = 32'hFFFFFFFF;   // Max 32-bit
        b = 32'h00000001;   // 1
        cin = 0;
        #5;
        expected = a + b + cin;
        check_result("Test 4: Overflow test");
        
        // Test Case 5: All zeros
        a = 32'h00000000;
        b = 32'h00000000;
        cin = 0;
        #5;
        expected = a + b + cin;
        check_result("Test 5: Zero test");
        
        // Test Case 6: Alternating pattern
        a = 32'hAAAAAAAA;   // 10101010...
        b = 32'h55555555;   // 01010101...
        cin = 1;
        #5;
        expected = a + b + cin;
        check_result("Test 6: Pattern test");
        
        $display("\n=== Test Completed ===");
        $finish;
    end
    
    // Task to check and display results
    task check_result;
        input [200:0] test_name;
        begin
            if ({cout, sum} == expected) begin
                $display("%0t\t%h\t%h\t%b\t%h\t%b\tPASS - %s", 
                         $time, a, b, cin, sum, cout, test_name);
            end else begin
                $display("%0t\t%h\t%h\t%b\t%h\t%b\tFAIL - %s", 
                         $time, a, b, cin, sum, cout, test_name);
                $display("\tExpected: %h, Got: %h", expected, {cout, sum});
            end
        end
    endtask
    
    // Generate VCD file for waveform analysis
    initial begin
        $dumpfile("cla_tb.vcd");
        $dumpvars(0, cla_tb);
    end
    
endmodule
