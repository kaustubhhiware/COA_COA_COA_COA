module is5(in1,in2,in3,out);
 input in1,in2,in3;
  wire notin1,notin3;
 output out;
  not (notin2,in2);
  not (notin1,in1);
  nor(out,nin1,nin2,in3);
endmodule


module DFF(in,out,clk,rst);
  output out;
  input in,clk,rst;
  reg out;
  always@(posedge clk or rst)
	begin
		if(rst)
		begin
			out<=0;
		end
		else 
		begin
			out<=in;
		end
		
  	end
endmodule

module count(rst,clk,q2,q1,q0);
  output q2,q1,q0;
  input clk,rst;
  not(nq0,q0);
  not(nq1,q1);
  and(D21,q0,q1);
  or(D2,D21,q2);
  xor(D1,q1,q0);
  not(D0,q0);
  DFF d1(D0,q0,clk,rst);
  DFF d2(D1,q1,clk,rst);
  DFF d3(D2,q2,clk,rst);
endmodule

module count1(rst,clk,q2,q1,q0);
 output q0,q1,q2;
  input clk,rst;
  not(nq0,q0);
  not(nq1,q1);
  not(nq2,q2);
  and a1(D21,q1,q0);
  and a2(D22,q2,nq0);
  or(D2,D21,D22);
  and(D11,q1,nq0);
  and(D12,nq2,nq1,q0);
  or(D1,D11,D12);
  and(D01,nq0,nq1);
  and(D02,nq2,nq0);
  or(D0,D01,D02);
  DFF d1(D0,q0,clk,rst);
  DFF d2(D1,q1,clk,rst);
  DFF d3(D2,q2,clk,rst);
endmodule 

module datapath(ldMplier,ldP,shift,ldMcand,clk2,go,count,rst,rst2,Mpand,Mplier,result,outp,rst3);
 input ldMplier,ldP,shift,ldMcand,clk2,go,count,rst,rst2,rst3;
  input [9:0] Mpand;
  input [9:0] Mplier;
  output outp;
  output [19:0] result;
  wire [19:0] out;
  assign result= out;
  wire [2:0] is5count;
  buf(is5count[0],out0);
  buf(is5count[1],out1);
  buf(is5count[2],out2);
  
 wire out0,out1,out2,out_1,clk2,clk;
 wire [2:0] select;
  wire [9:0] x,y,z;
  and (clk2,count,clk);
 and (clk,clk2,go);
  and(select[0],out_1,go);
  buf(select[1],out[0]);
  buf(select[2],out[1]);
  buf(x[0],out[10]);
  buf(x[1],out[11]);
  buf(x[2],out[12]);
  buf(x[3],out[13]);
  buf(x[4],out[14]);
  buf(x[5],out[15]);
  buf(x[6],out[16]);
  buf(x[7],out[17]);
  buf(x[8],out[18]);
  buf(x[9],out[19]);
  initial
    begin     
     
	  integer i;
	  for(i=0;i<14;i++)
			   $display("%d prod out at %0dns",out[19:10],$time); 
				$display("%d mply at %0dns",out[9:0],$time);
				$display("%d select  ",select);
				$display("%d zbus at %0dns",z,$time); 
				$display("%d is5count at %0dns",is5count,$time);
				#2
      end
    
 count c1(rst,clk2,out2,out1,out0);
 is5 eq1(out2,out1,out0,outp);

 alu alu1(x,y,select,z);
 reg9 mpcand(Mpand,y,ldMcand,clk,rst);

  DFF D1(out[1],out_1,clk,rst3);
  shiftreg PMplierl0(ldMplier,Mplier[0],shift,out[2],out[0],clk,rst);
 shiftreg PMplierl1(ldMplier,Mplier[1],shift,out[3],out[1],clk,rst);
 shiftreg PMplierl2(ldMplier,Mplier[2],shift,out[4],out[2],clk,rst);
 shiftreg PMplierl3(ldMplier,Mplier[3],shift,out[5],out[3],clk,rst);
 shiftreg PMplierl4(ldMplier,Mplier[4],shift,out[6],out[4],clk,rst);
 shiftreg PMplierl5(ldMplier,Mplier[5],shift,out[7],out[5],clk,rst);
 shiftreg PMplierl6(ldMplier,Mplier[6],shift,out[8],out[6],clk,rst);
 shiftreg PMplierl7(ldMplier,Mplier[7],shift,out[9],out[7],clk,rst);
 shiftreg PMplierl8(ldMplier,Mplier[8],shift,out[10],out[8],clk,rst);
  shiftreg PMplierl9(ldMplier,Mplier[9],shift,out[11],out[9],clk,rst);
  shiftreg PMplierl10(ldP,z[0],shift,out[12],out[10],clk,rst2);
  shiftreg PMplierl11(ldP,z[1],shift,out[13],out[11],clk,rst2);
  shiftreg PMplierl12(ldP,z[2],shift,out[14],out[12],clk,rst2);
  shiftreg PMplierl13(ldP,z[3],shift,out[15],out[13],clk,rst2);
  shiftreg PMplierl14(ldP,z[4],shift,out[16],out[14],clk,rst2);
  shiftreg PMplierl15(ldP,z[5],shift,out[17],out[15],clk,rst2);
  shiftreg PMplierl16(ldP,z[6],shift,out[18],out[16],clk,rst2);
  shiftreg PMplierl17(ldP,z[7],shift,out[19],out[17],clk,rst2);
  shiftreg PMplierl18(ldP,z[8],shift,out[19],out[18],clk,rst2);
  shiftreg PMplierl19(ldP,z[9],shift,out[19],out[19],clk,rst2);
endmodule
 
module shiftreg(ld,zi,shift,Di,out,clk,rst);
 output out;
 input ld,zi,shift,Di,clk,rst;
 wire X1,X2,in;
 
 
 and a1(X1,ld,zi);
 and a2(X2,shift,Di);
  or o1(in1,X1,X2);
  not n1(nld,ld);
  not(nshift,shift);
  and a3(in2,nld,nshift,out);
  or(in,in1,in2);
 DFF D(in,out,clk,rst);
endmodule

module shiftleft(in,out);
  input [9:0] in;
  output [9:0] out;
  genvar i;
  generate 
    begin
      for( i=0;i<9;i=i+1)
      buf(out[i+1],in[i]);
    end
 endgenerate
     buf(out[0],0);
endmodule

module full_adder(X,Y,cin,sum,cout);
    input X,Y,cin;
    output sum,cout;
    wire s1,c1,c2,c3;
    xor(s1,X,Y);
    xor(sum,cin,s1);
    and(c1,X,Y);
    and(c2,Y,cin);
    and(c3,X,cin);
    or(cout,c1,c2,c3);
endmodule

module full_adder_9bit(a,b,ckin,sum,cout);
  input [9:0] a,b;
    input ckin;
  output [9:0]sum,cout;
    full_adder fa0(a[0],b[0],ckin,sum[0],cout[0]);
    full_adder fa1(a[1],b[1],cout[0],sum[1],cout[1]);
    full_adder fa2(a[2],b[2],cout[1],sum[2],cout[2]);
    full_adder fa3(a[3],b[3],cout[2],sum[3],cout[3]);
    full_adder fa4(a[4],b[4],cout[3],sum[4],cout[4]);
    full_adder fa5(a[5],b[5],cout[4],sum[5],cout[5]);
    full_adder fa6(a[6],b[6],cout[5],sum[6],cout[6]);
    full_adder fa7(a[7],b[7],cout[6],sum[7],cout[7]);
    full_adder fa8(a[8],b[8],cout[7],sum[8],cout[8]);
  full_adder fa9(a[9],b[9],cout[8],sum[9],cout[9]);  
endmodule

module sub_9(X,Y,Z,carry);
  input [9:0]X,Y;
  output [9:0]Z;
    output carry;
  wire[9:0] nY, c2;
    not N0(nY[0],Y[0]);
    not N1(nY[1],Y[1]);
    not N2(nY[2],Y[2]);
    not N3(nY[3],Y[3]);
    not N4(nY[4],Y[4]);
    not N5(nY[5],Y[5]);
    not N6(nY[6],Y[6]);
    not N7(nY[7],Y[7]);
    not N8(nY[8],Y[8]);
  not N9(nY[9],Y[9]);
    full_adder_9bit F2(X, nY,1, Z, c2);
  not(carry,c2[9]);
endmodule

module reg9(in,out,load,clk,rst);
  output [9:0] out;
  input [9:0] in;
    input clk,rst,load;
  reg [9:0] out;
  always@(posedge clk)
    begin
    if(rst)
    begin   
         out<=10'b0000000000;
    end
      
    else if(load)
        begin
        out<=in;
      
         end
      else
        out=out;
    end
endmodule

module alu( X,Y,select,Z);
  input [9:0] X;
  input [9:0] Y;
	input [2:0] select;
  output [9:0] Z;
  wire [9:0] Y1,Z1,Z2,Z3,Z4,C1,C2,Z1in,Z2in,Z3in,Z4in,Z11,Z12,X1,X2,Xin,Z31,Z32;
	wire carry1,carry2;
    shiftleft l1(Y,Y1);	
  
      
	full_adder_9bit f1(X,Y,0,Z1,C1);
	full_adder_9bit f2(X,Y1,0,Z2,C2);
	sub_9 sub1(X,Y,Z3,carry1);
	sub_9 sub2(X,Y1,Z4,carry2);
	wire s0,s1,s2,ns0,ns1,ns2;
	buf(s0,select[0]);
	buf(s1,select[1]);
	buf(s2,select[2]);
	not(ns0,select[0]);
	not(ns1,select[1]);
	not(ns2,select[2]);
  
	genvar i;
	generate
   
      for(i=0;i<10;i=i+1)
          begin
		and(X1[i],X[i],ns0,ns1,ns2);
		and(X2[i],X[i],s0,s1,s2);
		or(Xin[i],X1[i],X2[i]);

		and(Z11[i],Z1[i],ns2,ns1,s0);
		and(Z12[i],Z1[i],ns2,s1,ns0);
		or(Z1in[i],Z11[i],Z12[i]);

		and(Z2in[i],Z2[i],ns2,s1,s0);

		and(Z31[i],Z3[i],s2,ns1,s0);
		and(Z32[i],Z3[i],s2,s1,ns0);
		or(Z3in[i],Z31[i],Z32[i]);

		and(Z4in[i],Z4[i],s2,ns1,ns0);

		or(Z[i],Xin[i],Z1in[i],Z2in[i],Z3in[i],Z4in[i]);
      end
 	endgenerate
endmodule		
			
// Test harness
module testbench_datapath();
 
  reg ldMplier;
  reg ldP;
  reg shift;
  reg ldMcand;
  reg clk2;
  reg go;
  reg countclk;
 reg count;
  reg rst;
  reg rst2;
  reg rst3;
  reg [9:0] Mpand;
  reg [9:0] Mplier;
  wire outp;
  wire [19:0] result;
  
  datapath d1(ldMplier,ldP,shift,ldMcand,clk2,go,count,rst,rst2,Mpand,Mplier,result,outp,rst2);
  
  initial
    begin
    rst=1;
    clk2=1;
    go=0;
    rst2=1;
    Mpand=10'b0000001011;
   ldMplier=1;
 Mplier=10'b0000010111;
      count=0;
      #2
      
    rst=0;
    shift=0;
    ldMcand=1;
    ldMplier=0;
    go=1;    
    ldP=1;
      count=1;
       rst2=0;
     #2 
      ldMplier=0;
      ldP=0; 
    shift=1;
       count=0;
    
    #2
     shift=0;
    ldP=1;
       count=1;
                    
    #2 
    shift=1;
    ldP=0;
        ldMplier=0;
       count=0;
                       
    #2
       shift=0;
    ldP=1;
       count=1;
                               
    #2 
    shift=1;
    ldP=0;
        ldMplier=0;
       count=0;
                                         
    #2
       shift=0;
    ldP=1;
         count=1;
    #2 
    shift=1;
    ldP=0;
      ldMplier=0;
       count=0;
    #2
       shift=0;
    ldP=1;
       count=1;
    #2 
    shift=1;
    ldP=0;
      ldMplier=0;
       count=0;
    #2
       shift=0;
    ldP=1;
      count=1;
   #2 
    shift=1;
    ldP=0;
      ldMplier=0;
       count=0;
    #2
       shift=0;
    ldP=1;
      count=1;
    #2 
    shift=1;
    ldP=0;
      ldMplier=0;
       count=0;
    #2
       shift=0;
    ldP=1;
      count=1;
    #2 
    shift=1;
    ldP=0;
      ldMplier=0;
       count=0;
    #2
    shift=0;
    ldP=1;
    #2 
    shift=1;
    ldP=0;
    
     
  end 
  initial begin   
    while(1)
      begin
      #1
      clk2=~clk2;
      end
  end
endmodule
