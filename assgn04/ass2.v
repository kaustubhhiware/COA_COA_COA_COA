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

module reg17(in,out,clk,rst,load,sel);

	input [16:0]in;
	input clk,rst;
	input load;
	input [2:0]sel;
	output [16:0]out;
	
	reg [16:0]out;
	
	always @(posedge clk or posedge rst)
	begin
		if(rst==1)
			out=0;
		else if(load==1)
			begin
			out=in;
		case(sel)
			3'b000: //same
				out=out;
			3'b001:
				out=out+1; //increment by 1
			3'b010:
				out=out+2; // increment by 2
			3'b011:
				out=out-1; //decrement by 1
			3'b100:
				out=out-2; //decrement by 2
			3'b101:
				out=out>>2; //shift right by 2
			3'b110:
				out=out<<1; //shift left by 1
		endcase
		end
	end
endmodule

module reg8(in,out,clk,rst,load,sel);

	input [7:0]in;
	input clk,rst;
	input load;
	input [2:0]sel;
	output [7:0]out;
	
	reg [7:0]out;
	
	always @(posedge clk or posedge rst)
	begin
		if(rst==1)
			out=0;
		else if(load==1)
		begin
			out=in;
		
		case(sel)
		3'b000:
				out=out;
			3'b001:
				out=out+1;
			3'b010:
				out=out+2;
			3'b011:
				out=out-1;
			3'b100:
				out=out-2;
			3'b101:
				out=out>>2;
			3'b110:
				out=out<<1;
		endcase
		end
	end
endmodule

module trstate17(in,enable,out);
	input [16:0]in;
	input enable;
	output [16:0]out;
	reg [16:0]out;
	always@(enable)
	begin
		if(enable==1)
			out=in;
		else
			out=17'bzzzzzzzzzzzzzzzzz;
	end
endmodule


//tristate for 8 bit bus
module trstate8(in,enable,out);
	input [7:0]in;
	input enable;
	output [7:0]out;
	reg [7:0]out;
	
	always@(enable)
	begin
		if(enable==1)
			out=in;
		else
			out=8'bzzzzzzzz;
	end
endmodule

`timescale 1ns / 1ps
	
module subt(output Bo,output eqz,output [16:0] S,
	output Cout,
	input [16:0] A,
	input [7:0] B);
	wire carry;
	//add adddneg(S,Cout,A,~B,1'b1);
	wire [16:0] B2;
	assign B2[7:0] = B;
	assign B2[16:8] = 9'b000000000;
	wire Cin = 1'b1;
	wire [16:0]A;
	wire [7:0]B;
	reg Bo,eqz,Cout;
	//reg [16:0] S;
		always@(*) begin
		assign Bo = (A<B);
		assign eqz = (A==B);
		//Cout<=0;
	end
	rca_8bit c1(S[7:0],carry,A[7:0],~B2[7:0],Cin);
	rca_8bit c2(S[15:8],Cout,A[15:8],~B2[15:8],carry);
	or(S[16],A[16],B2[16]);
	/*if(A[0]==B[0]&&A[1]==B[1]&&A[2]==B[2]&&A[3]==B[3]
		&&A[4]==B[4]&&A[5]==B[5]&&A[6]==B[6]&&A[7]==B[7]
		&&A[8]==A[9]==A[10]==A[11]==A[12]==A[13]==A[14]==A[15]==A[16]==0
	)begin
		assign eqz = 1;
	end*/
	and (Cout,A[16],B2[16]);
	wire [16:0] S2;wire ct;

	not(S2[0],S[0]);not(S2[1],S[1]);not(S2[2],S[2]);not(S2[3],S[3]);
	not(S2[4],S[4]);not(S2[5],S[5]);not(S2[6],S[6]);not(S2[7],S[7]);
	not(S2[8],S[8]);not(S2[9],S[9]);not(S2[10],S[10]);not(S2[11],S[11]);
	not(S2[12],S[12]);not(S2[13],S[13]);not(S2[14],S[14]);not(S2[15],S[15]);not(S2[16],S[16]);
	adder17 aw(S2,ct,S2,17'b00000000000000001);
	reg [16:0] gg,gh;
	adder17 aw2(gg,ct,gh,17'b00000000000000000);
	always@(~Cout)begin
			//assign Bo=1;
			//S=S2;//
			assign gg=S;assign gh=S2;//adder17 aw(S2,ct,S2,17'b00000000000000001);
	//and(S[0],S2[0],1'b1);
	/*or(S[1],S2[1],1'b0);or(S[2],S2[2],1'b0);or(S[3],S2[3],1'b0);
	or(S[4],S2[4],1'b0);or(S[5],S2[5],1'b0);or(S[6],S2[6],1'b0);or(S[7],S2[7],1'b0);
	or(S[8],S2[8],1'b0);or(S[9],S2[9],1'b0);or(S[10],S2[10],1'b0);or(S[11],S2[11],1'b0);
	or(S[12],S2[12],1'b0);or(S[13],S2[13],1'b0);or(S[14],S2[14],1'b0);or(S[15],S2[15],1'b0);or(S[16],S2[16],1'b0);	
	*/end
endmodule

module adder17(output [16:0] S,
	output Cout,
	input [16:0] A,
	input [16:0]B);
	wire [16:0] op;

wire carry,c2;
wire Cin = 0;

rca_8bit cl1(S[7:0],carry,A[7:0],B[7:0],Cin);
rca_8bit cl2(S[15:8],c2,A[15:8],B[15:8],carry);
	//S[16] = A[16] or Cout;
	or(S[16],A[16],B[16],c2);
	wire p,q,r;
	and(p,A[16],B[16]);and(q,A[16],c2);and(r,B[16],c2);
	or(Cout,p,q,r);
//	S = {A[16],op};
endmodule


module add(output [16:0] S, 
	output Cout,
	input [16:0] A,
	input [7:0]B);

wire carr;
wire Cin = 0;
rca_8bit c1(S[7:0],carry,A[7:0],B,Cin);
rca_8bit c2(S[15:8],Cout,A[15:8],8'b00000000,carry);
	//S[16] = A[16] or Cout;
	or(S[16],A[16],Cout);
//	S = {A[16],op};
endmodule


module rca_8bit(output [7:0] S,
    output Cout,
    input [7:0] A,B,
    input Cin);
	 
wire carry;
rca_4bit c1(S[3:0],carry,A[3:0],B[3:0],Cin);
rca_4bit c2(S[7:4],Cout,A[7:4],B[7:4],carry);

endmodule

module half_adder (a, b, sum, carry);
	input  a;
	input  b;
	output sum;
	output carry;
	assign sum = a^b;
	assign carry = a&b;
endmodule


module full_adder(a, b, c_in, sum,c_out);
	input  a;
	input  b;
	input  c_in;
	output sum;
	output c_out;
	wire w_sum1;
	wire w_carry1;
	wire w_carry2;
	assign c_out = w_carry1 | w_carry2;

	half_adder u1_half_adder
	(
	.a(a),
	.b(b),
	.sum(w_sum1),
	.carry(w_carry1)
	);                    
	half_adder u2_half_adder
	(
	.a(w_sum1),
	.b(c_in),
	.sum(sum),
	.carry(w_carry2)
	);               
endmodule

module rca_4bit(sum, cout,a, b, cin);

input [3:0] a;
input [3:0] b;
input cin;

output [3:0]sum;
output cout;

wire[2:0] c;

full_adder a1(a[0],b[0],cin,sum[0],c[0]);

//assign sum[0] = sum[0] - 1;//this is for diff

full_adder a2(a[1],b[1],c[0],sum[1],c[1]);
full_adder a3(a[2],b[2],c[1],sum[2],c[2]);
full_adder a4(a[3],b[3],c[2],sum[3],cout);

endmodule

module cla_4bit(
    output [3:0] S,
    output Cout,
    input [3:0] A,B,
    input Cin
    );
  wire [3:0] G,P,C;
 
    assign G = A & B; //Generate
    assign P = A ^ B; //Propagate
	 
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
    assign C[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) |             (P[2] & P[1] & P[0] & C[0]);
    assign Cout = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) |(P[3] & P[2] & P[1] & P[0] & C[0]);
    assign S = P ^ C;

endmodule




//alu
module alu(X,Y,func_sel,clk,rst,Bo,eqz,Z);
	input [16:0]X;
	input [7:0]Y;
	input clk,rst;
	input [3:0]func_sel;
	output [16:0]Z;

	output Bo,eqz;
	reg [16:0] Z;
	reg Bo,eqz;
	
	always@(posedge clk or  rst)
	begin
		if(func_sel==0)
			Z=X+Y;
		else if(func_sel==1)
			Z=X-Y;
		else if(func_sel==2)
			Z=X+2*Y;
		else if(func_sel==3)
			Z=X-2*Y;
	end
endmodule

//MUX to control whether the Y becomes 2Y or Y
module mux2(X,Y,sel,out);
	input X;
	input Y;
	input [3:0]sel;
	output out;
	
	reg out;
	
	always@(sel or X or Y)
	begin
			if(sel==0 || sel==1)
					out=X;
			else
					out=Y;
	end
endmodule


//shift left module
module shiftleft(X,Y);
	input [7:0]X;
	output [7:0]Y;
	wire [7:0]Y;
	
	assign Y[7:1]=X[6:0];
	assign Y[0]=0;
	//Y[0]=0;
endmodule

//shift right by 2 bits
module shiftrightby2(X,Y);
	input [7:0]X;
	output [7:0]Y;
	wire [7:0]Y;
	
	assign Y[5:0]=X[7:2];
	assign Y[7]=X[7];
	assign Y[6]=X[7];
	
endmodule

//not complete
module datapath(Mcand,Mplier,ldP,selP,func_sel,ldMcand,selMcand,count,
	ldMplier,selMplier,ldCount,trP,trMcand,trMplier,outMplier,countsignal,Bo,eqz,clk,rst);

	input ldP,ldMcand,ldMplier,ldCount;
	input [8:0]Mcand;
	input [8:0]Mplier;
	input [3:0]selP ;
	input [3:0]func_sel;
	
	output Bo,eqz;
	output [8:0]count;
	output countsignal;
	output [7:0] outMplier;
	//reg17(in,out,clk,rst,load,sel)
	
	wire [17:0]Zbus;
	wire	[8:0]Ybus;
   wire [17:0]XBus;
	
	wire [17:0]regPwire;
	wire [8:0] regMcandwire;
	wire [8:0] regMplierwire;
	wire [8:0] regCountwire;
	
	reg17 regP(Zbus,regPwire,clk,rst,ldP,selP);
	//module trstate17(in,enable,out);
	tristate17 tristateP(regPwire,Xbus,trP);
	
	
	reg8 regMcand(Mcand,regMcandwire,clk,rst,ldMcand,selMcand);
	tristate8 tristateMcand(regMcandwire,Ybus,trMcand);

	reg8 regMplier(Mplier,regMplierwire,clk,rst,ldMplier,trMplier);
	tristate8 tristateMplier(regMplierwire,Ybus,trMplier);
	
	reg8  regCount(Zbus,regCountwire,clk,rst,ldCount,selCount);
	tristate8 tristateCount(regCountwire,Ybus,trCount);
	
	assign countsignal=count[0] || count[1] || count[2] || count[3] || count[4] || count[5] || count[6] || count[7];
	
	
endmodule
	
//test benches
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


