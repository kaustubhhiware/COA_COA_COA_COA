`timescale 1ns / 1ps

module test_tristate17;

	// Inputs
	reg [16:0] in;
	reg enable;

	// Outputs
	wire [16:0] out;

	// Instantiate the Unit Under Test (UUT)
	trstate17 uut (
		.in(in), 
		.enable(enable), 
		.out(out)
	);

	initial begin
		// Initialize Inputs
		in = 0;
		enable = 0;

		// Wait 100 ns for global reset to finish
		#100;
     
		
		// Add stimulus here
		#10
		in=3;
		enable=1;
		
		#20
		in=1;
		enable=1;
		
		#20
		in=5;
		enable=0;
	end
      
endmodule