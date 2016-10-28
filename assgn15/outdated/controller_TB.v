`timescale 1ns / 1ps

module test_control;

	//input 
	reg[4:0] state;
	reg[6:0] operationcode;
	
	//output 
	wire[4:0] next_state;
	wire wpc, rpc, rm, wmem, wmar, rmar, wmdr, rmdr;
	wire in_mdr1, in_mdr2, out_mdr1, out_mdr2, wir,  wReg, rReg,wt;
	wire rt, rc1, ldF;
	wire [1:0] inReg1, inReg2;
	wire [2:0] aluOp;

	wpc = 1'b0;
	rpc= 1'b0;
	rm= 1'b0;
	wmem= 1'b0; 
	wmar = 1'b0; 
	rmar= 1'b0; 
	wmdr= 1'b0; 
	rmdr= 1'b0;
	in_mdr1= 1'bz; 
	in_mdr2= 1'bz; 
	out_mdr1= 1'bz; 
	out_mdr2= 1'bz; 
	wir = 1'b0; 
	inReg = 2'b00;
	wReg= 1'b0; 
	rReg= 1'b0;
	wt= 1'b0; 
	rt= 1'b0; 
	rc1 = 1'b0; 
	aluOp = 3'b101;
	ldF = 1'b0;

	// Instantiate the Unit Under Test (UUT)
	controller controlBox(operationcode, wpc, rpc, rm, wmem, wmar, rmar, wmdr, rmdr, in_mdr1, 
	in_mdr2, out_mdr1, out_mdr2, wir, inReg, wReg,rReg,wt, rt, rc1, aluOp, ldF,
	state, next_state);	

	always
	begin #5
	clk=~clk;
	end

	initial begin
		// Initialize Inputs
		in_mdr1= 1'bz; in_mdr2= 1'bz; inReg = 2'b00;
		rpc= 1'b0; rm= 1'b0; rmar= 1'b0; rmdr= 1'b0; rReg= 1'b0; rt= 1'b0; rc1 = 1'b0; 
		wpc = 1'b0; wmem= 1'b0; wmar = 1'b0; wmdr= 1'b0; wir = 1'b0; wReg= 1'b0; wt= 1'b0; 
		out_mdr1= 1'bz; out_mdr2= 1'bz; 
		aluOp = 3'b101;
		ldF = 1'b0;
		clk = 0;


		// Wait 100 ns for global reset to finish
		#100;
		state = 5'b00001;
		operationCode = 6'b010001;
		in_mdr1= 1'b1; in_mdr2= 1'bz; inReg = 2'b00;
		rpc= 1'b1; rm= 1'b0; rmar= 1'b1; rmdr= 1'b0; rReg= 1'b1; rt= 1'b0; rc1 = 1'b0; 
		wpc = 1'b1; wmem= 1'b1; wmar = 1'b1; wmdr= 1'b0; wir = 1'b0; wReg= 1'b0; wt= 1'b0; 
		out_mdr1= 1'bz; out_mdr2= 1'bz; 
		aluOp = 3'b100;
		ldF = 1'b0;
		clk = 0;

		#100;
		state = 5'b000011;
		operationCode = 6'b000000;
		in_mdr1= 1'b1; in_mdr2= 1'bz; inReg = 2'b00;
		rpc= 1'b1; rm= 1'b0; rmar= 1'b1; rmdr= 1'b0; rReg= 1'b1; rt= 1'b0; rc1 = 1'b0; 
		wpc = 1'b1; wmem= 1'b1; wmar = 1'b1; wmdr= 1'b0; wir = 1'b1; wReg= 1'b0; wt= 1'b0; 
		out_mdr1= 1'bz; out_mdr2= 1'bz; 
		aluOp = 3'b010;
		ldF = 1'b0;
		clk = 0;

		#100;
		state = 00101;
		operationCode = 6'b010000;
		in_mdr1= 1'b1; in_mdr2= 1'bz; inReg = 2'b00;
		rpc= 1'b1; rm= 1'b0; rmar= 1'b1; rmdr= 1'b0; rReg= 1'b1; rt= 1'b0; rc1 = 1'b0; 
		wpc = 1'b1; wmem= 1'b1; wmar = 1'b1; wmdr= 1'b0; wir = 1'b1; wReg= 1'b0; wt= 1'b1; 
		out_mdr1= 1'bz; out_mdr2= 1'bz; 
		aluOp = 3'b010;
		ldF = 1'b1;
		clk = 0;

		#100;
		state = 00101;
		operationCode = 6'b100000;
		in_mdr1= 1'b1; in_mdr2= 1'bz; inReg = 2'b00;
		rpc= 1'b1; rm= 1'b0; rmar= 1'b1; rmdr= 1'b0; rReg= 1'b1; rt= 1'b0; rc1 = 1'b0; 
		wpc = 1'b1; wmem= 1'b1; wmar = 1'b1; wmdr= 1'b0; wir = 1'b1; wReg= 1'b0; wt= 1'b1; 
		out_mdr1= 1'bz; out_mdr2= 1'bz; 
		aluOp = 3'b011;
		ldF = 1'b1;
		clk = 0;

		#100;
		state = 01011;
		operationCode = 6'b000000;		
		in_mdr1= 1'b1; in_mdr2= 1'bz; inReg = 2'b00;
		rpc= 1'b0; rm= 1'b1; rmar= 1'b1; rmdr= 1'b0; rReg= 1'b1; rt= 1'b0; rc1 = 1'b0; 
		wpc = 1'b1; wmem= 1'b1; wmar = 1'b1; wmdr= 1'b1; wir = 1'b1; wReg= 1'b0; wt= 1'b1; 
		out_mdr1= 1'bz; out_mdr2= 1'bz; 
		aluOp = 3'b011;
		ldF = 1'b1;
		clk = 0;
	
		#100;
		state = 01011;
		operationCode = 6'b110000;	
		in_mdr1= 1'b1; in_mdr2= 1'bz; inReg = 2'b00;
		rpc= 1'b0; rm= 1'b1; rmar= 1'b1; rmdr= 1'b0; rReg= 1'b1; rt= 1'b0; rc1 = 1'b0; 
		wpc = 1'b1; wmem= 1'b1; wmar = 1'b1; wmdr= 1'b1; wir = 1'b1; wReg= 1'b0; wt= 1'b1; 
		out_mdr1= 1'b1; out_mdr2= 1'bz; 
		aluOp = 3'b101;
		ldF = 1'b1;
		clk = 0;

		#100;
		state = 01111;
		operationCode = 6'b000011;	
		in_mdr1= 1'b0; in_mdr2= 1'bz; inReg = 2'b10;
		rpc= 1'b0; rm= 1'b1; rmar= 1'b0; rmdr= 1'b1; rReg= 1'b1; rt= 1'b0; rc1 = 1'b0; 
		wpc = 1'b1; wmem= 1'b1; wmar = 1'b1; wmdr= 1'b1; wir = 1'b1; wReg= 1'b0; wt= 1'b1; 
		out_mdr1= 1'b1; out_mdr2= 1'bz; 
		aluOp = 3'b101;
		ldF = 1'b1;
		clk = 0;

		#100;
		state = 11110;
		operationCode = 6'b100101;	
		in_mdr1= 1'b0; in_mdr2= 1'bz; inReg = 2'b10;
		rpc= 1'b0; rm= 1'b0; rmar= 1'b0; rmdr= 1'b1; rReg= 1'b1; rt= 1'b0; rc1 = 1'b0; 
		wpc = 1'b0; wmem= 1'b1; wmar = 1'b0; wmdr= 1'b1; wir = 1'b1; wReg= 1'b0; wt= 1'b1; 
		out_mdr1= 1'b1; out_mdr2= 1'bz; 
		aluOp = 3'b100;
		ldF = 1'b1;
		clk = 0;

		#100;
		state = 11110;
		operationCode = 6'b100101;	
		in_mdr1= 1'b0; in_mdr2= 1'bz; inReg = 2'b10;
		rpc= 1'b0; rm= 1'b0; rmar= 1'b0; rmdr= 1'b0; rReg= 1'b0; rt= 1'b0; rc1 = 1'b0; 
		wpc = 1'b0; wmem= 1'b1; wmar = 1'b0; wmdr= 1'b1; wir = 1'b1; wReg= 1'b0; wt= 1'b1; 
		out_mdr1= 1'b1; out_mdr2= 1'bz; 
		aluOp = 3'b110;
		ldF = 1'b0;
		clk = 0;
	end

endmodule