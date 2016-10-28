`timescale 1ns / 1ps

module test_reg_bank;

	// Inputs
	reg [2:0] PA;
	reg rdr;
	reg wrr;
	reg [15:0] wPA;
	reg clk;
	reg rst;

	// Outputs
	wire [15:0] out;

	// Instantiate the Unit Under Test (UUT)
	reg_bank uut (
		.PA(PA), 
		.rdr(rdr), 
		.wrr(wrr), 
		.wPA(wPA), 
		.clk(clk), 
		.rst(rst), 
		.out(out)
	);
	
	
	always
	begin #5
	clk=~clk;
	end

	initial begin
		// Initialize Inputs
		PA = 0;
		rdr = 0;
		wrr = 0;
		wPA = 0;
		clk = 0;
		rst = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		 

		
		PA = 3'b001;
		rdr=1;
		clk=1;
		wrr=1;
		wPA=16'b0000010000000100;
		
		clk=0;
		
		#20
		clk=1;
		wrr=0;
		rdr=0;
		
		#20
		clk=0;
		
		#20
		PA = 3'b010;
		rdr=1;
		clk=1;
		wrr=1;
		wPA=16'b0000010000000111;
		
		#20
		PA = 3'b001;
		wrr=0;
		rdr=1;
		clk=1;
		
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