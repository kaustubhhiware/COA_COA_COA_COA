`timescale 1ns / 1ps

module adder16_bit(in1, in2, out, carry);
  
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


module tristate(in,out,enable);
  
  input [15:0] in;
  output [15:0] out;
  input enable;
  
  assign out= (enable==1)?in:16'bz;

endmodule

//needed for PCBranch
module leftshift(in,out);
  
  input [15:0]in;
  output [15:0]out;
  reg [15:0]out;
  
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

module mux5( in1 , in2, s, out );
  input [4:0] in1, in2;
  input s;
  output [4:0]out;
  reg [4:0]out;
  
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
  output[15:0] out;
  reg [15:0] out;
  
  always@(in) begin
      out[15:0]  = in[15:0];
      out[15:16] = {16{in[15]}};
   end
endmodule

module RegisterBank(readReg1, readReg2, writeReg, writeData, readData1, readData2, RegWrite);
     input [4:0]readReg1, readReg2, writeReg;
     input [15:0]writeData;     //address of the register to be written on to.
     input RegWrite;    
     
     output [15:0]readData1, readData2;
     reg [15:0]readData1, readData2;
     reg [15:0]RegMemory[0:15];
     
     integer placeVal, i, j, writeRegINT=0, readReg1INT=0, readReg2INT=0;
     
     initial
     begin
       for(i=0 ; i<16 ; i=i+1)
       begin
              for(j=0 ; j<16 ; j= j+1)
                RegMemory[i][j] = 1'b0;
       end
     end
     
     always@ (RegWrite or readReg1 or readReg2 or writeReg or writeData)
     begin
       
        if(RegWrite == 1)
        begin
          
          placeVal = 1;
          readReg1INT=0;
          readReg2INT=0;
          for(i=0 ; i<5 ; i=i+1)
          begin
               if(readReg1[i] == 1)
                  readReg1INT = readReg1INT + placeVal;
                  
               if(readReg2[i] == 1)
                  readReg2INT = readReg2INT + placeVal; 
                    
               placeVal = placeVal * 2;
          end
          
          for(i=0 ; i<16 ; i=i+1)
          begin
              readData1[i] = RegMemory[readReg1INT][i];
              readData2[i] = RegMemory[readReg2INT][i];
          end
          
          //binary to decimal address translation.
          placeVal = 1;
          writeRegINT=0;
          for(i=0 ; i<5 ; i=i+1)
          begin
               if(writeReg[i] == 1)
                  writeRegINT = writeRegINT + placeVal;
                  
               placeVal = placeVal * 2;
          end
          
          $display("before writing %d at %d", writeData, writeRegINT);
          for(i=0 ; i<16 ; i=i+1)
          begin
                RegMemory[writeRegINT][i] = writeData[i];
          end
          $display("after writing %d at %d", writeData, writeRegINT);
            
        end  // Register Write
        
        if(RegWrite == 0)
        begin
            //binary to decimal address translation.
          placeVal = 1;
          readReg1INT=0;
          readReg2INT=0;
          for(i=0 ; i<5 ; i=i+1)
          begin
               if(readReg1[i] == 1)
                  readReg1INT = readReg1INT + placeVal;
                  
               if(readReg2[i] == 1)
                  readReg2INT = readReg2INT + placeVal; 
                    
               placeVal = placeVal * 2;
          end
              
          for(i=0 ; i<16 ; i=i+1)
          begin
              readData1[i] = RegMemory[readReg1INT][i];
              readData2[i] = RegMemory[readReg2INT][i];
          end          
        end// Register Read
     end  //always@
endmodule  

module ALU_Core(ALUSrc1 , ALUSrc2 , ALUCtrl , ALUResult , Zero);
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
               if(ALUResult == 16'h0000)
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
               if(ALUResult == 16'h0000)
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
               if(ALUResult == 16'h0000)
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
               if(ALUResult == 16'h0000)
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
               if(ALUResult == 16'h0000)
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


module ALU_Control(FunctField, ALUOp, ALUCtrl);
input [5:0]FunctField;
input [1:0]ALUOp;
output [2:0]ALUCtrl;
reg [2:0]ALUCtrl;

always@(FunctField or ALUOp)
begin
    if(ALUOp == 2'b10)      //'Arithmetic' Type Instructions
    begin
      case(FunctField)        
      //begin
        6'b100000: ALUCtrl = 3'b010;    //ADDITION in 'R' Type
        6'b100010: ALUCtrl = 3'b110;    //SUBTRACTION in 'R' Type
        6'b100100: ALUCtrl = 3'b000;    //AND in 'R' Type
        6'b100101: ALUCtrl = 3'b001;    //OR in 'R' Type
        6'b101010: ALUCtrl = 3'b111;    //SLT in 'R' Type
     // end
    endcase
    end
    
    if(ALUOp == 2'b00)     // 'LW/SW' Type Instructions
    begin
        ALUCtrl = 3'b010;               //ADDITION irrespective of the FunctField.
    end
    
    if(ALUOp == 2'b01)    //   'BEQ', 'BNE' Type Instructions
    begin
        ALUCtrl = 3'b110;               //SUBTRACTION irrespective of the FunctField.
    end        
    

    
end   //always block 

endmodule  //ALUOp module

module datapath(lmar,lt,lpc,lir,lmdr,ldx,ldy,abus,tt,tpc,tp,t2,tmdr2x,tmdrext,
rmdri,rmarx,pa,rdr,wpa,wrr,fnsel,vin,cin,datain,dataout);

  input lmar,lt,lpc,lir,lmdr,ldx,ldy,tt,tpc,tp,t2,tmdr2x,tmdrext,rmdri,rmarx,wrr,rdr;
  input[2:0] pa,wpa;
  input [2:0] fnsel;
  input [15:0] datain;
  output [15:0] dataout;
  output[15:0] abus;
  output vin, cin,zin,sin;
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
