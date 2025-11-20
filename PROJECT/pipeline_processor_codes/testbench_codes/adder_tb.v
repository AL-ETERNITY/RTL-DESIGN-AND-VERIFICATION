`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.11.2025 23:09:43
// Design Name: 
// Module Name: adder_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module adder_tb;

    reg  [31:0] a_in;
    reg  [31:0] b_in;
    wire [31:0] c_out;

    // Instantiate the adder module
    adder #(.WIDTH(32)) inst_adder (
        .a_in(a_in),
        .b_in(b_in),
        .c_out(c_out)
    );

    // Stimulus
    initial begin
        a_in = 32'b0000_0011_1100_0000_0000_0000_0000_0000;
        b_in = 32'd4;
        
        // Display results
        #10;
        $display("a_in = %h, b_in = %h, c_out = %h", a_in, b_in, c_out);
        
        #10;
        $finish;
    end

endmodule