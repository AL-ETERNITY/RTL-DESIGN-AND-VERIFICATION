`timescale 1ns / 1ps

module pc (
    input wire [31:0] PCNext,
    input wire clk,
    input wire reset,
    input wire en,
    output reg [31:0] PC_cur
);

    always @(posedge clk or posedge reset) begin
        if (reset == 1'b1) begin
            PC_cur <= 32'b0;
        end
        else if (en == 1'b1) begin
            PC_cur <= PCNext;
        end
    end

endmodule