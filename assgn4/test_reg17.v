`timescale 1ns / 1ps

module test_reg17;

	// Inputs
	reg [16:0] in;
	reg clk;
	reg rst;
	reg load;
	reg [2:0] sel;

	// Outputs
	wire [16:0] out;

	// Instantiate the Unit Under Test (UUT)
	reg17 uut (
		.in(in), 
		.out(out), 
		.clk(clk), 
		.rst(rst), 
		.load(load), 
		.sel(sel)
	);

	initial begin
		// Initialize Inputs
		in = 17'b00000000000000010;
		clk = 0;
		rst = 0;
		load = 1;
		sel = 5;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		while(1)
		begin
			#5
			clk=~clk;
		end
	end
      
endmodule


