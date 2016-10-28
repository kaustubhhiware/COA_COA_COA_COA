`timescale 100ps / 1ps


module tb_topmodule;
	reg clk,topRst;
	
	top_module uutO(clk, topRst);
	
	// Clock generator
	initial
	begin
		clk = 1;
		forever #5 clk = ~clk;
	end
	
	//Stimulus generator
	initial
	begin
		topRst = 0;
		#5; topRst = 1;
	end
endmodule
