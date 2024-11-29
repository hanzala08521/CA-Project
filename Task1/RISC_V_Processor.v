`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/25/2024 01:56:06 PM
// Design Name: 
// Module Name: RISC_V_Processor
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


module RISC_V_Processor(
    clk, reset,
    element1,element2,element3
);
input clk, reset;
output wire [63:0] element1,element2,element3;
wire [63:0] PC_to_IM;
wire [31:0] IM_to_parse;
wire [6:0] opcode_out; 
wire[4:0] rd_out;
wire [2:0] funct3_out;
wire [6:0] funct7_out;
wire [4:0] rs1_out, rs2_out;
wire Branch_out, MemRead_out, MemtoReg_out, MemWrite_out, ALUSrc_out, RegWrite_out;
wire Is_Greater_out;
wire [1:0] ALUOp_out;
wire [63:0] mux_to_reg;
wire [63:0] mux_to_pc_in;
wire [3:0] ALU_C_Operation;
wire pc_mux_sel_wire;
wire [63:0] imm_adder_to_mux;
wire [63:0] imm_to_adder;
wire [63:0] fixed_4 = 64'd4;
wire [63:0] PC_plus_4_to_mux;
wire [63:0] DM_Read_Data_out;
wire [63:0] alu_result_out;
wire zero_out;
wire [63:0] alu_mux_out;
wire [3:0] funct_in;
wire [63:0] imm_data_out;
wire [63:0] ReadData1_out, ReadData2_out;

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

Program_Counter PC (
    clk, 
    reset,
    mux_to_pc_in,
    PC_to_IM
);

ImmGen IG
(
    IM_to_parse,
    imm_data_out
);

Instruction_Memory IM
(
    PC_to_IM,
    IM_to_parse
);

InsParser IN
(
    IM_to_parse,
    opcode_out,
    rd_out,
    funct3_out,
    rs1_out,
    rs2_out,
    funct7_out
);

ALU_64 ALU64
(
    ReadData1_out,
    alu_mux_out, 
    ALU_C_Operation,
    alu_result_out,
    zero_out,
    Is_Greater_out
);


RegisterFile RF
(
    clk,
    reset,
    RegWrite_out,
    mux_to_reg,
    rs1_out,
    rs2_out,
    rd_out,
    ReadData1_out,
    ReadData2_out 
);

assign funct_in = {IM_to_parse[30],IM_to_parse[14:12]};

ALU_Control AC1
(
    ALUOp_out,
    funct_in,
    ALU_C_Operation
);

//wire [63:0] alu_mux_out;

Mux ALU_M
(
    imm_data_out, //value when sel is 1
    ReadData2_out,
    ALUSrc_out,
    alu_mux_out
);

Data_Memory DM
(
    alu_result_out,
    ReadData2_out,
    clk,
    MemWrite_out,
    MemRead_out,
    DM_Read_Data_out,
    element1,element2,element3 
);


Mux M2
(
    DM_Read_Data_out, //value when sel is 1
    alu_result_out,
    MemtoReg_out,
    mux_to_reg
);


Adder Inc4
(
    PC_to_IM,
    fixed_4,
    PC_plus_4_to_mux
);

assign imm_to_adder = imm_data_out << 1;


Adder IncIMM
(
    PC_to_IM,
    imm_to_adder,
    imm_adder_to_mux
);



Branch BC
(
    Branch_out,
    zero_out,
    Is_Greater_out,
    funct_in,
    pc_mux_sel_wire
);


Mux PC_M
(
    imm_adder_to_mux,   //value when sel is 1
    PC_plus_4_to_mux,
    pc_mux_sel_wire,
    mux_to_pc_in
);


endmodule 


