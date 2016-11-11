`timescale 1ns / 1ps

// The modules not present in earlier datapath are mentioned here in continuation
// like Instruction Memory, Data Memory, ALUcontrol after controller

module controller(inst,controlALU,writeOut ,RegWrite,AluOP,readDataMem,WriteDataMem,sizeDataMem,
		jal,jalr);
	
	input [31:0] inst;
	output reg [4:0] controlALU;// 2-0 is operationcode , 3 is for subtract , 4 for branch
										// LUI : 5'b11000, JALR : 5'b11001
	output reg writeOut ;// display output
								// 00 for ALU, 01 for data, 10 =>PC+4 11 => PC+immediate
	output reg [1:0] RegWrite;
	output reg AluOP;
	output reg readDataMem;
	output reg WriteDataMem;//size will be encoded as 10 => 32 , 01 => 16, 00 => 8
	output reg [1:0] sizeDataMem;
	output reg jal,jalr; 

	
	always @ (*) begin
		if (inst[1:0] == 2'b11) begin
			case (inst[6:2])
			
				//R-type
				5'b01100: begin
					controlALU[3:0] = {inst[30], inst[14:12]};
					controlALU[4] = 1'b0;
					writeOut  = 1'b1;
					RegWrite = 2'b00;
					AluOP = 1'b0;
					readDataMem = 1'b0;
					WriteDataMem = 1'b0;
					sizeDataMem = 2'bzz;
					jal = 1'b0;
					jalr = 1'b0;
				end
				
				//I-type
				5'b11001: begin
					controlALU = inst[6:2];
					writeOut  = 1'b1;
					RegWrite = 2'b10;
					AluOP = 1'b1;
					readDataMem = 1'b0;
					WriteDataMem = 1'b0;
					sizeDataMem = 2'bzz;
					jal = 1'b0;
					jalr = 1'b1;
				end
									
				5'b00000: begin
					controlALU = 5'b00000;
					writeOut  = 1'b1;
					RegWrite = 2'b01;
					AluOP = 1'b1;
					readDataMem = 1'b1;
					WriteDataMem = 1'b0;
					sizeDataMem = inst[13:12];
					jal = 1'b0;
					jalr = 1'b0;
				end
				
				5'b00100: begin
					if(inst[14:12] == 3'b010 || inst[14:12] == 3'b011) begin
						controlALU = {1'b0, 1'b1, inst[14:12]};
					end
					
					else begin
						controlALU = {2'b00, inst[14:12]};
					end
					writeOut  = 1'b1;
					RegWrite = 2'b00;
					AluOP = 1'b1;
					readDataMem = 1'b0;
					WriteDataMem = 1'b0;
					sizeDataMem = 2'bzz;
					jal = 1'b0;
					jalr = 1'b0;	
				end	
				
				//S-type
				5'b01000: begin
					controlALU = 5'b00000;
					writeOut  = 1'b0;
					RegWrite = 2'bzz;
					AluOP = 1'b1;
					WriteDataMem = 1'b1;
					sizeDataMem = inst[13:12];
					jal = 1'b0;
					jalr = 1'b0;
				end
				
				//SB-type
				5'b11000: begin
					controlALU = {1'b1, 1'b0, inst[14:12]};
					writeOut  = 1'b0;
					RegWrite = 2'bzz;
					AluOP = 1'b0;
					readDataMem = 1'b0;
					WriteDataMem = 1'b0;
					sizeDataMem = 2'bzz;
					jal = 1'b0;
					jalr = 1'b0;
				end
				
				//U-type
				5'b01101: begin
					if(inst[5]==1) begin
						controlALU = 5'b11000;
					end
					
					else begin
						controlALU = 5'bzzzzz;
					end	
					writeOut  = 1'b1;
					if(inst[5]==1) begin
						RegWrite = 2'b00;
					end
					
					else begin
						RegWrite = 2'b11;
					end					
					AluOP = 1'b1;
					readDataMem = 1'b0;
					WriteDataMem = 1'b0;
					sizeDataMem = 2'bzz;
					jal = 1'b0;
					jalr = 1'b0;
				end

				//2nd MCB does not matter hence repeated
				5'b00101: begin
					if(inst[5]==1) begin
						controlALU = 5'b11000;
					end
					
					else begin
						controlALU = 5'bzzzzz;
					end	
					writeOut  = 1'b1;
					if(inst[5]==1) begin
						RegWrite = 2'b00;
					end
					
					else begin
						RegWrite = 2'b11;
					end					
					AluOP = 1'b1;
					readDataMem = 1'b0;
					WriteDataMem = 1'b0;
					sizeDataMem = 2'bzz;
					jal = 1'b0;
					jalr = 1'b0;
				end
				
				//UJ-type
				5'b11011:begin
					controlALU = 5'bzzzzz;
					writeOut  = 1'b1;
					RegWrite = 2'b10;
					AluOP = 1'bz;
					readDataMem = 1'b0;
					WriteDataMem = 1'b0;
					sizeDataMem = 2'bzz;			
					jal = 1'b1;
					jalr = 1'b0;
				end			

				//default
				default: begin
					controlALU = 5'bzzzzz;
					writeOut  = 1'b0;
					RegWrite = 2'bzz;
					AluOP = 1'bz;
					readDataMem = 1'b0;
					WriteDataMem = 1'b0;
					sizeDataMem = 2'bzz;
					jal = 1'b0;
					jalr = 1'b0;
				end
				
			endcase
		end // end for if (inst[1:0] == 2'b11) begin
		
		else begin
			controlALU = 5'bzzzzz;
			writeOut  = 1'b0;
			RegWrite = 2'bzz;
			AluOP = 1'bz;
			readDataMem = 1'b0;
			WriteDataMem = 1'b0;
			sizeDataMem = 2'bzz;
			jal = 1'b0;
			jalr = 1'b0;
		end
	
	end // always block

endmodule //end for controller


module ALU_Control(function1 , ALUOp, ALUCtrl);

input [5:0]function1 ;
input [1:0]ALUOp;
output [2:0]ALUCtrl;
reg [2:0]ALUCtrl;

always@(function1  or ALUOp)
begin
    if(ALUOp == 2'b10)      //'Arithmetic' Type Instructions
    begin
      case(function1)        
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
        ALUCtrl = 3'b010;     // add          
    end
    
    if(ALUOp == 2'b01)    //   'BEQ', 'BNE' Type Instructions
    begin
        ALUCtrl = 3'b110;      // sub        
    end        
      
end   //always block 

endmodule  //ALU_Control module


module DataMemory(inputAddress, inData, outData, MemRead, MemWrite);

input [31:0]inputAddress;
input [31:0]inData;
input MemRead, MemWrite;
output [31:0]outData;

reg [7:0]address;
reg [7:0]dataBuffer;
reg [31:0]outData;

reg [7:0]MM[255:0];// Main Memory

integer addressInt, i, j, disp,var, baseAddr;//disp is the displacement
// baseAddr stores base index address
genvar k;

always @( inData or inputAddress or MemRead or MemWrite)
begin

	  address=inputAddress[7:0];
	  addressInt = 0; 
	  disp = 1;   
	  
	  for( i=0 ; i<8 ; i=i+1 )
	  begin
	      if(address[i] == 1'b1)
	        addressInt = addressInt + disp;
	        
	      disp = disp * 2;
	  end


	  if(MemRead == 1) begin // read from the memory
	    
	    baseAddr = addressInt;          
	    for(i=0 ; i<4 ; i=i+1)
	    begin 
	       for(j = 0 ; j < 8 ; j = j+1 )
	        begin
	           outData[j] = MM[baseAddr + i][j];           
	        end 
	    end     
	end   
	   
	  
	  if(MemWrite == 1) // write into the memory
	  begin
	  
	    baseAddr = addressInt;
	    for(i=0 ; i<4 ; i = i + 1)
	    begin
	      
	      for(j = 0 ; j < 8 ; j = j+1 )
	         begin
	             MM[baseAddr + i][j] = inData[j] ;
	         end     
	    end   
	  end  
end 
endmodule


module InstructionMemory(readAddress, instruction);

  input [31:0]readAddress;
  output [0:31]instruction;
  reg [0:31]instruction;
  
  reg [0:7]IM[0:31]; // instruction memory
  
  reg [4:0]tempAddr;
  
  integer tempAddrINT, disp, i, j;
  
  always@(readAddress)
  begin
      
      {IM[0], IM[1], IM[2], IM[3]} = 32'b001101_10010_10011_0000000000000001;    
      {IM[4], IM[5], IM[6], IM[7]} = 32'b000101_10011_00000_0000000000000100;     // branch case            
          
       
      {IM[24], IM[24+1], IM[24+2], IM[24+3]} = 32'b001000_10011_10010_0000000000000100;    // add case
      {IM[28], IM[28+1], IM[28+2], IM[28+3]} = 32'b000010_00000_00000_0000000000000000;                               

      tempAddr = readAddress[4:0];
      disp = 1;
      tempAddrINT = 0;
      for(i=0 ; i<5 ; i=i+1)
      begin
            if(tempAddr[i] == 1)
                tempAddrINT = tempAddrINT + disp;
                
            disp = disp * 2;
      end
      
      
      for(i=0 ; i<32 ; i=i+1)
      begin
             instruction[i] = IM[tempAddrINT + i/8][i%8];        
      end
 end  
endmodule
