`timescale 1ns / 1ps


module test_reg8;

	// Inputs
	reg [7:0] in;
	reg clk;
	reg rst;
	reg [2:0] sel,load;

	// Outputs
	wire [7:0] out;

	// Instantiate the Unit Under Test (UUT)
	reg8 uut (
		.in(in), 
		.out(out), 
		.clk(clk), 
		.rst(rst), 
		.load(load),
		.sel(sel)
	);


	initial begin
		// Initialize Inputs
		in = 0;
		clk = 0;
		rst = 0;
		load=1;
		sel = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		while(1)
		begin 
			#50
			clk=~clk;
		end
		
		end
	
      
endmodule