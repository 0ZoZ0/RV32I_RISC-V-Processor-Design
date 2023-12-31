`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.08.2023 18:26:25
// Design Name: 
// Module Name: RV32I
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


module RV32I(
output reg [31:0] Result1,
input [7:0] test_address,
output hlt,
input clk,rst
    );

wire [31:0] Result; 
wire [6:0] opcode;
wire [14:12] funct3; 
wire [31:25] funct7; 
wire [31:0] instr;
wire br_taken,resultsrc,reg_wr,sel_A,sel_B; 
wire [3:0] alu_op;
wire [2:0] immsrc, br_type,readcontrol,writecontrol;
wire [1:0] wb_sel;
wire gated_clk;



datapath dp(.opcode(opcode), .funct3(funct3), .funct7(funct7), .Result(Result), .rst(rst),.clk(gated_clk),.reg_wr(reg_wr),.sel_A(sel_A),.sel_B(sel_B), .wb_sel(wb_sel), 
.immsrc(immsrc), .alu_op(alu_op),.br_type(br_type),.readcontrol(readcontrol),.writecontrol(writecontrol));

controller con(.immsrc(immsrc),.alu_op(alu_op),.br_type(br_type),.readcontrol(readcontrol),.writecontrol(writecontrol), .reg_wr(reg_wr), .sel_A(sel_A), .sel_B(sel_B),.hlt(hlt), 
.wb_sel(wb_sel), .opcode(opcode), .funct3(funct3), .funct7(funct7));

halt stop(.gated_clk(gated_clk),.hlt(hlt),.clk(clk));

always @(*)
    begin
        if(hlt)
            Result1 <= dp.data_mem.data_mem_file[test_address >> 2];
        else
            Result1 <= Result;
    end
endmodule
