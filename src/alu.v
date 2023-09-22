`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.08.2023 12:15:34
// Design Name: 
// Module Name: alu
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


module alu(
    input [31:0] a,b,
    input [3:0] alu_sel,
    output reg [31:0] alu_out
    );
    
    always @(*)begin
    case(alu_sel)
    4'b0000: alu_out = a + b;        //add
    4'b0001: alu_out = a - b;        //sub
    4'b0010: alu_out = a ^ b;        //xor
    4'b0011: alu_out = a | b;        //or
    4'b0100: alu_out = a & b;        //and
    4'b0101: alu_out = a << b[4:0];  //logical shift left
    4'b0110: alu_out = a >> b[4:0];  //logical shift right
    4'b0111: alu_out = a >>> b[4:0]; //arithmetic shift right
    4'b1000: alu_out = a < b ? 32'd1 : 32'd0;  //set less than unsigned
    4'b1001: alu_out = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;  //set less than signed
    4'b1010: alu_out = b;            //lui instruction
    default: alu_out = 0;
    endcase
    
    end
endmodule
