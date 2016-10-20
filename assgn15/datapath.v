`timescale 1ns / 1ps

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

module datapath(lmar,lt,lpc,lir,lmdr,ldx,ldy,abus,tt,tpc,tp,t2,tmdr2x,tmdrext,
rmdri,rmarx,pa,rdr,wpa,wrr,fnsel,vin,cin,datain,dataout);
		 
	input lmar,lt,lpc,lir,lmdr,ldx,ldy,tt,tpc,tp,t2,tmdr2x,tmdrext,rmdri,rmarx,wrr,rdr;
	input[2:0] pa,wpa;
	input [2:0] fnsel;
	input [15:0] datain;
	output [15:0] dataout;
	output[15:0] abus;
	output vin, cin,zin,sin;
	wire[15:0] z,x,y,bus,p,t,pc;
	//MAR
	register regmar(z,abus,lmar,clk,rst);
	//T 
	register r1(z,t,lt,clk,rst);
	tristate ts1(t,tt,bus);
	//PC
	register r2(z,pc,lpc,clk,rst);
	tristate ts2(pc,tpc,bus);

	//REGBANK
	reg_bank rb(pa,rdr,wpa,wrr,z,p);
	tristate ts3(p,tp,bus);

	//RegX
	register regX(bus,x,ldx,clk,rst);

	//RegY
	register regY(bus,y,ldy,clk,rst);

	ALU alu(x,y,fnsel,z,vin,cin);

	zerodetector zd (z , zin);
	assign sin = z[15];

	wire[15:0] temp2;

	//constant 2
	register cons2(16'b0000000000000010,temp2,1'b 1,clk,rst);
	tristate ts4(temp2,t2,bus);


	wire [15:0] mdrin;


	//RegY
	register IRreg(datain,dataout,lir,clk,rst);
	tristate tr5(datain,rmarx,mdrin);
	tristate tr6(z,rmdri,mdrin);


	wire [15:0] mdrout;
	//MDR
	register regmdr(mdrin,mdrout,lmdr,clk,rst);
	tristate ifh(mdrout,tmdr2x,bus);

endmodule
