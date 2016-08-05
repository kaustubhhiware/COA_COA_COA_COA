`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:16:41 07/30/2016
// Design Name:   behaviouralFSM
// Module Name:   C:/Windows/system32/HellloXilinx/test_isPrime.v
// Project Name:  HellloXilinx
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: behaviouralFSM
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
// Verilog Test Fixture Template

  `timescale 1 ns / 1 ps

module TestFSM;
/*
input clk,Go;
input [15:0] N;
input Bo,eqz;
output isPrime,over,divover;*/
	// Inputs
	reg clk;
	reg Go;
	wire Bo,eqz,divover;
	reg [15:0] N;
	
	// Outputs
	wire isPrime,over;
	//wire isWork;

	always begin #5 clk = ~clk; end
	
	wire ldx,ldn,ldrem,ldrem1,lddv,lddiv,ld2;
	reg [15:0]x1;
	reg [15:0]x2;
	reg [15:0]y1;
	reg  [15:0]y2;
  	reg rst;
	reg [1:0]sel1;
	reg [1:0] sel2;
	reg [15:0]z1;
	
	reg [15:0] z2;
	wire enregx,enregn,enregdiv,enregrem,enregrem1,enregdv,enreg2;
	
	// Instantiate the Unit Under Test (UUT)
	
	//(Go,ldx,ldn,lddiv,ldrem,ldrem1,lddv,ld2,x1,x2,y1,y2,z1,z2,clk,rst,sel1,sel2,Bo,enregx,enregn,enregdiv,enregrem,enregrem1,enregdv,enreg2,eqz);
	
	
	behaviouralFSM uut (
		.clk(clk),.Go(Go),.Bo(Bo),.eqz(eqz),.N(N),
		.isPrime(isPrime),.over(over),.divover(divover),
		.ldx(ldx),
		.ldn(ldn),
		.ldrem(ldrem),
		.lddiv(lddiv),
		.ldrem1(ldrem1),
		.lddv(lddv),
		.ld2(ld2),
		.enregx(enregx),
		.enreg2(enreg2),
		.enregrem(enregrem),
		.enregn(enregn),
		.enregdiv(enregdiv),
		.enregrem1(enregrem1),
		.enregdv(enregdv)
		
	);
	

	
	//datapath(ldx,ldn,lddiv,ldrem,ldrem1,lddv,ld2,x1,x2,y1,y2,z1,z2,clk,rst,sel1,sel2,Bo,enregx,enregn,enregdiv,enregrem,enregrem1,enregdv,enreg2);
	datapath dp(
		.Go(Go),
		.ldx(ldx),
		.ldn(ldn),
		.ldrem(ldrem),
		.lddiv(lddiv),
		.ldrem1(ldrem1),
		.lddv(lddv),
		.ld2(ld2),
		.clk(clk),
		.rst(rst),
		.x1(x1),
		.x2(x2),
		.y1(y1),
		.y2(y2),
		.sel1(sel1),
		.sel2(sel2),
		.z1(z1),
		.z2(z2),
		.enregx(enregx),
		.enreg2(enreg2),
		.enregrem(enregrem),
		.enregn(enregn),
		.enregdiv(enregdiv),
		.enregrem1(enregrem1),
		.enregdv(enregdv),
		.Bo(Bo),
		.eqz(eqz),
		.divover(divover)
	);
	initial begin
		// Initialize Inputs
		clk = 0;
		Go = 1;
		N = 16'b0000000000000010;//2 
		// Wait 100 ns for global reset to finish
		#100;
		N = 16'b0000000000000011;//3 
		#100;     
		N = 16'b0000000000001100;//12	
		#100;     
		N = 16'b0000000000001101;//13	
		#100;     
		N = 16'b0000000001000101;//69	
		#100;     
		N = 16'b0000000001001111;//79	
		#100;     
		N = 16'b0000000011000111;//199			
		01000101
		// Add stimulus here

	end
endmodule