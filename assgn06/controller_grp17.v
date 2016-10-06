module register(in, out, clk ,load, rst);

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


module reg_noload(in, out, clk,rst);
 output [15:0] out;
 input [15:0] in;
 input clk,rst;
 reg [15:0] out;
 always @(negedge clk)
 	begin
 	if (rst) out <= 0;
   else  out <= in;
 	end
endmodule

module mux2(out,a,b,sel);  
output  out;  
input  a,b,sel;  
  not   not1(sel_, sel); 
  and   and1(a1,  a,  sel);  
  and   and2(b1,  b,  sel_);  
   or   or1(out,  a1,  b1);  
  endmodule 


module mux4(
    output out,
    input [3:0] a,
    input [1:0] sel);

wire [1:0] notsel;
wire [7:0] w;
not n0(notsel[0],sel[0]);
not n1(notsel[1],sel[1]);

and a0(w[0],notsel[1],notsel[0],a[0]);and a1(w[1],notsel[1],sel[0],a[1]);
and a2(w[2],sel[1],notsel[0],a[2]);and a3(w[3],sel[1],sel[0],a[3]);
or o1(out,w[0],w[1],w[2],w[3]);
endmodule


module mux8(
    input [7:0] a,
    input [2:0] sel,
    output out);	 
	 
wire [2:0] notsel;
wire [7:0] w;
not n0(notsel[0],sel[0]);
not n1(notsel[1],sel[1]);
not n2(notsel[2],sel[2]);

and a0(w[0],notsel[2],notsel[1],notsel[0],a[0]);and a1(w[1],notsel[2],notsel[1],sel[0],a[1]);
and a2(w[2],notsel[2],sel[1],notsel[0],a[2]);and a3(w[3],notsel[2],sel[1],sel[0],a[3]);
and a4(w[4],sel[2],notsel[1],notsel[0],a[4]);and a5(w[5],sel[2],notsel[1],sel[0],a[5]);
and a6(w[6],sel[2],sel[1],notsel[0],a[6]);and a7(w[7],sel[2],sel[1],sel[0],a[7]);
or o1(out,w[0],w[1],w[2],w[3],w[4],w[5],w[6],w[7]);
endmodule

module count_check(rout,out);
  output out;
  wire w;
  input [2:0]rout;
  or o(w,rout[2],rout[1],rout[0]);
  not nl(out,w);
endmodule

module half_adder(input a,input b,output sum,output Cout);

assign sum = a^b;
assign Cout = a&b;
endmodule

module full_adder(a,b,Cin,sum, Cout);
	
	input  a,b,Cin;	
	output sum,Cout;
	wire c1,c2,s;
	
	half_adder h1(a,b,s,c1);
	half_adder h2(s,Cin,sum,c2);
	or o1(Cout,c1,c2);
endmodule

module loadselect(state,ld,sel);
input [2:0] state;
output [4:0] ld;
output [4:0] sel;
wire [2:0] notstate;

not n0(notstate[0],state[0]);
not n1(notstate[1],state[1]);
not n2(notstate[2],state[2]);


and a1(ld[0],notstate[1],state[0]);and a2(ld[1],notstate[2],notstate[1],notstate[0]);
and a3(w1,notstate[2],state[0]);and a4(w2,state[2],notstate[1],notstate[0]);
or or1(ld[2],w1,w2);
 
and a5(w3,notstate[2],state[1],notstate[0]);
or or2(ld[3],w3,w2);

and a6(w4,notstate[2],notstate[1],state[0]);
or or3(ld[4],w4,w2);

and aa1( sel[0],state[2],notstate[1],state[0]);
and aa2(sel[1],state[2],notstate[1],notstate[0]);
and aa3(ww1,notstate[2],notstate[1],state[0]);
not nn(sel[2],ww1);
not nn2(sel[4],ww1);
and aa4(sel[3],state[2],notstate[1],notstate[0]);
endmodule


module adder8(a,b,sum,Cout);
	input [7:0] a;
	input [7:0] b;
	wire [6:0]s;
	output [7:0] sum;
	output Cout;
	
	full_adder u0 (a[0],b[0],1'b0,sum[0],s[0]);
	full_adder u1 (a[1],b[1],s[0],sum[1],s[1]);
	full_adder u2 (a[2],b[2],s[1],sum[2],s[2]);
	full_adder u3 (a[3],b[3],s[2],sum[3],s[3]);
	full_adder u4 (a[4],b[4],s[3],sum[4],s[4]);
	full_adder u5 (a[5],b[5],s[4],sum[5],s[5]);
	full_adder u6 (a[6],b[6],s[5],sum[6],s[6]);
	full_adder u7 (a[7],b[7],s[6],sum[7],Cout);

endmodule



module decrement_count( in,out);
	input [2:0] in ;
	output [2:0]out;
	wire carry;
	
	adder8 pp({5'b 00000,in},8'b 11111111 ,out,carry);
endmodule

module comp2s(
    input [7:0] a,
    output [7:0] b
    );
wire [7:0] na;
wire c;
generate 
    genvar k;
    for(k=0;k<8;k=k+1)
    begin:loop1
      not n(na[k],a[k]);
    end
  endgenerate
adder8 add(na,1,b,c);
endmodule

module next_state(
    input [2:0] state,
    input eqz,
    input Go,
    output [2:0] goto_state);

wire [2:0] notstate;
not n0(notstate[0],state[0]);
not n1(notstate[1],state[1]);
not n2(notstate[2],state[2]);
not n3(ngo,Go);
not n4(noteqz,eqz);

and a1(w1,state[1],state[0]);and a2(w2,state[2],notstate[1],notstate[0]);
and a3(w3,state[2],notstate[1],eqz);and a4(w4,state[2],notstate[0],Go);
or o1(goto_state[2],w1,w2,w3,w4);

and aa1(ww1,state[2],state[0]);and aa2(ww2,notstate[1],state[0],ngo);
and aa3(ww3,notstate[2],state[1],notstate[0]);and aa4(ww4,Go,notstate[0],state[1]);
or o2(goto_state[1],ww1,ww2,ww3,ww4);

and ab1(wb1,notstate[2],notstate[1],Go);and ab2(wb2,notstate[2],notstate[0],Go);
and ab3(wb3,state[2],notstate[0],ngo);and ab4(wb4,state[2],notstate[1],noteqz);
or o3(goto_state[0],wb1,wb2,wb3,wb4);

endmodule

module controller(Go,eqz,ld,sel,state,clk,rst);
input Go,eqz,clk,rst;
output [4:0] ld ;
output [4:0]sel;
output [2:0] state;
wire[2:0] state;
wire [2:0] goto_state;

reg_noload #(3)r1(goto_state,state,clk,rst);

next_state nxt(state,eqz,Go,goto_state);
loadselect ls(state,ld,sel);

endmodule

module test_controller;

	// Inputs
	reg Go;
	reg eqz;
	reg clk;
	reg rst;

	// Outputs
	wire [4:0] ld;
	wire [4:0] sel;
	wire [2:0] state;

	// Instantiate the Unit Under Test (UUT)
	controller uut (
		.Go(Go), 
		.eqz(eqz), 
		.ld(ld), 
		.sel(sel), 
		.state(state), 
		.clk(clk),
		.rst(rst)
	);
always #10 clk = ~clk;

	initial begin
		// Initialize Inputs
		
	clk=0;	
		Go = 1;
		eqz = 0;
		rst=1;

		#40;
		Go = 1;
		eqz = 0;
		rst=0;
		
		#40;
		Go = 0;
		eqz = 0;

		#20;
		Go = 1;
		eqz = 0;

		#50;
		Go = 0;
		eqz = 0;

		#140;	
		Go = 0;
		eqz = 1;
		
		#20;
	end
endmodule
