`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.08.2023 14:16:02
// Design Name: 
// Module Name: data_memory
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


module data_memory(
    output reg [31:0] read_data,
    input clk,rst, 
    input [2:0] readcontrol, writecontrol, 
    input [31:0] address, 
    input [31:0] writedata
    );
    
    
    reg [31:0] data_mem_file [255:0];
 
    
    integer i;
    always @(posedge clk or posedge rst) begin //write at WD3 if WE3
        if(rst)
        begin
            for(i=0;i<=255;i=i+1)begin    //set everything to 0
                data_mem_file[i]<=32'd0;
            end
        end
        else 
        begin
            case(writecontrol) 
                3'b000: data_mem_file[address >> 2] <= (data_mem_file[address >> 2] & ~(32'h000000ff << ({3'd0,address[1:0]} << 3))) | ({24'h000000,writedata[7:0]}<<({3'd0,address[1:0]}<<3));           
                3'b001: data_mem_file[address >> 2] <= (data_mem_file[address >> 2] & ~(32'h0000ffff << ({3'd0,address[1],1'd0} << 3))) | ({16'h0000,writedata[15:0]}<<({3'd0,address[1], 1'd0}<<3));           
                3'b010: data_mem_file[address >> 2] <=  writedata;
                default: begin
                    for(i=0;i<255;i=i+1)begin    //retain current value
                        data_mem_file[i] <= data_mem_file[i];
                    end 
                end 
            endcase
        end
    end
    
     always @(*) begin
        case (readcontrol)
            3'b000: read_data <= ((data_mem_file[address >> 2] << ((3-{3'd0,address[1:0]})<<3))) >>> 24 ;                  
            3'b001: read_data <= ((data_mem_file[address >> 2] << ((2-{3'd0,address[1], 1'd0})<<3))) >>> 16 ;
            3'b010: read_data <=  data_mem_file[address >> 2]; 
            3'b100: read_data <= ((data_mem_file[address >> 2] << ((3-{3'd0,address[1:0]})<<3))) >> 24;
            3'b101: read_data <= ((data_mem_file[address >> 2] << ((2-{3'd0,address[1], 1'd0})<<3))) >> 16 ;  
            default: begin
                        read_data <= 0;
            end
        endcase
    end
endmodule
