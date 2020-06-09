module Executs32(
    Read_data_1, 
    Read_data_2, 
    Sign_extend, 
    Function_opcode, 
    Exe_opcode, 
    ALUOp, 
    Shamt, 
    ALUSrc, 
    I_format, 
    Zero, 
    Jrn, 
    Sftmd, 
    ALU_Result, 
    Add_Result, 
    PC_plus_4
    );

    input[31:0]     Read_data_1;
    input[31:0]     Read_data_2;
    input[31:0]     Sign_extend;
    input[5:0]      Function_opcode;
    input[5:0]      Exe_opcode;

    input[1:0]      ALUOp;
    input[4:0]      Shamt;
    input           Sftmd;
    input           ALUSrc;
    input           I_format;
    input           Jrn;
    output          Zero;
    output[31:0]    ALU_Result;             //  the ALU calculation result    
    output[31:0]    Add_Result;             //  the calculated address            
    input[31:0]     PC_plus_4;              //  from ifetch module    
    
    reg[31:0]       ALU_Result;                   
    reg[31:0]       ALU_output_mux;         // the result of arithmetic or logic calculation 
    wire[31:0]      Ainput,Binput;          // two operands   
    reg[31:0]       Sinput;                 // the result of shift operation       
    wire[2:0]       ALU_ctl;    
    wire[5:0]       Exe_code;    
    wire[2:0]       Sftm;    
    wire            Sftmd;
    wire[32:0]      Branch_Add;

    assign Sftm = Function_opcode[2:0];
    assign Exe_code = (I_format == 0) ? Function_opcode : {3'b000,Exe_opcode[2:0]}; 
    assign Ainput = Read_data_1;    
    assign Binput = (ALUSrc == 0) ? Read_data_2 : Sign_extend[31:0]; 
    assign ALU_ctl[0] = (Exe_code[0] | Exe_code[3]) & ALUOp[1];      
    assign ALU_ctl[1] = ((!Exe_code[2]) | (!ALUOp[1]));
    assign ALU_ctl[2] = (Exe_code[1] & ALUOp[1]) | ALUOp[0];
    assign Branch_Add = PC_plus_4[31:2] + Sign_extend[31:0]<<2;
    assign Add_Result = Branch_Add[31:0];
    assign Zero = (ALU_output_mux[31:0]== 32'h00000000) ? 1'b1 : 1'b0;

    // logical operation
    always  @(ALU_ctl or Ainput or Binput)
    begin
        case(ALU_ctl)
        3'b000 : ALU_output_mux = Ainput & Binput;
        3'b001 : ALU_output_mux = Ainput | Binput;
        3'b010 : ALU_output_mux = Ainput + Binput;
        3'b011 : ALU_output_mux = Ainput + Binput;
        3'b100 : ALU_output_mux = Ainput ^ Binput;
        3'b101 : ALU_output_mux = ~(Ainput | Binput);
        3'b110 : ALU_output_mux = Ainput - Binput;
        3'b111 : ALU_output_mux = Ainput - Binput;
        default: ALU_output_mux = 32'h00000000;
        endcase
    end

    // shift opertion
    
    always @* begin
        if(Sftmd)
            case(Sftm[2:0])
                3'b000 : Sinput = Binput << Shamt;
                3'b010 : Sinput = Binput >> Shamt;
                3'b100 : Sinput = Binput << Ainput;
                3'b110 : Sinput = Binput >> Ainput;
                3'b011 : Sinput = ({32{Binput[31]}} << ~Shamt) | (Binput >> Shamt);
                3'b111 : Sinput = ({32{Binput[31]}} << ~Ainput) | (Binput >> Ainput);
                default : Sinput = Binput;
            endcase
        else Sinput = Binput;
    end 

    always @* begin 
        //set type operation 
        if(((ALU_ctl == 3'b111) && (Exe_code[3] == 1))||((ALU_ctl[2:1] == 2'b11) && (I_format == 1) ))
            ALU_Result = (Ainput < Binput) ? 1'b1 : 1'b0;
        //lui operation        
        else if((ALU_ctl == 3'b101) && (I_format == 1))
            ALU_Result[31:0] = (Binput << 16) & 32'hFFFF0000;    
        //shift operation        
        else if(Sftmd == 1) 
            ALU_Result = Sinput;  
        //other types of operation in ALU         
        else  
            ALU_Result = ALU_output_mux[31:0];       
    end
    
    
endmodule