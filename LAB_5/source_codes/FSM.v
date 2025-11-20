`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.10.2025 09:58:15
// Design Name: 
// Module Name: FSM
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


module FSM (
    input wire clk,
    input wire reset,
    input wire x,
    output reg y
);

    // State encoding
    parameter S0 = 3'b000;
    parameter S1 = 3'b001;
    parameter S2 = 3'b011;
    parameter S3 = 3'b010;
    parameter S4 = 3'b100;

    reg [2:0] state, next_state;

    // Sequential block
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Combinational logic (Mealy)
    always @(*) begin
        next_state = state;
        y = 0;

        case (state)
            S0: next_state = (x) ? S1 : S0;           // got 1
            S1: next_state = (x) ? S2 : S0;           // got 11
            S2: next_state = (x) ? S3 : S0;           // got 111
            S3: next_state = (x) ? S3 : S4;           // got 1110
            S4: begin
                if (x)
                    next_state = S1;                  // 11101 → possible restart
                else begin
                    y = 1;                            // 11100 detected here
                    next_state = S0;                  // non-overlapping reset
                end
            end
            default: next_state = S0;
        endcase
    end
endmodule


