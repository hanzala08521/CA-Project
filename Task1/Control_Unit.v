`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2024 02:09:20 PM
// Design Name: 
// Module Name: Control_Unit
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


module Control_Unit(
    input [6:0] Opcode,
    output reg Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite,
    output reg [1:0] ALUop 
); 

    always @(*) begin 
        case (Opcode)
            7'b0110011: begin // R-type
                ALUop = 2'b10; 
                Branch = 0; 
                MemRead = 0; 
                MemtoReg = 0; 
                MemWrite = 0; 
                ALUSrc = 0; 
                RegWrite = 1; 
            end
            7'b0000011: begin // I-type (ld)
                ALUop = 2'b00; 
                Branch = 0; 
                MemRead = 1; 
                MemtoReg = 1; 
                MemWrite = 0; 
                ALUSrc = 1; 
                RegWrite = 1; 
            end
            7'b0100011: begin // S-type (sd)
                ALUop = 2'b00; 
                Branch = 0; 
                MemRead = 0; 
                MemtoReg = 1'bx; 
                MemWrite = 1; 
                ALUSrc = 1; 
                RegWrite = 0; 
            end
            7'b1100011: begin // SB-type (beq)
                ALUop = 2'b01; 
                Branch = 1; 
                MemRead = 0; 
                MemtoReg = 1'bx; 
                MemWrite = 0; 
                ALUSrc = 0; 
                RegWrite = 0; 
            end
            7'b0010011: begin // I-type (addi)
                ALUop = 2'b00; 
                Branch = 0; 
                MemRead = 0; 
                MemtoReg = 0; 
                MemWrite = 0; 
                ALUSrc = 1; 
                RegWrite = 1; 
            end
        endcase
    end 
endmodule
