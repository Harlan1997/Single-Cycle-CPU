module control32(
    Opcode,
    Function_opcode,
    Alu_resultHigh,
    Jrn,RegDST,
    ALUSrc,
    MemorIOtoReg,
    RegWrite,
    MemRead,
    MemWrite,
    IORead,
    IOWrite,
    Branch,
    nBranch,
    Jmp,
    Jal,
    I_format,
    Sftmd,
    ALUOp
);
    input[5:0] Opcode;
    input[5:0] Function_opcode;
    input[21:0] Alu_resultHigh;
    output Jrn;
    output RegDST;
    output ALUSrc;
    output MemorIOtoReg;
    output RegWrite;
    output MemRead;
    output MemWrite;
    output IORead;
    output IOWrite;
    output Branch;
    output nBranch;
    output Jmp;
    output Jal;
    output I_format;
    output Sftmd;
    output[1:0] ALUOp;

    wire R_format;
    wire Lw;		
    wire Sw;		
   
    assign R_format = (Opcode==6'b000000) ? 1'b1:1'b0;    
    assign RegDST = R_format;                            
    assign I_format = (Opcode[5:3]==3'b001) ? 1'b1: 1'b0;
    assign Lw = (Opcode==6'b100011) ? 1'b1:1'b0;
    assign Jal = (Opcode==6'b000011) ? 1'b1:1'b0;
    assign Jrn = (R_format==1'b1 & Function_opcode==6'b001000)? 1'b1:1'b0;   
    assign RegWrite = (R_format || Lw || Jal || I_format) && !(Jrn);
    assign Sw = (Opcode==6'b101011) ? 1'b1:1'b0;
    assign ALUSrc = I_format | Lw | Sw;
    assign Branch = (Opcode==6'b000100) ? 1'b1:1'b0;
    assign nBranch = (Opcode==6'b000101)? 1'b1:1'b0;
    assign Jmp = (Opcode==6'b000010)? 1'b1:1'b0;
    assign MemWrite = ((Sw==1) && (Alu_resultHigh!=22'b1111111111111111111111))?1'b1:1'b0;
    assign MemorIOtoReg = (Lw==1)?1'b1:1'b0;
	assign MemRead = ((Lw==1) && (Alu_resultHigh!=22'b1111111111111111111111))?1'b1:1'b0;
	assign IOWrite = ((Sw==1) && (Alu_resultHigh==22'b1111111111111111111111))?1'b1:1'b0;
	assign IORead = ((Lw==1) && (Alu_resultHigh==22'b1111111111111111111111))?1'b1:1'b0;
    assign Sftmd = (Lw == 1)||(I_format) ? 0 : (Function_opcode[5:3]==3'b000)? 1'b1: 1'b0;
    assign ALUOp = {(R_format || I_format),(Branch || nBranch)};
endmodule