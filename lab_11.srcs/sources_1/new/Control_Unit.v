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
            7'b0110011: begin // R-type Instruction
                ALUop = 2'b10; //ALU operations based on funct3 and funct7
                Branch = 0;   
                MemRead = 0; 
                MemtoReg = 0; 
                MemWrite = 0; 
                ALUSrc = 0; //Both ALU operands come from registers.
                RegWrite = 1; // Writes the result back to the rd
            end
            7'b0000011: begin // I-type (ld) 
                ALUop = 2'b00; //ALU performs addition for address calculation.
                Branch = 0; 
                MemRead = 1; //Enables memory read.
                MemtoReg = 1; //Selects memory data for writing to the register file.
                MemWrite = 0; 
                ALUSrc = 1; 
                RegWrite = 1; //Second ALU operand is the imm offset
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
            7'b1100011: begin // SB-type (beq)
                ALUop = 2'b01; //ALU performs subtraction for comparison.
                Branch = 1; 
                MemRead = 0; 
                MemtoReg = 1'bx; 
                MemWrite = 0; 
                ALUSrc = 0; 
                RegWrite = 0; 
            end
            7'b0100011: begin // S-type (sd)
                ALUop = 2'b00; //ALU performs addition for address calculation.
                Branch = 0; 
                MemRead = 0; 
                MemtoReg = 1'bx; ////Not relevant as data is not being written back to register but memory instead
                MemWrite = 1; 
                ALUSrc = 1; 
                RegWrite = 0;
            end
        endcase
    end 
endmodule
