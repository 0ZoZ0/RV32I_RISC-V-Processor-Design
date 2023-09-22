`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/21/2023 12:02:17 PM
// Design Name: 
// Module Name: digits
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


module digits(
    input clk_10Hz,
    input reset, hlt,
    input [31:0] Result,
    output reg [3:0] ones,
    output reg [3:0] tens,
    output reg [3:0] hundreds,
    output reg [3:0] thousands
    );
    
    // ones reg control
    always @(posedge clk_10Hz or posedge reset)
        begin
            if(reset || !hlt)
                begin
                    ones <= 0;
                    tens <= 0;
                    hundreds <= 0;
                    thousands <= 0;                
                end
             else
                begin
                    ones <= Result[3:0];
                    tens <= Result[7:4];
                    hundreds <= Result[11:8];
                    thousands <= Result[15:12]; 
                end
        
        end
  
endmodule
