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


module shiftRightby2( in ,in2 ,out,res);
input [7:0] in ;
input [1:0] in2 ;
output [7:0] out ;
output [1:0] res ;
assign res[1] = in[1];
assign res[0] = in[0];

generate
	 	genvar m;
      for(m=0;m<6;m=m+1)  begin:loop2
          assign out[m] = in[m+2];
		end
 assign out[6] = in2[0];
 assign out[7] = in2[1];
endgenerate
endmodule

module datapath(ld,sel,clk,inputnum,rst,eqz,result);

input [4:0]ld;
input [4:0]sel;
input clk , rst; 
input [7:0]inputnum ; 
wire[2:0]  ct ;
wire[2:0]  ctnew;  
wire wc3,wc2,wc1,wc0;
output eqz ;
output [15:0] result ;

wire [2:0] select;

mux2 m2( wc2,ctnew[2],1'b 1,sel[0]);
mux2 m1( wc1,ctnew[1],1'b 0,sel[0]);
mux2 m0( wc0,ctnew[0],1'b 0,sel[0]);

register cnt({wc2,wc1,wc0} , ct , clk , ld[0] , rst);
decrement_count dec1(ct,ctnew) ;
count_check ck ( ct , eqz );

wire [7:0] md;
wire [7:0] nmd;
wire [7:0] c2md;

register Mcandreg(inputnum,md,clk,ld[1] , rst);
comp2s c1 (md,nmd);
register compmd(nmd,c2md,clk,1'b 1 , rst);

wire [7:0]z ;
wire [7:0]nAcc ;
wire [7:0]acc ;
wire [7:0]mAcc ;
wire [7:0]mmp ;
wire [7:0]Mpand;
wire [7:0]newMpand;
wire [1:0]transshr ;
wire [1:0]end2 ;

mux4 muxA7 (mAcc[7] ,{nAcc[7], z[7],1'b 0,1'b 0}, sel[2:1]);
mux4 muxA6 (mAcc[6] ,{nAcc[6], z[6],1'b 0,1'b 0}, sel[2:1]);
mux4 muxA5 (mAcc[5] ,{nAcc[5], z[5],1'b 0,1'b 0}, sel[2:1]);
mux4 muxA4 (mAcc[4] ,{nAcc[4], z[4],1'b 0,1'b 0}, sel[2:1]);
mux4 muxA3 (mAcc[3] ,{nAcc[3], z[3],1'b 0,1'b 0}, sel[2:1]);
mux4 muxA2 (mAcc[2] ,{nAcc[2], z[2],1'b 0,1'b 0}, sel[2:1]);
mux4 muxA1 (mAcc[1] ,{nAcc[1], z[1],1'b 0,1'b 0}, sel[2:1]);
mux4 muxA0 (mAcc[0] ,{nAcc[0], z[0],1'b 0,1'b 0}, sel[2:1]);
register rAcc(mAcc , acc , clk , ld[2] , rst);


mux2 muxMpand7 (mmp[7] ,newMpand[7], inputnum[7], sel[3]);
mux2 muxMpand6 (mmp[6] ,newMpand[6], inputnum[6], sel[3]);
mux2 muxMpand5 (mmp[5] ,newMpand[5], inputnum[5], sel[3]);
mux2 muxMpand4 (mmp[4] ,newMpand[4], inputnum[4], sel[3]);
mux2 muxMpand3 (mmp[3] ,newMpand[3], inputnum[3], sel[3]);
mux2 muxMpand2 (mmp[2] ,newMpand[2], inputnum[2], sel[3]);
mux2 muxMpand1 (mmp[1] ,newMpand[1], inputnum[1], sel[3]);
mux2 muxMpand0 (mmp[0] ,newMpand[0], inputnum[0], sel[3]);
register regMpand(mmp , Mpand , clk , ld[3] , rst);

shiftRightby2 shracc(acc,{acc[7],acc[7]},nAcc , transshr);
shiftRightby2 shrMpand(Mpand,transshr,newMpand , end2);

wire [7:0]y;
wire carry;
wire lb;
wire lastbit ; 

mux2 reglbit(lb,end2[1],1'b 0 , sel[4]);
register #(1) lbit(lb,lastbit,clk,ld[4],rst);

assign select = {Mpand[1],Mpand[0],lastbit};

mux8 outMux0({1'b 0 , c2md[0],c2md[0] ,1'b0 , 1'b 0 , md[0] , md[0], 1'b0 },select,y[0] );
mux8 outMux1({1'b 0 , c2md[1],c2md[1] ,c2md[0] , md[0] , md[1] , md[1], 1'b0 },select,y[1] );
mux8 outMux2({1'b 0 , c2md[2],c2md[2] ,c2md[1] , md[1] , md[2] , md[2], 1'b0 },select,y[2] );
mux8 outMux3({1'b 0 , c2md[3],c2md[3] ,c2md[2] , md[2] , md[3] , md[3], 1'b0 },select,y[3] );
mux8 outMux4({1'b 0 , c2md[4],c2md[4] ,c2md[3] , md[3] , md[4] , md[4], 1'b0 },select,y[4] );
mux8 outMux5({1'b 0 , c2md[5],c2md[5] ,c2md[4] , md[4] , md[5] , md[5], 1'b0 },select,y[5] );
mux8 outMux6({1'b 0 , c2md[6],c2md[6] ,c2md[5] , md[5] , md[6] , md[6], 1'b0 },select,y[6] );
mux8 outMux7({1'b 0 , c2md[7],c2md[7] ,c2md[6] , md[6] , md[7] , md[7], 1'b0 },select,y[7] );

adder8 alu(acc,y,z,carry);

assign result = {acc,Mpand};
endmodule

module test_datapath;

	// Inputs
	reg [4:0] ld;
	reg [4:0] sel;
	reg clk;
	reg [7:0] inputnum;
	reg rst;

	// Outputs
	wire eqz;
	wire [15:0] result;

	// Instantiate the Unit Under Test (UUT)
	datapath uut (
		.ld(ld), 
		.sel(sel), 
		.clk(clk), 
		.inputnum(inputnum),
		.rst(rst), 
		.eqz(eqz), 
		.result(result)
	);

  always #10 clk = ~clk ;

	initial begin
		// Initialize Inputs
		ld = 5'b 10010;
		sel = 5'b 10011;
		clk = 0;
		inputnum = 4;
		rst = 0;
      #10;
        
		ld = 5'b 10010;
		sel = 5'b 10011;
		clk = 0;
		inputnum = 3;
		rst = 0;
      #10;
      
		ld = 5'b 10010;
		sel = 5'b 10011;
		clk = 0;
		inputnum = 5;
		rst = 0;
      #10;
      // Add stimulus here

	end
      
endmodule


