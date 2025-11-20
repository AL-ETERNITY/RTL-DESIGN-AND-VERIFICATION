`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.09.2025 14:42:26
// Design Name: 
// Module Name: Boolean_func_without_optimization
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Min term function implementation
// Min terms: 0, 4, 8, 10, 12, 16, 20, 24, 26, 28, 40, 42, 44, 46, 56, 58
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Boolean_func_without_optimization(
    input A,      // MSB
    input B,
    input C,
    input D,
    input E,
    input F,      // LSB
    output Y      // Output function
    );
    
    // Synthesis attributes to prevent optimization
    (* DONT_TOUCH = "TRUE" *) wire term0, term4, term8, term10, term12, term16, term20, term24;
    (* DONT_TOUCH = "TRUE" *) wire term26, term28, term40, term42, term44, term46, term56, term58;
    (* DONT_TOUCH = "TRUE" *) wire Y_internal;
    
    // Individual min terms - each will be implemented as separate logic
    (* DONT_TOUCH = "TRUE" *) assign term0  = (~A & ~B & ~C & ~D & ~E & ~F);  // Min term 0:  A'B'C'D'E'F'
    (* DONT_TOUCH = "TRUE" *) assign term4  = (~A & ~B & ~C &  D & ~E & ~F);  // Min term 4:  A'B'C'DE'F'
    (* DONT_TOUCH = "TRUE" *) assign term8  = (~A & ~B &  C & ~D & ~E & ~F);  // Min term 8:  A'B'CD'E'F'
    (* DONT_TOUCH = "TRUE" *) assign term10 = (~A & ~B &  C & ~D &  E & ~F);  // Min term 10: A'B'CD'EF'
    (* DONT_TOUCH = "TRUE" *) assign term12 = (~A & ~B &  C &  D & ~E & ~F);  // Min term 12: A'B'CDE'F'
    (* DONT_TOUCH = "TRUE" *) assign term16 = (~A &  B & ~C & ~D & ~E & ~F);  // Min term 16: A'BC'D'E'F'
    (* DONT_TOUCH = "TRUE" *) assign term20 = (~A &  B & ~C &  D & ~E & ~F);  // Min term 20: A'BC'DE'F'
    (* DONT_TOUCH = "TRUE" *) assign term24 = (~A &  B &  C & ~D & ~E & ~F);  // Min term 24: A'BCD'E'F'
    (* DONT_TOUCH = "TRUE" *) assign term26 = (~A &  B &  C & ~D &  E & ~F);  // Min term 26: A'BCD'EF'
    (* DONT_TOUCH = "TRUE" *) assign term28 = (~A &  B &  C &  D & ~E & ~F);  // Min term 28: A'BCDE'F'
    (* DONT_TOUCH = "TRUE" *) assign term40 = ( A & ~B &  C & ~D & ~E & ~F);  // Min term 40: AB'CD'E'F'
    (* DONT_TOUCH = "TRUE" *) assign term42 = ( A & ~B &  C & ~D &  E & ~F);  // Min term 42: AB'CD'EF'
    (* DONT_TOUCH = "TRUE" *) assign term44 = ( A & ~B &  C &  D & ~E & ~F);  // Min term 44: AB'CDE'F'
    (* DONT_TOUCH = "TRUE" *) assign term46 = ( A & ~B &  C &  D &  E & ~F);  // Min term 46: AB'CDEF'
    (* DONT_TOUCH = "TRUE" *) assign term56 = ( A &  B &  C & ~D & ~E & ~F);  // Min term 56: ABCD'E'F'
    (* DONT_TOUCH = "TRUE" *) assign term58 = ( A &  B &  C & ~D &  E & ~F);  // Min term 58: ABCD'EF'
    
    // OR all terms together
    (* DONT_TOUCH = "TRUE" *) assign Y_internal = term0 | term4 | term8 | term10 | term12 | term16 | 
                                                   term20 | term24 | term26 | term28 | term40 | term42 | 
                                                   term44 | term46 | term56 | term58;
    
    (* DONT_TOUCH = "TRUE" *) assign Y = Y_internal;
               
endmodule
