`timescale 1ns / 1ps

module DFF(d,out,clk,rst);
	input d, rst, clk;
	output out;
	reg out;

	always@(posedge clk or posedge rst)
		begin
		
			if(rst) out <= 0;
			else out <= d;
		end
	
endmodule

module shift_right(a,sum,clk);


endmodule
