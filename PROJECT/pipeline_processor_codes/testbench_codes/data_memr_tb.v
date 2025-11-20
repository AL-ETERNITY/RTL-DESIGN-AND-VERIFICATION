`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2025 00:16:35
// Design Name: 
// Module Name: data_memr_tb
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


module data_memr_tb;

    // Testbench signals
    reg [31:0] addr_port;
    reg [31:0] write_data;
    reg clk;
    reg write_en;
    wire [31:0] read_data;

    // Instantiate the Unit Under Test (UUT)
    data_memr #(
        .DATA_WIDTH(32),
        .ADDR_WIDTH(32)
    ) inst_data_memr (
        .clk(clk),
        .memwrite_m(write_en),
        .rw_addr(addr_port),
        .w_data(write_data),
        .read_data_m(read_data)
    );

    // Clock generation process
    initial begin
        clk = 0;
        repeat(6) begin
            #5 clk = 1;
            #5 clk = 0;
        end
    end

    // Stimulus process
    initial begin
        // Initialize signals
        addr_port = 32'b0;
        write_data = 32'b0;
        write_en = 1'b0;
        
        // Wait for initial setup
        #0;
        
        // Write operation 1
        write_en = 1'b1;
        addr_port = 32'b0000_1100_0111_0000_1111_0010_0110_0001;
        write_data = 32'b0000_1100_0111_0000_1111_0010_0110_1111;
        #10;
        
        // Write operation 2
        addr_port = 32'b0000_1100_0111_0000_1111_0010_0110_0010;
        write_data = 32'b0000_1100_0111_0000_1111_0010_0110_1110;
        #10;
        
        // Read operation 1
        write_en = 1'b0;
        addr_port = 32'b0000_1100_0111_0000_1111_0010_0110_0001;
        #10;
        
        // Read operation 2
        addr_port = 32'b0000_1100_0111_0000_1111_0010_0110_0010;
        #10;
        
        // End simulation
        $finish;
    end
    
    // Optional: Monitor for debugging
    initial begin
        $monitor("Time=%0t clk=%b write_en=%b addr=%h write_data=%h read_data=%h", 
                 $time, clk, write_en, addr_port, write_data, read_data);
    end

endmodule
