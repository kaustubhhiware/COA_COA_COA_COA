`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:36:07 09/29/2016 
// Design Name: 
// Module Name:    datapath 
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

//16-bit Z register is changed to Save



module register(in,out,load,clk,rst);

	input [15:0]in;
	output [15:0]out;
	input rst;
	input clk;
	input load;

	reg [15:0]out;
	always@(posedge clk or posedge rst)
	begin
	   if(rst) 
	      out<=16'b0000000000000000;
	   else if(load)
	     out<=in;

	end
endmodule



module mux2_16(sel,A,B,out);

	input sel;
	input [15:0] A;
	input [15:0] B;
	output reg[15:0] out;

    always @(*)
    begin
	    if(sel)
	    out <= B;
	    else
	    out <= A;
    end

endmodule

module twoscompl(A,out,sel);

	input sel;
	input [15:0] A;
	output [15:0] out;
	mux2_16 m1(sel,A,~A+16'b1,out);
    

endmodule

module tristate_buffer(in,switch,out);

	input [15:0]in;
	output [15:0]out;
	input switch;

	assign out=(switch)? in:16'bzzzzzzzzzzzzzzzz;

endmodule

module PCIncr(outPC,selPC,outMDR,ldPC,clk,rst
    );
	input [1:0]selPC;
	input [15:0]outMDR;
	input ldPC;
	input clk;
	input rst;
	
	inout [15:0]outPC;
	
	wire [15:0] PCreg;
	wire 	[15:0]outX;
	wire 	[15:0]outAdd1;
	wire 	[15:0]outAdd;
	wire carry;
	
	mux2_16 m1(selPC[0], 16'b0000000000000010, outMDR, outX);
	
	adder_16bit add1(outX, outPC,outAdd1 , carry);
	
	mux2_16 m2(selPC[1], outAdd1, outMDR, outAdd);
	
	assign outPC = PCreg;
	register PC(outAdd, PCreg, ldPC, clk, rst);
	
endmodule


module regbank(bus,PA,rd,wr, clk, rst);

	inout [15:0]bus;
	wire [15:0]outreg0;
	wire [15:0]outreg1;
	wire [15:0]outreg2;
	wire [15:0]outreg3;
	wire [15:0]outreg4;
	wire [15:0]outreg5;
	wire [15:0]outreg6;
	wire [15:0]outreg7;
	input [2:0]PA;
	input rd;
	input wr;
	input clk, rst;

	wire [7:0] Tri;

	assign Tri[0] = (~PA[2])&(~PA[1])&(~PA[0]);
	assign Tri[1] = (~PA[2])&(~PA[1])&(PA[0]);
	assign Tri[2] = (~PA[2])&(PA[1])&(~PA[0]);
	assign Tri[3] = (~PA[2])&(PA[1])&(PA[0]);
	assign Tri[4] = (PA[2])&(~PA[1])&(~PA[0]);
	assign Tri[5] = (PA[2])&(~PA[1])&(PA[0]);
	assign Tri[6] = (PA[2])&(PA[1])&(~PA[0]);
	assign Tri[7] = (PA[2])&(PA[1])&(PA[0]);

	register r0(bus,outreg0,Tri[0]&(wr),clk,rst);
	tristate_buffer Tsz0(outreg0,Tri[0]&(rd),bus);

	register r1(bus,outreg1,Tri[1]&(wr),clk,rst);
	tristate_buffer Tsz1(outreg1,Tri[1]&(rd),bus);

	register r2(bus,outreg2,Tri[2]&(wr),clk,rst);
	tristate_buffer Tsz2(outreg2,Tri[2]&(rd),bus);

	register r3(bus,outreg3,Tri[3]&(wr),clk,rst);
	tristate_buffer Tsz3(outreg3,Tri[3]&(rd),bus);

	register r4(bus,outreg4,Tri[4]&(wr),clk,rst);
	tristate_buffer Tsz4(outreg4,Tri[4]&(rd),bus);

	register r5(bus,outreg5,Tri[5]&(wr),clk,rst);
	tristate_buffer Tsz5(outreg5,Tri[5]&(rd),bus);

	register r6(bus,outreg6,Tri[6]&(wr),clk,rst);
	tristate_buffer Tsz6(outreg6,Tri[6]&(rd),bus);

	register r7(bus,outreg7,Tri[7]&(wr),clk,rst);
	tristate_buffer Tsz7(outreg7,Tri[7]&(rd),bus);

endmodule

module adder_16bit ( a ,b ,sum , carry );

	output [15:0] sum ;
	output carry ;

	input [15:0] a ;
	input [15:0] b ; 

	wire [14:0]s;

	full_adder u0 (a[0],b[0],1'b0,sum[0],s[0]);
	full_adder u1 (a[1],b[1],s[0],sum[1],s[1]);
	full_adder u2 (a[2],b[2],s[1],sum[2],s[2]);
	full_adder u3 (a[3],b[3],s[2],sum[3],s[3]);
	full_adder u4 (a[4],b[4],s[3],sum[4],s[4]);
	full_adder u5 (a[5],b[5],s[4],sum[5],s[5]);
	full_adder u6 (a[6],b[6],s[5],sum[6],s[6]);
	full_adder u7 (a[7],b[7],s[6],sum[7],s[7]);
	full_adder u8 (a[8],b[8],s[7],sum[8],s[8]);
	full_adder u9 (a[9],b[9],s[8],sum[9],s[9]);
	full_adder u10 (a[10],b[10],s[9],sum[10],s[10]);
	full_adder u11 (a[11],b[11],s[10],sum[11],s[11]);
	full_adder u12 (a[12],b[12],s[11],sum[12],s[12]);
	full_adder u13 (a[13],b[13],s[12],sum[13],s[13]);
	full_adder u14 (a[14],b[14],s[13],sum[14],s[14]);
	full_adder u15 (a[15],b[15],s[14],sum[15],carry);

endmodule
module full_adder ( a ,b ,c ,sum ,carry );

	output sum ;
	output carry ;

	input a ;
	input b ;
	input c ;

	assign sum = a ^ b ^ c;  
	assign carry = (a&b) | (b&c) | (c&a);

endmodule
module sub(a, b, diff, borrow);

input [15:0]a;
input [15:0]b;
output [15:0]diff;
output borrow;
//output difference;
wire [14:0]s;
//xor(difference,a,b,c);

full_sub u0 (a[0],b[0],1'b0,diff[0],s[0]);
full_sub u1 (a[1],b[1],s[0],diff[1],s[1]);
full_sub u2 (a[2],b[2],s[1],diff[2],s[2]);
full_sub u3 (a[3],b[3],s[2],diff[3],s[3]);
full_sub u4 (a[4],b[4],s[3],diff[4],s[4]);
full_sub u5 (a[5],b[5],s[4],diff[5],s[5]);
full_sub u6 (a[6],b[6],s[5],diff[6],s[6]);
full_sub u7 (a[7],b[7],s[6],diff[7],s[7]);
full_sub u8 (a[8],b[8],s[7],diff[8],s[8]);
full_sub u9 (a[9],b[9],s[8],diff[9],s[9]);
full_sub u10 (a[10],b[10],s[9],diff[10],s[10]);
full_sub u11 (a[11],b[11],s[10],diff[11],s[11]);
full_sub u12 (a[12],b[12],s[11],diff[12],s[12]);
full_sub u13 (a[13],b[13],s[12],diff[13],s[13]);
full_sub u14 (a[14],b[14],s[13],diff[14],s[14]);
full_sub u15 (a[15],b[15],s[14],diff[15],borrow);

endmodule

module full_sub( a ,b ,c ,diff ,borrow );

input a ;
input b ;
input c ;
output diff ;
output borrow ;

assign diff = a ^ b ^ c;   
assign borrow = (~a&b) | (b&c) | (c&~a);

endmodule


module or1(x,y,z);
input [15:0]x;
input [15:0]y;
output [15:0]z;

assign z=x|y;

endmodule

module and1(x,y,z);
input [15:0]x;
input [15:0]y;
output [15:0]z;

assign z=x&y;

endmodule

module alu(X,Y,op,outZ,outC,outV,outS,complbus,clk,rst,ldSave);

	input [15:0] X;
	input [15:0] Y;
	input clk,rst,ldSave;

	output [15:0] complbus;
	input [2:0] op;
	output outZ;
	output outC;
	output outV;
	output outS;
	wire [15:0]add_out;
	wire [15:0]sub_out;
	wire [15:0]comp_out;
	wire [15:0]or_out;
	wire [15:0]and_out;
	reg [15:0]complbus;

	reg outZ;
	reg outC;
	reg outV;
	reg outS;

	wire a ,b ;

	adder_16bit a1(X,Y,add_out,a);
	sub s1(X,Y,sub_out,b);
	twoscompl cc1(X,comp_out,1'b1);
	or1 o1(X,Y,or_out);
	and1 an1(X,Y,and_out);
	always@(*)
	begin
	case(op) 
	3'b000 : complbus = add_out;
	3'b001 : complbus = sub_out;
	3'b010 : complbus = 16'bz;
	3'b011 : complbus = comp_out;
	3'b100 : complbus = and_out;
	3'b101 : complbus = or_out;
	endcase
	if(!rst)
	begin
	if(ldSave)
	begin
	outS <= complbus[15];
	outZ <= (complbus==0);
	if(op == 3'b000) outC <= a;
	case(op)
	3'b000 : outV <= !((X[15]^Y[15]) | (~(X[15]^complbus[15])&~(Y[15]^complbus[15])));
	3'b001 : outV <= !((X[15]^(~Y[15])) | (~(X[15]^complbus[15])&~(~Y[15]^complbus[15])));
	3'b010 : outV <= !((X[15]^(~Y[15])) | (~(X[15]^sub_out[15])&~(~Y[15]^sub_out[15])));
	endcase
	end
	end
	else
	begin
	outS <= 0;
	outZ <= 0;
	outC <= 0;
	outV <= 0;
	end
	end
	 
endmodule

module datapath(ldMA, ldMRMem, ldMRbus, ldIR, selPC, ldPC, ldY, op, ldSave, rd, wr, TMA, TY, TIR, TMRbus, TMRMem, TPC, TSave, PA, inoutIR, outSave, outZ, outC, outV, outS, outMAR, inoutMDR, clk, rst,
	compl1bus,outPC,bus, outMDR
    );
	input ldMA, ldMRMem, ldMRbus, ldIR,clk, rst;
	input [1:0]selPC;
	input rd,wr;
	input ldPC, ldY, ldSave;
	input [2:0] op;
	input [2:0] PA;
	input TMA, TY, TIR, TMRbus, TMRMem, TPC, TSave;


	output [15:0]outSave;
	output outZ;
	output outC;
	output outV;
	output outS;
	output [15:0]outMAR;

	inout [15:0]inoutIR;
	inout [15:0]inoutMDR;

	output [15:0]outPC;
	output [15:0]outMDR;
	wire [15:0]inMDR;
	wire [15:0]outIR;
	wire [15:0]outY;
	wire ldMR;
	assign ldMR = ldMRMem || ldMRbus;
	output [15:0]compl1bus;

	output [15:0]bus;

	register MAR(bus, outMAR, ldMA, clk, rst);
	tristate_buffer t1(outMAR, TMA, bus);

	tristate_buffer t201(inoutMDR, ldMRMem, inMDR);
	tristate_buffer t200(bus, ldMRbus, inMDR);
	register MDR(inMDR, outMDR, ldMR, clk, rst);
	tristate_buffer t2(outMDR, TMRbus, bus);
	tristate_buffer t21(outMDR, TMRMem, inoutMDR);

	register IR(inoutIR, outIR, ldIR, clk, rst);
	tristate_buffer t3(outIR, ~ldIR, inoutIR);

	register Y(bus, outY, ldY, clk, rst);

	PCIncr PCi(outPC, selPC, outMDR, ldPC,clk, rst);
	tristate_buffer TsZ(outPC, TPC, bus);

	

	register Save(compl1bus, outSave, ldSave, clk, rst);
	tristate_buffer TcZ(outSave, TSave, bus);

	regbank rb(bus, PA, rd,wr,clk,rst);

	alu alu1(bus, outY, op, outZ, outC, outV, outS, compl1bus, clk, rst, ldSave);

endmodule

module Controller(outZ, outC, outV, outS, inoutIR, ldMA, ldMRMem, ldMRbus, ldIR, selPC, ldPC, ldY, op, ldSave, rd, wr, TMA, TY, TIR, TMRMem, TMRbus, TPC, TSave, PA, clk, rst, over
    );
	inout [15:0]inoutIR;
	input outZ, outC, outV, outS;
	
	
	input clk, rst;
	input over;
	
	output ldMA, ldMRMem, ldMRbus, ldIR, ldPC, ldY, ldSave, rd, wr, TMA, TY, TIR, TMRMem, TMRbus, TPC, TSave;
	reg ldMA;
	reg ldMRMem;
	reg ldMRbus;
	reg ldIR;
	reg ldPC;
	reg ldY;
	reg ldSave;
	reg rd;
	reg wr;
	reg TMA;
	reg TY;
	reg TIR;
	reg TMRMem;
	reg TMRbus;
	reg TPC;
	reg TSave;
	
	output [1:0]selPC;
	reg [1:0]selPC;
	output [2:0]op;
	reg [2:0]op;
	output [2:0]PA;
	reg [2:0]PA;
	
	
	reg [2:0]stateIR;
	reg [4:0]statei;
	reg [2:0]stater;
	reg [10:0]statex;
	reg [12:0]statedn;
	
	reg flag;
	
	always @(posedge clk)
		begin
			if(rst)
				begin
					stateIR <= 3'b001;
					ldMA <= 0;
					ldMRMem <= 0;
					ldMRbus <= 0;
					ldIR <= 0;
					selPC <= 2'b00;
					ldPC <= 0;
					ldY <= 0;
					op <= 3'b000;
					ldSave <= 0;
					rd <= 0;
					wr <= 0;
					TIR <= 0;
					TY <= 0;
					TMA <= 0;
					TMRMem <= 0;
					TMRbus <= 0;
					TPC <= 0;
					TSave <= 0;
					PA <= 3'b000;
					statei <= 5'b00001;
					stater <= 3'b001;
					statex <= 11'b00000000001;
					statedn <= 13'b0000000000001;
				end
			else
				begin
					case(stateIR)
					3'b000 :
						begin
						ldMA <= 0;
						ldMRMem <= 0;
						ldMRbus <= 0;
						ldIR <= 0;
						selPC <= 2'b00;
						ldPC <= 0;
						ldY <= 0;
						op <= 3'b000;
						ldSave <= 0;
						rd <= 1;
						wr <= 0;
						TIR <= 0;
						TY <= 0;
						TMA <= 0;
						TMRMem <= 0;
						TMRbus <= 0;
						TPC <= 0;
						TSave <= 0;
						//PA <= 3'b000; to read the value in last register
						end
					3'b001 :	//MAR <= PC
						begin
						ldMRMem <= 0;
						ldMRbus <= 0;
						ldIR <= 0;
						selPC <= 2'b00;
						ldPC <= 0;
						ldY <= 0;
						op <= 3'b000;
						ldSave <= 0;
						rd <= 0;
						wr <= 0;
						TIR <= 0;
						TY <= 0;
						TMA <= 0;
						TMRMem <= 0;
						TMRbus <= 0;
						TSave <= 0;
						//PA <= 3'b000
						ldMA <= 1;
						TPC <= 1;
						stateIR <= 3'b010;
						end
					3'b010 : 	//IR <= M[MAR]; PC = PC+2
						begin	
						TPC <= 0;
						ldMA <= 0;
						ldIR <= 1;
						ldPC <= 1;
						selPC <= 2'b00;
						flag <= 0;
						op <= 3'b000;
						stateIR <= 3'b101;
						statei <= 5'b00001;
						stater <= 3'b001;
						statex <= 11'b000000001;
						statedn <= 13'b00000000001;
						end
					3'b101 :
					begin
						ldPC <= 0;
						if(over)
						begin
							ldIR <= 0;
							stateIR <= 3'b100;
						end
					end
					3'b100 :
					begin
					case(inoutIR[15:14])
					2'b00 : 	//load and store
						begin
						case(inoutIR[13:11])
						3'b000 : 
						begin
							case(inoutIR[7:6])
							2'b00:
								case(statei)
								5'b00001 : 	//MAR <= PC
								begin
									ldIR <= 0;
									ldPC <= 0;
									TPC <= 1;
									ldMA <= 1;
									statei <= 5'b00010;
								end
								5'b00010 : 	//MDR <= M[MAR] ; PC <= PC+2
								begin
									TPC <= 0;
									ldMA <= 0;
									ldMRMem <= 1;
									ldPC <= 1;
									
									statei <= 5'b00101;
								end
								5'b00101 :
								begin
									ldPC <= 0;
									if(over)
									begin
										ldMRMem <= 0;
										statei <= 5'b00100;
									end
								end
								5'b00100 : 	//r1 <= MDR
								begin
									ldMRMem <= 0;
									ldPC <= 0;
									TMRbus <= 1;
									PA <= inoutIR[10:8];
									wr <= 1;
									statei <= 5'b00001;
									stateIR <= 3'b001;
								end
								endcase
							2'b01 : 
								case(stater)
								3'b001 : 	//Save <= r2
								begin
									PA <= inoutIR[5:3];
									rd <= 1;
									ldSave <= 1;
									ldIR <= 0;
									ldPC <= 0;
									stater <= 3'b010;
								end
								3'b010 : 	//r1 <= Save
								begin
									rd <= 0;
									ldSave <= 0;
									TSave <= 1;
									PA <= inoutIR[10:8];
									wr <= 1;
									stater <= 3'b001;
									stateIR <= 3'b001;
								end
								endcase
							2'b10 : 
								case(statex)
								11'b00000000001 :	//MAR <= PC;
								begin
									TPC <= 1;
									ldMA <= 1;
									ldIR <= 0;
									ldPC <= 0;
									statex <= 11'b00000000010;
								end
								11'b00000000010 : 	//MDR <= M[MAR]; PC <= PC+2
								begin
									TPC <= 0;
									ldMA <= 0;
									ldMRMem <= 1;
									ldPC <= 1;
									
									statex <= 11'b00000000101;
								end
								11'b00000000101 :
								begin	
									ldPC <= 0;
									if(over)
									begin
										ldMRMem <= 0;
										statex <= 11'b00000000100;
									end
								end
								11'b00000000100 : 	//Y <= MDR;
								begin
									ldMRMem <= 0;
									ldPC <= 0;
									TMRbus <= 1;
									ldY <= 1;
									statex <= 11'b00000001000;
								end
								11'b00000001000 : 	//Save <= Y+r2;
								begin
									TMRbus <= 0;
									ldY <= 0;
									PA <= inoutIR[5:3];
									rd <= 1;
									ldSave <= 1;
									statex <= 11'b00000010000;
								end
								11'b00000010000 : 	//Y <= Save;
								begin
									rd <= 0;
									ldSave <= 0;
									TSave <= 1;
									ldY <= 1;
									statex <= 11'b00000100000;
								end
								11'b00000100000 : 	//Save <= Y+r7;
								begin
									TSave <= 0;
									ldY <= 0;
									PA <= inoutIR[2:0];
									rd <= 1;
									ldSave <= 1;
									statex <= 11'b00001000000;
								end
								11'b00001000000 : 	//MAR <= Save
								begin
									rd <= 0;
									ldSave <= 0;
									TSave <= 1;
									ldMA <= 1;
									statex <= 11'b00010000000;
								end
								11'b00010000000 : 	//MDR <= M[MAR];
								begin
									TSave <= 0;
									ldMA <= 0;
									ldMRMem <= 1;
									
									statex <= 11'b00100000001;
								end
								11'b00100000001 :
								begin
									if(over)
									begin
										ldMRMem <= 0;
										statex <= 11'b00100000000;
									end
								end
								11'b00100000000 : 	//rs <= MDR;
								begin
									ldMRMem <= 0;
									TMRbus <= 1;
									PA <= inoutIR[10:8];
									wr <= 1;
									statex <= 11'b00000000001;
									stateIR <= 3'b001;
									end
								endcase
							2'b11 : 
								case(statedn)
								13'b0000000000001 :	//MAR <= PC;
								begin
									TPC <= 1;
									ldMA <= 1;
									ldIR <= 0;
									ldPC <= 0;
									statedn <= 13'b0000000000010;
								end
								13'b0000000000010 : 	//MDR <= M[MAR]; PC <= PC+2
								begin
									TPC <= 0;
									ldMA <= 0;
									ldMRMem <= 1;
									ldPC <= 1;
									
									statedn <= 13'b0000000000101;
								end
								13'b0000000000101 :
								begin
									ldPC <= 0;
									if(over)
									begin
										ldMRMem <= 0;
										statedn <= 13'b0000000000100;
									end
								end
								13'b0000000000100 : 	//Y <= MDR;
								begin
									ldMRMem <= 0;
									ldPC <= 0;
									TMRbus <= 1;
									ldY <= 1;
								statedn <= 13'b0000000001000;
								end
								13'b0000000001000 : 	//Save <= Y+r2;
								begin
									TMRbus <= 0;
									ldY <= 0;
									PA <= inoutIR[5:3];
									rd <= 1;
									ldSave <= 1;
									statedn <= 13'b0000000010000;
								end
								13'b0000000010000 : 	//Y <= Save;
								begin
									rd <= 0;
									ldSave <= 0;
									TSave <= 1;
									ldY <= 1;
									statedn <= 13'b0000000100000;
								end
								13'b0000000100000 : 	//Save <= Y+r7;
								begin
									TSave <= 0;
									ldY <= 0;
									PA <= inoutIR[2:0];
									rd <= 1;
									ldSave <= 1;
								statedn <= 13'b0000001000000;
								end
								13'b0000001000000 : 	//MAR <= Save
								begin
									rd <= 0;
									ldSave <= 0;
									TSave <= 1;
									ldMA <= 1;
									statedn <= 13'b0000010000000;
								end
								13'b0000010000000 : 	//MDR <= M[MAR];
								begin
									TSave <= 0;
									ldMA <= 0;
									ldMRMem <= 1;
									if(over)
										statedn <= 13'b0000100000000;
								end
								13'b0000100000000 : 	//MAR <= MDR;
								begin
									ldMRMem <= 0;
									TMRbus <= 1;
									ldMA <= 1;
									statedn <= 13'b0001000000000;
								end
								13'b0001000000000 : 	//MDR <= M[MAR];
								begin
									TMRbus <= 0;
									ldMA <= 0;
									ldMRMem <= 1;
									if(over)
									begin
										ldMRMem <= 0;
										statedn <= 13'b0010000000000;
									end
								end
								13'b0010000000000 : 	//rs <= MDR;
								begin
									ldMRMem <= 0;
									TMRbus <= 1;
									PA <= inoutIR[10:8];
									wr <= 1;
									statedn <= 13'b0000000000001;
									stateIR <= 3'b001;
								end
								endcase
							endcase
							end
							3'b001 : 
							case(inoutIR[7:6]) 
							2'b00 : 
								case(statex)
								11'b00000000001 :	//MAR <= PC;
								begin
									TPC <= 1;
									ldMA <= 1;
									ldIR <= 0;
									ldPC <= 0;
									statex <= 11'b00000000010;
								end
								11'b00000000010 : 	//MDR <= M[MAR]; PC <= PC+2
								begin
									TPC <= 0;
									ldMA <= 0;
									ldMRMem <= 1;
									ldPC <= 1;
									
									statex <= 11'b00000000101;
								end
								11'b00000000101 :
								begin
									ldPC <= 0;
									if(over)
									begin
										ldMRMem <= 0;
										statex <= 11'b00000000100;
									end
								end
								11'b00000000100 : 	//Y <= MDR;
								begin
									ldMRMem <= 0;
									ldPC <= 0;
									TMRbus <= 1;
									ldY <= 1;
									statex <= 11'b00000001000;
								end
								11'b00000001000 : 	//Save <= Y+r1;
								begin
									TMRbus <= 0;
									ldY <= 0;
									PA <= inoutIR[10:8];
									rd <= 1;
									ldSave <= 1;
									statex <= 11'b00000010000;
								end
								11'b00000010000 : 	//MAR <= Save;
								begin
									rd <= 0;
									ldSave <= 0;
									TSave <= 1;
									ldMA <= 1;
									statex <= 11'b00000100000;
								end
								11'b00000100000 : 	//MDR <= r2;
								begin
									TSave <= 0;
									ldMA <= 0;
									PA <= inoutIR[5:3];
									rd <= 1;
									ldMRbus <= 1;
									statex <= 11'b00001000000;
								end
								11'b00001000000 : 	//M[MAR] <= MDR
								begin
									rd <= 0;
									ldMRbus <= 0;
									TMRMem <= 1;
									if(over)
									begin
										TMRMem <= 0;
										statex <= 11'b00000000001;
									end
									if(over)
										stateIR <= 3'b001;
								end
								endcase
							2'b01 :
								case(statedn)
								13'b0000000000001 :	//MAR <= PC;
								begin
									TPC <= 1;
									ldMA <= 1;
									ldIR <= 0;
									ldPC <= 0;
									statedn <= 13'b0000000000010;
								end
								13'b0000000000010 : 	//MDR <= M[MAR]; PC <= PC+2
								begin
									TPC <= 0;
									ldMA <= 0;
									ldMRMem <= 1;
									ldPC <= 1;
									
									statedn <= 13'b0000000000101;
								end
								13'b0000000000101 :
								begin
									ldPC <= 0;
									if(over)
									begin
										ldMRMem <= 0;
										statedn <= 13'b0000000000100;
									end
								end
								13'b0000000000100 : 	//Y <= MDR;
								begin
									ldMRMem <= 0;
									ldPC <= 0;
									TMRbus <= 1;
									ldY <= 1;
									statedn <= 13'b0000000001000;
								end
								13'b0000000001000 : 	//Save <= Y+r1;
								begin
									TMRbus <= 0;
									ldY <= 0;
									PA <= inoutIR[10:8];
									rd <= 1;
									ldSave <= 1;
									statedn <= 13'b0000000010000;
								end
								13'b0000000010000 : 	//MAR <= Save;
								begin
									rd <= 0;
									ldSave <= 0;
									TSave <= 1;
									ldMA <= 1;
									statedn <= 13'b0000000100000;
								end
								13'b0000000100000 : 	//MDR <= M[MAR];
								begin
									TSave <= 0;
									ldMA <= 0;
									ldMRMem <= 1;
									if(over)
									begin
										ldMRMem <= 0;
										statedn <= 13'b0000001000000;
									end
								end
								13'b0000001000000 : 	//MAR <= MDR
								begin
									ldMRMem <= 0;
									TMRbus <= 1;
									ldMA <= 1;
									statedn <= 13'b0000010000000;
								end
								13'b0000010000000 : 	//MDR <= r2;
								begin
									TMRbus <= 0;
									ldMA <= 0;
									PA <= inoutIR[5:3];
									rd <= 1;
									ldMRMem <= 1;
									statedn <= 13'b0000100000000;
								end
								13'b0000100000000 : 	//M[MAR] <= MDR;
								begin
									ldMRMem <= 0;
									rd <= 0;
									TMRMem <= 1;
									if(over)
									begin
										TMRMem <= 0;
										statedn <= 13'b0000000000001;
									end
									if(over)
										stateIR <= 3'b001;
								end
								endcase
							endcase
						endcase
							end
							2'b01 :
							begin
							case(inoutIR[7:6]) 
							2'b00 :
							case(statei) 
							5'b00001 :	//MAR <= PC
								begin
									ldIR <= 0;
									ldPC <= 0;
									TPC <= 1;
									ldMA <= 1;
									statei <= 5'b00010;
								end
							5'b00010 :	//MDR <= M[MAR] ; PC <= PC+2
								begin
								TPC <= 0;
								ldMA <= 0;
								ldMRMem <= 1;
								ldPC <= 1;

								statei <= 5'b00101;
								end
							5'b00101 :
							begin
								ldPC <= 0;
								if(over)
								begin
									ldMRMem <= 0;
									statei <= 5'b00100;
								end
							end
							5'b00100 :	//Y <= MDR
								begin
								ldMRMem <= 0;
								ldPC <= 0;
								TMRbus <= 1;
								ldY <= 1;
								statei <= 5'b01000;
								end
							5'b01000 :	//Save <= r1 op Y
								begin
								TMRbus <= 0;
								ldY <= 0;
								op <= inoutIR[13:11];
								PA <= inoutIR[10:8];
								rd <= 1;
								ldSave <= 1;
								statei <= 5'b10000;
								end
							5'b10000 :	//r1 <= Save
								begin
								rd <= 0;
								ldSave <= 0;
								TSave <= 1;
								wr <= 1;
								statei <= 5'b00001;
								stateIR <= 3'b001;
								end
							endcase
							2'b01 : 
								case(stater) 
								3'b001 :	//Y <= r2;
								begin
								ldIR <= 0;
								ldPC <= 0;
								PA <= inoutIR[5:3];
								rd <= 1;
								ldY <= 1;
								stater <= 3'b010;
								end
								3'b010 :	//Save <= r1 op Y
								begin
								ldY <= 0;
								op <= inoutIR[13:11];
								PA <= inoutIR[10:8];
								ldSave <= 1;
								stater <= 3'b100;
								end
								3'b100 :	//r1 <= Save
								begin
								ldSave <= 0;
								rd <= 0;
								TSave <= 1;
								wr <= 1;
								stater <= 3'b001;
								stateIR <= 3'b001;
								end
								endcase
							2'b10 :
								case(statex)
								11'b00000000001 :	//MAR <= PC;
									begin
									TPC <= 1;
									ldMA <= 1;
									ldIR <= 0;
									ldPC <= 0;
									statex <= 11'b00000000010;
									end
								11'b00000000010 : 	//MDR <= M[MAR]; PC <= PC+2
									begin
									TPC <= 0;
									ldMA <= 0;
									ldMRMem <= 1;
									ldPC <= 1;
									
									statex <= 11'b00000000101;
									end
								11'b00000000101 :
								begin
									ldPC <= 0;
									if(over)
									begin
										ldMRMem <= 0;
										statex <= 11'b00000000100;
									end
								end
								11'b00000000100 : 	//Y <= MDR;
								begin
								ldMRMem <= 0;
								ldPC <= 0;
								TMRbus <= 1;
								ldY <= 1;
								statex <= 11'b00000001000;
								end
								11'b00000001000 : 	//Save <= Y+r2;
								begin
								TMRbus <= 0;
								ldY <= 0;
								PA <= inoutIR[5:3];
								rd <= 1;
								ldSave <= 1;
								statex <= 11'b00000010000;
								end
								11'b00000010000 : 	//Y <= Save;
								begin
								rd <= 0;
								ldSave <= 0;
								TSave <= 1;
								ldY <= 1;
								statex <= 11'b00000100000;
								end
								11'b00000100000 : 	//Save <= Y+r3;
								begin
								TSave <= 0;
								ldY <= 0;
								PA <= inoutIR[2:0];
								rd <= 1;
								ldSave <= 1;
								statex <= 11'b00001000000;
								end
								11'b00001000000 : 	//MAR <= Save
								begin
								rd <= 0;
								ldSave <= 0;
								TSave <= 1;
								ldMA <= 1;
								statex <= 11'b00010000000;
								end
								11'b00010000000 : 	//MDR <= M[MAR];
								begin
								TSave <= 0;
								ldMA <= 0;
								ldMRMem <= 1;
								if(over)
								begin
									ldMRMem <= 0;
									statex <= 11'b00100000000;
								end
								end
								11'b00100000000 : 	//Y <= MDR;
								begin
								ldMRMem <= 0;
								TMRbus <= 1;
								ldY <= 1;
								statex <= 11'b01000000000;
								end
								11'b01000000000 :	//Save <= r1 op Y
								begin
								TMRbus <= 0;
								ldY <= 0;
								op <= inoutIR[13:11];
								PA <= inoutIR[10:8];
								rd <= 1;
								ldSave <= 1;
								statex <= 11'b10000000000;
								end
								11'b10000000000 :	//r1 <= Save
								begin
								rd <= 0;
								ldSave <= 0;
								TSave <= 1;
								wr <= 1;
								statex <= 11'b00000000001;
								stateIR <= 3'b001;
								end
							endcase
							2'b11 :
								case(statedn)
								13'b0000000000001 :	//MAR <= PC;
								begin
								TPC <= 1;
								ldMA <= 1;
								ldIR <= 0;
								ldPC <= 0;
								statedn <= 13'b0000000000010;
								end
								13'b0000000000010 : 	//MDR <= M[MAR]; PC <= PC+2
								begin
								TPC <= 0;
								ldMA <= 0;
								ldMRMem <= 1;
								ldPC <= 1;
								
								statedn <= 13'b0000000000101;
								end
								13'b0000000000101:
								begin
									ldPC <= 0;
									if(over)
									begin
										ldMRMem <= 0;
										statedn <= 13'b0000000000100;
									end
								end
								13'b0000000000100 : 	//Y <= MDR;
								begin
								ldMRMem <= 0;
								ldPC <= 0;
								TMRbus <= 1;
								ldY <= 1;
								statedn <= 13'b0000000001000;
								end
								13'b0000000001000 : 	//Save <= Y+r2;
								begin
								TMRbus <= 0;
								ldY <= 0;
								PA <= inoutIR[5:3];
								rd <= 1;
								ldSave <= 1;
								statedn <= 13'b0000000010000;
								end
								13'b0000000010000 : 	//Y <= Save;
								begin
								rd <= 0;
								ldSave <= 0;
								TSave <= 1;
								ldY <= 1;
								statedn <= 13'b0000000100000;
								end
								13'b0000000100000 : 	//Save <= Y+r7;
								begin
								TSave <= 0;
								ldY <= 0;
								PA <= inoutIR[2:0];
								rd <= 1;
								ldSave <= 1;
								statedn <= 13'b0000001000000;
								end
								13'b0000001000000 : 	//MAR <= Save
								begin
								rd <= 0;
								ldSave <= 0;
								TSave <= 1;
								ldMA <= 1;
								statedn <= 13'b0000010000000;
								end
								13'b0000010000000 : 	//MDR <= M[MAR];
								begin
								TSave <= 0;
								ldMA <= 0;
								ldMRMem <= 1;
								if(over)
								begin
									ldMRMem <= 0;
									statedn <= 13'b0000100000000;
								end
								end
								13'b0000100000000 : 	//MAR <= MDR;
								begin
								ldMRMem <= 0;
								TMRbus <= 1;
								ldMA <= 1;
								statedn <= 13'b0001000000000;
								end
								13'b0001000000000 : 	//MDR <= M[MAR];
								begin
								TMRbus <= 0;
								ldMA <= 0;
								ldMRMem <= 1;
								if(over)
								begin
									ldMRMem <=0;
									statedn <= 13'b0010000000000;
								end
								end
								13'b0010000000000 : 	//Y <= MDR;
								begin
								ldMRMem <= 0;
								TMRbus <= 1;
								ldY <= 1;
								statedn <= 13'b0000000000001;
								end
								13'b0100000000000 : 	//Save <= r1 op Y;
								begin
								TMRbus <= 0;
								ldY <= 0;
								op <= inoutIR[13:11];
								PA <= inoutIR[10:8];
								rd <= 1;
								ldSave <= 1;
								statedn <= 13'b1000000000000;
								end
								13'b1000000000000 : 	//r1 <= Save;
								begin
								ldSave <= 0;
								rd <= 0;
								TSave <= 1;
								wr <= 1;
								statedn <= 13'b0000000000001;
								stateIR <= 3'b001;
								end
							endcase
						endcase
					end
					2'b10 : 
						begin
							case(statei)
							5'b00001 :	//assigning flag; MAR <= PC
							begin
							ldIR <= 0;
							ldPC <= 0;
							TPC <= 1;
							ldMA <= 1;
							if(inoutIR[13]==0 && inoutIR[12]==0 && inoutIR[11] == 0)
							flag <= (outZ & ~inoutIR[10]) | (~outZ & inoutIR[10]);
							else if(inoutIR[13]==0 && inoutIR[12]==0 && inoutIR[11] == 1)
							flag <= (outC & ~inoutIR[10]) | (~outC & inoutIR[10]);
							else if(inoutIR[13]==0 && inoutIR[12]==1 && inoutIR[11] == 0)
							flag <= (outV & ~inoutIR[10]) | (~outV & inoutIR[10]);
							else if(inoutIR[13]==0 && inoutIR[12]==1 && inoutIR[11] == 1)
							flag <= (outS & ~inoutIR[10]) | (~outS & inoutIR[10]);
							else if(inoutIR[13]==1 && inoutIR[12]==0 && inoutIR[11] == 0)
							flag <= 1;
							
							statei <= 5'b00010;
							end
							5'b00010 :	//MDR <= M[MAR]
							begin
							TPC <= 0;
							ldMA <= 0;
							ldMRMem <= 1;
							if(over)
							begin
								ldMRMem <=0;
								statei <= 5'b00100;
							end
							end
							5'b00100 :	//(flag) ? PC <= PC+label : PC <= PC+2;
								begin
									ldMRMem <= 0;
									if(flag)
										selPC <= 2'b01;
									else
										selPC <= 2'b00;
									ldPC <= 1;
									statei <= 5'b00001;
									stateIR <= 3'b001;
								end
							endcase
						end
						2'b11 :
							case(inoutIR[13:11])
								3'b000 :
									begin
										case(statei) 
										5'b00001 :	//MAR <= PC ; PC <= PC+2
										begin
											ldIR <= 0;
											selPC <= 2'b00;
											ldPC <= 1;
											TPC <= 1;
											ldMA <= 1;
											statei <= 5'b00010;
										end
										5'b00010 :	//MDR <= M[PC]; Y <= PC;
										begin
											ldMA <= 0;
											ldPC <= 0;
											ldMRMem <= 1;
											TPC <= 1;
											ldY <= 1;
											if(over)
											begin
												ldMRMem <= 0;
												statei <= 5'b00100;
											end
										end
										5'b00100 :	//Save <= MDR + Y
										begin
											TPC <= 0;
											ldMRMem <= 0;
											ldY <= 0;
											op <= 3'b000;
											TMRbus <= 1;
											ldSave <= 1;
											statei <= 5'b01000;
										end
										5'b01000 :	//MDR <= Save;
										begin
											TMRbus <= 0;
											ldSave <= 0;
											TSave <= 1;
											ldMRbus <= 1;
											statei <= 5'b10000;
										end
										5'b10000 :	//PC <= MDR; r0 <= PC
										begin
											TSave <= 0;
											ldMRbus <= 0;
											selPC <= 2'b10;
											ldPC <= 1;
											TPC <= 1;
											PA <= inoutIR[10:8];
											wr <= 1;
											statei <= 5'b00001;
											stateIR <= 3'b001;
											end
										endcase
									end
								3'b001 :
									begin
										case(stater)
											3'b001 :	//MDR <= r0
												begin
												ldIR <= 0;
												ldPC <= 0;
												PA <= inoutIR[10:8];
												rd <= 1;
												ldMRbus <= 1;
												stater <= 3'b010;
												end
											3'b010 :	//PC <= MDR
												begin
												rd <= 0;
												ldMRbus <= 0;
												selPC <= 2'b10;
												ldPC <= 1;
												stater <= 3'b001;
												stateIR <= 3'b001;
											end
										endcase 
									end
								3'b111 :
									begin
										stateIR <= 3'b000;
									end
								endcase
							endcase
						end
					endcase
			end
	end

endmodule


module CPU(inoutIR, inoutMDR, clk, rstctrl, rstdata,
	ldMA, ldMRMem, ldMRbus, ldIR, selPC, ldPC, ldY, op, ldSave, rd, wr, TMA, TY, TIR, TMRbus, TMRMem, TPC, TSave, PA, outSave, outZ, outC, outV, outS, outMAR,
	compl1bus,outPC,bus, outMDR,over
    );
	 inout [15:0]inoutIR;
	 inout [15:0]inoutMDR;
	 
	 output ldMA, ldMRMem, ldMRbus, ldIR, ldPC, ldY, ldSave, rd, wr, TMA, TY, TIR, TMRbus, TMRMem, TPC, TSave, outZ, outC, outV, outS;
	 output [15:0]outMAR;
	 output [2:0]PA;
	 output [2:0]op;
	 output [1:0]selPC;
	 
	 output [15:0]outSave;
	 output [15:0]outPC;
	 output [15:0]outMDR;
	 output [15:0]compl1bus;
	 output [15:0]bus;
	 output over;
	 input clk,rstctrl,rstdata;
	 
	Controller c1(outZ, outC, outV, outS, inoutIR, ldMA, ldMRMem, ldMRbus, ldIR, selPC, ldPC, ldY, op, ldSave, rd, wr, TMA, TY, TIR, TMRMem, TMRbus, TPC, TSave, PA, clk, rstctrl,over);
	datapath d1(ldMA, ldMRMem, ldMRbus, ldIR, selPC, ldPC, ldY, op, ldSave, rd, wr, TMA, TY, TIR, TMRbus, TMRMem, TPC, TSave, PA, inoutIR, outSave, outZ, outC, outV, outS, outMAR, inoutMDR, clk, rstdata,
	compl1bus,outPC,bus, outMDR
	);
	memory mem1(outMAR,inoutMDR,inoutIR,TMRMem,ldMRMem,ldIR,over,clk,rstdata);

endmodule

module memory(outMAR,inoutMDR,inoutIR,TMRMem,ldMRMem,ldIR,over,clk,rstdata);

input [15:0]outMAR;
inout [15:0]inoutMDR;
output [15:0]inoutIR;
input TMRMem;
input ldMRMem;
input ldIR;
output reg over;
input clk;
input rstdata;

reg [7:0] mem[0:6000];
reg stateMem;

reg [15:0]data_out;

assign inoutMDR = (ldMRMem) ? data_out : 16'bzzzzzzzzzzzzzzzz;
assign inoutIR = (ldIR) ? data_out : 16'bzzzzzzzzzzzzzzzz;

always@(posedge clk )
begin
	if(rstdata)
	begin
		stateMem <= 0;
		over <= 0;
		data_out <= 16'b0000000000000000;
		
	{mem[0],mem[1]} <= 16'b0000000100000000; //li r1,100 //r1=100
	{mem[2],mem[3]} <= 16'b0000000001100100; //100
	{mem[4],mem[5]} <= 16'b0000001001001000; // lr r2,r1 //r2=100 
	{mem[6],mem[7]} <= 16'b0100000100000000; //addi r1,43 //r1=143
	{mem[8],mem[9]} <= 16'b0000000000101011; //43
	{mem[10],mem[11]} <= 16'b0000001110001010; //lx r3, 100(r1,r2); // r3=M[343]
	{mem[12],mem[13]} <= 16'b0000000000000000; // 0
	{mem[14],mem[15]} <= 16'b0000001001011000; //lr r2,r3; //r2=4
	
	{mem[243],mem[244]} <= 16'b0000000001100100; //4
	
	{mem[16],mem[17]} <= 16'b1111111111111111; //end
 
	
	end
	else
	begin
		if(stateMem == 0 )
			over <= 0;
		#1;
		if(ldMRMem || TMRMem || ldIR)
		begin
			if(ldMRMem || ldIR)
				data_out <= {mem[outMAR[3:0]],mem[outMAR[3:0]+1]};
			if(TMRMem)
				{mem[outMAR[3:0]],mem[outMAR[3:0]+1]} = inoutMDR;
			$display("%d",{mem[8],mem[9]});
			case(stateMem)
			1'b0 :
			begin
				over <= 0;
				stateMem <= 1;
			end
			1'b1 :
			begin
				over <= 1;
				stateMem <= 0;
			end
			endcase
		end
	end
end
	


endmodule




module test_PC1;

	// Inputs
	reg [1:0]selPC;
	reg [15:0] outY;
	reg ldPC;
	reg clk;
	reg rst;

	// Outputs
	wire [15:0] bus;

	// Bidirs
	wire [15:0] outPC;

	// Instantiate the Unit Under Test (UUT)
	PCIncr uut (outPC,selPC,outY,ldPC,clk,rst
	);

	initial begin
	// Initialize Inputs
	selPC = 2'b00;
	outY = 16'b0001001001111001;
	ldPC = 0;
	clk = 0;
	rst = 1;

	// Wait 100 ns for global reset to finish
	#10;
	rst=0;
	
	#5
	ldPC = 1;
	#5
	ldPC = 0;
	#10
	selPC = 2'b01;
	#5
	ldPC = 1'b1;
	#5
	ldPC = 1'b0;
	selPC = 2'b00;
	#10
	ldPC = 1'b1;
	#50;
        
	// Add stimulus here

	end
	always
	#5 clk=~clk;
      
endmodule

module test_reg;

	// Inputs
	reg [15:0] in;
	reg load;
	reg clk;
	reg rst;

	// Outputs
	wire [15:0] out;

	// Instantiate the Unit Under Test (UUT)
	register uut (
	.in(in), 
	.out(out), 
	.load(load), 
	.clk(clk), 
	.rst(rst)
	);

	initial begin
	// Initialize Inputs
	in = 100;
	load = 0;
	clk = 0;
	rst = 1;
	#10
	rst = 0;
	#15
	load = 1;
	#10
	load  =0;
	

	// Wait 100 ns for global reset to finish
	#100;
        
	// Add stimulus here

	end
	
	always
	#5 clk = ~clk;
      
endmodule


module test_alu;

	// Inputs
	reg [15:0] X;
	reg [15:0] Y;
	reg [5:0] op;
	reg clk;

	// Outputs
	wire outZ;
	wire outC;
	wire outV;
	wire outS;
	wire [15:0] complbus;

	// Instantiate the Unit Under Test (UUT)
	alu uut (
	.X(X), 
	.Y(Y), 
	.op(op), 
	.outZ(outZ), 
	.outC(outC), 
	.outV(outV), 
	.outS(outS), 
	.complbus(complbus),
	.clk(clk)
	);

	initial begin
	// Initialize Inputs
	X = 1;
	Y = 2;
	op = 0;
	clk=0;

	// Wait 100 ns for global reset to finish
	#15;
	
	X=3;
	Y=2;
	op=3'b001;
	
	
	#15
	
	X=15;
	Y=1;
	op=3'b010;
	
	#5
	X=14;
	Y=5;
	op=3'b011;
	
	   
        
	// Add stimulus here

	end
      
endmodule

module test_data;

	// Inputs
	reg ldMA;
	reg ldMRMem;
	reg ldMRbus;
	reg ldIR;
	reg [1:0]selPC;
	reg ldPC;
	reg ldY;
	reg [2:0] op;
	reg ldSave;
	reg rd;
	reg wr;
	reg TMA;
	reg TY;
	reg TIR;
	reg TMRMem;
	reg TMRbus;
	reg TPC;
	reg TSave;
	reg [2:0] PA;
	reg clk;
	reg rst;

	// Outputs
	wire [15:0] outSave;
	wire outZ;
	wire outC;
	wire outV;
	wire outS;
	wire [15:0] outMAR;
	wire [15:0] outPC;
	wire [15:0] compl1bus;
	wire [15:0] bus;
	wire [15:0] outMDR;
	wire over;

	// Bidirs
	wire [15:0] inoutIR;
	wire [15:0] inoutMDR;
	
	reg [15:0] IR_reg ;
	reg [15:0] MDR_reg ;
	// Instantiate the Unit Under Test (UUT)
	datapath uut (ldMA, ldMRMem, ldMRbus, ldIR, selPC, ldPC, ldY, op, ldSave, rd, wr, TMA, TY, TIR, TMRbus, TMRMem, TPC, TSave, PA, inoutIR,
	outSave, outZ, outC, outV, outS, outMAR, inoutMDR, clk, rst,
	compl1bus,outPC,bus, outMDR
    );
	 
	 assign inoutIR = (ldIR) ? IR_reg : 16'bzzzzzzzzzzzzzzzz;
	 assign inoutMDR = (ldMRMem) ? MDR_reg : 16'bzzzzzzzzzzzzzzzz;

	initial begin
	// Initialize Inputs
	ldMA = 1;
	ldMRMem = 0;
	ldMRbus = 0;
	ldIR = 0;
	selPC = 2'b00;
	ldPC = 0;
	ldY = 0;
	op = 0;
	ldSave = 0;
	rd = 0;
	wr = 0;
	TIR = 0;
	TY = 0;
	TMA = 0;
	TMRMem = 0;
	TMRbus = 0;
	TPC = 1;
	TSave = 0;
	PA = 0;
	clk = 0;
	rst = 1;
	IR_reg = 16'b0000000001111111;
	MDR_reg = 16'b1001101111000001;

	// Wait 100 ns for global reset to finish
	#10;
	rst = 0;
	#10
	TPC = 0;
	ldMA = 0;
	ldIR = 1;
	ldPC = 1;
	#10;
	ldIR = 0;
	ldPC = 0;
	TPC = 1;
	ldMA = 1;
	#10
	TPC = 0;
	ldMA = 0;
	ldMRMem = 1;
	ldPC = 1;
	#10
	ldMRMem = 0;
	ldPC = 0;
	TMRbus = 1;
	PA = 3'b000;
	wr = 1;
	MDR_reg = 16'b0000000000001001;
	#10
	wr = 0;
	TMRbus = 0;
	ldMRMem = 1;
	#10
	rd = 1;
	
	
	
        
	// Add stimulus here

	end
	
	always
	#5 clk=~clk;
      
endmodule


module test_CPU;

	// Inputs
	reg clk;
	reg rstctrl;
	reg rstdata;

	// Outputs
	wire ldMA;
	wire ldMRMem;
	wire ldMRbus;
	wire ldIR;
	wire [1:0]selPC;
	wire ldPC;
	wire ldY;
	wire [2:0] op;
	wire ldSave;
	wire rd;
	wire wr;
	wire TMA;
	wire TY;
	wire TIR;
	wire TMRbus;
	wire TMRMem;
	wire TPC;
	wire TSave;
	wire [2:0] PA;
	wire [15:0] outSave;
	wire outZ;
	wire outC;
	wire outV;
	wire outS;
	wire [15:0] outMAR;
	wire [15:0] compl1bus;
	wire [15:0] outPC;
	wire [15:0] bus;
	wire [15:0] outMDR;
	wire over;

	// Bidirs
	wire [15:0] inoutIR;
	wire [15:0] inoutMDR;

	// Instantiate the Unit Under Test (UUT)
	CPU uut (
	.inoutIR(inoutIR), 
	.inoutMDR(inoutMDR), 
	.clk(clk), 
	.rstctrl(rstctrl), 
	.rstdata(rstdata), 
	.ldMA(ldMA), 
	.ldMRMem(ldMRMem), 
	.ldMRbus(ldMRbus), 
	.ldIR(ldIR), 
	.selPC(selPC), 
	.ldPC(ldPC), 
	.ldY(ldY), 
	.op(op), 
	.ldSave(ldSave), 
	.rd(rd), 
	.wr(wr), 
	.TMA(TMA), 
	.TY(TY), 
	.TIR(TIR), 
	.TMRbus(TMRbus), 
	.TMRMem(TMRMem), 
	.TPC(TPC), 
	.TSave(TSave), 
	.PA(PA), 
	.outSave(outSave), 
	.outZ(outZ), 
	.outC(outC), 
	.outV(outV), 
	.outS(outS), 
	.outMAR(outMAR), 
	.compl1bus(compl1bus), 
	.outPC(outPC), 
	.bus(bus), 
	.outMDR(outMDR),
	.over(over)
	);

	initial begin
	// Initialize Inputs
	clk = 1;
	rstctrl = 1;
	rstdata = 1;
	
	#10
	rstctrl = 0;
	rstdata = 0;
	// Wait 100 ns for global reset to finish
	#200;
        
	// Add stimulus here

	end
	
	always
	#5 clk = ~clk;
      
endmodule

