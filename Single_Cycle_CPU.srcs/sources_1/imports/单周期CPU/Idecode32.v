    module Idecode32(
read_data_1, 
read_data_2, 
Instruction, 
read_data, 
ALU_result, 
Jal, 
RegWrite, 
MemtoReg, 
RegDst, 
Sign_extend, 
clock, 
reset, 
opcplus4
);
output[31:0] read_data_1;               // register[rs]
output[31:0] read_data_2;               // register[rt]    
output[31:0] Sign_extend;               // Immediate extend to 32 bit    
input[31:0]  Instruction;               // the instrution from fetch instruction unit    
input[31:0]  read_data;                 // the data read from DATA RAM or I/O port    
input[31:0]  ALU_result;                // the alu result from excutation unit,need to extend to 32 bit-width    
input        Jal;                       // from control unit, 1 mean current instruction is JAL     
input        RegWrite;                  // from control unit    
input        MemtoReg;                  // from control unit, 1 means from memory, 0 means from ALU      
input        RegDst;                    // from control unit    
input        clock,reset;               // clock and reset     
input[31:0]  opcplus4;                   // from fetch unit, used in JAL

wire[31:0]  read_data_1;
wire[31:0]  read_data_2;
reg[31:0]   register[0:31];
reg[4:0]    write_register_address;
reg[31:0]   write_data_to_reg;

wire[4:0]   read_register_1_address;     // readR rs, R format, source 1
wire[4:0]   read_register_2_address;     // readR rt, R format, source 2
wire[4:0]   write_register_address_1;    // writeR rd, R format, dest    
wire[4:0]   write_register_address_0;    // writeR rt, I format, dest    
wire[15:0]  Instruction_immediate_value;    
wire[5:0]   opcode; 

assign read_register_1_address = Instruction[25:21];
assign read_register_2_address = Instruction[20:16];
assign write_register_address_0 = Instruction[20:16];
assign write_register_address_1 = Instruction[15:11];
assign Instruction_immediate_value = Instruction[15:0];
assign opcode = Instruction[31:26];
assign read_data_1 = register[read_register_1_address];
assign read_data_2 = register[read_register_2_address];
assign Sign_extend[15:0] = Instruction_immediate_value;
assign Sign_extend[31:16] = Instruction_immediate_value[15] ? 16'hffff : 16'h0000;

always @* begin
    if(Jal == 1'b1)
        write_register_address = 5'b11111;
    else if(RegDst == 1'b1)
        write_register_address = write_register_address_1;
    else
        write_register_address = write_register_address_0;
    //write_data_to_reg <= Jal ? opcplus4 : (MemtoReg ? read_data : ALU_result);
    //write_register_address <= Jal ? 5'b11111 : (RegDst ? write_register_address_1 : write_register_address_0);
end

always @* begin
    if(Jal == 1'b1)
        write_data_to_reg = opcplus4;
    else if(MemtoReg)
        write_data_to_reg = read_data;
    else
        write_data_to_reg = ALU_result;
    //write_data_to_reg <= Jal ? opcplus4 : (MemtoReg ? read_data : ALU_result);
    //write_register_address <= Jal ? 5'b11111 : (RegDst ? write_register_address_1 : write_register_address_0);
end

integer i;

always @(posedge clock) begin 
    if(reset) begin
        for (i = 0; i < 32; i = i + 1)
            register[i] <= 0;
    end
    else if(RegWrite && write_register_address) 
       register[write_register_address] <= write_data_to_reg;
end
endmodule