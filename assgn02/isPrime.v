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

module alu(X,Y,func_select,Bo,Z,clk,eqz);

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


module divide(n,x,clk,ldrem,lddiv,rst,rem,divover,Bo);
  
  input [15:0] n;
  input[15:0] x;
  input clk;
  input ldrem,lddiv,rst;
  output [15:0] rem;
  output divover;
  output Bo;
  reg [15:0] nvar;
  reg [15:0] xvar;
  reg[1:0] subt;
  reg [15:0] tempOut;
  initial
  begin
	nvar = n;
	xvar = x;
	subt = 2'b10;
	tempOut = n;
	end
  register remreg(nvar,ldrem,clk,rst,rem);
  register divreg(xvar,lddiv,clk,rst,div);
  reg divover;
  alu a1(nvar,xvar,subt,Bo,tempOut,clk); 
		 
  always@(posedge clk )
 begin	
  while(rem>=div)
    begin 
		nvar = tempOut;
    end
  divover = 1; //division process ends when rem < div
 
 end
endmodule


module datapath(ldx,ldn,lddiv,ldrem,ldrem1,lddv,x1,x2,y1,y2,z1,z2,clk,rst,sel1,sel2,Bo);

	input ldx,ldn,ldrem,ldrem1,lddv,lddiv;
	input [15:0]x1;
	input [15:0]x2;
	input [15:0]y1;
	input  [15:0]y2;
  	input clk,rst;
  input [1:0]sel1;
  input [1:0] sel2;
  input [15:0]z1;
  input [15:0] z2;
	wire [15:0]z1;
	wire [15:0]z2;
	output Bo;
	//reg z1,z2;
	
	register regx(z1,ldx,clk,rst,x1);
	register regn(z1,ldn,clk,rst,x1);
	register regdiv(z1,lddiv,clk,rst,y1);
	register regrem(z1,ldrem,clk,rst,y1);
	
	register regrem1(z2,ldrem1,clk,rst,x2);
	register regdv(z2,lddv,clk,rst,y2);
	
	divide div1(regrem1,regdv,clk,ldrem1,lddv,rst,z2,divover,Bo);
	alu alu1(x1,y1,sel1,Bo,z1,clk);
  //alu alu2(x2,y2,sel2,Bo,z2,clk);

endmodule
  