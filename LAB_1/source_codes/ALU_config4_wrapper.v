`timescale 1ns / 1ps

// CONFIG 4: Mixed Slow-Fast (Serial Adder, Schoolbook Multiplier, Serial Subtractor, Unsigned Comparator)
module ALU_config4_wrapper(
    input clk,
    input reset,
    input [31:0] a,
    input [31:0] b,
    input [1:0] op_sel,
    input start,
    input cin,
    input bin,
    output [63:0] result,
    output carry_out,
    output borrow_out,
    output [5:0] comp_result,
    output done,
    output overflow
);

    // CONFIG 4: Mixed Slow-Fast implementations
    wire [1:0] adder_sel = 2'b10;    // Serial Adder (Slow)
    wire mult_sel = 1'b0;            // Schoolbook Multiplier (Fast)
    wire sub_sel = 1'b1;             // Serial Subtractor (Slow)
    wire comp_mode = 1'b0;           // Unsigned Comparator (Slow)

    // Instantiate the main ALU
    ALU alu_inst (
        .clk(clk),
        .reset(reset),
        .a(a),
        .b(b),
        .op_sel(op_sel),
        .adder_sel(adder_sel),
        .sub_sel(sub_sel),
        .mult_sel(mult_sel),
        .comp_mode(comp_mode),
        .start(start),
        .cin(cin),
        .bin(bin),
        .result(result),
        .carry_out(carry_out),
        .borrow_out(borrow_out),
        .comp_result(comp_result),
        .done(done),
        .overflow(overflow)
    );

endmodule
