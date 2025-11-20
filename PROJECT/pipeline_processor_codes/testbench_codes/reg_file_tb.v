`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2025 05:01:07
// Design Name: 
// Module Name: reg_file_tb
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


module reg_file_tb;

    // Inputs
    reg [4:0]  read_port_addr1;
    reg [4:0]  read_port_addr2;
    reg [4:0]  write_port_addr;
    reg [31:0] write_data;
    reg        write_en;
    reg        clk;

    // Outputs
    wire [31:0] read_data1;
    wire [31:0] read_data2;

    // Instantiate reg_file
    reg_file inst_reg_file (
        .read_port_addr1(read_port_addr1),
        .read_port_addr2(read_port_addr2),
        .clk(clk),
        .write_port_addr(write_port_addr),
        .write_data(write_data),
        .write_en(write_en),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // Initialize signals
    initial begin
        read_port_addr1 = 5'b00000;
        read_port_addr2 = 5'b00000;
        write_port_addr = 5'b00000;
        write_data = 32'h00000000;
        write_en = 1'b0;
        clk = 1'b0;
    end

    // Clock generation
    initial begin
        clk = 1'b1;
        #5;
        clk = 1'b0;
        #5;
        clk = 1'b1;
        #5;
        clk = 1'b0;
        #5;
        clk = 1'b1;
        #5;
        clk = 1'b0;
        #5;
        clk = 1'b1;
        #5;
        clk = 1'b0;
        #5;
        clk = 1'b1;
        #5;
        clk = 1'b0;
        #5;
        clk = 1'b1;
        #5;
        clk = 1'b0;
        $finish;
    end

    // Test stimulus
    initial begin
        write_en = 1'b1;
        write_port_addr = 5'b00001;
        write_data = 32'b00001100011100001111001001101111;

        #20;
        write_port_addr = 5'b00010;
        write_data = 32'b00001100011100001111001001101110;
        
        #20;
        write_en = 1'b0;
        read_port_addr1 = 5'b00001;
        read_port_addr2 = 5'b00010;
        #5;
    end

    // Generate VCD file
    initial begin
        $dumpfile("reg_file_tb.vcd");
        $dumpvars(0, reg_file_tb);
    end

    // Monitor outputs
    initial begin
        $monitor("Time=%0t clk=%b write_en=%b addr1=%b addr2=%b data1=%h data2=%h", 
                 $time, clk, write_en, read_port_addr1, read_port_addr2, read_data1, read_data2);
    end

endmodule
