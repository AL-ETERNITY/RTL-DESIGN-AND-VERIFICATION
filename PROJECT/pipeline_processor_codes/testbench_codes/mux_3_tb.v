`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2025 01:36:43
// Design Name: 
// Module Name: mux_3_tb
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


module mux_3_tb;

    reg [7:0] port_in1;
    reg [7:0] port_in2;
    reg [7:0] port_in3;
    reg [1:0] sel;
    wire [7:0] port_out;

    // Instantiate UUT
    mux_3 #(.N(8)) inst_mux3 (
        .a(port_in1),
        .b(port_in2),
        .c(port_in3),
        .sel(sel),
        .y(port_out)
    );

    // Stimulus for sel
    initial begin
        sel = 2'b00;
        #5 sel = 2'b01;
        #5 sel = 2'b10;
        #5 sel = 2'b11;
        #5 $finish;
    end
    
    // Constant inputs
    initial begin
        port_in1 = 8'h12;
        port_in2 = 8'h56;
        port_in3 = 8'hAB;
    end
    
    initial begin
        $monitor("Time=%0t sel=%b port_in1=%h port_in2=%h port_in3=%h port_out=%h", 
                 $time, sel, port_in1, port_in2, port_in3, port_out);
    end

endmodule
