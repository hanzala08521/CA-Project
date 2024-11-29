`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2024 02:11:02 PM
// Design Name: 
// Module Name: Program_Counter
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


module Program_Counter(
    input clk,          // Clock input
    input reset,        // Reset input
    input [63:0] PC_In, // 64-bit input
    output reg [63:0] PC_Out // 64-bit output
);
reg reset_force; // A flag that ensures PC_Out is forced to 0 after a reset.

initial 
PC_Out <= 64'd0;


always @(posedge clk or posedge reset) begin
    if (reset || reset_force) begin
        PC_Out = 64'd0;
        reset_force <= 0;
        end
        
    // else if (PC_In >= 16)
    //     PC_Out = 64'd0;
        
    else
    PC_Out = PC_In;

end

always @(negedge reset) reset_force <= 1;



endmodule
