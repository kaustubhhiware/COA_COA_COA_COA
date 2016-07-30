module register(in,load,clk,rst,out);

  input [15:0] in;
  input clk;
  input rst;
  input load;
  output [15:0] out;
  reg [15:0] out;
  
  always@(posedge clk or posedge rst)
  begin
    if(rst==1)
      out=0;
    else if(load==1)
      out=in;
  end
  
endmodule

module tristate(in,out,enable);
	
	input [15:0] in;
	output [15:0] out;
	input enable;
	
	assign out= (enable==1)?in:16'bz;

endmodule

module alu(X,Y,func_select,clk,Bo,Z,eqz);

  input [15:0] X;
  input [15:0] Y;
  input [1:0] func_select;
  input clk;
  output Bo;
  output [15:0] Z;
  output eqz;

  reg [15:0] Z;
  reg Bo, eqz; //status detector
  
  always@(posedge clk)
		
    begin
//	 eqz = 0;
      case(func_select)
        2'b00:
          Z=X; //transmit 
        2'b01: 
		  begin
          Z =0; //make zero
			 eqz=1;
        end
		  2'b10:
          begin
            if(X>Y)
              begin
						Z=X-Y; //difference
						Bo=1'b0;    
              end
				else if(X==Y)
					begin
						Z=0;
						eqz=0;
					end
               else if(X<Y)
            	Bo=1'b1;
          end  
        2'b11:
          Z=X+1; //increment X
      endcase
    end 
endmodule


module divide(n,x,clk,Go,ldrem,lddiv,rst,rem,divover,Bo,eqz);
  
  input [15:0] n;
  input[15:0] x;
  input clk;
  input Go;
  input ldrem,lddiv,rst;
  output [15:0] rem;
  wire [15:0] div;
  output divover;
  output Bo,eqz;
  //wire eqz;
  reg [15:0] nvar;
  reg [15:0] xvar;
  reg[1:0] subt;
  wire [15:0] tempOut;
  initial
  begin
	nvar = n;
	xvar = x;
	subt = 2'b10;
	//tempOut = n;
	end
  register remreg(nvar,ldrem,clk,rst,rem);
  register divreg(xvar,lddiv,clk,rst,div);
  reg divover;
  alu a1(nvar,xvar,subt,clk,Bo,tempOut,eqz); 
		 
  always@(posedge clk )
 begin	
  while(nvar>=xvar && Go==1 )
    begin 
		nvar = tempOut;
    end
  divover = 1; //division process ends when rem < div
 
 end
endmodule


module datapath(Go,ldx,ldn,lddiv,ldrem,ldrem1,lddv,ld2,x1,x2,y1,y2,z1,z2,clk,rst,sel1,sel2,Bo,enregx,enregn,enregdiv,enregrem,enregrem1,enregdv,enreg2,eqz,divover);

	input ldx,ldn,ldrem,ldrem1,lddv,lddiv,ld2;
	input [15:0]x1;
	input Go;
	input [15:0]x2;
	input [15:0]y1;
	input  [15:0]y2;
  	input clk,rst;
	input [1:0]sel1;
	input [1:0] sel2;
	input [15:0]z1;
	input [15:0] z2;
	input enregx,enregn,enregdiv,enregrem,enregrem1,enregdv,enreg2;

  
	wire [15:0] tsregx;
	wire [15:0] tsregn;
	wire [15:0] tsregdiv;
	wire [15:0] tsregrem;
	wire [15:0] tsregrem1;
	wire [15:0] tsregdv;
	wire [15:0] tsregtwo; // for the register containing 2
  
	wire [15:0]z1;
	wire [15:0]z2;
	output Bo,eqz,divover;

	//reg z1,z2;
	//tristate(in,out,enable);
	
	register regx(z1,ldx,clk,rst,tsregx);
	tristate ts1(tsregx,x1,enregx);

	register regn(z1,ldn,clk,rst,tsregn);
	tristate ts2(tsregn,x1,enregn);

	register regdiv(z1,lddiv,clk,rst,tsregdiv);
	tristate ts3(tsregdiv,y1,enregdiv);
	
	register regrem(z1,ldrem,clk,rst,tsregrem);
	tristate ts4(tsregrem,y1,enregrem);
	
	register reg2(16'b0000000000000010,ld2,clk,rst,tsregtwo);
	tristate tstwo(tsregtwo,y1,enreg2);
	
	register regrem1(z2,ldrem1,clk,rst,tsregrem1);
	tristate ts5(tsregrem1,x2,enregrem1);
		
	register regdv(z2,lddv,clk,rst,tsregdv);
	tristate ts6(tsregdv,y2,enregdv);
	

	divide div1(x2,y2,clk,Go,ldrem1,lddv,rst,z2,divover,Bo,eqz);
	// n,x,clk,Go,ldrem,lddiv,rst,divover,Bo,eqz)
	
	alu alu1(x1,y1,sel1,clk,Bo,z1,eqz);

endmodule
  
 
 
module behaviouralFSM(clk,Go,enregx,enregn,enregdiv,enregrem,enregrem1,enregdv,enreg2,ldx,ldn,ldrem,ldrem1,lddv,lddiv,ld2,Bo,eqz,N,isPrime,over,divover);

//input [3:0] state;
input clk,Go;
input [15:0] N;
input Bo,eqz;
output isPrime,over,divover;//,isWork;
output enregx,enregn,enregdiv,enregrem,enregrem1,enregdv,enreg2,ldx,ldn,ldrem,ldrem1,lddv,lddiv,ld2;
reg enregx,enregn,enregdiv,enregrem,enregrem1,enregdv,enreg2,ldx,ldn,ldrem,ldrem1,lddv,lddiv,ld2;

reg [3:0] state;
reg isPrime,over,divover;//,isWork;
reg [15:0] rem;
reg [15:0] div;
reg [15:0] remOut;
reg [15:0] divOut;
initial 
begin
	state=4'b0000;
	rem = N;
	div = 16'b0000000000000010; // div is 2 at start ,since  first prime is 2 
	//Bo <= 0;
	//eqz = 0;
	isPrime = 1;
	over =0;
	divover = 0;
//	isWork = 0;
end

always@(posedge clk )
		
    begin
//	 eqz = 0;
		//isWork = 1;
      case(state)
        4'b0000: 
		  begin
				if(Bo==0)
				begin
					state = 4'b0001;
					over = 1;
					isPrime = 0;
				end
				else
				begin
					state = 4'b0010;
					divover = 0;
				end
        end
		  
		  
		  4'b0001:
		  begin
			over <=1;
			isPrime <= 0;
		  end
		  
		  4'b0010:
		  begin
			divover <= 0;
			if(Bo==0)
				begin
					divover <=1;
					state <= 4'b0011;
				end
			else
				begin
					state <= 4'b0100;
				end
			end
			
			4'b0011:
			begin 
				if(eqz==1)
				begin
					isPrime<=0;
					over<=1;
					state<=4'b0101;
				end
				else
				begin
					divOut <= divOut+1;
					state=4'b0110;					
				end
			end
			
			
			4'b0100:
			begin
				remOut=remOut-divOut;
				state <= 4'b0010;
			end
				
			
			4'b0101:
			begin
				over <=1;
			end
			
			4'b0110:
			begin
				if(Bo==0)
				begin
					over <=1;
					isPrime <= 1;
					state <= 4'b0101;
				end
				else
				begin
					remOut <= N;
					state <= 4'b0010;
				end
			end
			
			
			4'b0111:
			begin
				over <= 1;
				isPrime <= 1;
			end
			
			
			4'b1000:
			begin
				remOut <= N;
				state  <= 4'b0010;
			end	
      endcase
    end 
	
		 
	 always@(state)
	 begin
		case(state)
			
			4'b0000:
			begin
				ld2=1;
				ldn=1;
				enregn=1;
				enreg2=1;
				enregx=1;
				enregdiv=1;
				enregrem=1;
				isPrime=1;
			end
			
			4'b0001:
			begin
				over=1;
				isPrime=0;
			end
			
			4'b0010:
			begin
				divover=1;
				ldn=1;
				ldrem=1;
				enregn=1;
				enregrem=1;
				ldn=0;
				ldrem=0;
				enregn=0;
				enregrem=0;
				enregdiv=1;
				enregdiv=1;
				ldx=1;
				lddiv=1;
			end
		endcase
	end		
	 	 
endmodule


module topmodule(Go,n,clk,isPrime);

	input Go,clk;
	input [15:0] n;
	output isPrime;
	
	reg ldx,ldn,ldrem,ldrem1,lddv,lddiv,ld2;
	reg [15:0] x1;
	reg [15:0] x2;
	reg [15:0] y1;
	reg [15:0] y2;
	reg [15:0] z1;
	reg [15:0] z2;	
	reg [1:0] sel1;
	reg [1:0] sel2;
	reg enregx,enregn,enregdiv,enregrem,enregrem1,enregdv,enreg2;//inputs for datapath
	
	reg Bo,eqz,divover;//output for datapath
	
	
	
	
	datapath da(Go,ldx,ldn,lddiv,ldrem,ldrem1,lddv,ld2,x1,x2,y1,y2,z1,z2,clk,rst,sel1,sel2,
	Bo,enregx,enregn,enregdiv,enregrem,enregrem1,enregdv,enreg2,eqz,divover);
	
	behaviouralFSM bFSM(clk,Go,enregx,enregn,enregdiv,enregrem,enregrem1,enregdv,enreg2,ldx
	,ldn,ldrem,ldrem1,lddv,lddiv,ld2,Bo,eqz,N,isPrime,over,divover);
endmodule


//testbench

//
//
//
 `timescale 1 ns / 1 ps

module TestFSM;
/*
input clk,Go;
input [15:0] N;
input Bo,eqz;
output isPrime,over,divover;*/
	// Inputs
	reg clk;
	reg Go;
	wire Bo,eqz,divover;
	reg [15:0] N;
	
	// Outputs
	wire isPrime,over;
	//wire isWork;

	always begin #5 clk = ~clk; end
	
	wire ldx,ldn,ldrem,ldrem1,lddv,lddiv,ld2;
	reg [15:0]x1;
	reg [15:0]x2;
	reg [15:0]y1;
	reg  [15:0]y2;
  	reg rst;
	reg [1:0]sel1;
	reg [1:0] sel2;
	reg [15:0]z1;
	
	reg [15:0] z2;
	wire enregx,enregn,enregdiv,enregrem,enregrem1,enregdv,enreg2;
	
	// Instantiate the Unit Under Test (UUT)
	
	//(Go,ldx,ldn,lddiv,ldrem,ldrem1,lddv,ld2,x1,x2,y1,y2,z1,z2,clk,rst,sel1,sel2,Bo,enregx,enregn,enregdiv,enregrem,enregrem1,enregdv,enreg2,eqz);
	
	
	behaviouralFSM uut (
		.clk(clk),.Go(Go),.Bo(Bo),.eqz(eqz),.N(N),
		.isPrime(isPrime),.over(over),.divover(divover),
		.ldx(ldx),
		.ldn(ldn),
		.ldrem(ldrem),
		.lddiv(lddiv),
		.ldrem1(ldrem1),
		.lddv(lddv),
		.ld2(ld2),
		.enregx(enregx),
		.enreg2(enreg2),
		.enregrem(enregrem),
		.enregn(enregn),
		.enregdiv(enregdiv),
		.enregrem1(enregrem1),
		.enregdv(enregdv)
		
	);
	

	
	//datapath(ldx,ldn,lddiv,ldrem,ldrem1,lddv,ld2,x1,x2,y1,y2,z1,z2,clk,rst,sel1,sel2,Bo,enregx,enregn,enregdiv,enregrem,enregrem1,enregdv,enreg2);
	datapath dp(
		.Go(Go),
		.ldx(ldx),
		.ldn(ldn),
		.ldrem(ldrem),
		.lddiv(lddiv),
		.ldrem1(ldrem1),
		.lddv(lddv),
		.ld2(ld2),
		.clk(clk),
		.rst(rst),
		.x1(x1),
		.x2(x2),
		.y1(y1),
		.y2(y2),
		.sel1(sel1),
		.sel2(sel2),
		.z1(z1),
		.z2(z2),
		.enregx(enregx),
		.enreg2(enreg2),
		.enregrem(enregrem),
		.enregn(enregn),
		.enregdiv(enregdiv),
		.enregrem1(enregrem1),
		.enregdv(enregdv),
		.Bo(Bo),
		.eqz(eqz),
		.divover(divover)
	);
	initial begin
		// Initialize Inputs
		clk = 0;
		Go = 1;
		N = 16'b0000000000000010;//2 
		// Wait 100 ns for global reset to finish
		#100;
		N = 16'b0000000000000011;//3 
		#100;     
		N = 16'b0000000000001100;//12	
		#100;     
		N = 16'b0000000000001101;//13	
		#100;     
		N = 16'b0000000001000101;//69	
		#100;     
		N = 16'b0000000001001111;//79	
		#100;     
		N = 16'b0000000011000111;//199			
		01000101
		// Add stimulus here

	end
endmodule
    