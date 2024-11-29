`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2024 04:13:08 PM
// Design Name: 
// Module Name: Exec_Mem
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


module Exec_Mem(
input clk,
    input RegWrite, MemtoReg,
    input Branch, Zero, MemWrite, MemRead, Is_Greater,
    input [63:0] PCplusimm, ALU_result, WriteData,
    input [3:0] funct_in,
    input [4:0] rd,

    output reg RegWrite_store, MemtoReg_store,
    output reg Branch_store, Zero_store, MemWrite_store, 
                MemRead_store, Is_Greater_store,
    output reg [63:0] PCplusimm_store, ALU_result_store,
            WriteData_store,
    output reg [3:0] funct_in_store,
    output reg [4:0] rd_store
);


always @(negedge clk) begin
    RegWrite_store = RegWrite;
    MemtoReg_store = MemtoReg;
    Branch_store = Branch;
    Zero_store = Zero;
    Is_Greater_store = Is_Greater;
    MemWrite_store = MemWrite;
    MemRead_store = MemRead;
    PCplusimm_store = PCplusimm;
    ALU_result_store = ALU_result;
    WriteData_store = WriteData;
    funct_in_store = funct_in;
    rd_store = rd;
end


endmodule
