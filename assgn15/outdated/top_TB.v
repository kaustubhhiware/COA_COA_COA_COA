`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:51:10 10/20/2016
// Design Name:   TopModule
// Module Name:   E:/CPU/testTop.v
// Project Name:  CPU
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: TopModule
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testTop;

	// Inputs
	reg [15:0] datain;
	reg clk;
	reg rst;
	reg dataout;

	// Instantiate the Unit Under Test (UUT)
	TopModule uut (
		.datain(datain), 
		.clk(clk), 
		.rst(rst), 
		.dataout(dataout)
	);

	initial begin
		// Initialize Inputs
		datain = 0;
		clk = 0;
		rst = 0;
		dataout = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		rst = 1;
		datain = 16'b 0000000000000000;
		
		// Wait 100 ns for global reset to finish
		#100;
        

		rst = 0;
		datain = 16'b 0000000000111010;
		
		// Wait 100 ns for global reset to finish
		#100;
        

		rst = 0;
		datain = 16'b 0010100111000000;
		
		// Wait 100 ns for global reset to finish
		#100;
        

		rst = 0;
		datain = 16'b 0000000001001011;
	
		// Wait 100 ns for global reset to finish
		#100;
        
	end
      
endmodule