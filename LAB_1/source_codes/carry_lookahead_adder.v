`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2025 02:06:28
// Design Name: 
// Module Name: carry_lookahead_adder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 32-bit Carry Lookahead Adder (Hierarchical Design)
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// 4-bit Carry Lookahead Generator
module cla_4bit_generator(
    input [3:0] g,      // Generate signals
    input [3:0] p,      // Propagate signals
    input cin,          // Carry input
    output [3:0] c      // Carry outputs (c1, c2, c3, c4)
);
    // Carry equations for 4-bit CLA
    assign c[0] = g[0] | (p[0] & cin);
    assign c[1] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & cin);
    assign c[2] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & cin);
    assign c[3] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | 
                  (p[3] & p[2] & p[1] & p[0] & cin);
endmodule

// 4-bit Carry Lookahead Adder
module cla_4bit(
    input [3:0] a,      // 4-bit input A
    input [3:0] b,      // 4-bit input B
    input cin,          // Carry input
    output [3:0] sum,   // 4-bit sum
    output cout,        // Carry output
    output g_out,       // Block generate
    output p_out        // Block propagate
);
    wire [3:0] g, p, c;
    
    // Generate and Propagate for each bit
    assign g[0] = a[0] & b[0];
    assign g[1] = a[1] & b[1];
    assign g[2] = a[2] & b[2];
    assign g[3] = a[3] & b[3];
    
    assign p[0] = a[0] ^ b[0];
    assign p[1] = a[1] ^ b[1];
    assign p[2] = a[2] ^ b[2];
    assign p[3] = a[3] ^ b[3];
    
    // Instantiate 4-bit carry generator
    cla_4bit_generator cla_gen (
        .g(g),
        .p(p),
        .cin(cin),
        .c(c)
    );
    
    // Sum calculation
    assign sum[0] = p[0] ^ cin;
    assign sum[1] = p[1] ^ c[0];
    assign sum[2] = p[2] ^ c[1];
    assign sum[3] = p[3] ^ c[2];
    
    // Carry output
    assign cout = c[3];
    
    // Block generate and propagate for next level
    assign g_out = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
    assign p_out = p[3] & p[2] & p[1] & p[0];
    
endmodule

// 16-bit Carry Lookahead Generator (for block level)
module cla_16bit_generator(
    input [3:0] g,      // Block generate signals
    input [3:0] p,      // Block propagate signals
    input cin,          // Carry input
    output [3:0] c      // Block carry outputs
);
    // Carry equations for 16-bit level (4 blocks of 4-bit)
    assign c[0] = g[0] | (p[0] & cin);
    assign c[1] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & cin);
    assign c[2] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & cin);
    assign c[3] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | 
                  (p[3] & p[2] & p[1] & p[0] & cin);
endmodule

// 32-bit Carry Lookahead Adder
module carry_lookahead_adder(
    input [31:0] a,      // 32-bit input A
    input [31:0] b,      // 32-bit input B
    input cin,           // Carry input
    output [31:0] sum,   // 32-bit sum
    output cout          // Carry output
);
    
    // Internal signals for hierarchical design
    wire [7:0] block_g, block_p;     // Block generate and propagate (8 blocks)
    wire [7:0] block_c;              // Block carry signals
    wire [7:0] block_cout;           // Individual block carry outputs
    
    // Level 1: 16-bit sections (2 sections of 16-bit each)
    wire [1:0] section_g, section_p, section_c;
    
    // Generate 8 blocks of 4-bit CLA adders
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : cla_blocks
            if (i == 0) begin
                // First block uses external cin
                cla_4bit cla_block (
                    .a(a[4*i+3:4*i]),
                    .b(b[4*i+3:4*i]),
                    .cin(cin),
                    .sum(sum[4*i+3:4*i]),
                    .cout(block_cout[i]),
                    .g_out(block_g[i]),
                    .p_out(block_p[i])
                );
            end else if (i < 4) begin
                // First 16-bit section (blocks 1-3)
                cla_4bit cla_block (
                    .a(a[4*i+3:4*i]),
                    .b(b[4*i+3:4*i]),
                    .cin(block_c[i-1]),
                    .sum(sum[4*i+3:4*i]),
                    .cout(block_cout[i]),
                    .g_out(block_g[i]),
                    .p_out(block_p[i])
                );
            end else if (i == 4) begin
                // Start of second 16-bit section
                cla_4bit cla_block (
                    .a(a[4*i+3:4*i]),
                    .b(b[4*i+3:4*i]),
                    .cin(section_c[0]),
                    .sum(sum[4*i+3:4*i]),
                    .cout(block_cout[i]),
                    .g_out(block_g[i]),
                    .p_out(block_p[i])
                );
            end else begin
                // Remaining blocks in second section
                cla_4bit cla_block (
                    .a(a[4*i+3:4*i]),
                    .b(b[4*i+3:4*i]),
                    .cin(block_c[i-1]),
                    .sum(sum[4*i+3:4*i]),
                    .cout(block_cout[i]),
                    .g_out(block_g[i]),
                    .p_out(block_p[i])
                );
            end
        end
    endgenerate
    
    // First 16-bit section carry generator (blocks 0-3)
    cla_16bit_generator section0_gen (
        .g(block_g[3:0]),
        .p(block_p[3:0]),
        .cin(cin),
        .c(block_c[3:0])
    );
    
    // Calculate section-level generate and propagate for first 16-bit section
    assign section_g[0] = block_g[3] | (block_p[3] & block_g[2]) | 
                          (block_p[3] & block_p[2] & block_g[1]) | 
                          (block_p[3] & block_p[2] & block_p[1] & block_g[0]);
    assign section_p[0] = block_p[3] & block_p[2] & block_p[1] & block_p[0];
    
    // Calculate section-level generate and propagate for second 16-bit section
    assign section_g[1] = block_g[7] | (block_p[7] & block_g[6]) | 
                          (block_p[7] & block_p[6] & block_g[5]) | 
                          (block_p[7] & block_p[6] & block_p[5] & block_g[4]);
    assign section_p[1] = block_p[7] & block_p[6] & block_p[5] & block_p[4];
    
    // Section-level carry generation
    assign section_c[0] = section_g[0] | (section_p[0] & cin);
    assign section_c[1] = section_g[1] | (section_p[1] & section_g[0]) | 
                          (section_p[1] & section_p[0] & cin);
    
    // Second 16-bit section carry generator (blocks 4-7)
    cla_16bit_generator section1_gen (
        .g(block_g[7:4]),
        .p(block_p[7:4]),
        .cin(section_c[0]),
        .c(block_c[7:4])
    );
    
    // Final carry output
    assign cout = section_c[1];
    
endmodule
