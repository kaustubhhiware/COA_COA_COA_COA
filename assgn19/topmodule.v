`timescale 1ns / 1ps

module topmodule(
    input rst,
    input clk
    );
	 
	 // Instantiation of leftshift
    wire [31:0] nextAddress ;
    wire [31:0] currentAddress ;
	 
    leftshift  PCB ( .out(nextAddress) , .in(currentAddress));

   wire [31:0] Instruction ;
 
    //Instantiation of adder16_bit
	 reg [31:0] in2_PC_adder16_bit = 32'd4;
	 wire [31:0] Add_4_Out_t;
	 
	 adder16_bit adder16_bit_t (. in1(currentAddress) , .in2(in2_PC_adder16_bit) , .out(Add_4_Out_t));


    //Instantiation of Control Unit 
    wire [4:0] controlALU_t ;	
    wire RegWrite_t , readDataMem_t  , WriteDataMem_t;
    wire [1:0] writeOut_t ;
	 wire [1:0] sizeDataMem_t;
	 wire jal_t , jalr_t , AluOP_t;
	 
	 wire lmar,lt,lpc,lir,lmdr,ldx,ldy,abus,tt,tpc,tp,t2,tmdr2x,tmdrext,
rmdri,rmarx,pa,rdr,wpa,wrr,vin,sin,cin,zin,datain,dataout;

	wire [2:0] fnsel;
	wire [31:0] datain;
	wire [31:0] dataout;
	wire [15:0] wpa;

	 controller controller_t ( .inst(Instruction) , .jal(jal_t) , .jalr(jalr_t) , .sizeDataMem(sizeDataMem_t) ,.writeOut(writeOut_t) , .WriteDataMem(WriteDataMem_t) ,
		       .AluOP(AluOP_t) , .readDataMem(readDataMem_t) , .RegWrite(RegWrite_t),
		       .controlALU(controlALU_t) ) ;

	datapath dp1(lmar,lt,lpc,lir,lmdr,ldx,ldy,abus,tt,tpc,tp,t2,tmdr2x,tmdrext,
rmdri,rmarx,pa,rdr,wpa,wrr,fnsel,vin,sin,cin,zin,datain,dataout);					
						
    //Instantiation of register file 
	 wire [31:0] readReg1_t , readReg2_t ;
    reg	[31:0] writeData_t;
	 wire [5:0] readData1_t = Instruction[`19 :`15] ;
	 wire [5:0] readData2_t= Instruction[`24 :`20] ;
	 wire [5:0] RegWrite_t = Instruction[`11 :`7] ;
	 
	 RegisterBank regBank ( .readReg1(readReg1_t) , .readReg2(readReg2_t) ,
                                .writeReg(RegWrite_t) ,.readData1(readData1_t) ,
                               .readData2(readData2_t) , .RegWrite(RegWrite_t) , 
                               .writeData(writeData_t));	
								 
								 
	 // Instantiation of sign extend module
	 wire [4:0] sign_extender_val_t ;
	 
    sign_extender sign_extender_t ( .in(Instruction) , .out(sign_extender_val_t));
	 
	 
	  // Implementation of 2:1 MUX 
	 
	 reg [32 : 0] Operand2_t, Operand1_t ;
	 always @ (AluOP_t)
	  begin 
	     case (AluOP_t )
		   1'b0 : Operand2_t = readReg2_t ;
	           1'b1 : Operand2_t = sign_extender_val_t ;
	     endcase
	  end
	 
	 // Implementation OF ALU 
	 wire [32 :0 ] ALU_Out_t;
	 wire bcond_t ;
	 
	 // Implementation of 2:4 mux 
	 
	 always @ ( writeOut_t )
	  begin 
	   if( writeOut_t== 2'b00 )
		     writeData_t = ALU_Out_t ;
			 else if(writeOut_t== 2'b01)
		          writeData_t = dataMemRead ; ///Should define
					 else if (writeOut_t== 2'b10)
		               writeData_t = Add_4_Out_t ;
							else
	                    writeData_t = Add_Out_t ;
			
		
	  end
    
	// Implementation of simple adder16_bit 
	wire [31:0] Add_Out_t;
	wire carry;
	adder16_bit adder16_bit_1_t (.in1(currentAddress) , .in2(sign_extender_val_t) , .out(Add_Out_t ),.carry(carry));
	
	//Implementation of OR gate 
	wire pc_mux1_sel_t  ;
	or or1 ( pc_mux1_sel_t , jal_t , bcond_t );
	
	 //Implemantation of pc_mux_1
	 reg [32 : 0 ] pc_mux1_Out_t ;
	 always @( pc_mux1_sel_t )
	   begin
		   case ( pc_mux1_sel_t)
			   1'b0 :  pc_mux1_Out_t = Add_4_Out_t;
		           1'b1 :  pc_mux1_Out_t = Add_Out_t ;
		   endcase
		end
		
	 //Implementation of pc_mux_2	
	 reg [31 : 0 ] pc_mux2_Out_t ;
	 //pc_mux2_sel_t = jalr_t ;
	 always @( jalr_t )
	   begin
		   case ( jalr_t)
			   1'b0 :  pc_mux2_Out_t = pc_mux1_Out_t;
			   1'b1 :  pc_mux2_Out_t = ALU_Out_t ;
		   endcase
		end
		
		
		assign nextAddress= pc_mux2_Out_t ;
	
	  
	 // Implementation of Data Memory module 
	 
	 reg [4:0] d_mem_word_size ; 
	 //reg [32 : 0]  d_mem_wr_data_t == ALU_Out_t;
	   

         wire [15 : 0 ] dataMemRead;
	 endmodule
