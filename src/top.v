`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/21/2023 12:23:24 PM
// Design Name: 
// Module Name: top
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


module top(
    input clk_100MHz,       // from Basys 3
    input reset,            // btnC
    output [0:6] seg,       // 7 segment display segment pattern
    output [3:0] digit      // 7 segment display anodes
    );
    
    // Internal wires for connecting inner modules
    wire w_10Hz, hlt, wire_10Mz;
    wire [3:0] w_1s, w_10s, w_100s, w_1000s;
    wire [31:0] result;
    
    // Instantiate inner design modules
    tenHz_gen hz10(.clk_100MHz(clk_100MHz), .reset(reset), .clk_10Hz(w_10Hz));
    tenMz_gen Mz10(.clk_100MHz(clk_100MHz), .reset(reset), .clk_10Mz(w_10Mz));
    
    digits digs(.clk_10Hz(w_10Hz), .reset(reset), .ones(w_1s), 
                .tens(w_10s), .hundreds(w_100s), .thousands(w_1000s), .hlt(hlt), .Result(result));
    
    seg7_control seg7(.clk_100MHz(clk_100MHz), .reset(reset), .ones(w_1s), .tens(w_10s),
                      .hundreds(w_100s), .thousands(w_1000s), .seg(seg), .digit(digit));
                      
    RV32I dut(.Result1(result), .test_address(8'd4), .hlt(hlt), .clk(w_10Mz), .rst(reset));
  
endmodule
