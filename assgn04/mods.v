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
