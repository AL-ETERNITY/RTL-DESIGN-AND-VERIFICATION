`timescale 1ns / 1ps

// ============================================================================
// 2-to-1 MUX Module
// ============================================================================
module mux_2 #(
    parameter number = 32
)(
    input wire [number-1:0] a,
    input wire [number-1:0] b,
    input wire sel,
    output reg [number-1:0] y
);

    always @(*) begin
        case (sel)
            1'b1:    y = b;
            default: y = a;
        endcase
    end

endmodule