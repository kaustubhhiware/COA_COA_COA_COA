module half_full_adder(
    input a,
    input b,
    output sum,
    output Cout
    );

assign sum = a^b;
assign Cout = a&b;
endmodule


module full_adder(a,b,Cin,sum, Cout);
	
	input  a,b,Cin;	
	output sum,Cout;
	wire c1,c2,s;
	
	half_full_adder h1(a,b,s,c1);
	half_full_adder h2(s,Cin,sum,c2);
	or o1(Cout,c1,c2);
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
  
full_adder8 add(na,1,b,c);


endmodule


module count_check(rout,out);
  output out;
  wire w;
  input [2:0]rout;
  or o(w,rout[2],rout[1],rout[0]);
  not nl(out,w);
endmodule


module count_decr( in,out
    );
input [2:0] in ;
output [2:0]out;
wire carry;
full_adder8 pp({5'b 00000,in},8'b 11111111 ,out,carry);
	
endmodule



module load_sel(state,ld,sel
    );
input [2:0] state;
output [4:0] ld;
output [4:0] sel;

wire [2:0] nstate;
not n0(nstate[0],state[0]);
not n1(nstate[1],state[1]);
not n2(nstate[2],state[2]);


and a1(ld[0],nstate[1],state[0]);
and a2(ld[1],nstate[2],nstate[1],nstate[0]);
and a3(w1,nstate[2],state[0]);
and a4(w2,state[2],nstate[1],nstate[0]);
or or1(ld[2],w1,w2);
and a5(w3,nstate[2],state[1],nstate[0]);
or or2(ld[3],w3,w2);
and a6(w4,nstate[2],nstate[1],state[0]);
or or3(ld[4],w4,w2);


and aa1( sel[0],state[2],nstate[1],state[0]);
and aa2(sel[1],state[2],nstate[1],nstate[0]);
and aa3(ww1,nstate[2],nstate[1],state[0]);
not nn(sel[2],ww1);
not nn2(sel[4],ww1);
and aa4(sel[3],state[2],nstate[1],nstate[0]);
endmodule




module mux2_1(out,a,b,sel);  
output  out;  
input  a,b,sel;  
  not   not1(sel_, sel); 
  and   and1(a1,  a,  sel);  
  and   and2(b1,  b,  sel_);  
   or   or1(out,  a1,  b1);  
  endmodule 


   module mux4_1(
    output out,
    input [3:0] a,
    input [1:0] sel
    );

wire [1:0] nsel;
wire [7:0] w;
not n0(nsel[0],sel[0]);
not n1(nsel[1],sel[1]);

and a0(w[0],nsel[1],nsel[0],a[0]);
and a1(w[1],nsel[1],sel[0],a[1]);
and a2(w[2],sel[1],nsel[0],a[2]);
and a3(w[3],sel[1],sel[0],a[3]);
or o1(out,w[0],w[1],w[2],w[3]);
endmodule



module mux8_1(
    input [7:0] a,
    input [2:0] sel,
    output out
    );
	 
wire [2:0] nsel;
wire [7:0] w;
not n0(nsel[0],sel[0]);
not n1(nsel[1],sel[1]);
not n2(nsel[2],sel[2]);

and a0(w[0],nsel[2],nsel[1],nsel[0],a[0]);
and a1(w[1],nsel[2],nsel[1],sel[0],a[1]);
and a2(w[2],nsel[2],sel[1],nsel[0],a[2]);
and a3(w[3],nsel[2],sel[1],sel[0],a[3]);
and a4(w[4],sel[2],nsel[1],nsel[0],a[4]);
and a5(w[5],sel[2],nsel[1],sel[0],a[5]);
and a6(w[6],sel[2],sel[1],nsel[0],a[6]);
and a7(w[7],sel[2],sel[1],sel[0],a[7]);
or o1(out,w[0],w[1],w[2],w[3],w[4],w[5],w[6],w[7]);
endmodule


module full_adder8(a,b,sum,carry);
	
	input [7:0] a;
	input [7:0] b;
	wire [6:0]s;
	output [7:0] sum;
	output carry;
	full_adder u0 (a[0],b[0],1'b0,sum[0],s[0]);
	full_adder u1 (a[1],b[1],s[0],sum[1],s[1]);
	full_adder u2 (a[2],b[2],s[1],sum[2],s[2]);
	full_adder u3 (a[3],b[3],s[2],sum[3],s[3]);
	full_adder u4 (a[4],b[4],s[3],sum[4],s[4]);
	full_adder u5 (a[5],b[5],s[4],sum[5],s[5]);
	full_adder u6 (a[6],b[6],s[5],sum[6],s[6]);
	full_adder u7 (a[7],b[7],s[6],sum[7],carry);

endmodule


module next_state(
    input [2:0] state,
    input flag,
    input go,
    output [2:0] nextstate
    );

wire [2:0] nstate;
not n0(nstate[0],state[0]);
not n1(nstate[1],state[1]);
not n2(nstate[2],state[2]);
not n3(ngo,go);
not n4(nflag,flag);




and a1(w1,state[1],state[0]);
and a2(w2,state[2],nstate[1],nstate[0]);
and a3(w3,state[2],nstate[1],flag);
and a4(w4,state[2],nstate[0],go);

or o1(nextstate[2],w1,w2,w3,w4);


and aa1(ww1,state[2],state[0]);
and aa2(ww2,nstate[1],state[0],ngo);
and aa3(ww3,nstate[2],state[1],nstate[0]);
and aa4(ww4,go,nstate[0],state[1]);

or o2(nextstate[1],ww1,ww2,ww3,ww4);


and ab1(wb1,nstate[2],nstate[1],go);
and ab2(wb2,nstate[2],nstate[0],go);
and ab3(wb3,state[2],nstate[0],ngo);
and ab4(wb4,state[2],nstate[1],nflag);

or o3(nextstate[0],wb1,wb2,wb3,wb4);


endmodule


module register(in, out, clk ,load, rst);
 parameter SIZE=16;
 output [SIZE-1:0] out;
 input [SIZE-1:0] in;
 input clk, rst,load;
 reg [SIZE-1:0] out;
 always @(posedge clk)
 	begin
 	if (rst) out <= 0;
 	else if(load) out <= in;
 

 	end
endmodule



module register_n(in, out, clk,rst);
 parameter SIZE=16;
 output [SIZE-1:0] out;
 input [SIZE-1:0] in;
 input clk,rst;
 reg [SIZE-1:0] out;
 always @(negedge clk)
 	begin
 	if (rst) out <= 0;
   else  out <= in;
 

 	end
endmodule



module shr_2( in ,inadd ,out,res
    );
input [7:0] in ;
input [1:0] inadd ;
output [7:0] out ;
output [1:0] res ;
assign res[1] = in[1];
assign res[0] = in[0];

generate
	 	genvar m;
      for(m=0;m<6;m=m+1)  begin:asdas
          assign out[m] = in[m+2];
		end
 assign out[6] = inadd[0];
 assign out[7] = inadd[1];
endgenerate
endmodule





module datapath(ld,sel,clk,sw,rst,flag,display);

input [4:0]ld;
input [4:0]sel;
input clk , rst; 
input [7:0]sw ; 
wire[2:0]  ct ;
wire[2:0]  ctnew;  
wire wc3,wc2,wc1,wc0;
output flag ;
output [15:0] display ;
//output [7:0]z;
//output [7:0]y;
//output [7:0] acc;
wire [2:0] mainsel;

mux2_1 mc2( wc2,ctnew[2],1'b 1,sel[0]);
mux2_1 mc1( wc1,ctnew[1],1'b 0,sel[0]);
mux2_1 mc0( wc0,ctnew[0],1'b 0,sel[0]);

//in, out, clk ,load, rst
register cnt({wc2,wc1,wc0} , ct , clk , ld[0] , rst);
count_decr dec1(ct,ctnew) ;
count_check ck ( ct , flag );


wire [7:0] md;
wire [7:0] nmd;
wire [7:0] c2md;


register multiplicand(sw,md,clk,ld[1] , rst);
comp2s c1 (md,nmd);
register compmd(nmd,c2md,clk,1'b 1 , rst);


wire [7:0]z ;
wire [7:0]newacc ;
wire [7:0]acc ;
wire [7:0]macc ;
wire [7:0]mmp ;
wire [7:0]mp;
wire [7:0]newmp;
wire [1:0]transshr ;
wire [1:0]lasttwo ;


mux4_1 muxacc7 (macc[7] ,{newacc[7], z[7],1'b 0,1'b 0}, sel[2:1]);
mux4_1 muxacc6 (macc[6] ,{newacc[6], z[6],1'b 0,1'b 0}, sel[2:1]);
mux4_1 muxacc5 (macc[5] ,{newacc[5], z[5],1'b 0,1'b 0}, sel[2:1]);
mux4_1 muxacc4 (macc[4] ,{newacc[4], z[4],1'b 0,1'b 0}, sel[2:1]);
mux4_1 muxacc3 (macc[3] ,{newacc[3], z[3],1'b 0,1'b 0}, sel[2:1]);
mux4_1 muxacc2 (macc[2] ,{newacc[2], z[2],1'b 0,1'b 0}, sel[2:1]);
mux4_1 muxacc1 (macc[1] ,{newacc[1], z[1],1'b 0,1'b 0}, sel[2:1]);
mux4_1 muxacc0 (macc[0] ,{newacc[0], z[0],1'b 0,1'b 0}, sel[2:1]);
register regacc(macc , acc , clk , ld[2] , rst);


mux2_1 muxmp7 (mmp[7] ,newmp[7], sw[7], sel[3]);
mux2_1 muxmp6 (mmp[6] ,newmp[6], sw[6], sel[3]);
mux2_1 muxmp5 (mmp[5] ,newmp[5], sw[5], sel[3]);
mux2_1 muxmp4 (mmp[4] ,newmp[4], sw[4], sel[3]);
mux2_1 muxmp3 (mmp[3] ,newmp[3], sw[3], sel[3]);
mux2_1 muxmp2 (mmp[2] ,newmp[2], sw[2], sel[3]);
mux2_1 muxmp1 (mmp[1] ,newmp[1], sw[1], sel[3]);
mux2_1 muxmp0 (mmp[0] ,newmp[0], sw[0], sel[3]);
register regmp(mmp , mp , clk , ld[3] , rst);


shr_2 shracc(acc,{acc[7],acc[7]},newacc , transshr);
shr_2 shrmp(mp,transshr,newmp , lasttwo);


wire [7:0]y;
wire carry;
wire lb;
wire lastbit ; 

mux2_1 reglbit(lb,lasttwo[1],1'b 0 , sel[4]);
register #(1) lbit(lb,lastbit,clk,ld[4],rst);

assign mainsel = {mp[1],mp[0],lastbit};

mux8_1 mainmux0({1'b 0 , c2md[0],c2md[0] ,1'b0 , 1'b 0 , md[0] , md[0], 1'b0 },mainsel,y[0] );
mux8_1 mainmux1({1'b 0 , c2md[1],c2md[1] ,c2md[0] , md[0] , md[1] , md[1], 1'b0 },mainsel,y[1] );
mux8_1 mainmux2({1'b 0 , c2md[2],c2md[2] ,c2md[1] , md[1] , md[2] , md[2], 1'b0 },mainsel,y[2] );
mux8_1 mainmux3({1'b 0 , c2md[3],c2md[3] ,c2md[2] , md[2] , md[3] , md[3], 1'b0 },mainsel,y[3] );
mux8_1 mainmux4({1'b 0 , c2md[4],c2md[4] ,c2md[3] , md[3] , md[4] , md[4], 1'b0 },mainsel,y[4] );
mux8_1 mainmux5({1'b 0 , c2md[5],c2md[5] ,c2md[4] , md[4] , md[5] , md[5], 1'b0 },mainsel,y[5] );
mux8_1 mainmux6({1'b 0 , c2md[6],c2md[6] ,c2md[5] , md[5] , md[6] , md[6], 1'b0 },mainsel,y[6] );
mux8_1 mainmux7({1'b 0 , c2md[7],c2md[7] ,c2md[6] , md[6] , md[7] , md[7], 1'b0 },mainsel,y[7] );

full_adder8 alu(acc,y,z,carry);

assign display = {acc,mp};
endmodule






module controller(go,flag,ld,sel,state,clk,rst);
input go,flag,clk,rst;
output [4:0] ld ;
output [4:0]sel;
output [2:0] state;
wire[2:0] state;
wire [2:0] nextstate;


register_n #(3)r1(nextstate,state,clk,rst);

next_state nxt(state,flag,go,nextstate);
load_sel ls(state,ld,sel);

endmodule


module radix4booth(sw,go,clk,rst,display,state);

input [7:0] sw;
input clk , rst,go;
output [15:0] display;
wire [4:0] ld;
wire [4:0] sel;
wire flag;
output [2:0]state;
datapath dp(ld,sel,clk,sw,rst,flag,display);
controller cont(go,flag,ld,sel,state,clk,rst);

endmodule




module datatest;

	// Inputs
	reg [4:0] ld;
	reg [4:0] sel;
	reg clk;
	reg [7:0] sw;
	reg rst;

	// Outputs
	wire flag;
	wire [15:0] display;

	// Instantiate the Unit Under Test (UUT)
	datapath uut (
		.ld(ld), 
		.sel(sel), 
		.clk(clk), 
		.sw(sw), 
		.rst(rst), 
		.flag(flag), 
		.display(display)
	);

  always #10 clk = ~clk ;

	initial begin
		// Initialize Inputs
		ld = 5'b 10010;
		sel = 5'b 10011;
		clk = 0;
		sw = 4;
		rst = 0;
      #10;
        
		ld = 5'b 10010;
		sel = 5'b 10011;
		clk = 0;
		sw = 3;
		rst = 0;
      #10;
      
		ld = 5'b 10010;
		sel = 5'b 10011;
		clk = 0;
		sw = 5;
		rst = 0;
      #10;
      // Add stimulus here

	end
      
endmodule


module radixtest;

	// Inputs
	reg [7:0] sw;
	reg go;
	reg clk;
	reg rst;

	// Outputs
	wire [15:0] display;
	wire [2:0] state;
	
	// Instantiate the Unit Under Test (UUT)
	radix4booth uut (
		.sw(sw), 
		.go(go), 
		.clk(clk), 
		.rst(rst), 
		.display(display), 
		.state(state)	
	);

  always #10 clk = ~clk;
	initial begin
		// Initialize Inputs
		sw = 68;
		go = 1;
		clk = 1;
		rst = 1;

		#10;
      
		sw =68;
		go = 1;
		rst = 1;

		#10;
		
		sw = 68;
		go = 1;
		rst = 0;

		#10;
		sw = 68;
		go = 1;
		rst = 0;

		#10;
		sw = 68;
		go = 1;
		rst = 0;

		#10;
		sw = 68;
		go = 1;
		rst = 0;

		#10;
		sw = 68;
		go = 1;
		rst = 0;

		#10;
		sw = 68;
		go = 1;
		rst = 0;

		#10;
		

		sw =68;
		go = 0;
		rst = 0;

		#10;

		sw = 35;
		go = 0;
		rst = 0;

		#10;

		sw = 35;
		go = 1;
		rst = 0;

		#10;

		sw = 35;
		go = 1;
		rst = 0;

		#10;

		// Add stimulus here

	end
      
endmodule


module cont_check;

	// Inputs
	reg go;
	reg flag;
	reg clk;
	reg rst;

	// Outputs
	wire [4:0] ld;
	wire [4:0] sel;
	wire [2:0] state;

	// Instantiate the Unit Under Test (UUT)
	controller uut (
		.go(go), 
		.flag(flag), 
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
		go = 1;
		flag = 0;
		rst=1;
		#10;
		go = 1;
		flag = 0;
		rst=1;
		#10;
		go = 1;
		flag = 0;
		rst=1;
		#10;
		go = 1;
		flag = 0;
		rst=1;
		#10;
		
			rst=0;
			go = 1;
		flag = 0;
		#10;
			go = 1;
		flag = 0;
		#10;
		go = 1;
		flag = 0;
		#10;
		go = 1;
		flag = 0;
		#10;
			go = 0;
		flag = 0;
		#10;
			go = 0;
		flag = 0;
		#10;
			go = 1;
		flag = 0;
		#10;	
		go = 1;
		flag = 0;
		#10;
       	go = 1;
		flag = 0;
		#10;	go = 1;
		flag = 0;
		#10;	go = 1;
		flag = 0;
		#10;	go = 0;
		flag = 0;
		#10;	go = 0;
		flag = 0;
		#10;	go = 0;
		flag = 0;
		#10; 
		
			go = 0;
		flag = 0;
		#10;	go = 0;
		flag = 0;
		#10;	go = 0;
		flag = 0;
		#10;	go = 0;
		flag = 0;
		#10;	go = 0;
		flag = 0;
		#10;	go = 0;
		flag = 0;
		#10;	go = 0;
		flag = 0;
		#10;	go = 0;
		flag = 0;
			go = 0;
		flag = 0;
		#10;	go = 0;
		flag = 0;
		#10;	go = 0;
		flag = 0;
		#10;
		#10;	go = 0;
		flag = 1;
		#10;	go = 0;
		flag = 1;
		#10;
		// Add stimulus here

	end
      
endmodule

