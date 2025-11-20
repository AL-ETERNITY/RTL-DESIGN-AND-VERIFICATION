`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2025 02:18:23
// Design Name: 
// Module Name: reg_file
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


module reg_file (
    // Inputs
    input wire [4:0] read_port_addr1,
    input wire [4:0] read_port_addr2,
    input wire [4:0] write_port_addr,
    input wire [31:0] write_data,
    input wire write_en,
    input wire clk,
    
    // Outputs
    output wire [31:0] read_data1,
    output wire [31:0] read_data2
);

    // Register bank (32 registers)
    reg [31:0] reg_bank1 [0:31];
    
    // Initialize all registers to 0 for cleaner simulation
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            reg_bank1[i] = 32'h00000000;
        end
    end

    // Write process
    always @(posedge clk) begin
        if (write_en == 1'b1) begin
            reg_bank1[write_port_addr] <= write_data;
        end
    end

    // Read process (combinational, x0 hardwired to 0)
    assign read_data1 = (read_port_addr1 == 5'b0) ? 32'h0000_0000 : reg_bank1[read_port_addr1];
    assign read_data2 = (read_port_addr2 == 5'b0) ? 32'h0000_0000 : reg_bank1[read_port_addr2];

endmodule

