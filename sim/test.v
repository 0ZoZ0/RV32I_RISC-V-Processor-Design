`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.08.2023 18:57:24
// Design Name: 
// Module Name: test
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


module test();

reg clk, rst, test;
reg [7:0] test_addr;
wire [31:0] Result;
wire hlt;

RV32I rv(.clk(clk),.rst(rst),.Result1(Result),.hlt(hlt), .test_address(test_addr));


initial
begin
 clk = 0;
 rst = 1;
end

always
 #5 clk = ~clk;
 
 initial
 begin
 #1.5 rst = 0;
 test_addr = 8'd4;

 #1000 $finish;  
 end
 
endmodule
