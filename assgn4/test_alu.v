`timescale 1ns / 1ps

module test_alu;

	// Inputs
	reg [16:0] X;
	reg [7:0] Y;
	reg [3:0] func_sel;
	reg clk;
	reg rst;

	// Outputs
	wire Bo;
	wire eqz;
	wire [16:0] Z;

	// Instantiate the Unit Under Test (UUT)
	alu uut (
		.X(X), 
		.Y(Y), 
		.func_sel(func_sel), 
		.clk(clk), 
		.rst(rst), 
		.Bo(Bo), 
		.eqz(eqz), 
		.Z(Z)
	);

	initial begin
		// Initialize Inputs
		X = 1;
		Y = 1;
		func_sel = 0;
		clk = 0;
		rst = 0;

		// Wait 100 ns for global reset to finish
		#100;
			
		while(1)
		begin
			clk=~clk;
		end
		
		// Add stimulus here
		X=1;
		Y=2;
		func_sel=2;
		

	end
      
endmodule

module testsubt;

	// Inputs
	reg [16:0] A;
	reg [7:0] B;
	//reg Cin;
	// Outputs
	wire [16:0] S;
	wire Cout;
	wire Bo,eqz;
	//integer i;
	// Instantiate the Unit Under Test (UUT)
	subt uut (
		.S(S), 
		.Cout(Cout), 
		.A(A), 
		.B(B), 
		.Bo(Bo),
		.eqz(eqz)
	);

	initial begin
		// Initialize Inputs
		A = 0;
		B = 0;
		
		#100;
		A=17'b000000000000001000;
		B = 8'b00000001;
		// Wait 100 ns for global reset to finish
		#100;
		end        
		// Add stimulus here
		

      
endmodule

