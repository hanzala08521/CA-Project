module Data_Memory
(
    input [63:0] Mem_Addr,
    input [63:0] Write_Data,
    input clk,
    input MemWrite, MemRead,
    output [63:0] Read_Data,
    output [63:0] element1,
    output [63:0] element2,
    output [63:0] element3
);

reg [7:0] memory [63:0];
reg [63:0] temp_data;
integer i;

//        assign element1 ={memory[7],memory[6],  memory[5] , memory[4] , memory[3] , memory[2] , memory[1] , memory[0]}; 
//        assign element2 = {memory[15], memory[14], memory[13] , memory[12] , memory[11], memory[10] , memory[9] , memory[8]}; 
//        assign element3 = {memory[23],memory[22],memory[21],memory[20],memory[19],memory[18],memory[17],memory[16]} ; 
        assign element1 = memory[20];
        assign element2 = memory[12];
        assign element3 = memory[4]; 

initial begin
for (i=0 ;i<64 ; i = i + 1) begin
    memory[i] = 0;
end
//      memory[20]  = 8'd2;
//      memory[12]  = 8'd1;
//      memory[4] = 8'd3;
end


always @(negedge clk) begin
    if (MemWrite) begin
        memory[Mem_Addr] = Write_Data[7:0];
        memory[Mem_Addr+1] = Write_Data[15:8];
        memory[Mem_Addr+2] = Write_Data[23:16];
        memory[Mem_Addr+3] = Write_Data[31:24];
        memory[Mem_Addr+4] = Write_Data[39:32];
        memory[Mem_Addr+5] = Write_Data[47:40];
        memory[Mem_Addr+6] = Write_Data[55:48];
        memory[Mem_Addr+7] = Write_Data[63:56];
    end
end



always @(*) begin
    if (MemRead) begin
        temp_data <= {memory[Mem_Addr+7], memory[Mem_Addr+6], memory[Mem_Addr+5], memory[Mem_Addr+4], memory[Mem_Addr+3], memory[Mem_Addr+2], memory[Mem_Addr+1], memory[Mem_Addr]};
    end
end

assign Read_Data = temp_data;



endmodule 