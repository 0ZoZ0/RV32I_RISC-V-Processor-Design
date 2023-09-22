`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/21/2023 01:34:19 PM
// Design Name: 
// Module Name: tenMz_gen
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


module tenMz_gen(
    input clk_100MHz,
    input reset,
    output clk_10Mz
    );
    
    reg [3:0] ctr_reg = 0; // 23 bits to cover 5,000,000
    reg clk_out_reg = 0;
    
    always @(posedge clk_100MHz or posedge reset)
        if(reset) begin
            ctr_reg <= 0;
            clk_out_reg <= 0;
        end
        else
            if(ctr_reg == 4) begin  // 100MHz / 10Hz / 2 = 5,000,000
                ctr_reg <= 0;
                clk_out_reg <= ~clk_out_reg;
            end
            else
                ctr_reg <= ctr_reg + 1;
    
    assign clk_10Mz = clk_out_reg;
    
endmodule
