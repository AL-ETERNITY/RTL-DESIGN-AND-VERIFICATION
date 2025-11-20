`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2025 05:14:02
// Design Name: 
// Module Name: ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Top-level 32-bit ALU (Arithmetic Logic Unit) Module
//              Integrates Adder, Subtractor, Multiplier, and Comparator
//              Provides unified interface with operation selection mechanism
//              
//              Operation Selection (op_sel[1:0]):
//              00: Addition (using Adder module)
//              01: Subtraction (using Subtractor module)  
//              10: Multiplication (using Multiplier module)
//              11: Comparison (using Comparator module)
//              
//              Sub-operation Selection:
//              - For Adder: adder_sel[1:0] (RCA=00, CLA=01, SA=10)
//              - For Subtractor: sub_sel (Parallel=0, Serial=1)
//              - For Multiplier: mult_sel (School-book=0, Left-shift=1)
//              - For Comparator: comp_mode (Unsigned=0, Signed=1)
// 
// Dependencies: Adder.v, Subtractor.v, Multiplier.v, Comparator.v
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// Comprehensive ALU supporting all basic arithmetic and logic operations
// Handles both combinational and sequential operations
//////////////////////////////////////////////////////////////////////////////////

module ALU(
    // Clock and reset (for sequential operations)
    input clk,                  // Clock signal
    input reset,                // Reset signal (active high)
    
    // Operation control signals
    input [1:0] op_sel,         // Main operation selection (00=Add, 01=Sub, 10=Mult, 11=Comp)
    input [1:0] adder_sel,      // Adder type selection (for op_sel=00)
    input sub_sel,              // Subtractor type selection (for op_sel=01)
    input mult_sel,             // Multiplier type selection (for op_sel=10)
    input comp_mode,            // Comparator mode (for op_sel=11)
    input start,                // Start signal for sequential operations
    
    // Operand inputs
    input [31:0] a,             // First operand
    input [31:0] b,             // Second operand
    input cin,                  // Carry input (for addition)
    input bin,                  // Borrow input (for subtraction)
    
    // Outputs
    output [63:0] result,       // Result output (64-bit to accommodate multiplication)
    output carry_out,           // Carry output (from addition)
    output borrow_out,          // Borrow output (from subtraction)
    output [5:0] comp_result,   // Comparison result flags
    output done,                // Operation complete flag
    output overflow             // Overflow flag
);

    // Internal signals for Adder
    wire [31:0] adder_sum;
    wire adder_carry_out;
    wire adder_done;
    
    // Internal signals for Subtractor  
    wire [31:0] sub_diff;
    wire sub_borrow_out;
    wire sub_done;
    
    // Internal signals for Multiplier
    wire [63:0] mult_product;
    wire mult_done;
    
    // Internal signals for Comparator
    wire comp_equal, comp_not_equal, comp_less_than;
    wire comp_less_equal, comp_greater_than, comp_greater_equal;
    wire [5:0] comp_flags;
    
    // Combine individual comparator outputs into flags
    assign comp_flags = {comp_equal, comp_not_equal, comp_less_than, 
                        comp_less_equal, comp_greater_than, comp_greater_equal};
    
    // Generate start signals for each module based on operation selection
    assign adder_start = (op_sel == 2'b00) ? start : 1'b0;
    assign sub_start = (op_sel == 2'b01) ? start : 1'b0;
    assign mult_start = (op_sel == 2'b10) ? start : 1'b0;
    
    // Instantiate Adder module
    Adder adder_inst (
        .clk(clk),
        .reset(reset),
        .adder_select(adder_sel),
        .start(adder_start),
        .a(a),
        .b(b),
        .cin(cin),
        .sum(adder_sum),
        .cout(adder_carry_out),
        .done(adder_done)
    );
    
    // Instantiate Subtractor module
    Subtractor subtractor_inst (
        .clk(clk),
        .reset(reset),
        .sel(sub_sel),
        .start(sub_start),
        .a(a),
        .b(b),
        .bin(bin),
        .diff(sub_diff),
        .bout(sub_borrow_out),
        .done(sub_done)
    );
    
    // Instantiate Multiplier module
    Multiplier multiplier_inst (
        .clk(clk),
        .reset(reset),
        .multiplier_select(mult_sel),
        .start(mult_start),
        .multiplicand(a),
        .multiplier(b),
        .product(mult_product),
        .done(mult_done)
    );
    
    // Instantiate Comparator module
    Comparator comparator_inst (
        .a(a),
        .b(b),
        .signed_mode(comp_mode),
        .equal(comp_equal),
        .not_equal(comp_not_equal),
        .less_than(comp_less_than),
        .less_equal(comp_less_equal),
        .greater_than(comp_greater_than),
        .greater_equal(comp_greater_equal)
    );
    
    // Output selection based on operation
    reg [63:0] result_reg;
    reg carry_out_reg;
    reg borrow_out_reg;
    reg [5:0] comp_result_reg;
    reg done_reg;
    reg overflow_reg;
    
    always @(*) begin
        // Default values
        result_reg = 64'b0;
        carry_out_reg = 1'b0;
        borrow_out_reg = 1'b0;
        comp_result_reg = 6'b0;
        done_reg = 1'b0;
        overflow_reg = 1'b0;
        
        case (op_sel)
            2'b00: begin // Addition
                result_reg = {32'b0, adder_sum};
                carry_out_reg = adder_carry_out;
                done_reg = adder_done;
                // Overflow detection for addition (signed)
                overflow_reg = (a[31] == b[31]) && (adder_sum[31] != a[31]);
            end
            
            2'b01: begin // Subtraction
                result_reg = {32'b0, sub_diff};
                borrow_out_reg = sub_borrow_out;
                done_reg = sub_done;
                // Overflow detection for subtraction (signed)
                overflow_reg = (a[31] != b[31]) && (sub_diff[31] != a[31]);
            end
            
            2'b10: begin // Multiplication
                result_reg = mult_product;
                done_reg = mult_done;
                // Overflow detection for multiplication (if result > 32 bits)
                overflow_reg = |mult_product[63:32];
            end
            
            2'b11: begin // Comparison
                result_reg = {58'b0, comp_flags};
                comp_result_reg = comp_flags;
                done_reg = 1'b1; // Comparator is always done (combinational)
            end
            
            default: begin
                result_reg = 64'b0;
                carry_out_reg = 1'b0;
                borrow_out_reg = 1'b0;
                comp_result_reg = 6'b0;
                done_reg = 1'b1;
                overflow_reg = 1'b0;
            end
        endcase
    end
    
    // Assign outputs
    assign result = result_reg;
    assign carry_out = carry_out_reg;
    assign borrow_out = borrow_out_reg;
    assign comp_result = comp_result_reg;
    assign done = done_reg;
    assign overflow = overflow_reg;

endmodule
