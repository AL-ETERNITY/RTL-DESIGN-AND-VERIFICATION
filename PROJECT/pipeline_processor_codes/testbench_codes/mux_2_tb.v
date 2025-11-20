`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2025 01:34:52
// Design Name: 
// Module Name: mux_2_tb
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


module mux_2_tb;

    reg [7:0] port_in1;
    reg [7:0] port_in2;
    reg sel;
    wire [7:0] port_out;

    // Instantiate UUT
    mux_2 #(.number(8)) inst_mux_2 (
        .a(port_in1),
        .b(port_in2),
        .sel(sel),
        .y(port_out)
    );

    // Stimulus
    initial begin
        port_in1 = 8'b1100_0010;
        port_in2 = 8'b0010_1001;
        sel = 1'b0;
        #5 sel = 1'b1;
        #5 sel = 1'b0;
        #2 sel = 1'b1;
        #10 $finish;
    end
    
    initial begin
        $monitor("Time=%0t sel=%b port_in1=%b port_in2=%b port_out=%b", 
                 $time, sel, port_in1, port_in2, port_out);
    end

endmodule
