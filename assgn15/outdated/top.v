`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:36:29 10/20/2016 
// Design Name: 
// Module Name:    TopModule 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module TopModule(datain,clk,rst,dataout);

input clk,reset;
input [15:0] datain;
output [15:0] outArr;


// initialise components

	wire lmar,lt,lpc,lir,lmdr,ldx,ldy,tt,tpc,tp,t2,tmdr2x,tmdrext,rmdri,rmarx,wrr,rdr;
	wire[2:0] pa,wpa;
	wire [2:0] fnsel;
	wire [15:0] abus;
	wire vin, cin,zin,sin;

datapath topDP(lmar,lt,lpc,lir,lmdr,ldx,ldy,abus,tt,tpc,tp,t2,tmdr2x,tmdrext,
rmdri,rmarx,pa,rdr,wpa,wrr,fnsel,vin,cin,datain,dataout);

	wire [4:0] state;
	wire [4:0] next_state;
	wire [6:0]operationcode;
	wire wpc, rpc, rm, wmem, wmar, rmar, wmdr, rmdr;
	wire in_mdr1, in_mdr2, out_mdr1, out_mdr2, wir,  wReg, rReg,wt;
	wire rt, rc1, ldF;
	wire [1:0] inReg1, inReg2;
	wire [2:0] aluOp;

controller topControl(operationcode, wpc, rpc, rm, wmem, wmar, rmar, 
wmdr, rmdr, in_mdr1, in_mdr2, out_mdr1, out_mdr2, wir, inReg, wReg,
rReg,wt, rt, rc1, aluOp, ldF, state, next_state);

	wire Memory_Reset;
	wire [15:0] ABus;
	wire [15:0] Write_Data;
	wire RD; 
	wire WR; 
	wire [15:0] DBus;

Memory mem( input Memory_Reset, input [15:0] ABus, input [15:0] Write_Data, input RD, input WR, output [15:0] DBus);
 
endmodule

module Memory( input Memory_Reset, input [15:0] ABus, input [15:0] Write_Data, input RD, input WR, output [15:0] DBus);
reg[15:0] Memory_Bank_Array [65535:0];
reg[15:0] Read_Data;
integer i;
always @ (Memory_Reset, Mem_Read, Mem_Write)
begin
if(Memory_Reset) begin
Memory_Bank_Array[0] <= 16'b0000011000101000;
end
if(Mem_Write) begin
Memory_Bank_Array[Mem_Addr] <= Write_Data[15:0];
end
if(Mem_Read) begin
Read_Data[15:0] <= Memory_Bank_Array[Mem_Addr];
end
end
endmodule