`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.11.2025 14:13:52
// Design Name: 
// Module Name: traffic_light
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


//====================================================
// traffic_fsm.v - Simple 2-way Traffic Light Controller
//====================================================
(* keep_hierarchy = "yes" *)
module traffic_light #(
    parameter integer GREEN_CYCLES  = 50,
    parameter integer YELLOW_CYCLES = 10
)(
    input  wire clk,
    input  wire reset_n,
    output reg  ns_g,
    output reg  ns_y,
    output reg  ns_r,
    output reg  ew_g,
    output reg  ew_y,
    output reg  ew_r
);

    //====================================================
    // State encoding (using parameters)
    //====================================================
    (* keep = "true", dont_touch = "true" *) parameter [1:0] 
        S_NS_GREEN = 2'b00,
        S_NS_YEL   = 2'b01,
        S_EW_GREEN = 2'b10,
        S_EW_YEL   = 2'b11;

    (* keep = "true", dont_touch = "true" *) reg [1:0] state, next_state;
    (* keep = "true", dont_touch = "true" *) integer timer;

    //====================================================
    // Next state logic
    //====================================================
    always @(*) begin
        next_state = 2'bxx; // don't care default for optimization blocking
        case (state)
            S_NS_GREEN: next_state = (timer == GREEN_CYCLES-1) ? S_NS_YEL : S_NS_GREEN;
            S_NS_YEL:   next_state = (timer == YELLOW_CYCLES-1) ? S_EW_GREEN : S_NS_YEL;
            S_EW_GREEN: next_state = (timer == GREEN_CYCLES-1) ? S_EW_YEL : S_EW_GREEN;
            S_EW_YEL:   next_state = (timer == YELLOW_CYCLES-1) ? S_NS_GREEN : S_EW_YEL;
            default:    next_state = S_NS_GREEN;
        endcase
    end

    //====================================================
    // Sequential logic (state register + timer)
    //====================================================
    always @(posedge clk or posedge reset_n) begin
        if (reset_n) begin
            state <= S_NS_GREEN;
            timer <= 0;
        end else begin
            if (state != next_state) begin
                state <= next_state;
                timer <= 0;
            end else begin
                timer <= timer + 1;
            end
        end
    end

    //====================================================
    // Output logic (Moore machine)
    //====================================================
    always @(*) begin
        {ns_g, ns_y, ns_r, ew_g, ew_y, ew_r} = 6'bxxxxxx; // don't-care default
        case (state)
            S_NS_GREEN: begin ns_g = 1; ns_y = 0; ns_r = 0; ew_g = 0; ew_y = 0; ew_r = 1; end
            S_NS_YEL:   begin ns_g = 0; ns_y = 1; ns_r = 0; ew_g = 0; ew_y = 0; ew_r = 1; end
            S_EW_GREEN: begin ns_g = 0; ns_y = 0; ns_r = 1; ew_g = 1; ew_y = 0; ew_r = 0; end
            S_EW_YEL:   begin ns_g = 0; ns_y = 0; ns_r = 1; ew_g = 0; ew_y = 1; ew_r = 0; end
            default:    {ns_g, ns_y, ns_r, ew_g, ew_y, ew_r} = 6'b000000;
        endcase
    end

endmodule
