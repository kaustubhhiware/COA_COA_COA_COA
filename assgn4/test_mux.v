`timescale 1ns / 1ps


module test_mux;

	// Inputs
	reg [7:0] X;
	reg [7:0] Y;
	reg [2:0] sel;

	// Outputs
	wire [7:0] out;

	// Instantiate the Unit Under Test (UUT)
	mux2 uut (
		.X(X), 
		.Y(Y), 
		.sel(sel), 
		.out(out)
	);

	initial begin
		// Initialize Inputs
		X = 1;
		Y = 0;
		sel = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		sel=1;
		X=3;
		Y=5;
		
		#5
		sel=2;
		X=3;
		Y=5;

	end
      
endmodule


