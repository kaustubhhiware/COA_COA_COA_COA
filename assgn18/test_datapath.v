module test_alu_control;
	// Inputs
	reg [15:0] ALUSrc1;
	reg [15:0] ALUSrc2;
	reg [2:0] ALUCtrl;
	// Outputs
	wire [15:0] ALUResult;
	wire Zero;
	// Instantiate the Unit Under Test (UUT)
	ALU_Core uut (
		.ALUSrc1(ALUSrc1), 
		.ALUSrc2(ALUSrc2), 
		.ALUCtrl(ALUCtrl), 
		.ALUResult(ALUResult), 
		.Zero(Zero)
	);
	initial begin
		// Initialize Inputs
		ALUSrc1 = 16'b0000000000001100;
		ALUSrc2 = 16'b1000000000001010;
		ALUCtrl = 0;//and
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		ALUSrc1 = 16'b0000000000001100;
		ALUSrc2 = 16'b0000000000001010;
		ALUCtrl = 3'b111;//slt
		
		#100;
		ALUSrc1 = 16'b0000000000001100;
		ALUSrc2 = 16'b0000000000001010;
		ALUCtrl = 3'b110;//sub
		
		#100;

	end
endmodule

      
module test_regbank;
	// Inputs
	reg [4:0] readReg1;
	reg [4:0] readReg2;
	reg [4:0] writeReg;
	reg [15:0] writeData;
	reg RegWrite;
	// Outputs
	wire [15:0] readData1;
	wire [15:0] readData2;
	// Instantiate the Unit Under Test (UUT)
	RegisterBank uut (
		.readReg1(readReg1), 
		.readReg2(readReg2), 
		.writeReg(writeReg), 
		.writeData(writeData), 
		.readData1(readData1), 
		.readData2(readData2), 
		.RegWrite(RegWrite)
	);
	initial begin
		// Initialize Inputs
		readReg1 = 0;
		readReg2 = 0;
		writeReg = 0;
		writeData = 0;
		RegWrite = 0;
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
	end
      
endmodule

module test_datapath;
	
		//input 
	reg lmar,lt,lpc,lir,lmdr,ldx,ldy,abus,tt,tpc,tp,t2,tmdr2x,tmdrext,rmdri,rmarx,pa,rdr,wpa,wrr,fnsel;
	reg[2:0] pa,wpa;
	reg[2:0] fnsel;
	reg[15:0] datain;
	reg[15:0] dataout;

	//output 
	wire[15:0] dataout;
	wire vin, cin,zin,sin;

	// Instantiate the Unit Under Test (UUT)
	datapath DP(lmar,lt,lpc,lir,lmdr,ldx,ldy,abus,tt,tpc,tp,t2,tmdr2x,tmdrext,
				rmdri,rmarx,pa,rdr,wpa,wrr,fnsel,vin,cin,datain,dataout);
	
	
	always
	begin #5
	clk=~clk;
	end

	initial begin
		// Initialize Inputs

		clk = 0;
		// Wait 100 ns for global reset to finish
		#100;
		lmar=1;
		lt=0;
		lpc=0;
		lir=1;
		lmdr=0;
		ldx=0;
		ldy=0;
		tt=0;tpc=0;tp=0;t2=0
		tmdr2x=0;
		tmdrext=0;
		rmdri=1;
		rmarx=1;
		pa=1;
		rdr=0;
		wpa=0;
		wrr=1;
		fnsel=0;

		#100;
		lt=1;datain = 16'b0000000000001100;lt=0;
		fnsel = 2'b00;
		lt=1;datain = 16'b0000000000000010;lt=0;
		
		lmar=0;
		lt=0;
		lpc=0;
		lir=1;
		lmdr=1;
		ldx=0;
		ldy=0;
		tt=0;tpc=0;tp=0;t2=0
		tmdr2x=0;
		tmdrext=0;
		rmdri=0;
		rmarx=0;
		pa=0;
		rdr=1;
		wpa=0;
		wrr=1;
		fnsel=0;
		
		#100;
		lt=1;datain = 16'b0000000000001100;lt=0;
		fnsel = 2'b00;
		lt=1;datain = 16'b0000000000000010;lt=0;
			lt=1;datain = 16'b0000000000001100;lt=0;
		fnsel = 2'b00;
		lt=1;datain = 16'b0000000000000010;lt=0;
			lt=1;datain = 16'b0000000000001100;lt=0;
		fnsel = 2'b00;
		lt=1;datain = 16'b0000000000000010;lt=0;
		
		lmar=1;
		lt=1;
		lpc=0;
		lir=1;
		lmdr=1;
		ldx=0;
		ldy=0;
		tt=0;
		tpc=0;
		tp=1;
		t2=1;
		tmdr2x=0;
		tmdrext=0;
		rmdri=0;
		rmarx=0;
		pa=0;
		rdr=1;
		wpa=0;
		wrr=1;
		fnsel=0;
		


		#100;
		lt=1;datain = 16'b0000000000001100;lt=0;
		fnsel = 2'b00;
				lmar=0;
		lt=0;
		lpc=0;
		lir=1;
		lmdr=1;
		ldx=0;
		ldy=0;
		tt=0;tpc=0;tp=0;t2=0
		tmdr2x=0;
		tmdrext=0;
		rmdri=0;
		rmarx=0;
		pa=0;
		rdr=1;
		wpa=0;
		wrr=1;
		fnsel=0;
	end
      
endmodule