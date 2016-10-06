`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:04:30 08/12/2016
// Design Name:   adder17
// Module Name:   C:/Windows/System32/Ass2/testadd17.v
// Project Name:  Ass2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: adder17
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testadd17;

	// Inputs
	reg [16:0] A;
	reg [16:0] B;

	// Outputs
	wire [16:0] S;
	wire Cout;

	// Instantiate the Unit Under Test (UUT)
	adder17 uut (
		.S(S), 
		.Cout(Cout), 
		.A(A), 
		.B(B)
	);

	initial begin
		// Initialize Inputs
		A = 0;
		B = 0;
	
		#10;
		A = 17'b00110011001100111;
		B = 17'b11000000000000001;
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

