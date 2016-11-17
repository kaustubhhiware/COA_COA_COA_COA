`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:41:36 11/04/2016
// Design Name:   RegisterFile
// Module Name:   C:/Windows/system32/cpu/test_regbank.v
// Project Name:  cpu
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: RegisterFile
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_regbank;

	// Inputs
	reg [4:0] readReg1;
	reg [4:0] readReg2;
	reg [4:0] writeReg;
	reg [31:0] writeData;
	reg RegWrite;

	// Outputs
	wire [31:0] readData1;
	wire [31:0] readData2;

	// Instantiate the Unit Under Test (UUT)
	RegisterFile uut (
		.readReg1(readReg1), 
		.readReg2(readReg2), 
		.writeReg(writeReg), 
		.writeData(writeData), 
		.readData1(readData1), 
		.readData2(readData2), 
		.RegWrite(RegWrite)
	);

	initial begin
		// Initialize Inputs
		readReg1 = 0;
		readReg2 = 0;
		writeReg = 0;
		writeData = 0;
		RegWrite = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

module test_topmodule;

	// Inputs
reg clk,rst;

	// Instantiate the Unit Under Test (UUT)
topmodule TP1(
.clk(clk),
.rst(clk)
);

	initial begin
		// Initialize Inputs
		rst=1;
		clk=0;

		// Wait 100 ns for global reset to finish
		#10
		rst=0;
		
		always@(*)
		begin
			clk=~clk
       end
		 
		// Add stimulus here

	end
      
endmodule

