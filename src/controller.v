`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.08.2023 14:53:16
// Design Name: 
// Module Name: controller
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

module controller(  output reg [2:0] immsrc, 
                    output reg [3:0] alu_op, 
                    output reg [2:0] br_type, readcontrol, writecontrol,
                    output reg reg_wr, sel_A, sel_B, hlt,
                    output reg [1:0] wb_sel,
                    input [6:0] opcode,      
                    input [14:12] funct3,      
                    input [31:25] funct7            
                    );
                    
        
        reg R,Ii,S,L,B,auipc,lui,jal,jalr,halt;
        
        `define instr_type {R,Ii,S,L,B,auipc,lui,jal,jalr,halt}
        `define control_signals {immsrc,sel_A, sel_B,wb_sel,reg_wr,hlt}
        
        //instruction type determination
    always@(*)begin    
            case(opcode)//instr_type {R,Ii,S,L,B,auipc,lui,jal,jalr,halt}  
                3:  `instr_type<=  'b0001000000;                         
                19: `instr_type<=  'b0100000000;                        
                23: `instr_type<=  'b0000010000;                         
                35: `instr_type<=  'b0010000000;                         
                51: `instr_type<=  'b1000000000;                         
                55: `instr_type<=  'b0000001000;                         
                70: `instr_type<=  'b0000000001;			              
		        99: `instr_type<=  'b0000100000;                         
                103:`instr_type<=  'b0000000010;                          
                111:`instr_type<=  'b0000000100;                          
                default:`instr_type<= 'b0000000000;
            endcase    
    end
    
     //alu control signals
        always@(*)begin
        if(R||Ii) begin
            casex({R,funct7[30],funct3})   
                5'b10000:  alu_op <= 0;  //add
                5'b11000:  alu_op <= 1;  //sub
                5'b00000:  alu_op <= 0;  //addi
                5'b10001:  alu_op <= 5;  //sll
                5'b00001:  alu_op <= 5;  //slli
                5'b10010:  alu_op <= 9;  //slt
                5'b00010:  alu_op <= 9;  //slti
                5'b10011:  alu_op <= 8;  //sltu
                5'b00011:  alu_op <= 8;  //sltiu
                5'b10100:  alu_op <= 2;  //xor
                5'b00100:  alu_op <= 2;  //xori
                5'b10101:  alu_op <= 6;  //srl
                5'b00101:  alu_op <= 6;  //srli
                5'b11101:  alu_op <= 7;  //sra
                5'b01101:  alu_op <= 7;  //srai
                5'b10110:  alu_op <= 3;  //or
                5'b00110:  alu_op <= 3;  //ori
                5'b10111:  alu_op <= 4;  //and
                5'b00111:  alu_op <= 4;  //andi
                default:    alu_op <= 0;
            endcase    
        end
        else if(lui)begin
            alu_op <= 10;   //aluop for result = B
        end 
        else begin
            alu_op <= 0;    //all other instructions use operation A+B of ALU
        end            
    end
   
   
   //data memory operation
    always @(*) begin     
        case ({S})
            1: writecontrol <= funct3;
            default: writecontrol <= 7;  //retain current value
        endcase
    end

    always @(*) begin
        case ({L})
            1: readcontrol <= funct3;
            default: readcontrol <= 7;  //output 0
        endcase
    end
   
   
   //branch instruction
       always @(*) begin                
        case({jal,jalr,B})
            3'b100: br_type <= 3 ;
            3'b010: br_type <= 3 ;      //jal,jalr
            3'b001: br_type <= funct3 ;
            default: br_type <= 2;      //no jump
        endcase
    end
    
    //control signals
    
     always@(*)begin
        case(`instr_type)    
           //control_signals {ImmSrc,sel_A, sel_B,wb_sel,reg_wr,hlt}               
           /*             
            instr_type     Description             ALU     sel_A   sel_B  wb_sel  imm_src     br_type   alu_op  reg_wr      d_wr        
            L-instr_type   load                    yes     1       1       2       0           none      0       1           0
            I-instr_type   immediate operation     yes     1       1       1       0           none      xxxx    1           0
            U-instr_type   auipc                   yes     0       1       1       3(u)        none      0       1           0
            S-instr_type   Store                   yes     1       1       z       1           none      0       0           1
            R-instr_type   register operation      yes     1       0       1       z           none      xxxx    1           0
            U-instr_type   lui                     yes     1       1       1       4(u)        none      copy    1           0
            HALT           HALT
		    B-instr_type   conditional branch      yes     0       1       z       2           xxx       0       0           0
            I-instr_type   jalr                    yes     1       1       0       0           uncond    0       1           0
            J-instr_type   jal                     yes     0       1       0       3           uncond    0       1           0
           */
           
            10'b1000000000: `control_signals <= 9'b000100110; //R
            10'b0100000000: `control_signals <= 9'b000110110; //Ii
            10'b0010000000: `control_signals <= 9'b001110000; //S
            10'b0001000000: `control_signals <= 9'b000111010; //L
            10'b0000100000: `control_signals <= 9'b010010000; //B
            10'b0000010000: `control_signals <= 9'b011010110; //auipc
            10'b0000001000: `control_signals <= 9'b011110110; //lui
            10'b0000000100: `control_signals <= 9'b100010010; //jal
            10'b0000000010: `control_signals <= 9'b000110010; //jalr
	        10'b0000000001: `control_signals <= 9'b000000001; //HALT
            default: `control_signals<=0;
        endcase
    end
endmodule

