`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/30 01:08:49
// Design Name: 
// Module Name: ioread
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


module ioread(
    reset,
    ior,
    switchctrl,
    ioread_data,
    ioread_data_switch
);
    input       reset;
    input       ior;
    input       switchctrl;
    input[15:0] ioread_data_switch;
    output[15:0]    ioread_data;
    reg[15:0]   ioread_data;
    
    always @* begin
        if(reset == 1)
            ioread_data = 16'h0000;
            else if(ior == 1)
                if(switchctrl == 1)
                    ioread_data = ioread_data_switch;
                else
                    ioread_data = ioread_data;
    end
endmodule
