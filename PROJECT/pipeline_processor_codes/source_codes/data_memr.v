`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2025 00:14:50
// Design Name: 
// Module Name: data_memr
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


module data_memr #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 32
)(
    input wire clk,
    input wire memwrite_m,
    input wire [ADDR_WIDTH-1:0] rw_addr,
    input wire [DATA_WIDTH-1:0] w_data,
    output reg [DATA_WIDTH-1:0] read_data_m
);

    // RAM array - (2*ADDR_WIDTH) depth
    reg [DATA_WIDTH-1:0] ram [0:(2*ADDR_WIDTH)-1];
    
    // Initialize RAM to zeros
    integer i;
    initial begin
        for (i = 0; i < (2*ADDR_WIDTH); i = i + 1) begin
            ram[i] = {DATA_WIDTH{1'b0}};
        end
    end

    // Write process
    always @(posedge clk) begin
        if (memwrite_m == 1'b1) begin
            ram[rw_addr[7:2]] <= w_data;
        end
    end

    // Read process (combinational with address)
    always @(*) begin
        read_data_m = ram[rw_addr[7:2]];
    end

endmodule
