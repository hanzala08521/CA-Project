`timescale 1ns / 1ps

module RISC_V_Processor_Testbench();

    // Inputs
    reg clk;
    reg reset;

    wire [63:0] index1,index2,index3;

    // Instantiate the processor
    RISC_V_Processor uut (
        .clk(clk),
        .reset(reset),
//        .PC_Out(PC_Out),
//        .Instruction(Instruction),
//        .rs1(rs1),
//        .rs2(rs2),
//        .rd(rd),
//        .WriteData(WriteData),
//        .ReadData1(ReadData1),
//        .ReadData2(ReadData2),
//        .imm_data(imm_data),
//        .dataout(dataout),
//        .Result(Result),
//        .ZERO(ZERO),
//        .Read_Data(Read_Data),
        .element1(index1),
        .element2(index2),
        .element3(index3)
    );

initial 
 begin 
  
  clk = 1'b0; 
   
  reset = 1'b1; 
   
  #10 reset = 1'b0; 
 end 
always  
 #5 clk = ~clk; 

endmodule
