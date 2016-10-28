`timescale 100ps / 1ps

module xor16_(
		output[15:0] c,
		input [15:0] a,
		input b);
	genvar i;
	generate for(i=0; i <= 15; i=i+1)
	begin:loop
		xor(c[i], a[i], b);
	end
	endgenerate

endmodule



module or16(
		output[15:0] c,
		input [15:0] a, b);
	genvar i;
	generate for(i=0; i <= 15; i=i+1)
	begin:loop
		or(c[i], a[i], b[i]);
	end
	endgenerate

endmodule



module and16(
		output[15:0] c,
		input [15:0] a, b);
	genvar i;
	generate for(i=0; i <= 15; i=i+1)
	begin:loop
		and(c[i], a[i], b[i]);
	end
	endgenerate

endmodule

module fullAdder ( a ,b ,cin ,s ,Cout );

    output s ;
    output Cout ;

    input a ;
    input b ;
    input cin ;

	 xor(s, a, b, cin);
	  wire w1,w2,w3;
    and (w1, a,b), (w2, b, cin), (w3, cin,a);
    or (Cout, w1, w2, w3);
endmodule

module adder16bit (sum, c_n, c_n_1, a, b, cin);

output [15:0] sum ;
output c_n, c_n_1;

input [15:0] a ;
input [15:0] b ;
input cin;

wire [13:0] s;

fullAdder fa0(a[0],b[0],cin,sum[0],s[0]);
fullAdder fa1(a[1],b[1],s[0],sum[1],s[1]);
fullAdder fa2(a[2],b[2],s[1],sum[2],s[2]);
fullAdder fa3(a[3],b[3],s[2],sum[3],s[3]);
fullAdder fa4(a[4],b[4],s[3],sum[4],s[4]);
fullAdder fa5(a[5],b[5],s[4],sum[5],s[5]);
fullAdder fa6(a[6],b[6],s[5],sum[6],s[6]);
fullAdder fa7(a[7],b[7],s[6],sum[7],s[7]);
fullAdder  fa8(a[8],b[8],s[7],sum[8],s[8]);
fullAdder  fa9(a[9],b[9],s[8],sum[9],s[9]);
fullAdder  fa10(a[10],b[10],s[9],sum[10],s[10]);
fullAdder  fa11(a[11],b[11],s[10],sum[11],s[11]);
fullAdder  fa12(a[12],b[12],s[11],sum[12],s[12]);
fullAdder  fa13(a[13],b[13],s[12],sum[13],s[13]);
fullAdder  fa14(a[14],b[14],s[13],sum[14],c_n_1);
fullAdder  fa15(a[15],b[15],c_n_1, sum[15],c_n);

endmodule


module DFF(output reg q, nq,input d,input load, rst);
	//reg q, nq;
	always @ (posedge load or negedge rst)
	begin
		if(rst == 0)
			q <= 0;
		else
			begin
				q <= d;
				nq <= ~d;
			end
	end

endmodule


module cmp16(
		output [15:0] out,
		input[15:0] i);
	wire[15:0] t;
	genvar j;
	generate for(j=0; j <= 15; j=j+1)
	begin:loop
		not(t[j], i[j]);
	end
	endgenerate

	wire cn,cn1;
  adder16bit m(out, cn, cn1, t, 16'b0000000000000000, 1'b1);
endmodule



module mux4to3(
		output reg [2:0] out,
		input [2:0] in0, in1, in2, in3,	input [1:0] sel);

	always @(sel, in0, in1, in2, in3)
		case(sel)
			2'b00: out = in0;
			2'b01: out = in1;
			2'b10: out = in2;
			2'b11: out = in3;
		endcase
endmodule


module Mux8to16(
		output reg [15:0] out,
		input[15:0] in0, in1, in2, in3, in4, in5, in6, in7,
		input[2:0] sel);
	
	always @ (in0 or in1 or in2 or in3 or in4 or in5 or in6 or in7 or sel)
		case(sel)
			0: out= in0;
			1: out= in1;
			2: out= in2;
			3: out= in3;
			4: out= in4;
			5: out= in5;
			6: out= in6;
			7: out= in7;
		endcase

endmodule


module mux2to3(
		output reg [2:0] out,
		input [2:0] in0, in1,
		input sel);

		always @(sel, in0, in1)
		case(sel)
			0: out = in0;
			1: out = in1;
	endcase
endmodule


module Dcode3to8(out, sel);


  input [2:0] sel;
  output reg [7:0] out;

  always @(sel,out)
		 case (sel)
			 3'b000  : out = 8'b00000001;
			 3'b001  : out = 8'b00000010;
			 3'b010  : out = 8'b00000100;
			 3'b011  : out = 8'b00001000;
			 3'b100  : out = 8'b00010000;
			 3'b101  : out = 8'b00100000;
			 3'b110  : out = 8'b01000000;
			 3'b111	: out = 8'b10000000;
		 endcase

endmodule


module DMux1to8(
		output reg [7:0] out,
		input i,
		input [2:0] sel);
	always @ (i or sel)

		case(sel)
			7: out = {i, 7'b0000000};
			6: out = {1'b0, i, 6'b000000};
			5: out = {2'b00, i, 5'b00000};
			4: out = {3'b000, i, 4'b0000};
			3: out = {4'b0000, i, 3'b000};
			2: out = {5'b00000, i, 2'b00};
			1: out = {6'b000000, i, 1'b0};
			0: out = {7'b0000000, i};
			default: out = 8'b00000000;
		endcase

endmodule


module reg16(
		output reg[15:0] q,
		input[15:0] d,
		input load, rst);
	//reg[15:0] q;
	always @ (posedge load or negedge rst)
	begin
		if(rst == 0)
			q <= 0;
		else
			q <= d;
	end

endmodule

module top_module(input clk, topRst);
	 
	 wire Dc, rd, wr, lPC, TPC, LT, TT, LMAR, TMAR, LIR, RMDRExt, RMDRInt, TMDR2X, TMDR2Ext, TMDR2IR, LMDR, LregY, T1, Lflag, rdM, wrM, PCrst, mfc;
	 wire [6:0] IRControl;
	 wire [15:0] Abus, Dbus;
	 wire [1:0] fnSel, RegSel;
	 
	datapath dpO(Dc, IRControl, Abus, Dbus, rd, wr, lPC, TPC, LT, TT, LMAR, TMAR, LIR, RMDRExt, RMDRInt, TMDR2X, TMDR2Ext, TMDR2IR, LMDR, LregY, T1, Lflag, PCrst, fnSel, RegSel);
	controller contrO(rd, wr, lPC, TPC, LT, TT, LMAR, TMAR, LIR, RMDRExt, RMDRInt, TMDR2X, TMDR2Ext, TMDR2IR, LMDR, LregY, T1, Lflag, rdM, wrM, PCrst, fnSel, RegSel, Dc, clk, topRst, mfc, IRControl);
	mainMemory memMod(Abus, Dbus, rdM, wrM, mfc);

endmodule


module tristate(
		output [15:0] b,
		input[15:0] a,
		input enable);
	assign b = (enable) ? a : 16'bzzzzzzzzzzzzzzzz;
	
endmodule


module alu(output[15:0] z,output c_n, c_n_1,
		input[15:0] x, y,input [2:0] fnsel);

	wire [15:0] cmpOut, sum, product, y1, sum16bit;
	
	xor16_ xm(y1, y, fnsel[0]);
	adder16bit addm(sum16bit, c_n, c_n_1, x, y1, fnsel[0]);
	and16 andm(product, x, y);
	or16 om(sum, x, y);
	cmp16 cm(cmpOut, x);
	Mux8to16 mm(z, sum16bit, sum16bit, product, sum, 16'bXXXXXXXXXXXXXXXX, cmpOut, x, 16'bXXXXXXXXXXXXXXXX, fnsel);

endmodule


module statusDetect(output Dc,
		input [15:0] z,
		input c_n, c_n_1, Lflag,
		input [3:0] ir12to9);
	//buf(Cin, c_n);
	
	wire Cin,Vin,Sin,Zin,rst,Zout,notZout,Cout,notCout,Vout,notVout,Sout,notSout;
	assign Cin = c_n;
	xor(Vin, c_n, c_n_1);
	assign Sin = z[15];
	nor(Zin, z[0], z[1], z[2], z[3], z[4], z[5], z[6], z[7], z[8], z[9], z[10], z[11], z[12], z[13], z[14], z[15]);

	DFF dff1(Zout, notZout, Zin, Lflag, rst),
		 dff2(Cout, notCout, Cin, Lflag, rst),
		 dff3(Vout, notVout, Vin, Lflag, rst),
		 dff4(Sout, notSout, Sin, Lflag, rst);

	muxDc Dcondition(Dc, 1'b1, Zout, notZout, Cout, notCout, Vout, notVout, Sout, notSout, ir12to9);
endmodule




module RegBank(
		output [15:0] p,
		input [15:0] Din,
		input [2:0] pa, wPa,
		input rd, wr);
	wire[15:0] q0, q1, q2 ,q3 ,q4 ,q5 ,q6 ,q7;
	wire[7:0] wPaOut, t;
	Dcode3to8 decoder(wPaOut, wPa);
	wire load0,load1,load2,load3,load4,load5,load6,load7;
	and and1(load0, wr, wPaOut[0]);
	and and2(load1, wr, wPaOut[1]);
	and and3(load2, wr, wPaOut[2]);
	and and4(load3, wr, wPaOut[3]);
	and and5(load4, wr, wPaOut[4]);
	and and6(load5, wr, wPaOut[5]);
	and and7(load6, wr, wPaOut[6]);
	and and8(load7, wr, wPaOut[7]);
	
  wire rst,Din;
	reg16 r0(q0, Din, load0, rst),r1(q1, Din, load1, rst),
			r2(q2, Din, load2, rst),r3(q3, Din, load3, rst),
			r4(q4, Din, load4, rst),r5(q5, Din, load5, rst),
			r6(q6, Din, load6, rst),r7(q7, Din, load7, rst);
	
	DMux1to8 dmm(t, rd, pa);
	
	tristate tsb0(p, q0, t[0]),tsb1(p, q1, t[1]),
			tsb2(p, q2, t[2]),tsb3(p, q3, t[3]),
			tsb4(p, q4, t[4]),tsb5(p, q5, t[5]),
			tsb6(p, q6, t[6]),tsb7(p, q7, t[7]);

endmodule


module mux2_1(
		output out,
		input in0, in1, sel);
  	wire nsel,w1,w2;
	not nn(nsel, sel);
  and at1(w1, in0, nsel), at2(w2, in1, sel);
	or ot(out, w1, w2);
endmodule

module muxDc(
		output reg Dc,
		input iu, inZ, inZnot, inC, inCnot, inV, inVnot, inS, inSnot,
		input[3:0] ir12to9);
	//reg[15:0] out;
	
	always @ (iu, inZ, inZnot, inC, inCnot, inV, inVnot, inS, inSnot, ir12to9)
	case(ir12to9)
		4'b0000: begin Dc= iu;  end
		4'b1000: begin Dc= inZ;  end
		4'b1001: begin Dc= inZnot;  end
		4'b1010: begin Dc= inC;  end
		4'b1011: begin Dc= inCnot; end
		4'b1100: begin Dc= inV; end
		4'b1101: begin Dc= inVnot; end
		4'b1110: begin Dc= inS;end
		4'b1111: begin Dc= inSnot; end
	endcase

endmodule

module mainMemory(

		input [15:0] Abus,
		inout [15:0] Dbus,
		input rdM, wrM,
		output reg mfc);

	reg [15:0] M[0:65535];// 65536 = 2^ 16
	
	initial
	begin
		M[0] = 16'b1000000110001111;//	33167
		M[1] = 16'b0000000111110100;//	500
		M[2] = 16'b1001011111010101;//	38869
		M[3] = 16'b0000000000000000;//	0
		M[4] = 16'b1000010111101110;//	34286
		M[5] = 16'b0000000000000001;//	1
		M[6] = 16'b0000001110000101;//	901
		M[7] = 16'b1010010111101110;//	42478
		M[8] = 16'b0000000000001010;//	10	
		M[9] = 16'b0100100111110101;//	18933
		M[10] = 16'b1111111111111000;//	65528
		M[11] = 16'b1101001101010101;//	54101
		M[12] = 16'b0000000001011000;//	88
		M[100] = 16'b1001000111000001;//37313
		M[101] = 16'b0000000001111001;//121
      	M[499] = 16'b0000001000001000;//520
		M[500] = 16'b0000000000001111;//15
		M[516] = 16'b0000000000000111;//7
		M[520] = 16'b0000000000001010;//10
	end
	
	reg [15:0] DbusReg;
	assign Dbus = (rdM) ? DbusReg : 16'bzzzzzzzzzzzzzzzz;
		
	always@(posedge rdM or posedge wrM)
	begin
		if(rdM == 1) begin
			DbusReg = M[Abus];
		end
		
		else if(wrM == 1) begin
			//M[Abus] = Dbus;
			#(1*0.01); 
			M[Abus] = Dbus;
		end
		
	end
	
	always @ (posedge rdM or posedge wrM)
	begin
		mfc = 0;
		#21;
		mfc = 1;
	end
endmodule

module controller(
		output reg rd, wr, lPC, TPC, LT, TT, LMAR, TMAR, LIR, RMDRExt, RMDRInt, TMDR2X, TMDR2Ext, TMDR2IR, LMDR, LregY, T1, Lflag, rdM, wrM, PCrst,


		output reg [1:0] fnSel, RegSel,
		input Dc, clk, topRst, mfc, //topRst is also active low
		input [6:0] IRControl);

	parameter f0=0,f1 =1,f2 =2,f3 =3,f4 =4,  
		  ain1=5,ain2=6,ain3=7,ain4=8,ain5=9,ain6=10,	  
		  min6=11,ar1=12,ar2=13,	  
		  mr2=14,  
		  ax1=15,ax2=16,ax3=17,ax4=18,ax5=19,ax6=20,ax7=21,ax8=22,ax9=23,ax10=24,ax11=25,ax12=26, 
		  mx12=27,
		  aa1=28,aa2=29,aa3=30,aa4=31,aa5=32,aa6=33,aa7=34,aa8=35,aa9=36,aa10=37,	  
		  ma10=38,  
			an1=39,an2=40,an3=41,an4=42,an5=43,an6=44,an7=45,an8=46,
			an9=47,an10=48,an11=49,an12=50,an13=51,an14=52,an15=53,
		  mn15=54,
		  cmpState=55,
		  lin5 = 56,
		  lr1 = 57,
		  lx11 = 58,
		  la9 = 59,
		  ln14 = 60,
		  sx8 = 61,sx9 = 62,sx10 = 63,
		  sa6 = 64,sa7 = 65,sa8 = 66,
		  sn12 = 67,sn13 = 68,sn14 = 69,
		  j1 = 70,j2 = 71,j3 = 72,j4 = 73,j5 = 74,  
		  jal1 = 75,jal2 = 76,jal3 = 77,jal4 = 78,jal5 = 79,jal6 = 80,jal7 = 81,
		  jrState = 82;
		  
   	reg [6:0] state, next_state; //82+1 (=83) states
   	
	always @ (posedge clk or negedge topRst)
	begin
		if(topRst==0) state <= f0;
		else state <= next_state;
	end
	
	// State transitions (for next state)
	always @ (state, IRControl, Dc, mfc)
	begin
		next_state = state;
		case(state)
		f0:	next_state = f1;
		f1:	next_state = f2;
		f2:	if(mfc == 0) next_state = f2;
				else next_state = f3;
		f3:	next_state = f4;
		f4: 	if((IRControl[6] == 0 | IRControl[6:4] == 3'b100) && IRControl[2:0] == 3'b000 && IRControl[6:3] != 4'b0101) //{add,sub,and,or,mns,load}i
					next_state = ain1;
				else if(IRControl[6] == 0 && IRControl[2:0] == 001 && IRControl[6:3] != 4'b0101)
 //{add,sub,and,or,mns}r
					next_state = ar1;
				else if(IRControl[6:4] == 3'b100 && IRControl[2:0] == 001) //loadr
					next_state = lr1;
				else if((IRControl[6] == 0 | IRControl[6:5] == 2'b10) && IRControl[2:0] == 3'b010 && IRControl[6:3] != 4'b0101) //{add,sub,and,or,mns,load,st}x
					next_state = ax1;
				else if((IRControl[6] == 0 | IRControl[6:5] == 2'b10) && IRControl[2:0] == 3'b011 && IRControl[6:3] != 4'b0101) //{add,sub,and,or,mns,load,st}a
					next_state = aa1;
				else if((IRControl[6] == 0 | IRControl[6:5] == 2'b10) && IRControl[2:0] == 3'b100 && IRControl[6:3] != 4'b0101) //{add,sub,and,or,mns,load,st}n
					next_state = an1;
				else if(IRControl[6:3] == 4'b0101) //cmp
					next_state = cmpState;
				else if(IRControl[6:4] == 3'b110) //j{_,z,nz,c,nc,v,nv,m,nm}
					next_state = j1;
				else if(IRControl[6:3] == 4'b1110) //jal
					next_state = jal1;
				else if(IRControl[6:3] == 4'b1111) //jr
					next_state = jrState;
				else //begin
					$display("Process has been completed.");//$finish;end
		ain1:	next_state = ain2;
		ain2:	if(mfc == 0) next_state = ain2;
				else next_state = ain3;
		ain3:	next_state = ain4;
		ain4:	if(IRControl[6:4] == 3'b100) next_state = lin5;
				else next_state = ain5;
		ain5:	if(4'b0100 == IRControl[6:3]) next_state = min6;
				else next_state = ain6;
		ain6:	next_state = f1;
		min6:	next_state = f1;
		ar1:	if(4'b0100 == IRControl[6:3]) next_state = mr2;
				else next_state = ar2;
		ar2:	next_state = f1;
		mr2:	next_state = f1;
		ax1:	next_state = ax2;
		ax2:	if(mfc == 0) next_state = ax2;
				else next_state = ax3;
		ax3:	next_state = ax4;
		ax4:	next_state = ax5;
		ax5:	next_state = ax6;
		ax6:	next_state = ax7;
		ax7:	if(3'b101 == IRControl[6:4]) next_state = sx8;
				else next_state = ax8;
		ax8: next_state = ax9;
		ax9:	if(mfc == 0) next_state = ax9;
				else next_state = ax10;
		ax10: if(3'b100 == IRControl[6:4]) next_state = lx11;
				else next_state = ax11;
		ax11: if(4'b0100 == IRControl[6:3]) next_state = mx12;
				else next_state = ax12;
		ax12: next_state = f1;
		mx12: next_state = f1;
		aa1:	next_state = aa2;
		aa2:	if(mfc == 0) next_state = aa2;
				else next_state = aa3;
		aa3:	next_state = aa4;
		aa4:	next_state = aa5;
		aa5:	if(3'b101 == IRControl[6:4]) next_state = sa6;
				else next_state = aa6;
		aa6:	next_state = aa7;
		aa7:	if(mfc == 0) next_state = aa7;
				else next_state = aa8;
		aa8:	if(3'b100 == IRControl[6:4]) next_state = la9;
				else next_state = aa9;
		aa9:	if(4'b0100 == IRControl[6:3]) next_state = ma10;
				else next_state = aa10;
		aa10:	next_state = f1;
		ma10:	next_state = f1;
		an1:	next_state = an2;
		an2:	if(mfc == 0) next_state = an2;
				else next_state = an3;
		an3:	next_state = an4;
		an4:	next_state = an5;
		an5:	next_state = an6;
		an6:	next_state = an7;
		an7:	next_state = an8;
		an8:	next_state = an9;
		an9:	if(mfc == 0) next_state = an9;
				else next_state = an10;
		an10:	next_state = an11;
		an11:	if(3'b101 == IRControl[6:4]) next_state = sn12;
				else next_state = an12;
		an12:	if(mfc == 0) next_state = an12;
				else next_state = an13;
		an13:	if(3'b100 == IRControl[6:4]) next_state = ln14;
				else next_state = an14;
		an14:	if(4'b0100 == IRControl[6:3]) next_state = mn15;
				else next_state = an15;
		an15:	next_state = f1;
		mn15:	next_state = f1;
		cmpState:	next_state = f1;
		lin5:	next_state = f1;
		lr1:	next_state = f1;
		lx11:	next_state = f1;
		la9:	next_state = f1;
		ln14:	next_state = f1;
		sx8:	next_state = sx9;
		sx9:	next_state = sx10;
		sx10:	if(mfc == 0) next_state = sx10;
				else next_state = f1;
		sa6:	next_state = sa7;
		sa7:	next_state = sa8;
		sa8:	if(mfc == 0) next_state = sa8;
				else next_state = f1;
		sn12:	next_state = sn13;
		sn13:	next_state = sn14;
		sn14:	if(mfc == 0) next_state = sn14;
				else next_state = f1;
		j1:	next_state = j2;
		j2:	if(mfc == 0) next_state = j2;
				else next_state = j3;
		j3:	next_state = j4;
		j4:	if(Dc) next_state = j5;
				else next_state = f1;
		j5:	next_state = f1;
		jal1:	next_state = jal2;
		jal2:	next_state = jal3;
		jal3:	next_state = jal4;
		jal4:	if(mfc == 0) next_state = jal4;
				else next_state = jal5;
		jal5:	next_state = jal6;
		jal6:	next_state = jal7;
		jal7:	next_state = f1;
		jrState:	next_state = f1;
		default: $display("Unexpected state. Reset to 0- %0d", $time);
		endcase
	end
	
	// For output signals
	always @ (state)
	begin
		rd = 0; wr = 0; lPC = 0; TPC = 0; LT = 0; TT = 0; LMAR = 0; TMAR = 0; LIR = 0; RMDRExt = 0; RMDRInt = 0; TMDR2X = 0; TMDR2Ext = 0; TMDR2IR = 0; LMDR = 0; LregY = 0; T1 = 0; Lflag = 0; rdM = 0; wrM = 0; PCrst = 1;
		fnSel = 2'b11; RegSel = 2'b11; //for don't care cases
		case(state)
		f0:	begin #1; PCrst <= 0;  end

		f1:	begin TPC <= 1; fnSel <= 2'b01; LMAR <= 0; /*LMAR <= ~clk;*/ TMAR <= 1; rdM <= 1;  #5; LMAR <= 1; end

		f2:	begin TMAR <= 1; rdM <= 1;  end

		f3:	begin TMAR <= 1; rdM <= 1; LIR <= 0; T1 <= 1; LregY <= 0;/*LregY <= ~clk;*/  #5; LIR <= 1; LregY <= 1; end

		f4:	begin TPC <= 1; fnSel <= 2'b10; /*lPC = ~clk;*/  #5; lPC <= 1; end

		ain1:	begin TPC <= 1; fnSel <= 2'b01; /*LMAR <= ~clk;*/ TMAR <= 1; rdM <= 1; #5; LMAR <= 1; end
		ain2:	begin TMAR <= 1; rdM <= 1;  end
		ain3:	begin TMAR <= 1; rdM <= 1; RMDRExt <= 1; /*LMDR <= ~clk;*/ T1 <= 1; /*LregY <= ~clk;*/ #5; LMDR <= 1; LregY <= 1;end
		ain4:	begin TPC <= 1; fnSel <= 2'b10; /*lPC <= ~clk;*/#5; lPC <= 1; end
		ain5:	begin TMDR2X <= 1; /*LregY <= ~clk;*/  #5; LregY <= 1; end
		ain6:	begin rd <= 1; RegSel <= 2; fnSel <= 0; /*wr <= ~clk;*/ /*Lflag <= ~clk;*/  #5; wr <= 1; Lflag <= 1; end
		min6:	begin rd <= 1; RegSel <= 2; fnSel <= 0; /*Lflag <= ~clk;*/  #5; Lflag <= 1; end
		ar1:	begin rd <= 1; RegSel <= 0; /*LregY <= ~clk;*/#5; LregY <= 1; #5; LregY <= 1; end
		ar2:	begin rd <= 1; RegSel <= 2; fnSel <= 0; /*wr <= ~clk;*/ /*Lflag <= ~clk;*/#5; wr <= 1; Lflag <= 1; end
		mr2:	begin rd <= 1; RegSel <= 2; fnSel <= 0; /*Lflag <= ~clk;*/ #5; Lflag <= 1; end
		ax1:	begin TPC <= 1; fnSel <= 1; /*LMAR <= ~clk;*/ TMAR <= 1; rdM <= 1;#5; LMAR <= 1; end
		ax2:	begin TMAR <= 1; rdM <= 1; end
		ax3:	begin TMAR <= 1; rdM <= 1; RMDRExt <= 1; /*LMDR <= ~clk;*/ T1 <= 1; #5; LMDR <= 1; LregY <= 1; end
		ax4:	begin TPC <= 1; fnSel <= 2; /*lPC <= ~clk;*/ #5; lPC <= 1; end
		ax5:	begin rd <= 1; RegSel <= 1; /*LregY <= ~clk;*/#5; LregY <= 1; end
		ax6:	begin rd <= 1; RegSel <= 0; fnSel <= 2; /*LT <= ~clk;*/  #5; LT <= 1; end
		ax7:	begin TMDR2X <= 1;#5; LregY <= 1; end
		ax8:	begin TT <= 1; fnSel <= 2; /*LMAR <= ~clk;*/ TMAR <= 1; rdM <= 1;#5; LMAR <= 1; end
		ax9:	begin TMAR <= 1; rdM <= 1;end
		ax10:	begin TMAR <= 1; rdM <= 1; RMDRExt <= 1; /*LMDR <= ~clk;*/ #5; LMDR <= 1; end
		ax11:	begin TMDR2X <= 1; /*LregY <= ~clk;*/#5; LregY <= 1; end
		ax12:	begin rd <= 1; RegSel <= 2; fnSel <= 0; /*wr <= ~clk;*/ /*Lflag <= ~clk;*/#5; wr <= 1; Lflag <= 1; end
		mx12:	begin rd <= 1; RegSel <= 2; fnSel <= 0; /*Lflag <= ~clk;*/#5; Lflag <= 1; end
		aa1:	begin TPC <= 1; fnSel <= 1; /*LMAR <= ~clk;*/ TMAR <= 1; rdM <= 1;#5; LMAR <= 1; end
		aa2:	begin TMAR <= 1; rdM <= 1;end
		aa3:	begin TMAR <= 1; rdM <= 1; RMDRExt <= 1; /*LMDR <= ~clk;*/ T1 <= 1; /*LregY <= ~clk;*/#5; LMDR <= 1; LregY <= 1; end
		aa4:	begin TPC <= 1; fnSel <= 2; /*lPC <= ~clk;*/#5; lPC <= 1; end
		aa5:	begin TMDR2X <= 1; /*LregY <= ~clk;*/LregY <= 1; end
		aa6:	begin rd <= 1; RegSel <= 0; fnSel <= 2; /*LMAR <= ~clk;*/ TMAR <= 1; rdM <= 1;#5; LMAR <= 1; end
		aa7:	begin TMAR <= 1; rdM <= 1;end
		aa8:	begin TMAR <= 1; rdM <= 1; RMDRExt <= 1; /*LMDR <= ~clk;*/#5; LMDR <= 1; end
		aa9:	begin TMDR2X <= 1; #5; LregY <= 1; end
		aa10:	begin rd <= 1; RegSel <= 2; fnSel <= 0; #5; wr <= 1; Lflag <= 1; end
		ma10:	begin rd <= 1; RegSel <= 2; fnSel <= 0;#5; Lflag <= 1; end
		an1:	begin TPC <= 1; fnSel <= 1; /*LMAR <= ~clk;*/ TMAR <= 1; rdM <= 1;#5; LMAR <= 1; end
		an2:	begin TMAR <= 1; rdM <= 1;end
		an3:	begin TMAR <= 1; rdM <= 1; RMDRExt <= 1; /*LMDR <= ~clk;*/ T1 <= 1; /*LregY <= ~clk;*/ #5; LMDR <= 1; LregY <= 1; end
		an4:	begin TPC <= 1; fnSel <= 2; /*lPC <= ~clk;*/#5; lPC <= 1; end
		an5:	begin rd <= 1; RegSel <= 1; /*LregY <= ~clk;*/#5; LregY <= 1; end
		an6:	begin rd <= 1; RegSel <= 0; fnSel <= 2; /*LT <= ~clk;*/#5; LT <= 1; end
		an7:	begin TMDR2X <= 1; /*LregY <= ~clk;*/#5; LregY <= 1; end
		an8:	begin TT <= 1; fnSel <= 2; /*LMAR <= ~clk;*/ TMAR <= 1; rdM <= 1;#5; LMAR <= 1; end
		an9:	begin TMAR <= 1; rdM <= 1; end
		an10:	begin TMAR <= 1; rdM <= 1; RMDRExt <= 1; /*LMDR <= ~clk;*/#5; LMDR <= 1; end
		an11:	begin TMDR2X <= 1; fnSel <= 1; /*LMAR <= ~clk;*/#5; LMAR <= 1; end
		an12:	begin TMAR <= 1; rdM <= 1; end
		an13:	begin TMAR <= 1; rdM <= 1; RMDRExt <= 1; /*LMDR <= ~clk;*/#5; LMDR <= 1; end
		an14:	begin TMDR2X <= 1; /*LregY <= ~clk;*/  #5; LregY <= 1; end
		an15:	begin rd <= 1; RegSel <= 2; fnSel <= 0; /*wr <= ~clk;*/ /*Lflag <= ~clk;*/#5; wr <= 1; Lflag <= 1; end
		mn15:	begin rd <= 1; RegSel <= 2; fnSel <= 0; /*Lflag <= ~clk;*/#5; Lflag <= 1; end
		cmpState:	begin rd <= 1; RegSel <= 2; fnSel <= 0;#5; wr <= 1; Lflag <= 1; end
		lin5:	begin TMDR2X <= 1; fnSel <= 1;#5; wr <= 1; end
		lr1:	begin rd <= 1; RegSel <= 0; fnSel <= 1;#5; wr <= 1; end
		lx11:	begin TMDR2X <= 1; fnSel <= 1; wr <= 1; end
		la9:	begin TMDR2X <= 1; fnSel <= 1;#5; wr <= 1; end
		ln14:	begin TMDR2X <= 1; fnSel <= 1; #5; wr <= 1; end
		sx8:	begin rd <= 1; RegSel <= 2; fnSel <= 1; RMDRInt <= 1; /*LMDR <= ~clk;*/  #5; LMDR <= 1; end
		sx9:	begin TT <= 1; fnSel <= 2; /*LMAR <= ~clk;*/ TMAR <= 1; TMDR2Ext <= 1; /*wrM <= 1;*/#5; LMAR <= 1; /*TMDR2Ext <= 1;*/end
		sx10:	begin TMAR <= 1; TMDR2Ext <= 1; wrM <= 1;end
		sa6:	begin rd <= 1; RegSel <= 2; fnSel <= 1; RMDRInt <= 1; /*LMDR <= ~clk;*/#5; LMDR <= 1; end
		sa7:	begin rd <= 1; RegSel <= 0; fnSel <= 2; /*LMAR <= ~clk;*/ TMAR <= 1; TMDR2Ext <= 1; /*wrM <= 1;*/#5; LMAR <= 1; end
		sa8:	begin TMAR <= 1; TMDR2Ext <= 1; wrM <= 1;end
		sn12:	begin rd <= 1; RegSel <= 2; fnSel <= 1; RMDRInt <= 1; /*LMDR <= ~clk;*/ #5; LMDR <= 1; end
		sn13:	begin TMAR <= 1; TMDR2Ext <= 1; wrM <= 1;end
		sn14:	begin TMAR <= 1; TMDR2Ext <= 1; wrM <= 1;end
		j1:	begin TPC <= 1; fnSel <= 1; /*LMAR <= ~clk;*/ TMAR <= 1; rdM <= 1;#5; LMAR <= 1; end
		j2:	begin TMAR <= 1; rdM <= 1; end
		j3:	begin TMAR <= 1; rdM <= 1; RMDRExt <= 1; /*LMDR <= ~clk;*/ #5; LMDR <= 1; end
		j4:	begin TMDR2X <= 1; #5; LregY <= 1; end
		j5:	begin TPC <= 1; fnSel <= 2;#5; lPC <= 1; end
		jal1:	begin T1 <= 1;#5; LregY <= 1; end
		jal2:	begin TPC <= 1; fnSel <= 2;#5; wr <= 1; end
		jal3:	begin TPC <= 1; fnSel <= 1; /*LMAR <= ~clk;*/ TMAR <= 1; rdM <= 1;#5; LMAR <= 1; end
		jal4:	begin TMAR <= 1; rdM <= 1;end
		jal5:	begin TMAR <= 1; rdM <= 1; RMDRExt <= 1;#5; LMDR <= 1; end
		jal6:	begin TMDR2X <= 1;#5; LregY <= 1; end
		jal7:	begin TPC <= 1; fnSel <= 2; #5; lPC <= 1; end
		jrState:	begin rd <= 1; RegSel <= 2; fnSel <= 1;#5; lPC <= 1; end
		endcase
	end
endmodule


module datapath(
		output Dc,
		output [6:0] IRControl,
		output [15:0] Abus,
		inout [15:0] Dbus,
		//inout [15:0] chk,
		input rd, wr, lPC, TPC, LT, TT, LMAR, TMAR, LIR, RMDRExt, RMDRInt, TMDR2X, TMDR2Ext, TMDR2IR, LMDR, LregY, T1, Lflag, PCrst,
		input [1:0] fnSel,
		input [1:0] RegSel);

	wire [15:0] DbusOut;// Dbus10;
	wire [15:0] Xbus, Zbus, y, irOut, irIn, mdrIn, mdrOut, marOut, tOut, pcOut;
	//reg [15:0] irOut;
  wire [2:0] pa, wPa, rb, rx, rdst, aluSel, alusel1;
	wire c_n, c_n_1,rst;
	wire LIR;
	assign rb[0] = irOut[6];
	assign rb[1] = irOut[7];
	assign rb[2] = irOut[8];
	
	assign rx[0] = irOut[3];
	assign rx[1] = irOut[4];
	assign rx[2] = irOut[5];
	
	assign rdst[0] = irOut[0];
	assign rdst[1] = irOut[1];
	assign rdst[2] = irOut[2];
	
	assign wPa[0] = irOut[0];
	assign wPa[1] = irOut[1];
	assign wPa[2] = irOut[2];
	
	// IR, MDR, MAR- memModry 
	reg16 ir(irOut, Dbus, LIR, rst),
					mdr(mdrOut, mdrIn, LMDR, rst),
					mar(marOut, Zbus, LMAR, rst);
	genvar fli;
	generate for(fli = 0; fli <= 6; fli = fli + 1)
	begin:loop
		assign IRControl[fli] = irOut[fli+9];
	end
	endgenerate
	
	tristate rmdrext(mdrIn, Dbus, RMDRExt),
						rmdrint(mdrIn, Zbus, RMDRInt),
						tmdr2ext(DbusOut, mdrOut, TMDR2Ext),
						tmdr2x(Xbus, mdrOut, TMDR2X),
						tmar(Abus, marOut, TMAR);
	
	assign Dbus = (TMDR2Ext) ? DbusOut : 16'bzzzzzzzzzzzzzzzz;

	reg16 t(tOut, Zbus, LT, rst),
					pc(pcOut, Zbus, lPC, PCrst),
					regy(y, Xbus, LregY, rst);
	tristate tt(Xbus, tOut, TT),
						tpc(Xbus, pcOut, TPC),
						w1(Xbus, 16'b0000000000000001, T1);
	RegBank rgbnk(Xbus, Zbus, pa, wPa, rd, wr);
	mux4to3 muxpa(pa, rb, rx, rdst, , RegSel);
	
	mux4to3 muxfnsel(alusel1, {irOut[14], irOut[13], irOut[12]}, 3'b110, 3'b000, 3'bXXX, fnSel);
  wire n2,n3;
	not(n2, alusel1[1]), (n3, alusel1[0]);
  	wire wSel;
	and(wSel, alusel1[2], n2, n3);	
  mux2to3 muxmns(aluSel, alusel1, 3'b001, wSel);
	alu aluop(Zbus, c_n, c_n_1, Xbus, y, aluSel);
	statusDetect condflag(Dc, Zbus, c_n, c_n_1, Lflag, irOut[12:9]);
	
endmodule
