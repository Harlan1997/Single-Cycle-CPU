`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/29 22:56:32
// Design Name: 
// Module Name: minisys_sim
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


module minisys_sc_sim(
    
    );
    reg clk = 0;
    reg rst = 1;
    reg[23:0] switch2N4;
    wire[23:0] led2N4;
    
    minisys_sc u
    (
        .clk(clk),
        .reset(rst),
        .switch_i(switch2N4),
        .ledout(led2N4)
    );
    
    initial begin
        #7000 rst = 0;
        
    end
    always #10 clk = ~clk;
endmodule
