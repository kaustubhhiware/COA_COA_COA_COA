`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:46:14 09/29/2016 
// Design Name: 
// Module Name:    main_datapath 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module register(in,load,clk,rst,ts,out);

  input [15:0] in;
  input clk;
  input rst;
  input ts;
  input load;
  output [15:0] out;
  reg [15:0] out;
  
  always@(in)
  begin
    if(rst==1)
      out<=0;
	 else
      out<=in;
  end
  
endmodule

/*module register(in, out, clk ,load, rst);

 output [15:0] out;
 input [15:0] in;
 input clk, rst,load;
 reg [15:0] out;
 always @(posedge clk)
 	begin
 	if (rst) out <= 0;
 	else if(load) out <= in;
  	end
endmodule
*/


module tristate(in,out,enable);
	
	input [15:0] in;
	output [15:0] out;
	input enable;
	
	assign out= (enable==1)?in:16'bz;

endmodule

module demux38(in,out,enable,clk,rst);
	input[2:0] in;
	input clk,rst,enable;
	output [7:0]out;
	reg [7:0]out;
	
	always@(posedge clk or rst)
	begin
	if(enable==1)
	begin
		if(in==3'b000)
		begin
			out=8'b10000000;
		end
		else if(in==3'b001)
		begin
			out=8'b01000000;
		end
		else if(in==3'b010)
		begin
			out=8'b00100000;
		end
		else if(in==3'b011)
		begin
			out=8'b00010000;
		end
		else if(in==3'b100)
		begin
			out=8'b00001000;
		end
		else if(in==3'b101)
		begin
			out=8'b00000100;
		end
		else if(in==3'b110)
		begin
			out=8'b00000010;
		end
		else if(in==3'b111)
		begin
			out=8'b00000001;
		end
	end
	end
	
endmodule
module reg_bank(PA, rdr,wrr,wPA,clk,rst,out); //wPA is the data we want to write

	input[2:0] PA;
 //3 bit address of the register we want
	input [15:0] wPA;  
	input rdr,wrr;
	input clk,rst;
	output[15:0] out;
	reg [15:0]out;
	
	wire [7:0]ld;
	wire [7:0]ts;
	wire [15:0]out0;
	wire [15:0]out1;
	wire [15:0]out2;
	wire [15:0]out3;
	wire [15:0]out4;
	wire [15:0]out5;
	wire [15:0]out6;
	wire [15:0]out7;
	
	register reg0(wPA,ld[0],clk,rst,ts[0],out0);
	register reg1(wPA,ld[1],clk,rst,ts[1],out1);
	register reg2(wPA,ld[2],clk,rst,ts[2],out2);
	register reg3(wPA,ld[3],clk,rst,ts[3],out3);
	register reg4(wPA,ld[4],clk,rst,ts[4],out4);
	register reg5(wPA,ld[5],clk,rst,ts[5],out5);
	register reg6(wPA,ld[6],clk,rst,ts[6],out6);
	register reg7(wPA,ld[7],clk,rst,ts[7],out7);
	
	wire readwrite = wrr || rdr;
	//for writing
	demux38 dm1(PA,ld,wrr,clk,rst);
	demux38 dm2(PA,ts,readwrite,clk,rst); //Either when ts=1 or load=1, the output is PA 
	
	always@(posedge clk or posedge rst)
	begin
	if(rdr==1)
	begin
		if(PA==3'b000)
		begin
			out=out0;
		end
		else if(PA==3'b001)
		begin
			out=out1;
		end
		else if(PA==3'b010)
		begin
			out=out2;
		end
		else if(PA==3'b011)
		begin
			out=out3;
		end
		else if(PA==3'b100)
		begin
			out=out4;
		end
		else if(PA==3'b101)
		begin
			out=out5;
		end
		else if(PA==3'b110)
		begin
			out=out6;
		end
		else if(PA==3'b111)
		begin
			out=out7;
		end
	end
	end

endmodule	

module test_reg_bank;

	// Inputs
	reg [2:0] PA;
	reg rdr;
	reg wrr;
	reg [15:0] wPA;
	reg clk;
	reg rst;

	// Outputs
	wire [15:0] out;

	// Instantiate the Unit Under Test (UUT)
	reg_bank uut (
		.PA(PA), 
		.rdr(rdr), 
		.wrr(wrr), 
		.wPA(wPA), 
		.clk(clk), 
		.rst(rst), 
		.out(out)
	);
	
	
	always
	begin #5
	clk=~clk;
	end

	initial begin
		// Initialize Inputs
		PA = 0;
		rdr = 0;
		wrr = 0;
		wPA = 0;
		clk = 0;
		rst = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		 

		
		PA = 3'b001;
		rdr=1;
		clk=1;
		wrr=1;
		wPA=16'b0000010000000100;
		
		clk=0;
		
		#20
		clk=1;
		wrr=0;
		rdr=0;
		
		#20
		clk=0;
		
		#20
		PA = 3'b010;
		rdr=1;
		clk=1;
		wrr=1;
		wPA=16'b0000010000000111;
		
		#20
		PA = 3'b001;
		wrr=0;
		rdr=1;
		clk=1;
		
	end
      
endmodule


endmodule
