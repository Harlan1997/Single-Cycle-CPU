`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/29 22:43:31
// Design Name: 
// Module Name: clkx32
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


module clkx32(
    input clk_in,
    output clk_out
    );
    clk23Mhz clk23(
        .clk_in1(clk_in),
        .clk_out1(clk_out)
    );
endmodule
