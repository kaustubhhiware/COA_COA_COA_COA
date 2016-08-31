`timescale 1ns / 1ps


module test_shiftrightby2;

	// Inputs
	reg [7:0] X;

	// Outputs
	wire [7:0] Y;

	// Instantiate the Unit Under Test (UUT)
	shiftrightby2 uut (
		.X(X), 
		.Y(Y)
	);

	initial begin
		// Initialize Inputs
		X = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		X=15;
		#10
		X=16;
		#10
		X=1;
		

	end
      
endmodule
