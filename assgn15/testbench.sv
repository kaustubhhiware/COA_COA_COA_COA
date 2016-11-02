`timescale 100ps / 1ps


module tb_topOverall_CPUmem;
	reg clk,rstIn;
	
	topOverall_CPUmem uutO(clk, rstIn);
	
	// Clock generator
	initial
	begin
		clk = 1;
		forever #5 clk = ~clk;
	end
	
	//Stimulus generator
	initial
	begin
		rstIn = 0;
		#5; rstIn = 1;
	end
endmodule

module triStateBuffer(
		output [15:0] b,
		input[15:0] a,
		input enable);
	assign b = (enable) ? a : 16'bzzzzzzzzzzzzzzzz;
	
endmodule
