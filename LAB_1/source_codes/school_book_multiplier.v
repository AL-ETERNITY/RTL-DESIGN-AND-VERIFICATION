`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2025 03:21:53
// Design Name: 
// Module Name: school_book_multiplier
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 32-bit School Book Multiplier (Traditional Multiplication Method)
//              Mimics the paper-and-pencil multiplication we learn in school
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// School book multiplication works by:
// 1. Multiply multiplicand by each bit of multiplier
// 2. Shift each partial product by appropriate position
// 3. Add all partial products to get final result
//////////////////////////////////////////////////////////////////////////////////

module school_book_multiplier(
    input [31:0] multiplicand,    // Number being multiplied (A)
    input [31:0] multiplier,      // Number multiplying by (B)
    output [63:0] product         // Result (A × B)
);

    // Partial products array - 32 partial products, each up to 64 bits
    wire [63:0] partial_products [31:0];
    
    // Generate partial products
    // For each bit of multiplier, create a partial product
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = multiplier[i] ? ({32'b0, multiplicand} << i) : 64'b0;
        end
    endgenerate
    
    // Add all partial products using a tree structure
    // Level 0: 32 partial products
    wire [63:0] level1 [15:0];  // 16 sums from level 0
    wire [63:0] level2 [7:0];   // 8 sums from level 1
    wire [63:0] level3 [3:0];   // 4 sums from level 2
    wire [63:0] level4 [1:0];   // 2 sums from level 3
    
    // Level 1: Add pairs of partial products (32 → 16)
    generate
        for (i = 0; i < 16; i = i + 1) begin : gen_level1
            assign level1[i] = partial_products[2*i] + partial_products[2*i + 1];
        end
    endgenerate
    
    // Level 2: Add pairs from level 1 (16 → 8)
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_level2
            assign level2[i] = level1[2*i] + level1[2*i + 1];
        end
    endgenerate
    
    // Level 3: Add pairs from level 2 (8 → 4)
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_level3
            assign level3[i] = level2[2*i] + level2[2*i + 1];
        end
    endgenerate
    
    // Level 4: Add pairs from level 3 (4 → 2)
    generate
        for (i = 0; i < 2; i = i + 1) begin : gen_level4
            assign level4[i] = level3[2*i] + level3[2*i + 1];
        end
    endgenerate
    
    // Final level: Add the last two sums
    assign product = level4[0] + level4[1];

endmodule
