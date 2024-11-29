`timescale 1ns / 1ps

module Mux(
input [63:0] a,b,
input sel, //input the selection bit
output [0:63]output_data // out of 64 bits by the name output_data
);
assign output_data = sel? a : b; //using if condition for muxfunction. If sel=1 then nalue a is the output, else b is the output.
endmodule