`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2025 01:54:27
// Design Name: 
// Module Name: rca_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Testbench for 32-bit Ripple Carry Adder
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module rca_tb();
    
    // Testbench signals
    reg [31:0] a;           // 32-bit input A
    reg [31:0] b;           // 32-bit input B
    reg cin;                // Carry input
    wire [31:0] sum;        // 32-bit sum output
    wire cout;              // Carry output
    
    // Expected result for verification
    reg [32:0] expected_result;
    
    // Instantiate the DUT (Device Under Test)
    ripple_carry_adder uut (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );
    
    // Test procedure
    initial begin
        // Initialize inputs
        a = 0;
        b = 0;
        cin = 0;
        
        // Display header
        $display("Time\t\tA\t\t\tB\t\t\tCin\tSum\t\t\tCout\tExpected\tStatus");
        $display("================================================================================");
        
        // Wait for initial stabilization
        #10;
        
        // Test Case 1: Simple addition without carry
        a = 32'h0000000A;    // 10 in decimal
        b = 32'h00000005;    // 5 in decimal
        cin = 0;
        #10;
        expected_result = a + b + cin;
        check_result();
        
        // Test Case 2: Addition with carry input
        a = 32'h0000000F;    // 15 in decimal
        b = 32'h00000010;    // 16 in decimal
        cin = 1;
        #10;
        expected_result = a + b + cin;
        check_result();
        
        // Test Case 3: Maximum values
        a = 32'hFFFFFFFF;    // Maximum 32-bit value
        b = 32'h00000001;    // 1
        cin = 0;
        #10;
        expected_result = a + b + cin;
        check_result();
        
        // Test Case 4: Overflow condition
        a = 32'hFFFFFFFF;    // Maximum 32-bit value
        b = 32'hFFFFFFFF;    // Maximum 32-bit value
        cin = 1;
        #10;
        expected_result = a + b + cin;
        check_result();
        
        // Test Case 5: Zero addition
        a = 32'h00000000;
        b = 32'h00000000;
        cin = 0;
        #10;
        expected_result = a + b + cin;
        check_result();
        
        // Test Case 6: Random test cases
        repeat(10) begin
            a = $random;
            b = $random;
            cin = $random % 2;
            #10;
            expected_result = a + b + cin;
            check_result();
        end
        
        // Test Case 7: Specific bit patterns
        a = 32'hAAAAAAAA;    // Alternating pattern
        b = 32'h55555555;    // Complementary pattern
        cin = 0;
        #10;
        expected_result = a + b + cin;
        check_result();
        
        a = 32'h12345678;
        b = 32'h87654321;
        cin = 1;
        #10;
        expected_result = a + b + cin;
        check_result();
        
        $display("\n=== Testbench Completed ===");
        $finish;
    end
    
    // Task to check and display results
    task check_result;
        begin
            if ({cout, sum} == expected_result) begin
                $display("%0t\t%h\t%h\t%b\t%h\t%b\t%h\tPASS", 
                         $time, a, b, cin, sum, cout, expected_result);
            end else begin
                $display("%0t\t%h\t%h\t%b\t%h\t%b\t%h\tFAIL", 
                         $time, a, b, cin, sum, cout, expected_result);
                $display("ERROR: Expected {cout,sum} = %h, Got {cout,sum} = %h", 
                         expected_result, {cout, sum});
            end
        end
    endtask
    
    // Optional: Generate VCD file for waveform viewing
    initial begin
        $dumpfile("rca_tb.vcd");
        $dumpvars(0, rca_tb);
    end
    
endmodule
