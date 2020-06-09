`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/22 23:48:52
// Design Name: 
// Module Name: Ifetc32
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


module Ifetc32(Instruction,PC_plus_4_out,Add_result,Read_data_1,Branch,nBranch,Jmp,Jal,Jrn,Zero,clock,reset, opcplus4);
    output[31:0] Instruction; // the instruction fetched from this module    
    output[31:0] PC_plus_4_out;          // (pc+4) to ALU which is used by branch type instruction   
    input[31:0]  Add_result;                  // from ALU module£¬the calculated address     
    input[31:0]  Read_data_1;               // from decoder£¬the address of instruction used by jr instruction    
    input        Branch;                           // from controller, while Branch is 1,it means current instruction is beq    
    input        nBranch;                     // from controller, while nBranch is 1,it means current instruction is bnq    
    input        Jmp;                   // from controller, while Jmp 1,it means current instruction is jump     
    input        Jal;                   // from controller, while Jal is 1,it means current instruction is jal    
    input        Jrn;                   // from controller, while jrn is 1,it means current instruction is jr    
    input        Zero;                  // from ALU, while Zero is 1, it means the ALUresult is zero    
    input        clock,reset;           // Clock and reset    
    output[31:0] opcplus4;              // (pc+4) to  decoder which is used by jal instruction
    reg[31:0]   PC;
    wire[31:0]  Instruction;

    prgrom instm(
            .clka(clock),
            .addra(PC[15:2]),
            .douta(Instruction)
        );

    // PC + 4
    wire [31:0] PC_plus_4;
    assign PC_plus_4[31:2] = PC[31:2] + 1;
    assign PC_plus_4[1:0] = 2'b00;
    assign PC_plus_4_out = PC_plus_4; 
    
    // update next PC
    reg[31:0] next_PC;
    always @* begin                   
                    
            
            if (Branch==1'b1 & Zero==1'b1)
                next_PC = Add_result;
            else if (nBranch==1'b1 & Zero==1'b0)
                next_PC = Add_result;
            else if (Jrn==1'b1)
                next_PC = Read_data_1;
            else
                next_PC = PC_plus_4;
    end 
    
    reg[31:0] opcplus4;
   
    always @(negedge clock) begin
        if (reset)
            begin
                PC = 32'd0;
            end
        else
        begin
            if (Jmp==1'b1)
                begin
                    PC = Instruction[25:0]<<2;
                end
            else if (Jal==1'b1)
                begin
                    opcplus4 = PC_plus_4;
                    PC = Instruction[25:0]<<2;
                end
            else
                begin
                    PC = next_PC;
                end
        end
   end
    endmodule