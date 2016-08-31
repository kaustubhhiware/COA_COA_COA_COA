`timescale 1ns / 1ps

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

