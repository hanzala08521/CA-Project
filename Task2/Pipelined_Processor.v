`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2024 04:08:01 PM
// Design Name: 
// Module Name: Pipelined_Processor
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


module Pipelined_Processor(
    input clk, reset,
    output [4:0] rd_out, rs1_out, rs2_out, 
    output [63:0] ReadData1_out, ReadData2_out, IDEX_ReadData1_out, IDEX_ReadData2_out, 
    output [4:0] IDEX_rd_out, 
    output [63:0] EXMEM_ReadData2_out, 
    output [4:0] EXMEM_rd_out,
    output [63:0] MEMWB_DM_Read_Data_out, 
    output [4:0] MEMWB_rd_out);

wire [63:0] PC_to_IM;
wire [31:0] IM_to_IFID;
wire [6:0] opcode_out; 
wire [2:0] funct3_out;
wire [6:0] funct7_out;
wire Branch_out, MemRead_out, MemtoReg_out, MemWrite_out, ALUSrc_out, RegWrite_out;
wire Is_Greater_out;
wire [1:0] ALUOp_out;
wire [63:0] mux_to_reg;
wire [63:0] mux_to_pc_in;
wire [3:0] ALU_C_Operation;
//wire [63:0] ReadData1_out, ReadData2_out;
wire [63:0] imm_data_out;
wire [63:0] fixed_4 = 64'd4;
wire [63:0] PC_plus_4_to_mux;
wire [63:0] alu_mux_out;
wire [63:0] alu_result_out;
wire zero_out;
wire [63:0] imm_to_adder;
wire [63:0] imm_adder_to_mux;
wire [63:0] DM_Read_Data_out;
wire pc_mux_sel_wire;
wire IDEX_Branch_out, IDEX_MemRead_out, IDEX_MemtoReg_out;
wire IDEX_MemWrite_out, IDEX_ALUSrc_out, IDEX_RegWrite_out;
wire [63:0] MEMWB_alu_result_out;
//IDEX WIRES
wire [63:0] IDEX_PC_addr, IDEX_imm_data_out;
wire [3:0] IDEX_funct_in;
wire [1:0] IDEX_ALUOp_out;

assign imm_to_adder = IDEX_imm_data_out<< 1;


//EXMEM WIRES
wire EXMEM_Branch_out, EXMEM_MemRead_out, EXMEM_MemtoReg_out;
wire EXMEM_MemWrite_out, EXMEM_RegWrite_out; 
wire EXMEM_zero_out, EXMEM_Is_Greater_out;
wire [63:0] EXMEM_PC_plus_imm, EXMEM_alu_result_out;
wire [3:0] EXMEM_funct_in;

//MEMWB WIRES
wire MEMWB_MemtoReg_out, MEMWB_RegWrite_out;
wire [63:0] IFID_PC_addr;
wire [31:0] IFID_IM_to_parse;
wire [3:0] funct_in;
wire [63:0] pcplusimm_to_EXMEM;

Mux MUX_PC
(
    EXMEM_PC_plus_imm,   //value when sel is 1
    PC_plus_4_to_mux,
    pc_mux_sel_wire,
    mux_to_pc_in
);

Program_Counter PC (
    clk, 
    reset,
    mux_to_pc_in,
    PC_to_IM
);

Adder PC_Inc
(
    PC_to_IM,
    fixed_4,
    PC_plus_4_to_mux
);

Instruction_Memory IM
(
    PC_to_IM,
    IM_to_IFID
);

InstructionF_InstructionD IF_ID
(
    clk,
    PC_to_IM,
    IM_to_IFID,
    IFID_PC_addr,
    IFID_IM_to_parse
);
//IF_ID HERE

InsParser InsParser
(
    IFID_IM_to_parse,
    opcode_out,
    rd_out,
    funct3_out,
    rs1_out,
    rs2_out,
    funct7_out
);

assign funct_in = {IFID_IM_to_parse[30],IFID_IM_to_parse[14:12]};

Control_Unit CU
(
    opcode_out,
    Branch_out, 
    MemRead_out, 
    MemtoReg_out,
    MemWrite_out, 
    ALUSrc_out,
    RegWrite_out,
    ALUOp_out
);

RegisterFile RF
(
    clk,
    reset,
    MEMWB_RegWrite_out, //change
    mux_to_reg,
    rs1_out,
    rs2_out,
    MEMWB_rd_out,    
    ReadData1_out,
    ReadData2_out 
);

ImmGen IG
(
    IFID_IM_to_parse,
    imm_data_out
);

InstructionD_Exec ID_EX
(
    clk,
    IFID_PC_addr,
    ReadData1_out,
    ReadData2_out,
    imm_data_out,
    funct_in,
    rd_out,
    RegWrite_out,
    MemtoReg_out,
    Branch_out,
    MemWrite_out,
    MemRead_out,
    ALUSrc_out,
    ALUOp_out,

    IDEX_PC_addr,
    IDEX_ReadData1_out,
    IDEX_ReadData2_out,
    IDEX_imm_data_out,
    IDEX_funct_in,
    IDEX_rd_out,
    IDEX_RegWrite_out,
    IDEX_MemtoReg_out,
    IDEX_Branch_out,
    IDEX_MemWrite_out,
    IDEX_MemRead_out,
    IDEX_ALUSrc_out,
    IDEX_ALUOp_out

);
// ID/EX HERE

ALU_Control ALU
(
    IDEX_ALUOp_out,
    IDEX_funct_in,
    ALU_C_Operation
);


Mux MUX_ALU
(
    IDEX_imm_data_out, //value when sel is 1
    IDEX_ReadData2_out,
    IDEX_ALUSrc_out,
    alu_mux_out
);


ALU_64 ALU64
(
    IDEX_ReadData1_out,
    alu_mux_out, 
    ALU_C_Operation,
    alu_result_out,
    zero_out,
    Is_Greater_out
);

Adder IMMInc
(
    IDEX_PC_addr,
    imm_to_adder,
    pcplusimm_to_EXMEM
);

Exec_Mem EX_MEM
(
    clk,
    IDEX_RegWrite_out,
    IDEX_MemtoReg_out,
    IDEX_Branch_out,
    zero_out,
    Is_Greater_out,
    IDEX_MemWrite_out,
    IDEX_MemRead_out,
    pcplusimm_to_EXMEM,
    alu_result_out,
    IDEX_ReadData2_out,
    IDEX_funct_in,
    IDEX_rd_out,

    EXMEM_RegWrite_out,
    EXMEM_MemtoReg_out,
    EXMEM_Branch_out,
    EXMEM_zero_out,
    EXMEM_Is_Greater_out,
    EXMEM_MemWrite_out,
    EXMEM_MemRead_out,
    EXMEM_PC_plus_imm,
    EXMEM_alu_result_out,
    EXMEM_ReadData2_out,
    EXMEM_funct_in,
    EXMEM_rd_out
);

// EX/MEM HERE

Branch BC
(
    EXMEM_Branch_out,
    EXMEM_zero_out,
    EXMEM_Is_Greater_out,
    EXMEM_funct_in,
    pc_mux_sel_wire
);

Data_Memory DM
(
    EXMEM_alu_result_out,
    EXMEM_ReadData2_out,
    clk,
    EXMEM_MemWrite_out,
    EXMEM_MemRead_out,
    DM_Read_Data_out 
);

Mem_WriteB MEM_WB
(
    clk,
    EXMEM_RegWrite_out,
    EXMEM_MemtoReg_out,
    DM_Read_Data_out,
    EXMEM_alu_result_out,
    EXMEM_rd_out,

    MEMWB_RegWrite_out,
    MEMWB_MemtoReg_out,
    MEMWB_DM_Read_Data_out,
    MEMWB_alu_result_out,
    MEMWB_rd_out
);

// MEM/WB HERE

Mux M2
(
    MEMWB_DM_Read_Data_out, //value when sel is 1
    MEMWB_alu_result_out,
    MEMWB_MemtoReg_out,
    mux_to_reg
);


endmodule 

