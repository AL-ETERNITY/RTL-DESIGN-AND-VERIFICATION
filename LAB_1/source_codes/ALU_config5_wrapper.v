`timescale 1ns / 1ps

// CONFIG 5: Balanced (RCA Adder, Schoolbook Multiplier, Parallel Subtractor, Signed Comparator)
module ALU_config5_wrapper(
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

    // CONFIG 5: Balanced implementations
    wire [1:0] adder_sel = 2'b00;    // RCA Adder (Balanced)
    wire mult_sel = 1'b0;            // Schoolbook Multiplier (Fast)
    wire sub_sel = 1'b0;             // Parallel Subtractor (Fast)
    wire comp_mode = 1'b1;           // Signed Comparator (Fast)

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
