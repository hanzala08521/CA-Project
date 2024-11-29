`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2024 10:32:04 PM
// Design Name: 
// Module Name: Forwarding_Unit
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


module Forwarding_Unit(
    input [4:0] EXMEM_rd, MEMWB_rd,
    input [4:0] IDEX_rs1, IDEX_rs2,
    input EXMEM_RegWrite, EXMEM_MemtoReg,
    input MEMWB_RegWrite,

    output reg [1:0] fwd_A, fwd_B
);



always @(*) begin
    fwd_A = 2'b00; //defaultvalues
    fwd_B = 2'b00;

    if (EXMEM_rd == IDEX_rs1 && EXMEM_RegWrite && EXMEM_rd != 0) 
        begin
            fwd_A = 2'b10;
        end
    
    else if (((MEMWB_rd == IDEX_rs1) && MEMWB_RegWrite && (MEMWB_rd != 0)) 
            &&
            !(EXMEM_RegWrite && (EXMEM_rd != 0) && (EXMEM_rd == IDEX_rs1)))
        begin
            fwd_A = 2'b01;
        end
    
    else
        begin
            fwd_A = 2'b00;
        end
    
    
    if ((EXMEM_rd == IDEX_rs2) && (EXMEM_RegWrite) && (EXMEM_rd != 0))
        begin
            fwd_B = 2'b10;
        end
    
    else if (((MEMWB_rd == IDEX_rs2) && (MEMWB_RegWrite == 1) && (MEMWB_rd != 0)) 
            &&
            !(EXMEM_RegWrite && (EXMEM_rd != 0) && (EXMEM_rd == IDEX_rs2)
            ))
        begin
            fwd_B = 2'b01;
        end
    
    else 
        begin
            fwd_B = 2'b00;
        end
end

endmodule
