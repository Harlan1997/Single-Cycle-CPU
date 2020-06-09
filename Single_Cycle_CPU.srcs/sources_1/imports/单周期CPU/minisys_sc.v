`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/05/30 00:58:25
// Design Name: 
// Module Name: minisys
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


module minisys_sc(
    input clk,
    input reset,
    input[23:0] switch_i,
    output[23:0] ledout
);
    wire            clock;
    wire[5:0]       Opcode;
    wire[31:0]      ALU_Result;
    wire[31:0]      read_data_1;
    wire[31:0]      read_data_2;
    wire[31:0]      Instruction;            
    wire[31:0]      PC_plus_4_out;
    wire[31:0]      opcplus4;          
    wire[31:0]      Add_Result;                                
    wire            Branch;                          
    wire            nBranch;                     
    wire            Jmp;                     
    wire            Jal;                     
    wire            Jrn;                 
    wire            Zero;   
    wire            ledctrl;
    wire            switchctrl;
    wire[15:0]      ioread_data;
    wire[15:0]      ioread_data_switch;
    wire[31:0]      Sign_extend;        // the output of decode unit which the extended 32bit-width instance data    
    wire[31:0]      rdata;              // the data read from DATA RAM or I/O port    
    wire            RegWrite;                  // from control unit    
    wire            MemorIOtoReg;               // from control unit    
    wire            RegDST;                    // from control unit  
    wire            MemWrite;
    wire[31:0]      write_data;
    wire[31:0]      read_data;
    wire[31:0]      address;   
    wire[5:0]       Function_opcode;
    wire[21:0]      Alu_resultHigh;
    wire            ALUSrc;
    wire            MemRead;
    wire            IORead;
    wire            IOWrite;
    wire            I_format;
    wire            Sftmd;
    wire[1:0]       ALUOp;
    wire[5:0]       Exe_opcode;         
    wire[4:0]       Shamt;              
    assign          Shamt = Instruction[10:6];
    assign          Exe_opcode = Instruction[31:26];
    assign          Function_opcode = Instruction[5:0];
    assign          Alu_resultHigh = ALU_Result[31:10];
    assign          Opcode = Instruction[31:26];        
   
    clkx32 cpuclk(
        .clk_in(clk),
        .clk_out(clock)
    );
    
    Ifetc32 ftc(
        .Instruction(Instruction),
        .PC_plus_4_out(PC_plus_4_out),
        .Add_result(Add_Result),
        .Read_data_1(read_data_1),
        .Branch(Branch),
        .nBranch(nBranch),
        .Jmp(Jmp),
        .Jal(Jal),
        .Jrn(Jrn),
        .Zero(Zero),
        .clock(clock),
        .reset(reset),
        .opcplus4(opcplus4)
    );
  
       
    Idecode32 idc(
        .read_data_1(read_data_1),
        .read_data_2(read_data_2),
        .Instruction(Instruction),
        .read_data(rdata),
        .ALU_result(ALU_Result),
        .Jal(Jal),
        .RegWrite(RegWrite),
        .MemtoReg(MemorIOtoReg),
        .RegDst(RegDST),
        .Sign_extend(Sign_extend),
        .clock(clock),
        .reset(reset),
        .opcplus4(opcplus4)
    );


    dmemory32 dme(
        .clock(clock),
        .address(address),
        .write_data(write_data),
        .MemWrite(MemWrite),
        .read_data(read_data)
    );



    control32 ctr(
        .Opcode(Opcode),
        .Function_opcode(Function_opcode),
        .Alu_resultHigh(Alu_resultHigh),
        .Jrn(Jrn),
        .RegDST(RegDST),
        .ALUSrc(ALUSrc),
        .MemorIOtoReg(MemorIOtoReg),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .IORead(IORead),
        .IOWrite(IOWrite),
        .Branch(Branch),
        .nBranch(nBranch),
        .Jmp(Jmp),
        .Jal(Jal),
        .I_format(I_format),
        .Sftmd(Sftmd),
        .ALUOp(ALUOp)
    );


    Executs32 exe(
        .Read_data_1(read_data_1),
        .Read_data_2(read_data_2),
        .Sign_extend(Sign_extend),
        .Function_opcode(Function_opcode),
        .Exe_opcode(Exe_opcode),
        .ALUOp(ALUOp),
        .Shamt(Shamt),
        .ALUSrc(ALUSrc),
        .I_format(I_format),
        .Zero(Zero),
        .Jrn(Jrn),
        .Sftmd(Sftmd),
        .ALU_Result(ALU_Result),
        .Add_Result(Add_Result),
        .PC_plus_4(PC_plus_4_out)
    );


    memorio memio(
        .caddress(ALU_Result),      //input
        .memread(MemRead),          //input
        .memwrite(MemWrite),
        .ioread(IORead),            //input
        .iowrite(IOWrite),          //input
        .mread_data(read_data),     //input     from memory
        .ioread_data(ioread_data),  //input     from io
        .wdata(read_data_2),        //input     from register
        .rdata(rdata),              //output
        .write_data(write_data),    //output    data to memory or io
        .address(address),          //output
        .LEDCtrl(ledctrl),          //output
        .SwitchCtrl(switchctrl)     //output
    );


    ioread multiioread(
        .reset(reset),
        .ior(IORead),
        .ioread_data(ioread_data),
        .switchctrl(switchctrl),
        .ioread_data_switch(ioread_data_switch)
    );

    leds led24(
        .led_clk(clock),
        .ledrst(reset),
        .ledwrite(IOWrite),
        .ledcs(ledctrl),
        .ledaddr(address[1:0]),
        .ledwdata(write_data[15:0]),
        .ledout(ledout)
    );
    
    switchs switch24(
        .switclk(clock),
        .switrst(reset),
        .switchcs(switchctrl),
        .switchaddr(address[1:0]),
        .switchread(IORead),
        .switch_i(switch_i),
        .switchrdata(ioread_data_switch)
    );
endmodule


