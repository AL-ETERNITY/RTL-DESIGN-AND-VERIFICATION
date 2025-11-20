`timescale 1ns / 1ps

// CONFIG 2: All Slow (Serial Adder, Left-shift Multiplier, Serial Subtractor, Unsigned Comparator)
module ALU_config2_wrapper(
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

    // CONFIG 2: All Slow implementations
    wire [1:0] adder_sel = 2'b10;    // Serial Adder
    wire mult_sel = 1'b1;            // Left-shift Multiplier
    wire sub_sel = 1'b1;             // Serial Subtractor
    wire comp_mode = 1'b0;           // Unsigned Comparator

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
