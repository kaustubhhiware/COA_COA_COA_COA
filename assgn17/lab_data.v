`timescale 1ns / 1ps

module adder(in1, in2, out, carry);
  
  input [15:0] in1, in2;
  output [15:0] out;
  reg [15:0]out;
  output carry;
  reg carry;
  
  always@(in1 or in2)
        begin
          {carry , out } = in1 + in2;    
        end
endmodule

//needed for PCBranch
module leftshift(in,out);
  
  input [31:0]in;
  output [31:0]out;
  reg [31:0]out;
  
  always@(in) begin
    out=in<<2;
  end 
endmodule    

module mux( in1 , in2, s, out );
  input [15:0] in1, in2;
  input s;
  output [15:0]out;
  reg [15:0]out;
  
  always @(in1 or in2 or s )
    begin 
      case(s)
          1'b0:   out=in1;
          1'b1:  out=in2;
       endcase
    end
 endmodule   

module sign_extender(in, out);
  
  input[15:0] in;
  output[31:0] out;
  reg [31:0] out;
  
  always@(in) begin
      out[15:0]  = in[15:0];
      out[31:16] = {16{in[15]}};
   end
endmodule

module ALU(ALUSrc1 , ALUSrc2 , ALUCtrl , ALUResult , Zero);
  input[15:0] ALUSrc1;
  input[15:0] ALUSrc2;
  input[2:0] ALUCtrl;
  
  output Zero;
  reg Zero;
    
  output [15:0]ALUResult;
  reg [15:0]ALUResult;
  
  
  always @(ALUSrc1 or ALUSrc2 or ALUCtrl)
    begin
          
          if(ALUCtrl == 3'b010) //'add'
          begin
               ALUResult = ALUSrc1 + ALUSrc2; 
               if(ALUResult == 32'h0000)
               begin
                      Zero = 1'b1;
               end 
               else
                 begin
                      Zero = 1'b0;
                 end
          end
          
          if(ALUCtrl == 3'b110) // 'sub'
          begin
               ALUResult = ALUSrc1 - ALUSrc2; 
               if(ALUResult == 32'h0000)
               begin
                      Zero = 1'b1;
               end 
               else
                 begin
                      Zero = 1'b0;
                 end
          end
          
          if(ALUCtrl == 3'b000) // 'and'
          begin
               ALUResult = ALUSrc1 & ALUSrc2; 
               if(ALUResult == 32'h0000)
               begin
                      Zero = 1'b1;
               end 
               else
                 begin
                      Zero = 1'b0;
                 end
          end
               
          if(ALUCtrl == 3'b001) // 'or'
          begin
               ALUResult = ALUSrc1 | ALUSrc2; 
               if(ALUResult == 32'h0000)
               begin
                      Zero = 1'b1;
               end 
               else
                 begin
                      Zero = 1'b0;
                 end
          end     
          
          if(ALUCtrl == 3'b111) // 'slt'
          begin
               ALUResult = ALUSrc1 - ALUSrc2; 
               if(ALUResult == 32'h0000)
               begin
                      Zero = 1'b1;
               end 
               else
                 begin
                      Zero = 1'b0;
                 end
          end
        
    end
  
endmodule

module reg_bank(reg_sel,inReg, rd1,rd2,wr,opReg1, opReg2);

input rd1,rd2,wr;

input [2:0] reg_sel;
output [15:0] opReg;
reg [15:0] opReg;
input [15:0] inReg;

reg[7:0] regbank;

always@(reg_sel)
begin
	if(rd1==1)
	begin
		opReg1 = regbank[reg_sel];	
	end
   if(rd2==1)
	begin
		opReg2 = regbank[reg_sel];
	end
	if(wr==1)
	begin
		regbank[reg_sel] = inReg;
	end
end
endmodule 

module datapath();

	wire [15:0]regbankout1;
	wire [15:0] regbankout2;
	wire [15:0] out1;
	wire [2:0]ctrl;
	wire [15:0] memInput;
	wire zero;
	wire a;
	wire selMux1;
	mux mux1(regbankout1,signextendout,selMux1,out1);
	ALU alu(out1 , regbankout2 , ctrl  , memInput  , zero);
	sign_extender sn1(ir[15:0], out1);
	wire leftin;
	assign leftin=out1;
	wire leftout;
	leftshift lsh(leftin, leftout);
	wire add1_carry;
	adder ad1(leftout,ad2_out,pcmux1_in2,add1_carry);
	


endmodule